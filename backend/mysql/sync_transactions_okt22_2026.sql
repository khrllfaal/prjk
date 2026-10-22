-- Sinkronisasi 22 Oktober 2026.
--
-- 1) 3 voucher jurnal baru (jurnal_umum bertambah 119 -> 122 baris),
-- semuanya V-HU-Nippon, "cat nippon (29/9)", detail dikonfirmasi dari
-- Detail Jurnal sistem asli (masing-masing 1 baris Biaya Bahan + 1
-- baris Hutang Dagang, Debit=Kredit per voucher).
INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('ja9b040fd3b11', '2026-10-22', 'JU26100134', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', 'Bahan', '', 'posted', 'cat nippon (29/9)', 10808780.00, 0.00),
  ('jaec69a8fb19e', '2026-10-22', 'JU26100134', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', '', '', 'posted', 'cat nippon (29/9)', 0.00, 10808780.00),
  ('j07f621218408', '2026-10-22', 'JU26100135', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', 'V-HU-Nippon', 'Bahan', '', 'posted', 'cat nippon (29/9)', 3260000.00, 0.00),
  ('jf0fdc05a833a', '2026-10-22', 'JU26100135', 'Hutang Dagang', 'Zidam Rehab Gudkesrah', 'V-HU-Nippon', '', '', 'posted', 'cat nippon (29/9)', 0.00, 3260000.00),
  ('je371a073a673', '2026-10-22', 'JU26100136', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', 'V-HU-Nippon', 'Bahan', '', 'posted', 'cat nippon (29/9)', 6031740.00, 0.00),
  ('j04a74dd547f4', '2026-10-22', 'JU26100136', 'Hutang Dagang', 'Zidam Rehab Gudkesrah', 'V-HU-Nippon', '', '', 'posted', 'cat nippon (29/9)', 0.00, 6031740.00);

-- 2) 5 reklasifikasi lama (RS Dustira Bangun Ruang Kenanga, kasbon
-- "putra"): Biaya Upah2 -> Biaya Upah3, ditemukan dari Report terbaru
-- (ref, tanggal, keterangan dan nominal sama persis, cuma akun lawan
-- berubah).
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` IN
  ('CO-2609-0408', 'CO-2609-0811', 'CO-2609-1240', 'CO-2610-0192', 'CO-2610-0461') AND `akun_lawan` = 'Biaya Upah2';

-- 3) 59 transaksi baru. 6 Prive diberi relasi langsung dari pencocokan
-- delta per-owner persis (Pr-K naik 3.031.000 = 110.000+2.302.000+
-- 519.000+100.000 "(pak ei)"; Pr-Z naik 50.000 = "albey"; Pr-R naik
-- 300.000 = "bensin mobil abi (pak rajab)"). 6 pembayaran Hutang Dagang
-- diberi relasi vendor dari ketepatan delta per-vendor (V-HU-Berkat
-- turun 112.534.000 = 39.096.000+10.545.000+52.969.200+9.923.800;
-- V-HU-Nippon naik netto 4.815.820 = +20.100.520 jurnal - 15.284.700
-- pembayaran).
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('taff5cd9dccc0', 'bank_masuk', '2026-10-22', 'BI-2610-0012', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'Zidam Rehab Gudkesrah', '', 'uang masuk gudkesrah', 343277091.00, 0.00),
  ('t26579bc12e5c', 'bank_keluar', '2026-10-22', 'BO-2610-0025', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 22 oktober', 0.00, 649270352.00),
  ('t6ea7ed532e2e', 'kas_masuk', '2026-10-22', 'CI-2610-0027', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 22 oktober', 649270352.00, 0.00),
  ('t942c8f39d5c1', 'kas_keluar', '2026-10-22', 'CO-2610-1139', 'Kas Besar', 'Biaya Panen', 'Farm Cibeureum periode 6', '', 'kasbon abk cibeureum', 0.00, 4000000.00),
  ('t80023838de0f', 'kas_keluar', '2026-10-22', 'CO-2610-1140', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cilame 2 periode 6', '', 'kasbon opiq mekanik', 0.00, 500000.00),
  ('tf01a95e4981e', 'kas_keluar', '2026-10-22', 'CO-2610-1141', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cilame 1 periode 5', '', 'kasbon pak jatjat', 0.00, 2000000.00),
  ('t722b9a8b7256', 'kas_keluar', '2026-10-22', 'CO-2610-1142', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 22/10', 0.00, 30000.00),
  ('t3695fe9e2384', 'kas_keluar', '2026-10-22', 'CO-2610-1143', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'etoll zenix', 0.00, 1500000.00),
  ('t0e2cb593463b', 'kas_keluar', '2026-10-22', 'CO-2610-1144', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'Biaya rtgs', 0.00, 15000.00),
  ('tda586e55b08a', 'kas_keluar', '2026-10-22', 'CO-2610-1145', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi', 0.00, 425000.00),
  ('te151128cc87c', 'kas_keluar', '2026-10-22', 'CO-2610-1146', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kertas hvs a4', 0.00, 217500.00),
  ('t14d7b1646dd8', 'kas_keluar', '2026-10-22', 'CO-2610-1147', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'soto + nasi', 0.00, 47000.00),
  ('t846e9394ca0c', 'kas_keluar', '2026-10-22', 'CO-2610-1148', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'baygon, galon', 0.00, 67900.00),
  ('tbaa052637db2', 'kas_keluar', '2026-10-22', 'CO-2610-1149', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi', 0.00, 41000.00),
  ('tf9c47080c613', 'kas_keluar', '2026-10-22', 'CO-2610-1150', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'teh ai (pak ei)', 0.00, 110000.00),
  ('t9ceac77193ec', 'kas_keluar', '2026-10-22', 'CO-2610-1151', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'kasbon pak ei (rs pak sambas)', 0.00, 2302000.00),
  ('ta2e3e7097435', 'kas_keluar', '2026-10-22', 'CO-2610-1152', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'albey', 0.00, 50000.00),
  ('t6791a25d0723', 'kas_keluar', '2026-10-22', 'CO-2610-1153', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'beras, kecap, telur sukaregang (pak ei)', 0.00, 519000.00),
  ('t1e7777e71c16', 'kas_keluar', '2026-10-22', 'CO-2610-1154', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'kopi tubruk tujuhenam (pak ei)', 0.00, 100000.00),
  ('t443303785b62', 'kas_keluar', '2026-10-22', 'CO-2610-1155', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'bensin mobil abi (pak rajab)', 0.00, 300000.00),
  ('t407a85a4421a', 'kas_keluar', '2026-10-22', 'CO-2610-1156', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan', '', 'op. mega pak asun majalengka - subang 21/10', 0.00, 932000.00),
  ('t4e3d1ae1839d', 'kas_keluar', '2026-10-22', 'CO-2610-1157', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'surat dari orang log', 0.00, 300000.00),
  ('t930cb118ffe4', 'kas_keluar', '2026-10-22', 'CO-2610-1158', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'Kasbon pak fuzy', 0.00, 20000000.00),
  ('t80ab6a83d7a8', 'kas_keluar', '2026-10-22', 'CO-2610-1159', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'pasir pasang 1 rit', 0.00, 1500000.00),
  ('tc37af401ea3f', 'kas_keluar', '2026-10-22', 'CO-2610-1160', 'Kas Besar', 'Biaya Upah2', 'Zidam Rehab Gudkesrah', '', 'pasang kusen alumunium pintu spanrel wc', 0.00, 4000000.00),
  ('t3066e3e2c560', 'kas_keluar', '2026-10-22', 'CO-2610-1161', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'semen, amplas, dll', 0.00, 2022000.00),
  ('t55d79b60c5dd', 'kas_keluar', '2026-10-22', 'CO-2610-1162', 'Kas Besar', 'Hutang Dagang', 'Zidam Rehab Gudkesrah', 'V-HU-Berkat', 'semen, amplas, dll', 0.00, 39096000.00),
  ('tde894d2c967c', 'kas_keluar', '2026-10-22', 'CO-2610-1163', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 22', 0.00, 5000000.00),
  ('td2fd4b64c39f', 'kas_keluar', '2026-10-22', 'CO-2610-1164', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'biaya trf semen', 0.00, 2500.00),
  ('t98a25a43d631', 'kas_keluar', '2026-10-22', 'CO-2610-1165', 'Kas Besar', 'Hutang Dagang', 'Bina Marga Kodim Bangun Jalan Cibalong', 'V-HU-Berkat', 'nota berkat 29/8', 0.00, 10545000.00),
  ('tf5d379bb5480', 'kas_keluar', '2026-10-22', 'CO-2610-1166', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'bahan alumunium dustira', 0.00, 33922800.00),
  ('t99387fcf8f0c', 'kas_keluar', '2026-10-22', 'CO-2610-1167', 'Kas Besar', 'Biaya Upah3', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon tim putra', 0.00, 50000000.00),
  ('t92b5ccd75029', 'kas_keluar', '2026-10-22', 'CO-2610-1168', 'Kas Besar', 'Hutang Dagang', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', 'nota berkat 29/8', 0.00, 52969200.00),
  ('t1c579937e1a4', 'kas_keluar', '2026-10-22', 'CO-2610-1169', 'Kas Besar', 'Hutang Dagang', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', 'nota berkat 3/9 - 4/9', 0.00, 9923800.00),
  ('t33f8c5f54314', 'kas_keluar', '2026-10-22', 'CO-2610-1170', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'bata tempel, nako30', 0.00, 2568000.00),
  ('tef5b3b72511d', 'kas_keluar', '2026-10-22', 'CO-2610-1171', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'baja ringan, gypsum, merdeka, dll', 0.00, 2505000.00),
  ('ta199eb1bfb13', 'kas_keluar', '2026-10-22', 'CO-2610-1172', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'ongkos kirim beton priscast', 0.00, 1352500.00),
  ('td269db89a110', 'kas_keluar', '2026-10-22', 'CO-2610-1173', 'Kas Besar', 'Hutang Dagang', 'Kemhan Bangun Rumdis Korem Cirebon', 'V-HU-Nippon', 'Cat Nippon 3/9', 0.00, 7192800.00),
  ('tdb31d647e6b7', 'kas_keluar', '2026-10-22', 'CO-2610-1174', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'bahan alumunium subang', 0.00, 76674200.00),
  ('tf46a82762e45', 'kas_keluar', '2026-10-22', 'CO-2610-1175', 'Kas Besar', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', 'Cat nippon 4/9', 0.00, 8091900.00),
  ('t2d6ae764a93f', 'kas_keluar', '2026-10-22', 'CO-2610-1176', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'kasbon tim dani', 0.00, 12000000.00),
  ('t18dc98e1090a', 'kas_keluar', '2026-10-22', 'CO-2610-1177', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'kas rasel (karpet, ember, bensin, service motor)', 0.00, 670000.00),
  ('t67bf1fbcddf9', 'kas_keluar', '2026-10-22', 'CO-2610-1178', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kas rasel (isi cutter, mata bor, skrup gypsum, waterpas, dll)', 0.00, 340000.00),
  ('t615bdd07d8b3', 'kas_keluar', '2026-10-22', 'CO-2610-1179', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'kas rasel (galon pekerja)', 0.00, 77000.00),
  ('tadd25c0cf253', 'kas_keluar', '2026-10-22', 'CO-2610-1180', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'bahan matrial subang', 0.00, 2626500.00),
  ('t8009004761e7', 'kas_keluar', '2026-10-22', 'CO-2610-1182', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pasir pasang 2 rit', 0.00, 4800000.00),
  ('t271bcc532d8a', 'kas_keluar', '2026-10-22', 'CO-2610-1183', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim sipil', 0.00, 6000000.00),
  ('t7ac31cd5c76a', 'kas_keluar', '2026-10-22', 'CO-2610-1184', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'semen, gypsum , holo dll', 0.00, 20240000.00),
  ('tb69bc6ec7874', 'kas_keluar', '2026-10-22', 'CO-2610-1185', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kasbon tim jalan (pak yudi)', 0.00, 2000000.00),
  ('tb13c83fdd099', 'kas_keluar', '2026-10-22', 'CO-2610-1186', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kas pengecoran (um supir, teknisi, uang koordinasi, dll) cimahi', 0.00, 1000000.00),
  ('t33f45444d160', 'kas_keluar', '2026-10-22', 'CO-2610-1187', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'biaya trf', 0.00, 2500.00),
  ('t333202a716d2', 'kas_keluar', '2026-10-22', 'CO-2610-1188', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'bbm breaker, um operator', 0.00, 1500000.00),
  ('t29af152341d4', 'kas_keluar', '2026-10-22', 'CO-2610-1189', 'Kas Besar', 'Biaya Upah3', 'Bina Marga Rehab Jembatan Provinsi', '', 'DP Upah Pancang', 0.00, 25000000.00),
  ('t4861a3dd2b4e', 'kas_keluar', '2026-10-22', 'CO-2610-1190', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', 'Progres 40.19%', 0.00, 69352252.00),
  ('tfec2843d6213', 'kas_keluar', '2026-10-22', 'CO-2610-1191', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', 'ongkos tukang plafond', 0.00, 500000.00),
  ('tea77f74f0883', 'kas_keluar', '2026-10-22', 'CO-2610-1192', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'granit rizky', 0.00, 40480000.00),
  ('t19bf2854685d', 'kas_keluar', '2026-10-22', 'CO-2610-1193', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'upah pesantren almabrur', 0.00, 2220000.00),
  ('tfb1287c37d3f', 'kas_keluar', '2026-10-22', 'CO-2610-1194', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'upah pesantren alhasan', 0.00, 2640000.00),
  ('t38069d36703e', 'kas_keluar', '2026-10-22', 'CO-2610-1195', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'DP kusen', 0.00, 115000000.00);
