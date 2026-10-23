-- Sinkronisasi 23 Oktober 2026.
--
-- 1) 5 penyesuaian pada transaksi lama (ditemukan dari Report terbaru,
-- ref/tanggal sama, akun/project/nominal berubah):
--  - CO-2608-0863 "pendamping" Rp3jt ternyata dipecah 2 project: separuh
--    (Rp1.5jt) di Zidam Rehab Rumdis Cimahi (bukan Zidam Brigif 15
--    Zipur), separuhnya lagi jadi transaksi baru CO-2610-1261 di ZIDAM
--    Bangun Rumdis Pangandaran -- totalnya tetap Rp3jt.
--  - CO-2609-0938 & CO-2609-1346 "ajuan asep yudi/asep-yudi": nominal
--    dikoreksi dari Rp15.450.000 jadi Rp15.000.000 per voucher (selisih
--    Rp450rb masing-masing jadi transaksi baru CO-2610-1197/1198
--    "dari ajuan asep/yudi").
--  - CO-2610-0323 "uang makan operator": akun lawan Biaya Upah ->
--    Biaya Upah2.
--  - CO-2610-1138 "bahan matrial alam" Rp24.300.000 ternyata dipecah:
--    Rp9.300.000 tetap di sini (ket diperbarui "pasir pasang 3 rit
--    (nota 24,3jt)"), sisanya Rp15.000.000 jadi transaksi baru
--    CO-2610-1196 "4 truk beskos..(nota 24,3jt)" -- totalnya tetap
--    Rp24.300.000.
UPDATE `transactions` SET `project` = 'Zidam Rehab Rumdis Cimahi', `kredit` = 1500000.00, `ket` = 'pendamping (3jt)' WHERE `ref` = 'CO-2608-0863';
UPDATE `transactions` SET `kredit` = 15000000.00 WHERE `ref` = 'CO-2609-0938';
UPDATE `transactions` SET `kredit` = 15000000.00 WHERE `ref` = 'CO-2609-1346';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-0323';
UPDATE `transactions` SET `kredit` = 9300000.00, `ket` = 'pasir pasang 3 rit (nota 24,3jt)' WHERE `ref` = 'CO-2610-1138';

-- 2) 1 Master Project baru: "BJB Prioritas Jakarta" (CO-2610-1285,
-- "putra", Biaya Upah, Rp3.000.000).
INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_bjb_prioritas_jakarta', 'BJB Prioritas Jakarta', 'BJB Prioritas Jakarta', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW());

-- 3) 108 transaksi baru. Tidak ada jurnal_umum baru hari ini (tetap
-- 122 baris). 5 relasi diberi dari pencocokan delta persis:
--  - HPK-TAF turun Rp18.831.882 = CO-2610-1296 "cicilan leasing taf"
--    (bunga Rp25.917.055-nya ke Biaya Bunga & Administrasi Bank, bukan
--    Hutang, jadi tidak diberi relasi).
--  - Pr-R naik Rp295.000 = CO-2610-1207 "pa rajab (rs vira)".
--  - Pr-Z naik Rp50.000 = CO-2610-1209 "alby cash (pak zamzam)".
--  - Pr-K naik Rp205.500 = CO-2610-1208 (Rp130.000) + CO-2610-1210
--    (Rp75.500), keduanya "(pak ei)".
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t68803d58a0ab', 'bank_masuk', '2026-10-23', 'BI-2610-0013', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'Zidam Rumdis Zipur', '', 'uang masuk zipur', 138784808.00, 0.00),
  ('t4f7b20b768a2', 'bank_keluar', '2026-10-23', 'BO-2610-0026', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 23 oktober', 0.00, 1414029153.00),
  ('t8ea4d7de79b8', 'kas_masuk', '2026-10-23', 'CI-2610-0028', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 23 oktober', 1414029153.00, 0.00),
  ('taa8913081c08', 'kas_keluar', '2026-10-21', 'CO-2610-1196', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', '4 truk beskos 8.400, 2 truk pasir cor 6.00 (nota 24,3jt)', 0.00, 15000000.00),
  ('t650bf205b8f7', 'kas_keluar', '2026-09-25', 'CO-2610-1197', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'dari ajuan asep/yudi', 0.00, 450000.00),
  ('t6985929c0314', 'kas_keluar', '2026-09-18', 'CO-2610-1198', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'dari ajuan asep/yudi', 0.00, 450000.00),
  ('t15c073d8d924', 'kas_keluar', '2026-10-23', 'CO-2610-1199', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'internet kantor', 0.00, 638250.00),
  ('t578de66ba856', 'kas_keluar', '2026-10-23', 'CO-2610-1200', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'materai', 0.00, 500000.00),
  ('t84ac148ee980', 'kas_keluar', '2026-10-23', 'CO-2610-1201', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'spring roll, kopi, dll', 0.00, 81000.00),
  ('t439b44bf86c0', 'kas_keluar', '2026-10-23', 'CO-2610-1202', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nasi pecel', 0.00, 41000.00),
  ('tde904b9ed4b0', 'kas_keluar', '2026-10-23', 'CO-2610-1203', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'tinta printer', 0.00, 745000.00),
  ('tbe57eb00b9c8', 'kas_keluar', '2026-10-23', 'CO-2610-1204', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'mangga', 0.00, 578000.00),
  ('tc4c48ef751e5', 'kas_keluar', '2026-10-23', 'CO-2610-1205', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'bayaran komeng 16 - 22 okt', 0.00, 1205000.00),
  ('td93e08dbc071', 'kas_keluar', '2026-10-23', 'CO-2610-1206', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'kasbon komeng (di potong tiap bulan)', 0.00, 5000000.00),
  ('t247ca88dc442', 'kas_keluar', '2026-10-23', 'CO-2610-1207', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'pa rajab (rs vira)', 0.00, 295000.00),
  ('t22e44ead86ec', 'kas_keluar', '2026-10-23', 'CO-2610-1208', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'lifree sukaregang (pak ei)', 0.00, 130000.00),
  ('t0545235de829', 'kas_keluar', '2026-10-23', 'CO-2610-1209', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'alby cash (pak zamzam)', 0.00, 50000.00),
  ('td981965cf4d7', 'kas_keluar', '2026-10-23', 'CO-2610-1210', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'gojek pa ei tgl 1 - 23 okt', 0.00, 75500.00),
  ('t6dc834e1d175', 'kas_keluar', '2026-10-23', 'CO-2610-1211', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'kasbon pak bowo (restu ibu)', 0.00, 5002500.00),
  ('t0572026713e4', 'kas_keluar', '2026-10-23', 'CO-2610-1212', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan', '', 'OP pa fahri bogor - kemahn 22/10', 0.00, 2027070.00),
  ('t222e677e1b04', 'kas_keluar', '2026-10-23', 'CO-2610-1213', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan', '', 'op komeng anter pak asun ke bogor 22/10', 0.00, 600000.00),
  ('t751da27b532b', 'kas_keluar', '2026-10-23', 'CO-2610-1214', 'Kas Besar', 'Biaya Bahan', 'Cibatu', '', 'pelunasan kandang ayam', 0.00, 32337600.00),
  ('t41a79d6c5a08', 'kas_keluar', '2026-10-23', 'CO-2610-1215', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'pasir pasang 1 rit', 0.00, 1500000.00),
  ('t080788afa1de', 'kas_keluar', '2026-10-23', 'CO-2610-1216', 'Kas Besar', 'Biaya Upah', 'RS Guntur Gudang Farmasi', '', 'upah tim h dana', 0.00, 27500000.00),
  ('t1e9d2f730ec7', 'kas_keluar', '2026-10-23', 'CO-2610-1217', 'Kas Besar', 'Biaya Upah', 'KNMP Donggala', '', 'donggala', 0.00, 500000000.00),
  ('t81b0fc70ced2', 'kas_keluar', '2026-10-23', 'CO-2610-1218', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'handle pintu', 0.00, 1911958.00),
  ('t2fa1f73239f1', 'kas_keluar', '2026-10-23', 'CO-2610-1219', 'Kas Besar', 'Biaya ADM', 'Zidam Rehab Gudkesrah', '', 'lapjusik', 0.00, 2500000.00),
  ('t912dfa86ceae', 'kas_keluar', '2026-10-23', 'CO-2610-1220', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Gudkesrah', '', 'h dana', 0.00, 6500000.00),
  ('t005cca7277a2', 'kas_keluar', '2026-10-23', 'CO-2610-1221', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Zidam Rehab Gudkesrah', '', 'Op. pak fahri gudkesrah - brigif (21/10)', 0.00, 314351.00),
  ('t957a843c48ef', 'kas_keluar', '2026-10-23', 'CO-2610-1222', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 23', 0.00, 9000000.00),
  ('ta646d25a88c9', 'kas_keluar', '2026-10-23', 'CO-2610-1223', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'aki panter', 0.00, 1350000.00),
  ('t60a7a76f868b', 'kas_keluar', '2026-10-23', 'CO-2610-1224', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'demob buzer', 0.00, 2500000.00),
  ('t2b3d2d078f66', 'kas_keluar', '2026-10-23', 'CO-2610-1225', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim jaga alat', 0.00, 1400000.00),
  ('t4100d7a3b3c3', 'kas_keluar', '2026-10-23', 'CO-2610-1226', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran pekerja tim garut 16-22 okt', 0.00, 12159500.00),
  ('t3b1938a33102', 'kas_keluar', '2026-10-23', 'CO-2610-1227', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran pekerja tim cihelang 16-22 okt', 0.00, 8045000.00),
  ('t4efdb13e35fb', 'kas_keluar', '2026-10-23', 'CO-2610-1228', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (adm brilink, listrik kontrakan, tambal ban, ban dalam)', 0.00, 480000.00),
  ('tf761dfd5acef', 'kas_keluar', '2026-10-23', 'CO-2610-1229', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (galon pekerja, mamin ngawal beko, lembur harian)', 0.00, 940000.00),
  ('t5b7ed5d8ebef', 'kas_keluar', '2026-10-23', 'CO-2610-1230', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (bensin pompa air, paku)', 0.00, 336000.00),
  ('tf6cbb59c4e65', 'kas_keluar', '2026-10-23', 'CO-2610-1231', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kontrakan', 0.00, 1500000.00),
  ('ta0b44aa750e0', 'kas_keluar', '2026-10-23', 'CO-2610-1232', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'pasir cor 18-21 okt', 0.00, 38665600.00),
  ('t68667d415e0a', 'kas_keluar', '2026-10-23', 'CO-2610-1233', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'operator beko', 0.00, 2130000.00),
  ('t4fc29cfdd8f1', 'kas_keluar', '2026-10-23', 'CO-2610-1234', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'operator mixer', 0.00, 1990000.00),
  ('t7693c05cf171', 'kas_keluar', '2026-10-23', 'CO-2610-1235', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'babinsa, danpos tuud 7 hari x 400 rb', 0.00, 2800000.00),
  ('t986f738bb5f1', 'kas_keluar', '2026-10-23', 'CO-2610-1236', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'tambahan babinsa 2, danpos (300x7)', 0.00, 2100000.00),
  ('t2355ecc71465', 'kas_keluar', '2026-10-23', 'CO-2610-1237', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'toren air, pelampung, mesin pendorong shimizu', 0.00, 5587000.00),
  ('t74d8d3f6576d', 'kas_keluar', '2026-10-23', 'CO-2610-1238', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'inkalum', 0.00, 7610400.00),
  ('tc4b529ab08d9', 'kas_keluar', '2026-10-23', 'CO-2610-1239', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'bayaran pekerja 16-22 okt', 0.00, 17383000.00),
  ('tda9e26250448', 'kas_keluar', '2026-10-23', 'CO-2610-1240', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname granit lantai wc', 0.00, 182280.00),
  ('t89ed8c96f371', 'kas_keluar', '2026-10-23', 'CO-2610-1241', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname granit lantai', 0.00, 213400.00),
  ('ta4d7d9d1024b', 'kas_keluar', '2026-10-23', 'CO-2610-1242', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname granit dinding selasar', 0.00, 333360.00),
  ('t660256e6b52b', 'kas_keluar', '2026-10-23', 'CO-2610-1243', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname pasangan kloset duduk', 0.00, 300000.00),
  ('ta8c09c2f015f', 'kas_keluar', '2026-10-23', 'CO-2610-1244', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname pasangan keran', 0.00, 15000.00),
  ('taa51cf196cbd', 'kas_keluar', '2026-10-23', 'CO-2610-1245', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname pasangan floordrain', 0.00, 170000.00),
  ('tdc3b085ed87f', 'kas_keluar', '2026-10-23', 'CO-2610-1246', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname pasangan grab bar stainless wc', 0.00, 255000.00),
  ('t1e17755f092d', 'kas_keluar', '2026-10-23', 'CO-2610-1247', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'bahan hpl pintu', 0.00, 11645000.00),
  ('t8f4b86cd19e6', 'kas_keluar', '2026-10-23', 'CO-2610-1248', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'keni, pvc, lem tangting, dop, dll', 0.00, 2612500.00),
  ('t306bab696717', 'kas_keluar', '2026-10-23', 'CO-2610-1249', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'pelunasan plin kenanga', 0.00, 48818000.00),
  ('t548cd27769d0', 'kas_keluar', '2026-10-23', 'CO-2610-1250', 'Kas Besar', 'Biaya Upah2', 'Proyek Antapani', '', 'kasbon tim baja (pak dadang)', 0.00, 3000000.00),
  ('tbef4ee1fd0a4', 'kas_keluar', '2026-10-23', 'CO-2610-1251', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'pelunasan panel lantai antapani 22/10', 0.00, 5531600.00),
  ('t1a22ec60f6cd', 'kas_keluar', '2026-10-23', 'CO-2610-1252', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'bahan manhole kolam', 0.00, 774000.00),
  ('tb61b5c2c488a', 'kas_keluar', '2026-10-23', 'CO-2610-1253', 'Kas Besar', 'Biaya Upah', 'Brigif kujang', '', 'H dana', 0.00, 7500000.00),
  ('td2f871da919c', 'kas_keluar', '2026-10-23', 'CO-2610-1254', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'semen', 0.00, 4500000.00),
  ('tbb209694f822', 'kas_keluar', '2026-10-23', 'CO-2610-1255', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'kasbon tim listrik', 0.00, 2000000.00),
  ('t1411576b8109', 'kas_keluar', '2026-10-23', 'CO-2610-1256', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', 'upah kopel 1-5', 0.00, 51298375.00),
  ('tc1d812405d77', 'kas_keluar', '2026-10-23', 'CO-2610-1257', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'semen 20 sak', 0.00, 960000.00),
  ('te08735cbcdf9', 'kas_keluar', '2026-10-23', 'CO-2610-1258', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'inkalum, engsel cesment', 0.00, 27085200.00),
  ('tf4759df94d62', 'kas_keluar', '2026-10-23', 'CO-2610-1259', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'inkalum panel', 0.00, 6977200.00),
  ('tfad0d9ef83ba', 'kas_keluar', '2026-10-23', 'CO-2610-1260', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pasir pasang 2 truk, pasir cor 1 truk', 0.00, 6250000.00),
  ('t8858c196ea20', 'kas_keluar', '2026-08-26', 'CO-2610-1261', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'pendamping (3jt)', 0.00, 1500000.00),
  ('t7f9c6070f671', 'kas_keluar', '2026-10-23', 'CO-2610-1262', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'hamplasm', 0.00, 210000.00),
  ('ta8b66cae98aa', 'kas_keluar', '2026-10-23', 'CO-2610-1263', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pipa pipa', 0.00, 7744000.00),
  ('t687c4290852e', 'kas_keluar', '2026-10-23', 'CO-2610-1264', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', 'ongkos pekerja baru', 0.00, 1200000.00),
  ('tea8979803fcc', 'kas_keluar', '2026-10-23', 'CO-2610-1265', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim plafond (asep) 22/10', 0.00, 3500000.00),
  ('tdbcc61e86c1c', 'kas_keluar', '2026-10-23', 'CO-2610-1266', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'lampu', 0.00, 1399920.00),
  ('t056eae3d593f', 'kas_keluar', '2026-10-23', 'CO-2610-1267', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan Bangun Rumdis Cimahi', '', 'op pak fahri ke gudkesrah dan brigif 21/10', 0.00, 314352.00),
  ('tfe9042bd2425', 'kas_keluar', '2026-10-23', 'CO-2610-1268', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kas pengecoran cimahi 22/10', 0.00, 750000.00),
  ('t4b48ee7cd4d6', 'kas_keluar', '2026-10-23', 'CO-2610-1269', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kasbon tim jalan pak yudi cimahi 22/10', 0.00, 2500000.00),
  ('t9c15323adaf9', 'kas_keluar', '2026-10-23', 'CO-2610-1270', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'uang lintas truk mixer subang', 0.00, 2400000.00),
  ('te193b7de011f', 'kas_keluar', '2026-10-23', 'CO-2610-1271', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kas pengecoran sesi 1 cimahi 23/10', 0.00, 750000.00),
  ('t68371a320b35', 'kas_keluar', '2026-10-23', 'CO-2610-1272', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'kasbon jalan subang', 0.00, 15000000.00),
  ('t9f86bc0d69c7', 'kas_keluar', '2026-10-23', 'CO-2610-1273', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'plastik cor', 0.00, 15000000.00),
  ('t1a9b4d55ce99', 'kas_keluar', '2026-10-23', 'CO-2610-1274', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'crane', 0.00, 10000000.00),
  ('tc3286168de16', 'kas_keluar', '2026-10-23', 'CO-2610-1275', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'perpanjangan bomag', 0.00, 1202500.00),
  ('ta362b7d2c7cc', 'kas_keluar', '2026-10-23', 'CO-2610-1276', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar, UM operator', 0.00, 1258000.00),
  ('t657d452f4a28', 'kas_keluar', '2026-10-23', 'CO-2610-1277', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'tebang pohon', 0.00, 4000000.00),
  ('tfea9e4af705e', 'kas_keluar', '2026-10-23', 'CO-2610-1278', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'tambahan solar', 0.00, 250000.00),
  ('tffeabcc3f80d', 'kas_keluar', '2026-10-23', 'CO-2610-1279', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'flagman', 0.00, 5600000.00),
  ('t7bf293c6306e', 'kas_keluar', '2026-10-23', 'CO-2610-1280', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan babinsa dll', 0.00, 1500000.00),
  ('t402d8b803cce', 'kas_keluar', '2026-10-23', 'CO-2610-1281', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan zipur', 0.00, 1500000.00),
  ('te95730bdc6c3', 'kas_keluar', '2026-10-23', 'CO-2610-1282', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'bahan alam', 0.00, 56120000.00),
  ('t26f2ef7c1951', 'kas_keluar', '2026-10-23', 'CO-2610-1283', 'Kas Besar', 'Biaya Upah', 'Bina Marga Rehab Jembatan Provinsi', '', 'upah asep yudi', 0.00, 15000000.00),
  ('tece953e485c3', 'kas_keluar', '2026-10-23', 'CO-2610-1284', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'jaga malam & alat', 0.00, 850000.00),
  ('t9a2ab0718973', 'kas_keluar', '2026-10-23', 'CO-2610-1285', 'Kas Besar', 'Biaya Upah', 'BJB Prioritas Jakarta', '', 'putra', 0.00, 3000000.00),
  ('t8c2cedd2867b', 'kas_keluar', '2026-10-23', 'CO-2610-1286', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'bayaran pekerja periode 17 - 22 oktober', 0.00, 16255000.00),
  ('te60cd9dea2b2', 'kas_keluar', '2026-10-23', 'CO-2610-1287', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pasir pasang 2 rit', 0.00, 4800000.00),
  ('tebecceba314c', 'kas_keluar', '2026-10-23', 'CO-2610-1288', 'Kas Besar', 'Biaya Upah2', 'Kemhan 2 Gudang Selatan', '', 'kasbon tim ato', 0.00, 5000000.00),
  ('tdb3a99c7d3c6', 'kas_keluar', '2026-10-23', 'CO-2610-1289', 'Kas Besar', 'Biaya ADM', 'Zidam Rumdis Zipur', '', 'ADM 5', 0.00, 113150000.00),
  ('t537b17e626f8', 'kas_keluar', '2026-10-23', 'CO-2610-1290', 'Kas Besar', 'Biaya Upah2', 'ZIDAM Bangun Rumdis Pangandaran', '', 'pengawas 5 minggu', 0.00, 1750000.00),
  ('t0f493112c634', 'kas_keluar', '2026-10-23', 'CO-2610-1291', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'sewa scafolding', 0.00, 8134800.00),
  ('t5c8d2e4d6656', 'kas_keluar', '2026-10-23', 'CO-2610-1292', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'granit', 0.00, 35400000.00),
  ('ta5a8019b1464', 'kas_keluar', '2026-10-23', 'CO-2610-1293', 'Kas Besar', 'Biaya Upah', 'PUPR Bangun Satpol PP Sumedang', '', 'upah tim h dana', 0.00, 80000000.00),
  ('t3d650df9094c', 'kas_keluar', '2026-10-23', 'CO-2610-1294', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'bayaran pekerja', 0.00, 43318000.00),
  ('t81918ac58139', 'kas_keluar', '2026-10-23', 'CO-2610-1295', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon pak egi', 0.00, 20000000.00),
  ('t1f86eb482829', 'kas_keluar', '2026-10-23', 'CO-2610-1296', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', 'HPK-TAF', 'cicilan leasing taf (sudah 36jt)', 0.00, 18831882.00),
  ('tf1e14da00268', 'kas_keluar', '2026-10-23', 'CO-2610-1297', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center - Pendanaan Uang', '', 'bunga cicilan leasing taf', 0.00, 25917055.00),
  ('tbbbf84272cfa', 'kas_keluar', '2026-10-23', 'CO-2610-1298', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cibeureum periode 6', '', 'lampu 200 pcs (2.812.000)', 0.00, 803429.00),
  ('t0eb53c5f1cc0', 'kas_keluar', '2026-10-23', 'CO-2610-1299', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'lampu 200 pcs (2.812.000)', 0.00, 1205142.00),
  ('t09b76519d600', 'kas_keluar', '2026-10-23', 'CO-2610-1300', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 2 periode 6', '', 'lampu 200 pcs (2.812.000)', 0.00, 803429.00);
