-- Sinkronisasi dari Report export terbaru (14 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup semua
-- file sync sebelumnya s/d sync_jurnal_okt13_2026.sql dan
-- fix_relasi_prive_okt13_2026.sql.
--
-- Ditemukan 62 transaksi baru (14 Oktober 2026, termasuk 1 pasangan
-- penarikan loan Bank BJB RC Prakasa -> Kas Besar BO-2610-0016/CI-2610-0016,
-- dan 1 termin masuk Bank BJB RC Prakasa BI-2610-0009 Rp624.532.676).
-- 0 penyesuaian pada transaksi lama, 0 transaksi hilang dari Report. Jurnal
-- Umum tidak berubah sama sekali dari export sebelumnya (file identik).
--
-- 5 transaksi Prive baru (CO-2610-0669/670/671/672/673) diberi relasi
-- langsung di sini (bukan perlu file fix terpisah lagi) -- owner dikenali
-- dari keterangan masing-masing ('pak ei'->Pr-K, 'pak zamzam'->Pr-Z,
-- 'pa rajab'->Pr-R) lalu DIVERIFIKASI SILANG terhadap Data Prive sistem
-- asli: kenaikan Pr-K tepat 170.950+2.000.800=2.171.750, Pr-Z tepat
-- 182.000, dan Pr-R tepat 92.000+20.000=112.000 -- termasuk memastikan
-- 'bu ema (kukusan)' Rp20.000 masuk Pr-R, bukan Pr-K (satu-satunya baris
-- yang tidak jelas dari teks keterangannya sendiri).
--
-- Diverifikasi end-to-end: Dashboard Cash Flow & Data Prive hasil index.html
-- atas dataset ini sama persis dengan sistem asli (lihat pesan balasan).

-- 62 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('tb80e2c5a40b1', 'bank_masuk', '2026-10-14', 'BI-2610-0009', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'Zidam Rumdis Zipur', '', 'termin ke 1 zipur', 624532676.00, 0.00),
  ('te85eb265680d', 'bank_keluar', '2026-10-14', 'BO-2610-0016', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 14 oktober', 0.00, 514894764.00),
  ('t3158a64f0d6e', 'kas_masuk', '2026-10-14', 'CI-2610-0016', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 14 oktober', 514894764.00, 0.00),
  ('t2cd3d283bb83', 'kas_keluar', '2026-10-14', 'CO-2610-0653', 'Kas Besar', 'Biaya Operasional', 'Farm Cibeureum periode 6', '', 'kas fahril cbr (bensin blade, batu baterai)', 0.00, 84000.00),
  ('t352b195c085c', 'kas_keluar', '2026-10-14', 'CO-2610-0654', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 1 periode 5', '', 'kas fahril cilame 1 (gas, pulsa satpam, bensin, ban dalam)', 0.00, 260000.00),
  ('t6f7d90987125', 'kas_keluar', '2026-10-14', 'CO-2610-0655', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cibeureum periode 6', '', 'gaji pegawai cibeureum off', 0.00, 3425000.00),
  ('tfcc02bb4953a', 'kas_keluar', '2026-10-14', 'CO-2610-0656', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cilame 2 periode 6', '', 'gaji pegawai cilame 2 off', 0.00, 5420000.00),
  ('t250ff42daa1b', 'kas_keluar', '2026-10-14', 'CO-2610-0657', 'Kas Besar', 'Biaya Pengobatan Karyawan', 'Farm Cibeureum periode 6', '', 'biaya berobat iduy cbr', 0.00, 1000000.00),
  ('t7236df3c6867', 'kas_keluar', '2026-10-14', 'CO-2610-0658', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin 12/10', 0.00, 30000.00),
  ('t185823b0aa8e', 'kas_keluar', '2026-10-14', 'CO-2610-0659', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'spring roll egg, chicken, sauce (12/10)', 0.00, 39000.00),
  ('td8961eaa5505', 'kas_keluar', '2026-10-14', 'CO-2610-0660', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, nasi (12/10)', 0.00, 68000.00),
  ('t53d4ec51b1be', 'kas_keluar', '2026-10-14', 'CO-2610-0661', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'fotocopy', 0.00, 2000.00),
  ('ted6307579a53', 'kas_keluar', '2026-10-14', 'CO-2610-0662', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'lembur, beli nasi', 0.00, 28000.00),
  ('t0f04a5ca022f', 'kas_keluar', '2026-10-14', 'CO-2610-0663', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'DP poles mobil', 0.00, 3000000.00),
  ('t676ae97d0b8e', 'kas_keluar', '2026-10-14', 'CO-2610-0664', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'Biaya trf firecash', 0.00, 35000.00),
  ('td3c54357f060', 'kas_keluar', '2026-10-14', 'CO-2610-0665', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'trf ke rc (kelebihan narik)', 0.00, 6500.00),
  ('t12dc552130fe', 'kas_keluar', '2026-10-14', 'CO-2610-0666', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'vaksin ade rana', 0.00, 750000.00),
  ('tfe9a05f5249d', 'kas_keluar', '2026-10-14', 'CO-2610-0667', 'Kas Besar', 'Biaya Telepon', 'Cost Center', '', 'pulsa pak ei', 0.00, 102000.00),
  ('t250b00deee70', 'kas_keluar', '2026-10-14', 'CO-2610-0668', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'op jemput pak ei', 0.00, 750000.00),
  ('t16e57e9da48d', 'kas_keluar', '2026-10-14', 'CO-2610-0669', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'pak ei baju tob', 0.00, 170950.00),
  ('td074a4b72719', 'kas_keluar', '2026-10-14', 'CO-2610-0670', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'pak zamzam (vermak, kolek, tahu)', 0.00, 182000.00),
  ('tfc74831f206a', 'kas_keluar', '2026-10-14', 'CO-2610-0671', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'bu ema (kukusan)', 0.00, 20000.00),
  ('t8586db1c8658', 'kas_keluar', '2026-10-14', 'CO-2610-0672', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'pa rajab (baso nusajaya)', 0.00, 92000.00),
  ('tfe91b3dcb4f9', 'kas_keluar', '2026-10-14', 'CO-2610-0673', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'pak ei oleh oleh', 0.00, 2000800.00),
  ('t8639d1faf141', 'kas_keluar', '2026-10-14', 'CO-2610-0674', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan', '', 'op pa fahri kodim kodim', 0.00, 1000000.00),
  ('t7c30c60a5bfd', 'kas_keluar', '2026-10-14', 'CO-2610-0675', 'Kas Besar', 'Biaya entertain', 'ZIDAM', '', 'karangan bunga hut zeni 3 perusahaan', 0.00, 1950000.00),
  ('t71369f89e0d1', 'kas_keluar', '2026-10-14', 'CO-2610-0676', 'Kas Besar', 'Biaya Bahan', 'ZIDAM', '', 'pelunasan sondir pangandaran', 0.00, 5000000.00),
  ('t15c99d941f77', 'kas_keluar', '2026-10-14', 'CO-2610-0677', 'Kas Besar', 'Biaya Bahan', 'Tugu Perkim Cirebon', '', 'pemb ke 2 mahkota kinasih', 0.00, 20000000.00),
  ('ta881fcfa521f', 'kas_keluar', '2026-10-14', 'CO-2610-0678', 'Kas Besar', 'Biaya Bahan', 'Tugu Perkim Cirebon', '', 'DP bata interlock', 0.00, 119880000.00),
  ('t4480d941da08', 'kas_keluar', '2026-10-14', 'CO-2610-0679', 'Kas Besar', 'Biaya Jakon', 'KNMP Donggala', '', 'BPJS donggala', 0.00, 16420472.00),
  ('tfd8a2cf0325c', 'kas_keluar', '2026-10-14', 'CO-2610-0680', 'Kas Besar', 'Biaya Jakon', 'KNMP Pekalongan', '', 'BPJS Pekalongan', 0.00, 14966267.00),
  ('tc7fa563d12b5', 'kas_keluar', '2026-10-14', 'CO-2610-0681', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'kloset jongkok', 0.00, 200000.00),
  ('t080eead4b5e3', 'kas_keluar', '2026-10-14', 'CO-2610-0682', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'buang barangkal', 0.00, 400000.00),
  ('t1da6eb768bf1', 'kas_keluar', '2026-10-14', 'CO-2610-0683', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'belanja bahan ART', 0.00, 5000000.00),
  ('te64b26ced24e', 'kas_keluar', '2026-10-14', 'CO-2610-0684', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'ompreng', 0.00, 43775.00),
  ('t7c6a31493bbb', 'kas_keluar', '2026-10-14', 'CO-2610-0685', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'Belanja tgl 14', 0.00, 6500000.00),
  ('t654344dd8fb2', 'kas_keluar', '2026-10-14', 'CO-2610-0686', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'biaya trf semen', 0.00, 2500.00),
  ('t7ca646f9a1d2', 'kas_keluar', '2026-10-14', 'CO-2610-0687', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'semen 720 sak', 0.00, 42482500.00),
  ('tfd2345ee4700', 'kas_keluar', '2026-10-14', 'CO-2610-0688', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang puing', 0.00, 3600000.00),
  ('t193d3fefef8b', 'kas_keluar', '2026-10-14', 'CO-2610-0689', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'pembelian pasir 2 rit', 0.00, 4300000.00),
  ('t9d06e8ae7090', 'kas_keluar', '2026-10-14', 'CO-2610-0690', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kostan fikri', 0.00, 1200000.00),
  ('tdd09accfcd12', 'kas_keluar', '2026-10-14', 'CO-2610-0691', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'semen 5 sak', 0.00, 250000.00),
  ('t145ed71defdd', 'kas_keluar', '2026-10-14', 'CO-2610-0692', 'Kas Besar', 'Biaya Upah', 'Asmira Dustira', '', 'Asmira Iqbal', 0.00, 30000000.00),
  ('tf468a7ba56c8', 'kas_keluar', '2026-10-14', 'CO-2610-0693', 'Kas Besar', 'Biaya Bahan', 'Cibatu', '', 'baja ringan, skrup', 0.00, 3735000.00),
  ('ta7fb9c625cdc', 'kas_keluar', '2026-10-14', 'CO-2610-0694', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'trf bahan alam', 0.00, 5000.00),
  ('t54d0e4d6c75b', 'kas_keluar', '2026-10-14', 'CO-2610-0695', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'magic com', 0.00, 270000.00),
  ('tb9fcc0800cd3', 'kas_keluar', '2026-10-14', 'CO-2610-0696', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'kost subang', 0.00, 700000.00),
  ('t0985bae51bf2', 'kas_keluar', '2026-10-14', 'CO-2610-0697', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'ban arco', 0.00, 534000.00),
  ('te7440d619706', 'kas_keluar', '2026-10-14', 'CO-2610-0698', 'Kas Besar', 'Biaya Dibayar Dimuka', 'Kemhan Bangun Rumdis Cimahi', '', 'kas arya', 0.00, 1000000.00),
  ('t950dd682ef81', 'kas_keluar', '2026-10-14', 'CO-2610-0699', 'Kas Besar', 'Biaya ADM', 'Kemhan Bangun Rumdis Cimahi', '', 'SLO', 0.00, 8162500.00),
  ('ta1223cd39af7', 'kas_keluar', '2026-10-14', 'CO-2610-0700', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'dempul, koas, meteran', 0.00, 872000.00),
  ('td0dc50a4650a', 'kas_keluar', '2026-10-14', 'CO-2610-0701', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'lampu untuk lembur', 0.00, 236500.00),
  ('tfc8e57f3b83a', 'kas_keluar', '2026-10-14', 'CO-2610-0702', 'Kas Besar', 'Biaya Bahan2', 'Kemhan Cut n Fill', '', 'sewa beko dan mob demob cimahi', 0.00, 11375000.00),
  ('t9fb362125efa', 'kas_keluar', '2026-10-14', 'CO-2610-0703', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'nota bon toko adi mekar jaya', 0.00, 4807000.00),
  ('tbb43a6b41d44', 'kas_keluar', '2026-10-14', 'CO-2610-0704', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'beton fasttrack 149m3', 0.00, 149839000.00),
  ('tea7fda557fe2', 'kas_keluar', '2026-10-14', 'CO-2610-0705', 'Kas Besar', 'Biaya Bahan', 'BJB Majalaya', '', 'majalaya', 0.00, 2000000.00),
  ('t8a46220a367d', 'kas_keluar', '2026-10-14', 'CO-2610-0706', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'buang barangkal 2 rit', 0.00, 800000.00),
  ('t0c70378ba0f3', 'kas_keluar', '2026-10-14', 'CO-2610-0707', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kabel', 0.00, 650000.00),
  ('t5dbb2b2f7eb0', 'kas_keluar', '2026-10-14', 'CO-2610-0708', 'Kas Besar', 'Biaya Bahan', 'Zidam Brigif 15 Zipur', '', 'Genteng', 0.00, 12247500.00),
  ('t43bd927cb0f1', 'kas_keluar', '2026-10-14', 'CO-2610-0709', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan Bangun Koramil Majalengka Maulusma', '', 'OP pa fahri majalengka 14/10', 0.00, 1000000.00),
  ('t5a4600f7ebc7', 'kas_keluar', '2026-10-14', 'CO-2610-0710', 'Kas Besar', 'Biaya Upah2', 'PUPR Bangun Satpol PP Sumedang', '', 'Kasbon pekerja atap / alumunium foil', 0.00, 5002500.00),
  ('t9faf68129e02', 'kas_keluar', '2026-10-14', 'CO-2610-0711', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'nota bahan material TB subur 4-10 okt', 0.00, 20998000.00);
