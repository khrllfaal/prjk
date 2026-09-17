<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';

/**
 * Cheap "has anything changed" check for the frontend's background
 * poll (see pollForRemoteChanges() in auth.js) — a small aggregate
 * query per table (all index-friendly: PRIMARY KEY for COUNT(*), and
 * every table's updated_at is the same column the ON UPDATE trigger
 * already maintains), nowhere near the cost of fetchAllData()'s full
 * row dump. The frontend compares the returned signature against the
 * last one it saw; a different signature is the only reason it does a
 * real (expensive) refetch.
 */
send_cors_headers();
require_login();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    json_error('Method not allowed', 405);
}

$tables = ['customers', 'vendors', 'projects', 'coa', 'transactions', 'jurnal_umum'];
$counts = [];
$maxUpdated = null;
foreach ($tables as $t) {
    $row = db()->query("SELECT COUNT(*) AS cnt, MAX(updated_at) AS max_updated FROM `$t`")->fetch();
    $counts[$t] = (int)$row['cnt'];
    if ($row['max_updated'] !== null && ($maxUpdated === null || $row['max_updated'] > $maxUpdated)) {
        $maxUpdated = $row['max_updated'];
    }
}
// hutang_overrides has no id-based count the frontend tracks per row,
// but its own updated_at still needs to fold into the signature so a
// Trial Hutang "Bayar"/manual-correction from another device is caught.
$ho = db()->query("SELECT COUNT(*) AS cnt, MAX(updated_at) AS max_updated FROM `hutang_overrides`")->fetch();
$counts['hutang_overrides'] = (int)$ho['cnt'];
if ($ho['max_updated'] !== null && ($maxUpdated === null || $ho['max_updated'] > $maxUpdated)) {
    $maxUpdated = $ho['max_updated'];
}

json_response([
    'signature' => md5($maxUpdated . '|' . json_encode($counts)),
]);
