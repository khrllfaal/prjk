-- Melengkapi sinkronisasi 21 Oktober 2026 -- bagian cash_out (Kas Keluar)
-- yang belum sempat diupload pada putaran sebelumnya (lihat
-- sync_transactions_okt21_2026_partial.sql untuk 3 transaksi Bank/Kas
-- Masuk hari itu). cash_out bertambah 5754 -> 5820 baris di export,
-- semuanya transaksi baru murni: 66 baru, 0 hilang, 0 penyesuaian.
--
-- Semua 66 transaksi ini masuk ke akun Biaya (bukan Hutang Dagang,
-- Piutang, atau Prive), sesuai dengan Data Hutang/Piutang/Prive 21
-- Oktober yang totalnya TIDAK berubah dari 20 Oktober (Hutang tetap
-- 10.385.092.614, Piutang tetap 1.256.853.948, Prive tetap
-- 1.212.315.493) -- jadi tidak ada relasi yang perlu ditambahkan hari
-- ini.
--
-- 1 Master Project baru ditemukan: "Brigif kujang" (CO-2610-1132, H
-- Dana, Biaya Upah, Rp10.000.000) -- berbeda dari project yang sudah
-- ada "Zidam Brigif 15 Zipur".
INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_brigif_kujang', 'Brigif kujang', 'Brigif kujang', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW());

-- 66 transaksi kas_keluar baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('tdb373889d439', 'kas_keluar', '2026-10-21', 'CO-2610-1073', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Farm Cibeureum periode 5', '', 'jatah panen cbr (pak atep)', 0.00, 5000000.00),
  ('tb05f4d11d8cf', 'kas_keluar', '2026-10-21', 'CO-2610-1074', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Farm Cilame 2 periode 5', '', 'jatah panen clm2 (pak yayang)', 0.00, 2500000.00),
  ('t56340bb0330b', 'kas_keluar', '2026-10-21', 'CO-2610-1075', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'DP ke-1 sekam cibeureum', 0.00, 3750000.00),
  ('t2e59c2b32c72', 'kas_keluar', '2026-10-21', 'CO-2610-1076', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cilame 1 periode 5', '', 'DP ke-2 sekam cilame 1', 0.00, 5000000.00),
  ('tf5c82639d8f3', 'kas_keluar', '2026-10-21', 'CO-2610-1077', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 2 periode 6', '', 'matrial listrik cilame 2', 0.00, 3330000.00),
  ('t3d46f362ff3a', 'kas_keluar', '2026-10-21', 'CO-2610-1078', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'cuci mobil inova', 0.00, 50000.00),
  ('tbe0c8bde0c0b', 'kas_keluar', '2026-10-21', 'CO-2610-1079', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'spooring inova putih', 0.00, 270000.00),
  ('t3dca7a5ae5c2', 'kas_keluar', '2026-10-21', 'CO-2610-1080', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'Bensin', 0.00, 10000.00),
  ('tf754274d5820', 'kas_keluar', '2026-10-21', 'CO-2610-1081', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'Bensin 21/10', 0.00, 30000.00),
  ('tc32269112892', 'kas_keluar', '2026-10-21', 'CO-2610-1082', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kwetiau, nasi, capcai, sate direksi', 0.00, 277000.00),
  ('tda8860828665', 'kas_keluar', '2026-10-21', 'CO-2610-1083', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'tape', 0.00, 30000.00),
  ('tdba423172cf0', 'kas_keluar', '2026-10-21', 'CO-2610-1084', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'makan lembur, bajigur, roti', 0.00, 89000.00),
  ('tc833247197b8', 'kas_keluar', '2026-10-21', 'CO-2610-1085', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'jilid mika, jilid ring', 0.00, 55000.00),
  ('t7f7b9dac27c4', 'kas_keluar', '2026-10-21', 'CO-2610-1086', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'Fotokopi, jilid', 0.00, 7300.00),
  ('tf09e84e773a1', 'kas_keluar', '2026-10-21', 'CO-2610-1087', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'jilid ring, jilid, ganti lakban', 0.00, 67000.00),
  ('tbdc0fce9946a', 'kas_keluar', '2026-10-21', 'CO-2610-1088', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'Bikin cap', 0.00, 60000.00),
  ('td7bd265cbdc8', 'kas_keluar', '2026-10-21', 'CO-2610-1089', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'kasbon pak asun', 0.00, 2500000.00),
  ('ta2a123bc06de', 'kas_keluar', '2026-10-21', 'CO-2610-1090', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'Matrial listrik', 0.00, 157000.00),
  ('t5209ebfdd37a', 'kas_keluar', '2026-10-21', 'CO-2610-1091', 'Kas Besar', 'Biaya ADM', 'Zidam Rehab Gudkesrah', '', 'Adm pencairan pelunasan', 0.00, 9800000.00),
  ('tcf2159d146ce', 'kas_keluar', '2026-10-21', 'CO-2610-1092', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'Keramik 30x30 54 dus', 0.00, 3240000.00),
  ('tfd819c3e4690', 'kas_keluar', '2026-10-21', 'CO-2610-1093', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Zidam Rehab Gudkesrah', '', 'Op gupron', 0.00, 354000.00),
  ('t5432edf93cdf', 'kas_keluar', '2026-10-21', 'CO-2610-1094', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'reimburse ilham (tiner)', 0.00, 56000.00),
  ('t2065a2207e48', 'kas_keluar', '2026-10-21', 'CO-2610-1095', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'Belanja tgl 21', 0.00, 5000000.00),
  ('t78266c44371e', 'kas_keluar', '2026-10-21', 'CO-2610-1096', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'Semen 1 do', 0.00, 7080000.00),
  ('tdfdac42e4d58', 'kas_keluar', '2026-10-21', 'CO-2610-1097', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (lalamove)', 0.00, 78000.00),
  ('t7f39c26efc67', 'kas_keluar', '2026-10-21', 'CO-2610-1098', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (bensin, tiket arya, berobat arya)', 0.00, 603000.00),
  ('ta77b36a837ad', 'kas_keluar', '2026-10-21', 'CO-2610-1099', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'matrial listrik (kasbon pak nanang)', 0.00, 400000.00),
  ('te9df351e9b24', 'kas_keluar', '2026-10-21', 'CO-2610-1100', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang barangkal', 0.00, 4050000.00),
  ('t619950ee547b', 'kas_keluar', '2026-10-21', 'CO-2610-1101', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'Double nepel', 0.00, 50000.00),
  ('t7dd2f9047dca', 'kas_keluar', '2026-10-21', 'CO-2610-1102', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'pipa, mata gergaji, sdl, keni dll', 0.00, 3756500.00),
  ('t24bbb3466d1d', 'kas_keluar', '2026-10-21', 'CO-2610-1103', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'Cat', 0.00, 869000.00),
  ('t7b9fb72d7c78', 'kas_keluar', '2026-10-21', 'CO-2610-1104', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'plat antapani', 0.00, 365900.00),
  ('t1bafdb6a0cf1', 'kas_keluar', '2026-10-21', 'CO-2610-1105', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'Angkur, mur', 0.00, 405000.00),
  ('t7683cb9b2a97', 'kas_keluar', '2026-10-21', 'CO-2610-1106', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'kas arya (silent aquaproof, pisau granit, cat, thiner, ongkir dll)', 0.00, 373000.00),
  ('t3ba24ad58f9d', 'kas_keluar', '2026-10-21', 'CO-2610-1107', 'Kas Besar', 'Biaya entertain', 'Proyek Antapani', '', 'kas arya (rokok ajudan)', 0.00, 360000.00),
  ('t70b928250214', 'kas_keluar', '2026-10-21', 'CO-2610-1108', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'Pipa pipa', 0.00, 5370000.00),
  ('t2f6c1f3bcf5b', 'kas_keluar', '2026-10-21', 'CO-2610-1109', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'uang galon', 0.00, 497000.00),
  ('t8201b0a433eb', 'kas_keluar', '2026-10-21', 'CO-2610-1110', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'ritase & uang lintas TM dll', 0.00, 2300000.00),
  ('t0bb7860b3ba6', 'kas_keluar', '2026-10-21', 'CO-2610-1111', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kas arya (lalamove granit)', 0.00, 450000.00),
  ('t576e82e58780', 'kas_keluar', '2026-10-21', 'CO-2610-1112', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'matrial listrik', 0.00, 15338000.00),
  ('t8b69153f83e9', 'kas_keluar', '2026-10-21', 'CO-2610-1113', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'perekat hebel, paku beton, koas 4"', 0.00, 515000.00),
  ('t71a04d3a8f3c', 'kas_keluar', '2026-10-21', 'CO-2610-1114', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pvc, dop, keni, asahi', 0.00, 1916000.00),
  ('t648310e8bbdb', 'kas_keluar', '2026-10-21', 'CO-2610-1115', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'matrial listrik', 0.00, 25404000.00),
  ('t2d229abba253', 'kas_keluar', '2026-10-21', 'CO-2610-1116', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim sipil', 0.00, 6000000.00),
  ('te509cb6df193', 'kas_keluar', '2026-10-21', 'CO-2610-1117', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pipa 3 inch, 3/4, 1/2', 0.00, 1389000.00),
  ('teab851e40a1f', 'kas_keluar', '2026-10-21', 'CO-2610-1118', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pipa, tee, roll cat,', 0.00, 1202400.00),
  ('t10c7c832a3fe', 'kas_keluar', '2026-10-21', 'CO-2610-1119', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kas arya (lalamove stemper)', 0.00, 110000.00),
  ('t880dedd645f5', 'kas_keluar', '2026-10-21', 'CO-2610-1120', 'Kas Besar', 'Biaya ADM', 'Kemhan Bangun Rumdis Cimahi', '', 'kas arya (print fotokopian)', 0.00, 17500.00),
  ('t8eddb2187ce2', 'kas_keluar', '2026-10-21', 'CO-2610-1121', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'mobil tm, teknisi', 0.00, 500000.00),
  ('t3067350d4374', 'kas_keluar', '2026-10-21', 'CO-2610-1122', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar', 0.00, 756000.00),
  ('t763ad401f73d', 'kas_keluar', '2026-10-21', 'CO-2610-1123', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'um operator', 0.00, 250000.00),
  ('t2497ffd7a586', 'kas_keluar', '2026-10-21', 'CO-2610-1124', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'Kas', 0.00, 200000.00),
  ('tcfe8724ab903', 'kas_keluar', '2026-10-21', 'CO-2610-1125', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'mob demob, sewa hem all-in', 0.00, 2900000.00),
  ('t87a8af13e23e', 'kas_keluar', '2026-10-21', 'CO-2610-1126', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'bahan adi mekar', 0.00, 3025000.00),
  ('t02168b2276b2', 'kas_keluar', '2026-10-21', 'CO-2610-1127', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'cat sanlex, pintu, kawat dll', 0.00, 5704000.00),
  ('t7673bbbe5dc8', 'kas_keluar', '2026-10-21', 'CO-2610-1128', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (bongkar semen, lalamove bahan)', 0.00, 119000.00),
  ('tcbe9688bbf63', 'kas_keluar', '2026-10-21', 'CO-2610-1129', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (bensin, berobat pekerja)', 0.00, 82000.00),
  ('t55648748d847', 'kas_keluar', '2026-10-21', 'CO-2610-1130', 'Kas Besar', 'Biaya Upah2', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (galon)', 0.00, 118000.00),
  ('tac278d824fcf', 'kas_keluar', '2026-10-21', 'CO-2610-1131', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'papan gypsum, holo, grs, dll', 0.00, 4971500.00),
  ('tf02956353105', 'kas_keluar', '2026-10-21', 'CO-2610-1132', 'Kas Besar', 'Biaya Upah', 'Brigif kujang', '', 'H Dana', 0.00, 10000000.00),
  ('t08e8d194a58f', 'kas_keluar', '2026-10-21', 'CO-2610-1133', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'air damkar', 0.00, 250000.00),
  ('t8e9818a8ac1d', 'kas_keluar', '2026-10-21', 'CO-2610-1134', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'grab bar, tissue holder', 0.00, 1339825.00),
  ('t17c22cc5a3d6', 'kas_keluar', '2026-10-21', 'CO-2610-1135', 'Kas Besar', 'Biaya ADM', 'PUPR Bangun Satpol PP Sumedang', '', 'Adm (R)', 0.00, 50000000.00),
  ('t40fe9d2ba108', 'kas_keluar', '2026-10-21', 'CO-2610-1136', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'bak cuci, kran, kloset duduk, floordrain, dll', 0.00, 20161600.00),
  ('t817edf2cbd7f', 'kas_keluar', '2026-10-21', 'CO-2610-1137', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'bahan sanitary', 0.00, 34185000.00),
  ('t77a959a22645', 'kas_keluar', '2026-10-21', 'CO-2610-1138', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'bahan matrial alam', 0.00, 24300000.00);
