# Deploy ke Hostinger — backend PHP + MySQL

Panduan ini untuk jalur backend **utama** (PHP 8 + MySQL/MariaDB),
dirancang khusus untuk hosting shared/business Hostinger — tidak perlu
proses Node.js terpisah, karena PHP + MySQL sudah tersedia langsung di
paket hosting Hostinger mana pun.

Kalau Anda memakai jalur Supabase (alternatif), lihat
[docs/SETUP.md](SETUP.md) — bagian di bawah ini tidak berlaku untuk
jalur itu.

## Yang Anda butuhkan

- Paket hosting Hostinger dengan PHP 8.1+ dan 1 database MySQL (semua
  paket shared Hostinger sudah termasuk ini).
- Akses **hPanel**. Akses **SSH** mempercepat beberapa langkah (tersedia
  mulai paket Premium/Business) tapi tidak wajib — setiap langkah yang
  butuh SSH punya alternatif lewat hPanel di bawah.
- File project ini (folder `frontend/` dan `backend/`).

## 1. Buat database MySQL

1. Di hPanel: **Databases → MySQL Databases**.
2. Buat database baru (misal `u123456789_accv2`) dan user baru dengan
   password kuat — Hostinger otomatis mengaitkan user ke database itu.
   Catat: nama database, username, password, dan **host** (biasanya
   `localhost` untuk koneksi dari PHP di server yang sama).
3. Buka **phpMyAdmin** dari hPanel, pilih database yang baru dibuat, lalu
   masuk tab **SQL** dan jalankan seluruh isi `backend/mysql/schema.sql`
   (copy-paste, lalu klik "Go"). Ini membuat semua 9 tabel yang
   dibutuhkan.

## 2. Upload file aplikasi

Struktur yang disarankan di server (lewat File Manager hPanel atau FTP):

```
public_html/
  index.html, auth.js, data-sync.js, backend-config.js, ...   (isi frontend/)
  api/                                                         (isi backend/api/)
```

- Upload seluruh isi `frontend/` ke `public_html/` (root domain Anda).
- Upload seluruh isi `backend/api/` ke `public_html/api/`.
- **Jangan** upload `backend/api/config.php` dari komputer lokal Anda
  (kalau ada) — itu berisi kredensial database lokal untuk testing, bukan
  untuk produksi. Anda akan membuat `config.php` baru langsung di server
  (langkah 3).
- Upload `backend/mysql/` tidak perlu ke server — isinya sudah dijalankan
  lewat phpMyAdmin di langkah 1.

## 3. Konfigurasi backend (`config.php`)

Di File Manager hPanel, masuk ke `public_html/api/`, duplikat
`config.sample.php` menjadi `config.php`, lalu edit isinya:

```php
return [
    'db_host' => 'localhost',                 // dari langkah 1
    'db_name' => 'u123456789_accv2',
    'db_user' => 'u123456789_accv2user',
    'db_pass' => '<password database Anda>',
    'cors_origins' => [],                      // kosong: frontend & API satu domain
    'backup_dir' => '/home/u123456789/accv2_backups',  // LIHAT CATATAN di bawah
    'backup_retention_days' => 14,
];
```

**Penting soal `backup_dir`:** arahkan ke folder **di luar** `public_html`
sepenuhnya (bukan `public_html/api/../backups` seperti default lokal),
supaya file backup database tidak pernah bisa diakses lewat URL publik
sama sekali. Path absolut seperti `/home/u123456789/accv2_backups` (satu
level di atas `public_html`) aman — buat foldernya lewat File Manager
kalau belum ada.

`config.php` sudah otomatis diblokir dari akses HTTP langsung oleh
`.htaccess` yang sudah ikut ter-upload di folder `api/` — tidak perlu
langkah tambahan, tapi boleh dicek dengan membuka
`https://domainanda.com/api/config.php` di browser dan memastikan hasilnya
403 Forbidden, bukan isi file.

## 4. Konfigurasi frontend (`backend-config.js`)

Edit `public_html/backend-config.js`:

```js
window.API_BASE_URL = '/api';
```

Karena frontend dan API ada di domain yang sama, path relatif `/api`
sudah cukup — tidak perlu URL lengkap, dan tidak perlu mengisi
`cors_origins` di `config.php` (CORS hanya diperlukan kalau frontend dan
API ada di domain/subdomain berbeda).

## 5. Aktifkan HTTPS

Di hPanel: **SSL → Setup SSL** (Hostinger menyediakan sertifikat gratis).
Setelah aktif, pastikan ada redirect otomatis HTTP → HTTPS (biasanya
sudah otomatis; kalau belum, aktifkan "Force HTTPS" di menu SSL yang
sama). Ini penting karena session cookie login (`accv2_session`) hanya
ditandai `secure` saat koneksi benar-benar HTTPS — lihat
`backend/api/helpers.php`.

## 6. Buat akun admin/owner pertama

**Kalau Anda punya akses SSH** (hPanel → Advanced → SSH Access):

```bash
ssh u123456789@yourdomain.com
cd public_html/api/bin
php create_user.php owner@perusahaananda.com "PasswordKuatSekali!" "Nama Pemilik" owner
```

**Kalau tidak punya SSH**, jalankan `create_user.php` di komputer lokal
Anda dulu (tanpa terhubung ke database produksi) hanya untuk melihat
password hash-nya, lalu masukkan barisnya manual lewat phpMyAdmin:

```bash
# di komputer lokal — script akan gagal connect ke DB, itu tidak masalah,
# yang dibutuhkan hanya baris `$hash = password_hash(...)` di kodenya —
# atau lebih gampang, jalankan satu baris ini pakai php CLI lokal:
php -r "echo password_hash('PasswordKuatSekali!', PASSWORD_BCRYPT), PHP_EOL;"
```

Lalu di phpMyAdmin, tabel `users`, klik **Insert**, isi:
- `id`: teks bebas unik, misal `u1`
- `email`: email login (huruf kecil semua)
- `password_hash`: hasil `password_hash(...)` di atas (mulai dengan `$2y$`)
- `nama`: nama tampil
- `role`: `owner` atau `admin`
- kolom lain biarkan default/kosong

Ulangi untuk setiap akun admin/owner yang dibutuhkan. Login bisa dipakai
bersamaan dari beberapa perangkat (HP, laptop, tablet) — lihat
`frontend/auth.js`.

## 7. Import data Excel

Cara paling praktis: aktifkan **Remote MySQL** sementara supaya komputer
lokal Anda bisa konek langsung ke database Hostinger untuk import.

1. hPanel → **Databases → Remote MySQL** → tambahkan IP publik komputer
   Anda saat ini (cek di google "what is my ip").
2. Di komputer lokal:
   ```bash
   cd scripts
   python3 -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   export MYSQL_HOST=<hostname MySQL dari hPanel, bukan 'localhost'>
   export MYSQL_DB=u123456789_accv2
   export MYSQL_USER=u123456789_accv2user
   export MYSQL_PASS='<password database>'
   python3 import_excel_mysql.py --dry-run "/path/ke/LAPORAN_KEUANGAN.xlsx"
   # kalau jumlah baris di atas terlihat wajar, jalankan sungguhan:
   python3 import_excel_mysql.py "/path/ke/LAPORAN_KEUANGAN.xlsx"
   ```
3. **Setelah import selesai, hapus lagi entri IP di Remote MySQL** —
   jangan biarkan akses remote terbuka permanen.

File Excel **tidak pernah** perlu diupload ke server atau masuk git —
importer konek langsung dari komputer lokal ke database.

Import aman dijalankan ulang (upsert by id) kalau perlu re-sync data
terbaru dari Excel; pakai `--wipe` hanya kalau memang ingin mengosongkan
tabel dulu.

## 8. Jadwalkan backup otomatis

hPanel → **Advanced → Cron Jobs** → buat cron job baru:

- **Frekuensi**: harian (misalnya jam 02:00 pagi)
- **Command**:
  ```
  php /home/u123456789/public_html/api/bin/backup_db.php
  ```
  (sesuaikan path dengan lokasi upload Anda di langkah 2)

Cron job ini menulis dump `.sql.gz` bertanggal ke `backup_dir` yang Anda
set di langkah 3, dan otomatis menghapus dump yang lebih tua dari
`backup_retention_days` (default 14 hari). Untuk restore, download file
`.sql.gz`-nya lewat File Manager/FTP, extract, lalu import lewat tab
**Import** di phpMyAdmin.

Disarankan sesekali (misalnya sebulan sekali) mengunduh salah satu file
backup ke penyimpanan di luar Hostinger (Google Drive, laptop pribadi,
dsb) sebagai lapis proteksi tambahan kalau akun hosting bermasalah.

## 9. Verifikasi

1. Buka `https://domainanda.com` — harus muncul layar login.
2. Login dengan akun dari langkah 6.
3. Buka salah satu menu (misal Customer), tambah 1 data uji, refresh
   halaman, pastikan data tetap ada (artinya benar-benar tersimpan di
   MySQL, bukan cuma di browser).
4. Cek Dashboard menunjukkan angka yang masuk akal dari data Excel yang
   diimpor di langkah 7.
5. Coba akses `https://domainanda.com/api/config.php` langsung di
   browser — harus 403 Forbidden.

## Checklist keamanan sebelum go-live

- [ ] `config.php` tidak bisa diakses lewat URL (langkah 3).
- [ ] HTTPS aktif dan dipaksa (langkah 5).
- [ ] `backup_dir` berada di luar `public_html` (langkah 3).
- [ ] Akses Remote MySQL sudah dimatikan lagi setelah import (langkah 7).
- [ ] Password akun admin/owner kuat dan unik (bukan dipakai di tempat
      lain).
- [ ] Cron backup harian sudah aktif dan sudah dites minimal sekali
      (cek folder `backup_dir` ada file `.sql.gz` baru setelah cron jalan).
- [ ] Repo GitHub `khrllfaal/prjk` sudah di-set **Private** (Settings →
      Danger Zone → Change repository visibility) — kode di git tidak
      berisi data asli, tapi tetap disarankan untuk mengurangi exposure.

## Update aplikasi di kemudian hari

Untuk menerapkan perubahan kode (fitur baru, perbaikan bug):

1. Upload ulang file `frontend/` dan `backend/api/` yang berubah lewat
   File Manager/FTP — **jangan** timpa `public_html/api/config.php`
   (kredensial produksi Anda) atau `public_html/backend-config.js` kalau
   isinya sudah disesuaikan.
2. Kalau ada perubahan skema (`backend/mysql/schema.sql`), jalankan ulang
   isinya lewat phpMyAdmin — semua statement di sana aman dijalankan
   berkali-kali (`CREATE TABLE IF NOT EXISTS` / `ADD COLUMN IF NOT
   EXISTS`), tidak akan menghapus data yang sudah ada.
