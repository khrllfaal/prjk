<?php
declare(strict_types=1);
require_once __DIR__ . '/db.php';

function cfg(): array {
    static $cfg = null;
    if ($cfg === null) $cfg = require __DIR__ . '/config.php';
    return $cfg;
}

function start_session(): void {
    if (session_status() === PHP_SESSION_ACTIVE) return;
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'httponly' => true,
        'samesite' => 'Lax',
        // 'secure' is left off in local dev (plain http); a production
        // deploy behind HTTPS should force this true (see index.php).
        'secure' => !empty($_SERVER['HTTPS']),
    ]);
    session_name('accv2_session');
    session_start();
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
 *  client for identity — always re-derived from the server-side session. */
function current_user(): ?array {
    start_session();
    return $_SESSION['user'] ?? null;
}

function require_login(): array {
    $u = current_user();
    if (!$u) json_error('Belum login.', 401);
    return $u;
}

function audit(string $action, string $entity, string $entityId, string $detail = ''): void {
    $u = current_user();
    $stmt = db()->prepare(
        'INSERT INTO audit_log (user_id, user_email, action, entity, entity_id, detail) VALUES (?,?,?,?,?,?)'
    );
    $stmt->execute([$u['id'] ?? null, $u['email'] ?? null, $action, $entity, $entityId, $detail]);
}
