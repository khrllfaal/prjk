# MatTrack — Frontend Manajemen Bahan Proyek

Frontend (mode demo) untuk mencatat bahan masuk/keluar di lapangan dan
memantau stok terhadap RAB dari sisi admin pusat/owner. Belum ada backend —
data tersimpan di `localStorage` browser, tapi model datanya sudah
disiapkan untuk disambungkan ke API/DB nyata (lihat "Menuju backend" di
bawah).

## Menjalankan

Tidak ada build step. Buka `index.html` langsung, atau jalankan static
server dari folder ini, misalnya:

```
python3 -m http.server 8080
```

lalu buka `http://localhost:8080`.

## Struktur

```
index.html        shell halaman + urutan pemuatan script
css/style.css      design system (warna, komponen, responsive)
js/icons.js        ikon inline SVG (tanpa dependensi CDN)
js/data.js          lapisan penyimpanan (localStorage) + data contoh/demo
js/calc.js          mesin kalkulasi rekap stok, status, laporan mingguan
js/app.js            router (hash-based), shell aplikasi, login/sesi
js/views.js          seluruh tampilan halaman & modal
```

## Keputusan desain penting

- **Semua relasi antar-data pakai ID, bukan nama teks.** Versi Excel
  sebelumnya memakai SUMIFS berbasis nama bahan lintas sheet — begitu ada
  rename/typo, rekap keseluruhan rusak jadi `#REF!`. Di sini nama bahan
  boleh diubah kapan saja tanpa merusak angka yang sudah tercatat, karena
  transaksi merujuk `materialId`, bukan nama.
- **RAB kebutuhan bahan itu opsional (`rabKebutuhan: null`).** Banyak
  proyek belum punya data volume RAB yang lengkap/terbaru. UI tidak boleh
  error atau menampilkan `NaN` — statusnya ditandai eksplisit "Belum ada
  RAB" dan pencatatan bahan masuk/keluar tetap jalan normal.
- **Rekap dihitung ulang saat render (recompute-on-read)**, bukan disimpan
  sebagai field yang bisa basi. Logikanya di `calc.js`, mudah ditelusuri
  dan ditest, tidak ada rantai formula tersembunyi.
- **Role**: `owner` (Admin Pusat/Owner) bisa kelola proyek & RAB;
  `lapangan` (Admin Lapangan) fokus input transaksi. Keduanya bisa lihat
  semua data — pembagian akses lebih granular (mis. per-proyek) menyusul
  saat backend & auth sungguhan digarap.
- **Status stok**: `Aman` / `Perlu Order` (sisa ≤10% dari total masuk) /
  `Habis` (sisa ≤0) / `Belum Ada Data` (belum pernah ada barang masuk).
- **Status RAB**: `Aman` (deviasi realisasi ≤5%) / `Perlu Perhatian`
  (5–10%) / `Over RAB` (>10%) / `Belum Ada RAB`.

## Menuju backend

Struktur `js/data.js` (`projects`, `materials`, `transactions`) dipetakan
1:1 ke tabel: `projects`, `materials(project_id)`,
`transactions(material_id, tipe, tanggal, volume, ...)`. Saat backend
siap, ganti isi method `Store.*` agar memanggil API (fetch) alih-alih
`localStorage`, tanpa perlu mengubah `calc.js` atau `views.js`.
