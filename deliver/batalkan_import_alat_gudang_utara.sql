-- BATALKAN import_alat_gudang_utara.sql (hanya yang dibuat oleh import itu).
-- Jalankan lewat phpMyAdmin > pilih database YANG SAMA dengan tempat import dijalankan > tab SQL.
-- Aman: barang datang dihapus hanya yang bernomor referensi INV-GUDANG-UTARA; bahan dihapus hanya yang
-- berkategori 'Peralatan', ada di daftar 36 itu, dan TIDAK dipakai di transaksi lain
-- (barang datang lain, pemakaian, hitung stok, RAP). Bahan yang sudah dipakai di tempat lain dibiarkan.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET @ref := 'INV-GUDANG-UTARA';

SELECT COUNT(*) AS barang_datang_sebelum FROM material_receipts WHERE no_referensi = @ref COLLATE utf8mb4_unicode_ci;

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


-- 1) Hapus barang datang hasil import
DELETE FROM material_receipts WHERE no_referensi = @ref COLLATE utf8mb4_unicode_ci AND vendor = 'Inventarisir awal' COLLATE utf8mb4_unicode_ci;

-- 2) Hapus bahan yang dibuat import dan tidak dipakai di tempat lain
DELETE m FROM materials m
  JOIN inv_gudang t ON m.nama = t.nama COLLATE utf8mb4_unicode_ci AND m.satuan = t.satuan COLLATE utf8mb4_unicode_ci
 WHERE m.kategori = 'Peralatan' COLLATE utf8mb4_unicode_ci
   AND NOT EXISTS (SELECT 1 FROM material_receipts x WHERE x.material_id = m.id)
   AND NOT EXISTS (SELECT 1 FROM material_usage x WHERE x.material_id = m.id)
   AND NOT EXISTS (SELECT 1 FROM stock_counts x WHERE x.material_id = m.id)
   AND NOT EXISTS (SELECT 1 FROM rap_material x WHERE x.material_id = m.id)
   AND NOT EXISTS (SELECT 1 FROM rap_bahan_proyek x WHERE x.material_id = m.id);

-- 3) CEK: dua angka ini harus 0 (bahan yang tersisa di sini berarti sudah dipakai di transaksi lain, sengaja tidak dihapus)
SELECT COUNT(*) AS barang_datang_tersisa FROM material_receipts WHERE no_referensi = @ref COLLATE utf8mb4_unicode_ci;
SELECT COUNT(*) AS bahan_tersisa_dari_daftar FROM materials m JOIN inv_gudang t ON m.nama = t.nama COLLATE utf8mb4_unicode_ci AND m.satuan = t.satuan COLLATE utf8mb4_unicode_ci WHERE m.kategori = 'Peralatan' COLLATE utf8mb4_unicode_ci;
