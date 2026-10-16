-- Sinkronisasi dari Report export terbaru (16 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup semua
-- file sync sebelumnya s/d sync_jurnal_okt12_tambahan.sql.
--
-- Ditemukan 129 transaksi baru, 3 penyesuaian akun_lawan
-- (Biaya Upah2 -> Biaya Upah, reklasifikasi murni), dan 1 transaksi yang
-- sudah TIDAK ADA lagi di Report (CO-2610-0698, 'kas arya' Rp1.000.000 --
-- dihapus/dibatalkan di sistem asli, jadi ikut dihapus di sini).
--
-- 10 transaksi baru diberi relasi langsung di sini, DIVERIFIKASI SILANG
-- terhadap kenaikan baris Data Prive/Hutang sistem asli:
--  - 9 Prive (CO-2610-0811/812/813/814/815/816/848/849/850) -> Pr-Z/Pr-K/
--    Pr-R, totalnya naik tepat 25.265.000 (Pr-Z) / 29.270.000 (Pr-K) /
--    25.105.000 (Pr-R) -- persis sama dengan kenaikan Data Prive asli.
--    (CO-2610-0837 'Bu rinrin 25%' SENGAJA dibiarkan tanpa relasi --
--    pola yang sama dengan entri bagi-hasil/pooled lain yang sudah ada,
--    karena 3 kenaikan di atas saja sudah pas menutup total kenaikan
--    Data Prive tanpa entri ini.)
--  - CO-2610-0911 (penarikan 75% dari belanja dapur, cicilan leasing) ->
--    HPK-TAF, turun tepat 36.671.063 (333.017.670 -> 296.346.607).
--
-- Data Piutang tidak berubah sama sekali hari ini. Jurnal Umum juga tidak
-- berubah (file identik, sudah termasuk JU26100128 dari sync sebelumnya).
--
-- 1 Master Project yang direferensikan ('Kodim Purwakarta') ternyata sama
-- dengan 'Kodim Kab Purwakarta' yang sudah ada -- diberi ledger_name,
-- bukan dibuat project baru/duplikat.

-- 129 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t693b8d8c0ca4', 'bank_keluar', '2026-10-16', 'BO-2610-0018', 'Bank BCA Cilame1', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan pelet kayu clm1', 0.00, 16000000.00),
  ('t3b6b7191b178', 'bank_keluar', '2026-10-16', 'BO-2610-0019', 'Bank BCA Cibeureum', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan pengeluaran kandang 16 okt', 0.00, 132644864.00),
  ('tc337171e1419', 'bank_keluar', '2026-10-16', 'BO-2610-0020', 'Bank BJB RC PT', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 16 oktober', 0.00, 1903919904.00),
  ('td16539ead361', 'kas_masuk', '2026-10-16', 'CI-2610-0019', 'Kas Besar', 'Pendapatan Pengadaan', 'RS Guntur Belanja Dapur', '', 'Uang Mamin pasien 16 ags -30 sep', 282660669.00, 0.00),
  ('t61f76b922252', 'kas_masuk', '2026-10-16', 'CI-2610-0020', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan uang kandang 16 okt', 148644864.00, 0.00),
  ('td675a50ec6c0', 'kas_masuk', '2026-10-16', 'CI-2610-0021', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 16 oktober', 1903919904.00, 0.00),
  ('t1da8db970999', 'kas_keluar', '2026-10-16', 'CO-2610-0789', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin gupron 15/10', 0.00, 50000.00),
  ('td89916d68173', 'kas_keluar', '2026-10-16', 'CO-2610-0790', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'perbaikan bumper depan', 0.00, 150000.00),
  ('t0e9a49f13a7b', 'kas_keluar', '2026-10-16', 'CO-2610-0791', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'solar inova', 0.00, 210868.00),
  ('tcbe14e6fd15b', 'kas_keluar', '2026-10-16', 'CO-2610-0792', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'emoney inova hitam', 0.00, 500000.00),
  ('taa8223458fe4', 'kas_keluar', '2026-10-16', 'CO-2610-0793', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'steam', 0.00, 50000.00),
  ('t778ab2a06366', 'kas_keluar', '2026-10-16', 'CO-2610-0794', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya firecash', 0.00, 35000.00),
  ('t55f17d37e3cf', 'kas_keluar', '2026-10-16', 'CO-2610-0795', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'tisu', 0.00, 22000.00),
  ('t55fe27dfd4bc', 'kas_keluar', '2026-10-16', 'CO-2610-0796', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat pak rajab', 0.00, 55083.00),
  ('t61bf027ce86c', 'kas_keluar', '2026-10-16', 'CO-2610-0797', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM mega periode 1-15 okt', 0.00, 250000.00),
  ('t6a35a3e87204', 'kas_keluar', '2026-10-16', 'CO-2610-0798', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM zihan', 0.00, 275000.00),
  ('t9915b2d7d2b2', 'kas_keluar', '2026-10-16', 'CO-2610-0799', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM gupron', 0.00, 150000.00),
  ('t6a3dfa82f680', 'kas_keluar', '2026-10-16', 'CO-2610-0800', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM yuki', 0.00, 350000.00),
  ('t85048f1c78d4', 'kas_keluar', '2026-10-16', 'CO-2610-0801', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM eri', 0.00, 200000.00),
  ('t456f2b2f10bc', 'kas_keluar', '2026-10-16', 'CO-2610-0802', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM andri', 0.00, 50000.00),
  ('teb3cd1940083', 'kas_keluar', '2026-10-16', 'CO-2610-0803', 'Kas Besar', 'Biaya Akomodasi', 'RS Guntur Gudang Farmasi', '', 'UM asep (rumkit guntur)', 0.00, 490000.00),
  ('t699ea2b95afc', 'kas_keluar', '2026-10-16', 'CO-2610-0804', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'UM arya (5 hari dustira, 5 cimahi, 5 antapani)', 0.00, 375000.00),
  ('t92f4a666b5aa', 'kas_keluar', '2026-10-16', 'CO-2610-0805', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'UM fikri (dustira)', 0.00, 975000.00),
  ('tde81105b2a3b', 'kas_keluar', '2026-10-16', 'CO-2610-0806', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'UM dicky (dustira)', 0.00, 975000.00),
  ('t6637a88b24e3', 'kas_keluar', '2026-10-16', 'CO-2610-0807', 'Kas Besar', 'Biaya Akomodasi', 'PUPR Bangun Satpol PP Sumedang', '', 'UM latif (sumedang)', 0.00, 450000.00),
  ('teb35aa44e96a', 'kas_keluar', '2026-10-16', 'CO-2610-0808', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'UM dadan (cibalong)', 0.00, 1125000.00),
  ('tcc13cbee8b42', 'kas_keluar', '2026-10-16', 'CO-2610-0809', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM hamdan (bogor)', 0.00, 1125000.00),
  ('tfacd133b45dd', 'kas_keluar', '2026-10-16', 'CO-2610-0810', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'komeng 9-15 okt', 0.00, 1038000.00),
  ('t6e37dc91f4e9', 'kas_keluar', '2026-10-16', 'CO-2610-0811', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'bita cash (jajan 2x), pak zamzam', 0.00, 200000.00),
  ('t2fa9b392e35a', 'kas_keluar', '2026-10-16', 'CO-2610-0812', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'pak karli', 0.00, 2599000.00),
  ('tfc8919e290ad', 'kas_keluar', '2026-10-16', 'CO-2610-0813', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'pak zamzam (makanan kucing)', 0.00, 65000.00),
  ('t0bd77176847a', 'kas_keluar', '2026-10-16', 'CO-2610-0814', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'pak rajab (abon)', 0.00, 60000.00),
  ('t581c71d33743', 'kas_keluar', '2026-10-16', 'CO-2610-0815', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'pak rajab (nasi tim)', 0.00, 45000.00),
  ('t56c1e7cabb8d', 'kas_keluar', '2026-10-16', 'CO-2610-0816', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'bah yayat (pa karli)', 0.00, 1671000.00),
  ('t1b5975b0d2c9', 'kas_keluar', '2026-10-16', 'CO-2610-0817', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 1 periode 5', '', 'solar panther cilame 1 (nota 14 sept-15 okt)', 0.00, 710000.00),
  ('tfeea1e06b564', 'kas_keluar', '2026-10-16', 'CO-2610-0818', 'Kas Besar', 'Biaya Operasional', 'Farm Cibeureum periode 6', '', 'reimburse pak jat cbr (pulsa, pembersih pane, servis scoopyl, wd cut)', 0.00, 422500.00),
  ('t290fc4f158a8', 'kas_keluar', '2026-10-16', 'CO-2610-0819', 'Kas Besar', 'Biaya Cuci Kandang', 'Farm Cibeureum periode 6', '', 'reimburse pak jat cbr (cuci kandang)', 0.00, 504000.00),
  ('tc013e3145834', 'kas_keluar', '2026-10-16', 'CO-2610-0820', 'Kas Besar', 'Biaya Cuci Kandang', 'Farm Cilame 2 periode 6', '', 'reimburse pak jat clm 2 (cuci kandang)', 0.00, 192000.00),
  ('t9714e8393f10', 'kas_keluar', '2026-10-16', 'CO-2610-0821', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 2 periode 6', '', 'reimburse pak jat cilame 2 (solar genset)', 0.00, 790364.00),
  ('tb22522fbcbc1', 'kas_keluar', '2026-10-16', 'CO-2610-0822', 'Kas Besar', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', 'gas kdg cibeureum 26 tabung', 0.00, 26406000.00),
  ('t411c9e21cc7b', 'kas_keluar', '2026-10-16', 'CO-2610-0823', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cilame 2 periode 5', '', 'gas kdg clm 2, 28 tabung', 0.00, 28620000.00),
  ('t2b606e4f7383', 'kas_keluar', '2026-10-16', 'CO-2610-0824', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'jaminan Uang muka', 0.00, 12740000.00),
  ('t0f12334c24d0', 'kas_keluar', '2026-10-16', 'CO-2610-0825', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'Jaminan pelaksanaan', 0.00, 3500000.00),
  ('tfbb1634fd3c5', 'kas_keluar', '2026-10-16', 'CO-2610-0826', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'bahan nota MM', 0.00, 110835000.00),
  ('t7abd135e0e74', 'kas_keluar', '2026-10-16', 'CO-2610-0827', 'Kas Besar', 'Biaya Upah', 'RS Guntur Gudang Farmasi', '', 'h dana', 0.00, 20000000.00),
  ('t62498cd6ce33', 'kas_keluar', '2026-10-16', 'CO-2610-0828', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'KNMP Donggala', '', 'tiket pulang donggala', 0.00, 12362659.00),
  ('td6d00100a411', 'kas_keluar', '2026-10-16', 'CO-2610-0829', 'Kas Besar', 'Biaya Upah', 'KNMP Donggala', '', 'donggala', 0.00, 500000000.00),
  ('tfa74e5d98f0e', 'kas_keluar', '2026-10-16', 'CO-2610-0830', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'cat 1 pail', 0.00, 711000.00),
  ('t1188e92fd1fa', 'kas_keluar', '2026-10-16', 'CO-2610-0831', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'granit', 0.00, 360000.00),
  ('t6be3ae941c0c', 'kas_keluar', '2026-10-16', 'CO-2610-0832', 'Kas Besar', 'Biaya ADM', 'Zidam Rehab Gudkesrah', '', 'jamhar', 0.00, 3500000.00),
  ('t5102353092db', 'kas_keluar', '2026-10-16', 'CO-2610-0833', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Gudkesrah', '', 'h dana', 0.00, 27500000.00),
  ('tc439a6e12826', 'kas_keluar', '2026-10-16', 'CO-2610-0834', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 16', 0.00, 9500000.00),
  ('t2a0299189052', 'kas_keluar', '2026-10-16', 'CO-2610-0835', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'kekurangan beli piring dan mangkok', 0.00, 867960.00),
  ('teecadd96e3c8', 'kas_keluar', '2026-10-16', 'CO-2610-0836', 'Kas Besar', 'Biaya ADM', 'RS Guntur Belanja Dapur', '', 'ADM (2 bulan)', 0.00, 65084938.00),
  ('t4efea3fb08aa', 'kas_keluar', '2026-10-16', 'CO-2610-0837', 'Kas Besar', 'Prive', 'RS Guntur Belanja Dapur', '', '25% (Bu rinrin)', 0.00, 12223688.00),
  ('tbc7d5eb33a80', 'kas_keluar', '2026-10-16', 'CO-2610-0838', 'Kas Besar', 'Biaya ADM', 'RS Guntur Belanja Dapur', '', 'adm pencairan 2 bulan', 0.00, 2800000.00),
  ('tb9e02e58eb0f', 'kas_keluar', '2026-10-16', 'CO-2610-0839', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'operator beko 9-15 okt', 0.00, 2090000.00),
  ('t4b30e239a40d', 'kas_keluar', '2026-10-16', 'CO-2610-0840', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'operator mixer 9-15 okt', 0.00, 1970000.00),
  ('t521967f9f8fa', 'kas_keluar', '2026-10-16', 'CO-2610-0841', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim jaga alat 9-15 okt', 0.00, 1400000.00),
  ('t53624f7d6034', 'kas_keluar', '2026-10-16', 'CO-2610-0842', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim cihelang 9-15 okt', 0.00, 6600000.00),
  ('t865626bf94fb', 'kas_keluar', '2026-10-16', 'CO-2610-0843', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim garut 9-15 okt', 0.00, 10867000.00),
  ('te2603829ec24', 'kas_keluar', '2026-10-16', 'CO-2610-0844', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (ganti ban dumptruk, ban panter)', 0.00, 260000.00),
  ('tc8880d51ffe5', 'kas_keluar', '2026-10-16', 'CO-2610-0845', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (oli mesin)', 0.00, 720000.00),
  ('t35ae1cd47b60', 'kas_keluar', '2026-10-16', 'CO-2610-0846', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (token kontrakan, gas melon)', 0.00, 159000.00),
  ('t61214e75f592', 'kas_keluar', '2026-10-16', 'CO-2610-0847', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cilame 1 periode 5', '', 'pelet cilame 1', 0.00, 16000000.00),
  ('t3b68a4f60ad2', 'kas_keluar', '2026-10-16', 'CO-2610-0848', 'Kas Besar', 'Prive', 'Farm Cibeureum periode 5', 'Pr-R', 'bagi hasil cibeureum, pa rajab', 0.00, 25000000.00),
  ('t8e8a3a4a4e5d', 'kas_keluar', '2026-10-16', 'CO-2610-0849', 'Kas Besar', 'Prive', 'Farm Cibeureum periode 5', 'Pr-Z', 'bagi hasil cibeureum, pa zamzam', 0.00, 25000000.00),
  ('t849de9142333', 'kas_keluar', '2026-10-16', 'CO-2610-0850', 'Kas Besar', 'Prive', 'Farm Cibeureum periode 5', 'Pr-K', 'bagi hasil cibeureum, pa karli', 0.00, 25000000.00),
  ('ta889bbd7ab66', 'kas_keluar', '2026-10-16', 'CO-2610-0851', 'Kas Besar', 'Biaya Upah', 'Kodim Purwakarta', '', 'DP kodim purwakarta', 0.00, 55461821.00),
  ('t34079d824245', 'kas_keluar', '2026-10-16', 'CO-2610-0852', 'Kas Besar', 'Biaya Upah', 'Kodim Subang', '', 'DP kodim subang', 0.00, 55461821.00),
  ('t7bda8a17e5b6', 'kas_keluar', '2026-10-16', 'CO-2610-0853', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (mamin lembur, galon)', 0.00, 900000.00),
  ('tced81905cc8d', 'kas_keluar', '2026-10-16', 'CO-2610-0854', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim urugan 2 minggu 2-15 okt', 0.00, 8100000.00),
  ('t25c5eca1e7c3', 'kas_keluar', '2026-10-16', 'CO-2610-0855', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'pasir cor 9-15 okt', 0.00, 79292000.00),
  ('t9e91f7b46f30', 'kas_keluar', '2026-10-16', 'CO-2610-0856', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'pipa pvs, lisplang', 0.00, 4100600.00),
  ('tf571e646f064', 'kas_keluar', '2026-10-16', 'CO-2610-0857', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname granit lantai wc', 0.00, 347820.00),
  ('tb7b2aaa53ac9', 'kas_keluar', '2026-10-16', 'CO-2610-0858', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname granit lantai', 0.00, 514090.00),
  ('tb063f3e640c3', 'kas_keluar', '2026-10-16', 'CO-2610-0859', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname granit dinding wc', 0.00, 404550.00),
  ('tee80832f1a6f', 'kas_keluar', '2026-10-16', 'CO-2610-0860', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname pasangan kloset duduk', 0.00, 1400000.00),
  ('t8080cb7853a9', 'kas_keluar', '2026-10-16', 'CO-2610-0861', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname pasangan keran', 0.00, 70000.00),
  ('tcc6653b1fc84', 'kas_keluar', '2026-10-16', 'CO-2610-0862', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'opname atapp', 0.00, 1072140.00),
  ('t16ba38677494', 'kas_keluar', '2026-10-16', 'CO-2610-0863', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang barangkal', 0.00, 2700000.00),
  ('t83fcb2406bf3', 'kas_keluar', '2026-10-16', 'CO-2610-0864', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon tim listrik pak nanang', 0.00, 2000000.00),
  ('t3260843171e3', 'kas_keluar', '2026-10-16', 'CO-2610-0865', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon tim cat usep', 0.00, 5000000.00),
  ('tcb07c73a1edc', 'kas_keluar', '2026-10-16', 'CO-2610-0866', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon tim agus alumunium', 0.00, 10000000.00),
  ('t163438a60ebf', 'kas_keluar', '2026-10-16', 'CO-2610-0867', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'bayaran pekerja 9 - 15 okt', 0.00, 27661000.00),
  ('t8b47db19a60f', 'kas_keluar', '2026-10-16', 'CO-2610-0868', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', 'wasrik', 0.00, 6200000.00),
  ('t1c06e0fd0177', 'kas_keluar', '2026-10-16', 'CO-2610-0869', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'ongkos penambahan kerja', 0.00, 500000.00),
  ('td0ac92a3e37e', 'kas_keluar', '2026-10-16', 'CO-2610-0870', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'paving kenanga', 0.00, 5903333.00),
  ('tc2f1e2319d75', 'kas_keluar', '2026-10-16', 'CO-2610-0871', 'Kas Besar', 'Biaya Upah', 'Proyek Antapani', '', 'bayaran pekerja 9-15 okt', 0.00, 3076000.00),
  ('t374e389cb506', 'kas_keluar', '2026-10-16', 'CO-2610-0872', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Proyek Antapani', '', 'op. yuki tangguh andri 15/10', 0.00, 675000.00),
  ('tfabb5b3f8d96', 'kas_keluar', '2026-10-16', 'CO-2610-0873', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', 'UM arya (5 hari dustira, 5 cimahi, 5 antapani)', 0.00, 375000.00),
  ('te09f07bde4a4', 'kas_keluar', '2026-10-16', 'CO-2610-0874', 'Kas Besar', 'Biaya Akomodasi', 'Proyek Antapani', '', 'UM arya (5 hari dustira, 5 cimahi, 5 antapani)', 0.00, 375000.00),
  ('t477b69413e06', 'kas_keluar', '2026-10-16', 'CO-2610-0875', 'Kas Besar', 'Biaya Upah', 'Zidam Rumdis Zipur', '', 'kasbon upah bahan ke 2 50%', 0.00, 299883784.00),
  ('tb801f4eb7800', 'kas_keluar', '2026-10-16', 'CO-2610-0876', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'biaya trf bahan', 0.00, 2500.00),
  ('t60e3e23ecfc3', 'kas_keluar', '2026-10-16', 'CO-2610-0877', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', 'opname kopel 1-5', 0.00, 52707300.00),
  ('t7ba180a27525', 'kas_keluar', '2026-10-16', 'CO-2610-0878', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'kasbon tim cat dani', 0.00, 6000000.00),
  ('tea149a30ffd2', 'kas_keluar', '2026-10-16', 'CO-2610-0879', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'listplang 15 lbr', 0.00, 825000.00),
  ('t46547b4352e0', 'kas_keluar', '2026-10-16', 'CO-2610-0880', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'reimburse bayu (bensin)', 0.00, 50000.00),
  ('t269b13d32db6', 'kas_keluar', '2026-10-16', 'CO-2610-0881', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'kasbon pak nanang', 0.00, 4000000.00),
  ('t6368d95b7315', 'kas_keluar', '2026-10-16', 'CO-2610-0882', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'Semen 200 sak', 0.00, 9000000.00),
  ('t95bb3757b4f8', 'kas_keluar', '2026-10-16', 'CO-2610-0883', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pasang listrik', 0.00, 24942000.00),
  ('taa1defa2c7a9', 'kas_keluar', '2026-10-16', 'CO-2610-0884', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon borongan granit', 0.00, 2000000.00),
  ('td8f65f3e8b33', 'kas_keluar', '2026-10-16', 'CO-2610-0885', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'bayaran pekerja 9-15 okt', 0.00, 33745500.00),
  ('tca2e3826526c', 'kas_keluar', '2026-10-16', 'CO-2610-0886', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon egi', 0.00, 20000000.00),
  ('t1944737d6742', 'kas_keluar', '2026-10-16', 'CO-2610-0887', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'kasbon pek jalan dan uditch subang', 0.00, 10000000.00),
  ('t9d2672b48cf1', 'kas_keluar', '2026-10-16', 'CO-2610-0888', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'sewa mobil langsir tanah cimahi', 0.00, 2000000.00),
  ('t6511da27cc1e', 'kas_keluar', '2026-10-16', 'CO-2610-0889', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'mob vibro subang', 0.00, 2000000.00),
  ('t0eb4038d9919', 'kas_keluar', '2026-10-16', 'CO-2610-0890', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'pancang jembatan', 0.00, 26640000.00),
  ('tafbd7c0e1924', 'kas_keluar', '2026-10-16', 'CO-2610-0891', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'Bahan base coarse, batu pondasi, splite', 0.00, 9340000.00),
  ('t9a1c86054330', 'kas_keluar', '2026-10-16', 'CO-2610-0892', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan pengamanan', 0.00, 3500000.00),
  ('t7ea26cb5270a', 'kas_keluar', '2026-10-16', 'CO-2610-0893', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'perpanjangan sewa kompresor, bambu, flagman', 0.00, 1065000.00),
  ('t94e4435614fb', 'kas_keluar', '2026-10-16', 'CO-2610-0894', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'konsumsi demo', 0.00, 500000.00),
  ('tf18235bb44a9', 'kas_keluar', '2026-10-16', 'CO-2610-0895', 'Kas Besar', 'Biaya Upah', 'Bina Marga Rehab Jembatan Provinsi', '', 'kasbon upah aseo/yudi', 0.00, 15000000.00),
  ('t7c9fa4e2669d', 'kas_keluar', '2026-10-16', 'CO-2610-0896', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan pengamanan zipur', 0.00, 1500000.00),
  ('t6dbeeb9d195c', 'kas_keluar', '2026-10-16', 'CO-2610-0897', 'Kas Besar', 'Biaya ADM', 'BJB', '', 'adm 2% D', 0.00, 135200000.00),
  ('t6333dd54cad7', 'kas_keluar', '2026-10-16', 'CO-2610-0898', 'Kas Besar', 'Biaya entertain', 'BJB', '', 'duren pak sony + ongkir', 0.00, 1000500.00),
  ('t2afbd4667c3e', 'kas_keluar', '2026-10-16', 'CO-2610-0899', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', 'penarikan 10% (progress 30%)', 0.00, 69352252.00),
  ('t4d39e03c51cd', 'kas_keluar', '2026-10-16', 'CO-2610-0900', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (bensin)', 0.00, 100000.00),
  ('tac0ec99a191d', 'kas_keluar', '2026-10-16', 'CO-2610-0901', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (lalamove kunci, cat)', 0.00, 61000.00),
  ('te668c48d661f', 'kas_keluar', '2026-10-16', 'CO-2610-0902', 'Kas Besar', 'Biaya Upah2', 'Kemhan 2 Gudang Selatan', '', 'reimburse ilham (galon)', 0.00, 112000.00),
  ('t78370cdc1f5a', 'kas_keluar', '2026-10-16', 'CO-2610-0903', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'Opname pekerjaan pagar sementara', 0.00, 9950200.00),
  ('tde31052195d1', 'kas_keluar', '2026-10-16', 'CO-2610-0904', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan 2 Gudang Selatan', '', 'kekurangan op. yuki gudang utara (7-8 okt)', 0.00, 306500.00),
  ('t0df024f3ccf8', 'kas_keluar', '2026-10-16', 'CO-2610-0905', 'Kas Besar', 'Biaya Upah2', 'PUPR Bangun Satpol PP Sumedang', '', 'pembayaran  upah pasang atap alumunium foil', 0.00, 7800000.00),
  ('t1c73d3b07dac', 'kas_keluar', '2026-10-16', 'CO-2610-0906', 'Kas Besar', 'Biaya Upah', 'PUPR Bangun Satpol PP Sumedang', '', 'h dana', 0.00, 70000000.00),
  ('t91f939e63d29', 'kas_keluar', '2026-10-16', 'CO-2610-0907', 'Kas Besar', 'Biaya Upah', 'RS Cirebon', '', 'putra', 0.00, 35000000.00),
  ('taa148356f23b', 'kas_keluar', '2026-10-16', 'CO-2610-0908', 'Kas Besar', 'Biaya Upah', 'Zidam Renov Rumdis Bogor', '', 'penarikan 10% ke 4 (sudah kasbon 5jt)', 0.00, 106143603.00),
  ('tf7c40ac34d15', 'kas_keluar', '2026-10-16', 'CO-2610-0909', 'Kas Besar', 'Biaya Upah', 'Kodim Majalengka', '', 'upah', 0.00, 50000000.00),
  ('t4786f8619198', 'kas_keluar', '2026-10-16', 'CO-2610-0910', 'Kas Besar', 'Biaya Bahan', 'Kodim Majalengka', '', 'bahan', 0.00, 50000000.00),
  ('tc29a308249b7', 'kas_keluar', '2026-10-16', 'CO-2610-0911', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', 'HPK-TAF', 'penarikan 75% dari belanja dapur (untuk cicilan leasing)', 0.00, 36671063.00);

-- 3 penyesuaian pada transaksi yang sudah ada
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2609-0678';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2610-0274';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2610-0710';

-- 1 transaksi yang sudah tidak ada di Report (dihapus/dibatalkan di sistem asli)
DELETE FROM `transactions` WHERE `ref` = 'CO-2610-0698';

-- 'Kodim Purwakarta' adalah nama lain dari 'Kodim Kab Purwakarta' yang sudah ada
UPDATE `projects` SET `ledger_name` = 'Kodim Purwakarta' WHERE `nama` = 'Kodim Kab Purwakarta';
