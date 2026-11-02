-- Sinkronisasi 2 November 2026.
--
-- 114 transaksi baru (lihat INSERT transactions di bawah). TIDAK ada baris
-- baru untuk Hutang Dagang / Piutang di laporan kali ini -- Data Hutang dan
-- Data Piutang referensi (Rp10.135.238.564 / Rp1.261.553.948) tetap sama
-- seperti sync 30 Oktober, diverifikasi tidak berubah.
--
-- cash_in_Report_2.xls yang diupload user byte-identical (md5 sama) dengan
-- cash_in_Report_1.xls -- upload dobel, hanya diproses sekali.
--
-- 4 relasi Prive baru (delta Data Prive Rp5.716.000, dicocokkan ke pola ket
-- yang sama seperti kemunculan sebelumnya untuk nama yang sama -- lihat
-- kolom relasi langsung di INSERT di bawah, bukan UPDATE terpisah setelahnya):
--  - CO-2611-0018 'bulanan opal' -> Pr-F (pola sama seperti CO-2609-0464/CO-2610-0206)
--  - CO-2611-0019 'ade rana (ongkos dan kontrakan)' -> Pr-F (pola sama seperti CO-2610-1309)
--  - CO-2611-0048 '...(pak zamzam)' -> Pr-Z (pola sama di hampir semua ket 'pak zamzam')
--  - CO-2611-0049 'kasbon pak karli (hara)' -> Pr-K (pola sama di hampir semua ket 'pak karli')
-- Keempatnya diverifikasi: total & per-pemilik cocok persis dengan Data Prive
-- referensi (Pr-F 317.917.875, Pr-K 286.906.094, Pr-Z 256.833.382, Pr-R dan
-- Pr-I tidak berubah).
--
-- Koreksi JU26100146 'belanja dapur tgl 11-25 oktober' (voucher dari sync 30
-- Oktober yang waktu itu BELUM DIKONFIRMASI, dicatat sementara 1 baris) --
-- sekarang dipecah sesuai Detail Jurnal yang dikonfirmasi user:
--   5.1.01 Biaya Bahan debit 75.458.610 (turun dari 78.012.610)
--   5.1.07 Biaya Akomodasi debit 2.554.000 (baris baru)
--   1.1.24 Biaya Dibayar Dimuka kredit 78.012.610 (tetap, balance)
--
-- Koreksi NYATA (bukan normalisasi spasi) pada 4 transaksi lama -- 29 baris
-- lain yang kedeteksi beda hanya normalisasi spasi ganda di `ket`, bukan
-- perubahan data, jadi tidak diterapkan (sama seperti sync-sync sebelumnya):
--  - CO-2610-0052: akun lawan 'Biaya kirim Paket dan Dokumen' -> 'Biaya ATK & Perlengkapan Kantor'
--  - CO-2610-0174: akun lawan 'Biaya kirim Paket dan Dokumen' -> 'Biaya ADM'
--  - CO-2610-0170 & CO-2610-0809: project 'Cost Center' -> 'Kemhan Bangun Rumdis Bogor',
--    akun lawan 'Biaya Makan Karyawan' -> 'Biaya Akomodasi'
--
-- CATATAN (bukan bug, sudah diselidiki dan dikonfirmasi beres): selisih
-- Rp10.000.000 antara Trial Balance 'Piutang Karyawan' (Rp51.100.000) dan
-- jumlah PK-* di Data Piutang (Rp41.100.000) adalah relasi 'Pi-Asun'
-- (Rp10.000.000) yang memang dibukukan ke akun Piutang Karyawan (bukan
-- Piutang Usaha) di kedua sistem -- bukan relasi yang hilang.

-- Pelajaran dari bug sync 30 Oktober (fix_ci_2610_0036_relasi.sql): setiap
-- UPDATE yang menyasar baris yang BARU di-INSERT di file ini HARUS diletakkan
-- SETELAH blok INSERT itu. Di file ini relasi Prive baru sudah langsung
-- dimasukkan ke nilai INSERT-nya, jadi tidak perlu UPDATE terpisah sama sekali.

UPDATE `transactions` SET `akun_lawan` = 'Biaya ATK & Perlengkapan Kantor' WHERE `ref` = 'CO-2610-0052' AND `akun_lawan` = 'Biaya kirim Paket dan Dokumen';
UPDATE `transactions` SET `akun_lawan` = 'Biaya ADM' WHERE `ref` = 'CO-2610-0174' AND `akun_lawan` = 'Biaya kirim Paket dan Dokumen';
UPDATE `transactions` SET `project` = 'Kemhan Bangun Rumdis Bogor', `akun_lawan` = 'Biaya Akomodasi' WHERE `ref` = 'CO-2610-0170' AND `akun_lawan` = 'Biaya Makan Karyawan';
UPDATE `transactions` SET `project` = 'Kemhan Bangun Rumdis Bogor', `akun_lawan` = 'Biaya Akomodasi' WHERE `ref` = 'CO-2610-0809' AND `akun_lawan` = 'Biaya Makan Karyawan';

UPDATE `jurnal_umum` SET `debet` = 75458610.00, `ket` = 'belanja dapur tgl 11-25 oktober' WHERE `ref` = 'JU26100146' AND `akun` = 'Biaya Bahan' AND `debet` = 78012610.00;
UPDATE `jurnal_umum` SET `ket` = 'belanja dapur tgl 11-25 oktober' WHERE `ref` = 'JU26100146' AND `akun` = 'Biaya Dibayar Dimuka';
INSERT IGNORE INTO `jurnal_umum` (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`) VALUES
  ('j_new_JU26100146_akomodasi', '2026-10-30', 'JU26100146', 'Biaya Akomodasi', 'RS Guntur Belanja Dapur', '', 'Akomodasi', '', 'posted', 'belanja dapur tgl 11-25 oktober', 2554000.00, 0.00);

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('te9dccfa9519e', 'bank_keluar', '2026-11-02', 'BO-2611-0001', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 2 november', 0.00, 1050774444.00),
  ('t976498a62adf', 'kas_keluar', '2026-11-02', 'CO-2611-0001', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cibeureum periode 6', '', 'gaji cbr', 0.00, 34950000.00),
  ('t793541495e0b', 'kas_keluar', '2026-11-02', 'CO-2611-0002', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cilame 1 periode 5', '', 'gaji clm 1', 0.00, 49900000.00),
  ('tda70e6e60fa0', 'kas_keluar', '2026-11-02', 'CO-2611-0003', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cilame 2 periode 6', '', 'gaji clm 2', 0.00, 9500000.00),
  ('t5155b5bda171', 'kas_keluar', '2026-11-02', 'CO-2611-0004', 'Kas Besar', 'Cadangan THR', 'Farm Cibeureum periode 6', '', 'cadangan THR cbr', 0.00, 3400000.00),
  ('t595ffc8c8658', 'kas_keluar', '2026-11-02', 'CO-2611-0005', 'Kas Besar', 'Cadangan THR', 'Farm Cilame 1 periode 5', '', 'cadangan THR clm1', 0.00, 5200000.00),
  ('t17fab6b498df', 'kas_keluar', '2026-11-02', 'CO-2611-0006', 'Kas Besar', 'Cadangan THR', 'Farm Cilame 2 periode 6', '', 'cadangan THR clm2', 0.00, 3100000.00),
  ('tb5dae9b58a7d', 'kas_keluar', '2026-11-02', 'CO-2611-0007', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Farm Cibeureum periode 6', '', 'jatah panen cbr', 0.00, 1000000.00),
  ('t498d806b87a5', 'kas_keluar', '2026-11-02', 'CO-2611-0008', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Farm Cilame 1 periode 5', '', 'jatah panen clm1', 0.00, 1100000.00),
  ('tf0d0a2f8cd6f', 'kas_keluar', '2026-11-02', 'CO-2611-0009', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'mio pak zamzam', 0.00, 270000.00),
  ('t6e7ce66c4b05', 'kas_keluar', '2026-11-02', 'CO-2611-0010', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 29/10', 0.00, 30150.00),
  ('t7a877020d7c7', 'kas_keluar', '2026-11-02', 'CO-2611-0011', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 30/10', 0.00, 30000.00),
  ('t32285a435fc1', 'kas_keluar', '2026-11-02', 'CO-2611-0012', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendi 1/11', 0.00, 30000.00),
  ('t84ef66715748', 'kas_keluar', '2026-11-02', 'CO-2611-0013', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin pak dewo bawa mobil 31/10', 0.00, 100000.00),
  ('t52da003468b7', 'kas_keluar', '2026-11-02', 'CO-2611-0014', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'mobil pa dadan servis', 0.00, 685000.00),
  ('tc908a0506ebd', 'kas_keluar', '2026-11-02', 'CO-2611-0015', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'gigi pak zam', 0.00, 500000.00),
  ('tb944da61d76e', 'kas_keluar', '2026-11-02', 'CO-2611-0016', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'amplop uang', 0.00, 84000.00),
  ('tc27f0266300c', 'kas_keluar', '2026-11-02', 'CO-2611-0017', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'lampu broco namina', 0.00, 70000.00),
  ('te421ff8a5e5e', 'kas_keluar', '2026-11-02', 'CO-2611-0018', 'Kas Besar', 'Prive', 'Prive', 'Pr-F', 'bulanan opal', 0.00, 2500000.00),
  ('ta4956b6d24ca', 'kas_keluar', '2026-11-02', 'CO-2611-0019', 'Kas Besar', 'Prive', 'Prive', 'Pr-F', 'ade rana (ongkos dan kontrakan)', 0.00, 750000.00),
  ('t4c3ef1d1e5ad', 'kas_keluar', '2026-11-02', 'CO-2611-0020', 'Kas Besar', 'Biaya Honor Tenaga Ahli', 'Cost Center', '', 'tangguh', 0.00, 10000000.00),
  ('teb43216cefb8', 'kas_keluar', '2026-11-02', 'CO-2611-0021', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'galon', 0.00, 20000.00),
  ('t5e2a0ca2441e', 'kas_keluar', '2026-11-02', 'CO-2611-0022', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'baso pak rajab', 0.00, 49000.00),
  ('t5ed121bf4192', 'kas_keluar', '2026-11-02', 'CO-2611-0023', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, bubur', 0.00, 69000.00),
  ('t6d156b4a5299', 'kas_keluar', '2026-11-02', 'CO-2611-0024', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi dll 29/10', 0.00, 37000.00),
  ('t325f394dce60', 'kas_keluar', '2026-11-02', 'CO-2611-0025', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'diapet, promaag', 0.00, 11900.00),
  ('ta9f208b37431', 'kas_keluar', '2026-11-02', 'CO-2611-0026', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'soto nonoy 29/10', 0.00, 55000.00),
  ('t7940b32ee264', 'kas_keluar', '2026-11-02', 'CO-2611-0027', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'terpal, tambang', 0.00, 135000.00),
  ('t378518ee6be9', 'kas_keluar', '2026-11-02', 'CO-2611-0028', 'Kas Besar', 'Biaya Denda Pajak', 'Cost Center', '', 'denda keterlambatan lapor spt pak karli', 0.00, 303869.00),
  ('tf346e9cec8e0', 'kas_keluar', '2026-11-02', 'CO-2611-0029', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'gaji kantor + cadangan THR', 0.00, 91201846.00),
  ('ta1713041e357', 'kas_keluar', '2026-11-02', 'CO-2611-0030', 'Kas Besar', 'Biaya Gaji Direksi', 'Cost Center', '', 'ibu ibu', 0.00, 30000000.00),
  ('tc5f4b971bbe6', 'kas_keluar', '2026-11-02', 'CO-2611-0031', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM mega periode 16 - 31 okt', 0.00, 325000.00),
  ('ta26dbd23f707', 'kas_keluar', '2026-11-02', 'CO-2611-0032', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM zihan', 0.00, 275000.00),
  ('t1065c603a99a', 'kas_keluar', '2026-11-02', 'CO-2611-0033', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM gupron', 0.00, 275000.00),
  ('tfc4583f0de7b', 'kas_keluar', '2026-11-02', 'CO-2611-0034', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM yuki', 0.00, 350000.00),
  ('tbfd9ebd26560', 'kas_keluar', '2026-11-02', 'CO-2611-0035', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM eri', 0.00, 350000.00),
  ('taa3ed56afb11', 'kas_keluar', '2026-11-02', 'CO-2611-0036', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM andri', 0.00, 150000.00),
  ('tb04da9e6e643', 'kas_keluar', '2026-11-02', 'CO-2611-0037', 'Kas Besar', 'Biaya Akomodasi', 'RS Guntur Gudang Farmasi', '', 'UM asep', 0.00, 455000.00),
  ('t250558e38ce9', 'kas_keluar', '2026-11-02', 'CO-2611-0038', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'UM arya (8 hari antapani, 6 hari cimahi)', 0.00, 1050000.00),
  ('t93835334a0e5', 'kas_keluar', '2026-11-02', 'CO-2611-0039', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'UM fikri', 0.00, 1200000.00),
  ('t03b7948a4a9c', 'kas_keluar', '2026-11-02', 'CO-2611-0040', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'UM dicky', 0.00, 1125000.00),
  ('t3cc8c4e2e8c4', 'kas_keluar', '2026-11-02', 'CO-2611-0041', 'Kas Besar', 'Biaya Akomodasi', 'PUPR Bangun Satpol PP Sumedang', '', 'UM latif', 0.00, 1200000.00),
  ('te80d99e721ae', 'kas_keluar', '2026-11-02', 'CO-2611-0042', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'UM dadan', 0.00, 975000.00),
  ('tce5855393dbf', 'kas_keluar', '2026-11-02', 'CO-2611-0043', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Bogor', '', 'UM hamdan', 0.00, 1200000.00),
  ('t0c081a1488df', 'kas_keluar', '2026-11-02', 'CO-2611-0044', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'UM bayu', 0.00, 1500000.00),
  ('td7ecc82533ba', 'kas_keluar', '2026-11-02', 'CO-2611-0045', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'UM deni', 0.00, 975000.00),
  ('tf89344b5d388', 'kas_keluar', '2026-11-02', 'CO-2611-0046', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'UM ilham', 0.00, 1875000.00),
  ('te1756375307e', 'kas_keluar', '2026-11-02', 'CO-2611-0047', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Cost Center', '', 'Op pa dewo tasik (motor) 30/10', 0.00, 220048.00),
  ('t792badad4301', 'kas_keluar', '2026-11-02', 'CO-2611-0048', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'bahan jumat berkah, sepeda, stim, jilid, dl (pak zamzam)', 0.00, 156000.00),
  ('teec7caf6b1f5', 'kas_keluar', '2026-11-02', 'CO-2611-0049', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'kasbon pak karli (hara)', 0.00, 2310000.00),
  ('t14fa133907a2', 'kas_keluar', '2026-11-02', 'CO-2611-0050', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'termen ke 3 2 perusahaan', 0.00, 26000000.00),
  ('t5b2d66ec6e4f', 'kas_keluar', '2026-11-02', 'CO-2611-0051', 'Kas Besar', 'Biaya CSR/Kompensasi/Sumbangan', 'Tugu Perkim Cirebon', '', 'CSR', 0.00, 2000000.00),
  ('td7491d41661a', 'kas_keluar', '2026-11-02', 'CO-2611-0052', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'kasbon fuji', 0.00, 20000000.00),
  ('t2b383ba3284e', 'kas_keluar', '2026-11-02', 'CO-2611-0053', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'adm', 0.00, 25002500.00),
  ('tc8d9f48ee5fb', 'kas_keluar', '2026-11-02', 'CO-2611-0054', 'Kas Besar', 'Biaya Upah', 'Kemhan Kodim Kab Cianjur', '', 'DP pekerjaan cianjur', 0.00, 55461740.00),
  ('t917f44a77e24', 'kas_keluar', '2026-11-02', 'CO-2611-0055', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 31', 0.00, 4500000.00),
  ('taed33a1e92d7', 'kas_keluar', '2026-11-02', 'CO-2611-0056', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 1', 0.00, 6500000.00),
  ('t45f01a491cb5', 'kas_keluar', '2026-11-02', 'CO-2611-0057', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 2', 0.00, 4000000.00),
  ('t346d5847928a', 'kas_keluar', '2026-11-02', 'CO-2611-0058', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'semen, arco', 0.00, 7795000.00),
  ('t7af18d872064', 'kas_keluar', '2026-11-02', 'CO-2611-0059', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kirim paket ke cibalong 30/10', 0.00, 125000.00),
  ('t73b9e673e8a6', 'kas_keluar', '2026-11-02', 'CO-2611-0060', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang barangkal', 0.00, 300000.00),
  ('t3d1733063647', 'kas_keluar', '2026-11-02', 'CO-2611-0061', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'lem tetes', 0.00, 220000.00),
  ('t19f2a567818e', 'kas_keluar', '2026-11-02', 'CO-2611-0062', 'Kas Besar', 'Biaya Jamsostek Ketenagakerjaan', 'RS Dustira Bangun Ruang Kenanga', '', 'biaya kecelakaan kerja', 0.00, 2121976.00),
  ('tc02a7ff88e48', 'kas_keluar', '2026-11-02', 'CO-2611-0063', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'roster', 0.00, 540000.00),
  ('tb67755cdfb81', 'kas_keluar', '2026-11-02', 'CO-2611-0064', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'kolo, koas, sealent', 0.00, 789000.00),
  ('tadb88a4a7fac', 'kas_keluar', '2026-11-02', 'CO-2611-0065', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'primafix wall finish', 0.00, 658800.00),
  ('t26b1205a09d4', 'kas_keluar', '2026-11-02', 'CO-2611-0066', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'cat plafond antapani', 0.00, 462000.00),
  ('tfa131f2fca65', 'kas_keluar', '2026-11-02', 'CO-2611-0067', 'Kas Besar', 'Biaya Upah2', 'Proyek Antapani', '', 'kang bersih', 0.00, 500000.00),
  ('t487da7f12560', 'kas_keluar', '2026-11-02', 'CO-2611-0068', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'DP pemasangan AC', 0.00, 6500000.00),
  ('t771fc21b1fe2', 'kas_keluar', '2026-11-02', 'CO-2611-0069', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'cat PL', 0.00, 3060000.00),
  ('tdf776c0c1c1c', 'kas_keluar', '2026-11-02', 'CO-2611-0070', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'granit PL selasar', 0.00, 34171200.00),
  ('tfd419611b5e6', 'kas_keluar', '2026-11-02', 'CO-2611-0071', 'Kas Besar', 'Biaya ADM', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'termen PL', 0.00, 2502500.00),
  ('t442ccfc4da10', 'kas_keluar', '2026-11-02', 'CO-2611-0072', 'Kas Besar', 'Biaya ADM', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'adm pencairan PL', 0.00, 636000.00),
  ('td67e53ad7ac7', 'kas_keluar', '2026-11-02', 'CO-2611-0073', 'Kas Besar', 'Biaya Upah', 'KNMP Pekalongan', '', 'pekalongan', 0.00, 500000000.00),
  ('t6434c5f58104', 'kas_keluar', '2026-11-02', 'CO-2611-0074', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'pasir pasang', 0.00, 12400000.00),
  ('t77bcf3c2a8d5', 'kas_keluar', '2026-11-02', 'CO-2611-0075', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'cat pt srijaya 7/9', 0.00, 7192800.00),
  ('t29bb3d229644', 'kas_keluar', '2026-11-02', 'CO-2611-0076', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'cat pt srijaya 8/9', 0.00, 6031740.00),
  ('t2302e71a0cec', 'kas_keluar', '2026-11-02', 'CO-2611-0077', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'cat pt srijaya 14/9', 0.00, 927960.00),
  ('t3c88134d3d3e', 'kas_keluar', '2026-11-02', 'CO-2611-0078', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'semen, bata ringan', 0.00, 4277500.00),
  ('tdd90d4ac7ac6', 'kas_keluar', '2026-11-02', 'CO-2611-0079', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'etoll', 0.00, 200000.00),
  ('t6dd6892e2a41', 'kas_keluar', '2026-11-02', 'CO-2611-0080', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'keramik wc', 0.00, 1088100.00),
  ('t9e3602ddd0d6', 'kas_keluar', '2026-11-02', 'CO-2611-0081', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kloset 15 set', 0.00, 25953000.00),
  ('ta03c83bed776', 'kas_keluar', '2026-11-02', 'CO-2611-0082', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'listrik', 0.00, 203000.00),
  ('tcacb018fe0cb', 'kas_keluar', '2026-11-02', 'CO-2611-0083', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'dempul, paku beton, perekat baja dll', 0.00, 913500.00),
  ('ta9f3651e3bd3', 'kas_keluar', '2026-11-02', 'CO-2611-0084', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'list, bending', 0.00, 4502500.00),
  ('tdf928f6eecc4', 'kas_keluar', '2026-11-02', 'CO-2611-0085', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon idang pasir', 0.00, 5000000.00),
  ('t3c32ae97f82d', 'kas_keluar', '2026-11-02', 'CO-2611-0086', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'floordereein', 0.00, 120000.00),
  ('t9cb2c5427703', 'kas_keluar', '2026-11-02', 'CO-2611-0087', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'vsock, dempul, dll', 0.00, 83500.00),
  ('tee9337aa5d14', 'kas_keluar', '2026-11-02', 'CO-2611-0088', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Bangun Rumdis Cimahi', '', 'op andri brigif & arhanud 31/10', 0.00, 325000.00),
  ('t964e776a950c', 'kas_keluar', '2026-11-02', 'CO-2611-0089', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kunci dan engsel', 0.00, 13987792.00),
  ('te899e5940d78', 'kas_keluar', '2026-11-02', 'CO-2611-0090', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'kekurangan upah', 0.00, 1225000.00),
  ('t8bb3b6fa224e', 'kas_keluar', '2026-11-02', 'CO-2611-0091', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Korem Cirebon', '', 'cat pt srijaya 8/9', 0.00, 7201680.00),
  ('te075ba4bdce2', 'kas_keluar', '2026-11-02', 'CO-2611-0092', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Kodim Cirebon', '', 'cat pt srijaya 8/9', 0.00, 4495500.00),
  ('t6d7f3d4bd5b2', 'kas_keluar', '2026-11-02', 'CO-2611-0093', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Korem Cirebon', '', 'cat pt srijaya 9/9', 0.00, 11688300.00),
  ('t1a275af18cf1', 'kas_keluar', '2026-11-02', 'CO-2611-0094', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Korem Cirebon', '', 'cat pt srijaya 11/9', 0.00, 1152440.00),
  ('t7f3d1f8a3d2f', 'kas_keluar', '2026-11-02', 'CO-2611-0095', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'pasir cor, beskos subang', 0.00, 7500000.00),
  ('td4c1b61ae8fc', 'kas_keluar', '2026-11-02', 'CO-2611-0096', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'pengecoran subang', 0.00, 1000000.00),
  ('t347cc637e4cf', 'kas_keluar', '2026-11-02', 'CO-2611-0097', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'nota adi mekar jaya', 0.00, 5645000.00),
  ('t460815f7722e', 'kas_keluar', '2026-11-02', 'CO-2611-0098', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Bangun Rumdis Bogor', '', 'op andri ke bogor kirim pintu 30/10', 0.00, 751500.00),
  ('t57ecc77bb7fb', 'kas_keluar', '2026-11-02', 'CO-2611-0099', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Bogor', '', 'kasbon tk plafond', 0.00, 4000000.00),
  ('tf5410f0ca2c6', 'kas_keluar', '2026-11-02', 'CO-2611-0100', 'Kas Besar', 'Biaya Upah', 'Zidam Renov Rumdis Bogor', '', 'sisa progres 60%', 0.00, 27023603.00),
  ('ta8397e9a0814', 'kas_keluar', '2026-11-02', 'CO-2611-0101', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'Nota TB subur jaya', 0.00, 24267500.00),
  ('t465fb3d09341', 'kas_keluar', '2026-11-02', 'CO-2611-0102', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'contoh cat kolom', 0.00, 513000.00),
  ('t3638ee4e7fd4', 'kas_keluar', '2026-11-02', 'CO-2611-0103', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'contoh cat kolom pertama', 0.00, 515000.00),
  ('t2afa976dc03e', 'kas_keluar', '2026-11-02', 'CO-2611-0104', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'mob beko', 0.00, 1500000.00),
  ('tf2598551944e', 'kas_keluar', '2026-11-02', 'CO-2611-0105', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'baja ringan, paku beton', 0.00, 3304000.00),
  ('te0a4ef3c3ef9', 'kas_keluar', '2026-11-02', 'CO-2611-0106', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Zidam Rehab Rumdis Cimahi', '', 'op andri brigif & arhanud 31/10', 0.00, 325000.00),
  ('te73518fa11f0', 'kas_keluar', '2026-11-02', 'CO-2611-0107', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'semen', 0.00, 9200000.00),
  ('tf8088d826786', 'kas_keluar', '2026-11-02', 'CO-2611-0108', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'pasir pasang', 0.00, 2400000.00),
  ('t74988e2d47c9', 'kas_keluar', '2026-11-02', 'CO-2611-0109', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'material gudang utara (pinyi selot, kawat beton dll)', 0.00, 945000.00),
  ('tea9604190f8f', 'kas_keluar', '2026-11-02', 'CO-2611-0110', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'paku, kloset, keramik, dll', 0.00, 922000.00),
  ('ta5cd357b64e8', 'kas_keluar', '2026-11-02', 'CO-2611-0111', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'solar 40 L', 0.00, 400000.00),
  ('t009924974a4b', 'kas_keluar', '2026-11-02', 'CO-2611-0112', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'buang sampah gudang utara 3 rit', 0.00, 900000.00),
  ('t252a8647307c', 'kas_masuk', '2026-11-02', 'CI-2611-0001', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 2 november', 1050774444.00, 0.00);
