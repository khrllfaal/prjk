# Setup — Prakasa Group ACC v2, jalur Supabase (alternatif)

> Backend utama sekarang adalah **PHP + MySQL** (`backend/mysql/schema.sql`
> + `backend/api/`), dipilih karena cocok langsung dengan hosting shared
> Hostinger. Panduan di file ini untuk jalur **Supabase**, yang tetap
> didukung sebagai alternatif. Untuk deploy ke Hostinger dengan MySQL,
> lihat docs/DEPLOY_HOSTINGER.md.

## 0. Sebelum mulai — repo harus private

Repo ini menampung *skema* dan *kode*, bukan data asli. Tapi begitu Anda
menjalankan importer di langkah 4, data keuangan asli akan ada di database
Supabase Anda (bukan di git) — repo tetap boleh public untuk kode. Kalau
Anda tetap ingin private, ubah di GitHub: **Settings → Danger Zone → Change
repository visibility → Private**.

## 1. Buat project Supabase

1. Daftar/masuk ke https://supabase.com, buat project baru (pilih region
   Singapore untuk latensi terbaik dari Indonesia).
2. Simpan **Database password** yang dibuat saat itu — dipakai di langkah 4.
3. Buka **Project Settings → API**, catat:
   - `Project URL` → contoh `https://xxxxx.supabase.co`
   - `anon public` key
4. Buka **Project Settings → Database → Connection string → URI**, catat
   connection string-nya (dipakai sebagai `DATABASE_URL` di langkah 4).

## 2. Jalankan schema SQL

1. Buka **SQL Editor** di dashboard Supabase.
2. Copy-paste seluruh isi `backend/supabase/migrations/0001_init.sql`,
   lalu jalankan (Run). Ini membuat semua tabel (customers, vendors,
   projects, coa, transactions, jurnal_umum, hutang_dagang, profiles)
   beserta Row Level Security-nya.

## 3. Buat akun admin & owner

Aplikasi ini **tidak punya form daftar akun sendiri** (disengaja, supaya
tidak sembarang orang bisa daftar) — akun dibuat manual oleh Anda:

1. Di dashboard Supabase: **Authentication → Users → Add user** → isi
   email + password untuk admin, ulangi untuk owner.
2. Di **SQL Editor**, jalankan (ganti `<uuid>` dengan User UID dari
   langkah di atas, bisa dicopy dari halaman Users):
   ```sql
   insert into profiles (id, nama, role) values
     ('<uuid-admin>', 'Nama Admin', 'admin'),
     ('<uuid-owner>', 'Nama Owner', 'owner');
   ```

Akun-akun ini bisa login bersamaan dari HP, laptop, tablet dsb — Supabase
Auth memberi setiap login sesi (JWT) sendiri-sendiri per perangkat, jadi
tidak saling logout.

## 4. Import data dari Excel

Data asli (kas besar/kecil, bank, COA, customer/vendor, project, jurnal)
diimpor langsung dari Excel ke database — **tidak pernah lewat git**.

```bash
cd scripts
pip install -r requirements.txt
export DATABASE_URL="postgresql://postgres:<password>@<host>:5432/postgres"
python3 import_excel_supabase.py --dry-run "/path/ke/LAPORAN_KEUANGAN_2026_KONTRUKSI_april_rev_2.xlsx"
# kalau jumlah baris di atas terlihat wajar, jalankan sungguhan:
python3 import_excel_supabase.py "/path/ke/LAPORAN_KEUANGAN_2026_KONTRUKSI_april_rev_2.xlsx"
```

Import bisa dijalankan ulang dengan aman (pakai `on conflict do nothing`);
untuk mulai bersih pakai flag `--wipe`.

## 5. Konfigurasi frontend

Edit `frontend/supabase-config.js`, isi dengan URL dan anon key dari
langkah 1:

```js
window.SUPABASE_URL = 'https://xxxxx.supabase.co';
window.SUPABASE_ANON_KEY = 'ey...';
```

File ini **aman dipublikasikan** — anon key hanya berfungsi untuk user
yang sudah login dan terdaftar di tabel `profiles` (diatur oleh Row Level
Security di migration SQL). Tanpa login, key ini tidak bisa mengambil
data apa pun.

## 6. Jalankan / deploy frontend

Lokal (untuk uji coba):
```bash
cd frontend
python3 -m http.server 8080
# buka http://localhost:8080
```

Untuk produksi: upload isi folder `frontend/` ke GitHub Pages, Netlify,
Vercel, atau hosting statis apa pun — tidak butuh server Node/PHP karena
semua logic backend sudah ditangani Supabase.

## Yang sudah jalan di Phase 1 ini

- Login (admin/owner) via Supabase Auth, multi-device.
- Semua data (customer, vendor, project, COA, transaksi kas/bank, jurnal)
  disimpan permanen di Postgres (Supabase), bukan localStorage browser.
- Form Kas Masuk/Keluar & Bank Masuk/Keluar: kolom "Kategori" dihapus,
  diganti relasi **Customer** (untuk transaksi masuk) atau **Vendor**
  (untuk transaksi keluar).
- Setiap tambah/edit/hapus data langsung tersinkron ke server (dengan
  fallback cache lokal kalau koneksi terputus).

## Yang masih dikerjakan (iterasi berikut)

- Revisi tampilan Cash Flow sesuai contoh.
- Perbaikan Dashboard "Rincian Progress per Proyek" + filter pemberi
  proyek (Kemhan, Bina Marga, PUPR, dst).
- Drill-down riwayat transaksi saat klik angka/label (Cash Flow, Laba
  Rugi, Dashboard, dll).
- Menu baru "Trial Hutang" (status bayar per nota, per vendor, per
  project).
- QA menyeluruh atas semua menu setelah semua di atas selesai.
