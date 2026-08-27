# Prakasa Group — ACC v2

Sistem akuntansi internal (kas/bank, jurnal, laporan keuangan, tracking
proyek) untuk perusahaan konstruksi. Lanjutan dari
[ammar-zxz/ACCV2](https://github.com/ammar-zxz/ACCV2) (satu file HTML
statis dengan data di `localStorage`), dikembangkan menjadi aplikasi
dengan backend sungguhan agar bisa login multi-user/multi-perangkat dan
datanya tersimpan permanen di server, bukan di satu browser saja.

Backend adalah **PHP + MySQL** — cocok langsung dengan hosting shared
Hostinger, tanpa proses Node terpisah. Mulai dari nol (install XAMPP,
coba di komputer sendiri dulu) lihat
**[docs/PANDUAN_LOKAL_KE_HOSTINGER.md](docs/PANDUAN_LOKAL_KE_HOSTINGER.md)**;
untuk detail tahap deploy ke Hostinger saja lihat
**[docs/DEPLOY_HOSTINGER.md](docs/DEPLOY_HOSTINGER.md)**.

## Struktur repo

```
frontend/    — aplikasi web (HTML/CSS/JS polos, tanpa build step)
  index.html          halaman utama (semua menu/laporan)
  auth.js             layar login & sesi multi-device
  data-sync.js        jembatan DB lokal <-> backend PHP/MySQL
  backend-config.js   API_BASE_URL (kosong = mode lokal/offline)

backend/mysql/
  schema.sql          skema tabel MySQL/MariaDB

backend/api/           REST API PHP 8 di atas MySQL (sesi cookie, CRUD generik, audit log)

scripts/
  import_excel_mysql.py    import Excel -> MySQL, tidak pernah lewat git

docs/
  PANDUAN_LOKAL_KE_HOSTINGER.md  mulai dari nol: install XAMPP, coba di
                                  localhost, sampai pindah ke Hostinger
  DEPLOY_HOSTINGER.md            detail lengkap tahap deploy ke Hostinger
```

## Prinsip desain

- **Tidak ada data asli di git.** Data keuangan (nilai kontrak, vendor,
  transaksi) hanya hidup di database MySQL Anda sendiri, diimpor
  langsung dari file Excel lokal. Contoh data bawaan di `frontend/index.html`
  (`const SEED`) sudah diganti dengan data contoh/placeholder yang jelas
  fiktif — dipakai hanya sebagai fallback offline/demo, bukan sumber data
  utama lagi (sumber data utama adalah MySQL setelah login).
- **Tampilan & alur kerja existing dipertahankan** — perubahan pada
  `frontend/index.html` sejauh ini hanya menambahkan gerbang login dan
  sinkronisasi ke backend, tanpa mengubah menu/laporan yang sudah ada.
- **Multi-device by design** — sesi login PHP berbasis cookie per
  perangkat/browser, jadi admin dan owner bisa masuk bersamaan dari HP,
  laptop, dan tablet tanpa saling ter-logout.

## Status pengembangan

Fondasi backend (PHP + MySQL), login, CRUD penuh di semua menu,
Dashboard, Cash Flow, Trial Hutang, importer Excel, backup otomatis, dan
hardening keamanan sudah selesai dan teruji end-to-end. Lihat
docs/DEPLOY_HOSTINGER.md untuk langkah go-live.
