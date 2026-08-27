# Panduan lengkap: dari folder di komputer sampai online di Hostinger

Panduan ini untuk yang belum pernah setup PHP/MySQL sama sekali. Alurnya
sengaja **coba dulu di komputer sendiri (localhost)** sampai semua fitur
jalan dan data cocok, baru dipindah ke hosting sungguhan. Kalau ada yang
salah, jauh lebih gampang diperbaiki di komputer sendiri daripada
langsung di server orang lain.

```
Bagian A — Kenali isi folder
Bagian B — Install software yang dibutuhkan di komputer
Bagian C — Siapkan database MySQL lokal
Bagian D — Jalankan backend (API) secara lokal
Bagian E — Jalankan frontend secara lokal, login pertama kali
Bagian F — Import data Excel asli ke database lokal
Bagian G — Checklist pengetesan sebelum pindah ke hosting
Bagian H — Sewa hosting + domain di Hostinger
Bagian I — Pindahkan semuanya ke Hostinger (ringkas — detail lengkap di
            docs/DEPLOY_HOSTINGER.md)
```

---

## Bagian A — Kenali isi folder

Setelah zip diekstrak, akan ada dua folder utama:

```
frontend/     <- ini yang dibuka user lewat browser (tampilan aplikasi)
  index.html          halaman utama, semua menu & laporan ada di sini
  auth.js             layar login
  data-sync.js        jembatan ke database (lewat backend di bawah)
  backend-config.js   <- SATU baris paling penting: alamat backend/API

backend/api/  <- ini yang jalan di server, menyimpan & mengambil data dari MySQL
  config.php (dibuat sendiri, lihat Bagian C)   kredensial database
  *.php               setiap file = satu "pintu" API (login, data customer, dst)
  bin/backup_db.php   untuk backup database (dijadwalkan otomatis nanti)

backend/mysql/schema.sql   <- struktur tabel database, dijalankan SEKALI saja

scripts/import_excel_mysql.py   <- untuk memasukkan data dari file Excel Anda
```

Yang perlu Anda ubah/isi sendiri hanya **dua** file:
`backend/api/config.php` (dibuat dari `config.sample.php`) dan
`frontend/backend-config.js`. File lainnya tidak perlu disentuh.

---

## Bagian B — Install software yang dibutuhkan di komputer

Cara termudah (disarankan): install **XAMPP** — satu installer yang
sudah termasuk Apache (web server), PHP, MySQL/MariaDB, dan phpMyAdmin
sekaligus. Tersedia untuk Windows, Mac, dan Linux.

1. Download di **apachefriends.org** (versi dengan PHP 8.1 ke atas).
2. Install seperti biasa (Next-Next-Finish). Catat di mana XAMPP
   dipasang — biasanya `C:\xampp` (Windows) atau `/Applications/XAMPP`
   (Mac).
3. Buka **XAMPP Control Panel**, klik **Start** pada baris **Apache**
   dan **MySQL**. Kalau keduanya berubah warna hijau/"Running", berarti
   sudah jalan.
4. Cek berhasil: buka browser ke `http://localhost/dashboard` (harus
   muncul halaman XAMPP) dan `http://localhost/phpmyadmin` (harus
   muncul phpMyAdmin).

> Kalau nanti Anda juga ingin coba import Excel dari komputer sendiri
> (Bagian F), install juga **Python 3** dari python.org — pilih versi
> terbaru, saat instalasi centang "Add Python to PATH".

---

## Bagian C — Siapkan database MySQL lokal

1. Buka `http://localhost/phpmyadmin`.
2. Klik tab **Databases**, buat database baru bernama `accv2`
   (collation pilih `utf8mb4_unicode_ci` kalau ditanya).
3. Klik nama database `accv2` yang baru dibuat, masuk tab **SQL**,
   buka file `backend/mysql/schema.sql` dengan text editor, copy semua
   isinya, paste ke kotak SQL di phpMyAdmin, lalu klik **Go**.
   Hasilnya: 9 tabel baru muncul di sebelah kiri (`users`, `customers`,
   `vendors`, `projects`, `coa`, `transactions`, `jurnal_umum`,
   `hutang_overrides`, `audit_log`).
4. (Opsional tapi disarankan) Buat user database terpisah — jangan pakai
   `root` untuk aplikasi. Di phpMyAdmin: tab **User accounts** → **Add
   user account** → username `accv2_user`, password buat sendiri yang
   kuat, host `localhost`. Di bagian hak akses, centang **Grant all
   privileges on database "accv2"**, lalu **Go**.

---

## Bagian D — Jalankan backend (API) secara lokal

1. Copy folder `backend/api/` ke dalam folder `htdocs` XAMPP, misalnya
   jadi `C:\xampp\htdocs\accv2\api\` (Windows) atau
   `/Applications/XAMPP/htdocs/accv2/api/` (Mac).
2. Di dalam folder `api/` itu, duplikat `config.sample.php` menjadi
   `config.php`, lalu edit isinya sesuai yang dibuat di Bagian C:
   ```php
   return [
       'db_host' => '127.0.0.1',
       'db_name' => 'accv2',
       'db_user' => 'accv2_user',
       'db_pass' => '<password yang Anda buat di langkah C.4>',
       'cors_origins' => [],
       'backup_dir' => __DIR__ . '/../backups',
       'backup_retention_days' => 14,
   ];
   ```
3. Buat akun login pertama. Buka **Terminal/Command Prompt**, arahkan ke
   folder `bin`:
   ```bash
   cd C:\xampp\htdocs\accv2\api\bin      # sesuaikan path Anda
   C:\xampp\php\php.exe create_user.php owner@perusahaananda.com "PasswordKuatSekali!" "Nama Pemilik" owner
   ```
   (Di Mac/Linux, ganti `C:\xampp\php\php.exe` dengan `php` saja.)
   Kalau berhasil akan muncul `OK — user '...' (owner) is ready to log in.`
4. Tes API-nya sudah jalan: buka
   `http://localhost/accv2/api/auth_me.php` di browser — harus muncul
   teks `{"user":null}` (belum login, tapi itu tandanya API hidup dan
   bisa bicara ke database).

---

## Bagian E — Jalankan frontend secara lokal, login pertama kali

1. Copy seluruh isi folder `frontend/` ke `htdocs`, sejajar dengan
   folder `api` di atas — jadi strukturnya:
   ```
   htdocs/accv2/
     api/            (dari Bagian D)
     index.html      (dan file frontend lainnya)
   ```
2. Edit `htdocs/accv2/backend-config.js`:
   ```js
   window.API_BASE_URL = '/accv2/api';
   ```
3. Buka `http://localhost/accv2/index.html` di browser.
4. Harus muncul layar login. Masuk pakai email & password dari Bagian
   D.3.
5. Setelah masuk, coba:
   - Buka menu **Customer**, tambah 1 data, refresh halaman (F5) —
     data harus tetap ada (artinya benar-benar tersimpan di MySQL).
   - Buka **Dashboard** — untuk sekarang datanya masih kosong/contoh,
     wajar, karena data asli baru masuk di Bagian F.

---

## Bagian F — Import data Excel asli ke database lokal

1. Buka Terminal/Command Prompt, masuk ke folder `scripts/`:
   ```bash
   cd scripts
   python -m venv .venv
   .venv\Scripts\activate        # Mac/Linux: source .venv/bin/activate
   pip install -r requirements.txt
   ```
2. Coba dulu tanpa menulis apa pun ke database (`--dry-run`), untuk
   memastikan file Excel Anda terbaca dengan benar:
   ```bash
   set MYSQL_HOST=127.0.0.1
   set MYSQL_DB=accv2
   set MYSQL_USER=accv2_user
   set MYSQL_PASS=<password Anda>
   python import_excel_mysql.py --dry-run "C:\path\ke\LAPORAN_KEUANGAN.xlsx"
   ```
   (Mac/Linux: ganti `set X=Y` menjadi `export X=Y`.)
   Perhatikan ringkasan jumlah baris yang muncul — kalau angkanya masuk
   akal (jumlah project, transaksi, dst sesuai perkiraan Anda), lanjut
   ke langkah berikutnya.
3. Jalankan sungguhan (hapus `--dry-run`):
   ```bash
   python import_excel_mysql.py "C:\path\ke\LAPORAN_KEUANGAN.xlsx"
   ```
4. Refresh `http://localhost/accv2/index.html`, buka **Dashboard** —
   sekarang harus muncul angka-angka dari data Excel Anda.

File Excel Anda **tidak pernah** perlu diupload ke mana-mana atau masuk
git — proses ini murni dari komputer Anda langsung ke database lokal
Anda.

---

## Bagian G — Checklist pengetesan sebelum pindah ke hosting

Jangan lanjut ke Hostinger sebelum semua ini dicoba dan beres di
localhost:

- [ ] Login & logout berhasil.
- [ ] Tambah, edit, hapus data di minimal: Customer, Vendor, Master
      Project, Kas Masuk/Keluar, Jurnal Umum.
- [ ] Setelah tambah/edit/hapus transaksi, angka di **Dashboard** dan
      **Cash Flow** ikut berubah dengan benar.
- [ ] Menu **Trial Hutang** menampilkan nota dari Jurnal Umum dan status
      lunas/belum-nya benar.
- [ ] Refresh halaman (F5) tidak menghilangkan data maupun sesi login.
- [ ] Coba buka aplikasi dari HP (di jaringan WiFi yang sama, pakai
      alamat IP komputer, misalnya `http://192.168.1.5/accv2/`) untuk
      cek tampilan responsive.
- [ ] Data dari Excel di Bagian F sudah lengkap dan project-nya
      ter-link (Dashboard menunjukkan angka, bukan nol semua).

Kalau semua sudah dicek dan aman, baru lanjut ke Bagian H.

---

## Bagian H — Sewa hosting + domain di Hostinger

1. Buka **hostinger.co.id** (atau hostinger.com), pilih paket **Web
   Hosting** — paket **Premium** sudah cukup untuk aplikasi ini (sudah
   termasuk PHP terbaru, MySQL, SSL gratis); paket **Business** kalau
   ingin akses SSH (mempercepat beberapa langkah di Bagian I, tapi
   tidak wajib).
2. Saat checkout, Hostinger akan menawarkan pendaftaran domain baru
   (misal `.com`/`.co.id`) — bisa daftar domain baru di sini, atau pilih
   "sudah punya domain" kalau domainnya dibeli di tempat lain (nanti
   tinggal arahkan DNS domain itu ke Hostinger).
3. Selesaikan pembayaran, tunggu email konfirmasi dari Hostinger berisi
   akses ke **hPanel** (panel kontrol hosting Anda).
4. Kalau domain baru didaftarkan bersamaan, biasanya otomatis
   tersambung. Kalau domain dari tempat lain, ikuti instruksi Hostinger
   untuk mengubah **nameserver** domain tersebut ke nameserver
   Hostinger (butuh beberapa jam sampai 1x24 jam untuk aktif penuh —
   ini disebut propagasi DNS).

---

## Bagian I — Pindahkan semuanya ke Hostinger

Setelah hosting & domain aktif, langkah-langkahnya sama persis dengan
yang baru dites di Bagian C–F, hanya targetnya database & server
Hostinger, bukan lagi XAMPP di komputer sendiri. Panduan detailnya
sudah ditulis lengkap di **[docs/DEPLOY_HOSTINGER.md](DEPLOY_HOSTINGER.md)**,
mengikuti urutan:

1. Buat database MySQL di hPanel (setara Bagian C, tapi lewat hPanel,
   bukan XAMPP).
2. Upload folder `frontend/` dan `backend/api/` lewat File Manager
   hPanel (setara Bagian D–E, tapi filenya diupload, bukan dicopy ke
   `htdocs`).
3. Buat `config.php` di server dengan kredensial database Hostinger.
4. Ubah `backend-config.js` jadi `/api` (bukan `/accv2/api` seperti di
   lokal, karena di Hostinger frontend ada di root domain).
5. Aktifkan HTTPS gratis dari hPanel.
6. Buat ulang akun login admin/owner (akun di lokal tidak otomatis ikut
   pindah — database lokal dan database Hostinger terpisah).
7. Import data Excel yang sama ke database Hostinger (Remote MySQL,
   sama seperti Bagian F tapi nyambung ke server, bukan ke `127.0.0.1`).
8. Jadwalkan cron job harian untuk backup otomatis.
9. Tes ulang seluruh checklist Bagian G, kali ini di alamat domain asli
   Anda.

Baca `docs/DEPLOY_HOSTINGER.md` untuk perintah dan tangkapan layar
langkah demi langkah setiap poin di atas.
