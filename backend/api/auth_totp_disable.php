<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';
send_cors_headers();
$me = require_login();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') json_error('Method not allowed', 405);

// Requires the current password again, not just an active session —
// turning off 2FA is exactly the kind of action a hijacked session
// (stolen cookie, shared/unlocked computer) would try first, so it
// shouldn't be a single click away.
$body = read_json_body();
$password = (string)($body['password'] ?? '');

$stmt = db()->prepare('SELECT password_hash FROM users WHERE id = ?');
$stmt->execute([$me['id']]);
$hash = $stmt->fetchColumn();

if (!$hash || !password_verify($password, $hash)) json_error('Password salah.', 401);

db()->prepare('UPDATE users SET totp_enabled = 0, totp_secret = NULL WHERE id = ?')->execute([$me['id']]);
audit('update', 'users', $me['id'], '2FA dinonaktifkan');

json_response(['ok' => true]);
