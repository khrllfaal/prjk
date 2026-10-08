<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';
send_cors_headers();

$u = current_user();
if ($u) {
    $stmt = db()->prepare('SELECT totp_enabled FROM users WHERE id = ?');
    $stmt->execute([$u['id']]);
    $u['totpEnabled'] = (bool)$stmt->fetchColumn();
}
json_response(['user' => $u]);
