# Prakasa Group — ACC v2

Sistem akuntansi internal (kas/bank, jurnal, laporan keuangan, tracking
proyek) untuk perusahaan konstruksi. Lanjutan dari
[ammar-zxz/ACCV2](https://github.com/ammar-zxz/ACCV2) (satu file HTML
statis dengan data di `localStorage`), dikembangkan menjadi aplikasi
dengan backend sungguhan agar bisa login multi-user/multi-perangkat dan
datanya tersimpan permanen di server, bukan di satu browser saja.

Lihat **[docs/SETUP.md](docs/SETUP.md)** untuk cara menjalankan dari nol
(bikin project Supabase, import data Excel, konfigurasi frontend).

## Struktur repo

```
frontend/    — aplikasi web (HTML/CSS/JS polos, tanpa build step)
  index.html         halaman utama (semua menu/laporan)
  auth.js            layar login & sesi multi-device
  data-sync.js        jembatan DB lokal <-> Supabase
  supabase-config.js  URL + anon key project Supabase Anda
  vendor/            library pihak ketiga (supabase-js), di-vendor
                      lokal supaya tidak bergantung ke CDN eksternal

backend/supabase/migrations/
  0001_init.sql      skema tabel + Row Level Security

scripts/
  import_excel.py    import data dari file Excel laporan keuangan ke
                      Supabase (tidak pernah lewat git)

docs/
  SETUP.md           panduan setup lengkap
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
