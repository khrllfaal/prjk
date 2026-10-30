-- Ubah tanggal kasbon Komeng (proyek Cost Center) sebesar Rp 5.000.000 menjadi 29 Okt 2026.
-- Supaya kasbon ikut periode gaji 23-29 Okt dan muncul di kotak "Potongan kasbon otomatis" saat Periksa & Setujui.
-- Hanya mengubah kolom tanggal pada baris itu. Jalankan di phpMyAdmin (pilih database aplikasi), per bagian dari atas ke bawah.

-- ===== 1. PERIKSA DULU (tidak mengubah apa pun) =====
-- a) Harus tepat 1 baris, tanggal sekarang 2026-10-30:
SELECT k.id, k.tgl, k.jumlah, k.ket, k.ref
  FROM kasbon k JOIN workers w ON w.id = k.worker_id JOIN projects p ON p.id = k.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND k.jumlah = 5000000;
-- b) Status periode 23-29 Okt harus 'draft' atau 'diajukan'. Bila 'disetujui' atau 'dibayar', BERHENTI dan kabari saya.
SELECT pp.tgl_mulai, pp.tgl_akhir, pp.status FROM payroll_periods pp JOIN projects p ON p.id = pp.project_id
 WHERE p.nama = 'Cost Center' AND pp.tgl_mulai = '2026-10-23';

-- ===== 2. CADANGAN (aman dijalankan ulang) =====
CREATE TABLE IF NOT EXISTS kasbon_cadangan_komeng AS
SELECT k.* FROM kasbon k JOIN workers w ON w.id = k.worker_id JOIN projects p ON p.id = k.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND k.jumlah = 5000000;

-- ===== 3. UBAH TANGGAL =====
UPDATE kasbon k
  JOIN workers w ON w.id = k.worker_id
  JOIN projects p ON p.id = k.project_id
   SET k.tgl = '2026-10-29'
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND k.jumlah = 5000000 AND k.tgl = '2026-10-30'
   AND NOT EXISTS (SELECT 1 FROM payroll_periods pp
                    WHERE pp.project_id = k.project_id AND pp.tgl_mulai = '2026-10-23' AND pp.status NOT IN ('draft', 'diajukan'));

-- ===== 4. PERIKSA HASIL: tanggal harus 2026-10-29 =====
SELECT k.id, k.tgl, k.jumlah FROM kasbon k JOIN workers w ON w.id = k.worker_id JOIN projects p ON p.id = k.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND k.jumlah = 5000000;

-- ===== MEMBATALKAN (bila perlu) =====
-- UPDATE kasbon k JOIN kasbon_cadangan_komeng c ON c.id = k.id SET k.tgl = c.tgl;
-- Setelah yakin benar:  DROP TABLE kasbon_cadangan_komeng;
