<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('coa', ['id', 'kode', 'nama', 'level', 'tipe', 'saldo_awal'], 'id', [], [
    'id' => ['type' => 'string', 'max' => 40, 'required' => true],
    'kode' => ['type' => 'string', 'max' => 40],
    'nama' => ['type' => 'string', 'max' => 255],
    'level' => ['type' => 'number'],
    'tipe' => ['type' => 'string', 'max' => 20],
    'saldo_awal' => ['type' => 'number'],
]);
