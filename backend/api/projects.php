<?php
declare(strict_types=1);
require_once __DIR__ . '/resource_crud.php';
handle_resource_crud('projects', [
    'id', 'nama', 'ledger_name', 'kontrak', 'rap', 'progress', 'pemberi_proyek', 'cost_center', 'adm_fee',
]);
