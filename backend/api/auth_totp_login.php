<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';
require_once __DIR__ . '/totp.php';
send_cors_headers();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') json_error('Method not allowed', 405);

start_session();

$userId = $_SESSION['pending_totp_user_id'] ?? null;
$pendingAt = $_SESSION['pending_totp_at'] ?? 0;
// 5 minutes to enter the code before having to log in again from
// scratch — a half-authenticated session sitting open indefinitely
// would itself be a weak point.
if (!$userId || (time() - (int)$pendingAt) > 300) {
    unset($_SESSION['pending_totp_user_id'], $_SESSION['pending_totp_at']);
    json_error('Sesi login kedaluwarsa, silakan login ulang.', 401);
}

$body = read_json_body();
$code = (string)($body['code'] ?? '');

$stmt = db()->prepare('SELECT * FROM users WHERE id = ?');
$stmt->execute([$userId]);
$user = $stmt->fetch();

if (!$user || (int)$user['totp_enabled'] !== 1 || !$user['totp_secret']) {
    unset($_SESSION['pending_totp_user_id'], $_SESSION['pending_totp_at']);
    json_error('Sesi login tidak valid, silakan login ulang.', 401);
}

// Same lockout columns/threshold as the password step — a 6-digit code
// is brute-forceable without this (1 in a million per guess, but cheap
// to script many guesses inside one 30s window otherwise).
if (!empty($user['locked_until']) && strtotime($user['locked_until']) > time()) {
    json_error('Akun terkunci sementara karena terlalu banyak percobaan gagal. Coba lagi beberapa menit lagi.', 429);
}

if (!totp_verify($user['totp_secret'], $code)) {
    $attempts = (int)$user['failed_attempts'] + 1;
    $lockUntil = $attempts >= 5 ? date('Y-m-d H:i:s', time() + 15 * 60) : null;
    db()->prepare('UPDATE users SET failed_attempts = ?, locked_until = ? WHERE id = ?')
        ->execute([$attempts, $lockUntil, $user['id']]);
    json_error('Kode OTP salah.', 401);
}

db()->prepare('UPDATE users SET failed_attempts = 0, locked_until = NULL WHERE id = ?')->execute([$user['id']]);
unset($_SESSION['pending_totp_user_id'], $_SESSION['pending_totp_at']);
session_regenerate_id(true);
$_SESSION['user'] = ['id' => $user['id'], 'email' => $user['email'], 'nama' => $user['nama'], 'role' => $user['role']];

json_response(['user' => $_SESSION['user'] + ['totpEnabled' => true]]);
