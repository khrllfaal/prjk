<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = require_login();
    read_json_body(array_merge(read_json_body(), ['created_by' => $u['id']]));
}

handle_resource_crud('jurnal_umum', [
    'id', 'tgl', 'ref', 'akun', 'project', 'relasi', 'kategori', 'no_faktur', 'status', 'ket', 'debet', 'kredit', 'created_by',
], 'id', ['created_by'], [
    'id' => ['type' => 'string', 'max' => 40, 'required' => true],
    'tgl' => ['type' => 'date'],
    'ref' => ['type' => 'string', 'max' => 40],
    'akun' => ['type' => 'string', 'max' => 255],
    'project' => ['type' => 'string', 'max' => 255],
    'relasi' => ['type' => 'string', 'max' => 255],
    'kategori' => ['type' => 'string', 'max' => 120],
    'no_faktur' => ['type' => 'string', 'max' => 80],
    'status' => ['type' => 'string', 'max' => 10],
    'ket' => ['type' => 'string', 'max' => 5000],
    'debet' => ['type' => 'number'],
    'kredit' => ['type' => 'number'],
]);
