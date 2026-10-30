-- Sinkronisasi 30 Oktober 2026.
--
-- 87 transaksi baru (lihat INSERT transactions di bawah).
-- 1 vendor baru: V-HU-Rajawali (Hutang Dagang Rp10.107.660, voucher JU26100145,
--   dikonfirmasi dari Detail Jurnal: Debit 5.1.01 Biaya Bahan / Kredit 2.1.1 Hutang Dagang).
-- 1 relasi Piutang Karyawan baru: PK-Komeng (kasbon Rp5.000.000 pada CO-2610-1206,
--   dicicil Rp300.000 pada CI-2610-0036 -> sisa Rp4.700.000, sesuai Data Piutang).
-- 1 relasi Prive diberi lewat pencocokan nominal persis dengan delta Data Prive:
--  - CO-2610-1587 'kasbon nani' Rp900.000 -> Pr-I (delta persis; 'kasbon nani' selalu
--    Pr-I pada setiap kemunculan sebelumnya)
--
-- Penyesuaian NYATA (bukan normalisasi spasi) pada transaksi lama:
--  - CO-2610-1206: akun lawan 'Biaya Gaji Pegawai' -> 'Piutang Karyawan' (laporan baru
--    menunjukkan ini kasbon, bukan gaji) + relasi 'PK-Komeng'
--  - 6x akun lawan 'Biaya Gaji Pegawai' -> 'Cadangan THR' (CO-2608-0097/0099/0100,
--    CO-2609-0130/0132)
--  - 11x koreksi nama project 'Kodim Bogor' -> 'Kemhan Kodim Kab. Bogor' (sama
--    seperti pola 'Kodim X' -> 'Kemhan Kodim X' pada sync 29 Oktober -- CATATAN:
--    ini kembali membuka gap Master Project yang sama seperti audit sebelumnya
--    (9 project di transaksi tidak match nama Master Project manapun, Rp5.42M+
--    biaya hilang dari dashboard) untuk 'Kemhan Kodim Kab. Bogor' -- user sudah
--    menjawab 'jangan' untuk perbaikan Master Project itu, jadi TIDAK disentuh di
--    sini. Transaksi-level rename ini tetap diterapkan karena itu literal data dari
--    laporan sumber (sama seperti perlakuan koreksi lain), tapi perlu direview lagi
--    kapan-kapan kalau user mau menyelesaikan gap Master Project secara menyeluruh.
--
-- Jurnal Umum baru:
--  - JU26100145 (V-HU-Rajawali, lihat atas) -- 2 baris: Biaya Bahan debit /
--    Hutang Dagang kredit, masing-masing Rp10.107.660, sesuai Detail Jurnal.
--  - JU26100146 'belanja dapur tgl 11-25 oktober' Rp78.012.610 -- laporan Jurnal
--    Umum hanya memberi total yang balance (Debit=Kredit), TIDAK memberi rincian
--    akun per baris seperti voucher 'belanja dapur' sebelumnya yang biasa dipecah
--    Biaya Bahan + Biaya Akomodasi (debit) vs Biaya Dibayar Dimuka (kredit).
--    DIBUAT SEMENTARA sebagai 1 baris Biaya Bahan debit / Biaya Dibayar Dimuka
--    kredit (tidak mempengaruhi Kas Masuk/Keluar/Hutang/Piutang/Prive yang sudah
--    diverifikasi) -- BELUM DIKONFIRMASI lewat Detail Jurnal, mohon dicek lagi
--    rincian pecahannya kalau ada.
--
-- Vendor baru ditambahkan ke master data (lihat INSERT vendors di bawah, guarded
-- dengan WHERE NOT EXISTS supaya aman dijalankan ulang).

UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2607-0387' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2607-0536' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2608-0088' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2608-0349' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2608-0642' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2608-0872' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2609-0037' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2609-0835' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2609-1181' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2609-1295' AND `project` = 'Kodim Bogor';
UPDATE `transactions` SET `project` = 'Kemhan Kodim Kab. Bogor' WHERE `ref` = 'CO-2610-1537' AND `project` = 'Kodim Bogor';

UPDATE `transactions` SET `akun_lawan` = 'Cadangan THR' WHERE `ref` = 'CO-2608-0097' AND `akun_lawan` = 'Biaya Gaji Pegawai';
UPDATE `transactions` SET `akun_lawan` = 'Cadangan THR' WHERE `ref` = 'CO-2608-0099' AND `akun_lawan` = 'Biaya Gaji Pegawai';
UPDATE `transactions` SET `akun_lawan` = 'Cadangan THR' WHERE `ref` = 'CO-2608-0100' AND `akun_lawan` = 'Biaya Gaji Pegawai';
UPDATE `transactions` SET `akun_lawan` = 'Cadangan THR' WHERE `ref` = 'CO-2609-0130' AND `akun_lawan` = 'Biaya Gaji Pegawai';
UPDATE `transactions` SET `akun_lawan` = 'Cadangan THR' WHERE `ref` = 'CO-2609-0132' AND `akun_lawan` = 'Biaya Gaji Pegawai';
UPDATE `transactions` SET `akun_lawan` = 'Piutang Karyawan', `relasi` = 'PK-Komeng' WHERE `ref` = 'CO-2610-1206' AND `akun_lawan` = 'Biaya Gaji Pegawai';
UPDATE `transactions` SET `relasi` = 'PK-Komeng' WHERE `ref` = 'CI-2610-0036' AND `relasi` = '';

INSERT INTO `vendors` (`id`, `kode`, `nama`)
SELECT CONCAT('v', SUBSTRING(MD5(RAND()), 1, 12)), 'V-HU-Rajawali', 'V-HU-Rajawali'
FROM (SELECT 1) AS dummy
WHERE NOT EXISTS (SELECT 1 FROM `vendors` WHERE `nama` = 'V-HU-Rajawali');

INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('j_new_JU26100145_d', '2026-10-30', 'JU26100145', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', 'V-HU-Rajawali', 'Bahan', '', 'posted', 'sanlex interior pro wall paint (30/10) #rajawali', 10107660.00, 0.00),
  ('j_new_JU26100145_k', '2026-10-30', 'JU26100145', 'Hutang Dagang', 'PUPR Bangun Satpol PP Sumedang', 'V-HU-Rajawali', '', '', 'posted', 'sanlex interior pro wall paint (30/10) #rajawali', 0.00, 10107660.00),
  ('j_new_JU26100146_d', '2026-10-30', 'JU26100146', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'Bahan', '', 'posted', 'belanja dapur tgl 11-25 oktober (SPLIT BELUM DIKONFIRMASI)', 78012610.00, 0.00),
  ('j_new_JU26100146_k', '2026-10-30', 'JU26100146', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', '', '', 'posted', 'belanja dapur tgl 11-25 oktober (SPLIT BELUM DIKONFIRMASI)', 0.00, 78012610.00);

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t8d34fd848edb', 'bank_keluar', '2026-10-30', 'BO-2610-0038', 'Bank BNI PT', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 30 oktober', 0.00, 311165328.00),
  ('t4bb2e26e77c3', 'bank_keluar', '2026-10-30', 'BO-2610-0039', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 30 oktober', 0.00, 556095672.00),
  ('t55c08fa7704f', 'bank_masuk', '2026-10-30', 'BI-2610-0018', 'Bank BJB RC Prakasa', 'Hutang Bank Jk.Pendek PT', 'Cost Center - Pendanaan Uang', '', 'kelayakan KNMP cibalong ke 2', 3131887500.00, 0.00),
  ('t99b50a144050', 'kas_keluar', '2026-10-30', 'CO-2610-1577', 'Kas Besar', 'Biaya Operasional', 'Farm Cibeureum periode 6', '', 'kas fahri cbr (bensin isop, bensin blade, vaksin, dll)', 0.00, 232000.00),
  ('t5b708547c8df', 'kas_keluar', '2026-10-30', 'CO-2610-1578', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 1 periode 5', '', 'kas fahri clm 1 (gas, bensin, maman, bensin nanang, batre dll)', 0.00, 164000.00),
  ('t902ee3cef0d8', 'kas_keluar', '2026-10-30', 'CO-2610-1579', 'Kas Besar', 'Biaya Operasional', 'Farm Cilame 1 periode 5', '', 'kas fahri cilame 1 (solar genset)', 0.00, 588000.00),
  ('tf0c88fe74179', 'kas_keluar', '2026-10-30', 'CO-2610-1580', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin zenix 30/10', 0.00, 500000.00),
  ('te5cd9c2a654c', 'kas_keluar', '2026-10-30', 'CO-2610-1581', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'service mobil dadan', 0.00, 700000.00),
  ('t00e64f018818', 'kas_keluar', '2026-10-30', 'CO-2610-1582', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'biaya materai cek (RC PT BJB)', 0.00, 10000.00),
  ('t25b8c0325188', 'kas_keluar', '2026-10-30', 'CO-2610-1583', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya firecash', 0.00, 35000.00),
  ('t891576264441', 'kas_keluar', '2026-10-30', 'CO-2610-1584', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'berobat pak zam 30/10', 0.00, 201136.00),
  ('te6a98c2b1781', 'kas_keluar', '2026-10-30', 'CO-2610-1585', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'makan tasik pak zamzam', 0.00, 95000.00),
  ('tf36cd5478569', 'kas_keluar', '2026-10-30', 'CO-2610-1586', 'Kas Besar', 'Biaya Bahan', 'BJB Rehab Rumdis Caringin', '', 'bahan caringin', 0.00, 342000.00),
  ('td01ccd7220df', 'kas_keluar', '2026-10-30', 'CO-2610-1587', 'Kas Besar', 'Prive', 'Prive', 'Pr-I', 'kasbon nani', 0.00, 900000.00),
  ('tfe0eb1a98dce', 'kas_keluar', '2026-10-30', 'CO-2610-1588', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'bayaran komeng 23-29okt', 0.00, 918500.00),
  ('t586543475563', 'kas_keluar', '2026-10-30', 'CO-2610-1589', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'termen ke 3 2 perusahaan', 0.00, 4000000.00),
  ('t181e3253e24d', 'kas_keluar', '2026-10-30', 'CO-2610-1590', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'jamhar PT prakasa purba', 0.00, 31164000.00),
  ('t2867ace81ec7', 'kas_keluar', '2026-10-30', 'CO-2610-1591', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'jamhar PT restu ibu', 0.00, 32851000.00),
  ('tbffc02dceffc', 'kas_keluar', '2026-10-30', 'CO-2610-1592', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'kasbon pak fuji', 0.00, 20000000.00),
  ('t3facaab51f7e', 'kas_keluar', '2026-10-30', 'CO-2610-1593', 'Kas Besar', 'Biaya Bahan', 'RS Guntur Gudang Farmasi', '', 'pasir pasang', 0.00, 1500000.00),
  ('tb704e3c791aa', 'kas_keluar', '2026-10-30', 'CO-2610-1594', 'Kas Besar', 'Biaya Upah', 'RS Guntur Gudang Farmasi', '', 'kasbon h. dana', 0.00, 35000000.00),
  ('tc32a2b82dcfe', 'kas_keluar', '2026-10-30', 'CO-2610-1595', 'Kas Besar', 'Biaya Upah', 'Tugu TNI', '', 'kasbon ervan', 0.00, 15000000.00),
  ('t9793a3383eb3', 'kas_keluar', '2026-10-30', 'CO-2610-1596', 'Kas Besar', 'Biaya Upah', 'Kemhan Kodim Kab Cianjur', '', 'kodim cianjur', 0.00, 55461740.00),
  ('t63c97cc3ad8c', 'kas_keluar', '2026-10-30', 'CO-2610-1597', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan Kodim Kab Cianjur', '', 'OP direksi ke kodim cianjur 20/10', 0.00, 537050.00),
  ('t352c250f6b3b', 'kas_keluar', '2026-10-30', 'CO-2610-1598', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan Kodim Kab Cianjur', '', 'OP direksi ke kodim cianjur 20/10', 0.00, 875410.00),
  ('ted9d92bbb392', 'kas_keluar', '2026-10-30', 'CO-2610-1599', 'Kas Besar', 'Biaya ADM Fee', 'Zidam Rehab Gudkesrah', '', 'dako', 0.00, 27462168.00),
  ('tdbdb14cf7541', 'kas_keluar', '2026-10-30', 'CO-2610-1600', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Gudkesrah', '', 'kasbon h dana', 0.00, 2500000.00),
  ('t0b9f1989d3cd', 'kas_keluar', '2026-10-30', 'CO-2610-1601', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 30', 0.00, 4500000.00),
  ('t838fd7e53c1e', 'kas_keluar', '2026-10-30', 'CO-2610-1602', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas dadan (servis motor, adm brilink, lampu panter, baud panter)', 0.00, 880000.00),
  ('t44d741d36ece', 'kas_keluar', '2026-10-30', 'CO-2610-1603', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'service beko', 0.00, 2794980.00),
  ('tdeafc82626db', 'kas_keluar', '2026-10-30', 'CO-2610-1604', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim urugan 2 minggu', 0.00, 4200000.00),
  ('t535bd4911ab9', 'kas_keluar', '2026-10-30', 'CO-2610-1605', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim jaga alat 23-29 Okt', 0.00, 1400000.00),
  ('te7ddf4f07dab', 'kas_keluar', '2026-10-30', 'CO-2610-1606', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bambu', 0.00, 150000.00),
  ('td89195d2314b', 'kas_keluar', '2026-10-30', 'CO-2610-1607', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim garut 23-29 Okt', 0.00, 5798000.00),
  ('t0c7ba20c0590', 'kas_keluar', '2026-10-30', 'CO-2610-1608', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'upah mang wawan operator', 0.00, 1990000.00),
  ('t6e7b93a1fa8c', 'kas_keluar', '2026-10-30', 'CO-2610-1609', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'pelunasan handrail', 0.00, 15955000.00),
  ('t51e228cd06ad', 'kas_keluar', '2026-10-30', 'CO-2610-1610', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon pak nanang', 0.00, 3000000.00),
  ('tc62756018222', 'kas_keluar', '2026-10-30', 'CO-2610-1611', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'bayaran pekerja 23-29 Okt', 0.00, 9582000.00),
  ('t4fb5edd62446', 'kas_keluar', '2026-10-30', 'CO-2610-1612', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'RS Dustira Bangun Ruang Kenanga', '', 'OP pa fahri ke cimahi - sumedang 26/10', 0.00, 405200.00),
  ('tc3034aed797f', 'kas_keluar', '2026-10-30', 'CO-2610-1613', 'Kas Besar', 'Biaya Upah', 'Proyek Antapani', '', 'bayaran pekerja 23-29 okt', 0.00, 3210000.00),
  ('tb51e080ccd6c', 'kas_keluar', '2026-10-30', 'CO-2610-1614', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'bajaringan, baud baja, roofing', 0.00, 1060000.00),
  ('tdc2bfad3fd1d', 'kas_keluar', '2026-10-30', 'CO-2610-1615', 'Kas Besar', 'Biaya Upah2', 'Proyek Antapani', '', 'upah tim anto', 0.00, 578700.00),
  ('ta4c60ab90ee8', 'kas_keluar', '2026-10-30', 'CO-2610-1616', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'KNMP Cibalong', '', 'biaya firecash dan rtgs', 0.00, 135000.00),
  ('tcda142a38618', 'kas_keluar', '2026-10-30', 'CO-2610-1617', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'KNMP Pekalongan', '', 'Op direksi ke KNMP pekalongan 26/10', 0.00, 2106500.00),
  ('t1866ac12842d', 'kas_keluar', '2026-10-30', 'CO-2610-1618', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Brigif kujang', '', 'OP pa fahri ke brigif 15 kujang 29/10', 0.00, 484000.00),
  ('tce9469d56deb', 'kas_keluar', '2026-10-30', 'CO-2610-1619', 'Kas Besar', 'Biaya Upah', 'Brigif kujang', '', 'kasbon H dana', 0.00, 9000000.00),
  ('tb2612997b30e', 'kas_keluar', '2026-10-30', 'CO-2610-1620', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Armed', '', 'OP pak zamzam armed 19/10', 0.00, 274000.00),
  ('t71145837968a', 'kas_keluar', '2026-10-30', 'CO-2610-1621', 'Kas Besar', 'Biaya Upah', 'Armed', '', 'kasbon h dana', 0.00, 18000000.00),
  ('tb4eabc1506d4', 'kas_keluar', '2026-10-30', 'CO-2610-1622', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Armed', '', 'OP direksi ke pusdik armed 19/10', 0.00, 889200.00),
  ('t55115aa101e2', 'kas_keluar', '2026-10-30', 'CO-2610-1623', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'bensin bayu', 0.00, 90000.00),
  ('tff9d03929c22', 'kas_keluar', '2026-10-30', 'CO-2610-1624', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'upah muat genteng', 0.00, 200000.00),
  ('t5a77ea929bb8', 'kas_keluar', '2026-10-30', 'CO-2610-1625', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kasbon tim listrik pak nanang', 0.00, 3000000.00),
  ('t1aeb553d2fae', 'kas_keluar', '2026-10-30', 'CO-2610-1626', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'kasbon tim cat dani', 0.00, 15000000.00),
  ('t07e66de0fa9b', 'kas_keluar', '2026-10-30', 'CO-2610-1627', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', 'kasbon septian kopel 1 - 5', 0.00, 41075548.00),
  ('ta4808e23ad53', 'kas_keluar', '2026-10-30', 'CO-2610-1628', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Subang', '', 'pengawas', 0.00, 18000000.00),
  ('t5dfb62fdd12d', 'kas_keluar', '2026-10-30', 'CO-2610-1629', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'sepatu boot', 0.00, 550000.00),
  ('ta979ede5f17a', 'kas_keluar', '2026-10-30', 'CO-2610-1630', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'bahan kusen tim egi', 0.00, 1484344.00),
  ('tf6a9b78b61f7', 'kas_keluar', '2026-10-30', 'CO-2610-1631', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim plafon asep', 0.00, 2500000.00),
  ('t4d76b6026de1', 'kas_keluar', '2026-10-30', 'CO-2610-1632', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon pekerja tambahan tim m. zek', 0.00, 2500000.00),
  ('t0563af94951e', 'kas_keluar', '2026-10-30', 'CO-2610-1633', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'bayaran pekerja 23-29 okt', 0.00, 35139000.00),
  ('t060f72944934', 'kas_keluar', '2026-10-30', 'CO-2610-1634', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon egi', 0.00, 19000000.00),
  ('t86aaabd0e543', 'kas_keluar', '2026-10-30', 'CO-2610-1635', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kain majun, roskam pvc, paku', 0.00, 251500.00),
  ('t604df4e65b7d', 'kas_keluar', '2026-10-30', 'CO-2610-1636', 'Kas Besar', 'Biaya ADM Fee', 'ZIDAM Bangun Rumdis Pangandaran', '', 'dako', 0.00, 32119400.00),
  ('te0f1ba0a1566', 'kas_keluar', '2026-10-30', 'CO-2610-1637', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'ritase uang lintas dll jalan subang', 0.00, 2100000.00),
  ('t7cf54fd2671c', 'kas_keluar', '2026-10-30', 'CO-2610-1638', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'kasbon septian julan subang', 0.00, 10000000.00),
  ('t7f24d46a9545', 'kas_keluar', '2026-10-30', 'CO-2610-1639', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'bensin pompa', 0.00, 200000.00),
  ('t2030c248fd95', 'kas_keluar', '2026-10-30', 'CO-2610-1640', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'flagman', 0.00, 5600000.00),
  ('tf6ba6858041f', 'kas_keluar', '2026-10-30', 'CO-2610-1641', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan babinsa dll', 0.00, 1500000.00),
  ('t2d51306a3fc2', 'kas_keluar', '2026-10-30', 'CO-2610-1642', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan zipur', 0.00, 1500000.00),
  ('te030fe1d3385', 'kas_keluar', '2026-10-30', 'CO-2610-1643', 'Kas Besar', 'Biaya Upah', 'Bina Marga Rehab Jembatan Provinsi', '', 'asep yudi', 0.00, 11500000.00),
  ('t4b5198f4a3a9', 'kas_keluar', '2026-10-30', 'CO-2610-1644', 'Kas Besar', 'Biaya Upah3', 'Bina Marga Rehab Jembatan Provinsi', '', 'jaga pancang', 0.00, 600000.00),
  ('t0e8cf5b2baa7', 'kas_keluar', '2026-10-30', 'CO-2610-1645', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'matrial alam', 0.00, 21700000.00),
  ('t331f1ab510df', 'kas_keluar', '2026-10-30', 'CO-2610-1646', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Bogor', '', 'reimburse hamdan (obat, bensin)', 0.00, 86803.00),
  ('t1ebd90da885e', 'kas_keluar', '2026-10-30', 'CO-2610-1647', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Bogor', '', 'reimburse hamdan (siku, meteran)', 0.00, 85000.00),
  ('t21e81d5b3d96', 'kas_keluar', '2026-10-30', 'CO-2610-1648', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Bogor', '', 'sisa progres 60%', 0.00, 24352004.00),
  ('t5f2a5b3444b9', 'kas_keluar', '2026-10-30', 'CO-2610-1649', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'bayaran pekerja 23-29 okt', 0.00, 28822500.00),
  ('t60c5e561f2c8', 'kas_keluar', '2026-10-30', 'CO-2610-1650', 'Kas Besar', 'Biaya Upah', 'PUPR Bangun Satpol PP Sumedang', '', 'kasbon h dana', 0.00, 80000000.00),
  ('te2b1cab44d17', 'kas_keluar', '2026-10-30', 'CO-2610-1651', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'PUPR Bangun Satpol PP Sumedang', '', 'op pa fahri ke cimahi - sumedang 28/10', 0.00, 712192.00),
  ('td548fe8debef', 'kas_keluar', '2026-10-30', 'CO-2610-1652', 'Kas Besar', 'Biaya Upah3', 'Zidam Rehab Rumdis Cimahi', '', 'bayaran pekerja 23-29 okt', 0.00, 31780625.00),
  ('tcfcc473de9ed', 'kas_keluar', '2026-10-30', 'CO-2610-1653', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'semen, arco, skrup', 0.00, 3832500.00),
  ('t9612b62efce9', 'kas_keluar', '2026-10-30', 'CO-2610-1654', 'Kas Besar', 'Biaya Upah2', 'Zidam Rehab Rumdis Cimahi', '', 'kasbon tim plafon', 0.00, 1500000.00),
  ('te1ea293928e9', 'kas_keluar', '2026-10-30', 'CO-2610-1655', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'pasir pasang', 0.00, 2050000.00),
  ('t35460fa92d45', 'kas_keluar', '2026-10-30', 'CO-2610-1656', 'Kas Besar', 'Biaya Upah2', 'Zidam Rehab Rumdis Cimahi', '', 'kasbon anto bajaringan', 0.00, 5000000.00),
  ('t3442d39a4a55', 'kas_keluar', '2026-10-30', 'CO-2610-1657', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'pompa alkon + selang', 0.00, 6300000.00),
  ('taa9869864500', 'kas_keluar', '2026-10-30', 'CO-2610-1658', 'Kas Besar', 'Kendaraan', 'Cost Center', '', 'motor', 0.00, 25800000.00),
  ('tab83cbc87116', 'kas_masuk', '2026-10-30', 'CI-2610-0036', 'Kas Besar', 'Piutang Karyawan', 'Cost Center - Pendanaan Uang', '', 'cicilan kasbon komeng', 300000.00, 0.00),
  ('t7f1fcbad2c09', 'kas_masuk', '2026-10-30', 'CI-2610-0037', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 30 oktober', 867261000.00, 0.00);
