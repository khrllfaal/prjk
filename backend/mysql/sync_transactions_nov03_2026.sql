-- Sinkronisasi 3 November 2026.
--
-- 95 transaksi baru (lihat INSERT transactions di bawah). Tidak ada baris baru
-- untuk Hutang Dagang / Piutang di laporan ini -- totalnya tetap sesuai referensi
-- (Rp10.135.238.564 / Rp1.261.553.948, tidak berubah).
--
-- 2 perubahan BESAR yang menjelaskan lonjakan Trial Balance November (sudah
-- diverifikasi via Playwright, bukan ditelusuri manual):
--  - BI-2611-0001 'uang masuk cibalong ke-3' Rp2.976.206.496 -> akun Pendapatan
--    Proyek, project Bina Marga Kodim Bangun Jalan Cibalong -- persis sama dengan
--    kenaikan Mutasi Kredit '4.1.1 Pendapatan Proyek' di Trial Balance.
--  - CO-2611-0148 'cash' Rp1.400.000.000 -> akun Biaya ADM Fee, project yang sama
--    (Bina Marga Kodim Bangun Jalan Cibalong) -- persis sama dengan '5.1.11 Biaya
--    ADM Fee' Trial Balance (sebelumnya nol). Kedua transaksi tanggal sama (3 Nov),
--    masuk akal: termin cibalong ke-3 diterima lalu admin fee-nya langsung dibayar.
--
-- 6 relasi Prive baru (delta Data Prive Rp11.182.500, dicocokkan ke pola ket
-- historis per pemilik, nilai langsung di INSERT di bawah -- bukan UPDATE terpisah):
--  - CO-2611-0130 'reinburse opal' -> Pr-F (Rp1.095.000, pas = delta Pr-F)
--  - CO-2611-0133 'kasbon nani' -> Pr-I (Rp1.700.000, pas = delta Pr-I, pola sama
--    seperti kemunculan 'kasbon nani' sebelumnya)
--  - CO-2611-0134 'nota mm 5-28 sep (nusajaya)' + CO-2611-0135 'nota persis 27 sep -
--    7 okt (nusajaya)' + CO-2611-0137 'name tag vira (pa rajab)' -> Pr-R
--    (Rp5.502.000 + Rp2.788.500 + Rp20.000 = Rp8.310.500, pas = delta Pr-R)
--  - CO-2611-0136 'sate, tahu, kresek (pa zamzam)' -> Pr-Z (Rp77.000, pas = delta Pr-Z)
--  Pr-K tidak berubah (tidak ada baris baru untuk Pr-K).
--
-- Koreksi NYATA (bukan normalisasi spasi) pada transaksi lama:
--  - CO-2607-0242: akun lawan 'Biaya Bahan' -> 'Biaya Bahan2', ket 'beton k250 ...' ->
--    'beton cimahi k250 ...' (klarifikasi lokasi, bukan cuma spasi)
--  - CO-2608-0084, CO-2608-0152: akun lawan 'Biaya Alat Konstruksi' -> 'Biaya Bahan'
--  - CO-2608-0107, CO-2609-0288: akun lawan -> 'Biaya ADM' (dari 'Biaya Entertain
--    Direksi' / 'Biaya Perjalanan Dinas Direksi')
--  - 7x akun lawan 'Biaya Upah2' -> 'Biaya ADM' (semua terkait 'pengawas', pola
--    konsisten: biaya pengawas direklasifikasi ke ADM, bukan upah langsung) --
--    CO-2609-1061/1141/1237, CO-2610-1290/1382/1385/1499/1628
--  - CO-2611-0002 'gaji clm 1' (baru di-insert sync kemarin, 2 Nov): nominal
--    Rp49.900.000 -> Rp49.400.000 (koreksi turun Rp500.000)
--
-- Pelajaran dari bug sync 30 Oktober: tidak ada UPDATE yang menyasar baris yang
-- baru di-INSERT di file ini -- semua relasi baru sudah langsung di nilai INSERT.

UPDATE `transactions` SET `akun_lawan` = 'Biaya Bahan2', `ket` = 'beton cimahi k250 (18 dan 22 juni) 25/6' WHERE `ref` = 'CO-2607-0242' AND `akun_lawan` = 'Biaya Bahan';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Bahan' WHERE `ref` = 'CO-2608-0084' AND `akun_lawan` = 'Biaya Alat Konstruksi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2608-0107' AND `akun_lawan` = 'Biaya Entertain Direksi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Bahan' WHERE `ref` = 'CO-2608-0152' AND `akun_lawan` = 'Biaya Alat Konstruksi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2609-0288' AND `akun_lawan` = 'Biaya Perjalanan Dinas Direksi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2609-1061' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2609-1141' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2609-1237' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2610-1290' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2610-1382' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2610-1385' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2610-1499' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2610-1628' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `kredit` = 49400000.00 WHERE `ref` = 'CO-2611-0002' AND `kredit` = 49900000.00;

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t72f9ee74f692', 'bank_keluar', '2026-11-03', 'BO-2611-0002', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 3 november', 0.00, 1400000000.00),
  ('t7f3e3f3ce63d', 'bank_keluar', '2026-11-03', 'BO-2611-0003', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 3 november', 0.00, 1062057426.00),
  ('t7148a7963d14', 'bank_keluar', '2026-11-03', 'BO-2611-0004', 'Bank BJB RC PT', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'materai', 0.00, 10000.00),
  ('t09b7bf646b04', 'bank_masuk', '2026-11-03', 'BI-2611-0001', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'uang masuk cibalong ke-3', 2976206496.00, 0.00),
  ('t9ba5e4c35afd', 'kas_keluar', '2026-11-03', 'CO-2611-0113', 'Kas Besar', 'Biaya Makan Karyawan', 'Farm Cibeureum periode 6', '', 'makan kandang oktober cbr', 0.00, 8260000.00),
  ('t4051740798c1', 'kas_keluar', '2026-11-03', 'CO-2611-0114', 'Kas Besar', 'Biaya Makan Karyawan', 'Farm Cilame 1 periode 5', '', 'makan kandang oktober clm1', 0.00, 16580000.00),
  ('ta716ec78f482', 'kas_keluar', '2026-11-03', 'CO-2611-0115', 'Kas Besar', 'Biaya Makan Karyawan', 'Farm Cilame 2 periode 6', '', 'makan kandang oktober clm2', 0.00, 4880000.00),
  ('tfcdbf786fc4e', 'kas_keluar', '2026-11-03', 'CO-2611-0116', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'nota mm 18 sept cilame 1', 0.00, 250000.00),
  ('t2e1801e652d0', 'kas_keluar', '2026-11-03', 'CO-2611-0117', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 2 periode 6', '', 'nota mm 6 okt cilame 2', 0.00, 440000.00),
  ('t88876f2fea1a', 'kas_keluar', '2026-11-03', 'CO-2611-0118', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'nota persis 17-23 sept cilame 1', 0.00, 740000.00),
  ('t49b92aa1a5f7', 'kas_keluar', '2026-11-03', 'CO-2611-0119', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 2 periode 6', '', 'nota persis 8 okt cilame 2', 0.00, 100000.00),
  ('tca5863f0c42e', 'kas_keluar', '2026-11-03', 'CO-2611-0120', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'bunga bu endah', 0.00, 5000000.00),
  ('t0c1561e4c603', 'kas_keluar', '2026-11-03', 'CO-2611-0121', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'maktal oli (nota 5/8 - 26/10)', 0.00, 3203000.00),
  ('t7fb7ad727777', 'kas_keluar', '2026-11-03', 'CO-2611-0122', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'oli inova hitam', 0.00, 1154000.00),
  ('t938c44a00f85', 'kas_keluar', '2026-11-03', 'CO-2611-0123', 'Kas Besar', 'Biaya Pemeliharaan Kantor', 'Cost Center', '', 'nota mm (otomatis pompa) 6 okt', 0.00, 75000.00),
  ('tb86a68c03913', 'kas_keluar', '2026-11-03', 'CO-2611-0124', 'Kas Besar', 'Biaya Pemeliharaan Kantor', 'Cost Center', '', 'nota persis 21 sep', 0.00, 85000.00),
  ('t1129c4a8eac4', 'kas_keluar', '2026-11-03', 'CO-2611-0125', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, surabi', 0.00, 86000.00),
  ('t885bf52aa769', 'kas_keluar', '2026-11-03', 'CO-2611-0126', 'Kas Besar', 'Biaya Telepon', 'Cost Center', '', 'pulsa pa fahri', 0.00, 52000.00),
  ('tcbb79cd80676', 'kas_keluar', '2026-11-03', 'CO-2611-0127', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nota biang kantor', 0.00, 66400.00),
  ('t6a6e3bd562a4', 'kas_keluar', '2026-11-03', 'CO-2611-0128', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nota likur kantor', 0.00, 460900.00),
  ('t9b3f8da13d10', 'kas_keluar', '2026-11-03', 'CO-2611-0129', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nota namina kantor', 0.00, 347550.00),
  ('ta2217bbab1e5', 'kas_keluar', '2026-11-03', 'CO-2611-0130', 'Kas Besar', 'Prive', 'Prive', 'Pr-F', 'reinburse opal', 0.00, 1095000.00),
  ('t4005a6e0974e', 'kas_keluar', '2026-11-03', 'CO-2611-0131', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'suci', 0.00, 500000.00),
  ('tc664f1c9df22', 'kas_keluar', '2026-11-03', 'CO-2611-0132', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya trf gaji (beda bank)', 0.00, 15000.00),
  ('t4de006b22af0', 'kas_keluar', '2026-11-03', 'CO-2611-0133', 'Kas Besar', 'Prive', 'Prive', 'Pr-I', 'kasbon nani', 0.00, 1700000.00),
  ('t4f1e46a931ca', 'kas_keluar', '2026-11-03', 'CO-2611-0134', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'nota mm 5-28 sep (nusajaya)', 0.00, 5502000.00),
  ('t2696e2ed7bc5', 'kas_keluar', '2026-11-03', 'CO-2611-0135', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'nota persis 27 sep - 7 okt (nusajaya)', 0.00, 2788500.00),
  ('t8a268b405f5e', 'kas_keluar', '2026-11-03', 'CO-2611-0136', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'sate, tahu, kresek (pa zamzam)', 0.00, 77000.00),
  ('t1ac642fad43b', 'kas_keluar', '2026-11-03', 'CO-2611-0137', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'name tag vira (pa rajab)', 0.00, 20000.00),
  ('te6d0603982a5', 'kas_keluar', '2026-11-03', 'CO-2611-0138', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'adendum jamlak kemhan pt prakasa', 0.00, 26137000.00),
  ('t6a9c681ab11c', 'kas_keluar', '2026-11-03', 'CO-2611-0139', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'adendum jamlak kemhan pt restu ibu', 0.00, 27542000.00),
  ('te9c8f418d439', 'kas_keluar', '2026-11-03', 'CO-2611-0140', 'Kas Besar', 'Biaya entertain', 'Kemhan Tahap 2', '', 'oleh oleh', 0.00, 1444000.00),
  ('t7118dd723eec', 'kas_keluar', '2026-11-03', 'CO-2611-0141', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'matrial listrik 26 okt', 0.00, 371000.00),
  ('t3db3b8928630', 'kas_keluar', '2026-11-03', 'CO-2611-0142', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'nota persis 6 -21 okt', 0.00, 2630000.00),
  ('tedb61ee4e736', 'kas_keluar', '2026-11-03', 'CO-2611-0143', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 3', 0.00, 9000000.00),
  ('t5d1ef8c75132', 'kas_keluar', '2026-11-03', 'CO-2611-0144', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'ompreng', 0.00, 6760000.00),
  ('t7b0d13c3ed4c', 'kas_keluar', '2026-11-03', 'CO-2611-0145', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'nota mm 14 - 26 sep', 0.00, 18300000.00),
  ('t14163c845ca0', 'kas_keluar', '2026-11-03', 'CO-2611-0146', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'nota persis 8 okt', 0.00, 375000.00),
  ('tb39b1a30e7d3', 'kas_keluar', '2026-11-03', 'CO-2611-0147', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'adm pencairan ke 3', 0.00, 2000000.00),
  ('t16824386f4e2', 'kas_keluar', '2026-11-03', 'CO-2611-0148', 'Kas Besar', 'Biaya ADM Fee', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'cash', 0.00, 1400000000.00),
  ('t7a37d72460f6', 'kas_keluar', '2026-11-03', 'CO-2611-0149', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'plafond pvc', 0.00, 990000.00),
  ('td6a35511e15d', 'kas_keluar', '2026-11-03', 'CO-2611-0150', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'matrial listrik 16-23 okt', 0.00, 10368500.00),
  ('t1251c2056a68', 'kas_keluar', '2026-11-03', 'CO-2611-0151', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'pvc pipa mas, tee, keni', 0.00, 2263000.00),
  ('t540a40c6fffd', 'kas_keluar', '2026-11-03', 'CO-2611-0152', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'nym 4 roll', 0.00, 2000000.00),
  ('t2dcc2da7091a', 'kas_keluar', '2026-11-03', 'CO-2611-0153', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'granit', 0.00, 207000.00),
  ('tdfb6241db871', 'kas_keluar', '2026-11-03', 'CO-2611-0154', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'talang antapani', 0.00, 280000.00),
  ('t44b4d284b4c0', 'kas_keluar', '2026-11-03', 'CO-2611-0155', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'pasir cor, besi 10,, besi 8', 0.00, 431000.00),
  ('t5ea414824df6', 'kas_keluar', '2026-11-03', 'CO-2611-0156', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'MOS 20 % tekanan negatif', 0.00, 100903388.00),
  ('t8967816892be', 'kas_keluar', '2026-11-03', 'CO-2611-0157', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'DP 30% ducting exhaust', 0.00, 40185000.00),
  ('t324da8767081', 'kas_keluar', '2026-11-03', 'CO-2611-0158', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'termitex Pl', 0.00, 3060000.00),
  ('tf7bfb9199e90', 'kas_keluar', '2026-11-03', 'CO-2611-0159', 'Kas Besar', 'Biaya Bahan', 'Armed', '', 'trospal', 0.00, 4800000.00),
  ('tb6ed4a8e3b52', 'kas_keluar', '2026-11-03', 'CO-2611-0160', 'Kas Besar', 'Biaya Upah', 'Tugu TNI', '', 'tugu ervan', 0.00, 7500000.00),
  ('t733a56673397', 'kas_keluar', '2026-11-03', 'CO-2611-0161', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'matrial listrik 19 okt', 0.00, 400000.00),
  ('t99f5ba6fca5c', 'kas_keluar', '2026-11-03', 'CO-2611-0162', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'nota mm 9-14 sep', 0.00, 3825000.00),
  ('tb40238ff93b3', 'kas_keluar', '2026-11-03', 'CO-2611-0163', 'Kas Besar', 'Biaya ADM', 'Kemhan Bangun Rumdis Subang', '', 'kekurangan pengawas', 0.00, 2000000.00),
  ('t7d5be9b66c16', 'kas_keluar', '2026-11-03', 'CO-2611-0164', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'isi ulang galon', 0.00, 420000.00),
  ('t6d5c10bd45ad', 'kas_keluar', '2026-11-03', 'CO-2611-0165', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'op pa dewo ke subang anter bahan 2/11', 0.00, 375000.00),
  ('t2d73c057360f', 'kas_keluar', '2026-11-03', 'CO-2611-0166', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'grc dll', 0.00, 1230000.00),
  ('t83e22993e14e', 'kas_keluar', '2026-11-03', 'CO-2611-0167', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'nota mm 5 sep - 6 okt', 0.00, 4340000.00),
  ('tffa279f41f4c', 'kas_keluar', '2026-11-03', 'CO-2611-0168', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'borongan cat genteng', 0.00, 3660000.00),
  ('tde2c0ee57ed3', 'kas_keluar', '2026-11-03', 'CO-2611-0169', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim listrik', 0.00, 4000000.00),
  ('tbfdac9089fc8', 'kas_keluar', '2026-11-03', 'CO-2611-0170', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'borongan pek alumunium kusen kopel 1-2', 0.00, 20600000.00),
  ('t53d95a9536be', 'kas_keluar', '2026-11-03', 'CO-2611-0171', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pvc pipamas, soket aw, lem asahi', 0.00, 1266500.00),
  ('t0d6e6848a611', 'kas_keluar', '2026-11-03', 'CO-2611-0172', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'beton k300 50 m3, subang', 0.00, 60000000.00),
  ('t23bd4475d5a6', 'kas_keluar', '2026-11-03', 'CO-2611-0173', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'pengecoran jalan subang', 0.00, 1100000.00),
  ('t5a0db4284e09', 'kas_keluar', '2026-11-03', 'CO-2611-0174', 'Kas Besar', 'Biaya Bahan2', 'Kemhan Cut n Fill', '', 'beton cimahi 187 kubik', 0.00, 181390000.00),
  ('t868c4c2d2d29', 'kas_keluar', '2026-11-03', 'CO-2611-0175', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'kas termen', 0.00, 12000000.00),
  ('t0b5041ef3961', 'kas_keluar', '2026-11-03', 'CO-2611-0176', 'Kas Besar', 'Biaya Upah', 'BJB Riau', '', 'progres jl riau 70% (10%)', 0.00, 43417958.00),
  ('t747368bd3df4', 'kas_keluar', '2026-11-03', 'CO-2611-0177', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Bogor', '', 'bensin hamdan 1/11', 0.00, 60130.00),
  ('t19769613d6e8', 'kas_keluar', '2026-11-03', 'CO-2611-0178', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'angkut barangkal', 0.00, 752500.00),
  ('tb2cae4e8606b', 'kas_keluar', '2026-11-03', 'CO-2611-0179', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'kasbon pekerja (untuk makan)', 0.00, 800000.00),
  ('t7b52b0eabb36', 'kas_keluar', '2026-11-03', 'CO-2611-0180', 'Kas Besar', 'Biaya Upah2', 'Kemhan 2 Gudang Selatan', '', 'kas deni (isi ulang galon)', 0.00, 168000.00),
  ('t5f7e6f0b12f9', 'kas_keluar', '2026-11-03', 'CO-2611-0181', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kas deni (paku 5, paku 7, dempul, palu, bensin molen)', 0.00, 425500.00),
  ('tf6c9e23eb727', 'kas_keluar', '2026-11-03', 'CO-2611-0182', 'Kas Besar', 'Biaya ADM', 'BJB', '', 'reinburse anwizing bjb syariah', 0.00, 1500000.00),
  ('t2655fb0d8e53', 'kas_keluar', '2026-11-03', 'CO-2611-0183', 'Kas Besar', 'Biaya ADM', 'BJB', '', 'jaminan penawaran bjb syariah', 0.00, 300000.00),
  ('tdcae04d9afc6', 'kas_keluar', '2026-11-03', 'CO-2611-0184', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pasir pasang', 0.00, 2400000.00),
  ('t600756193ff2', 'kas_keluar', '2026-11-03', 'CO-2611-0185', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'keramik, sarung tangan, lem kaca, avian, thinner, dll', 0.00, 556000.00),
  ('t4d63d16eb805', 'kas_keluar', '2026-11-03', 'CO-2611-0186', 'Kas Besar', 'Biaya Bahan', 'Proyek Patrakomala', '', 'nota mm 26 sep', 0.00, 905000.00),
  ('t3915ad2caf73', 'kas_keluar', '2026-11-03', 'CO-2611-0187', 'Kas Besar', 'Biaya Bahan', 'Proyek Patrakomala', '', 'nota persis 26 sep', 0.00, 264000.00),
  ('t17d028a126d1', 'kas_keluar', '2026-11-03', 'CO-2611-0188', 'Kas Besar', 'Biaya Upah', 'Proyek Patrakomala', '', 'progres 50% (termin ke 2)', 0.00, 150000000.00),
  ('tc1d223d37ef0', 'kas_keluar', '2026-11-03', 'CO-2611-0189', 'Kas Besar', 'Biaya Upah', 'ZIDAM Bangun Rumdis Pangandaran', '', 'progres ke 3', 0.00, 155000000.00),
  ('td27d41457dab', 'kas_keluar', '2026-11-03', 'CO-2611-0190', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'pasir pasang', 0.00, 3700000.00),
  ('t80d9d1da1c2b', 'kas_keluar', '2026-11-03', 'CO-2611-0191', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'matrial listrik 19-26 okt', 0.00, 42205000.00),
  ('tf150edee6dc3', 'kas_keluar', '2026-11-03', 'CO-2611-0192', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'biotank 2500l + ongkir', 0.00, 6800000.00),
  ('t23e7d3098397', 'kas_keluar', '2026-11-03', 'CO-2611-0193', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'cat jotun 10 pail', 0.00, 13700000.00),
  ('t194b6b0f6c4d', 'kas_keluar', '2026-11-03', 'CO-2611-0194', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'pacul, doran', 0.00, 230000.00),
  ('t6b038e41a608', 'kas_keluar', '2026-11-03', 'CO-2611-0195', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'baja ringan, reng, list, ramset', 0.00, 4795000.00),
  ('tfed9b96d1c12', 'kas_keluar', '2026-11-03', 'CO-2611-0196', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'bata ringan, perekat, semen merdeka', 0.00, 4660000.00),
  ('t23e9e0cc38b3', 'kas_keluar', '2026-11-03', 'CO-2611-0197', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'pipa pipa', 0.00, 6735500.00),
  ('t6b65e2e8006d', 'kas_keluar', '2026-11-03', 'CO-2611-0198', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'scrap plat', 0.00, 130000.00),
  ('t185832ca1e15', 'kas_keluar', '2026-11-03', 'CO-2611-0199', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'pipa condulit, inbow', 0.00, 1800000.00),
  ('tc05803dd804c', 'kas_keluar', '2026-11-03', 'CO-2611-0200', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 1 periode 5', '', 'pinjaman ke namina (jasa potong ayam, kresek, ongkir, mie, dll)', 0.00, 1619907.00),
  ('tbdfdb0935c32', 'kas_keluar', '2026-11-03', 'CO-2611-0201', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan 2 Gudang Selatan', '', 'op pa fahri ke gudang utara 2/11', 0.00, 922256.00),
  ('t653d52a41f34', 'kas_keluar', '2026-11-03', 'CO-2611-0202', 'Kas Besar', 'Biaya Operasional', 'Farm Cibeureum periode 6', '', 'pinjaman ke namina (pdam, jasa potong ayam, kresek, ongkir, mie, dll)', 0.00, 1079937.00),
  ('t16674619f962', 'kas_masuk', '2026-11-03', 'CI-2611-0002', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 3 november', 2462057426.00, 0.00);
