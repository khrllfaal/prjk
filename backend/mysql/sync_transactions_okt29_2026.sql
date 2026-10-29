-- Sinkronisasi 29 Oktober 2026.
--
-- 62 transaksi baru (lihat INSERT transactions di bawah).
-- 3 relasi diberi lewat pencocokan nominal persis dengan delta Data Prive:
--  - CO-2610-1526 'potong rambut pak zamzam' Rp40.000 -> Pr-Z (delta persis)
--  - CO-2610-1530 'permak (pa karli)' Rp30.000 -> Pr-K (delta persis)
--  - CO-2610-1531 'kekurangan perpanjangan emas' Rp328.700 -> Pr-R (delta persis)
--  - CO-2610-1552 + CO-2610-1553 ('nota berkat 10/9' + 'nota berkat 5/9') -> V-HU-Berkat,
--    ini melunasi 2 nota Jurnal Umum (JU26090094 Rp76.535.600 dan JU26090088 Rp22.419.780)
--    yang sebelumnya Belum Dibayar/Sebagian -- diverifikasi lewat computeHutangDagangRows()
--
-- Penyesuaian NYATA (bukan normalisasi spasi) pada transaksi lama, 25 baris:
--  - 16x koreksi nama project 'KNMP' -> 'KNMP Cibalong'
--  - 3x koreksi akun lawan 'Biaya Upah2' -> 'Biaya Upah'
--  - 1x koreksi ket 'bayaran pesantren al mabur' -> 'al mabrur' (typo)
--  - 5x koreksi nama project 'Kodim X' -> 'Kemhan Kodim X'

UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2607-0619' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2607-0620' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2607-0641' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2607-1008' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2608-1032' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-0623' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-0624' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-0712' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-0853' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-0854' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-0855' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-1138' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2609-1446' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2610-0301' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'KNMP Cibalong' WHERE `ref` = 'CO-2610-0631' AND `project` = 'KNMP';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Purwakarta' WHERE `ref` = 'CO-2610-0851' AND `project` = 'Kodim Purwakarta';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Subang' WHERE `ref` = 'CO-2610-0852' AND `project` = 'Kodim Subang';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Majalengka' WHERE `ref` = 'CO-2610-0909' AND `project` = 'Kodim Majalengka';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Majalengka' WHERE `ref` = 'CO-2610-0910' AND `project` = 'Kodim Majalengka';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kuningan' WHERE `ref` = 'CO-2610-1347' AND `project` = 'Kodim Kuningan';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kuningan' WHERE `ref` = 'CO-2610-1475' AND `project` = 'Kodim Kuningan';

UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2609-0644' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2609-0645' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2610-0459' AND `akun_lawan` = 'Biaya Upah2';

UPDATE `transactions` SET `ket` = 'bayaran pesantren al mabrur' WHERE `ref` = 'CO-2610-0784' AND `ket` = 'bayaran pesantren al mabur';

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t86da7cd0a440', 'bank_keluar', '2026-10-29', 'BO-2610-0037', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 29 oktober', 0.00, 2469394480.00),
  ('tb6872e3f6b05', 'bank_masuk', '2026-10-29', 'BI-2610-0016', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'KNMP Pekalongan', '', 'uang masuk knmp pekalongan', 2636296400.00, 0.00),
  ('t3176b8e74853', 'bank_masuk', '2026-10-29', 'BI-2610-0017', 'Bank BNI PT', 'Pendapatan Proyek', 'ZIDAM Bangun Rumdis Pangandaran', '', 'uang masuk pangandaran', 401492495.00, 0.00),
  ('tdb0c2d41af4d', 'kas_keluar', '2026-10-29', 'CO-2610-1520', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'ongkir pelet cibeureum', 0.00, 1502500.00),
  ('t72af940b166c', 'kas_keluar', '2026-10-29', 'CO-2610-1521', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cilame 1 periode 5', '', 'DP ke-2 sekam', 0.00, 5000000.00),
  ('tc27ffb9fe21a', 'kas_keluar', '2026-10-29', 'CO-2610-1522', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 28/10', 0.00, 30000.00),
  ('tb7453840ec06', 'kas_keluar', '2026-10-29', 'CO-2610-1523', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nasi padang, gorengan, jus, air mineral, bubur sumsum', 0.00, 101000.00),
  ('t85f19e4c9362', 'kas_keluar', '2026-10-29', 'CO-2610-1524', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'casan hp', 0.00, 50000.00),
  ('tff1aaf0bc636', 'kas_keluar', '2026-10-29', 'CO-2610-1525', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'makan', 0.00, 97100.00),
  ('t2b903bfaba57', 'kas_keluar', '2026-10-29', 'CO-2610-1526', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'potong rambut pak zamzam', 0.00, 40000.00),
  ('t551c0ed64c89', 'kas_keluar', '2026-10-29', 'CO-2610-1527', 'Kas Besar', 'Biaya Upah2', 'Kemhan', '', 'upah dede dll nurunin pintu', 0.00, 200000.00),
  ('t8bbccae4848a', 'kas_keluar', '2026-10-29', 'CO-2610-1528', 'Kas Besar', 'Biaya Telepon', 'Cost Center', '', 'pulsa fahri', 0.00, 202000.00),
  ('t8de9aa559118', 'kas_keluar', '2026-10-29', 'CO-2610-1529', 'Kas Besar', 'Prive', 'Prive', '', '3an', 0.00, 500000.00),
  ('t9aa106be63a8', 'kas_keluar', '2026-10-29', 'CO-2610-1530', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'permak (pa karli)', 0.00, 30000.00),
  ('t5beb75387eba', 'kas_keluar', '2026-10-29', 'CO-2610-1531', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'kekurangan perpanjangan emas', 0.00, 328700.00),
  ('t42fc41f889a9', 'kas_keluar', '2026-10-29', 'CO-2610-1532', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'pasir pasang', 0.00, 1500000.00),
  ('tfeac74c4f54a', 'kas_keluar', '2026-10-29', 'CO-2610-1533', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'keramik wc', 0.00, 3142000.00),
  ('tb6fb9033d1a5', 'kas_keluar', '2026-10-29', 'CO-2610-1534', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kuningan', '', 'op yuki andri ke kuningan (bensin rokok makan dll) 23/10', 0.00, 985000.00),
  ('te4922a8723bd', 'kas_keluar', '2026-10-29', 'CO-2610-1535', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kab Cianjur', '', 'op yuki ke kodim cianjur (roko, nasgor, kopi) 26/10', 0.00, 286100.00),
  ('t06635d8b1268', 'kas_keluar', '2026-10-29', 'CO-2610-1536', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kab Sukabumi', '', 'op yuki ke kodim sukabumi (hotel, makan, dll) 27/10', 0.00, 1015000.00),
  ('te33a0af29b86', 'kas_keluar', '2026-10-29', 'CO-2610-1537', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kodim Bogor', '', 'op yuki ke kodim bogor (kopi pengawas, bensin, makan, dll) 27/10', 0.00, 478200.00),
  ('t3d57f2589f3d', 'kas_keluar', '2026-10-29', 'CO-2610-1538', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kota Sukabumi', '', 'op yuki ke kodim kota sukabumi (hotel, etol, roko tni, dll) 28/10', 0.00, 795500.00),
  ('t4d2560565aa0', 'kas_keluar', '2026-10-29', 'CO-2610-1539', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 29', 0.00, 8500000.00),
  ('t612972a216b3', 'kas_keluar', '2026-10-29', 'CO-2610-1540', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'ongkir barang', 0.00, 45000.00),
  ('t4a64cec7821f', 'kas_keluar', '2026-10-29', 'CO-2610-1541', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon dani', 0.00, 1000000.00),
  ('t6a969889cf44', 'kas_keluar', '2026-10-29', 'CO-2610-1542', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'pelunasan AC', 0.00, 63850000.00),
  ('t94776c109297', 'kas_keluar', '2026-10-29', 'CO-2610-1543', 'Kas Besar', 'Biaya Upah', 'KNMP Pekalongan', '', 'KNMP pekalongan', 0.00, 1000000000.00),
  ('t3d052b0f1544', 'kas_keluar', '2026-10-29', 'CO-2610-1544', 'Kas Besar', 'Biaya Upah', 'KNMP Donggala', '', 'KNMP donggala', 0.00, 500000000.00),
  ('t6c7c6337f018', 'kas_keluar', '2026-10-29', 'CO-2610-1545', 'Kas Besar', 'Biaya Upah', 'KNMP Cibalong', '', 'KNMP pmpk', 0.00, 1500000000.00),
  ('t172a97550bf6', 'kas_keluar', '2026-10-29', 'CO-2610-1546', 'Kas Besar', 'Biaya Bahan', 'Armed', '', 'pemotongan listrik', 0.00, 2500000.00),
  ('t7b6c76ca1376', 'kas_keluar', '2026-10-29', 'CO-2610-1547', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'semen 100sak', 0.00, 4500000.00),
  ('t24ac0e4142a8', 'kas_keluar', '2026-10-29', 'CO-2610-1548', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'pilox, skrup', 0.00, 186000.00),
  ('td01fd1344fd7', 'kas_keluar', '2026-10-29', 'CO-2610-1549', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'triplek, dll', 0.00, 1616000.00),
  ('t63100a9a2ec7', 'kas_keluar', '2026-10-29', 'CO-2610-1550', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'beading, lis', 0.00, 2972500.00),
  ('t2cf3635c8e8b', 'kas_keluar', '2026-10-29', 'CO-2610-1551', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kaso', 0.00, 324000.00),
  ('t2005d55edf29', 'kas_keluar', '2026-10-29', 'CO-2610-1552', 'Kas Besar', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Berkat', 'nota berkat 10/9', 0.00, 76535600.00),
  ('t48847cd07dc6', 'kas_keluar', '2026-10-29', 'CO-2610-1553', 'Kas Besar', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Berkat', 'nota berkat 5/9', 0.00, 22419780.00),
  ('t80313033b33c', 'kas_keluar', '2026-10-29', 'CO-2610-1554', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', 'kontrakan', 0.00, 1350000.00),
  ('tba9475e59d1b', 'kas_keluar', '2026-10-29', 'CO-2610-1555', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim m. zek', 0.00, 6000000.00),
  ('t141e4353d7ad', 'kas_keluar', '2026-10-29', 'CO-2610-1556', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'bayaran pesantren al hasan', 0.00, 2770000.00),
  ('t8b5bafc18fb0', 'kas_keluar', '2026-10-29', 'CO-2610-1557', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'bayaran pesantren al mabrur', 0.00, 1980000.00),
  ('t3f7e0c99f723', 'kas_keluar', '2026-10-29', 'CO-2610-1558', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'kekurangan sewa sk75', 0.00, 2050000.00),
  ('t7f8d3799020b', 'kas_keluar', '2026-10-29', 'CO-2610-1559', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'buang barangkal', 0.00, 3000000.00),
  ('tc34ca164d9ee', 'kas_keluar', '2026-10-29', 'CO-2610-1560', 'Kas Besar', 'Biaya entertain', 'BJB', '', 'duren pak sony + ongkir', 0.00, 840500.00),
  ('t6a67ac51b673', 'kas_keluar', '2026-10-29', 'CO-2610-1561', 'Kas Besar', 'Biaya ADM', 'BJB', '', 'adm (s)', 0.00, 50000000.00),
  ('t367901c29460', 'kas_keluar', '2026-10-29', 'CO-2610-1562', 'Kas Besar', 'Biaya Bahan', 'BJB Prioritas Jakarta', '', 'AC bjb kelapa gading', 0.00, 7650000.00),
  ('t3727f902bffa', 'kas_keluar', '2026-10-29', 'CO-2610-1563', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', 'kasbon upah bogor', 0.00, 53730000.00),
  ('t2b0ecfd99a0a', 'kas_keluar', '2026-10-29', 'CO-2610-1564', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (ongkos pekerja listrik)', 0.00, 100000.00),
  ('te0eeac8f5765', 'kas_keluar', '2026-10-29', 'CO-2610-1565', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (ongkir pintu, thinner)', 0.00, 47000.00),
  ('t358b2296a48b', 'kas_keluar', '2026-10-29', 'CO-2610-1566', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (bensin)', 0.00, 100000.00),
  ('t98a724e6ea97', 'kas_keluar', '2026-10-29', 'CO-2610-1567', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'molen', 0.00, 6500000.00),
  ('t715c62f913bf', 'kas_keluar', '2026-10-29', 'CO-2610-1568', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'ongkos pekerja baru', 0.00, 800000.00),
  ('t9a794a6015c0', 'kas_keluar', '2026-10-29', 'CO-2610-1569', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pasir pasang 2 rit', 0.00, 4800000.00),
  ('t236be8e0362c', 'kas_keluar', '2026-10-29', 'CO-2610-1570', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'keramik denzi', 0.00, 42000000.00),
  ('t4df028ab6c58', 'kas_keluar', '2026-10-29', 'CO-2610-1571', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'kasbon pasir', 0.00, 12600000.00),
  ('tcfaed4f0395a', 'kas_keluar', '2026-10-29', 'CO-2610-1572', 'Kas Besar', 'Biaya Upah', 'Zidam Renov Rumdis Bogor', '', 'kasbon upah denzi', 0.00, 37650000.00),
  ('tcbb8b19328d6', 'kas_keluar', '2026-10-29', 'CO-2610-1573', 'Kas Besar', 'Biaya Akomodasi', 'Zidam Rehab Rumdis Cimahi', '', 'kontrakan', 0.00, 1350000.00),
  ('t597aadaeec85', 'kas_keluar', '2026-10-29', 'CO-2610-1574', 'Kas Besar', 'Hutang Bank Jk.Pendek PT', 'Cost Center - Pendanaan Uang', '', 'cicilan pembayaran kelayakan knmp', 0.00, 1345547919.00),
  ('t758a44159794', 'kas_keluar', '2026-10-29', 'CO-2610-1575', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Bogor', '', 'Pintu bogor 30pcs x 470.000 = 14.100.000, dikurangi DP 5jt', 0.00, 9100000.00),
  ('t802de2d07a7b', 'kas_keluar', '2026-10-29', 'CO-2610-1576', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'Pintu subang', 0.00, 24245000.00),
  ('t56bc13302088', 'kas_masuk', '2026-10-29', 'CI-2610-0034', 'Kas Besar', 'Pendapatan Proyek', 'KNMP Cibalong', '', 'uang masuk knmp garut', 2345547919.00, 0.00),
  ('t1d24e392993d', 'kas_masuk', '2026-10-29', 'CI-2610-0035', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 29 oktober', 2469394480.00, 0.00);
