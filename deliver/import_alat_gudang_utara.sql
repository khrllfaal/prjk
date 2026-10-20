-- Import Alat Gudang Utara: master bahan (nama, satuan) + barang datang (jumlah) dari lembar "Inventarisir Alat Gudang Utara" (36 baris).
-- Jalankan lewat phpMyAdmin > pilih database > tab SQL. Aman dijalankan berulang (tidak menggandakan).
--
-- LANGKAH WAJIB: ganti nama proyek di baris @proyek dan tanggal di @tgl sebelum dijalankan.
-- Bila nama proyek tidak ditemukan, hanya Master Bahan yang ditambahkan; barang datang dilewati dan hasil cek di bawah memberi tahu.
-- Angka bertanda "CEK" di komentar adalah tulisan tangan yang kurang jelas: samakan dengan kertas aslinya.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET @proyek := 'GANTI-NAMA-PROYEK-PERSIS-SEPERTI-DI-APLIKASI';
SET @tgl    := CURDATE();
SET @ref    := 'INV-GUDANG-UTARA';
SET @pid    := (SELECT id FROM projects WHERE nama = @proyek COLLATE utf8mb4_unicode_ci LIMIT 1);

DROP TEMPORARY TABLE IF EXISTS inv_gudang;
CREATE TEMPORARY TABLE inv_gudang (no INT PRIMARY KEY, nama VARCHAR(255) NOT NULL, satuan VARCHAR(40) NOT NULL, qty DECIMAL(18,3) NOT NULL, ket VARCHAR(255) NOT NULL DEFAULT '') DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO inv_gudang (no, nama, satuan, qty, ket) VALUES
  (1, 'Scaffolding', 'bh', 25, ''),
  (2, 'Jack Hammer Besar', 'bh', 3, ''),
  (3, 'Jack Hammer Kecil', 'bh', 3, ''),
  (4, 'Palu Beton', 'bh', 5, ''),
  (5, 'Palu Konde', 'bh', 10, ''),
  (6, 'Kapak Gagang', 'bh', 12, ''),  -- CEK: tertulis "Kape gagang" - dibaca Kapak gagang
  (7, 'Linggis Kecil', 'bh', 5, ''),
  (8, 'Linggis Besar', 'bh', 5, ''),
  (9, 'Arco', 'bh', 10, ''),
  (10, 'Scrap Pengupas Dinding', 'bh', 10, ''),  -- CEK: angka dibaca 10 (bisa 16)
  (11, 'Sekop', 'bh', 12, ''),
  (12, 'Pahat', 'bh', 10, '5 bh + 5 bh'),
  (13, 'Bor', 'bh', 1, ''),
  (14, 'Join Scaffolding', 'bh', 20, ''),
  (15, 'Cangkul', 'bh', 4, ''),  -- CEK: angka dibaca 4 (bisa 9)
  (16, 'Magic Com', 'bh', 10, ''),  -- CEK: angka dibaca 10 (bisa 15/16)
  (17, 'Karpet', 'bh', 25, ''),
  (18, 'Galon', 'bh', 15, ''),
  (19, 'Termos', 'bh', 3, ''),
  (20, 'Terminal', 'bh', 8, ''),
  (21, 'Kabel', 'roll', 4, ''),  -- CEK: angka dibaca 4 (bisa 9)
  (22, 'Roskam', 'bh', 10, ''),
  (23, 'Selang', 'm', 80, '30 m + 50 m'),
  (24, 'Ember', 'bh', 20, '10 bh + 10 (satuan kedua tidak jelas)'),  -- CEK: jumlah kedua dibaca bh
  (25, 'Meteran 50 m', 'bh', 10, ''),  -- CEK: tulisan tertimpa, dibaca 10
  (26, 'Meteran 7,5 m', 'bh', 4, ''),  -- CEK: angka dibaca 4 (bisa 9)
  (27, 'Masker', 'box', 1, ''),
  (28, 'Kawat Rem', 'm', 3, ''),
  (29, 'Sampah', 'pak', 2, ''),
  (30, 'Bot', 'bh', 5, ''),  -- CEK: satuan tidak tertulis, dianggap bh
  (31, 'Holo 3x1 (2 m)', 'bh', 8, ''),  -- CEK: satuan tidak tertulis, dianggap bh
  (32, 'Tangga', 'bh', 1, ''),  -- CEK: satuan tidak tertulis, dianggap bh
  (33, 'Gegep', 'bh', 2, ''),  -- CEK: satuan tidak tertulis, dianggap bh
  (34, 'Lampu Senter', 'bh', 2, ''),  -- CEK: satuan tidak tertulis, dianggap bh
  (35, 'Lot', 'bh', 3, ''),  -- CEK: satuan tidak tertulis, dianggap bh
  (36, 'P3K', 'bh', 1, '');  -- CEK: satuan tidak tertulis, dianggap bh

-- 1) Master Bahan: tambah yang belum ada (nama + satuan sama = dilewati). Kode BHN-### dilanjutkan otomatis.
SET @n := (SELECT COALESCE(MAX(CAST(SUBSTRING(kode, 5) AS UNSIGNED)), 0) FROM materials WHERE kode REGEXP '^BHN-[0-9]+$');
INSERT INTO materials (id, kode, nama, satuan, kategori)
SELECT CONCAT('mat_', SUBSTRING(MD5(UUID()), 1, 12)), CONCAT('BHN-', LPAD(@n := @n + 1, 3, '0')), t.nama, t.satuan, 'Peralatan'
  FROM inv_gudang t
 WHERE NOT EXISTS (SELECT 1 FROM materials m WHERE m.nama = t.nama COLLATE utf8mb4_unicode_ci AND m.satuan = t.satuan COLLATE utf8mb4_unicode_ci)
 ORDER BY t.no;

-- 2) Barang datang (stok masuk) per bahan; satu baris per bahan, tidak ditulis dua kali bila skrip diulang.
INSERT INTO material_receipts (id, project_id, material_id, tgl, qty, harga_satuan, vendor, no_referensi, ket)
SELECT CONCAT('rcp_', SUBSTRING(MD5(UUID()), 1, 12)), @pid, m.id, @tgl, t.qty, 0, 'Inventarisir awal', @ref,
       CONCAT('Inventarisir Alat Gudang Utara no. ', t.no, IF(t.ket = '', '', CONCAT(' (', t.ket, ')')))
  FROM inv_gudang t
  JOIN materials m ON m.nama = t.nama COLLATE utf8mb4_unicode_ci AND m.satuan = t.satuan COLLATE utf8mb4_unicode_ci
 WHERE @pid IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM material_receipts r WHERE r.project_id = @pid AND r.material_id = m.id AND r.no_referensi = @ref COLLATE utf8mb4_unicode_ci)
 ORDER BY t.no;

-- 3) CEK HASIL: harus 36 baris, selisih 0 untuk semua baris, dan total sesuai kertas.
SELECT IF(@pid IS NULL, 'PROYEK TIDAK DITEMUKAN - barang datang BELUM masuk. Perbaiki @proyek lalu jalankan ulang.', 'Proyek ditemukan') AS status;
SELECT t.no, t.nama, t.satuan, t.qty AS jumlah_kertas, COALESCE(SUM(r.qty), 0) AS jumlah_tersimpan, COALESCE(SUM(r.qty), 0) - t.qty AS selisih
  FROM inv_gudang t
  LEFT JOIN materials m ON m.nama = t.nama COLLATE utf8mb4_unicode_ci AND m.satuan = t.satuan COLLATE utf8mb4_unicode_ci
  LEFT JOIN material_receipts r ON r.material_id = m.id AND r.project_id = @pid AND r.no_referensi = @ref COLLATE utf8mb4_unicode_ci
 GROUP BY t.no, t.nama, t.satuan, t.qty ORDER BY t.no;
SELECT COUNT(*) AS jumlah_baris, SUM(t.qty) AS total_jumlah_kertas FROM inv_gudang t;
