-- Sinkronisasi 5 November 2026.
--
-- 154 transaksi baru dari 5 file (bank_in, cash_out, jurnal_umum, bank_out, cash_in).
--
-- Pembayaran Hutang Dagang: CO-2611-0302 'nota berkat 17/9' Rp158.929.820 -> V-HU-Berkat
-- (melebihi sisa hutangnya, saldo jadi minus/lebih bayar -Rp110.465.976, sesuai Data Hutang).
--
-- CO-2611-0212 'bayar pinjaman ke arif' Rp200.000.000 -> HPK-Arif penuh (bukan dipecah).
-- Awalnya dikira ada gap Rp100.000.000 (saldo dikira seharusnya Rp310.000.000 dari basis
-- Rp410.000.000), tapi user mengkonfirmasi lewat Buku Besar HPK-Arif per relasi: saldo
-- SEBELUM transaksi ini sebenarnya Rp510.000.000 (bukan Rp410.000.000 -- ada mutasi lebih
-- awal yang sebelumnya tidak terlihat dari sync-sync ini saja), jadi debit penuh
-- Rp200.000.000 memang pas membawanya ke Rp310.000.000 sesuai Data Hutang. Dikonfirmasi benar.
-- CO-2611-0213 'bayar pinjaman ke bu kunkun' Rp45.000.000 TIDAK diberi relasi (tidak ada
-- kode vendor HPK untuk dia di 28 baris Data Hutang -- sesuai, tidak ada efek ke total referensi).
--
-- Piutang Usaha baru: CO-2611-0294 'asun' Rp4.000.000 -> Pi-Asun (sesuai Data Piutang).
--
-- 15 relasi Prive baru (delta Rp6.799.925, dicocokkan ke pola ket historis per pemilik,
-- nilai langsung di INSERT di bawah): Pr-Z (6 baris: biang/likur/namina pa zamzam + cash
-- bu desi + print jilid + makanan kucing), Pr-R (3 baris nusajaya/pa rajab), Pr-K (6 baris
-- biang/likur/namina pa karli + pak ei x3 -- 'pak ei' konsisten Pr-K sepanjang riwayat).
--
-- Voucher jurnal umum baru JU26110147 'belanja dapur tgl 26-31 oktober' Rp40.374.110 --
-- dipecah sesuai Detail Jurnal yang dikonfirmasi user dari awal: Biaya Bahan 39.348.110 +
-- Biaya Akomodasi 1.026.000 (debit) = Biaya Dibayar Dimuka 40.374.110 (kredit).
--
-- Koreksi NYATA pada transaksi lama:
--  - CO-2607-0168, CO-2609-0457, CO-2609-0458: akun lawan 'Biaya Lainnya' -> klasifikasi
--    yang benar (Biaya Pemeliharaan Alat & Kandang / Biaya Operasional)
--  - CO-2610-1347, CO-2610-1475, CO-2610-1534: nama project 'Kemhan Kodim Kuningan' ->
--    'Kemhan Kodim Kuningan Indramayu' (nama lengkap dari laporan sumber, pola sama seperti
--    rename 'Kodim X'->'Kemhan Kodim X' sebelumnya -- SUDAH dicek: bukan duplikat, nama ini
--    konsisten dipakai di semua transaksi baru project ini juga)
--  - CO-2611-0175 (transaksi baru dari sync 3 Nov): nominal Rp12.000.000 -> Rp10.300.000,
--    ket 'kas termen' -> 'amplop termen' (koreksi nyata, bukan baru di-insert di sini)
--
-- Pelajaran dari bug-bug sebelumnya: tidak ada UPDATE yang menyasar baris baru di-INSERT
-- di file ini -- semua relasi baru sudah langsung di nilai INSERT.

UPDATE `transactions` SET `akun_lawan` = 'Biaya Pemeliharaan Alat & Kandang' WHERE `ref` = 'CO-2607-0168' AND `akun_lawan` = 'Biaya Lainnya';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Operasional' WHERE `ref` = 'CO-2609-0457' AND `akun_lawan` = 'Biaya Lainnya';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Operasional' WHERE `ref` = 'CO-2609-0458' AND `akun_lawan` = 'Biaya Lainnya';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kuningan Indramayu' WHERE `ref` = 'CO-2610-1347' AND `project` = 'Kemhan Kodim Kuningan';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kuningan Indramayu' WHERE `ref` = 'CO-2610-1475' AND `project` = 'Kemhan Kodim Kuningan';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kuningan Indramayu' WHERE `ref` = 'CO-2610-1534' AND `project` = 'Kemhan Kodim Kuningan';
UPDATE `transactions` SET `kredit` = 10300000.00, `ket` = 'amplop termen' WHERE `ref` = 'CO-2611-0175' AND `kredit` = 12000000.00;

INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('j_new_JU26110147_bahan', '2026-11-05', 'JU26110147', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'Bahan', '', 'posted', 'belanja dapur tgl 26-31 oktober', 39348110.00, 0.00),
  ('j_new_JU26110147_akomodasi', '2026-11-05', 'JU26110147', 'Biaya Akomodasi', 'RS Guntur Belanja Dapur', '', 'Akomodasi', '', 'posted', 'belanja dapur tgl 26-31 oktober', 1026000.00, 0.00),
  ('j_new_JU26110147_dimuka', '2026-11-05', 'JU26110147', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', '', '', 'posted', 'belanja dapur tgl 26-31 oktober', 0.00, 40374110.00);

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t689a4d77e9bc', 'bank_keluar', '2026-11-04', 'BO-2611-0005', 'Bank BCA Cibeureum', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan keperluan kandang', 0.00, 17000000.00),
  ('td27d5a92f0ec', 'bank_keluar', '2026-11-04', 'BO-2611-0006', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 4 november', 0.00, 764951128.00),
  ('tc22a86afa28d', 'bank_keluar', '2026-11-04', 'BO-2611-0007', 'Bank BNI PT', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 4 november (maulusma)', 0.00, 75002500.00),
  ('t477458e4067d', 'bank_keluar', '2026-11-05', 'BO-2611-0008', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 5 november', 0.00, 975605957.00),
  ('t85ac4cf1be60', 'bank_masuk', '2026-11-04', 'BI-2611-0002', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'RS Guntur Gudang Farmasi', '', 'termen ke 2 farmasi', 421300000.00, 0.00),
  ('tf882cc1d9c65', 'kas_keluar', '2026-11-04', 'CO-2611-0203', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cibeureum periode 6', '', 'kasbon abk cbr a.n. gugum', 0.00, 1000000.00),
  ('ted8fbb47e47a', 'kas_keluar', '2026-11-04', 'CO-2611-0204', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'pelet', 0.00, 16000000.00),
  ('tc16a9c227875', 'kas_keluar', '2026-11-04', 'CO-2611-0205', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya RTGS', 0.00, 30000.00),
  ('ta68ea59d63f6', 'kas_keluar', '2026-11-04', 'CO-2611-0206', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya firecash', 0.00, 70000.00),
  ('t4d5bc1924966', 'kas_keluar', '2026-11-04', 'CO-2611-0207', 'Kas Besar', 'Biaya entertain', 'Cost Center', '', 'HP zfold', 0.00, 32346996.00),
  ('t9a3a89403758', 'kas_keluar', '2026-11-04', 'CO-2611-0208', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Cost Center', '', 'baju pak ade', 0.00, 2256000.00),
  ('t5cf09eab8c63', 'kas_keluar', '2026-11-04', 'CO-2611-0209', 'Kas Besar', 'Biaya Entertain Direksi', 'Cost Center', '', 'opeln direksi', 0.00, 306950.00),
  ('tf41c52fde4b5', 'kas_keluar', '2026-11-04', 'CO-2611-0210', 'Kas Besar', 'Biaya Entertain Direksi', 'Cost Center', '', 'giordano direksi', 0.00, 1916800.00),
  ('t5bf6717e33ad', 'kas_keluar', '2026-11-04', 'CO-2611-0211', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat pak zamzam', 0.00, 750000.00),
  ('tdfc462d8f5ac', 'kas_keluar', '2026-11-04', 'CO-2611-0212', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', 'HPK-Arif', 'bayar pinjaman ke arif', 0.00, 200000000.00),
  ('t27a66d6b4f6f', 'kas_keluar', '2026-11-04', 'CO-2611-0213', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', '', 'bayar pinjaman ke bu kunkun (sisa 100.000.000)', 0.00, 45000000.00),
  ('t93f6155b477f', 'kas_keluar', '2026-11-04', 'CO-2611-0214', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'PUPR Bangun Satpol PP Sumedang', '', 'op direksi ke sumedang', 0.00, 1000000.00),
  ('t2c404d7b1f21', 'kas_keluar', '2026-11-04', 'CO-2611-0215', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'cash bu desi', 0.00, 190000.00),
  ('td0413ad4db43', 'kas_keluar', '2026-11-04', 'CO-2611-0216', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'biang pa zamzam', 0.00, 1719450.00),
  ('tedbe388da8b7', 'kas_keluar', '2026-11-04', 'CO-2611-0217', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'likur pa zamzam', 0.00, 1411000.00),
  ('t09524e3549d3', 'kas_keluar', '2026-11-04', 'CO-2611-0218', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'namina pa zamzam', 0.00, 55070.00),
  ('t05735e9350bf', 'kas_keluar', '2026-11-04', 'CO-2611-0219', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'biang pa rajab', 0.00, 486700.00),
  ('tc98354b238ea', 'kas_keluar', '2026-11-04', 'CO-2611-0220', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'likur pa rajab', 0.00, 605600.00),
  ('t5de3af4661fe', 'kas_keluar', '2026-11-04', 'CO-2611-0221', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'namina pa rajab', 0.00, 317205.00),
  ('t34117c05d1ff', 'kas_keluar', '2026-11-04', 'CO-2611-0222', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'biang pa karli', 0.00, 105000.00),
  ('t24a20ed321b9', 'kas_keluar', '2026-11-04', 'CO-2611-0223', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'likur pa karli', 0.00, 215000.00),
  ('t04bd5037b786', 'kas_keluar', '2026-11-04', 'CO-2611-0224', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'namina pa kali', 0.00, 346900.00),
  ('t2c1d39c964a1', 'kas_keluar', '2026-11-04', 'CO-2611-0225', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kab Lebak', '', 'op yuki kodim lebak 2/11', 0.00, 777800.00),
  ('t6c1e4b6e0dbe', 'kas_keluar', '2026-11-04', 'CO-2611-0226', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kab Pandeglang', '', 'op yuki kodim pandeglang 3/11', 0.00, 1363900.00),
  ('t32d825c6cd59', 'kas_keluar', '2026-11-04', 'CO-2611-0227', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim kab Cilegon', '', 'op yuki kodim cilegon 3/11', 0.00, 579000.00),
  ('t3e7c16b80aa7', 'kas_keluar', '2026-11-04', 'CO-2611-0228', 'Kas Besar', 'Biaya Bahan', 'Cibatu', '', 'baja ringan dan baud', 0.00, 1970000.00),
  ('tfa8aaf914d88', 'kas_keluar', '2026-11-04', 'CO-2611-0229', 'Kas Besar', 'Biaya ADM', 'Tugu Perkim Cirebon', '', 'kas fikri (kertas f4)', 0.00, 68000.00),
  ('t8b826c5d3e1d', 'kas_keluar', '2026-11-04', 'CO-2611-0230', 'Kas Besar', 'Biaya Akomodasi', 'RS Guntur Gudang Farmasi', '', 'kontrakan', 0.00, 3000000.00),
  ('t636ad06b4001', 'kas_keluar', '2026-11-04', 'CO-2611-0231', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'bensin cary', 0.00, 202500.00),
  ('t24029f7724fe', 'kas_keluar', '2026-11-04', 'CO-2611-0232', 'Kas Besar', 'Biaya Bahan', 'Masjid RS Guntur', '', 'keramik lantai dan dinding', 0.00, 9025000.00),
  ('t23093bef6ae6', 'kas_keluar', '2026-11-04', 'CO-2611-0233', 'Kas Besar', 'Biaya Bahan', 'Masjid RS Guntur', '', 'batu alam', 0.00, 3375000.00),
  ('t2bcd06d1f973', 'kas_keluar', '2026-11-04', 'CO-2611-0234', 'Kas Besar', 'Biaya Upah', 'Kemhan Kodim Kab Sukabumi', '', 'DP kodim sukabumi', 0.00, 55055722.00),
  ('t01600d7f66bb', 'kas_keluar', '2026-11-04', 'CO-2611-0235', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Koramil Majalengka Cingambul', '', 'koramil cigambul (h dana)', 0.00, 15000000.00),
  ('t717f567b16d8', 'kas_keluar', '2026-11-04', 'CO-2611-0236', 'Kas Besar', 'Biaya Upah2', 'Zidam Rumdis Zipur', '', 'upah zipur', 0.00, 75600000.00),
  ('t9256a6770b70', 'kas_keluar', '2026-11-04', 'CO-2611-0237', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 4', 0.00, 3500000.00),
  ('t5d8308860254', 'kas_keluar', '2026-11-04', 'CO-2611-0238', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'operasional pencairan', 0.00, 1000000.00),
  ('t07bfb4005618', 'kas_keluar', '2026-11-04', 'CO-2611-0239', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'solar 420 L', 0.00, 5040000.00),
  ('tbabeb4650e77', 'kas_keluar', '2026-11-04', 'CO-2611-0240', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kekurangan revisi granit', 0.00, 82000.00),
  ('te3a08ab06a6a', 'kas_keluar', '2026-11-04', 'CO-2611-0241', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (flexible,, lem tetets, alat kebersihan, dll)', 0.00, 1042320.00),
  ('t1ed3bfd33ba7', 'kas_keluar', '2026-11-04', 'CO-2611-0242', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (bensin)', 0.00, 210090.00),
  ('te6d2bd126d59', 'kas_keluar', '2026-11-04', 'CO-2611-0243', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'siku', 0.00, 268000.00),
  ('t648677284f3b', 'kas_keluar', '2026-11-04', 'CO-2611-0244', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'nitoproof aw grey', 0.00, 1318000.00),
  ('tefce5acefc23', 'kas_keluar', '2026-11-04', 'CO-2611-0245', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'plester hebel, hebel, paku beton, roofing, serat', 0.00, 827000.00),
  ('t5e1e2ea3aead', 'kas_keluar', '2026-11-04', 'CO-2611-0246', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', 'kostan arya', 0.00, 1500000.00),
  ('taee15bacb30a', 'kas_keluar', '2026-11-04', 'CO-2611-0247', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'perekat keramik', 0.00, 12749625.00),
  ('t37172ddc6d11', 'kas_keluar', '2026-11-04', 'CO-2611-0248', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'kas fikri (kuas, uang ongkos cat) paviliun dustira', 0.00, 335000.00),
  ('t75dac9d3f2fb', 'kas_keluar', '2026-11-04', 'CO-2611-0249', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'pipa dan kabel ac', 0.00, 10168000.00),
  ('tc5f18cd8110f', 'kas_keluar', '2026-11-04', 'CO-2611-0250', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'lapju pangandaran', 0.00, 1002500.00),
  ('t50a5b4a8299e', 'kas_keluar', '2026-11-04', 'CO-2611-0251', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'knee', 0.00, 182500.00),
  ('tfe76419d9693', 'kas_keluar', '2026-11-04', 'CO-2611-0252', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kayu subang', 0.00, 550000.00),
  ('tf0acafed6714', 'kas_keluar', '2026-11-04', 'CO-2611-0253', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'biaya trf', 0.00, 2500.00),
  ('t74a27c8917dc', 'kas_keluar', '2026-11-04', 'CO-2611-0254', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim m. zek', 0.00, 6000000.00),
  ('t3969f659da4e', 'kas_keluar', '2026-11-04', 'CO-2611-0255', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pasir pasang 3 rit (sudah 5 juta)', 0.00, 1900000.00),
  ('t1f84065f1e36', 'kas_keluar', '2026-11-04', 'CO-2611-0256', 'Kas Besar', 'Biaya Upah', 'Kemhan Kodim Kuningan Indramayu', '', 'kasbon agus 31/10', 0.00, 5950000.00),
  ('tf8c6ccdf391b', 'kas_keluar', '2026-11-04', 'CO-2611-0257', 'Kas Besar', 'Biaya Upah', 'Kemhan Kodim Kuningan Indramayu', '', 'kasbon agus 4/11', 0.00, 3850000.00),
  ('tf3d2c5f08d0d', 'kas_keluar', '2026-11-04', 'CO-2611-0258', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'beton subang', 0.00, 114000000.00),
  ('tdeae59e5be05', 'kas_keluar', '2026-11-04', 'CO-2611-0259', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Bogor', '', 'kasbon pekerja plafond untuk makan', 0.00, 600000.00),
  ('tf577e3da1171', 'kas_keluar', '2026-11-04', 'CO-2611-0260', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'bayar angkut atap', 0.00, 1502500.00),
  ('ta873b9f61ab2', 'kas_keluar', '2026-11-04', 'CO-2611-0261', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kuas', 0.00, 672000.00),
  ('t33ff0f7c9515', 'kas_keluar', '2026-11-04', 'CO-2611-0262', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pasir 3/11', 0.00, 2400000.00),
  ('tbd214162075a', 'kas_keluar', '2026-11-04', 'CO-2611-0263', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'buang barangkal 2 rit', 0.00, 550000.00),
  ('tdb4434ca6d6d', 'kas_keluar', '2026-11-04', 'CO-2611-0264', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kas fikri (banner)', 0.00, 43000.00),
  ('ta84f1c6cc7b8', 'kas_keluar', '2026-11-04', 'CO-2611-0265', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'buang barangkal 2 rit', 0.00, 3500000.00),
  ('te11ccd58a768', 'kas_keluar', '2026-11-04', 'CO-2611-0266', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan 2 Gudang Selatan', '', 'OP pak ei nguriling', 0.00, 650500.00),
  ('t514169067e06', 'kas_keluar', '2026-11-04', 'CO-2611-0267', 'Kas Besar', 'Atensi', 'Proyek Patrakomala', '', 'perbaikan rumah ambruk', 0.00, 3801000.00),
  ('t01f4528ae665', 'kas_keluar', '2026-11-04', 'CO-2611-0268', 'Kas Besar', 'Biaya Upah', 'Jembatan Cirebon', '', 'dadang (DP)', 0.00, 100002500.00),
  ('t1bfa20ece4a1', 'kas_keluar', '2026-11-04', 'CO-2611-0269', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'buis sumedang', 0.00, 3600000.00),
  ('t1f714ed89dc8', 'kas_keluar', '2026-11-04', 'CO-2611-0270', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'capit 3 set', 0.00, 3750000.00),
  ('t52cb9748a332', 'kas_keluar', '2026-11-04', 'CO-2611-0271', 'Kas Besar', 'Biaya ADM', 'PUPR Bangun Satpol PP Sumedang', '', 'adm skds smdng', 0.00, 5000000.00),
  ('tf6b67a4fcdfb', 'kas_keluar', '2026-11-04', 'CO-2611-0272', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'bata ringan perekat 3/11', 0.00, 2944500.00),
  ('tffa31706052c', 'kas_keluar', '2026-11-04', 'CO-2611-0273', 'Kas Besar', 'Biaya Upah2', 'Zidam Rehab Rumdis Cimahi', '', 'kasbon upah kerja plafond', 0.00, 1500000.00),
  ('t90e3cb59dfdd', 'kas_keluar', '2026-11-04', 'CO-2611-0274', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'skrup grpsum, paku beton, bajaringan', 0.00, 3012000.00),
  ('t3f435a02b88d', 'kas_keluar', '2026-11-04', 'CO-2611-0275', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'pasir pasang 2 rit', 0.00, 4800000.00),
  ('tf13ef530e8a9', 'kas_keluar', '2026-11-04', 'CO-2611-0276', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Koramil Majalengka Maulusma', '', 'koramil maulusma pak kuwu', 0.00, 75002500.00),
  ('ta6dd42051d5f', 'kas_keluar', '2026-11-03', 'CO-2611-0277', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin gupron 29 okt - 4 nov', 0.00, 90000.00),
  ('tb1fa227af879', 'kas_keluar', '2026-11-03', 'CO-2611-0278', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'listrik suci 27 okt', 0.00, 101500.00),
  ('t5442716423ce', 'kas_keluar', '2026-11-03', 'CO-2611-0279', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'print compro pt', 0.00, 94500.00),
  ('t3ea8e2c6b2da', 'kas_keluar', '2026-11-03', 'CO-2611-0280', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'KNMP Cibalong', '', 'Op. gupron ttd kontrak adendum knmp garut 28/10', 0.00, 382500.00),
  ('t4f8b69edd760', 'kas_keluar', '2026-11-03', 'CO-2611-0281', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'BJB', '', 'op. gupron lelang bjbs 4/11', 0.00, 325000.00),
  ('tfa7e71e7aa21', 'kas_keluar', '2026-11-03', 'CO-2611-0282', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Bina Marga Rehab Jembatan Provinsi', '', 'op. gupron termin jembatan 2/11', 0.00, 417500.00),
  ('t2b49de0f905c', 'kas_keluar', '2026-11-03', 'CO-2611-0283', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Cost Center', '', 'op. gupron baloghan 5/11', 0.00, 289000.00),
  ('td066396265b9', 'kas_keluar', '2026-11-05', 'CO-2611-0284', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'servis motor kandang (jasa + sparepart)', 0.00, 447000.00),
  ('te893624cfb92', 'kas_keluar', '2026-11-05', 'CO-2611-0285', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'jasa servis motor kandang', 0.00, 200000.00),
  ('t6bab30bb867f', 'kas_keluar', '2026-11-05', 'CO-2611-0286', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 4/11', 0.00, 30000.00),
  ('t9b6e62694e7a', 'kas_keluar', '2026-11-05', 'CO-2611-0287', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'sparepart servis motor', 0.00, 1685000.00),
  ('t87ebc2850332', 'kas_keluar', '2026-11-05', 'CO-2611-0288', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 3/11', 0.00, 30000.00),
  ('t61eb91a48425', 'kas_keluar', '2026-11-05', 'CO-2611-0289', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'ganti ban inova', 0.00, 50000.00),
  ('t819284d1c65c', 'kas_keluar', '2026-11-05', 'CO-2611-0290', 'Kas Besar', 'Biaya entertain', 'Cost Center', '', 'karangan bunga pangalengan', 0.00, 550000.00),
  ('t3c30798ee301', 'kas_keluar', '2026-11-05', 'CO-2611-0291', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'kirim paket baju ke namina', 0.00, 15000.00),
  ('t14685985af45', 'kas_keluar', '2026-11-05', 'CO-2611-0292', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'claude pa fahri', 0.00, 501000.00),
  ('td14b5c675ac6', 'kas_keluar', '2026-11-05', 'CO-2611-0293', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Jembatan Pusziad', '', 'Atk termin ke 1 jembatan 2', 0.00, 6600000.00),
  ('t4e1f1368ec98', 'kas_keluar', '2026-11-05', 'CO-2611-0294', 'Kas Besar', 'Piutang Usaha', 'Cost Center', 'Pi-Asun', 'asun', 0.00, 4000000.00),
  ('tfabfa5b5fff3', 'kas_keluar', '2026-11-05', 'CO-2611-0295', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'print jilid (pa zamzam)', 0.00, 30000.00),
  ('t6008dc59e31c', 'kas_keluar', '2026-11-05', 'CO-2611-0296', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'martabak (pak ei)', 0.00, 120000.00),
  ('tcc74a31a2cb9', 'kas_keluar', '2026-11-05', 'CO-2611-0297', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'makanan kucing (pa zamzam)', 0.00, 65000.00),
  ('t49a01279e05f', 'kas_keluar', '2026-11-05', 'CO-2611-0298', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'baso (pak ei)', 0.00, 33000.00),
  ('t0bd32fb2fc26', 'kas_keluar', '2026-11-05', 'CO-2611-0299', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'psk ei (trf ke risa)', 0.00, 1100000.00),
  ('tb37df3d1b37e', 'kas_keluar', '2026-11-05', 'CO-2611-0300', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan', '', 'op pa zamzam ke kemhan 4/11', 0.00, 268156.00),
  ('tc249ff85d95f', 'kas_keluar', '2026-11-05', 'CO-2611-0301', 'Kas Besar', 'Biaya Upah', 'KNMP Donggala', '', 'donggala', 0.00, 500000000.00),
  ('tb4122ce8235d', 'kas_keluar', '2026-11-05', 'CO-2611-0302', 'Kas Besar', 'Hutang Dagang', 'Tugu Perkim Cirebon', 'V-HU-Berkat', 'nota berkat 17/9', 0.00, 158929820.00),
  ('tbbb6cbc43d74', 'kas_keluar', '2026-11-05', 'CO-2611-0303', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'fuji', 0.00, 20000000.00),
  ('t406136901821', 'kas_keluar', '2026-11-05', 'CO-2611-0304', 'Kas Besar', 'Biaya Upah2', 'RS Guntur Gudang Farmasi', '', 'kasbon pak nanang', 0.00, 3000000.00),
  ('tb0f5c1a1ab7f', 'kas_keluar', '2026-11-05', 'CO-2611-0305', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 5', 0.00, 6500000.00),
  ('t67716434397c', 'kas_keluar', '2026-11-05', 'CO-2611-0306', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'alumunium flexible duct, klem', 0.00, 3120000.00),
  ('t1d9618a9a83c', 'kas_keluar', '2026-11-05', 'CO-2611-0307', 'Kas Besar', 'Biaya entertain', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (makan tim urdal, tim pphp, tim pengadaan)', 0.00, 510000.00),
  ('tb22a38aa559f', 'kas_keluar', '2026-11-05', 'CO-2611-0308', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (matabor, mata roofing, knee)', 0.00, 401500.00),
  ('t2d023cf77d57', 'kas_keluar', '2026-11-05', 'CO-2611-0309', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (gojek arya)', 0.00, 179750.00),
  ('t33142fdd5ecc', 'kas_keluar', '2026-11-05', 'CO-2611-0310', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'dempul, batu potong, kawat las, wf 100 4/11', 0.00, 860000.00),
  ('t615ee4c7c5e1', 'kas_keluar', '2026-11-05', 'CO-2611-0311', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'siku, wf, lem', 0.00, 985000.00),
  ('t8da2f6881fdd', 'kas_keluar', '2026-11-05', 'CO-2611-0312', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'thinner, multi, dll', 0.00, 1679500.00),
  ('t4c84cb7d0c0c', 'kas_keluar', '2026-11-05', 'CO-2611-0313', 'Kas Besar', 'Biaya entertain', 'Proyek Antapani', '', 'kas arya (upah ajudan, rokok ajudan 3x)', 0.00, 652000.00),
  ('td998d14cc4e9', 'kas_keluar', '2026-11-05', 'CO-2611-0314', 'Kas Besar', 'Biaya Upah2', 'Proyek Antapani', '', 'kas arya (makan lembur)', 0.00, 225000.00),
  ('t6dd8045b8d84', 'kas_keluar', '2026-11-05', 'CO-2611-0315', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'kas arya (karung, cutting wd, plastik cor, lakban, dll)', 0.00, 664500.00),
  ('t17e7b9beff2b', 'kas_keluar', '2026-11-05', 'CO-2611-0316', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', 'kas arya (gojek arya)', 0.00, 179750.00),
  ('t24733602d208', 'kas_keluar', '2026-11-05', 'CO-2611-0317', 'Kas Besar', 'Biaya Upah', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'opname cat genteng paviliun', 0.00, 17731684.00),
  ('te39fa01b262c', 'kas_keluar', '2026-11-05', 'CO-2611-0318', 'Kas Besar', 'Biaya Upah', 'Asmira Dustira', '', 'iqbal', 0.00, 20000000.00),
  ('t89c24fbf84c5', 'kas_keluar', '2026-11-05', 'CO-2611-0319', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'semen', 0.00, 2250000.00),
  ('t0fa27477b6cd', 'kas_keluar', '2026-11-05', 'CO-2611-0320', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'inkalum skoneng', 0.00, 4327050.00),
  ('tc5f9021fdb02', 'kas_keluar', '2026-11-05', 'CO-2611-0321', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'sewa mobil engkel', 0.00, 500000.00),
  ('t0e689d35c7fd', 'kas_keluar', '2026-11-05', 'CO-2611-0322', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'pelunasan pintu', 0.00, 23500000.00),
  ('t75644fa93966', 'kas_keluar', '2026-11-05', 'CO-2611-0323', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'kas rasel (bensin, servis motor)', 0.00, 1041000.00),
  ('t754f12479fa8', 'kas_keluar', '2026-11-05', 'CO-2611-0324', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kas rasel (bensin stemper, skrap, komdus kotak dll)', 0.00, 531000.00),
  ('t77d47b6809cd', 'kas_keluar', '2026-11-05', 'CO-2611-0325', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kran angsa, saringan wc 3/11', 0.00, 1639000.00),
  ('t66252ead3328', 'kas_keluar', '2026-11-05', 'CO-2611-0326', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'semen', 0.00, 9406500.00),
  ('t9d7bfc80aaf2', 'kas_keluar', '2026-11-05', 'CO-2611-0327', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', 'kas arya (mejikom)', 0.00, 150000.00),
  ('t96868dd40247', 'kas_keluar', '2026-11-05', 'CO-2611-0328', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kas arya (dempul, sikat kawat, roll cat, kuas, thinner, dll)', 0.00, 274000.00),
  ('t9f98e83c9e14', 'kas_keluar', '2026-11-05', 'CO-2611-0329', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'kas pengecoran subang', 0.00, 1800000.00),
  ('tb443f7c9767c', 'kas_keluar', '2026-11-05', 'CO-2611-0330', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'kas rapat dengan polres', 0.00, 1000000.00),
  ('t53f0dc7087fd', 'kas_keluar', '2026-11-05', 'CO-2611-0332', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', 'progres 70% (dipotong pintu dan kasbon plafond)', 0.00, 48052252.00),
  ('t78e1b3451425', 'kas_keluar', '2026-11-05', 'CO-2611-0333', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pemb angkut puing', 0.00, 3700000.00),
  ('tfe492194293d', 'kas_keluar', '2026-11-05', 'CO-2611-0334', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'sewa beko', 0.00, 10000000.00),
  ('td5756a9664d7', 'kas_keluar', '2026-11-05', 'CO-2611-0335', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'material gudang utara', 0.00, 3815000.00),
  ('tb038e48fa80d', 'kas_keluar', '2026-11-05', 'CO-2611-0336', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kran, sealtape', 0.00, 47000.00),
  ('t82cff91ead44', 'kas_keluar', '2026-11-05', 'CO-2611-0337', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'gojek, aqua, bensin', 0.00, 125000.00),
  ('tc24e6e1ab4c0', 'kas_keluar', '2026-11-05', 'CO-2611-0338', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'bayaran pekerja pesantren al hasan', 0.00, 2270000.00),
  ('t1a1b377a9d4e', 'kas_keluar', '2026-11-05', 'CO-2611-0339', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'ketua direksi', 0.00, 1000000.00),
  ('t7cebfe75e7ce', 'kas_keluar', '2026-11-05', 'CO-2611-0340', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'bayaran pekerja pesantren al mabrur', 0.00, 2380000.00),
  ('t3b90ef542629', 'kas_keluar', '2026-11-05', 'CO-2611-0341', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'granit unpolish, watafel gantung, partisi', 0.00, 15820000.00),
  ('t106f993aa2f5', 'kas_keluar', '2026-11-05', 'CO-2611-0342', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'granit lantai 2 (meliuz)', 0.00, 10043000.00),
  ('tbe83716289b7', 'kas_keluar', '2026-11-05', 'CO-2611-0343', 'Kas Besar', 'Biaya Upah2', 'PUPR Bangun Satpol PP Sumedang', '', 'kasbon pekerja alumunium', 0.00, 25000000.00),
  ('te65f1fff13d7', 'kas_keluar', '2026-11-05', 'CO-2611-0344', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'nota berkat (contoh besi 16)', 0.00, 204795.00),
  ('t6ede4b0aa506', 'kas_keluar', '2026-11-05', 'CO-2611-0345', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'PUPR Bangun Satpol PP Sumedang', '', 'op. dewo sumedang 3/11', 0.00, 395000.00),
  ('t450194687c9e', 'kas_keluar', '2026-11-05', 'CO-2611-0346', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'buang barangkal 12 rit', 0.00, 2400000.00),
  ('t04d2186f72b9', 'kas_keluar', '2026-11-05', 'CO-2611-0347', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'paku beton', 0.00, 182500.00),
  ('te11f094cafd1', 'kas_keluar', '2026-11-05', 'CO-2611-0348', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'keramik', 0.00, 18310200.00),
  ('tcbeaad0fcb7d', 'kas_keluar', '2026-11-05', 'CO-2611-0349', 'Kas Besar', 'Biaya Bahan', 'Korem Garut', '', 'pasir, split', 0.00, 2600000.00),
  ('tf2eb9fc84ac1', 'kas_keluar', '2026-11-05', 'CO-2611-0350', 'Kas Besar', 'Biaya Bahan', 'Masjid RS Guntur', '', 'pasir pasang', 0.00, 1500000.00),
  ('t71cca5f2e63f', 'kas_masuk', '2026-11-04', 'CI-2611-0003', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 4 november', 856953628.00, 0.00),
  ('tfca895787330', 'kas_masuk', '2026-11-05', 'CI-2611-0004', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 5 november', 975605957.00, 0.00);
