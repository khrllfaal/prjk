-- 9 voucher jurnal penyesuaian baru (13 Oktober 2026) yang belum ada di
-- data kita -- ditemukan lewat selisih Trial Balance (Biaya Treatment Ayam
-- & Biaya Bahan) dan dikonfirmasi oleh detail jurnal per-akun yang
-- dikirim owner dari sistem asli. Baris per akun untuk tiap voucher sudah
-- dicek: jumlah Debit = Kredit = total voucher di Report Jurnal Umum.
INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('j1c22e33874d2', '2026-10-13', 'JU26100119', 'Biaya Treatment Ayam', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'pelunasan sekam cibeureum 5.289 karung x 7.500 = 39.667.500, dipot. karung pakan 8.250, kasbon 7.500, pemeliharaan 1.000', 22917500.00, 0.00),
  ('jfe640ef4b1a6', '2026-10-13', 'JU26100119', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', '', '', 'posted', 'pelunasan sekam cibeureum 5.289 karung x 7.500 = 39.667.500, dipot. karung pakan 8.250, kasbon 7.500, pemeliharaan 1.000', 0.00, 22917500.00),
  ('j7c8ee837a7a7', '2026-10-13', 'JU26100120', 'Biaya Bahan', 'Proyek Patrakomala', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 10 143btg, beton polos 8 135btg (26/9) #berkat', 16058000.00, 0.00),
  ('jdbc4d7d05d20', '2026-10-13', 'JU26100120', 'Biaya Bahan', 'Proyek Patrakomala', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 10 143btg, beton polos 8 135btg (26/9) #berkat', 1766380.00, 0.00),
  ('j5fa3a165dd9b', '2026-10-13', 'JU26100120', 'Hutang Dagang', 'Proyek Patrakomala', 'V-HU-Berkat', '', '', 'posted', 'beton polos 10 143btg, beton polos 8 135btg (26/9) #berkat', 0.00, 17824380.00),
  ('jf1226b026408', '2026-10-13', 'JU26100121', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', 'V-HU-Berkat', 'Bahan', '', 'posted', 'alumunium foil bubble 1.200m (24/9) #berkat', 14400000.00, 0.00),
  ('jc60e4879d816', '2026-10-13', 'JU26100121', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', 'V-HU-Berkat', 'Bahan', '', 'posted', 'alumunium foil bubble 1.200m (24/9) #berkat', 1584000.00, 0.00),
  ('j578902cafc3f', '2026-10-13', 'JU26100121', 'Hutang Dagang', 'PUPR Bangun Satpol PP Sumedang', 'V-HU-Berkat', '', '', 'posted', 'alumunium foil bubble 1.200m (24/9) #berkat', 0.00, 15984000.00),
  ('j8da615699b0b', '2026-10-13', 'JU26100122', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 10 400btg, beton polos 8 160btg, beton ulir 25 84btg (25/9) #berkat', 73808000.00, 0.00),
  ('j98601381a9ad', '2026-10-13', 'JU26100122', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 10 400btg, beton polos 8 160btg, beton ulir 25 84btg (25/9) #berkat', 8118880.00, 0.00),
  ('j90216a3ae193', '2026-10-13', 'JU26100122', 'Hutang Dagang', 'Bina Marga Kodim Bangun Jalan Cibalong', 'V-HU-Berkat', '', '', 'posted', 'beton polos 10 400btg, beton polos 8 160btg, beton ulir 25 84btg (25/9) #berkat', 0.00, 81926880.00),
  ('j2fc55637714b', '2026-10-13', 'JU26100123', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', 'V-HU-Berkat', 'Bahan', '', 'posted', 'hollow gitsum 600btg (22/9)', 10200000.00, 0.00),
  ('j6406f2739666', '2026-10-13', 'JU26100123', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', 'V-HU-Berkat', 'Bahan', '', 'posted', 'hollow gitsum 600btg (22/9)', 1122000.00, 0.00),
  ('j476aab09a880', '2026-10-13', 'JU26100123', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Berkat', '', '', 'posted', 'hollow gitsum 600btg (22/9)', 0.00, 11322000.00),
  ('j63c101500df1', '2026-10-13', 'JU26100124', 'Biaya Bahan', 'Kemhan Cut n Fill', 'V-HU-Berkat', 'Bahan', '', 'posted', 'wiremesh 8mm 120lembar (22/9) #berkat', 62400000.00, 0.00),
  ('j7eacdb0ccf6d', '2026-10-13', 'JU26100124', 'Biaya Bahan', 'Kemhan Cut n Fill', 'V-HU-Berkat', 'Bahan', '', 'posted', 'wiremesh 8mm 120lembar (22/9) #berkat', 6864000.00, 0.00),
  ('jc8e671a15323', '2026-10-13', 'JU26100124', 'Hutang Dagang', 'Kemhan Cut n Fill', 'V-HU-Berkat', '', '', 'posted', 'wiremesh 8mm 120lembar (22/9) #berkat', 0.00, 69264000.00),
  ('j5c63383a0ece', '2026-10-13', 'JU26100125', 'Biaya Bahan', 'Proyek Antapani', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 8 6btg, beton ulir 13 8btg (22/9) #berkat', 1242400.00, 0.00),
  ('j5fb8b5edb190', '2026-10-13', 'JU26100125', 'Biaya Bahan', 'Proyek Antapani', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 8 6btg, beton ulir 13 8btg (22/9) #berkat', 136664.00, 0.00),
  ('j163df30b8141', '2026-10-13', 'JU26100125', 'Hutang Dagang', 'Proyek Antapani', 'V-HU-Berkat', '', '', 'posted', 'beton polos 8 6btg, beton ulir 13 8btg (22/9) #berkat', 0.00, 1379064.00),
  ('j7b812468a86a', '2026-10-13', 'JU26100126', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 12 15btg, beton 8 13btg (22/9) #berkat', 2145400.00, 0.00),
  ('jcc1d3745f0e6', '2026-10-13', 'JU26100126', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton polos 12 15btg, beton 8 13btg (22/9) #berkat', 235994.00, 0.00),
  ('jce6c37d565e1', '2026-10-13', 'JU26100126', 'Hutang Dagang', 'RS Dustira Bangun Ruang Kenanga', 'V-HU-Berkat', '', '', 'posted', 'beton polos 12 15btg, beton 8 13btg (22/9) #berkat', 0.00, 2381394.00),
  ('j43c037daa84d', '2026-10-13', 'JU26100127', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton ulir 13 10btg, wiremesh 8mm 20lembar (21/9) #berkat', 11617000.00, 0.00),
  ('jec6eae6cf760', '2026-10-13', 'JU26100127', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Berkat', 'Bahan', '', 'posted', 'beton ulir 13 10btg, wiremesh 8mm 20lembar (21/9) #berkat', 1277870.00, 0.00),
  ('ja440b1509f5d', '2026-10-13', 'JU26100127', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Berkat', '', '', 'posted', 'beton ulir 13 10btg, wiremesh 8mm 20lembar (21/9) #berkat', 0.00, 12894870.00);
