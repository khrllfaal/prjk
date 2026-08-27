# Prakasa Group — ACC v2

Sistem akuntansi internal (kas/bank, jurnal, laporan keuangan, tracking
proyek) untuk perusahaan konstruksi. Lanjutan dari
[ammar-zxz/ACCV2](https://github.com/ammar-zxz/ACCV2) (satu file HTML
statis dengan data di `localStorage`), dikembangkan menjadi aplikasi
dengan backend sungguhan agar bisa login multi-user/multi-perangkat dan
datanya tersimpan permanen di server, bukan di satu browser saja.

Backend utama adalah **PHP + MySQL** (cocok dengan hosting shared
Hostinger tanpa proses Node terpisah); jalur **Supabase** tetap ada
sebagai alternatif/legacy. Lihat **[docs/SETUP.md](docs/SETUP.md)**
untuk jalur Supabase, atau `backend/mysql/schema.sql` +
`backend/api/` untuk jalur MySQL (panduan deploy Hostinger lengkap:
lihat docs/DEPLOY_HOSTINGER.md).

## Struktur repo

```
frontend/    — aplikasi web (HTML/CSS/JS polos, tanpa build step)
  index.html          halaman utama (semua menu/laporan)
  auth.js             layar login & sesi multi-device (MySQL session atau Supabase Auth)
  data-sync.js        jembatan DB lokal <-> backend aktif (MySQL/PHP atau Supabase)
  backend-config.js   API_BASE_URL untuk backend PHP/MySQL (kosong = mode lokal)
  supabase-config.js  URL + anon key project Supabase (jalur alternatif)
  vendor/             library pihak ketiga (supabase-js), di-vendor
                       lokal supaya tidak bergantung ke CDN eksternal

backend/mysql/
  schema.sql          skema tabel MySQL/MariaDB (backend utama)

backend/api/           REST API PHP 8 di atas MySQL (sesi cookie, CRUD generik, audit log)

backend/supabase/migrations/
  0001_init.sql        skema tabel + Row Level Security (jalur alternatif)

scripts/
  import_excel_mysql.py    import Excel -> MySQL (jalur utama, tidak pernah lewat git)
  import_excel_supabase.py import Excel -> Supabase (jalur alternatif)

docs/
  PANDUAN_LOKAL_KE_HOSTINGER.md  mulai dari nol: install XAMPP, coba di
                                  localhost, sampai pindah ke Hostinger
  DEPLOY_HOSTINGER.md            detail lengkap tahap deploy ke Hostinger
  SETUP.md                       panduan setup jalur Supabase (alternatif)
```

## Prinsip desain

- **Tidak ada data asli di git.** Data keuangan (nilai kontrak, vendor,
  transaksi) hanya hidup di database Supabase Anda sendiri, diimpor
  langsung dari file Excel lokal. Contoh data bawaan di `frontend/index.html`
  (`const SEED`) sudah diganti dengan data contoh/placeholder yang jelas
  fiktif — dipakai hanya sebagai fallback offline/demo, bukan sumber data
  utama lagi (sumber data utama adalah Supabase setelah login).
- **Tampilan & alur kerja existing dipertahankan** — perubahan pada
  `frontend/index.html` sejauh ini hanya menambahkan gerbang login dan
  sinkronisasi ke backend, tanpa mengubah menu/laporan yang sudah ada.
- **Multi-device by design** — Supabase Auth memberi setiap
  login/perangkat sesi JWT sendiri, jadi admin dan owner bisa masuk
  bersamaan dari HP, laptop, dan tablet tanpa saling ter-logout.

## Status pengembangan

Progres saat ini dan rencana lanjutan ada di daftar tugas sesi
pengembangan — ringkasnya: fondasi backend + login + relasi
customer/vendor pada form kas sudah berjalan; revisi tampilan Cash Flow,
Dashboard, drill-down riwayat transaksi, dan menu Trial Hutang menyusul.
