-- Sinkronisasi dari Report export terbaru (s/d 13 Oktober 2026),
-- dibandingkan ref-by-ref terhadap database yang sudah mencakup
-- sync_transactions_okt8_2026.sql, sync_transactions_okt9_2026.sql,
-- sync_transactions_okt9_lanjutan_2026.sql, DAN sync_transactions_okt12_2026.sql
-- (jalankan file ini SETELAH keempatnya -- semuanya INSERT IGNORE /
-- UPDATE idempotent, aman dijalankan ulang kapan saja).
--
-- Ditemukan 48 transaksi baru (13 Oktober 2026, termasuk 1 pasangan
-- penarikan loan Bank BJB RC Prakasa -> Kas Besar BO-2610-0015/CI-2610-0015)
-- dan 4 penyesuaian pada transaksi yang sudah ada (reklasifikasi
-- project/akun, dan 1 nota yang ternyata dibagi 3 lokasi -- jumlahnya sudah
-- dicek pas dengan total aslinya: 2.832.572 + 2.832.572 + 4.248.856 =
-- 9.914.000). Jurnal Umum sudah 100% sinkron (0 baru, 0 hilang, 0 beda nilai),
-- tidak ada perubahan di sana.
--
-- Diverifikasi end-to-end: Dashboard Cash Flow hasil index.html atas dataset
-- ini (Kas Masuk 76.742.410.241 / Kas Keluar 71.635.880.200 / Saldo Akhir
-- 5.504.453.049) sama persis dengan Dashboard Cash Flow sistem asli.
--
-- Data yang sudah benar (Trial Balance, Neraca, Laba Rugi, Hutang, Prive,
-- logika index.html) tidak disentuh sama sekali oleh file ini.

-- 48 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('tdff97afc5f03', 'bank_keluar', '2026-10-13', 'BO-2610-0015', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 13 oktober', 0.00, 322607290.00),
  ('t48878082a907', 'kas_masuk', '2026-10-13', 'CI-2610-0015', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 13 oktober', 322607290.00, 0.00),
  ('tba8c27997593', 'kas_keluar', '2026-10-01', 'CO-2610-0606', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 2 periode 5', '', 'Bayar nota MAT 9.914.000 (kawat las, bolt nut, mata bor, cutting resibon, resibon, blower) 4/8 - 14/9 (dibagi 3 lokasi)', 0.00, 2832572.00),
  ('tf3ddfd9fcad6', 'kas_keluar', '2026-10-01', 'CO-2610-0607', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'Bayar nota MAT 9.914.000 (kawat las, bolt nut, mata bor, cutting resibon, resibon, blower) 4/8 - 14/9 (dibagi 3 lokasi)', 0.00, 4248856.00),
  ('t95b05c0e837c', 'kas_keluar', '2026-10-13', 'CO-2610-0608', 'Kas Besar', 'Biaya Cuci Kandang', 'Farm Cilame 2 periode 6', '', 'soda api, cilame 2 (10/10)', 0.00, 840000.00),
  ('t23c73ee6af0b', 'kas_keluar', '2026-10-13', 'CO-2610-0609', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 2 periode 5', '', 'paket, cilame 2', 0.00, 15000.00),
  ('t3d103f42be57', 'kas_keluar', '2026-10-13', 'CO-2610-0610', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 2 periode 5', '', 'upah warga bantu langsr sekam, cilame 2', 0.00, 312000.00),
  ('te6d0baf4c47d', 'kas_keluar', '2026-10-13', 'CO-2610-0611', 'Kas Besar', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', 'upah tangkap, pikul pakan dan briket cibeureum', 0.00, 1512220.00),
  ('tf881a17d2c89', 'kas_keluar', '2026-10-13', 'CO-2610-0612', 'Kas Besar', 'Hutang lancar Lainnya', 'Farm Cibeureum periode 5', '', 'uang nimbang cibeureum', 0.00, 1000000.00),
  ('t582416391ef4', 'kas_keluar', '2026-10-13', 'CO-2610-0613', 'Kas Besar', 'Biaya Gaji Pegawai', 'Farm Cibeureum periode 6', '', 'kasbon ab cibeureum a.n Fadli', 0.00, 1000000.00),
  ('t80877a3fee91', 'kas_keluar', '2026-10-13', 'CO-2610-0614', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (10/10)', 0.00, 30000.00),
  ('t4805c19a0636', 'kas_keluar', '2026-10-13', 'CO-2610-0615', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (11/10)', 0.00, 30000.00),
  ('te55edf401e80', 'kas_keluar', '2026-10-13', 'CO-2610-0616', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'baud, stim motor, ban, jasa bengkel (9/10)', 0.00, 83000.00),
  ('t3d4ded981a82', 'kas_keluar', '2026-10-13', 'CO-2610-0617', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor (9/10)', 0.00, 10000.00),
  ('t25402ee6bc81', 'kas_keluar', '2026-10-13', 'CO-2610-0618', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin motor', 0.00, 10000.00),
  ('tcadcb3bf9262', 'kas_keluar', '2026-10-13', 'CO-2610-0619', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya trf', 0.00, 35000.00),
  ('t726d5149011a', 'kas_keluar', '2026-10-13', 'CO-2610-0620', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi & batagor (9/10)', 0.00, 32000.00),
  ('t4853fc072f5f', 'kas_keluar', '2026-10-13', 'CO-2610-0621', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'galon', 0.00, 22000.00),
  ('t4dc53232e02a', 'kas_keluar', '2026-10-13', 'CO-2610-0622', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya rtgs', 0.00, 35000.00),
  ('t872ef0bf8d51', 'kas_keluar', '2026-10-13', 'CO-2610-0623', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM rendy', 0.00, 200000.00),
  ('t86bcbd5b822d', 'kas_keluar', '2026-10-13', 'CO-2610-0624', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, beli sate domba & gule (11/10)', 0.00, 87000.00),
  ('t0c15d8c6b265', 'kas_keluar', '2026-10-13', 'CO-2610-0625', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, beli chickeum richeese (11/10)', 0.00, 166000.00),
  ('ta4cf6465e92a', 'kas_keluar', '2026-10-13', 'CO-2610-0626', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab cash', 0.00, 200000.00),
  ('t0a06077c82b5', 'kas_keluar', '2026-10-13', 'CO-2610-0627', 'Kas Besar', 'Prive', 'Prive', '', 'pa rajab, beli baso', 0.00, 90000.00),
  ('t15ebeaeadc89', 'kas_keluar', '2026-10-13', 'CO-2610-0628', 'Kas Besar', 'Prive', 'Prive', '', 'pa zamzam, bu desy beli minyak & lontong (12/10)', 0.00, 78200.00),
  ('t906eeb32ac8e', 'kas_keluar', '2026-10-13', 'CO-2610-0630', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'sewa pompa standard', 0.00, 4002500.00),
  ('tcfa91461dfa0', 'kas_keluar', '2026-10-13', 'CO-2610-0631', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'KNMP', '', 'Biaya trf', 0.00, 37500.00),
  ('t3462f2cd4bc2', 'kas_keluar', '2026-10-13', 'CO-2610-0632', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'cat kusen, bodelac 2 qty (13/10)', 0.00, 2703520.00),
  ('tbbae65aa8de6', 'kas_keluar', '2026-10-13', 'CO-2610-0633', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'pisin 7 inch, piring 9 inch, mangkok', 0.00, 1563360.00),
  ('t0444e8525314', 'kas_keluar', '2026-10-13', 'CO-2610-0634', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 13', 0.00, 4500000.00),
  ('t627a1c632058', 'kas_keluar', '2026-10-13', 'CO-2610-0635', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'semen tb. hemat 720zak', 0.00, 42480000.00),
  ('tc4e49cb1dfad', 'kas_keluar', '2026-10-13', 'CO-2610-0636', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'perekat bata ringan & lisplang (13/10)', 0.00, 629000.00),
  ('t57c2406730d6', 'kas_keluar', '2026-10-13', 'CO-2610-0637', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'primafix wall finish 30pcs', 0.00, 2148821.00),
  ('tddcd0648d424', 'kas_keluar', '2026-10-13', 'CO-2610-0638', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'primafix wall finish 50pcs', 0.00, 3581369.00),
  ('tfbd340a508aa', 'kas_keluar', '2026-10-13', 'CO-2610-0639', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'semen, pvc 12/10', 0.00, 1573200.00),
  ('tf174b8ae21c7', 'kas_keluar', '2026-10-13', 'CO-2610-0640', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon tim usep cat 12/10', 0.00, 2000000.00),
  ('t3b7ef0dab393', 'kas_keluar', '2026-10-13', 'CO-2610-0641', 'Kas Besar', 'Fee Tenaga Ahli', 'Cost Center', '', 'pak boim', 0.00, 5002500.00),
  ('t4e8d0025b691', 'kas_keluar', '2026-10-13', 'CO-2610-0642', 'Kas Besar', 'Biaya Upah', 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai', '', 'rizky (kornel)', 0.00, 55000000.00),
  ('t57cf4cd96204', 'kas_keluar', '2026-10-13', 'CO-2610-0643', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'bahan pipa rucika, lem, keni, dll (13/10)', 0.00, 9210000.00),
  ('t4c80fc0e8512', 'kas_keluar', '2026-10-13', 'CO-2610-0644', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'air galon', 0.00, 504000.00),
  ('t1432ab7b45b7', 'kas_keluar', '2026-10-13', 'CO-2610-0645', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'pasir pasang, dumptruk, beskos', 0.00, 23400000.00),
  ('tde7d87652362', 'kas_keluar', '2026-10-13', 'CO-2610-0646', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'meteran, ember, pahat, dll', 0.00, 1121000.00),
  ('t3b6675cad42c', 'kas_keluar', '2026-10-13', 'CO-2610-0647', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'semen, pipa dll', 0.00, 1573200.00),
  ('td4231d9702f2', 'kas_keluar', '2026-10-13', 'CO-2610-0648', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pvc, keni, dop 1/2 bh, lemkran, perekat bata (13/10)', 0.00, 1481000.00),
  ('t1af31a18b6a7', 'kas_keluar', '2026-10-13', 'CO-2610-0649', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'sekrup gypsum 3 cm, 3 dus (13/10)', 0.00, 393000.00),
  ('t76a7d7d092d0', 'kas_keluar', '2026-10-13', 'CO-2610-0650', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kramik lantai wc', 0.00, 3360000.00),
  ('t71d6b7963fbe', 'kas_keluar', '2026-10-13', 'CO-2610-0651', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'join scaffolding untuk gudang utara (13/10)', 0.00, 555900.00),
  ('tc169173ed14b', 'kas_keluar', '2026-10-13', 'CO-2610-0652', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Koramil Majalengka Maulusma', '', 'pak kuwu maulusma', 0.00, 150000000.00);

-- 4 penyesuaian pada transaksi yang sudah ada
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2609-0761';
UPDATE `transactions` SET `kredit` = 2832572.00 WHERE `ref` = 'CO-2610-0079';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai' WHERE `ref` = 'CO-2610-0271';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2610-0279';

-- Project baru yang direferensikan transaksi 13 Oktober, belum ada di Master Project
INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_farm_cilame_2_periode_6', 'Farm Cilame 2 periode 6', 'Farm Cilame 2 periode 6', 0.00, 0.00, NULL, 'Farm', 0.00, 0.00, NOW());
