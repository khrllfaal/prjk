<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';
require_once __DIR__ . '/totp.php';
send_cors_headers();
$me = require_login();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') json_error('Method not allowed', 405);

// Generates a fresh secret and stores it, but leaves totp_enabled at 0
// until auth_totp_enable.php confirms a real code against it — so
// starting setup (or abandoning it mid-way) never locks the account
// out or silently turns 2FA on without the user actually finishing
// scanning the QR code.
$secret = totp_generate_secret();
db()->prepare('UPDATE users SET totp_secret = ?, totp_enabled = 0 WHERE id = ?')->execute([$secret, $me['id']]);

json_response([
    'secret' => $secret,
    'otpauth_uri' => totp_provisioning_uri($secret, $me['email']),
]);
