<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';

// Never let an uncaught exception (bad DB creds, an invalid ENUM value,
// a duplicate-key race, etc.) reach the client as a raw PHP error page —
// on a misconfigured host that could leak the DSN, table names, or
// filesystem paths. Log the real error server-side and hand back a
// generic JSON 500 instead, so every response stays JSON and every
// endpoint's error handling in the frontend keeps working.
ini_set('display_errors', '0');
ini_set('log_errors', '1');

// Belt-and-suspenders alongside .htaccess's mod_deflate: some shared
// hosting plans restrict which Apache modules a .htaccess can enable,
// so compress at the PHP layer too. ob_gzhandler is a no-op if the
// client didn't send Accept-Encoding: gzip or zlib isn't available —
// safe to call unconditionally. The full transactions list is the
// biggest response here (over 1MB once a few months of real data is
// loaded) and compresses to well under a tenth of that.
if (extension_loaded('zlib') && !ini_get('zlib.output_compression')) {
    ob_start('ob_gzhandler');
}
set_exception_handler(function (Throwable $e): void {
    error_log('[accv2] Unhandled ' . get_class($e) . ': ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine());
    if (!headers_sent()) {
        http_response_code(500);
        header('Content-Type: application/json; charset=utf-8');
    }
    echo json_encode(['error' => 'Terjadi kesalahan pada server.']);
    exit;
});

function cfg(): array {
    static $cfg = null;
    if ($cfg === null) $cfg = require __DIR__ . '/config.php';
    return $cfg;
}

// Idle timeout: a session cookie with lifetime=>0 (below) lives until the
// browser closes, with nothing bounding how long it stays valid while the
// browser stays open — a shared/unattended computer would otherwise keep
// an accounting session logged in indefinitely. 12h covers a full
// work day without logging someone out mid-shift.
const SESSION_IDLE_TIMEOUT = 12 * 3600;

function start_session(): void {
    if (session_status() === PHP_SESSION_ACTIVE) return;
    // Plain $_SERVER['HTTPS'] isn't set when TLS is terminated by a
    // reverse proxy/load balancer in front of PHP (common on shared
    // hosting) — fall back to the standard forwarded-proto header so
    // the cookie still gets marked secure on a real HTTPS deploy.
    $isHttps = !empty($_SERVER['HTTPS']) || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https');
    // Frontend and API on the same domain (typical Hostinger deploy)
    // work fine with the default 'Lax'. Frontend hosted separately
    // (e.g. Netlify) needs 'None' — a cross-site fetch() never sends a
    // Lax cookie back, so login would silently "succeed" once and then
    // look logged-out on every next request. 'None' requires Secure, so
    // it's forced here rather than trusted blindly from config.
    $sameSite = (cfg()['cookie_samesite'] ?? 'Lax');
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'httponly' => true,
        'samesite' => $sameSite,
        'secure' => $isHttps || $sameSite === 'None',
    ]);
    session_name('accv2_session');
    session_start();

    if (isset($_SESSION['user'])) {
        if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity']) > SESSION_IDLE_TIMEOUT) {
            $_SESSION = [];
            session_regenerate_id(true);
        } else {
            $_SESSION['last_activity'] = time();
        }
    }
}

function send_cors_headers(): void {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if ($origin && in_array($origin, cfg()['cors_origins'], true)) {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type');
    }
    if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
        http_response_code(204);
        exit;
    }
}

function json_response($data, int $status = 200): void {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function json_error(string $message, int $status = 400): void {
    json_response(['error' => $message], $status);
}

/** php://input can only be read once, so the parsed body is cached.
 *  Pass $override to permanently replace the cache — used to inject
 *  server-trusted fields (e.g. created_by from the session) that the
 *  client must never be able to spoof via the request body itself. */
function read_json_body(?array $override = null): array {
    static $cached = null;
    if ($override !== null) return $cached = $override;
    if ($cached !== null) return $cached;
    $raw = file_get_contents('php://input');
    if ($raw === '' || $raw === false) return $cached = [];
    $data = json_decode($raw, true);
    if (!is_array($data)) json_error('Invalid JSON body', 400);
    return $cached = $data;
}

/** Returns the logged-in user's session row, or null. Never trusts the
 *  client for identity — always re-derived from the server-side session.
 *
 *  PHP's default file-based session handler holds an exclusive lock on
 *  the session file for as long as the session stays open — normally
 *  that means the whole rest of the request. Every endpoint here calls
 *  this (via require_login()) before doing any real work, so without
 *  closing the session back up immediately, concurrent requests from
 *  the SAME browser (e.g. the sync-status poll firing right after a
 *  save, or opening a form that loads several resources) queue up and
 *  wait for each other's lock instead of running in parallel — the
 *  "respon lambat sampai beberapa detik setelah simpan" symptom. Caching
 *  the result per-request and releasing the lock (session_write_close())
 *  right after the one real read fixes that: nothing after this point
 *  writes to $_SESSION, so there's nothing lost by closing it early. */
function current_user(): ?array {
    static $cached = null, $checked = false;
    if ($checked) return $cached;
    $checked = true;
    start_session();
    $cached = $_SESSION['user'] ?? null;
    session_write_close();
    return $cached;
}

function require_login(): array {
    $u = current_user();
    if (!$u) json_error('Belum login.', 401);
    return $u;
}

/**
 * Lightweight server-side validation for handle_resource_crud()'s POST
 * body, keyed by column name. Runs BEFORE the value ever reaches SQL —
 * every existing query already used prepared statements so this was
 * never an injection risk, but nothing previously stopped a buggy or
 * compromised client from sending a non-numeric `debet`, an
 * out-of-range `jenis`, or a string longer than the column, silently
 * corrupting a report instead of failing loudly. Rules are optional
 * per column (no rule = no check, so undeclared columns still pass
 * through unchanged) and deliberately don't force any field to be
 * non-empty beyond what the schema itself already requires — an
 * existing legitimate blank akun_lawan/project/relasi etc. must keep
 * working exactly as before.
 *
 * Rule shape: ['type' => 'string'|'number'|'date', 'max' => int,
 * 'enum' => [...], 'required' => bool]. Called once per field with the
 * raw incoming value; returns the (possibly type-coerced) value to
 * store, or calls json_error() and exits on a real violation.
 */
function validate_field(string $col, $value, array $rules): mixed {
    if (!isset($rules[$col])) return $value;
    $rule = $rules[$col];
    if ($value === null || $value === '') {
        if (!empty($rule['required']) && $value === null) json_error("$col wajib diisi", 422);
        return $value;
    }
    switch ($rule['type'] ?? 'string') {
        case 'number':
            if (!is_numeric($value)) json_error("$col harus berupa angka", 422);
            return $value + 0;
        case 'date':
            if (!is_string($value) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $value)) {
                json_error("$col harus format tanggal YYYY-MM-DD", 422);
            }
            return $value;
        case 'string':
        default:
            if (!is_string($value) && !is_numeric($value)) json_error("$col harus berupa teks", 422);
            $value = (string)$value;
            if (isset($rule['max']) && mb_strlen($value) > $rule['max']) {
                json_error("$col terlalu panjang (maksimal {$rule['max']} karakter)", 422);
            }
            if (isset($rule['enum']) && !in_array($value, $rule['enum'], true)) {
                json_error("$col tidak valid: $value", 422);
            }
            return $value;
    }
}

/**
 * The frontend computes a new transaction's Ref No (CO-2609-1119 style)
 * from its own in-memory copy of the transactions list — see
 * nextRefFor() in index.html. Two users adding a transaction within the
 * ~30s window before either save reflects back to the other's browser
 * can compute the exact same Ref No. Since `ref` is now a UNIQUE column
 * (schema.sql), the second insert would otherwise fail outright; this
 * bumps it to the next free sequence number for the same prefix instead,
 * so the save still succeeds — the caller must send the (possibly
 * different) `ref` this returns back to the client so its own copy of
 * the record stays correct (see the `ref` field in handle_resource_crud()'s
 * POST response, and syncUpsert() in data-sync.js).
 * Only touches `$ref` when it both matches the <PREFIX>-<YYMM>-<NNNN>
 * scheme AND is already used by a DIFFERENT row (an edit re-saving its
 * own unchanged ref, or a ref outside that scheme, passes through
 * untouched) — mirrors nextRefFor()'s own "max existing sequence + 1
 * for this prefix" logic exactly, so a renumbered ref still sorts in
 * with the rest of that prefix's history.
 */
function reserve_unique_ref(string $table, string $ref, string $excludeId): string {
    if (!preg_match('/^([A-Z]+)-(\d{4})-(\d+)$/', $ref, $m)) return $ref;
    [$full, $prefix, $month, ] = $m;
    $pdo = db();
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM `$table` WHERE ref = ? AND id <> ?");
    $stmt->execute([$ref, $excludeId]);
    if ((int)$stmt->fetchColumn() === 0) return $ref; // no conflict

    $stmt2 = $pdo->prepare("SELECT ref FROM `$table` WHERE ref LIKE ?");
    $stmt2->execute([$prefix . '-%']);
    $maxSeq = 0;
    foreach ($stmt2->fetchAll(PDO::FETCH_COLUMN) as $existingRef) {
        $lastDash = strrpos($existingRef, '-');
        if ($lastDash === false) continue;
        $seq = (int)substr($existingRef, $lastDash + 1);
        if ($seq > $maxSeq) $maxSeq = $seq;
    }
    return $prefix . '-' . $month . '-' . str_pad((string)($maxSeq + 1), 4, '0', STR_PAD_LEFT);
}

function audit(string $action, string $entity, string $entityId, string $detail = ''): void {
    $u = current_user();
    $stmt = db()->prepare(
        'INSERT INTO audit_log (user_id, user_email, action, entity, entity_id, detail, ip_address, user_agent) VALUES (?,?,?,?,?,?,?,?)'
    );
    $stmt->execute([
        $u['id'] ?? null, $u['email'] ?? null, $action, $entity, $entityId, $detail,
        $_SERVER['REMOTE_ADDR'] ?? null,
        substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 255) ?: null,
    ]);
}

// Per-IP login rate limit (see login_rate_limits in schema.sql) — a
// second, independent layer alongside users.failed_attempts/locked_until.
// That per-account lockout never trips on credential stuffing (many
// accounts, each tried just a few times from one IP), so this counts
// failures by REMOTE_ADDR regardless of which account was targeted.
// 20 fails within a rolling hour locks that IP for 30 minutes; the
// window itself resets after an hour of inactivity so one noisy IP
// (e.g. a shared office connection with ordinary typos) doesn't stay
// counted forever. Same REMOTE_ADDR convention as audit() above —
// deliberately not trusting X-Forwarded-For, which a client can send
// with any value unless the host's proxy is known to overwrite it.
const IP_RATE_LIMIT_MAX_ATTEMPTS = 20;
const IP_RATE_LIMIT_WINDOW = 3600;   // 1 hour
const IP_RATE_LIMIT_LOCKOUT = 1800;  // 30 minutes

function client_ip(): string {
    return $_SERVER['REMOTE_ADDR'] ?? 'unknown';
}

// Call before verifying a password/OTP. Returns null when not locked,
// or the lock's expiry (for the error message) when it is.
//
// Fails OPEN (treats it as "not locked") on any DB error, specifically
// including login_rate_limits not existing yet -- this table's own
// migration (add_login_rate_limit.sql) is a separate deploy step from
// the PHP files that reference it, so a brief window where the code is
// live but the migration hasn't run yet is expected, not exceptional.
// A security *enhancement* must never become the single point of
// failure that locks every legitimate user out of the whole app; the
// pre-existing per-account lockout (users.failed_attempts/locked_until)
// still protects login on its own either way.
function check_ip_lockout(): ?string {
    try {
        $stmt = db()->prepare('SELECT locked_until FROM login_rate_limits WHERE ip = ?');
        $stmt->execute([client_ip()]);
        $row = $stmt->fetch();
        if ($row && !empty($row['locked_until']) && strtotime($row['locked_until']) > time()) {
            return $row['locked_until'];
        }
        return null;
    } catch (Throwable $e) {
        error_log('[accv2] check_ip_lockout degraded (login_rate_limits missing?): ' . $e->getMessage());
        return null;
    }
}

// Call after a failed password/OTP check. Upserts this IP's row,
// starting a fresh window if the previous one is stale, and locks the
// IP once it crosses the threshold.
//
// Degrades silently (logs and returns) on any DB error -- see
// check_ip_lockout() above for why: the caller's own json_error() for
// the wrong password/OTP must still reach the user instead of a raw
// 500, even while login_rate_limits doesn't exist yet.
function record_ip_failure(): void {
    $ip = client_ip();
    $now = time();
    $pdo = db();
    try {
        $pdo->beginTransaction();
        $stmt = $pdo->prepare('SELECT * FROM login_rate_limits WHERE ip = ? FOR UPDATE');
        $stmt->execute([$ip]);
        $row = $stmt->fetch();

        if (!$row || ($now - strtotime($row['window_started'])) > IP_RATE_LIMIT_WINDOW) {
            $attempts = 1;
            $windowStarted = date('Y-m-d H:i:s', $now);
        } else {
            $attempts = (int)$row['attempts'] + 1;
            $windowStarted = $row['window_started'];
        }
        $lockUntil = $attempts >= IP_RATE_LIMIT_MAX_ATTEMPTS
            ? date('Y-m-d H:i:s', $now + IP_RATE_LIMIT_LOCKOUT) : null;

        $pdo->prepare(
            'INSERT INTO login_rate_limits (ip, attempts, window_started, locked_until) VALUES (?,?,?,?)
             ON DUPLICATE KEY UPDATE attempts = VALUES(attempts), window_started = VALUES(window_started), locked_until = VALUES(locked_until)'
        )->execute([$ip, $attempts, $windowStarted, $lockUntil]);

        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        error_log('[accv2] record_ip_failure degraded (login_rate_limits missing?): ' . $e->getMessage());
    }
}

// Call after a successful password/OTP check — the IP just proved it's
// (at least partly) a legitimate user, so don't let unrelated past
// failures from the same shared IP lock out the next person. Degrades
// silently for the same reason as the two functions above: a
// successful login must never fail because of this table.
function clear_ip_failures(): void {
    try {
        db()->prepare('DELETE FROM login_rate_limits WHERE ip = ?')->execute([client_ip()]);
    } catch (Throwable $e) {
        error_log('[accv2] clear_ip_failures degraded (login_rate_limits missing?): ' . $e->getMessage());
    }
}
