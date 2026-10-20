-- Sinkronisasi dari Report export terbaru (20 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup semua
-- file sync sebelumnya s/d sync_transactions_okt19_2026.sql.
--
-- Ditemukan 79 transaksi baru, 0 transaksi hilang, dan 1 penyesuaian
-- (CO-2610-0699: Biaya ADM -> Biaya Bahan, reklasifikasi murni).
--
-- 2 transaksi baru diberi relasi langsung, DIVERIFIKASI SILANG terhadap
-- penurunan baris Data Hutang sistem asli:
--  - CO-2610-1072 ('pembayaran kelayakan dari termen 2 satpol pp',
--    Rp1.000.000.000) -> HB-BJB, turun tepat dari 8.353.689.307 ke
--    7.353.689.307.
--  - CO-2610-1042 ('bayar pinjaman ke pak zamzam', Rp154.000.000) ->
--    HPK-Zam, turun tepat dari 355.240.045 ke 201.240.045.
--
-- CATATAN: ~13 transaksi Prive baru hari ini (CO-2610-1031, 1033-1048)
-- BELUM diberi relasi -- Data Prive yang dikirim hari ini angkanya persis
-- sama dengan Data Prive kemarin (19 Oktober), padahal transaksi baru ini
-- jelas menyentuh akun Prive dengan nilai nyata. Kemungkinan Data Prive
-- yang di-paste belum ter-refresh -- mohon dikonfirmasi ulang sebelum
-- relasi-nya ditentukan, supaya tidak menebak.

-- 79 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t4cc78c1d96a8', 'bank_masuk', '2026-10-20', 'BI-2610-0010', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'PUPR Bangun Satpol PP Sumedang', '', 'termin ke-2 satpol pp', 1076000000.00, 0.00),
  ('t07f6d0663083', 'bank_keluar', '2026-10-20', 'BO-2610-0023', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 20 oktober', 0.00, 1083890759.00),
  ('t8f481c9bde94', 'kas_masuk', '2026-10-20', 'CI-2610-0024', 'Kas Besar', 'Pendapatan Proyek', 'PUPR Bangun Satpol PP Sumedang', '', 'termin 2 satpol pp', 1000000000.00, 0.00),
  ('tfd35edfccbc5', 'kas_masuk', '2026-10-20', 'CI-2610-0025', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 20 oktober', 1083890759.00, 0.00),
  ('t501cd199bf43', 'kas_keluar', '2026-10-20', 'CO-2610-0998', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'biaya trf pelet cbr', 0.00, 2500.00),
  ('t6206697edaf5', 'kas_keluar', '2026-10-20', 'CO-2610-0999', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Farm Cilame 1 periode 5', '', 'biaya bayar listrik clm 1', 0.00, 15000.00),
  ('t1d3642f84668', 'kas_keluar', '2026-10-20', 'CO-2610-1000', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (15/10)', 0.00, 40000.00),
  ('t1fe501486fe9', 'kas_keluar', '2026-10-20', 'CO-2610-1001', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (18/10)', 0.00, 30000.00),
  ('te637f98131f5', 'kas_keluar', '2026-10-20', 'CO-2610-1002', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'bussi (18/10)', 0.00, 25000.00),
  ('t5dfe7434f971', 'kas_keluar', '2026-10-20', 'CO-2610-1003', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (17/10)', 0.00, 13500.00),
  ('t2f3df2bef72d', 'kas_keluar', '2026-10-20', 'CO-2610-1004', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'biaya bayar listrik', 0.00, 15000.00),
  ('ta4c5e4106136', 'kas_keluar', '2026-10-20', 'CO-2610-1005', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya trf', 0.00, 10000.00),
  ('t4ae9dea1f77b', 'kas_keluar', '2026-10-20', 'CO-2610-1006', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'uang cash receh inova hitam', 0.00, 200000.00),
  ('tcddb325c3f63', 'kas_keluar', '2026-10-20', 'CO-2610-1007', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'rompi kantor (14/10)', 0.00, 1700000.00),
  ('t3d303c4c9c48', 'kas_keluar', '2026-10-20', 'CO-2610-1008', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'ayam & nasi', 0.00, 145000.00),
  ('t6cccc4d0410e', 'kas_keluar', '2026-10-20', 'CO-2610-1009', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'air minum eternal 1 pcs (14/10)', 0.00, 9300.00),
  ('t82bdf36f7d79', 'kas_keluar', '2026-10-20', 'CO-2610-1010', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nasi 2 & paha ayam 2 (14/10)', 0.00, 82000.00),
  ('tf39a660a9979', 'kas_keluar', '2026-10-20', 'CO-2610-1011', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kirim paket (14/10)', 0.00, 11000.00),
  ('t8d8a20869d29', 'kas_keluar', '2026-10-20', 'CO-2610-1012', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'bubur (15/10)', 0.00, 21000.00),
  ('t9969e3f7d638', 'kas_keluar', '2026-10-20', 'CO-2610-1013', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat nacl & disposible (15/10)', 0.00, 26000.00),
  ('t7f6f7d37784f', 'kas_keluar', '2026-10-20', 'CO-2610-1014', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kirim paket (15/10)', 0.00, 20000.00),
  ('t243c83f39754', 'kas_keluar', '2026-10-20', 'CO-2610-1015', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, baso & dokeh (15/10)', 0.00, 67500.00),
  ('t975b60e41bb3', 'kas_keluar', '2026-10-20', 'CO-2610-1016', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat aquabidest & cernevit (15/10)', 0.00, 374700.00),
  ('t613ff35f07c0', 'kas_keluar', '2026-10-20', 'CO-2610-1017', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat L-Bio & lecozinc (15/10)', 0.00, 64000.00),
  ('t429948bab692', 'kas_keluar', '2026-10-20', 'CO-2610-1018', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kertas A4 (18/10)', 0.00, 50000.00),
  ('t600b8c5f6838', 'kas_keluar', '2026-10-20', 'CO-2610-1019', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'galon (17/10)', 0.00, 22000.00),
  ('t73b1bced5834', 'kas_keluar', '2026-10-20', 'CO-2610-1020', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM rendy', 0.00, 200000.00),
  ('ta3cd42e55ec6', 'kas_keluar', '2026-10-20', 'CO-2610-1021', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kertas A4 (17/10)', 0.00, 80000.00),
  ('t21c4f1a66e4a', 'kas_keluar', '2026-10-20', 'CO-2610-1022', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat pa karli (17/10)', 0.00, 168500.00),
  ('tda43cb0925f4', 'kas_keluar', '2026-10-20', 'CO-2610-1023', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'cleo 4 pak (19/10)', 0.00, 84000.00),
  ('tef04c61e903f', 'kas_keluar', '2026-10-20', 'CO-2610-1024', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi (19/10)', 0.00, 22000.00),
  ('t7d9b6ed26904', 'kas_keluar', '2026-10-20', 'CO-2610-1025', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'lembur, beli jus (19/10)', 0.00, 39000.00),
  ('tf776204d427f', 'kas_keluar', '2026-10-20', 'CO-2610-1026', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi (20/10)', 0.00, 22000.00),
  ('t1abaf1ad953a', 'kas_keluar', '2026-10-20', 'CO-2610-1027', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'bubur (20/10)', 0.00, 14999.00),
  ('ta54ef5eb99cf', 'kas_keluar', '2026-10-20', 'CO-2610-1028', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'spring roll chickeun, spring roll egg, sauce (20/10)', 0.00, 39000.00),
  ('t9465ebaede1b', 'kas_keluar', '2026-10-20', 'CO-2610-1029', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nasi paket dadar & es teler (20/10)', 0.00, 33000.00),
  ('t3cad7447be03', 'kas_keluar', '2026-10-20', 'CO-2610-1030', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'chat GPT pa fahri', 0.00, 402000.00),
  ('t4cb32a2be803', 'kas_keluar', '2026-10-20', 'CO-2610-1031', 'Kas Besar', 'Prive', 'Prive', '', 'kasbon nani', 0.00, 300000.00),
  ('t92706ee1147f', 'kas_keluar', '2026-10-20', 'CO-2610-1032', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Cost Center', '', 'OP gupron, ke BJB syariah (12/10)', 0.00, 659900.00),
  ('tbff628b7e92c', 'kas_keluar', '2026-10-20', 'CO-2610-1033', 'Kas Besar', 'Prive', 'Prive', '', 'uang 2000an bita', 0.00, 200000.00),
  ('t713c3b34f6bf', 'kas_keluar', '2026-10-20', 'CO-2610-1034', 'Kas Besar', 'Prive', 'Prive', '', 'uang 2000an gasa', 0.00, 200000.00),
  ('tb0f247ac4f90', 'kas_keluar', '2026-10-20', 'CO-2610-1035', 'Kas Besar', 'Prive', 'Prive', '', 'pak ei, solar inova', 0.00, 500000.00),
  ('tfddb594d9721', 'kas_keluar', '2026-10-20', 'CO-2610-1036', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, untuk nusajaya beli soto, antangin, dll (12/10)', 0.00, 80000.00),
  ('tca83279c35ab', 'kas_keluar', '2026-10-20', 'CO-2610-1037', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, yntuk nusajaya beras, pak haji, plastik (13/10)', 0.00, 295000.00),
  ('t2bb7f49c2a2d', 'kas_keluar', '2026-10-20', 'CO-2610-1038', 'Kas Besar', 'Prive', 'Prive', '', 'pak zamzam, beras 10kg (15/10)', 0.00, 175000.00),
  ('t70d80e15bf12', 'kas_keluar', '2026-10-20', 'CO-2610-1039', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, untuk nusajaya arit (15/10)', 0.00, 100000.00),
  ('tf6bf47645508', 'kas_keluar', '2026-10-20', 'CO-2610-1040', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, untuk nusajaya kerupuk kulit (15/10)', 0.00, 57000.00),
  ('t98b2c0b81393', 'kas_keluar', '2026-10-20', 'CO-2610-1041', 'Kas Besar', 'Prive', 'Prive', '', 'pa zamzam, Kabel Duct TC 5 (18/10)', 0.00, 20000.00),
  ('td52bdcb1cb11', 'kas_keluar', '2026-10-20', 'CO-2610-1042', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', 'HPK-Zam', 'bayar pinjaman ke pak zamzam', 0.00, 154000000.00),
  ('tda9646a7e6a8', 'kas_keluar', '2026-10-20', 'CO-2610-1043', 'Kas Besar', 'Prive', 'Prive', '', 'bu dessy (18/10)', 0.00, 135000.00),
  ('tb7b975e97b5c', 'kas_keluar', '2026-10-20', 'CO-2610-1044', 'Kas Besar', 'Prive', 'Prive', '', 'pa karli, martabak', 0.00, 120000.00),
  ('ta8720ec95734', 'kas_keluar', '2026-10-20', 'CO-2610-1045', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, beli kue milo crepes. choco cheese, dsb (17/10)', 0.00, 184000.00),
  ('t81c3e54cf42f', 'kas_keluar', '2026-10-20', 'CO-2610-1046', 'Kas Besar', 'Prive', 'Prive', '', 'pa zamzam, kirim paket (20/10)', 0.00, 63000.00),
  ('t7ad83afcd52b', 'kas_keluar', '2026-10-20', 'CO-2610-1047', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, beli bubur, kupat, dsb (17/10)', 0.00, 99000.00),
  ('t6e1531c8df69', 'kas_keluar', '2026-10-20', 'CO-2610-1048', 'Kas Besar', 'Prive', 'Prive', '', 'pa karli, kepala casan (17/10)', 0.00, 203000.00),
  ('tfa8dbfd13c60', 'kas_keluar', '2026-10-20', 'CO-2610-1049', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan', '', 'Op andri & yuki ke cimahi ketemu konwas kemhan (17/10)', 0.00, 688000.00),
  ('t5224d5e9e6ad', 'kas_keluar', '2026-10-20', 'CO-2610-1050', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'restu ibu', 0.00, 574000000.00),
  ('t1520ee0d4aba', 'kas_keluar', '2026-10-20', 'CO-2610-1051', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'Belanja tgl 20', 0.00, 8000000.00),
  ('ted8fcd8ef6d8', 'kas_keluar', '2026-10-20', 'CO-2610-1052', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'DP plin', 0.00, 20924500.00),
  ('t242bce29259a', 'kas_keluar', '2026-10-20', 'CO-2610-1053', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang barangkal', 0.00, 3150000.00),
  ('t1e4e6eed5f02', 'kas_keluar', '2026-10-20', 'CO-2610-1054', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'upah pekerja grop ii (off)', 0.00, 2822000.00),
  ('tb085a6680974', 'kas_keluar', '2026-10-20', 'CO-2610-1055', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Bangun Rumdis Subang', '', 'OP komeng, rasel ke subang & bogor (11/10)', 0.00, 831580.00),
  ('t97507bf9613d', 'kas_keluar', '2026-10-20', 'CO-2610-1056', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kawat, keni, koas, dll', 0.00, 1311500.00),
  ('t3df1e0726c2c', 'kas_keluar', '2026-10-20', 'CO-2610-1057', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'DP paving', 0.00, 30000000.00),
  ('t0a0726b61a97', 'kas_keluar', '2026-10-20', 'CO-2610-1058', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'ongkos biotank (cimahi 16, subang 20)', 0.00, 3050000.00),
  ('tdc80790a666a', 'kas_keluar', '2026-10-20', 'CO-2610-1059', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'ongkos  bahan alumunium', 0.00, 300000.00),
  ('t4ed083a15cd0', 'kas_keluar', '2026-10-20', 'CO-2610-1060', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'atap (genteng)', 0.00, 39340000.00),
  ('tf1e74acbf1a5', 'kas_keluar', '2026-10-20', 'CO-2610-1061', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'sisa bayar beton 150m3 subang', 0.00, 80000000.00),
  ('t2dadd422ca88', 'kas_keluar', '2026-10-20', 'CO-2610-1062', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', '1 drum aspal subang (19/10)', 0.00, 2400000.00),
  ('t31cf69e2528c', 'kas_keluar', '2026-10-20', 'CO-2610-1063', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'ritase & uang lintas cor jalan subang', 0.00, 1000000.00),
  ('td834efdb95e5', 'kas_keluar', '2026-10-20', 'CO-2610-1064', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'insentif teknisi, batcher, jamuan cor pengawas', 0.00, 500000.00),
  ('tf18aa8526369', 'kas_keluar', '2026-10-20', 'CO-2610-1065', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'operasional pengecoran (TM, operator)', 0.00, 500000.00),
  ('tb0ba7fd9c03c', 'kas_keluar', '2026-10-20', 'CO-2610-1066', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'sewa breaker, sewa beko', 0.00, 8200000.00),
  ('t006d4cc1f8ca', 'kas_keluar', '2026-10-20', 'CO-2610-1067', 'Kas Besar', 'Biaya Upah', 'BJB Riau', '', 'BJB riau progress 30%', 0.00, 130223280.00),
  ('t9f0db5a9f37a', 'kas_keluar', '2026-10-20', 'CO-2610-1068', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Bogor', '', 'listrik SLO', 0.00, 10668000.00),
  ('te4efe62a9be3', 'kas_keluar', '2026-10-20', 'CO-2610-1069', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'gegep, senter, stempel, dll', 0.00, 1241000.00),
  ('t8bf9f44053c6', 'kas_keluar', '2026-10-20', 'CO-2610-1070', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'contoh kloser, urinior, wastafel', 0.00, 2957000.00),
  ('t41b06c02201b', 'kas_keluar', '2026-10-20', 'CO-2610-1071', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'PUPR Bangun Satpol PP Sumedang', '', 'OP komeng ke sumedang (19/10)', 0.00, 345000.00),
  ('t96cd7020291b', 'kas_keluar', '2026-10-20', 'CO-2610-1072', 'Kas Besar', 'Hutang Bank Jk.Pendek PT', 'Cost Center - Pendanaan Uang', 'HB-BJB', 'pembayaran kelayakan dari termen 2 satpol pp', 0.00, 1000000000.00);

-- 1 penyesuaian pada transaksi yang sudah ada
UPDATE `transactions` SET `akun_lawan` = 'Biaya Bahan' WHERE `ref` = 'CO-2610-0699';
