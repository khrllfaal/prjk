<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';

// created_by must come from the session, never from the client —
// inject it before the generic handler reads the body. Also resolve a
// Ref No collision from two users saving within the same sync window
// before it can ever hit the ref UNIQUE constraint — see
// reserve_unique_ref() in helpers.php.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = require_login();
    $body = read_json_body();
    if (!empty($body['ref']) && !empty($body['id'])) {
        $body['ref'] = reserve_unique_ref('transactions', $body['ref'], $body['id']);
    }
    read_json_body(array_merge($body, ['created_by' => $u['id']]));
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
