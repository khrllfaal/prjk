#!/usr/bin/env python3
"""
Import Kas/Bank In/Out "Report" files exported as .xls but actually
HTML tables (a common export format from Indonesian accounting
software) into the MySQL database from backend/mysql/schema.sql.

Expects up to 4 files, each with header row:
  No | Date | Ref No | Bank        | Akun Lawan | Project | Amount | Description   (bank in/out)
  No | Date | Ref No | Akun Kas    | Akun Lawan | Project | Amount | Description   (cash in/out)

Which file is which "jenis" (kas_masuk/kas_keluar/bank_masuk/
bank_keluar) is auto-detected from the report title inside the file
("CASH IN REPORT", "BANK OUT REPORT", etc.) — no need to pass jenis
per file on the command line.

This REPLACES the entire `transactions` table (kas/bank masuk/keluar)
with what's in these files — use this to load a fresh period's data
after clearing out an old one. It does NOT touch customers, vendors,
coa, jurnal_umum, or hutang_overrides — those aren't covered by these
report files and are left exactly as they are.

Ref numbers are imported verbatim from the files (they're already
real historical nota numbers from the company's own system) — the
app's own auto-numbering (nextRefFor in frontend/index.html) only
ever looks at the max existing sequence per CI/CO/BI/BO prefix, not
the month embedded in the ref string, so this is always safe even
when a ref's embedded month doesn't match its transaction date (entry
lag in the source system — common and expected).

Any Project name referenced by a transaction that doesn't already
match an existing project (by nama or ledger_name) gets a new minimal
Master Project row created automatically (kontrak/rap/cost_center/
adm_fee = 0) so Dashboard linking works immediately; edit/rename it
via Master Project in the app afterwards as needed.

Usage:
    export MYSQL_HOST=127.0.0.1 MYSQL_DB=accv2 MYSQL_USER=accv2_user MYSQL_PASS=...
    python3 scripts/import_html_reports_mysql.py --dry-run \
        bank_in_Report.xls bank_out_Report.xls cash_in_Report.xls cash_out_Report.xls
    # kalau ringkasannya masuk akal, jalankan sungguhan (hapus --dry-run)
"""
import argparse
import os
import re
import sys
from html.parser import HTMLParser


class ReportParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.title = None
        self.header = None
        self.rows = []
        self.cur_row = None
        self.cur_cell = None
        self.in_data_table = False
        self.table_depth = 0
        self._text_buf = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'table':
            self.table_depth += 1
            if attrs.get('border') == '1':
                self.in_data_table = True
        elif tag == 'tr' and self.in_data_table:
            self.cur_row = []
        elif tag in ('td', 'th') and self.cur_row is not None:
            self.cur_cell = []
        elif tag == 'b' and self.title is None:
            # Reset right before the title's bold tag so stray text seen
            # earlier (company name, address) never gets swept into it.
            self._text_buf = []

    def handle_endtag(self, tag):
        if tag == 'table':
            if self.table_depth == 1:
                self.in_data_table = False
            self.table_depth -= 1
        elif tag == 'tr' and self.cur_row is not None:
            row = [c.strip() for c in self.cur_row]
            if self.header is None and ('No' in row and 'Date' in row):
                self.header = row
            else:
                self.rows.append(row)
            self.cur_row = None
        elif tag in ('td', 'th') and self.cur_cell is not None:
            self.cur_row.append(''.join(self.cur_cell))
            self.cur_cell = None
        elif tag == 'b' and self.title is None and self._text_buf:
            joined = ''.join(self._text_buf).strip()
            if 'REPORT' in joined.upper():
                self.title = joined
            self._text_buf = []

    def handle_data(self, data):
        if self.cur_cell is not None:
            self.cur_cell.append(data)
        else:
            self._text_buf.append(data)


JENIS_BY_TITLE = {
    'CASH IN REPORT': 'kas_masuk',
    'CASH OUT REPORT': 'kas_keluar',
    'BANK IN REPORT': 'bank_masuk',
    'BANK OUT REPORT': 'bank_keluar',
}


def parse_report(path):
    with open(path, encoding='utf-8', errors='replace') as f:
        html = f.read()
    p = ReportParser()
    p.feed(html)
    if not p.title or p.title.upper() not in JENIS_BY_TITLE:
        raise ValueError(f"{path}: tidak bisa mengenali jenis laporan (judul: {p.title!r})")
    jenis = JENIS_BY_TITLE[p.title.upper()]
    header = p.header
    if not header:
        raise ValueError(f"{path}: header tabel tidak ditemukan")
    idx = {name: i for i, name in enumerate(header)}
    akun_kas_col = idx.get('Bank', idx.get('Akun Kas'))
    is_in = jenis.endswith('masuk')

    out = []
    for row in p.rows:
        if not row or row[0] == 'TOTAL' or len(row) != len(header):
            continue
        tgl = row[idx['Date']].strip()
        if not re.match(r'^\d{4}-\d{2}-\d{2}$', tgl):
            continue
        amount_raw = row[idx['Amount']].replace(',', '').strip()
        try:
            amount = float(amount_raw)
        except ValueError:
            continue
        out.append({
            'jenis': jenis,
            'tgl': tgl,
            'ref': row[idx['Ref No']].strip(),
            'akun_kas': row[akun_kas_col].strip(),
            'akun_lawan': row[idx['Akun Lawan']].strip(),
            'project': row[idx['Project']].strip(),
            'ket': row[idx['Description']].strip(),
            'debet': amount if is_in else 0.0,
            'kredit': 0.0 if is_in else amount,
        })
    return jenis, out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('files', nargs='+', help='satu atau lebih file report .xls (HTML)')
    ap.add_argument('--dry-run', action='store_true')
    args = ap.parse_args()

    all_txns = []
    for path in args.files:
        jenis, txns = parse_report(path)
        print(f"{os.path.basename(path)}: {jenis} — {len(txns)} baris")
        all_txns.extend(txns)

    projects_referenced = sorted({t['project'] for t in all_txns if t['project']})
    total_debet = sum(t['debet'] for t in all_txns)
    total_kredit = sum(t['kredit'] for t in all_txns)
    print(f"\nTotal transaksi: {len(all_txns)}")
    print(f"Total debet: {total_debet:,.0f}  |  Total kredit: {total_kredit:,.0f}")
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

            cur.execute("DELETE FROM transactions")
            print("Tabel transactions (kas/bank masuk & keluar) dikosongkan.")

            rows = [
                (f't{i + 1}', t['jenis'], t['tgl'], t['ref'], t['akun_kas'], t['akun_lawan'],
                 t['project'], '', None, None, t['ket'], t['debet'], t['kredit'], None)
                for i, t in enumerate(all_txns)
            ]
            cur.executemany(
                "INSERT INTO transactions "
                "(id, jenis, tgl, ref, akun_kas, akun_lawan, project, relasi, customer_id, vendor_id, ket, debet, kredit, created_by) "
                "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
                rows)
        conn.commit()
        print(f"\nImport selesai: {len(all_txns)} transaksi dimuat, sudah di-commit ke database.")
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


if __name__ == '__main__':
    main()
