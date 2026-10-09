-- Sinkronisasi transaksi dari Report export terbaru (s/d 8 Oktober 2026)
-- ke database. Dibandingkan ref-by-ref terhadap seluruh isi tabel
-- `transactions` (5.305 baris): 5.305 baris existing semuanya cocok
-- 100% (tanggal, akun kas, akun lawan, project, jumlah) -- tidak ada
-- satupun yang perlu di-UPDATE. Hanya ditemukan baris BARU, semuanya
-- bertanggal 8 Oktober 2026 -- transaksi hari terakhir yang belum
-- masuk database. Satu di antaranya ("BJB Riau") memakai nama project
-- yang belum ada di Master Project, jadi dibuatkan dulu baris minimal
-- (sama seperti project baru lain yang sudah ada -- edit/lengkapi lagi
-- lewat Master Project di aplikasi kalau perlu).
--
-- INSERT IGNORE di semua baris di bawah -- aman dijalankan ulang kalau
-- sebelumnya sempat berhenti di tengah jalan (baris yang sudah masuk
-- cuma dilewati, bukan error "Duplicate entry").
--
-- Kolom `relasi` (vendor/pemilik) tidak ada di file Report export ini,
-- jadi awalnya dikosongkan -- lalu ketahuan dari Laporan Hutang/Prive
-- sistem asli ada 2 vendor/pemilik yang jumlahnya beda dari sistem
-- buatan: V-HU-Berkat (asli lebih rendah Rp153.977.930) dan Pr-K (asli
-- lebih tinggi Rp1.710.000). Dicocokkan ke pola `ket` transaksi lain
-- yang sudah ada relasinya di database ("pak ei" -> selalu Pr-K, nota
-- "berkat" -> selalu V-HU-Berkat), dan sudah dikonfirmasi lewat
-- perhitungan ulang: isi relasi di bawah membuat kedua total itu cocok
-- 100% dengan sistem asli (158.060.291 dan 246.964.844).

INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_bjb_riau', 'BJB Riau', 'BJB Riau', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW());

-- 43 transaksi baru (8 Oktober 2026)
INSERT IGNORE INTO `transactions` (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `customer_id`, `vendor_id`, `ket`, `debet`, `kredit`, `created_by`, `created_at`, `updated_at`) VALUES
('t9acb7882bf64', 'bank_masuk', '2026-10-08', 'BI-2610-0004', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'Termen dustira ke 2', 808992493.0, 0.0, NULL, NOW(), NOW()),
('tdf84e4a41ff2', 'bank_masuk', '2026-10-08', 'BI-2610-0005', 'Bank BJB CV Purbayanti', 'Pendapatan Proyek', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', NULL, NULL, 'termen PL pengecatan', 192042308.0, 0.0, NULL, NOW(), NOW()),
('tdd54b5d020ed', 'bank_keluar', '2026-10-08', 'BO-2610-0009', 'Bank BJB RC PT', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', NULL, NULL, 'biaya pembuatan cek RC PT BJB (dari rek RC BJB PT)', 0.0, 275000.0, NULL, NOW(), NOW()),
('te896c8aa13b6', 'bank_keluar', '2026-10-08', 'BO-2610-0010', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'penarikan 8 oktober', 0.0, 472440100.0, NULL, NOW(), NOW()),
('t2ad04e357292', 'kas_masuk', '2026-10-08', 'CI-2610-0011', 'Kas Besar', 'Pendapatan Proyek', 'Zidam Bangun Rumdis Lebak Banten', '', NULL, NULL, 'termen ketiga sbsn', 1190551014.0, 0.0, NULL, NOW(), NOW()),
('t45cfe6e2b872', 'kas_masuk', '2026-10-08', 'CI-2610-0012', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'penarikan 8 oktober', 472440100.0, 0.0, NULL, NOW(), NOW()),
('t39b36127949b', 'kas_keluar', '2026-10-08', 'CO-2610-0386', 'Kas Besar', 'Biaya Panen', 'Farm Cibeureum periode 5', '', NULL, NULL, 'jatah panen warga cibeureum', 0.0, 400000.0, NULL, NOW(), NOW()),
('t83c2d8c62343', 'kas_keluar', '2026-10-08', 'CO-2610-0387', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', NULL, NULL, 'bayar servis motor 7/10', 0.0, 150000.0, NULL, NOW(), NOW()),
('t23f48f734e62', 'kas_keluar', '2026-10-08', 'CO-2610-0389', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', NULL, NULL, 'pak ei (jas)', 0.0, 1600000.0, NULL, NOW(), NOW()),
('tf471154ebecf', 'kas_keluar', '2026-10-08', 'CO-2610-0390', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', NULL, NULL, 'teh ai (pak ei)', 0.0, 110000.0, NULL, NOW(), NOW()),
('t5f6d55bcd8be', 'kas_keluar', '2026-10-08', 'CO-2610-0391', 'Kas Besar', 'Biaya ADM', 'ZIDAM', '', NULL, NULL, 'sumbangan HUT TNI', 0.0, 25002500.0, NULL, NOW(), NOW()),
('t39ae479f3075', 'kas_keluar', '2026-10-08', 'CO-2610-0392', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', NULL, NULL, 'kaso 7/10', 0.0, 5002500.0, NULL, NOW(), NOW()),
('td5401febf3f8', 'kas_keluar', '2026-10-08', 'CO-2610-0393', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', NULL, NULL, 'sewa scafolding', 0.0, 10564667.0, NULL, NOW(), NOW()),
('t4fe158b27f73', 'kas_keluar', '2026-10-08', 'CO-2610-0394', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', NULL, NULL, 'nota TB utama sudirman', 0.0, 4306500.0, NULL, NOW(), NOW()),
('t530da7bcf2e3', 'kas_keluar', '2026-10-08', 'CO-2610-0395', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', NULL, NULL, 'belanja tgl 8', 0.0, 9500000.0, NULL, NOW(), NOW()),
('t57767500a0bd', 'kas_keluar', '2026-10-08', 'CO-2610-0396', 'Kas Besar', 'Hutang Dagang', 'Bina Marga Kodim Bangun Jalan Cibalong', 'V-HU-Berkat', NULL, NULL, 'nota berkat cibalong 4/8 (besi 25)', 0.0, 106400000.0, NULL, NOW(), NOW()),
('tb9eca3df01c0', 'kas_keluar', '2026-10-08', 'CO-2610-0397', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', NULL, NULL, 'terpal, kaso, thinner, belmas', 0.0, 1094000.0, NULL, NOW(), NOW()),
('t60df44b9bad6', 'kas_keluar', '2026-10-08', 'CO-2610-0398', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangunan Heritage', '', NULL, NULL, 'cat gardex, kuas roll', 0.0, 3071000.0, NULL, NOW(), NOW()),
('tb5cf52cdf97c', 'kas_keluar', '2026-10-08', 'CO-2610-0399', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kabel, inbow dus, steker arde, stopkontak, flood light 7/10', 0.0, 2966000.0, NULL, NOW(), NOW()),
('t0541b8b3903d', 'kas_keluar', '2026-10-08', 'CO-2610-0400', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kasbon tim asep plafond', 0.0, 2000000.0, NULL, NOW(), NOW()),
('tdd338272e586', 'kas_keluar', '2026-10-08', 'CO-2610-0401', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'kompresor, jack hammer, operator', 0.0, 1450000.0, NULL, NOW(), NOW()),
('tea23fa532ed6', 'kas_keluar', '2026-10-08', 'CO-2610-0402', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'solar alat', 0.0, 350000.0, NULL, NOW(), NOW()),
('ta67e0953a57d', 'kas_keluar', '2026-10-08', 'CO-2610-0403', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'palu, pilox, multi, kasom paku, slepan, dll', 0.0, 3785000.0, NULL, NOW(), NOW()),
('t672ba6b6f63c', 'kas_keluar', '2026-10-08', 'CO-2610-0404', 'Kas Besar', 'Hutang Dagang', 'Bina Marga Rehab Jembatan Provinsi', 'V-HU-Berkat', NULL, NULL, 'nota berkat 19/8 besi ulir 13, 16, 19', 0.0, 47577930.0, NULL, NOW(), NOW()),
('t39476a64b676', 'kas_keluar', '2026-10-08', 'CO-2610-0405', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'banner', 0.0, 910000.0, NULL, NOW(), NOW()),
('t503a90e08c2a', 'kas_keluar', '2026-10-08', 'CO-2610-0406', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'rompi proyek', 0.0, 550000.0, NULL, NOW(), NOW()),
('t9f8fabcbbf08', 'kas_keluar', '2026-10-08', 'CO-2610-0407', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kloset', 0.0, 1400000.0, NULL, NOW(), NOW()),
('t929fa5fa3079', 'kas_keluar', '2026-10-08', 'CO-2610-0408', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'helm proyek', 0.0, 1269000.0, NULL, NOW(), NOW()),
('tffaaa82b1874', 'kas_keluar', '2026-10-08', 'CO-2610-0409', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kas', 0.0, 500000.0, NULL, NOW(), NOW()),
('tf868d7b58d9b', 'kas_keluar', '2026-10-08', 'CO-2610-0410', 'Kas Besar', 'Biaya entertain', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'nasi padang tamu', 0.0, 3232000.0, NULL, NOW(), NOW()),
('ta1819d75448e', 'kas_keluar', '2026-10-08', 'CO-2610-0411', 'Kas Besar', 'Biaya entertain', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'duren', 0.0, 1751000.0, NULL, NOW(), NOW()),
('tf424ffc6a8a9', 'kas_keluar', '2026-10-08', 'CO-2610-0412', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'op direksi 8/10', 0.0, 1000000.0, NULL, NOW(), NOW()),
('t3345cc795605', 'kas_keluar', '2026-10-08', 'CO-2610-0413', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'op pa fahri 7/10', 0.0, 1000000.0, NULL, NOW(), NOW()),
('t5cb66699d794', 'kas_keluar', '2026-10-08', 'CO-2610-0414', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'tambahan op yuki', 0.0, 500000.0, NULL, NOW(), NOW()),
('t5e75ab4c5a0b', 'kas_keluar', '2026-10-08', 'CO-2610-0415', 'Kas Besar', 'Biaya ADM', 'Zidam Bangun Rumdis Lebak Banten', '', NULL, NULL, 'biaya adm photocopy 100%', 0.0, 1502500.0, NULL, NOW(), NOW()),
('tf97fec14d919', 'kas_keluar', '2026-10-08', 'CO-2610-0416', 'Kas Besar', 'Biaya ADM', 'ZIDAM', '', NULL, NULL, 'OP Kodam III', 0.0, 10002500.0, NULL, NOW(), NOW()),
('tb6d0c4871ee7', 'kas_keluar', '2026-10-08', 'CO-2610-0417', 'Kas Besar', 'Biaya Bahan', 'BJB Riau', '', NULL, NULL, 'kcp riau bjb', 0.0, 108544400.0, NULL, NOW(), NOW()),
('t0b5564539611', 'kas_keluar', '2026-10-08', 'CO-2610-0418', 'Kas Besar', 'Biaya Upah', 'Zidam Renov Rumdis Bogor', '', NULL, NULL, 'penarikan ke 3 (progres 30.15%)', 0.0, 94143603.0, NULL, NOW(), NOW()),
('t8fc53c4a1f98', 'kas_keluar', '2026-10-08', 'CO-2610-0419', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', NULL, NULL, 'kasbon baja penarikan ke 3 (progres 30.15%)', 0.0, 17000000.0, NULL, NOW(), NOW()),
('t6f997fee976a', 'kas_keluar', '2026-10-08', 'CO-2610-0420', 'Kas Besar', 'Biaya entertain', 'Zidam Renov Rumdis Bogor', '', NULL, NULL, 'konsumsi tamu', 0.0, 1485000.0, NULL, NOW(), NOW()),
('t8e5de4d99e56', 'kas_keluar', '2026-10-08', 'CO-2610-0421', 'Kas Besar', 'Biaya ADM Fee', 'Zidam Bangun Rumdis Lebak Banten', '', NULL, NULL, 'dako 100%', 0.0, 95246581.0, NULL, NOW(), NOW()),
('t9f41ff0c6610', 'kas_keluar', '2026-10-08', 'CO-2610-0422', 'Kas Besar', 'Hutang Bank Jk.Pendek PT', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'Bayar kelayakan SBSN', 0.0, 1095304433.0, NULL, NOW(), NOW()),
('t50737856d9f6', 'kas_keluar', '2026-10-08', 'CO-2610-0423', 'Kas Besar', 'Atensi', 'ZIDAM', '', NULL, NULL, 'bayaran pesantren parigi', 0.0, 2320000.0, NULL, NOW(), NOW());

-- 2 transaksi Bank In/Out tambahan (8 Oktober) yang belum sempat masuk
-- ke file Report saat diexport, ketahuan dari perbandingan Dashboard
-- Cash Flow sistem asli -- Bapak kirim datanya langsung dari layar
-- Data Bank In/Out sistem asli:
--  - BI-2610-0006: selisih Kas Masuk Rp877.988
--  - BO-2610-0011: selisih Kas Keluar Rp195.598
INSERT IGNORE INTO `transactions` (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `customer_id`, `vendor_id`, `ket`, `debet`, `kredit`, `created_by`, `created_at`, `updated_at`) VALUES
('tbi26100006bg', 'bank_masuk', '2026-10-08', 'BI-2610-0006', 'Bank BNI PT', 'Pendapatan Jasa Giro', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'bunga giro', 877988.0, 0.0, NULL, NOW(), NOW()),
('tbo26100011bg', 'bank_keluar', '2026-10-08', 'BO-2610-0011', 'Bank BNI PT', 'Biaya Bunga & Administrasi Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'biaya adm bank', 0.0, 195598.0, NULL, NOW(), NOW());

-- Cek hasilnya:
SELECT COUNT(*) AS total_setelah_insert FROM `transactions`;
-- Harus 5305 + 43 + 2 = 5350
