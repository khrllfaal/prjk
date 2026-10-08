<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';
require_once __DIR__ . '/totp.php';
send_cors_headers();
$me = require_login();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') json_error('Method not allowed', 405);

$body = read_json_body();
$code = (string)($body['code'] ?? '');

$stmt = db()->prepare('SELECT totp_secret FROM users WHERE id = ?');
$stmt->execute([$me['id']]);
$secret = $stmt->fetchColumn();

if (!$secret) json_error('Belum ada setup 2FA yang berjalan — mulai dari auth_totp_setup.php dulu.', 400);
if (!totp_verify($secret, $code)) json_error('Kode OTP salah. Pastikan jam di HP Anda akurat lalu coba lagi.', 401);

db()->prepare('UPDATE users SET totp_enabled = 1 WHERE id = ?')->execute([$me['id']]);
audit('update', 'users', $me['id'], '2FA diaktifkan');

json_response(['ok' => true]);
