<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('vendors', ['id', 'kode', 'nama', 'alamat', 'telp', 'email']);
