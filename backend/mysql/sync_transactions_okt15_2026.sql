-- Sinkronisasi dari Report export terbaru (15 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup semua
-- file sync sebelumnya s/d fix_relasi_piutang_prive_lama.sql dan
-- fix_relasi_prive_okt13_2026.sql (PENTING: jalankan file ini SETELAH
-- fix_relasi_prive_okt13_2026.sql sudah dijalankan, kalau belum).
--
-- Ditemukan 80 transaksi baru dan 7 penyesuaian pada
-- transaksi lama:
--  - 3 pasangan split (servis dinamo 2jt, bubut puly 1.350.000, service
--    dinamo 1,8jt -- masing-masing dibagi 2 lokasi, Cibeureum & Cilame 1,
--    jumlahnya sudah dicek pas dengan nilai aslinya)
--  - 2 entri kloset yang realokasi antar nota (CO-2610-0443 <-> 0540,
--    nilainya saling menutupi persis 1.680.200)
--  - CO-2610-0506 (upah asep/yudi) dikoreksi 24.100.000 -> 20.000.000,
--    tidak ditemukan pasangannya di transaksi lain -- report dianggap benar
--  - CO-2610-0708 (Genteng) reklasifikasi project
--
-- 11 transaksi baru diberi relasi langsung di sini (bukan lewat file fix
-- terpisah) -- semuanya DIVERIFIKASI SILANG terhadap kenaikan baris Data
-- Hutang/Piutang/Prive sistem asli (bukan tebakan dari teks saja):
--  - 3 Prive (CO-2610-0730/731/776) -> Pr-R/Pr-Z/Pr-F, naik tepat
--    1.000.000 / 32.000 / 10.002.500
--  - CO-2610-0717 (KUR an yusri) -> HPK-Yusri, naik tepat 12.537.037
--  - CO-2610-0729 (pinjaman asun) -> Pi-Asun, naik tepat 6.000.000
--  - 7 pembayaran Hutang Dagang (CO-2610-0736/737/747/748/770/786/787,
--    semua nota dari V-HU-Berkat) -> V-HU-Berkat, totalnya
--    17.989.215+49.955.700+11.805.960+32.629.500+13.320.000+21.389.700+
--    821.400 = 147.911.475, turun tepat sejumlah itu dari saldo
--    V-HU-Berkat (371.036.879 -> 223.125.404).
--
-- Jurnal Umum tidak berubah sama sekali (file identik dengan export
-- sebelumnya). Tidak ada Master Project baru yang diperlukan.

-- 80 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t3fb801fcbd46', 'bank_keluar', '2026-10-15', 'BO-2610-0017', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 15 oktober', 0.00, 233179492.00),
  ('t6fd092422363', 'kas_masuk', '2026-10-15', 'CI-2610-0017', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 15 oktober', 233179492.00, 0.00),
  ('tac1ec29f267a', 'kas_masuk', '2026-10-15', 'CI-2610-0018', 'Kas Besar', 'Pendapatan Proyek', 'Zidam Rumdis Zipur', '', 'termin ke 2 zipur', 138784808.00, 0.00),
  ('tf16aa029f963', 'kas_keluar', '2026-08-27', 'CO-2610-0712', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'servis dinamo 2jt', 0.00, 1000000.00),
  ('teabe2f1f6fd7', 'kas_keluar', '2026-08-27', 'CO-2610-0713', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'bubut puly 1.350.000', 0.00, 675000.00),
  ('t5156a6907233', 'kas_keluar', '2026-09-07', 'CO-2610-0714', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'service dinamo 1,8jt', 0.00, 900000.00),
  ('t46bb8ae10cb1', 'kas_keluar', '2026-10-15', 'CO-2610-0715', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 6', '', 'pelunasan sekam cibeurem pak rw', 0.00, 1500500.00),
  ('t352d982dd2b7', 'kas_keluar', '2026-10-15', 'CO-2610-0716', 'Kas Besar', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 5', '', 'sekam cibeureum (uang ganti pupuk bu yanti clm2)', 0.00, 2000000.00),
  ('te6f31515bdbb', 'kas_keluar', '2026-10-15', 'CO-2610-0717', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', 'HPK-Yusri', 'KUR an yusri', 0.00, 12537037.00),
  ('te9eaa094725c', 'kas_keluar', '2026-10-15', 'CO-2610-0718', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (13/10)', 0.00, 35000.00),
  ('t291957a15737', 'kas_keluar', '2026-10-15', 'CO-2610-0719', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (9/10)', 0.00, 30000.00),
  ('t24024e328e9c', 'kas_keluar', '2026-10-15', 'CO-2610-0720', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (13/10)', 0.00, 30000.00),
  ('tcb19b1d7c2eb', 'kas_keluar', '2026-10-15', 'CO-2610-0721', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'pelunasan coating mobil', 0.00, 3000000.00),
  ('t1d172a7fa761', 'kas_keluar', '2026-10-15', 'CO-2610-0722', 'Kas Besar', 'Pajak Dibayar Dimuka-PPh 21', 'Cost Center', '', 'pph 21 bln september', 0.00, 56250.00),
  ('t823b8f859be6', 'kas_keluar', '2026-10-15', 'CO-2610-0723', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'sunlight, mr muscle, galon', 0.00, 50600.00),
  ('t26dfccb9f1ac', 'kas_keluar', '2026-10-15', 'CO-2610-0724', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat pak rajab', 0.00, 30000.00),
  ('t69972708f583', 'kas_keluar', '2026-10-15', 'CO-2610-0725', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat pak rajab', 0.00, 374700.00),
  ('t3486b14de04b', 'kas_keluar', '2026-10-15', 'CO-2610-0726', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'HP Inventaris', 0.00, 2599000.00),
  ('t564f5eadbd45', 'kas_keluar', '2026-10-15', 'CO-2610-0727', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'bihun pak rajab', 0.00, 24000.00),
  ('tc3e8cce37475', 'kas_keluar', '2026-10-15', 'CO-2610-0728', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'kasbon bah sarip', 0.00, 500000.00),
  ('t3b4ec33e9517', 'kas_keluar', '2026-10-15', 'CO-2610-0729', 'Kas Besar', 'Piutang Karyawan', 'Cost Center', 'Pi-Asun', 'pinjaman asun', 0.00, 6000000.00),
  ('t45a4a71f6cdb', 'kas_keluar', '2026-10-15', 'CO-2610-0730', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'pak rajab cash', 0.00, 1000000.00),
  ('t9091eb026b95', 'kas_keluar', '2026-10-15', 'CO-2610-0731', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'lem sealant (pak zamzam)', 0.00, 32000.00),
  ('tb830e6d7bcf9', 'kas_keluar', '2026-10-15', 'CO-2610-0732', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'beton K250 49 m3', 0.00, 47530000.00),
  ('tcfa9fd217f5a', 'kas_keluar', '2026-10-15', 'CO-2610-0733', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'ADM', 0.00, 46945965.00),
  ('t4692fda63d0f', 'kas_keluar', '2026-10-15', 'CO-2610-0734', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'KNMP Donggala', '', 'kas op donggala', 0.00, 5000000.00),
  ('taa79ecf5d38b', 'kas_keluar', '2026-10-15', 'CO-2610-0735', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'vinilex pro', 0.00, 167600.00),
  ('t21910d35c684', 'kas_keluar', '2026-10-15', 'CO-2610-0736', 'Kas Besar', 'Hutang Dagang', 'Bina Marga Rehab Jembatan Provinsi', 'V-HU-Berkat', 'nota berkat 27/8', 0.00, 17989215.00),
  ('te664b8f5ba1b', 'kas_keluar', '2026-10-15', 'CO-2610-0737', 'Kas Besar', 'Hutang Dagang', 'Cibatu', 'V-HU-Berkat', 'nota 21/8 berkat', 0.00, 49955700.00),
  ('tf379dd4d249b', 'kas_keluar', '2026-10-15', 'CO-2610-0738', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 15', 0.00, 5000000.00),
  ('t4deb7884ef80', 'kas_keluar', '2026-10-15', 'CO-2610-0739', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'keni, mata gergaji', 0.00, 100600.00),
  ('t53f74be2c7b9', 'kas_keluar', '2026-10-15', 'CO-2610-0740', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kramik', 0.00, 670500.00),
  ('t3bcef65cd29e', 'kas_keluar', '2026-10-15', 'CO-2610-0741', 'Kas Besar', 'Biaya entertain', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (rokok minum kaur&pengawas)', 0.00, 134000.00),
  ('t0df1b6056fec', 'kas_keluar', '2026-10-15', 'CO-2610-0742', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (obat2an, bensin)', 0.00, 153000.00),
  ('tcac9c456d1d2', 'kas_keluar', '2026-10-15', 'CO-2610-0743', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', 'kas arya (print, fotokopi)', 0.00, 346500.00),
  ('t51ec69473946', 'kas_keluar', '2026-10-15', 'CO-2610-0744', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (ongkir primafix, benang, lem kayu, peso granit, dll)', 0.00, 715000.00),
  ('ta26ea071ff41', 'kas_keluar', '2026-10-15', 'CO-2610-0745', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (print gambar, fotokopi lapjusik)', 0.00, 127000.00),
  ('tbce92fd7ad11', 'kas_keluar', '2026-10-15', 'CO-2610-0746', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (ongkos pekerja)', 0.00, 100000.00),
  ('td58bb6852938', 'kas_keluar', '2026-10-15', 'CO-2610-0747', 'Kas Besar', 'Hutang Dagang', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', 'besi 8, 12 nota berkat 6/8', 0.00, 11805960.00),
  ('te12f56f18a7a', 'kas_keluar', '2026-10-15', 'CO-2610-0748', 'Kas Besar', 'Hutang Dagang', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', 'nota berkat 29/8', 0.00, 32629500.00),
  ('t2f5cfd903196', 'kas_keluar', '2026-10-15', 'CO-2610-0749', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'semen', 0.00, 2330000.00),
  ('tdf895d0a96db', 'kas_keluar', '2026-10-15', 'CO-2610-0750', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang barangkal', 0.00, 4050000.00),
  ('t8e7dcf4a55be', 'kas_keluar', '2026-10-15', 'CO-2610-0751', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'kas arya (prostex, tangit, triplek, dll)', 0.00, 456000.00),
  ('t9d56dfe5dc7c', 'kas_keluar', '2026-10-15', 'CO-2610-0752', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'DP precast lantai antapani', 0.00, 12907073.00),
  ('t278995a18662', 'kas_keluar', '2026-10-15', 'CO-2610-0753', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'kas fikri r.asoka (compound, skrap)', 0.00, 27500.00),
  ('te2d4c44ec1d0', 'kas_keluar', '2026-10-15', 'CO-2610-0754', 'Kas Besar', 'Biaya Bahan', 'KDMP Pasar Baru Andir', '', 'kas fikri andir (cat seiv, roskam, lampu neon, token, dll)', 0.00, 503000.00),
  ('t2736af07f7cb', 'kas_keluar', '2026-10-15', 'CO-2610-0755', 'Kas Besar', 'Biaya Akomodasi', 'KDMP Pasar Baru Andir', '', 'kas fikri (transport pekerja)', 0.00, 101500.00),
  ('t94ace78a005f', 'kas_keluar', '2026-10-15', 'CO-2610-0756', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'gergaji, koas, thinner, stop kran, dll', 0.00, 1153500.00),
  ('t47449adf255b', 'kas_keluar', '2026-10-15', 'CO-2610-0757', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kramik lantai 80dus', 0.00, 4800000.00),
  ('ta088d3222759', 'kas_keluar', '2026-10-15', 'CO-2610-0758', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'reng baja, kumpon, semen putih, skrup, lem kayu', 0.00, 1795000.00),
  ('t1f3f179d9d5f', 'kas_keluar', '2026-10-15', 'CO-2610-0759', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'Listrik', 0.00, 503000.00),
  ('tf5f245f62ca0', 'kas_keluar', '2026-10-15', 'CO-2610-0760', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'semen, lemkra, mill', 0.00, 10002500.00),
  ('tb332f5cb3a3c', 'kas_keluar', '2026-10-15', 'CO-2610-0761', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pasir pasang 4truk', 0.00, 8200000.00),
  ('tb1adc777c69c', 'kas_keluar', '2026-10-15', 'CO-2610-0762', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pasir pasang 2 rit (14/10)', 0.00, 4500000.00),
  ('t42968f3f6a32', 'kas_keluar', '2026-10-15', 'CO-2610-0763', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kanzel gold, presto', 0.00, 2650000.00),
  ('t5819b96ca75e', 'kas_keluar', '2026-10-15', 'CO-2610-0764', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kas arya (triplek, sikat kawat, pisau kramik, pilox, paku, dll)', 0.00, 856500.00),
  ('tdd0ce73de686', 'kas_keluar', '2026-10-15', 'CO-2610-0765', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim plafon 14/10', 0.00, 2000000.00),
  ('t18faf9fe58b3', 'kas_keluar', '2026-10-15', 'CO-2610-0766', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim sipil 14/10', 0.00, 5000000.00),
  ('t0f1d3e8998e1', 'kas_keluar', '2026-10-15', 'CO-2610-0767', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim jalan 14/10', 0.00, 2000000.00),
  ('tfca5b5f65a8a', 'kas_keluar', '2026-10-15', 'CO-2610-0768', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'lem hebel. roll, koas', 0.00, 440000.00),
  ('t2bb544641433', 'kas_keluar', '2026-10-15', 'CO-2610-0769', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'bak cat, sekrup', 0.00, 195000.00),
  ('td42a942ad820', 'kas_keluar', '2026-10-15', 'CO-2610-0770', 'Kas Besar', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Berkat', 'baja ringan nota berkat 6/8', 0.00, 13320000.00),
  ('t8e5e38d01083', 'kas_keluar', '2026-10-15', 'CO-2610-0771', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'kasbon rina (baja)', 0.00, 5000000.00),
  ('t76b556d0c799', 'kas_keluar', '2026-10-15', 'CO-2610-0772', 'Kas Besar', 'Biaya ADM', 'Zidam Renov Rumdis Bogor', '', 'kunjungan pengawas', 0.00, 3500000.00),
  ('t4c0cd479e1b6', 'kas_keluar', '2026-10-15', 'CO-2610-0773', 'Kas Besar', 'Biaya ADM', 'Zidam Renov Rumdis Bogor', '', 'reimburse hamdan (spanduk, print)', 0.00, 282000.00),
  ('t7e481977f1ec', 'kas_keluar', '2026-10-15', 'CO-2610-0774', 'Kas Besar', 'Biaya Akomodasi', 'Zidam Renov Rumdis Bogor', '', 'reimburse hamdan (bensin)', 0.00, 72000.00),
  ('tafcbce92364d', 'kas_keluar', '2026-10-15', 'CO-2610-0775', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'bensin carry (langsir)', 0.00, 300000.00),
  ('t1b7493edd5f1', 'kas_keluar', '2026-10-15', 'CO-2610-0776', 'Kas Besar', 'Prive', 'Prive', 'Pr-F', 'DP umroh ade rana', 0.00, 10002500.00),
  ('t7dcaf0a165d8', 'kas_keluar', '2026-10-15', 'CO-2610-0777', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'tm 7, teknisi, solar jackhammer 12/10', 0.00, 1100000.00),
  ('t12353dc06f58', 'kas_keluar', '2026-10-15', 'CO-2610-0778', 'Kas Besar', 'Biaya entertain', 'Bina Marga Rehab Jembatan Provinsi', '', 'kas um dinas dll 12/10', 0.00, 700000.00),
  ('tcca934be9f22', 'kas_keluar', '2026-10-15', 'CO-2610-0779', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Bogor', '', 'kas arya (kirim buku direksikeet)', 0.00, 58000.00),
  ('t25d99a99d498', 'kas_keluar', '2026-10-15', 'CO-2610-0780', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'kas fikri (ongkos pekerja)', 0.00, 54500.00),
  ('t32068da954ee', 'kas_keluar', '2026-10-15', 'CO-2610-0781', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'cangkul, gagang, kape', 0.00, 368000.00),
  ('t0dedcfab890d', 'kas_keluar', '2026-10-15', 'CO-2610-0782', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'sarung tangan , rooping', 0.00, 250000.00),
  ('t4bc9cc50cd58', 'kas_keluar', '2026-10-15', 'CO-2610-0783', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'bayaran pesantren al hasan', 0.00, 2632000.00),
  ('t83b878e0a014', 'kas_keluar', '2026-10-15', 'CO-2610-0784', 'Kas Besar', 'Atensi', 'ZIDAM Bangun Rumdis Pangandaran', '', 'bayaran pesantrren al mabur', 0.00, 1484000.00),
  ('tc199d3f58e08', 'kas_keluar', '2026-10-15', 'CO-2610-0785', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'air 14/10', 0.00, 250000.00),
  ('tbf4201cb8d84', 'kas_keluar', '2026-10-15', 'CO-2610-0786', 'Kas Besar', 'Hutang Dagang', 'PUPR Bangun Satpol PP Sumedang', 'V-HU-Berkat', 'besi 8, 16 nota 7/8', 0.00, 21389700.00),
  ('tcf39109c1a96', 'kas_keluar', '2026-10-15', 'CO-2610-0787', 'Kas Besar', 'Hutang Dagang', 'Kemhan Bangun Rumdis Korem Cirebon', 'V-HU-Berkat', 'nota 7/8 berkat', 0.00, 821400.00),
  ('t4361d4a44c8c', 'kas_keluar', '2026-10-15', 'CO-2610-0788', 'Kas Besar', 'Biaya Cuci Kandang', 'Farm Cibeureum periode 6', '', 'soda api', 0.00, 840000.00);

-- 7 penyesuaian pada transaksi yang sudah ada
UPDATE `transactions` SET `kredit` = 1000000.00 WHERE `ref` = 'CO-2608-0958';
UPDATE `transactions` SET `kredit` = 675000.00 WHERE `ref` = 'CO-2608-0959';
UPDATE `transactions` SET `kredit` = 900000.00 WHERE `ref` = 'CO-2609-0460';
UPDATE `transactions` SET `kredit` = 5056200.00 WHERE `ref` = 'CO-2610-0443';
UPDATE `transactions` SET `kredit` = 20000000.00 WHERE `ref` = 'CO-2610-0506';
UPDATE `transactions` SET `kredit` = 1680200.00 WHERE `ref` = 'CO-2610-0540';
UPDATE `transactions` SET `project` = 'Zidam Rehab Rumdis Cimahi' WHERE `ref` = 'CO-2610-0708';
