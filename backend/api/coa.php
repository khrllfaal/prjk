<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('coa', ['id', 'kode', 'nama', 'level', 'tipe', 'saldo_awal']);
