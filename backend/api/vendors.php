<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('vendors', ['id', 'kode', 'nama', 'alamat', 'telp', 'email'], 'id', [], [
    'id' => ['type' => 'string', 'max' => 40, 'required' => true],
    'kode' => ['type' => 'string', 'max' => 40],
    'nama' => ['type' => 'string', 'max' => 255],
    'alamat' => ['type' => 'string', 'max' => 500],
    'telp' => ['type' => 'string', 'max' => 60],
    'email' => ['type' => 'string', 'max' => 190],
]);
