-- Sinkronisasi dari Report export terbaru (19 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup semua
-- file sync sebelumnya s/d sync_transactions_okt16_2026.sql.
--
-- Ditemukan 90 transaksi baru, 0 transaksi hilang, dan 3
-- penyesuaian akun_lawan (reklasifikasi murni, bukan soal nilai):
--  - CO-2609-1064, CO-2610-0549: Biaya Akomodasi -> Biaya Perjalanan Dinas
--    Pegawai/Direksi
--  - CO-2610-0024 ('kasbon latif'): Biaya Gaji Pegawai -> Piutang Karyawan
--    (jadi pinjaman karyawan, bukan beban gaji -- diberi relasi PK-Latif)
--
-- 3 transaksi baru diberi relasi langsung, DIVERIFIKASI SILANG terhadap
-- kenaikan baris Data Piutang/Prive sistem asli:
--  - CI-2610-0022 ('latif bayar kasbon', Rp5.000.000) -> PK-Latif -- bersama
--    CO-2610-0024 di atas (10jt pinjaman - 5jt bayar = 5jt sisa, persis sama
--    dengan baris PK-Latif di Data Piutang asli, pelanggan baru hari ini).
--  - CO-2610-0980 ('listrik cilame 2 mbu', Rp27.299.725) -> Pi-MBU -- naik
--    tepat dari -7.895.728 ke 19.403.997.
--  - CO-2610-0921 ('bulanan ade rana', Rp2.250.000) -> Pr-F -- naik tepat
--    sejumlah itu, dan PERSIS sama dengan kenaikan Total Prive hari ini.
--    CO-2610-0924 ('ongkos makanan bu haji', Rp15.000) SENGAJA dibiarkan
--    tanpa relasi meski 'bu haji' biasanya Pr-I -- total kenaikan Data Prive
--    hari ini (Rp2.250.000) sudah pas hanya dari CO-2610-0921 saja, dan Pr-I
--    sendiri tidak berubah sama sekali di Data Prive asli hari ini.
--
-- Jurnal Umum tidak berubah sama sekali (file identik).
--
-- 1 Master Project baru diperlukan: 'Dinas Perikanan' (CO-2610-0996).

-- 90 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('tb31abf307cde', 'bank_keluar', '2026-10-19', 'BO-2610-0021', 'Bank BJB RC PT', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 19 oktober', 0.00, 717521333.00),
  ('t6de1385ea8cc', 'bank_keluar', '2026-10-19', 'BO-2610-0022', 'Bank BCA Cibeureum', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 19 oktober', 0.00, 100009787.00),
  ('t9986a1f8a68b', 'kas_masuk', '2026-10-19', 'CI-2610-0022', 'Kas Besar', 'Piutang Karyawan', 'Cost Center - Pendanaan Uang', 'PK-Latif', 'latif bayar kasbon', 5000000.00, 0.00),
  ('t8e0a08fef6d3', 'kas_masuk', '2026-10-19', 'CI-2610-0023', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 19 oktober', 817531120.00, 0.00),
  ('t80adfd8ee22b', 'kas_keluar', '2026-10-19', 'CO-2610-0912', 'Kas Besar', 'Biaya Panen', 'Farm Cilame 1 periode 5', '', 'rokok kopi panen cilame 1', 0.00, 1446000.00),
  ('tb3392d4b43e7', 'kas_keluar', '2026-10-19', 'CO-2610-0913', 'Kas Besar', 'Biaya Panen', 'Farm Cilame 1 periode 5', '', 'kasbon abk cilame 1', 0.00, 6000000.00),
  ('t021d67d3bee7', 'kas_keluar', '2026-10-19', 'CO-2610-0914', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'ongkir pelet cbr', 0.00, 1500000.00),
  ('tbc192602f3ca', 'kas_keluar', '2026-10-19', 'CO-2610-0915', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Farm Cibeureum periode 6', '', 'listrik cibeureum', 0.00, 21549111.00),
  ('t3b9aadd80d3d', 'kas_keluar', '2026-10-19', 'CO-2610-0916', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Farm Cilame 1 periode 5', '', 'listrik cilame 1', 0.00, 13521255.00),
  ('t6e5e4e1f5d56', 'kas_keluar', '2026-10-19', 'CO-2610-0917', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Farm Cilame 2 periode 6', '', 'listrik cilame 2', 0.00, 27299726.00),
  ('t50b5edd4cb46', 'kas_keluar', '2026-10-19', 'CO-2610-0918', 'Kas Besar', 'Biaya Listrik, Air & Telepon', 'Farm Cibeureum periode 6', '', 'listrik cibeureum tambahan', 0.00, 893970.00),
  ('teade6efab65c', 'kas_keluar', '2026-10-19', 'CO-2610-0919', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'ganti oli', 0.00, 470000.00),
  ('t71cf04787ade', 'kas_keluar', '2026-10-19', 'CO-2610-0920', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, sprite, dll', 0.00, 110000.00),
  ('teb43cf5f3b91', 'kas_keluar', '2026-10-19', 'CO-2610-0921', 'Kas Besar', 'Prive', 'Prive', 'Pr-F', 'bulanan ade rana', 0.00, 2250000.00),
  ('t99d77df8858e', 'kas_keluar', '2026-10-19', 'CO-2610-0922', 'Kas Besar', 'Biaya Telepon', 'Cost Center', '', 'kartu halo pa rajab', 0.00, 142860.00),
  ('t1d660bd6680c', 'kas_keluar', '2026-10-19', 'CO-2610-0923', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'gopay pak zamzam', 0.00, 51000.00),
  ('tafd5d2fd079f', 'kas_keluar', '2026-10-19', 'CO-2610-0924', 'Kas Besar', 'Prive', 'Prive', '', 'ongkos makanan bu haji', 0.00, 15000.00),
  ('t8bacb3c6479d', 'kas_keluar', '2026-10-19', 'CO-2610-0925', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'listrik rmh ibu', 0.00, 178572.00),
  ('tcb99729096fb', 'kas_keluar', '2026-10-19', 'CO-2610-0926', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'listrik gudang ibu (bagi 3)', 0.00, 998355.00),
  ('t6c30946b71ff', 'kas_keluar', '2026-10-19', 'CO-2610-0927', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'listrik rmh ibu', 0.00, 286840.00),
  ('t812e98055564', 'kas_keluar', '2026-10-19', 'CO-2610-0928', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'listrik pangrajangan', 0.00, 480083.00),
  ('tc483fc847de0', 'kas_keluar', '2026-10-19', 'CO-2610-0929', 'Kas Besar', 'Biaya Listrik & Internet', 'Cost Center', '', 'listrik kantor', 0.00, 779473.00),
  ('t6cd9f317d956', 'kas_keluar', '2026-10-19', 'CO-2610-0930', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'korwas PT prakasa purba', 0.00, 20000000.00),
  ('t567d1d24b6b2', 'kas_keluar', '2026-10-19', 'CO-2610-0931', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'korwas PT Restu Ibu', 0.00, 20000000.00),
  ('t66e9f4ab2ca6', 'kas_keluar', '2026-10-19', 'CO-2610-0932', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'kasbon fuji 17/10', 0.00, 20000000.00),
  ('t8f88320cf0cc', 'kas_keluar', '2026-10-19', 'CO-2610-0933', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'kasbon fuji 19/10', 0.00, 30000000.00),
  ('t42f9db514294', 'kas_keluar', '2026-10-19', 'CO-2610-0934', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'cat vinilex', 0.00, 207000.00),
  ('tce1e990533d4', 'kas_keluar', '2026-10-19', 'CO-2610-0935', 'Kas Besar', 'Biaya Akomodasi', 'RS Guntur Belanja Dapur', '', 'sewa mobil 2 bulan', 0.00, 3000000.00),
  ('tda77e275fee8', 'kas_keluar', '2026-10-19', 'CO-2610-0936', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'Belanja tgl 17', 0.00, 5000000.00),
  ('t28556b3f3f58', 'kas_keluar', '2026-10-19', 'CO-2610-0937', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'Belanja tgl 18', 0.00, 3000000.00),
  ('t98e6a4c61fd0', 'kas_keluar', '2026-10-19', 'CO-2610-0938', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'Belanja tgl 19', 0.00, 3300000.00),
  ('te651c2835f13', 'kas_keluar', '2026-10-19', 'CO-2610-0939', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'aspal cibalong 17/10', 0.00, 2400000.00),
  ('t4696ca81f9a8', 'kas_keluar', '2026-10-19', 'CO-2610-0940', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'solar 420 lt, pertalite 35 lt', 0.00, 5547500.00),
  ('t4b72c29067dd', 'kas_keluar', '2026-10-19', 'CO-2610-0941', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'semen 720 sak', 0.00, 42480000.00),
  ('td02b1ad4fab3', 'kas_keluar', '2026-10-19', 'CO-2610-0942', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'babinsa, danpos tuud 7 hari x 400 ribu', 0.00, 2800000.00),
  ('t965400002106', 'kas_keluar', '2026-10-19', 'CO-2610-0943', 'Kas Besar', 'Biaya ADM', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'tambahan babinsa 2, danpos (300x7)', 0.00, 2100000.00),
  ('t83e6a639be06', 'kas_keluar', '2026-10-19', 'CO-2610-0944', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'rutihalu', 0.00, 60000000.00),
  ('t9c7dbd740dde', 'kas_keluar', '2026-10-19', 'CO-2610-0945', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'service mobil', 0.00, 1570000.00),
  ('t77952da8f362', 'kas_keluar', '2026-10-19', 'CO-2610-0946', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'mockup pintu dustira', 0.00, 425000.00),
  ('tcbc3d5bf3c4e', 'kas_keluar', '2026-10-19', 'CO-2610-0947', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'mockup kenanga alumunium', 0.00, 217200.00),
  ('td6111e372a46', 'kas_keluar', '2026-10-19', 'CO-2610-0948', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'semen (18/10)', 0.00, 2330000.00),
  ('tce73fb9c9df9', 'kas_keluar', '2026-10-19', 'CO-2610-0949', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'primafix 5 pile (17/10)', 0.00, 411750.00),
  ('te81075bf5daa', 'kas_keluar', '2026-10-19', 'CO-2610-0950', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'keni, paku, perekat hebel (17/10)', 0.00, 325500.00),
  ('t104c9c769ff2', 'kas_keluar', '2026-10-19', 'CO-2610-0951', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'galvalum, pisau keramik, aquaproof, koas, dll', 0.00, 536000.00),
  ('t32edb5a4154d', 'kas_keluar', '2026-10-19', 'CO-2610-0952', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'reng baja', 0.00, 730000.00),
  ('t582a31ce4610', 'kas_keluar', '2026-10-19', 'CO-2610-0953', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'vibro roller & operator 17/10', 0.00, 1350000.00),
  ('t15f473f91b3e', 'kas_keluar', '2026-10-19', 'CO-2610-0954', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'ritase & uang lintas, insentif tekisi 17/10', 0.00, 1300000.00),
  ('t1467d714e4cf', 'kas_keluar', '2026-10-19', 'CO-2610-0955', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'canal c, H 4x6, sarung tangan 18/10', 0.00, 1580000.00),
  ('t3f1eebea41a5', 'kas_keluar', '2026-10-19', 'CO-2610-0956', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'BP listrik 20 unit + SLO', 0.00, 39918000.00),
  ('tf71351e94df1', 'kas_keluar', '2026-10-19', 'CO-2610-0957', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'BP pln daya 2200va +SLO', 0.00, 3222200.00),
  ('tbce6c29dd005', 'kas_keluar', '2026-10-19', 'CO-2610-0958', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cilame 1 periode 5', '', 'kasbon somad', 0.00, 500000.00),
  ('t50cdce50f5e5', 'kas_keluar', '2026-10-19', 'CO-2610-0959', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'perekat hebel, paku (17/10)', 0.00, 852500.00),
  ('tf8f62b24a8c2', 'kas_keluar', '2026-10-19', 'CO-2610-0960', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'scrap pvc', 0.00, 55000.00),
  ('t29e8ddfc3f93', 'kas_keluar', '2026-10-19', 'CO-2610-0961', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'materai kwh rumdis 17/10', 0.00, 361000.00),
  ('t009e22405d86', 'kas_keluar', '2026-10-19', 'CO-2610-0962', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'big nym 2x1,5 (18/10)', 0.00, 655000.00),
  ('t58f0d4f38f5a', 'kas_keluar', '2026-10-19', 'CO-2610-0963', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'genteng morando 550pcs', 0.00, 1897500.00),
  ('t5f4b3cfe8887', 'kas_keluar', '2026-10-19', 'CO-2610-0964', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'bahan kusen (inkalum, engsel, dsb)', 0.00, 74092000.00),
  ('t817b1ed30fee', 'kas_keluar', '2026-10-19', 'CO-2610-0965', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'DP beton subang', 0.00, 57600000.00),
  ('t6a157504c3d9', 'kas_keluar', '2026-10-19', 'CO-2610-0966', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'upah pemasangan uditch subang', 0.00, 12338500.00),
  ('t887f5f0078e1', 'kas_keluar', '2026-10-19', 'CO-2610-0967', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'silent', 0.00, 1502500.00),
  ('t8c419ac49543', 'kas_keluar', '2026-10-19', 'CO-2610-0968', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'pembatas jembatan', 0.00, 6002500.00),
  ('t43276814776b', 'kas_keluar', '2026-10-19', 'CO-2610-0969', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'PUPR', 0.00, 4000000.00),
  ('td01cb9def26c', 'kas_keluar', '2026-10-19', 'CO-2610-0970', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'harian flagman', 0.00, 5602500.00),
  ('t03c569db2ea7', 'kas_keluar', '2026-10-19', 'CO-2610-0971', 'Kas Besar', 'Biaya Bahan', 'BJB Rehab Rumdis Subang', '', 'DP pekerjaan bjb subang (17/10)', 0.00, 1175000.00),
  ('t92478e7a5567', 'kas_keluar', '2026-10-19', 'CO-2610-0972', 'Kas Besar', 'Biaya ADM', 'BJB Pangandaran', '', 'vian me pangandaran', 0.00, 3000000.00),
  ('t3392d3631fc0', 'kas_keluar', '2026-10-19', 'CO-2610-0973', 'Kas Besar', 'Biaya Bahan', 'BJB Rehab Rumdis Subang', '', 'pelunasan pek perbaikan air 18/10', 0.00, 1225000.00),
  ('t7a3636f05a6b', 'kas_keluar', '2026-10-19', 'CO-2610-0974', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kaca', 0.00, 249000.00),
  ('t100cb5f9cbd2', 'kas_keluar', '2026-10-19', 'CO-2610-0975', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'slang flexibel', 0.00, 68500.00),
  ('t29b1cf7239ea', 'kas_keluar', '2026-10-19', 'CO-2610-0976', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'bayaran pekerja 12 - 16 okt', 0.00, 19375000.00),
  ('t1f775c82f860', 'kas_keluar', '2026-10-19', 'CO-2610-0977', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pasir 5 dt', 0.00, 12000000.00),
  ('t5925f6d8ab9c', 'kas_keluar', '2026-10-19', 'CO-2610-0978', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kempu 2 bh 18/10', 0.00, 2400000.00),
  ('t3f02ce847243', 'kas_keluar', '2026-10-19', 'CO-2610-0979', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'ember, sepatu', 0.00, 148500.00),
  ('t80c4a753e4b4', 'kas_keluar', '2026-10-19', 'CO-2610-0980', 'Kas Besar', 'Piutang Usaha', 'Farm Cilame 2 periode 6', 'Pi-MBU', 'listrik cilame 2 mbu', 0.00, 27299725.00),
  ('td7800554b9f5', 'kas_keluar', '2026-10-19', 'CO-2610-0981', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'gypsum, skrup', 0.00, 3386500.00),
  ('td29a3541f4c8', 'kas_keluar', '2026-10-19', 'CO-2610-0982', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'semen', 0.00, 9200000.00),
  ('t717e5db324be', 'kas_keluar', '2026-10-19', 'CO-2610-0983', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'selang', 0.00, 835000.00),
  ('t5c01b4f8cefe', 'kas_keluar', '2026-10-19', 'CO-2610-0984', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'sepatu, paku, dll', 0.00, 476000.00),
  ('t15d1fe3fecae', 'kas_keluar', '2026-10-19', 'CO-2610-0985', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'p3k', 0.00, 61000.00),
  ('ta3e44902ff13', 'kas_keluar', '2026-10-19', 'CO-2610-0986', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'plastik sampah', 0.00, 70000.00),
  ('t89e874e56c7a', 'kas_keluar', '2026-10-19', 'CO-2610-0987', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'oli jack hammer', 0.00, 89000.00),
  ('t0dfbc0ea6e1e', 'kas_keluar', '2026-10-19', 'CO-2610-0988', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'ram kawat, roskam, dll', 0.00, 957500.00),
  ('t315d94e2c422', 'kas_keluar', '2026-10-19', 'CO-2610-0989', 'Kas Besar', 'Biaya ADM', 'KODAM IV', '', 'adm', 0.00, 50000000.00),
  ('t0c6e4a5c79c7', 'kas_keluar', '2026-10-19', 'CO-2610-0990', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'ongkos bdg - pangandaran', 0.00, 500000.00),
  ('t53eef74ec5ad', 'kas_keluar', '2026-10-19', 'CO-2610-0991', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'pasir pasang 2 rit', 0.00, 3750000.00),
  ('tb2af8c142cea', 'kas_keluar', '2026-10-19', 'CO-2610-0992', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'matrial TB, subur (nota 12-17 okt)', 0.00, 42054000.00),
  ('t4c29e4abaed5', 'kas_keluar', '2026-10-19', 'CO-2610-0993', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'air damkar (17/10)', 0.00, 250000.00),
  ('t49ba55a8fbe1', 'kas_keluar', '2026-10-19', 'CO-2610-0994', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'granit 100 pcs', 0.00, 12740000.00),
  ('t19f302755c14', 'kas_keluar', '2026-10-19', 'CO-2610-0995', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'genteng morando 200 pcs', 0.00, 690000.00),
  ('t1a8ce3ea95dd', 'kas_keluar', '2026-10-19', 'CO-2610-0996', 'Kas Besar', 'Biaya Bahan', 'Dinas Perikanan', '', 'perikanan', 0.00, 13350000.00),
  ('te00ef159112e', 'kas_keluar', '2026-10-19', 'CO-2610-0997', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'DP beton subang', 0.00, 100000000.00);

-- 3 penyesuaian pada transaksi yang sudah ada
UPDATE `transactions` SET `akun_lawan` = 'Biaya Perjalanan Dinas Pegawai' WHERE `ref` = 'CO-2609-1064';
UPDATE `transactions` SET `akun_lawan` = 'Piutang Karyawan', `relasi` = 'PK-Latif' WHERE `ref` = 'CO-2610-0024';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Perjalanan Dinas Direksi' WHERE `ref` = 'CO-2610-0549';

-- Project baru yang direferensikan transaksi 19 Oktober, belum ada di Master Project
INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_dinas_perikanan', 'Dinas Perikanan', 'Dinas Perikanan', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW());
