<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('customers', ['id', 'kode', 'nama', 'alamat', 'telp', 'email']);
