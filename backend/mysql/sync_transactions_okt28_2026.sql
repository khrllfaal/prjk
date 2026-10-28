-- Sinkronisasi 28 Oktober 2026.
--
-- 77 transaksi baru (lihat INSERT transactions di bawah).
-- 2 relasi Prive diberi lewat pencocokan nominal persis dengan delta Data Prive:
--  - CO-2610-1472 + CO-2610-1473 = Rp106.000 + Rp35.000 = Rp141.000 = kenaikan Pr-Z
--
-- Penyesuaian NYATA (bukan normalisasi spasi) pada transaksi lama:
--  - CO-2608-0818: akun lawan Peralatan Kandang -> Biaya Perlengkapan Kandang
--  - CO-2609-0947: akun lawan Biaya Listrik, Air & Telepon -> Hutang lancar Lainnya
--  - CO-2609-0952: project Farm Cilame 1 periode 5 -> periode 4, akun lawan Biaya
--    CSR/Kompensasi/Sumbangan -> Hutang lancar Lainnya
--  - CO-2610-1329: keterangan "belanja tgl 27" -> "belanja tgl 26" (koreksi tanggal)
--  - CO-2610-1417: nominal Rp6.992.000 -> Rp1.112.000 (ada retur Rp5.880.000, ket
--    diperbarui jadi 'paku rivet, kaca (nota 6.992.000 diretur 5.880.000)')
--
--  - CO-2608-0325: relasi kosong -> V-HU-Berkat (Rp111.490.500, ket sudah jelas
--    sebut 'berkat' tapi field vendor belum pernah diisi -- bug data lama, BUKAN
--    dari sync ini, ketemu lewat verifikasi Buku Besar V-HU-Berkat 147-baris dari
--    user. Ini PENJELASAN UTAMA selisih Rp111.520.500 pada Total Hutang Berkat.)
--
-- Koreksi Hutang Dagang V-HU-Berkat (dari Jurnal Umum, -Rp10.000 tiap voucher,
-- sisi Hutang Dagang DAN sisi Biaya Bahan disesuaikan supaya tetap balance):
--  - JU26090061: Rp7.469.200 -> Rp7.459.200
--  - JU26090062: Rp7.469.200 -> Rp7.459.200
--  - JU26070022: Rp21.822.400 -> Rp21.812.400
-- CATATAN: ketiga koreksi ini cuma menjelaskan Rp30.000 dari total penurunan
-- Rp111.520.500 pada Total Hutang V-HU-Berkat yang user laporkan. SISA SELISIH
-- Rp111.490.500 BELUM TERJELASKAN dari 5 file yang diupload (jurnal_umum_Report_5,
-- bank_out/in_Report_4, cash_out_Report_5, cash_in_Report_4) -- tidak ditemukan
-- voucher baru, pembayaran baru, atau perubahan nominal/vendor/project lain untuk
-- V-HU-Berkat di kelima file itu. Perlu data tambahan (mis. Buku Besar lengkap
-- vendor V-HU-Berkat) untuk menelusuri sisa selisih ini -- TIDAK DIPAKSAKAN cocok.

UPDATE `jurnal_umum` SET `kredit` = 7459200.00 WHERE `id` = 'j159' AND `kredit` = 7469200.00;
UPDATE `jurnal_umum` SET `debet` = 6719009.00 WHERE `id` = 'j157' AND `debet` = 6729009.00;
UPDATE `jurnal_umum` SET `kredit` = 7459200.00 WHERE `id` = 'j162' AND `kredit` = 7469200.00;
UPDATE `jurnal_umum` SET `debet` = 6719009.00 WHERE `id` = 'j160' AND `debet` = 6729009.00;
UPDATE `jurnal_umum` SET `kredit` = 21812400.00 WHERE `id` = 'j61' AND `kredit` = 21822400.00;
UPDATE `jurnal_umum` SET `debet` = 21812400.00 WHERE `id` = 'j60' AND `debet` = 21822400.00;

UPDATE `transactions` SET `akun_lawan` = 'Biaya Perlengkapan Kandang' WHERE `ref` = 'CO-2608-0818' AND `akun_lawan` = 'Peralatan Kandang';
UPDATE `transactions` SET `akun_lawan` = 'Hutang lancar Lainnya' WHERE `ref` = 'CO-2609-0947' AND `akun_lawan` = 'Biaya Listrik, Air & Telepon';
UPDATE `transactions` SET `project` = 'Farm Cilame 1 periode 4', `akun_lawan` = 'Hutang lancar Lainnya' WHERE `ref` = 'CO-2609-0952' AND `project` = 'Farm Cilame 1 periode 5';
UPDATE `transactions` SET `ket` = 'belanja tgl 26' WHERE `ref` = 'CO-2610-1329' AND `ket` = 'belanja tgl 27';
UPDATE `transactions` SET `kredit` = 1112000.00, `ket` = 'paku rivet, kaca (nota 6.992.000 diretur 5.880.000)' WHERE `ref` = 'CO-2610-1417' AND `kredit` = 6992000.00;
UPDATE `transactions` SET `relasi` = 'V-HU-Berkat' WHERE `ref` = 'CO-2608-0325' AND `relasi` = '';

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t0504c7ddcb25', 'bank_keluar', '2026-10-28', 'BO-2610-0036', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 28 oktober', 0.00, 100002021.00),
  ('t2a3d2a464deb', 'bank_masuk', '2026-10-28', 'BI-2610-0014', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'RS Guntur Gudang Farmasi', '', 'uang masuk gudang farmasi', 361000000.00, 0.00),
  ('t7e632fe12cc8', 'bank_masuk', '2026-10-28', 'BI-2610-0015', 'Bank BJB RC Purbayanti', 'Pendapatan Proyek', 'BJB Pangandaran', '', 'uang masuk fisik pangandaran', 829505520.00, 0.00),
  ('t5a711d9afff9', 'kas_keluar', '2026-10-28', 'CO-2610-1448', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cibeureum periode 6', '', 'cloth tape cibeureum', 0.00, 164500.00),
  ('t47aa95f22f6a', 'kas_keluar', '2026-10-28', 'CO-2610-1449', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'service panther cilame 1', 0.00, 100000.00),
  ('t19d325a2e59a', 'kas_keluar', '2026-10-28', 'CO-2610-1450', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cibeureum periode 6', '', 'service motor kandang', 0.00, 701000.00),
  ('tae273d9cfba6', 'kas_keluar', '2026-10-28', 'CO-2610-1451', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'pilok', 0.00, 100000.00),
  ('t26f9dfa6fa21', 'kas_keluar', '2026-10-28', 'CO-2610-1452', 'Kas Besar', 'Biaya Pemeliharaan Peralatan Kantor', 'Cost Center', '', 'dinamo dan cuci steam', 0.00, 150000.00),
  ('t35bb18c398f3', 'kas_keluar', '2026-10-28', 'CO-2610-1453', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'air aki', 0.00, 150000.00),
  ('te3de97c3b3a4', 'kas_keluar', '2026-10-28', 'CO-2610-1454', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'pasang lampu & kabel panter', 0.00, 100000.00),
  ('tfe825da1db70', 'kas_keluar', '2026-10-28', 'CO-2610-1455', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'stim', 0.00, 50000.00),
  ('t632b9474ffc9', 'kas_keluar', '2026-10-28', 'CO-2610-1456', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 27/10', 0.00, 35000.00),
  ('t3b34a6de919a', 'kas_keluar', '2026-10-28', 'CO-2610-1457', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin pak eri', 0.00, 50000.00),
  ('t9f3458ad7c6f', 'kas_keluar', '2026-10-28', 'CO-2610-1458', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin gupron', 0.00, 25000.00),
  ('tabe5b68bbef1', 'kas_keluar', '2026-10-28', 'CO-2610-1459', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin', 0.00, 13000.00),
  ('te742f3c5e179', 'kas_keluar', '2026-10-28', 'CO-2610-1460', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'service motor asep', 0.00, 240000.00),
  ('t353a24265027', 'kas_keluar', '2026-10-28', 'CO-2610-1461', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'ongkos kpm pa zamzam', 0.00, 60000.00),
  ('t47331980a5b9', 'kas_keluar', '2026-10-28', 'CO-2610-1462', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'cash pa zamzam', 0.00, 50000.00),
  ('t38fd7a40fedd', 'kas_keluar', '2026-10-28', 'CO-2610-1463', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nasi, kerupuk, lotek 27/10', 0.00, 47000.00),
  ('t2c22ed334af9', 'kas_keluar', '2026-10-28', 'CO-2610-1464', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'soto ayam 26/10', 0.00, 46000.00),
  ('t9ea983d50d8a', 'kas_keluar', '2026-10-28', 'CO-2610-1465', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'galon', 0.00, 21000.00),
  ('t0bfcbd69c557', 'kas_keluar', '2026-10-28', 'CO-2610-1466', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, nutribubu', 0.00, 61000.00),
  ('tb5c7fe0efe0e', 'kas_keluar', '2026-10-28', 'CO-2610-1467', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kirim tiki ke karimun', 0.00, 48000.00),
  ('t797b4db3ef10', 'kas_keluar', '2026-10-28', 'CO-2610-1468', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'gorengan', 0.00, 10000.00),
  ('te6f00adc269e', 'kas_keluar', '2026-10-28', 'CO-2610-1469', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kirim paket', 0.00, 15000.00),
  ('t8186aa89f299', 'kas_keluar', '2026-10-28', 'CO-2610-1470', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat pak zamzam', 0.00, 31000.00),
  ('t938954a256e4', 'kas_keluar', '2026-10-28', 'CO-2610-1471', 'Kas Besar', 'Biaya Bahan', 'KDMP Caringin', '', 'bahan repair kdmp', 0.00, 219000.00),
  ('t1a4a52027c34', 'kas_keluar', '2026-10-28', 'CO-2610-1472', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'pulpen, tahu, kacang, cash 29 rb pak zamzam', 0.00, 106000.00),
  ('tebd24e856773', 'kas_keluar', '2026-10-28', 'CO-2610-1473', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'permak (pa zamzam)', 0.00, 35000.00),
  ('t4ed2853e3fbb', 'kas_keluar', '2026-10-28', 'CO-2610-1474', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'RS Guntur Gudang Farmasi', '', 'sumbangan', 0.00, 10000000.00),
  ('tc8103171db6f', 'kas_keluar', '2026-10-28', 'CO-2610-1475', 'Kas Besar', 'Biaya Upah', 'Kodim Kuningan', '', 'agus', 0.00, 15000000.00),
  ('t8a3f6fc61174', 'kas_keluar', '2026-10-28', 'CO-2610-1476', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 28', 0.00, 5500000.00),
  ('t92095af66fd4', 'kas_keluar', '2026-10-28', 'CO-2610-1477', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'bahan ART', 0.00, 2450000.00),
  ('te4dbe5397365', 'kas_keluar', '2026-10-28', 'CO-2610-1478', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'service dumptruk cibalong', 0.00, 1510000.00),
  ('tf31311f73649', 'kas_keluar', '2026-10-28', 'CO-2610-1479', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'solar dumptruk', 0.00, 300000.00),
  ('t25bc1601942e', 'kas_keluar', '2026-10-28', 'CO-2610-1480', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'ongkos tim dani ke dustira', 0.00, 500000.00),
  ('t76fc161ec88f', 'kas_keluar', '2026-10-28', 'CO-2610-1481', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'DP handrail', 0.00, 15955000.00),
  ('tc1bf95c2edba', 'kas_keluar', '2026-10-28', 'CO-2610-1482', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', 'kontrakan pekerja', 0.00, 900000.00),
  ('t2e926fa2d634', 'kas_keluar', '2026-10-28', 'CO-2610-1483', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'karung dll', 0.00, 472000.00),
  ('t6f72a8d47b4a', 'kas_keluar', '2026-10-28', 'CO-2610-1484', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'tambang', 0.00, 55000.00),
  ('t4d145b83f092', 'kas_keluar', '2026-10-28', 'CO-2610-1485', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'galon', 0.00, 385000.00),
  ('tf7c46521afa2', 'kas_keluar', '2026-10-28', 'CO-2610-1486', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'holo, papan gypsum', 0.00, 1972500.00),
  ('t4fe89727f4c4', 'kas_keluar', '2026-10-28', 'CO-2610-1487', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'papan gypsum aplus', 0.00, 5050000.00),
  ('t1cf5b24d9417', 'kas_keluar', '2026-10-28', 'CO-2610-1488', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'keramik, kran, hand shower', 0.00, 2860000.00),
  ('te64aa7a71249', 'kas_keluar', '2026-10-28', 'CO-2610-1489', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'flexible', 0.00, 132000.00),
  ('t03f9512a2edd', 'kas_keluar', '2026-10-28', 'CO-2610-1490', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'amplop termin', 0.00, 9450000.00),
  ('t78f668f8a82b', 'kas_keluar', '2026-10-28', 'CO-2610-1491', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'amplop lapju (mayor supri)', 0.00, 1000000.00),
  ('t0cfd99750beb', 'kas_keluar', '2026-10-28', 'CO-2610-1492', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'ZIDAM Bangun Rumdis Pangandaran', '', 'op gupron termin pangandaran 27/10', 0.00, 248000.00),
  ('ta1fec0374201', 'kas_keluar', '2026-10-28', 'CO-2610-1493', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'cor jalan subang (uang lintas tm dll)', 0.00, 1800000.00),
  ('tccd27da56d3c', 'kas_keluar', '2026-10-28', 'CO-2610-1494', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'uang lintas TM untuk dansub subang (30 rit)', 0.00, 600000.00),
  ('t3397270f5486', 'kas_keluar', '2026-10-28', 'CO-2610-1495', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'kunjungan dinas', 0.00, 300000.00),
  ('tba425f19d797', 'kas_keluar', '2026-10-28', 'CO-2610-1496', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'pancang', 0.00, 45221400.00),
  ('te9927400dc1b', 'kas_keluar', '2026-10-28', 'CO-2610-1497', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar dan um operator', 0.00, 1000000.00),
  ('t30c997dc52d7', 'kas_keluar', '2026-10-28', 'CO-2610-1498', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'buang tanah', 0.00, 2500000.00),
  ('tb9af6969f1d3', 'kas_keluar', '2026-10-28', 'CO-2610-1499', 'Kas Besar', 'Biaya Upah2', 'BJB', '', 'reinburse pengawas dan makan', 0.00, 1401000.00),
  ('t1211188cfb49', 'kas_keluar', '2026-10-28', 'CO-2610-1500', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Bogor', '', 'kasbon tim plafond 27/10', 0.00, 600000.00),
  ('tb315b4d8995d', 'kas_keluar', '2026-10-28', 'CO-2610-1501', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Bogor', '', 'gypsum, holo, dll', 0.00, 20602000.00),
  ('te11552f06cdd', 'kas_keluar', '2026-10-28', 'CO-2610-1502', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Bogor', '', 'tambahan DP pintu', 0.00, 5000000.00),
  ('tffb326c51c05', 'kas_keluar', '2026-10-28', 'CO-2610-1503', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Bangun Koramil Majalengka Cingambul', '', 'op. arya majalengka (sewa mobil)', 0.00, 750000.00),
  ('tb42645207591', 'kas_keluar', '2026-10-28', 'CO-2610-1504', 'Kas Besar', 'Biaya Upah', 'BJB Prioritas Jakarta', '', 'kelapa gading', 0.00, 29500000.00),
  ('tf607720207ef', 'kas_keluar', '2026-10-28', 'CO-2610-1505', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Bangun Koramil Majalengka Maulusma', '', 'op. arya majalengka (sewa mobil)', 0.00, 750000.00),
  ('t194f843a3cd1', 'kas_keluar', '2026-10-28', 'CO-2610-1506', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Koramil Majalengka Cingambul', '', 'kirim kunci', 0.00, 12650.00),
  ('tb8d01093aed7', 'kas_keluar', '2026-10-28', 'CO-2610-1507', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Koramil Majalengka Maulusma', '', 'kirim kunci', 0.00, 12650.00),
  ('t0546cc3c871a', 'kas_keluar', '2026-10-28', 'CO-2610-1508', 'Kas Besar', 'Biaya Dibayar Dimuka', 'Kemhan Bangun Koramil Majalengka Cingambul', '', 'op arya bareng konwas', 0.00, 500000.00),
  ('t98f269d50e40', 'kas_keluar', '2026-10-28', 'CO-2610-1509', 'Kas Besar', 'Biaya Dibayar Dimuka', 'Kemhan Bangun Koramil Majalengka Maulusma', '', 'op arya bareng konwas', 0.00, 500000.00),
  ('tac017af30b15', 'kas_keluar', '2026-10-28', 'CO-2610-1510', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'keramik dinding dan lantai', 0.00, 14300000.00),
  ('t22d29467326d', 'kas_keluar', '2026-10-28', 'CO-2610-1511', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'bahan hebel, gypsum dll', 0.00, 8390000.00),
  ('te367458673f6', 'kas_keluar', '2026-10-28', 'CO-2610-1512', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'pasir', 0.00, 3700000.00),
  ('tc1bd62cdfebb', 'kas_keluar', '2026-10-28', 'CO-2610-1513', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'urinoir dan wastafel', 0.00, 18319000.00),
  ('tb4b18d164ac7', 'kas_keluar', '2026-10-28', 'CO-2610-1514', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'pasir pasang 1 rit', 0.00, 2400000.00),
  ('t87ca8ca29e4d', 'kas_keluar', '2026-10-28', 'CO-2610-1515', 'Kas Besar', 'Biaya Upah2', 'Zidam Rehab Rumdis Cimahi', '', 'kasbon tim ato baja', 0.00, 1500000.00),
  ('ta17e1056467a', 'kas_keluar', '2026-10-28', 'CO-2610-1516', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'benang nylond', 0.00, 100000.00),
  ('tf4627967cb97', 'kas_keluar', '2026-10-28', 'CO-2610-1517', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'sekrup, textile', 0.00, 618000.00),
  ('t8a60b4c178b9', 'kas_keluar', '2026-10-28', 'CO-2610-1518', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'silent x-key 240btl (dari uang retur 5.880.000)', 0.00, 5130000.00),
  ('ta2668574d506', 'kas_keluar', '2026-10-28', 'CO-2610-1519', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'dekson door closer (dari sisa uang retur 5.880.000)', 0.00, 1160000.00),
  ('te7bd5a07534b', 'kas_masuk', '2026-10-28', 'CI-2610-0032', 'Kas Besar', 'Pendapatan Pengadaan', 'RS Guntur Belanja Dapur', '', 'uang mamin 1-15 oktober', 137151679.00, 0.00),
  ('tcc7f1cb40f65', 'kas_masuk', '2026-10-28', 'CI-2610-0033', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 28 oktober', 100002021.00, 0.00);
