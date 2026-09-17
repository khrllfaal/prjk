<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('projects', [
    'id', 'nama', 'ledger_name', 'kontrak', 'rap', 'progress', 'pemberi_proyek', 'cost_center', 'adm_fee',
], 'id', [], [
    'id' => ['type' => 'string', 'max' => 40, 'required' => true],
    'nama' => ['type' => 'string', 'max' => 255],
    'ledger_name' => ['type' => 'string', 'max' => 255],
    'kontrak' => ['type' => 'number'],
    'rap' => ['type' => 'number'],
    'progress' => ['type' => 'number'],
    'pemberi_proyek' => ['type' => 'string', 'max' => 120],
    'cost_center' => ['type' => 'number'],
    'adm_fee' => ['type' => 'number'],
]);
