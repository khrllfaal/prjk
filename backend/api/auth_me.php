<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';
send_cors_headers();

$u = current_user();
json_response(['user' => $u]);
