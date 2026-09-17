<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';

// created_by must come from the session, never from the client —
// inject it before the generic handler reads the body.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = require_login();
    read_json_body(array_merge(read_json_body(), ['created_by' => $u['id']]));
}

handle_resource_crud('transactions', [
    'id', 'jenis', 'tgl', 'ref', 'akun_kas', 'akun_lawan', 'project', 'relasi',
    'customer_id', 'vendor_id', 'ket', 'debet', 'kredit', 'created_by',
], 'id', ['created_by'], [
    'id' => ['type' => 'string', 'max' => 40, 'required' => true],
    'jenis' => ['type' => 'string', 'enum' => ['kas_masuk', 'kas_keluar', 'bank_masuk', 'bank_keluar']],
    'tgl' => ['type' => 'date'],
    'ref' => ['type' => 'string', 'max' => 40],
    'akun_kas' => ['type' => 'string', 'max' => 255],
    'akun_lawan' => ['type' => 'string', 'max' => 255],
    'project' => ['type' => 'string', 'max' => 255],
    'relasi' => ['type' => 'string', 'max' => 255],
    'customer_id' => ['type' => 'string', 'max' => 40],
    'vendor_id' => ['type' => 'string', 'max' => 40],
    'ket' => ['type' => 'string', 'max' => 5000],
    'debet' => ['type' => 'number'],
    'kredit' => ['type' => 'number'],
]);
