<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = require_login();
    read_json_body(array_merge(read_json_body(), ['updated_by' => $u['id']]));
}

handle_resource_crud('hutang_overrides', ['nota_id', 'paid', 'status', 'updated_by'], 'nota_id');
