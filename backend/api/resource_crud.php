<?php
declare(strict_types=1);
require_once __DIR__ . '/helpers.php';

/**
 * Generic list/upsert/delete handler shared by every simple resource
 * (customers, vendors, projects, coa, transactions, jurnal_umum).
 * Mirrors the frontend's syncUpsert()/syncDelete() contract: POST
 * always upserts (insert-or-update) by primary key, matching how the
 * app already treats every save. Every write is logged to audit_log.
 *
 * $columns: whitelist of writable columns (id must be included).
 * $idColumn: primary key column name, default 'id'.
 * $insertOnlyColumns: columns (e.g. created_by) written on first
 * insert but never overwritten by a later upsert-as-update.
 */
function handle_resource_crud(string $table, array $columns, string $idColumn = 'id', array $insertOnlyColumns = []): void {
    // CORS (and the OPTIONS preflight short-circuit) must run before any
    // auth check — a preflight request never carries credentials, so
    // require_login() would 401 it before the browser ever got to see
    // the CORS headers, and silently block the real request that follows.
    send_cors_headers();
    require_login();
    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $rows = db()->query("SELECT * FROM `$table` ORDER BY `$idColumn`")->fetchAll();
        json_response($rows);
        return;
    }

    if ($method === 'POST') {
        $body = read_json_body();
        $data = [];
        foreach ($columns as $col) {
            if (array_key_exists($col, $body)) $data[$col] = $body[$col];
        }
        if (empty($data[$idColumn])) json_error('id wajib diisi', 422);

        $cols = array_keys($data);
        $placeholders = implode(',', array_fill(0, count($cols), '?'));
        $colList = implode(',', array_map(fn($c) => "`$c`", $cols));
        $updateCols = array_filter($cols, fn($c) => $c !== $idColumn && !in_array($c, $insertOnlyColumns, true));
        $updateList = implode(',', array_map(fn($c) => "`$c`=VALUES(`$c`)", $updateCols));
        $sql = "INSERT INTO `$table` ($colList) VALUES ($placeholders)"
             . ($updateList ? " ON DUPLICATE KEY UPDATE $updateList" : '');
        $stmt = db()->prepare($sql);
        $stmt->execute(array_values($data));

        audit('update', $table, (string)$data[$idColumn]);
        json_response(['ok' => true, 'id' => $data[$idColumn]]);
        return;
    }

    if ($method === 'DELETE') {
        $id = $_GET['id'] ?? '';
        if ($id === '') json_error('id wajib diisi', 422);
        $stmt = db()->prepare("DELETE FROM `$table` WHERE `$idColumn` = ?");
        $stmt->execute([$id]);
        audit('delete', $table, (string)$id);
        json_response(['ok' => true]);
        return;
    }

    json_error('Method not allowed', 405);
}
