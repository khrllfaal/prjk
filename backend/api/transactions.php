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
], 'id', ['created_by']);
