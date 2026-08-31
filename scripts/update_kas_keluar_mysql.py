#!/usr/bin/env python3
"""
Replace ONLY the kas_keluar (cash out) rows in `transactions` with a
fresh Cash Out Report file, leaving kas_masuk/bank_masuk/bank_keluar
and every other table completely untouched.

Existing Project links are preserved: a transaction's `project` text is
matched case-insensitively against existing projects.nama/ledger_name
first, and only a genuinely new project name gets a new stub row (same
auto-link behavior as import_html_reports_mysql.py) — so previously
linked projects keep exactly the same relationship.

Usage:
    export MYSQL_HOST=127.0.0.1 MYSQL_DB=accv2 MYSQL_USER=accv2_user MYSQL_PASS=...
    python3 scripts/update_kas_keluar_mysql.py --dry-run cash_out_Report_8.xls
"""
import argparse
import os
import re
import sys

sys.path.insert(0, os.path.dirname(__file__))
from import_html_reports_mysql import parse_report


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file', help='cash out report .xls (HTML)')
    ap.add_argument('--dry-run', action='store_true')
    args = ap.parse_args()

    jenis, txns = parse_report(args.file)
    if jenis != 'kas_keluar':
        print(f"ERROR: file ini terdeteksi sebagai '{jenis}', bukan kas_keluar.", file=sys.stderr)
        sys.exit(1)

    projects_referenced = sorted({t['project'] for t in txns if t['project']})
    total_kredit = sum(t['kredit'] for t in txns)
    print(f"Kas Keluar baru: {len(txns)} baris, total {total_kredit:,.0f}")
    print(f"Project yang direferensikan ({len(projects_referenced)}): {', '.join(projects_referenced)}")

    if args.dry_run:
        print("\n--dry-run: tidak ada yang ditulis ke database.")
        return

    host = os.environ.get('MYSQL_HOST')
    db = os.environ.get('MYSQL_DB')
    user = os.environ.get('MYSQL_USER')
    password = os.environ.get('MYSQL_PASS')
    if not all([host, db, user]):
        print("\nERROR: set MYSQL_HOST, MYSQL_DB, MYSQL_USER, MYSQL_PASS env vars.", file=sys.stderr)
        sys.exit(1)

    import pymysql
    conn = pymysql.connect(host=host, user=user, password=password or '', database=db,
                            charset='utf8mb4', autocommit=False)
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id, nama, ledger_name FROM projects")
            existing = cur.fetchall()
            known_names = set()
            for _id, nama, ledger_name in existing:
                if nama: known_names.add(nama.strip().lower())
                if ledger_name: known_names.add(ledger_name.strip().lower())
            max_pid = 0
            for _id, *_ in existing:
                m = re.match(r'^p(\d+)$', _id or '')
                if m: max_pid = max(max_pid, int(m.group(1)))

            new_projects = []
            for name in projects_referenced:
                if name.strip().lower() not in known_names:
                    max_pid += 1
                    new_projects.append((f'p{max_pid}', name, name))
                    known_names.add(name.strip().lower())

            if new_projects:
                cur.executemany(
                    "INSERT INTO projects (id, nama, ledger_name, kontrak, rap, pemberi_proyek, cost_center, adm_fee) "
                    "VALUES (%s, %s, %s, 0, 0, '', 0, 0)",
                    new_projects)
                print(f"\nProject baru dibuat otomatis ({len(new_projects)}): " +
                      ', '.join(p[1] for p in new_projects))
            else:
                print("\nTidak ada project baru — semua nama project sudah tertaut ke Master Project yang ada.")

            cur.execute("SELECT id FROM transactions")
            max_tid = 0
            for (tid,) in cur.fetchall():
                m = re.match(r'^t(\d+)$', tid or '')
                if m: max_tid = max(max_tid, int(m.group(1)))

            cur.execute("DELETE FROM transactions WHERE jenis='kas_keluar'")
            deleted = cur.rowcount
            print(f"\n{deleted} baris kas_keluar lama dihapus (kas_masuk/bank_masuk/bank_keluar tidak disentuh).")

            rows = [
                (f't{max_tid + i + 1}', t['jenis'], t['tgl'], t['ref'], t['akun_kas'], t['akun_lawan'],
                 t['project'], '', None, None, t['ket'], t['debet'], t['kredit'], None)
                for i, t in enumerate(txns)
            ]
            cur.executemany(
                "INSERT INTO transactions "
                "(id, jenis, tgl, ref, akun_kas, akun_lawan, project, relasi, customer_id, vendor_id, ket, debet, kredit, created_by) "
                "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
                rows)
        conn.commit()
        print(f"\nUpdate selesai: {len(txns)} baris kas_keluar baru dimuat, sudah di-commit ke database.")
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


if __name__ == '__main__':
    main()
