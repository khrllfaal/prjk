<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = require_login();
    read_json_body(array_merge(read_json_body(), ['created_by' => $u['id']]));
}

handle_resource_crud('jurnal_umum', [
    'id', 'tgl', 'ref', 'akun', 'project', 'relasi', 'kategori', 'ket', 'debet', 'kredit', 'created_by',
], 'id', ['created_by']);
