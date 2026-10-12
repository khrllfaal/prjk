-- Sinkronisasi dari Report export terbaru (s/d 12 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup
-- sync_transactions_okt9_2026.sql DAN sync_transactions_okt9_lanjutan_2026.sql
-- (jalankan file ini SETELAH kedua file itu -- urutan tidak masalah,
-- semuanya INSERT IGNORE / UPDATE idempotent, aman dijalankan ulang dan kapan saja).
--
-- Ditemukan 74 transaksi baru (9-12 Oktober 2026) dan
-- 16 penyesuaian pada transaksi yang sudah ada (reklasifikasi
-- project/akun, pembetulan nama akun kas, dan pemecahan nilai transaksi
-- yang ternyata gabungan 2-3 pos berbeda -- setiap pemecahan sudah
-- dicek jumlahnya pas dengan total aslinya). Jurnal Umum sudah 100%
-- sinkron, tidak ada perubahan di sana.
--
-- Data yang sudah benar (Trial Balance, Neraca, Laba Rugi, Hutang, Prive,
-- logika index.html) tidak disentuh sama sekali oleh file ini.

-- 74 transaksi baru
INSERT IGNORE INTO `transactions` (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `customer_id`, `vendor_id`, `ket`, `debet`, `kredit`, `created_by`, `created_at`, `updated_at`) VALUES
('tdd6d4ceb5dce', 'bank_masuk', '2026-10-12', 'BI-2610-0007', 'Bank BCA Cibeureum', 'Pendapatan Kandang', 'Farm Cibeureum periode 5', '', NULL, NULL, 'uang masuk kandang A', 163959124.0, 0.0, NULL, NOW(), NOW()),
('t9b303d4f34e0', 'bank_masuk', '2026-10-12', 'BI-2610-0008', 'Bank BCA Cibeureum', 'Pendapatan Kandang', 'Farm Cibeureum periode 5', '', NULL, NULL, 'uang masuk kandang B', 174350827.0, 0.0, NULL, NOW(), NOW()),
('tc02f32456a3b', 'bank_keluar', '2026-10-12', 'BO-2610-0013', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'penarikan 12 oktober', 0.0, 818027239.0, NULL, NOW(), NOW()),
('tea66d59da2de', 'bank_keluar', '2026-04-30', 'BO-2610-0014', 'Bank BJB RC Purbayanti', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'Penarikan loan cv purbayanti (6/3)', 0.0, 200000000.0, NULL, NOW(), NOW()),
('tdbb1c1eefc4f', 'kas_masuk', '2026-10-12', 'CI-2610-0014', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'penarikan 12 oktober', 818027239.0, 0.0, NULL, NOW(), NOW()),
('t4f41f91ec723', 'kas_keluar', '2026-08-20', 'CO-2610-0537', 'Kas Besar', 'Biaya Perlengkapan Kandang', 'Farm Cilame 2 periode 5', '', NULL, NULL, 'baby chick 15.122.500 (dibagi 3 lokasi)', 0.0, 4320714.0, NULL, NOW(), NOW()),
('tc7ae58d58fe5', 'kas_keluar', '2026-08-20', 'CO-2610-0538', 'Kas Besar', 'Biaya Perlengkapan Kandang', 'Farm Cilame 1 periode 5', '', NULL, NULL, 'baby chick 15.122.500 (dibagi 3 lokasi)', 0.0, 6481072.0, NULL, NOW(), NOW()),
('te66a5382a71e', 'kas_keluar', '2026-08-26', 'CO-2610-0539', 'Kas Besar', 'Biaya Perlengkapan Kandang', 'Farm Cibeureum periode 6', '', NULL, NULL, 'kompor pelet dan tungku cibeureum 16,5jt, ongkir 1,6jt. Total 18.100.000 (dibagi 2 periode)', 0.0, 9050000.0, NULL, NOW(), NOW()),
('t2daaf3128cdf', 'kas_keluar', '2026-10-09', 'CO-2610-0540', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'kloset 2 set (dari orderan gudkesrah)', 0.0, 3360400.0, NULL, NOW(), NOW()),
('t1bd7667c9aa0', 'kas_keluar', '2026-10-12', 'CO-2610-0541', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Cost Center', '', NULL, NULL, 'amplop bayu menikah', 0.0, 500000.0, NULL, NOW(), NOW()),
('t10acf6d816a4', 'kas_keluar', '2026-10-12', 'CO-2610-0542', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', NULL, NULL, 'obat pak zam', 0.0, 152500.0, NULL, NOW(), NOW()),
('tf444665a576b', 'kas_keluar', '2026-10-12', 'CO-2610-0543', 'Kas Besar', 'Biaya Jamsostek Ketenagakerjaan', 'Cost Center', '', NULL, NULL, 'BPJS TK PT', 0.0, 1468458.0, NULL, NOW(), NOW()),
('te75ea084f3d9', 'kas_keluar', '2026-10-12', 'CO-2610-0544', 'Kas Besar', 'Biaya Jamsostek Ketenagakerjaan', 'Cost Center', '', NULL, NULL, 'BPJS TK Prakasa', 0.0, 1230726.0, NULL, NOW(), NOW()),
('te21373f39b79', 'kas_keluar', '2026-10-12', 'CO-2610-0545', 'Kas Besar', 'Biaya Jamsostek Ketenagakerjaan', 'Cost Center', '', NULL, NULL, 'BPJS TK Purbayanti', 0.0, 1230726.0, NULL, NOW(), NOW()),
('t98e7b9393e43', 'kas_keluar', '2026-10-12', 'CO-2610-0546', 'Kas Besar', 'Biaya Bahan', 'ZIDAM', '', NULL, NULL, 'ongkos meja', 0.0, 1205000.0, NULL, NOW(), NOW()),
('t6a2baff49e11', 'kas_keluar', '2026-10-12', 'CO-2610-0547', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', NULL, NULL, 'pinjaman adm', 0.0, 50002500.0, NULL, NOW(), NOW()),
('t4e6c1556a80c', 'kas_keluar', '2026-10-12', 'CO-2610-0548', 'Kas Besar', 'Biaya ADM', 'KNMP Donggala', '', NULL, NULL, 'pinjaman adm tim irul', 0.0, 10000000.0, NULL, NOW(), NOW()),
('t73424165368d', 'kas_keluar', '2026-10-12', 'CO-2610-0549', 'Kas Besar', 'Biaya Akomodasi', 'KNMP Donggala', '', NULL, NULL, 'tiket donggala 4 org', 0.0, 10870192.0, NULL, NOW(), NOW()),
('t883e94faec2d', 'kas_keluar', '2026-10-12', 'CO-2610-0550', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'h dana', 0.0, 12000000.0, NULL, NOW(), NOW()),
('tb04d0c578b82', 'kas_keluar', '2026-10-12', 'CO-2610-0551', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'OP fahri 10/10', 0.0, 1000000.0, NULL, NOW(), NOW()),
('t3ca16ecf87ff', 'kas_keluar', '2026-10-12', 'CO-2610-0552', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'ongkos granit', 0.0, 60000.0, NULL, NOW(), NOW()),
('ta38c0f1d6775', 'kas_keluar', '2026-10-12', 'CO-2610-0553', 'Kas Besar', 'Biaya ADM', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'lapjusik', 0.0, 1500000.0, NULL, NOW(), NOW()),
('t18677f6463a4', 'kas_keluar', '2026-10-12', 'CO-2610-0554', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'cat talang hijau', 0.0, 3247875.0, NULL, NOW(), NOW()),
('t7eea58810e09', 'kas_keluar', '2026-10-12', 'CO-2610-0555', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', NULL, NULL, 'granit', 0.0, 856800.0, NULL, NOW(), NOW()),
('t4e79e9c18e17', 'kas_keluar', '2026-10-12', 'CO-2610-0556', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', NULL, NULL, 'Belanja tgl 10', 0.0, 4000000.0, NULL, NOW(), NOW()),
('td245ac8cd154', 'kas_keluar', '2026-10-12', 'CO-2610-0557', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', NULL, NULL, 'Belanja tgl 11', 0.0, 3000000.0, NULL, NOW(), NOW()),
('t7e588e6786af', 'kas_keluar', '2026-10-12', 'CO-2610-0558', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', NULL, NULL, 'Belanja tgl 12', 0.0, 5000000.0, NULL, NOW(), NOW()),
('te69cf543bbfb', 'kas_keluar', '2026-10-12', 'CO-2610-0559', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Kodim Bangun Jalan Cibalong', '', NULL, NULL, 'konsumsi lemburan', 0.0, 1198500.0, NULL, NOW(), NOW()),
('ta3b0ad337c5b', 'kas_keluar', '2026-10-12', 'CO-2610-0560', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kayu isian kusen', 0.0, 920000.0, NULL, NOW(), NOW()),
('t9b9d08db1d2f', 'kas_keluar', '2026-10-12', 'CO-2610-0561', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'keramik wc', 0.0, 290000.0, NULL, NOW(), NOW()),
('t508315acbcf7', 'kas_keluar', '2026-10-12', 'CO-2610-0562', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'semen', 0.0, 1077000.0, NULL, NOW(), NOW()),
('t73d1d1207ed5', 'kas_keluar', '2026-10-12', 'CO-2610-0563', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'primafix', 0.0, 1235250.0, NULL, NOW(), NOW()),
('tf7944c2d4901', 'kas_keluar', '2026-10-12', 'CO-2610-0564', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'wasrik', 0.0, 2500000.0, NULL, NOW(), NOW()),
('t4f41d1af3b80', 'kas_keluar', '2026-10-12', 'CO-2610-0565', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kasbon agus', 0.0, 5000000.0, NULL, NOW(), NOW()),
('ta49657dc774f', 'kas_keluar', '2026-10-12', 'CO-2610-0566', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', NULL, NULL, 'chemical', 0.0, 795000.0, NULL, NOW(), NOW()),
('t6ac8f291ecb2', 'kas_keluar', '2026-10-12', 'CO-2610-0567', 'Kas Besar', 'Biaya Upah', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', NULL, NULL, 'rizky aula kornel', 0.0, 25000000.0, NULL, NOW(), NOW()),
('t57ef79d84477', 'kas_keluar', '2026-10-12', 'CO-2610-0568', 'Kas Besar', 'Biaya Upah', 'KNMP Pekalongan', '', NULL, NULL, 'pekalongan ke 3', 0.0, 500000000.0, NULL, NOW(), NOW()),
('t2fd2c6c959f8', 'kas_keluar', '2026-10-12', 'CO-2610-0569', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', NULL, NULL, 'kabidren', 0.0, 40000000.0, NULL, NOW(), NOW()),
('t788e0876e0ab', 'kas_keluar', '2026-10-12', 'CO-2610-0570', 'Kas Besar', 'Biaya Bahan', 'Cibatu', '', NULL, NULL, 'DP 20% kandang ayam', 0.0, 8084000.0, NULL, NOW(), NOW()),
('ta609c825f454', 'kas_keluar', '2026-10-12', 'CO-2610-0571', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'bahan asyfa', 0.0, 1665000.0, NULL, NOW(), NOW()),
('t65f2f961cca2', 'kas_keluar', '2026-10-12', 'CO-2610-0572', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'ongkos pekerja group dani', 0.0, 1200000.0, NULL, NOW(), NOW()),
('t1c62e903ffd3', 'kas_keluar', '2026-10-12', 'CO-2610-0573', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'kasbon group dani', 0.0, 2000000.0, NULL, NOW(), NOW()),
('te4d294551c07', 'kas_keluar', '2026-10-12', 'CO-2610-0574', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'keni', 0.0, 6202500.0, NULL, NOW(), NOW()),
('t27ee6077a2b0', 'kas_keluar', '2026-10-12', 'CO-2610-0575', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kabel', 0.0, 4500000.0, NULL, NOW(), NOW()),
('t2ee2ae7ea0ce', 'kas_keluar', '2026-10-12', 'CO-2610-0576', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'paku beton', 0.0, 374000.0, NULL, NOW(), NOW()),
('t5da7e3e29fba', 'kas_keluar', '2026-10-12', 'CO-2610-0577', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'ongkos kirim granit', 0.0, 1300000.0, NULL, NOW(), NOW()),
('tbe9d99cfaa8b', 'kas_keluar', '2026-10-12', 'CO-2610-0578', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'triplek, semen, dll', 0.0, 11674400.0, NULL, NOW(), NOW()),
('td453069eb105', 'kas_keluar', '2026-10-12', 'CO-2610-0579', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'granit 300 dus', 0.0, 35400000.0, NULL, NOW(), NOW()),
('t0cbde4de6311', 'kas_keluar', '2026-10-12', 'CO-2610-0580', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'bahan alam', 0.0, 8200000.0, NULL, NOW(), NOW()),
('t7e45bcbdad79', 'kas_keluar', '2026-10-12', 'CO-2610-0581', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', NULL, NULL, 'kasbon yudi', 0.0, 7000000.0, NULL, NOW(), NOW()),
('t9693c5c497c6', 'kas_keluar', '2026-10-12', 'CO-2610-0582', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'mesin cutting', 0.0, 2752500.0, NULL, NOW(), NOW()),
('t98b54cf718b8', 'kas_keluar', '2026-10-12', 'CO-2610-0583', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'japuk dan teknisi', 0.0, 950000.0, NULL, NOW(), NOW()),
('t62a8cea5dbac', 'kas_keluar', '2026-10-12', 'CO-2610-0584', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'perpanjangan kompresor', 0.0, 1600000.0, NULL, NOW(), NOW()),
('t4ba32ae290c4', 'kas_keluar', '2026-10-12', 'CO-2610-0585', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'bambu', 0.0, 142500.0, NULL, NOW(), NOW()),
('t1a440c1cb413', 'kas_keluar', '2026-10-12', 'CO-2610-0586', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'bekisting', 0.0, 2800000.0, NULL, NOW(), NOW()),
('ta12515b977ca', 'kas_keluar', '2026-10-12', 'CO-2610-0587', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', NULL, NULL, 'pengamanan demo', 0.0, 3000000.0, NULL, NOW(), NOW()),
('t9dbb2ec85a46', 'kas_keluar', '2026-10-12', 'CO-2610-0588', 'Kas Besar', 'Biaya Bahan', 'BJB Riau', '', NULL, NULL, 'DP neon box', 0.0, 7000000.0, NULL, NOW(), NOW()),
('tdeb7e9452d3f', 'kas_keluar', '2026-10-12', 'CO-2610-0589', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'scraper', 0.0, 245107.0, NULL, NOW(), NOW()),
('t625580786410', 'kas_keluar', '2026-10-12', 'CO-2610-0590', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'ongkos pekerja', 0.0, 4125000.0, NULL, NOW(), NOW()),
('t9078952515c4', 'kas_keluar', '2026-10-12', 'CO-2610-0591', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'paku, pahat, linggis', 0.0, 1389500.0, NULL, NOW(), NOW()),
('ta1e87a1bcd6c', 'kas_keluar', '2026-10-12', 'CO-2610-0592', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'terminal, steker, kabel', 0.0, 1374000.0, NULL, NOW(), NOW()),
('t32bce0533448', 'kas_keluar', '2026-10-12', 'CO-2610-0593', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'scrapes', 0.0, 145705.0, NULL, NOW(), NOW()),
('tfabb3e7c87dd', 'kas_keluar', '2026-10-12', 'CO-2610-0594', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'karpet, ticecooker', 0.0, 3835000.0, NULL, NOW(), NOW()),
('t1031c435aeb5', 'kas_keluar', '2026-10-12', 'CO-2610-0595', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', NULL, NULL, 'kasbon pekerja', 0.0, 1900000.0, NULL, NOW(), NOW()),
('t44641d802dfd', 'kas_keluar', '2026-10-12', 'CO-2610-0596', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'air damkar', 0.0, 250000.0, NULL, NOW(), NOW()),
('t0cb5ed024146', 'kas_keluar', '2026-10-12', 'CO-2610-0597', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', NULL, NULL, 'pasir', 0.0, 1850000.0, NULL, NOW(), NOW()),
('t994bc6a82b0a', 'kas_keluar', '2026-10-12', 'CO-2610-0598', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Armed', '', NULL, NULL, 'OP armed 12/10', 0.0, 1500000.0, NULL, NOW(), NOW()),
('t514033971164', 'kas_keluar', '2026-10-12', 'CO-2610-0599', 'Kas Besar', 'Biaya Bahan', 'Kemhan', '', NULL, NULL, 'sondir', 0.0, 2500000.0, NULL, NOW(), NOW()),
('tb65e04226748', 'kas_keluar', '2026-10-12', 'CO-2610-0600', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', NULL, NULL, 'operasional pengecoran (bahan)', 0.0, 1450000.0, NULL, NOW(), NOW()),
('t07c89bff8493', 'kas_keluar', '2026-10-12', 'CO-2610-0601', 'Kas Besar', 'Biaya ADM', 'ZIDAM', '', NULL, NULL, 'iuran', 0.0, 2000000.0, NULL, NOW(), NOW()),
('tc777a4630b69', 'kas_keluar', '2026-10-12', 'CO-2610-0602', 'Kas Besar', 'Biaya entertain', 'Cost Center', '', NULL, NULL, 'parfume oleh oleh AU', 0.0, 1752500.0, NULL, NOW(), NOW()),
('t81aee2769c32', 'kas_keluar', '2026-10-12', 'CO-2610-0603', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', NULL, NULL, 'upah terlewat', 0.0, 480000.0, NULL, NOW(), NOW()),
('ta4308a25e223', 'kas_keluar', '2026-10-12', 'CO-2610-0604', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 2 periode 5', '', NULL, NULL, 'ongkos kirim tali cilame 2', 0.0, 45000.0, NULL, NOW(), NOW()),
('tdeefb49eeec5', 'kas_keluar', '2026-10-12', 'CO-2610-0605', 'Kas Besar', 'Biaya ADM', 'Cost Center', '', NULL, NULL, 'rintisan mama', 0.0, 2000000.0, NULL, NOW(), NOW());

-- 16 penyesuaian pada transaksi yang sudah ada
UPDATE `transactions` SET `akun_kas`='Bank BJB RC Purbayanti' WHERE `ref`='BI-2610-0005';
UPDATE `transactions` SET `akun_kas`='Bank BJB RC Purbayanti' WHERE `ref`='BO-2607-0005';
UPDATE `transactions` SET `akun_lawan`='Ayat Silang Kas Besar Kas-Bank' WHERE `ref`='CI-2609-0013';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0243';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0244';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0247';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0250';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0572';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0699';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0739';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2608-0741';
UPDATE `transactions` SET `kredit`=9050000.0 WHERE `ref`='CO-2608-0819';
UPDATE `transactions` SET `akun_lawan`='Biaya Perlengkapan Kandang', `kredit`=4320714.0 WHERE `ref`='CO-2608-0900';
UPDATE `transactions` SET `project`='Farm Cibeureum' WHERE `ref`='CO-2609-0332';
UPDATE `transactions` SET `akun_lawan`='Biaya Upah3' WHERE `ref`='CO-2610-0279';
UPDATE `transactions` SET `kredit`=3376000.0 WHERE `ref`='CO-2610-0443';

-- Verifikasi (harapan setelah file ini dan 2 file sebelumnya sama-sama jalan): 5539
SELECT COUNT(*) AS total_transactions FROM `transactions`;
