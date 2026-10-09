-- Sinkronisasi transaksi + jurnal umum dari Report export terbaru
-- (s/d 9 Oktober 2026), dibandingkan ref-by-ref terhadap seluruh isi
-- tabel `transactions` (5.305 baris existing) + 45 baris yang sudah
-- disinkronkan sebelumnya lewat sync_transactions_okt8_2026.sql (baik
-- sudah dijalankan atau belum -- INSERT IGNORE di bawah aman dipakai
-- dua-duanya, tidak akan dobel).
--
-- Ditemukan:
--  1) 112 transaksi BARU, semuanya kas_keluar bertanggal 9
--     Oktober 2026 (hari terakhir yang belum masuk database).
--  2) 5 bukti jurnal umum BARU (JU26100114..JU26100118, 9 Oktober 2026,
--     semuanya project Farm Cibeureum periode 5) -- detail baris akun
--     per voucher sesuai yang dikonfirmasi dari modal 'Detail Jurnal'.
--  3) 19 PENYESUAIAN kategori pada data yang SUDAH ada di database:
--     sistem asli mereklasifikasi project (13 baris, mayoritas dari
--     'Farm Cibeureum' generik -> 'Farm Cibeureum periode 5') dan akun
--     lawan (6 baris, mis. 'Peralatan Kandang' -> 'Biaya Perlengkapan
--     Kandang') pada transaksi yang jumlah/tanggal/keterangannya TIDAK
--     berubah -- hanya kategorinya dibetulkan (satu ref, CO-2609-0134,
--     punya kedua jenis penyesuaian sekaligus). UPDATE di bawah
--     idempotent (aman dijalankan berkali-kali).
--  4) 4 pembetulan kecil pada kolom keterangan (karakter tanda kutip
--     yang sebelumnya tersimpan dengan backslash berlebih, dan satu
--     keterangan yang diperjelas sistem asli dari 'pelunasan pintu'
--     jadi 'pelunasan bahan pintu') -- tidak memengaruhi angka apapun.
--
-- Data yang SUDAH benar (Trial Balance, Neraca, Laba Rugi, Hutang,
-- Prive, dan logika index.html) TIDAK disentuh sama sekali oleh file ini.

-- Project baru yang direferensikan transaksi 9 Oktober, belum ada di Master Project
INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_armed', 'Armed', 'Armed', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW()),
       ('p_farm_cibeureum_periode_6', 'Farm Cibeureum periode 6', 'Farm Cibeureum periode 6', 0.00, 0.00, NULL, 'Farm', 0.00, 0.00, NOW());

-- 112 transaksi baru (9 Oktober 2026)
INSERT IGNORE INTO `transactions` (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `customer_id`, `vendor_id`, `ket`, `debet`, `kredit`, `created_by`, `created_at`, `updated_at`) VALUES
('t2fa31df6f2d5', 'kas_keluar', '2026-10-09', 'CO-2610-0424', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cilame 1 periode 5', '', NULL, NULL, 'ongkos pelet, cilame 1', 0.0, 1502500.0, NULL, NOW(), NOW()),
('tf086e8712160', 'kas_keluar', '2026-10-09', 'CO-2610-0425', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', NULL, NULL, 'nota matrial listrik 24/9, cilame 1', 0.0, 390000.0, NULL, NOW(), NOW()),
('td97b43eaf4f9', 'kas_keluar', '2026-10-09', 'CO-2610-0426', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 2 periode 5', '', NULL, NULL, 'nota matrial listrik 30/9 cilame 2', 0.0, 3075000.0, NULL, NOW(), NOW()),
('ta8a615d42412', 'kas_keluar', '2026-10-09', 'CO-2610-0427', 'Kas Besar', 'Biaya Cuci Kandang', 'Farm Cibeureum periode 6', '', NULL, NULL, 'daia 6bks cibeureum', 0.0, 347400.0, NULL, NOW(), NOW()),
('t88230cacd520', 'kas_keluar', '2026-10-09', 'CO-2610-0428', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 2 periode 5', '', NULL, NULL, 'kas pak deni cilame 2', 0.0, 821000.0, NULL, NOW(), NOW()),
('td7429c44ef75', 'kas_keluar', '2026-10-09', 'CO-2610-0429', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', NULL, NULL, 'bensin gupron 1/10', 0.0, 40000.0, NULL, NOW(), NOW()),
('t7d7820731470', 'kas_keluar', '2026-10-09', 'CO-2610-0430', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', NULL, NULL, 'bensin rendi 8/10', 0.0, 30000.0, NULL, NOW(), NOW()),
('t5e3bb2ede7b3', 'kas_keluar', '2026-10-09', 'CO-2610-0431', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', NULL, NULL, 'biaya trf', 0.0, 17500.0, NULL, NOW(), NOW()),
('t0e6898171309', 'kas_keluar', '2026-10-09', 'CO-2610-0432', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Cost Center', '', NULL, NULL, 'listrik suci 1/10', 0.0, 101500.0, NULL, NOW(), NOW()),
('tb24736994cdb', 'kas_keluar', '2026-10-09', 'CO-2610-0433', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', NULL, NULL, 'kopi, rokok lembur 8/10', 0.0, 87900.0, NULL, NOW(), NOW()),
('t71c80e814eaa', 'kas_keluar', '2026-10-09', 'CO-2610-0434', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Cost Center', '', NULL, NULL, 'nota matrial lsitrik 22/9', 0.0, 225000.0, NULL, NOW(), NOW()),
('t3d1d4b08ea6a', 'kas_keluar', '2026-10-09', 'CO-2610-0435', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', NULL, NULL, 'bayaran komeng 2-8 okt', 0.0, 1158000.0, NULL, NOW(), NOW()),
('t03056c74da11', 'kas_keluar', '2026-10-09', 'CO-2610-0436', 'Kas Besar', 'Biaya Upah2', 'Pangalengan', '', NULL, NULL, 'idang pangalengan 2 hari', 0.0, 400000.0, NULL, NOW(), NOW()),
('tc492d1d41b3d', 'kas_keluar', '2026-10-09', 'CO-2610-0437', 'Kas Besar', 'Prive', 'Prive', '', NULL, NULL, 'bayaran dede (pa rajab)', 0.0, 1500000.0, NULL, NOW(), NOW()),
('ta15266ed7903', 'kas_keluar', '2026-10-09', 'CO-2610-0438', 'Kas Besar', 'Prive', 'Prive', '', NULL, NULL, 'd.okeh albey 8/10 (pak zam)', 0.0, 20000.0, NULL, NOW(), NOW()),
('td96347738a1d', 'kas_keluar', '2026-10-09', 'CO-2610-0439', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Jembatan Pusziad', '', NULL, NULL, 'op. gupron (spj) 5/10', 0.0, 100000.0, NULL, NOW(), NOW()),
('t1180d8f48332', 'kas_keluar', '2026-10-09', 'CO-2610-0440', 'Kas Besar', 'Biaya Bahan', 'ZIDAM', '', NULL, NULL, 'pelunasan Bangku (atn)', 0.0, 3402500.0, NULL, NOW(), NOW()),
('t29cbc46e6e49', 'kas_keluar', '2026-10-09', 'CO-2610-0441', 'Kas Besar', 'Biaya Upah', 'RS Guntur Gudang Farmasi', '', NULL, NULL, 'H dana', 0.0, 55000000.0, NULL, NOW(), NOW()),
('t5711dc4791c0', 'kas_keluar', '2026-10-09', 'CO-2610-0442', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'h dana', 0.0, 15000000.0, NULL, NOW(), NOW()),
('t98d662a11ee1', 'kas_keluar', '2026-10-09', 'CO-2610-0443', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'keramik, wc, kloset, dll', 0.0, 6736400.0, NULL, NOW(), NOW()),
('te979cd70e44e', 'kas_keluar', '2026-10-09', 'CO-2610-0444', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', NULL, NULL, 'belanja tgl 9', 0.0, 7500000.0, NULL, NOW(), NOW()),
('t9fef344b739d', 'kas_keluar', '2026-10-09', 'CO-2610-0445', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'semen', 0.0, 42480000.0, NULL, NOW(), NOW()),
('t4b142b161830', 'kas_keluar', '2026-10-09', 'CO-2610-0446', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'babinsa, danpos tuud 7 hari x 400 rb', 0.0, 2800000.0, NULL, NOW(), NOW()),
('tb86ce2d4384a', 'kas_keluar', '2026-10-09', 'CO-2610-0447', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'tambahan babinsa 2, danpos (300x7)', 0.0, 2100000.0, NULL, NOW(), NOW()),
('tcac0df762e2a', 'kas_keluar', '2026-10-09', 'CO-2610-0448', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'kas dadan (tambal ban, ganti pentil ban penter, gas, bensin)', 0.0, 207000.0, NULL, NOW(), NOW()),
('taad7237d7571', 'kas_keluar', '2026-10-09', 'CO-2610-0449', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'kas dadan (air galon)', 0.0, 120000.0, NULL, NOW(), NOW()),
('tfeb9ab32878f', 'kas_keluar', '2026-10-09', 'CO-2610-0450', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'kas dadan (uang bongkar semen, bensin pompa air, busit lem)', 0.0, 665000.0, NULL, NOW(), NOW()),
('t98efe38a36f1', 'kas_keluar', '2026-10-09', 'CO-2610-0451', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'pasir cor 3-8 okt', 0.0, 79718000.0, NULL, NOW(), NOW()),
('t97405b741593', 'kas_keluar', '2026-10-09', 'CO-2610-0452', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'bayaran tim jaga alat 2-8 Okt', 0.0, 1400000.0, NULL, NOW(), NOW()),
('tca0c0ba15a64', 'kas_keluar', '2026-10-09', 'CO-2610-0453', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'bayaran tim cihelang 2-8 Okt', 0.0, 8190000.0, NULL, NOW(), NOW()),
('t3e899616dbc6', 'kas_keluar', '2026-10-09', 'CO-2610-0454', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'bayaran tim garut 2-8 Okt', 0.0, 12297500.0, NULL, NOW(), NOW()),
('tf1cab5781fa2', 'kas_keluar', '2026-10-09', 'CO-2610-0455', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'bayaran tim pabrikasi 2-8 Okt', 0.0, 1370000.0, NULL, NOW(), NOW()),
('te48ab5f44b42', 'kas_keluar', '2026-10-09', 'CO-2610-0456', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'bayaran operator beko 2-8 Okt', 0.0, 2070000.0, NULL, NOW(), NOW()),
('t96a7d932f1b7', 'kas_keluar', '2026-10-09', 'CO-2610-0457', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'bayaran operator mixer 2-8 Okt', 0.0, 2110000.0, NULL, NOW(), NOW()),
('t46cc5760d27d', 'kas_keluar', '2026-10-09', 'CO-2610-0458', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'nota matrial lsitrik 21-25/9', 0.0, 5930000.0, NULL, NOW(), NOW()),
('tac691196e8d6', 'kas_keluar', '2026-10-09', 'CO-2610-0459', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'bayaran pekerja tim anang 2-8 okt', 0.0, 15486500.0, NULL, NOW(), NOW()),
('td5270015f37c', 'kas_keluar', '2026-10-09', 'CO-2610-0460', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kekurangan bayaran dustira minggu lalu (pekerja rumdis)', 0.0, 550000.0, NULL, NOW(), NOW()),
('t4cc00c7eabe0', 'kas_keluar', '2026-10-09', 'CO-2610-0461', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'putra', 0.0, 35000000.0, NULL, NOW(), NOW()),
('tb3924db314b9', 'kas_keluar', '2026-10-09', 'CO-2610-0462', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'opname granit lantai', 0.0, 1292850.0, NULL, NOW(), NOW()),
('t4d936f834aa6', 'kas_keluar', '2026-10-09', 'CO-2610-0463', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'opname dinding selasar', 0.0, 1202700.0, NULL, NOW(), NOW()),
('tf2943610c3ca', 'kas_keluar', '2026-10-09', 'CO-2610-0464', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'opname granit dinding wc', 0.0, 171120.0, NULL, NOW(), NOW()),
('t36ae75b45e6f', 'kas_keluar', '2026-10-09', 'CO-2610-0465', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'borong langsir pasir', 0.0, 600000.0, NULL, NOW(), NOW()),
('ta17c2b10faab', 'kas_keluar', '2026-10-09', 'CO-2610-0466', 'Kas Besar', 'Biaya entertain', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kas arya (rokok minum kaur)', 0.0, 96000.0, NULL, NOW(), NOW()),
('t430a8fc6bf3e', 'kas_keluar', '2026-10-09', 'CO-2610-0467', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kas fikri (karung, ongkir alum.foil, kuas, paku, bubble alum.foil, dll)', 0.0, 1417500.0, NULL, NOW(), NOW()),
('tb93440c7c590', 'kas_keluar', '2026-10-09', 'CO-2610-0468', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kasbon pak nanang listrik', 0.0, 2000000.0, NULL, NOW(), NOW()),
('t64e7233c19fc', 'kas_keluar', '2026-10-09', 'CO-2610-0469', 'Kas Besar', 'Biaya Upah', 'Proyek Antapani', '', NULL, NULL, 'bayaran pekerja 2-8 okt', 0.0, 636000.0, NULL, NOW(), NOW()),
('tcbb162451738', 'kas_keluar', '2026-10-09', 'CO-2610-0470', 'Kas Besar', 'Biaya Upah', 'Proyek Antapani', '', NULL, NULL, 'Kasbon tim pak dadang', 0.0, 2000000.0, NULL, NOW(), NOW()),
('t79388dd71d77', 'kas_keluar', '2026-10-09', 'CO-2610-0471', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', NULL, NULL, 'kas arya (ongkos pekerja)', 0.0, 250000.0, NULL, NOW(), NOW()),
('t2a0070786dcc', 'kas_keluar', '2026-10-09', 'CO-2610-0472', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', NULL, NULL, 'kas arya (matabor, isi kater, lakban, paku beton, ongkir wf)', 0.0, 484000.0, NULL, NOW(), NOW()),
('t346e05c4ebab', 'kas_keluar', '2026-10-09', 'CO-2610-0473', 'Kas Besar', 'Biaya Upah', 'Asmira Dustira', '', NULL, NULL, 'Iqbal asmira', 0.0, 20000000.0, NULL, NOW(), NOW()),
('t30725174bf83', 'kas_keluar', '2026-10-09', 'CO-2610-0474', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', NULL, NULL, 'DP AC', 0.0, 30000000.0, NULL, NOW(), NOW()),
('tf71db4e7cc1e', 'kas_keluar', '2026-10-09', 'CO-2610-0475', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', NULL, NULL, 'kas fikri (sealant) ruang asoka', 0.0, 42500.0, NULL, NOW(), NOW()),
('t728f94f56f94', 'kas_keluar', '2026-10-09', 'CO-2610-0476', 'Kas Besar', 'Biaya Upah', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', NULL, NULL, 'bayaran pekerja 2-8 okt', 0.0, 636000.0, NULL, NOW(), NOW()),
('ta5f3a07dfa63', 'kas_keluar', '2026-10-09', 'CO-2610-0477', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangunan Heritage', '', NULL, NULL, 'opname tim usep', 0.0, 8380113.0, NULL, NOW(), NOW()),
('t1b464853fdf8', 'kas_keluar', '2026-10-09', 'CO-2610-0478', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangunan Heritage', '', NULL, NULL, 'opname tim dani', 0.0, 9927389.0, NULL, NOW(), NOW()),
('t7fc1a1339a6b', 'kas_keluar', '2026-10-09', 'CO-2610-0479', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangunan Heritage', '', NULL, NULL, 'kas fikri (kawat, lem, ember, lakban kertas, kuas, dll)', 0.0, 762500.0, NULL, NOW(), NOW()),
('tcdf6a0f0cff3', 'kas_keluar', '2026-10-09', 'CO-2610-0480', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangunan Heritage', '', NULL, NULL, 'kas fikri (makan lembur pekerja)', 0.0, 257000.0, NULL, NOW(), NOW()),
('ta85f744bdf7d', 'kas_keluar', '2026-10-09', 'CO-2610-0481', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangunan Heritage', '', NULL, NULL, 'kas fikri (bensin fikri, bensin verza)', 0.0, 180200.0, NULL, NOW(), NOW()),
('t152eca151e1c', 'kas_keluar', '2026-10-09', 'CO-2610-0482', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Korem Cirebon', '', NULL, NULL, 'opname pek. alumunium & pintu korem cirebon 40jt, potong kasbon 25jt', 0.0, 15000000.0, NULL, NOW(), NOW()),
('t99d85b5a8992', 'kas_keluar', '2026-10-09', 'CO-2610-0483', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Kodim Cirebon', '', NULL, NULL, 'opname pek. alumunium & pintu kodim cirebon', 0.0, 8000000.0, NULL, NOW(), NOW()),
('t4d9f4eb8ea11', 'kas_keluar', '2026-10-09', 'CO-2610-0484', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Korem Cirebon', '', NULL, NULL, 'bayaran korem cirebon', 0.0, 768000.0, NULL, NOW(), NOW()),
('t77ba7e9767bd', 'kas_keluar', '2026-10-09', 'CO-2610-0485', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'Opname kopel 1-5, septian', 0.0, 72582130.0, NULL, NOW(), NOW()),
('t4f680fd1cdd5', 'kas_keluar', '2026-10-09', 'CO-2610-0486', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'kasbon tim baja', 0.0, 4000000.0, NULL, NOW(), NOW()),
('t34a9d9cc465a', 'kas_keluar', '2026-10-09', 'CO-2610-0487', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'septic tank subang 20', 0.0, 26000000.0, NULL, NOW(), NOW()),
('t719c5cfc53d1', 'kas_keluar', '2026-10-09', 'CO-2610-0488', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'Semen 200 sak dan kumpon', 0.0, 9350000.0, NULL, NOW(), NOW()),
('t5cb9016366c1', 'kas_keluar', '2026-10-09', 'CO-2610-0489', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'bayaran pekerja 2-8 okt', 0.0, 28675000.0, NULL, NOW(), NOW()),
('t169b4d7c13b1', 'kas_keluar', '2026-10-09', 'CO-2610-0490', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'septictank cimahi 16', 0.0, 20800000.0, NULL, NOW(), NOW()),
('t52a20f21f400', 'kas_keluar', '2026-10-09', 'CO-2610-0491', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'nota matrial listrik 1/10', 0.0, 7100000.0, NULL, NOW(), NOW()),
('t688894ab1c81', 'kas_keluar', '2026-10-09', 'CO-2610-0492', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'ram kawat, ember, benang singkup', 0.0, 765000.0, NULL, NOW(), NOW()),
('tf731a391596f', 'kas_keluar', '2026-10-09', 'CO-2610-0493', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'bata ringan, perekat, holo, paku beton', 0.0, 5745500.0, NULL, NOW(), NOW()),
('t65355cea16bc', 'kas_keluar', '2026-10-09', 'CO-2610-0494', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kas arya (bensin)', 0.0, 99000.0, NULL, NOW(), NOW()),
('t7adbe572c85b', 'kas_keluar', '2026-10-09', 'CO-2610-0495', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kas arya (sealant, ongkir)', 0.0, 261000.0, NULL, NOW(), NOW()),
('tc7a38fbcb57b', 'kas_keluar', '2026-10-09', 'CO-2610-0496', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kas arya (ongkos pekerja, karpet pekerja)', 0.0, 875000.0, NULL, NOW(), NOW()),
('tcf34e7ee5c68', 'kas_keluar', '2026-10-09', 'CO-2610-0497', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kasbon egi cimahi', 0.0, 16500000.0, NULL, NOW(), NOW()),
('t1dded4538a1e', 'kas_keluar', '2026-10-09', 'CO-2610-0498', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', NULL, NULL, 'kasbon tim jalan subang', 0.0, 2000000.0, NULL, NOW(), NOW()),
('tcc62aceaf0b6', 'kas_keluar', '2026-10-09', 'CO-2610-0499', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', NULL, NULL, 'kasbon tim uditch subang', 0.0, 8000000.0, NULL, NOW(), NOW()),
('t82c2ddc6e678', 'kas_keluar', '2026-10-09', 'CO-2610-0500', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', NULL, NULL, 'uang makan operator dan solar subang', 0.0, 3500000.0, NULL, NOW(), NOW()),
('t49ace9b69328', 'kas_keluar', '2026-10-09', 'CO-2610-0501', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'safety', 0.0, 2870000.0, NULL, NOW(), NOW()),
('t6baee840f027', 'kas_keluar', '2026-10-09', 'CO-2610-0502', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'multi', 0.0, 8085000.0, NULL, NOW(), NOW()),
('t6894f9385628', 'kas_keluar', '2026-10-09', 'CO-2610-0503', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'ongkos multi', 0.0, 800000.0, NULL, NOW(), NOW()),
('t8f5efd73012b', 'kas_keluar', '2026-10-09', 'CO-2610-0504', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'solar', 0.0, 500000.0, NULL, NOW(), NOW()),
('t8bac616f93a1', 'kas_keluar', '2026-10-09', 'CO-2610-0505', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'pasir cor, semen, besi 10, besi 8, kawat beton', 0.0, 3748000.0, NULL, NOW(), NOW()),
('t082e56742d07', 'kas_keluar', '2026-10-09', 'CO-2610-0506', 'Kas Besar', 'Biaya Upah', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'upah asep/yudi', 0.0, 24100000.0, NULL, NOW(), NOW()),
('tc25a9602447e', 'kas_keluar', '2026-10-09', 'CO-2610-0507', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'mingguan pengamanan', 0.0, 3500000.0, NULL, NOW(), NOW()),
('ta326ccd99e82', 'kas_keluar', '2026-10-09', 'CO-2610-0508', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'mingguan pengamanan 2', 0.0, 1500000.0, NULL, NOW(), NOW()),
('tfb25ea4491f6', 'kas_keluar', '2026-10-09', 'CO-2610-0509', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'basecouse, dll', 0.0, 15440000.0, NULL, NOW(), NOW()),
('t8d2037ffe305', 'kas_keluar', '2026-10-09', 'CO-2610-0510', 'Kas Besar', 'Biaya Dibayar Dimuka', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'kas pak asep', 0.0, 500000.0, NULL, NOW(), NOW()),
('tf545b717ef4c', 'kas_keluar', '2026-10-09', 'CO-2610-0511', 'Kas Besar', 'Biaya Upah', 'BJB Rehab Rumdis Caringin', '', NULL, NULL, 'bayaran pekerja caringin 2-8 okt', 0.0, 535000.0, NULL, NOW(), NOW()),
('t34d7d04b70ce', 'kas_keluar', '2026-10-09', 'CO-2610-0512', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'upah dan ongkos pekerja', 0.0, 2702500.0, NULL, NOW(), NOW()),
('t209c40523cb3', 'kas_keluar', '2026-10-09', 'CO-2610-0513', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kabel hdmi', 0.0, 220000.0, NULL, NOW(), NOW()),
('t7cbfe0721b1f', 'kas_keluar', '2026-10-09', 'CO-2610-0514', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'upah pekerja H dana (di tarik dari gudkesrah)', 0.0, 225000.0, NULL, NOW(), NOW()),
('t5832f6d24b05', 'kas_keluar', '2026-10-09', 'CO-2610-0515', 'Kas Besar', 'Biaya ADM', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kas arya (a4 + gosend)', 0.0, 168000.0, NULL, NOW(), NOW()),
('t90538efb004e', 'kas_keluar', '2026-10-09', 'CO-2610-0516', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kas fikri (kirim lampu sorot ke gudut)', 0.0, 35890.0, NULL, NOW(), NOW()),
('t90d93485714b', 'kas_keluar', '2026-10-09', 'CO-2610-0517', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'upah pekerja (dari patrakomala)', 0.0, 3596000.0, NULL, NOW(), NOW()),
('t37520ca60967', 'kas_keluar', '2026-10-09', 'CO-2610-0518', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kasbon pekerja borongan tim pagar', 0.0, 6000000.0, NULL, NOW(), NOW()),
('tdae0e2ea67e2', 'kas_keluar', '2026-10-09', 'CO-2610-0519', 'Kas Besar', 'Biaya Akomodasi', 'RS Cirebon', '', NULL, NULL, 'kas fikri (ongkos pekerja dustira ke ciremai, kopi rokok)', 0.0, 520000.0, NULL, NOW(), NOW()),
('ta215f48ce5fd', 'kas_keluar', '2026-10-09', 'CO-2610-0520', 'Kas Besar', 'Biaya Upah2', 'RS Cirebon', '', NULL, NULL, 'kas fikri (jasa pasang ac)', 0.0, 150000.0, NULL, NOW(), NOW()),
('t2193e522963c', 'kas_keluar', '2026-10-09', 'CO-2610-0521', 'Kas Besar', 'Biaya ADM', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'ADM termen', 0.0, 3000000.0, NULL, NOW(), NOW()),
('t03bb26c82c4c', 'kas_keluar', '2026-10-09', 'CO-2610-0522', 'Kas Besar', 'Biaya Upah', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'H dana', 0.0, 70000000.0, NULL, NOW(), NOW()),
('t7478cea3f185', 'kas_keluar', '2026-10-09', 'CO-2610-0523', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'op. gupron termin 1 6/10', 0.0, 618000.0, NULL, NOW(), NOW()),
('t87d655628498', 'kas_keluar', '2026-10-09', 'CO-2610-0524', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'etoll op. gupron 6/10', 0.0, 100000.0, NULL, NOW(), NOW()),
('t75533f1a1c83', 'kas_keluar', '2026-10-09', 'CO-2610-0525', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'op. gupron termin 1 8/10', 0.0, 436000.0, NULL, NOW(), NOW()),
('tb997c8f5de11', 'kas_keluar', '2026-10-09', 'CO-2610-0526', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'nota matrial listrik 23/9 - 3/10', 0.0, 19580000.0, NULL, NOW(), NOW()),
('t90d8c800058e', 'kas_keluar', '2026-10-09', 'CO-2610-0527', 'Kas Besar', 'Biaya Bahan', 'KDMP Pasar Baru Andir', '', NULL, NULL, 'kas fikri (kirim scafolding ke andir)', 0.0, 82578.0, NULL, NOW(), NOW()),
('tc8e852e8042c', 'kas_keluar', '2026-10-09', 'CO-2610-0528', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Zidam Bangun Rumdis Lebak Banten', '', NULL, NULL, 'OP gupron termin 3 sbsn 7/10', 0.0, 676000.0, NULL, NOW(), NOW()),
('t80ffae3953bb', 'kas_keluar', '2026-10-09', 'CO-2610-0529', 'Kas Besar', 'Biaya ADM', 'Zidam Bangun Rumdis Lebak Banten', '', NULL, NULL, 'jamhar', 0.0, 8570000.0, NULL, NOW(), NOW()),
('t96425c93fb6c', 'kas_keluar', '2026-10-09', 'CO-2610-0530', 'Kas Besar', 'Biaya Bahan', 'Zidam Bangun Rumdis Lebak Banten', '', NULL, NULL, 'nota LBS', 0.0, 1137000.0, NULL, NOW(), NOW()),
('t04e078ff5b2e', 'kas_keluar', '2026-10-09', 'CO-2610-0531', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Armed', '', NULL, NULL, 'OP ke Armed direksi 9/10', 0.0, 1500000.0, NULL, NOW(), NOW()),
('t501709c5c82b', 'kas_keluar', '2026-10-09', 'CO-2610-0532', 'Kas Besar', 'Biaya ADM', 'ZIDAM', '', NULL, NULL, 'danki 4 bln', 0.0, 10000000.0, NULL, NOW(), NOW()),
('t609eb54e045c', 'kas_keluar', '2026-10-09', 'CO-2610-0533', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', NULL, NULL, 'sisa progres rina 10%', 0.0, 38836252.0, NULL, NOW(), NOW()),
('teaaec04f991b', 'kas_keluar', '2026-10-09', 'CO-2610-0534', 'Kas Besar', 'Beban Pajak Badan', 'Farm Cilame 1 periode 5', '', NULL, NULL, 'cadangan pph cilame 1', 0.0, 5559346.0, NULL, NOW(), NOW()),
('t3426cc56e2a6', 'kas_keluar', '2026-10-09', 'CO-2610-0535', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kas arya (makan pekerja)', 0.0, 114000.0, NULL, NOW(), NOW());

-- 5 bukti jurnal umum baru (9 Oktober 2026), 13 baris akun total
INSERT IGNORE INTO `jurnal_umum` (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`, `created_by`, `created_at`, `updated_at`) VALUES
('j59c4ae2b678', '2026-10-09', 'JU26100114', 'Biaya Listrik, Air & Telepon', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'tagihan listrik bulan september', 9583043.0, 0.0, NULL, NOW(), NOW()),
('j0602bff375c', '2026-10-09', 'JU26100114', 'Biaya Listrik, Air & Telepon', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'tagihan listrik bulan september', 11969068.0, 0.0, NULL, NOW(), NOW()),
('j0350f8988fc', '2026-10-09', 'JU26100114', 'Biaya Listrik, Air & Telepon', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'tagihan listrik bulan september', 893970.0, 0.0, NULL, NOW(), NOW()),
('jf1fe26da3a0', '2026-10-09', 'JU26100114', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'tagihan listrik bulan september', 0.0, 22446081.0, NULL, NOW(), NOW()),
('jc0f2809f00d', '2026-10-09', 'JU26100115', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'gas cibeureum 26 tbg', 26406000.0, 0.0, NULL, NOW(), NOW()),
('j8638a82722f', '2026-10-09', 'JU26100115', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'gas cibeureum 26 tbg', 0.0, 26406000.0, NULL, NOW(), NOW()),
('jfcfe45bfaa3', '2026-10-09', 'JU26100116', 'Biaya CSR/Kompensasi/Sumbangan', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'jatah panen warga cibeureum', 5000000.0, 0.0, NULL, NOW(), NOW()),
('jaac9f2d5502', '2026-10-09', 'JU26100116', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'jatah panen warga cibeureum', 0.0, 5000000.0, NULL, NOW(), NOW()),
('j00170a46482', '2026-10-09', 'JU26100117', 'Biaya Panen', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'upah tangkap, pikul pakan dan briket. uang nimbang.', 1512220.0, 0.0, NULL, NOW(), NOW()),
('jd15314c041d', '2026-10-09', 'JU26100117', 'Biaya Panen', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'upah tangkap, pikul pakan dan briket. uang nimbang.', 1000000.0, 0.0, NULL, NOW(), NOW()),
('j87ef49d0dcd', '2026-10-09', 'JU26100117', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'upah tangkap, pikul pakan dan briket. uang nimbang.', 0.0, 2512220.0, NULL, NOW(), NOW()),
('j9fefb156720', '2026-10-09', 'JU26100118', 'Beban Pajak Badan', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'cadangan PPH cibeureum', 2226949.0, 0.0, NULL, NOW(), NOW()),
('j2051e782a4e', '2026-10-09', 'JU26100118', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'cadangan PPH cibeureum', 0.0, 2226949.0, NULL, NOW(), NOW());

-- 23 UPDATE (19 reklasifikasi kategori + 4 pembetulan keterangan) pada
-- 22 transaksi yang sudah ada -- jumlah/tanggal/jenis tidak berubah sama sekali.
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0243';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0244';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0246';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0247';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0250';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0570';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0572';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0699';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0739';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0741';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2608-0906';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2609-0127';
UPDATE `transactions` SET `project`='Farm Cibeureum periode 5' WHERE `ref`='CO-2609-0134';
UPDATE `transactions` SET `akun_lawan`='Cadangan THR' WHERE `ref`='CO-2609-0134';
UPDATE `transactions` SET `akun_lawan`='Biaya Perlengkapan Kandang' WHERE `ref`='CO-2608-0819';
UPDATE `transactions` SET `akun_lawan`='Biaya Listrik, Air & Telepon' WHERE `ref`='CO-2608-0824';
UPDATE `transactions` SET `akun_lawan`='Biaya Pemeliharaan Alat & Kandang' WHERE `ref`='CO-2609-1021';
UPDATE `transactions` SET `akun_lawan`='Biaya ADM' WHERE `ref`='CO-2609-1455';
UPDATE `transactions` SET `akun_lawan`='Biaya Upah2' WHERE `ref`='CO-2610-0246';
UPDATE `transactions` SET `ket`='7btg pipa galv 2", 122lbr wiremesh 10mmx2.1x5.4. Total +ppn 109.900.000 (22/10) #berkat (bougenville 25)' WHERE `ref`='CO-2606-0265';
UPDATE `transactions` SET `ket`='triplek, koas 4" (pos satpam)' WHERE `ref`='CO-2608-0122';
UPDATE `transactions` SET `ket`='hebel, holo, tee, gypsum, pvc 3", knee 3" semen dll (5 nota)' WHERE `ref`='CO-2609-1433';
UPDATE `transactions` SET `ket`='pelunasan bahan pintu' WHERE `ref`='CO-2609-1422';

-- Verifikasi jumlah baris setelah dijalankan (harapan setelah file ini
-- + sync_transactions_okt8_2026.sql sama-sama sudah jalan): 5305 + 45 + 112 = 5462
SELECT COUNT(*) AS total_transactions FROM `transactions`;
