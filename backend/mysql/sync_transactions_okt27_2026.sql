-- Sinkronisasi 27 Oktober 2026.
--
-- 57 transaksi baru (48 Kas Keluar, 8 Bank Keluar, 1 Kas Masuk). Tidak ada
-- voucher/pembayaran Hutang Dagang baru sama sekali di sync ini (Data Hutang
-- total tidak berubah, dikonfirmasi lewat Jurnal Umum penuh -- 0 baris baru).
--
-- 1 Master Project baru: "Kemhan Rehab Kodim Bandung Cimahi" (dari CO-2610-1410/
-- 1411/1412, "10% kodim kota bdg/kota cimahi/kab bandung").
--
-- 4 relasi Prive diberi lewat pencocokan nominal persis dengan delta Data Prive:
--  - CO-2610-1404 "kasbon teh nani" Rp250.000 = Pr-I
--  - CO-2610-1405 "bayaran deden (pak zamzam)" Rp95.000 = Pr-Z
--  - CO-2610-1406 "pak ei" Rp2.100.000 = Pr-K
--  - CO-2610-1407 "perpanjangan emas" Rp11.913.600 = Pr-R
--
-- 30 koreksi keterangan di laporan lama ternyata cuma normalisasi spasi ganda
-- jadi spasi tunggal (bukan perubahan data nyata) -- tidak di-apply.
--
-- Diverifikasi via Playwright terhadap data yang diberikan owner: Dashboard
-- Cash Flow, Data Hutang (27 vendor), Data Piutang (14 customer), Data Prive
-- (5 pemilik), Trial Balance (kolom Laba Rugi & Neraca balance).

INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_kemhan_rehab_kodim_bandung_cimahi', 'Kemhan Rehab Kodim Bandung Cimahi', 'Kemhan Rehab Kodim Bandung Cimahi', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW());

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t8fe0ca6f4e92', 'bank_keluar', '2026-10-27', 'BO-2610-0028', 'Bank BCA Cibeureum', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan untuk pelet', 0.00, 16000000.00),
  ('t96c90041ab63', 'bank_keluar', '2026-10-27', 'BO-2610-0029', 'Bank BJB RC Prakasa', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'bunga cv prakasa', 0.00, 31351214.00),
  ('t20c1b7f6198f', 'bank_keluar', '2026-10-27', 'BO-2610-0030', 'Bank BJB RC Purbayanti', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'bunga cv purbayanti', 0.00, 42939875.00),
  ('ta20d78554026', 'bank_keluar', '2026-10-27', 'BO-2610-0031', 'Bank BJB RC PT', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'Bunga PT Prakasa Purba BJB', 0.00, 17485215.00),
  ('tc8090e2c6823', 'bank_keluar', '2026-10-27', 'BO-2610-0032', 'Bank BRI PT', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'Bunga PT Prakasa Purba BRI', 0.00, 48737741.00),
  ('td982be46e85e', 'bank_keluar', '2026-10-27', 'BO-2610-0033', 'Bank BNI PT', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'Bunga PT Prakasa Purba BNI', 0.00, 31816646.00),
  ('t6824f3f0c6ab', 'bank_keluar', '2026-10-27', 'BO-2610-0034', 'Bank BJB RC PT', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 27 oktober', 0.00, 600000000.00),
  ('tdb99281640bd', 'bank_keluar', '2026-10-27', 'BO-2610-0035', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 27 oktober', 0.00, 204241577.00),
  ('t082ff559d9a3', 'kas_keluar', '2026-10-27', 'CO-2610-1395', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'pelet 10 ton kdg cibeureum', 0.00, 16000000.00),
  ('tfe54376ab747', 'kas_keluar', '2026-10-27', 'CO-2610-1401', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'hekter', 0.00, 15000.00),
  ('t9e870120b7e4', 'kas_keluar', '2026-10-27', 'CO-2610-1402', 'Kas Besar', 'Biaya Denda Pajak', 'Cost Center', '', 'denda telat lapor', 0.00, 500000.00),
  ('t4f33f4553d3c', 'kas_keluar', '2026-10-27', 'CO-2610-1403', 'Kas Besar', 'Biaya entertain', 'Cost Center', '', 'kas arya (ongkos kirim kiojay)', 0.00, 197000.00),
  ('tf51c008b269d', 'kas_keluar', '2026-10-27', 'CO-2610-1404', 'Kas Besar', 'Prive', 'Prive', 'Pr-I', 'kasbon teh nani', 0.00, 250000.00),
  ('tf9e5f3c09f37', 'kas_keluar', '2026-10-27', 'CO-2610-1405', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'bayaran deden (pak zamzam)', 0.00, 95000.00),
  ('t9d302a0e047c', 'kas_keluar', '2026-10-27', 'CO-2610-1406', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'pak ei', 0.00, 2100000.00),
  ('ta17fd3e147e8', 'kas_keluar', '2026-10-27', 'CO-2610-1407', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'perpanjangan emas', 0.00, 11913600.00),
  ('td5a8dad0886a', 'kas_keluar', '2026-10-27', 'CO-2610-1408', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'fuji', 0.00, 25000000.00),
  ('t792580f1560c', 'kas_keluar', '2026-10-27', 'CO-2610-1409', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'cat ruang kontaminasi', 0.00, 481000.00),
  ('tfd1c7439807e', 'kas_keluar', '2026-10-27', 'CO-2610-1410', 'Kas Besar', 'Biaya Upah2', 'Kemhan Rehab Kodim Bandung Cimahi', '', '10% kodim kota bdg', 0.00, 21621636.00),
  ('t79ef0414a322', 'kas_keluar', '2026-10-27', 'CO-2610-1411', 'Kas Besar', 'Biaya Upah', 'Kemhan Rehab Kodim Bandung Cimahi', '', '10% kodim kota cimahi', 0.00, 25946005.00),
  ('t59c2551fb4cf', 'kas_keluar', '2026-10-27', 'CO-2610-1412', 'Kas Besar', 'Biaya Upah3', 'Kemhan Rehab Kodim Bandung Cimahi', '', '10% kodim kab bandung', 0.00, 19459469.00),
  ('t2d7c547248a9', 'kas_keluar', '2026-10-27', 'CO-2610-1413', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 27', 0.00, 4000000.00),
  ('t4050677d23c4', 'kas_keluar', '2026-10-27', 'CO-2610-1414', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'solar 350lt', 0.00, 4200000.00),
  ('t16d99c98ebf9', 'kas_keluar', '2026-10-27', 'CO-2610-1415', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'keni, vsock, dll', 0.00, 548000.00),
  ('td1b7e389bfc0', 'kas_keluar', '2026-10-27', 'CO-2610-1416', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'listrik kenanga', 0.00, 203000.00),
  ('t3b0be12f659b', 'kas_keluar', '2026-10-27', 'CO-2610-1417', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'paku rivet, silicone dowsil, kaca', 0.00, 6992000.00),
  ('ta263d66e0885', 'kas_keluar', '2026-10-27', 'CO-2610-1418', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'jasa ganti media filter', 0.00, 1002500.00),
  ('tb6822949d876', 'kas_keluar', '2026-10-27', 'CO-2610-1419', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'flexible onda', 0.00, 119000.00),
  ('t720a5ada4726', 'kas_keluar', '2026-10-27', 'CO-2610-1420', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (ongkir)', 0.00, 90000.00),
  ('t722f1c3e7bcb', 'kas_keluar', '2026-10-27', 'CO-2610-1421', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'semen, besi, kawat', 0.00, 2182000.00),
  ('td8da2f17789f', 'kas_keluar', '2026-10-27', 'CO-2610-1422', 'Kas Besar', 'Biaya Upah2', 'Proyek Antapani', '', 'jasa perbaikan shower', 0.00, 350000.00),
  ('tc7187ea9967d', 'kas_keluar', '2026-10-27', 'CO-2610-1423', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'kaso, knie, asahi, besi, dll', 0.00, 1889000.00),
  ('t7e59dc7fef20', 'kas_keluar', '2026-10-27', 'CO-2610-1424', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'kas arya (cutting wd, paku, ember,plastik cor, dll)', 0.00, 1172500.00),
  ('t51582074807b', 'kas_keluar', '2026-10-27', 'CO-2610-1425', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', 'kas arya (ongkos pekerja)', 0.00, 410000.00),
  ('t311da90d120b', 'kas_keluar', '2026-10-27', 'CO-2610-1426', 'Kas Besar', 'Biaya entertain', 'Proyek Antapani', '', 'kas arya (upah ajudan, rokok ajudan)', 0.00, 314000.00),
  ('t40caf989e0df', 'kas_keluar', '2026-10-27', 'CO-2610-1427', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', 'kas arya (bensin, obat arya)', 0.00, 122000.00),
  ('t9119609b5864', 'kas_keluar', '2026-10-27', 'CO-2610-1428', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'gravel', 0.00, 6125000.00),
  ('t4dae915a806b', 'kas_keluar', '2026-10-27', 'CO-2610-1429', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'upah penurunan bahan', 0.00, 350000.00),
  ('t12f487e17a47', 'kas_keluar', '2026-10-27', 'CO-2610-1430', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'thiner, kuas', 0.00, 101000.00),
  ('t90626f4a33d6', 'kas_keluar', '2026-10-27', 'CO-2610-1431', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'paku', 0.00, 425000.00),
  ('t8beb576e8fba', 'kas_keluar', '2026-10-27', 'CO-2610-1432', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'skrup', 0.00, 763000.00),
  ('t5d6df273e40b', 'kas_keluar', '2026-10-27', 'CO-2610-1433', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'roll, koas, dempul, bata ringan', 0.00, 3959500.00),
  ('tcc8e972a6484', 'kas_keluar', '2026-10-27', 'CO-2610-1434', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'beton 212 m3 subang', 0.00, 254400000.00),
  ('td749aa0d7a3c', 'kas_keluar', '2026-10-27', 'CO-2610-1435', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'long arm', 0.00, 4410000.00),
  ('t8a2f55e9c311', 'kas_keluar', '2026-10-27', 'CO-2610-1436', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'buang barangkai 9 rit', 0.00, 2250000.00),
  ('t889f48e3973e', 'kas_keluar', '2026-10-27', 'CO-2610-1437', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar pc 30lt', 0.00, 1006000.00),
  ('t0009fe4be004', 'kas_keluar', '2026-10-27', 'CO-2610-1438', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar long arm 75 lt', 0.00, 2240000.00),
  ('tdde6537e4068', 'kas_keluar', '2026-10-27', 'CO-2610-1439', 'Kas Besar', 'Biaya Upah', 'BJB Riau', '', 'BJB riau', 0.00, 130253874.00),
  ('tcc2cb1496b8d', 'kas_keluar', '2026-10-27', 'CO-2610-1440', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'keramik', 0.00, 7121307.00),
  ('ta61b1a4dabf4', 'kas_keluar', '2026-10-27', 'CO-2610-1441', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'bahan holo, kabel, dll', 0.00, 25480000.00),
  ('t3ae9f926e0fd', 'kas_keluar', '2026-10-27', 'CO-2610-1442', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'progress 50% (dikurangi bahan yg sudah dibayar)', 0.00, 24136603.00),
  ('t824ba2ae4069', 'kas_keluar', '2026-10-27', 'CO-2610-1443', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'gravel', 0.00, 8440000.00),
  ('t91af9faad050', 'kas_keluar', '2026-10-27', 'CO-2610-1444', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'lis', 0.00, 4502500.00),
  ('t4bbef61d5231', 'kas_keluar', '2026-10-27', 'CO-2610-1445', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'gypsum 150 lbr', 0.00, 7800000.00),
  ('tbe5ee0727d7b', 'kas_keluar', '2026-10-27', 'CO-2610-1446', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'AC 1 pk 11 pcs (belum ongkos)', 0.00, 37950000.00),
  ('t94c5f3d7bb80', 'kas_keluar', '2026-10-27', 'CO-2610-1447', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'DP tekanan negatif', 0.00, 151355083.00),
  ('te60c5ebeb26a', 'kas_masuk', '2026-10-27', 'CI-2610-0031', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 27 oktober', 820241577.00, 0.00);
