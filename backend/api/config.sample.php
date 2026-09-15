<?php
/**
 * Copy this file to config.php and fill in your real values.
 * config.php is gitignored — never commit real database credentials.
 */
return [
    'db_host' => '127.0.0.1',
    'db_name' => 'accv',
    'db_user' => 'accv_user',
    'db_pass' => 'CHANGE-ME',
    // Origins allowed to call this API when the frontend is NOT served
    // from the same domain (e.g. local dev, or frontend on Netlify with
    // this backend on Hostinger). Leave empty when frontend + API share
    // one domain — same-origin requests don't need CORS at all.
    'cors_origins' => [],
    // 'Lax' (default) — fine when frontend + API share one domain.
    // Set to 'None' when the frontend is hosted separately (e.g.
    // Netlify) and cors_origins above is filled in — a cross-site
    // fetch() never sends a 'Lax' cookie back, so login would otherwise
    // silently "succeed" once and then look logged-out on every next
    // request. 'None' only works over HTTPS (enforced automatically).
    'cookie_samesite' => 'Lax',

    // Where bin/backup_db.php writes its .sql.gz dumps. On Hostinger,
    // point this OUTSIDE public_html (e.g. one level up) so backups are
    // never reachable over HTTP — see docs/DEPLOY_HOSTINGER.md.
    'backup_dir' => __DIR__ . '/../backups',
    // Dumps older than this are deleted each time the backup script runs.
    'backup_retention_days' => 14,
];
