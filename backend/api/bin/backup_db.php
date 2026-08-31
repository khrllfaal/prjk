<?php
declare(strict_types=1);
/**
 * Dumps every table (schema + data) to a timestamped, gzip-compressed
 * .sql.gz file, then deletes dumps older than backup_retention_days.
 * Pure PHP/PDO — no dependency on the mysqldump binary or shell_exec()
 * being enabled, since shared hosting often disables both.
 *
 * Usage (CLI only — refuses to run over HTTP):
 *   php backup_db.php
 *   php backup_db.php --exclude=users
 *
 * On Hostinger, schedule this from hPanel -> Advanced -> Cron Job as a
 * daily command, e.g.:
 *   php /home/USERNAME/domains/yourdomain.com/backend/api/bin/backup_db.php
 * See docs/DEPLOY_HOSTINGER.md for the full walkthrough, including why
 * `backup_dir` in config.php must point outside public_html.
 *
 * --exclude=table1,table2 skips those tables entirely (no DROP/CREATE/
 * INSERT for them) — use this for a dump that's meant to hand off a
 * data update (e.g. a corrected report import) without also
 * overwriting the target database's real `users` table and its
 * accounts/passwords. Excluding `users` is safe even though
 * hutang_overrides has a foreign key to it: that FK is only checked
 * against whatever `users` table already exists on the restore
 * target, which this flag deliberately leaves untouched.
 */
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    die('This script only runs from the command line.');
}

require_once __DIR__ . '/../helpers.php';

const ROWS_PER_INSERT = 500;

function quote_ident(string $name): string {
    return '`' . str_replace('`', '``', $name) . '`';
}

/** Renders one PHP value as a literal for an INSERT statement, without
 *  relying on PDO::quote() (some drivers can't quote outside a live
 *  query) — safe here because every value originates from our own DB,
 *  never from user input at dump time. */
function sql_literal($v): string {
    if ($v === null) return 'NULL';
    if (is_int($v) || is_float($v)) return (string)$v;
    return "'" . str_replace(["\\", "'"], ["\\\\", "\\'"], (string)$v) . "'";
}

function dump_table(PDO $pdo, $out, string $table): int {
    $q = quote_ident($table);
    fwrite($out, "\n-- ---- $table ----\n");
    fwrite($out, "DROP TABLE IF EXISTS $q;\n");
    $createRow = $pdo->query("SHOW CREATE TABLE $q")->fetch(PDO::FETCH_NUM);
    fwrite($out, $createRow[1] . ";\n");

    $rowCount = 0;
    $stmt = $pdo->query("SELECT * FROM $q");
    $cols = null;
    $batch = [];
    $flush = function () use (&$batch, $out, $q, &$cols) {
        if (!$batch) return;
        $colList = implode(',', array_map('quote_ident', $cols));
        $rows = array_map(function ($row) {
            return '(' . implode(',', array_map('sql_literal', $row)) . ')';
        }, $batch);
        fwrite($out, "INSERT INTO $q ($colList) VALUES\n" . implode(",\n", $rows) . ";\n");
        $batch = [];
    };
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        if ($cols === null) $cols = array_keys($row);
        $batch[] = array_values($row);
        $rowCount++;
        if (count($batch) >= ROWS_PER_INSERT) $flush();
    }
    $flush();
    return $rowCount;
}

$backupDir = rtrim(cfg()['backup_dir'], '/');
$retentionDays = (int)cfg()['backup_retention_days'];

if (!is_dir($backupDir) && !mkdir($backupDir, 0750, true) && !is_dir($backupDir)) {
    fwrite(STDERR, "ERROR: could not create backup_dir '$backupDir'.\n");
    exit(1);
}

$pdo = db();
// SET FOREIGN_KEY_CHECKS=0 (below) only suppresses FK checks on DML
// (INSERT/UPDATE/DELETE) — MySQL still refuses to CREATE TABLE with a
// foreign key pointing at a table that doesn't exist yet, regardless
// of that flag. SHOW TABLES returns alphabetical order, which puts
// hutang_overrides (FK -> jurnal_umum, users) before either of them,
// so a restore into a fresh/empty database would fail with errno 150
// on CREATE TABLE. Dump in the same dependency order schema.sql
// creates them in instead, then append anything not in that list
// (future tables) so a schema change can't silently go undumped.
$knownOrder = ['users', 'customers', 'vendors', 'projects', 'coa',
    'transactions', 'jurnal_umum', 'hutang_overrides', 'audit_log'];
$existing = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
$tables = array_values(array_intersect($knownOrder, $existing));
$tables = array_merge($tables, array_diff($existing, $tables));

$exclude = [];
foreach ($argv as $arg) {
    if (preg_match('/^--exclude=(.+)$/', $arg, $m)) {
        $exclude = array_map('trim', explode(',', $m[1]));
    }
}
if ($exclude) {
    $tables = array_values(array_diff($tables, $exclude));
}

$filename = 'backup-' . date('Ymd-His') . '.sql.gz';
$path = "$backupDir/$filename";
$gz = gzopen($path, 'wb9');
if ($gz === false) {
    fwrite(STDERR, "ERROR: could not open '$path' for writing.\n");
    exit(1);
}

gzwrite($gz, "-- ACCv2 MySQL backup — " . date('c') . "\n");
// sql_literal() below escapes a quote/backslash the standard MySQL way
// (backslash-escaped) — that only works while NO_BACKSLASH_ESCAPES is
// off. A restore target's own default sql_mode can differ from this
// dump's source server (common between a Linux dev box and a Windows
// XAMPP/MariaDB install), which would silently corrupt any INSERT
// containing a quote or backslash and abort the import. Pin sql_mode
// for the duration of this restore so escaping behaves the same
// regardless of the target's global default.
gzwrite($gz, "SET NAMES utf8mb4;\nSET SESSION sql_mode='';\nSET FOREIGN_KEY_CHECKS=0;\n");

$totalRows = 0;
foreach ($tables as $table) {
    $totalRows += dump_table($pdo, $gz, $table);
}
gzwrite($gz, "\nSET FOREIGN_KEY_CHECKS=1;\n");
gzclose($gz);

$sizeKb = round(filesize($path) / 1024, 1);
echo "OK — wrote $filename (" . count($tables) . " tables, $totalRows rows, {$sizeKb} KB)\n";

// --- retention: delete dumps older than $retentionDays ---
$cutoff = time() - $retentionDays * 86400;
$deleted = 0;
foreach (glob("$backupDir/backup-*.sql.gz") ?: [] as $old) {
    if (filemtime($old) < $cutoff) {
        unlink($old);
        $deleted++;
    }
}
if ($deleted > 0) echo "Removed $deleted backup(s) older than $retentionDays day(s).\n";
