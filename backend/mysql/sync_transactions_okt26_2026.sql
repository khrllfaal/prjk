-- Sinkronisasi 26 Oktober 2026.
--
-- 1) 10 penyesuaian keterangan/project pada transaksi lama (ditemukan
-- dari Report terbaru, ref/tanggal sama, nilai TIDAK berubah):
--  - 8 koreksi teks keterangan (detail tambahan: nominal, item, typo).
--  - 2 koreksi project: CO-2608-0861 & CO-2609-0311 "Zidam Brigif 15
--    Zipur" -> "Zidam Rehab Rumdis Cimahi".
--
-- 2) 1 Master Project baru: "Tugu TNI" (dari CO-2610-1393, "ervan",
-- Biaya Upah, Rp10.000.000).
--
-- 3) 8 voucher Jurnal Umum baru (JU26100137 s/d JU26100144), semua
-- V-HU-Nippon, Biaya Bahan / Hutang Dagang -- dikonfirmasi cocok
-- persis dengan 8 popup "Detail Jurnal" dari pemilik.
--
-- 4) 97 transaksi baru (94 Kas Keluar, 2 Kas Masuk, 1 Bank Keluar).
-- 5 relasi diberi lewat pencocokan pola/nominal persis dengan riwayat:
--  - CO-2610-1308 "cicilan beat pak eri" Rp829.440 = CC-Beat (pola +
--    nominal sama persis dengan 2 cicilan CC-Beat sebelumnya).
--  - CO-2610-1309/CO-2610-1320/1321/1322 (ade rana/teh rinrin/pa
--    rajab) = Pr-F / Pr-I / Pr-R / Pr-R (pola nama identik dengan 282
--    transaksi Prive sebelumnya).
--
-- Diverifikasi via Playwright terhadap data yang diberikan owner:
-- Dashboard Cash Flow, Data Hutang (27 vendor), Data Piutang (14
-- customer), Data Prive (5 pemilik) -- SEMUA cocok persis ke rupiah.
-- (Satu catatan: total "sisa" per-nota Hutang Dagang di Trial Hutang/
-- picker Kas Keluar berbeda Rp40.000 dari Neraca TB -- ini BUKAN
-- bug baru, itu efek perbaikan pencocokan tanggal sebelumnya yang
-- membuka 3 kekurangan bayar Rp10rb riil yang dulu tersembunyi di
-- balik FIFO; totalnya sendiri -- Data Hutang per vendor -- cocok
-- 100% persis.)

UPDATE `transactions` SET `ket` = 'DP matrial alam (splite)' WHERE `ref` = 'CO-2607-0812';
UPDATE `transactions` SET `ket` = 'DP ke 2 splite (total 500jt)' WHERE `ref` = 'CO-2607-0903';
UPDATE `transactions` SET `project` = 'Zidam Rehab Rumdis Cimahi' WHERE `ref` = 'CO-2608-0861';
UPDATE `transactions` SET `ket` = 'servis dinamo 2jt' WHERE `ref` = 'CO-2608-0958';
UPDATE `transactions` SET `ket` = 'bubut puly 1.350.000' WHERE `ref` = 'CO-2608-0959';
UPDATE `transactions` SET `project` = 'Zidam Rehab Rumdis Cimahi' WHERE `ref` = 'CO-2609-0311';
UPDATE `transactions` SET `ket` = 'service dinamo 1,8jt' WHERE `ref` = 'CO-2609-0460';
UPDATE `transactions` SET `ket` = 'keramik, wc, kran, kloset 1 set, dll' WHERE `ref` = 'CO-2610-0443';
UPDATE `transactions` SET `ket` = 'kloset 1 set (dari orderan gudkesrah)' WHERE `ref` = 'CO-2610-0540';
UPDATE `transactions` SET `ket` = 'bayaran pesantren al mabur' WHERE `ref` = 'CO-2610-0784';

INSERT IGNORE INTO `projects` (`id`, `nama`, `ledger_name`, `kontrak`, `rap`, `progress`, `pemberi_proyek`, `cost_center`, `adm_fee`, `updated_at`)
VALUES ('p_tugu_tni', 'Tugu TNI', 'Tugu TNI', 0.00, 0.00, NULL, '', 0.00, 0.00, NOW());

INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('j9fd0bf83b668', '2026-10-26', 'JU26100137', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon vinilex pro, nippon platone, nippon stoneshield clear gloss (13/10)', 4912860.00, 0.00),
  ('jec4b3a9e6b1c', '2026-10-26', 'JU26100137', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', '', '', 'posted', 'nippon vinilex pro, nippon platone, nippon stoneshield clear gloss (13/10)', 0.00, 4912860.00),
  ('j8e07bca94167', '2026-10-26', 'JU26100138', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon F8 deef maroon (13/10)', 6293700.00, 0.00),
  ('j8de52428dccb', '2026-10-26', 'JU26100138', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', '', '', 'posted', 'nippon F8 deef maroon (13/10)', 0.00, 6293700.00),
  ('je68450c11d96', '2026-10-26', 'JU26100139', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon vinilex apple white, nippon vinilex s1515 (10/10)', 8965000.00, 0.00),
  ('j54bb621ada14', '2026-10-26', 'JU26100139', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', '', '', 'posted', 'nippon vinilex apple white, nippon vinilex s1515 (10/10)', 0.00, 8965000.00),
  ('jf762b942d299', '2026-10-26', 'JU26100140', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon vinilex pro apple white (9/10)', 3711840.00, 0.00),
  ('jc697cfa5cf05', '2026-10-26', 'JU26100140', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', '', '', 'posted', 'nippon vinilex pro apple white (9/10)', 0.00, 3711840.00),
  ('jb91113163193', '2026-10-26', 'JU26100141', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon vinilex apple white, nippon F8 deef maroon (25/9)', 6940500.00, 0.00),
  ('j7028fa1ae0d6', '2026-10-26', 'JU26100141', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', '', '', 'posted', 'nippon vinilex apple white, nippon F8 deef maroon (25/9)', 0.00, 6940500.00),
  ('j0ecb1ce8a842', '2026-10-26', 'JU26100142', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon stoneshield clear gloss (25/9)', 2851368.00, 0.00),
  ('ja9d87e47f0a5', '2026-10-26', 'JU26100142', 'Hutang Dagang', 'Kemhan Bangun Rumdis Cimahi', 'V-HU-Nippon', '', '', 'posted', 'nippon stoneshield clear gloss (25/9)', 0.00, 2851368.00),
  ('j6767f3c87732', '2026-10-26', 'JU26100143', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon stoneshield clear gloss (2/10)', 300144.00, 0.00),
  ('j777c116245f5', '2026-10-26', 'JU26100143', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', '', '', 'posted', 'nippon stoneshield clear gloss (2/10)', 0.00, 300144.00),
  ('jc8ae385ccfbd', '2026-10-26', 'JU26100144', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', 'Bahan', '', 'posted', 'nippon vinilex pro briliant white (10/10)', 1391940.00, 0.00),
  ('j6f1f92d8dbdb', '2026-10-26', 'JU26100144', 'Hutang Dagang', 'Kemhan Bangun Rumdis Subang', 'V-HU-Nippon', '', '', 'posted', 'nippon vinilex pro briliant white (10/10)', 0.00, 1391940.00);

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('t2ffdea72daec', 'bank_keluar', '2026-10-26', 'BO-2610-0027', 'Bank BJB RC PT', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 26 oktober', 0.00, 451817580.00),
  ('t1b8c7c86b82c', 'kas_keluar', '2026-10-26', 'CO-2610-1301', 'Kas Besar', 'Biaya Pemeliharaan Alat & Kandang', 'Farm Cilame 1 periode 5', '', 'servis motor kandang', 0.00, 1202500.00),
  ('tc216749f4364', 'kas_keluar', '2026-10-26', 'CO-2610-1302', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin', 0.00, 22000.00),
  ('t71a76a5733e1', 'kas_keluar', '2026-10-26', 'CO-2610-1303', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin 24/10', 0.00, 30000.00),
  ('tb5c262e7aeef', 'kas_keluar', '2026-10-26', 'CO-2610-1304', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin 26/10', 0.00, 30000.00),
  ('t3d76d2d00ae8', 'kas_keluar', '2026-10-26', 'CO-2610-1305', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'tambal ban mobil', 0.00, 25000.00),
  ('tc23225549a7b', 'kas_keluar', '2026-10-26', 'CO-2610-1306', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'sparepart servis motor dede', 0.00, 393000.00),
  ('ta8107aa9df89', 'kas_keluar', '2026-10-26', 'CO-2610-1307', 'Kas Besar', 'Biaya Pemeliharaan Kendaraan Kantor', 'Cost Center', '', 'jasa servis motor dede', 0.00, 202500.00),
  ('t5a5091b72fc7', 'kas_keluar', '2026-10-26', 'CO-2610-1308', 'Kas Besar', 'Hutang Pihak Ke-3', 'Cost Center - Pendanaan Uang', 'CC-Beat', 'cicilan beat pak eri', 0.00, 829440.00),
  ('t2dd35936c9d8', 'kas_keluar', '2026-10-26', 'CO-2610-1309', 'Kas Besar', 'Prive', 'Prive', 'Pr-F', 'ade rana (ongkos ke bdg)', 0.00, 1000000.00),
  ('t9a89628d5fcb', 'kas_keluar', '2026-10-26', 'CO-2610-1310', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya trf', 0.00, 35000.00),
  ('ta4819388cdaa', 'kas_keluar', '2026-10-26', 'CO-2610-1311', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'antangin', 0.00, 23000.00),
  ('tf8fbca3d1f04', 'kas_keluar', '2026-10-26', 'CO-2610-1312', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'bajigur', 0.00, 67000.00),
  ('t564788c556a9', 'kas_keluar', '2026-10-26', 'CO-2610-1313', 'Kas Besar', 'Biaya entertain', 'Cost Center', '', 'mangga kiojay 23/7', 0.00, 578000.00),
  ('ta6cfdd8956d4', 'kas_keluar', '2026-10-26', 'CO-2610-1314', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'bubur, tahu', 0.00, 52000.00),
  ('tc31f7bbab6a6', 'kas_keluar', '2026-10-26', 'CO-2610-1315', 'Kas Besar', 'Biaya Rumah Tangga Kantor', 'Cost Center', '', 'kran', 0.00, 5500.00),
  ('tca26cfb29c64', 'kas_keluar', '2026-10-26', 'CO-2610-1316', 'Kas Besar', 'Biaya Pengobatan Direksi', 'Cost Center', '', 'obat', 0.00, 25000.00),
  ('t07530f932d98', 'kas_keluar', '2026-10-26', 'CO-2610-1317', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'nasi, kopi', 0.00, 81000.00),
  ('tea1f02bc8ab4', 'kas_keluar', '2026-10-26', 'CO-2610-1318', 'Kas Besar', 'Biaya ATK & Perlengkapan Kantor', 'Cost Center', '', 'perpanjang claude', 0.00, 401000.00),
  ('td79876a154f2', 'kas_keluar', '2026-10-26', 'CO-2610-1319', 'Kas Besar', 'Biaya Makan Karyawan', 'Cost Center', '', 'UM rendi', 0.00, 200000.00),
  ('t27efb7654a32', 'kas_keluar', '2026-10-26', 'CO-2610-1320', 'Kas Besar', 'Prive', 'Prive', 'Pr-I', 'gaji teh rinrin', 0.00, 1502500.00),
  ('te0200e821ad8', 'kas_keluar', '2026-10-26', 'CO-2610-1321', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'bayar tebus emas MBG (pa rajab)', 0.00, 235173600.00),
  ('t26b05b105eba', 'kas_keluar', '2026-10-26', 'CO-2610-1322', 'Kas Besar', 'Prive', 'Prive', 'Pr-R', 'force lemon, mie baso kota kembang (pak rajab)', 0.00, 143300.00),
  ('t7a9d00cf9583', 'kas_keluar', '2026-10-26', 'CO-2610-1323', 'Kas Besar', 'Biaya Upah', 'Tugu Perkim Cirebon', '', 'fuji', 0.00, 20000000.00),
  ('td63bc690090b', 'kas_keluar', '2026-10-26', 'CO-2610-1324', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Tugu Perkim Cirebon', '', 'OP eri antar mangga', 0.00, 500000.00),
  ('tfe5121db6e7b', 'kas_keluar', '2026-10-26', 'CO-2610-1325', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'semen', 0.00, 182000.00),
  ('t3a9ea97af323', 'kas_keluar', '2026-10-26', 'CO-2610-1326', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', '', 'cat thinner, semen', 0.00, 667000.00),
  ('t4d3a73ba4fe4', 'kas_keluar', '2026-10-26', 'CO-2610-1327', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 24', 0.00, 3500000.00),
  ('t2d3e42d3202a', 'kas_keluar', '2026-10-26', 'CO-2610-1328', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 25', 0.00, 3000000.00),
  ('te5e620e9ac5e', 'kas_keluar', '2026-10-26', 'CO-2610-1329', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 27', 0.00, 14000000.00),
  ('tf028ef3aca91', 'kas_keluar', '2026-10-26', 'CO-2610-1330', 'Kas Besar', 'Biaya Alat Konstruksi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'cicilan loader ke 3 terakhir', 0.00, 83333333.00),
  ('t92e64286f1df', 'kas_keluar', '2026-10-26', 'CO-2610-1331', 'Kas Besar', 'Biaya Alat Konstruksi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'cicilan beko ke 3 (sisa 2 kali)', 0.00, 89800000.00),
  ('t52bf7ac6af55', 'kas_keluar', '2026-10-26', 'CO-2610-1332', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'upah', 0.00, 2350000.00),
  ('t11a0fb6758b7', 'kas_keluar', '2026-10-26', 'CO-2610-1333', 'Kas Besar', 'Biaya Akomodasi', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (bensin, servis printer, obat pekerja)', 0.00, 254000.00),
  ('td66da16c27d0', 'kas_keluar', '2026-10-26', 'CO-2610-1334', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (ongkir bahan granit, knee, dll)', 0.00, 1179490.00),
  ('t0db687d635d8', 'kas_keluar', '2026-10-26', 'CO-2610-1335', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', 'kas fikri (print lapju, print gambar)', 0.00, 172000.00),
  ('t12076004ed40', 'kas_keluar', '2026-10-26', 'CO-2610-1336', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'keni, acian bata ringan, bata ringan 24/10', 0.00, 485550.00),
  ('t560065476aa2', 'kas_keluar', '2026-10-26', 'CO-2610-1337', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon pak nanang', 0.00, 2000000.00),
  ('t64d6cd479e4f', 'kas_keluar', '2026-10-26', 'CO-2610-1338', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'lakban kertas 24/10', 0.00, 165000.00),
  ('t5f87f0566a61', 'kas_keluar', '2026-10-26', 'CO-2610-1339', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'resibon, plug, keni, acian bata ringan, lem tembak 24/10', 0.00, 2192000.00),
  ('t03849cdc8140', 'kas_keluar', '2026-10-26', 'CO-2610-1340', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'opname tim usep', 0.00, 1600000.00),
  ('tc571c6149cdf', 'kas_keluar', '2026-10-26', 'CO-2610-1341', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'kasbon tim agus', 0.00, 5000000.00),
  ('t53471445b9bd', 'kas_keluar', '2026-10-26', 'CO-2610-1342', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'unc, ring plat baja 23/10', 0.00, 288000.00),
  ('t1bda9793f35f', 'kas_keluar', '2026-10-26', 'CO-2610-1343', 'Kas Besar', 'Biaya Upah', 'Asmira Dustira', '', 'iqbal', 0.00, 25000000.00),
  ('tf06c4eae82d0', 'kas_keluar', '2026-10-26', 'CO-2610-1344', 'Kas Besar', 'Biaya Akomodasi', 'MBG Cibalong', '', 'listrik', 0.00, 203000.00),
  ('t7132778aac9e', 'kas_keluar', '2026-10-26', 'CO-2610-1345', 'Kas Besar', 'Biaya Bahan', 'Cibatu', '', 'kayu papan', 0.00, 3000000.00),
  ('t44873d8acad6', 'kas_keluar', '2026-10-26', 'CO-2610-1346', 'Kas Besar', 'Biaya Bahan', 'Cibatu', '', 'CNP, skrup', 0.00, 1255000.00),
  ('tc571de57a7da', 'kas_keluar', '2026-10-26', 'CO-2610-1347', 'Kas Besar', 'Biaya Upah', 'Kodim Kuningan', '', 'kasbon pertama group agus', 0.00, 7500000.00),
  ('tea67bb38af32', 'kas_keluar', '2026-10-26', 'CO-2610-1348', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', 'kasbon septian', 0.00, 1000000.00),
  ('td18c6f41c7ec', 'kas_keluar', '2026-10-26', 'CO-2610-1349', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'knee. dop, lem kayu, semen 25/10', 0.00, 4908500.00),
  ('t1faa09d99abf', 'kas_keluar', '2026-10-26', 'CO-2610-1350', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'skrup gypsum', 0.00, 150000.00),
  ('t8bdf4f595611', 'kas_keluar', '2026-10-26', 'CO-2610-1351', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pacul doran singkup dll', 0.00, 1322000.00),
  ('t53d86e14614b', 'kas_keluar', '2026-10-26', 'CO-2610-1352', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'triplek dll', 0.00, 908000.00),
  ('taca348e9afd1', 'kas_keluar', '2026-10-26', 'CO-2610-1353', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Cimahi', '', 'Kas fikri (bensin, servis printer)', 0.00, 212000.00),
  ('tf599f632f83f', 'kas_keluar', '2026-10-26', 'CO-2610-1354', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'Kas fikri (skrap, roskam)', 0.00, 230000.00),
  ('t04330e02472f', 'kas_keluar', '2026-10-26', 'CO-2610-1355', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'Kas fikri (jasa perbaikan kabel putus)', 0.00, 200000.00),
  ('t093aab5e37b9', 'kas_keluar', '2026-10-26', 'CO-2610-1356', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'pacul, doran, singkup, selang waterpass, roskam,dll', 0.00, 1322000.00),
  ('t66690c106bf0', 'kas_keluar', '2026-10-26', 'CO-2610-1357', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'triplek 9mm, triplek 3mm, roskam dll', 0.00, 908000.00),
  ('te9d774694c27', 'kas_keluar', '2026-10-26', 'CO-2610-1358', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim borong m.zek', 0.00, 4000000.00),
  ('tffd3a3cc0ae3', 'kas_keluar', '2026-10-26', 'CO-2610-1359', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'semen merdeka, mill, perekat bata ringan', 0.00, 10505000.00),
  ('td88fa63cf297', 'kas_keluar', '2026-10-26', 'CO-2610-1360', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon tim kusen', 0.00, 5000000.00),
  ('t8540a2a35b61', 'kas_keluar', '2026-10-26', 'CO-2610-1361', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'opname pas keramik', 0.00, 4300000.00),
  ('t8225de62c857', 'kas_keluar', '2026-10-26', 'CO-2610-1362', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'lapjusik sd 100 %', 0.00, 6500000.00),
  ('t0d42e41adfe3', 'kas_keluar', '2026-10-26', 'CO-2610-1363', 'Kas Besar', 'Biaya entertain', 'Kemhan Cut n Fill', '', 'kas fikri (rokok minum konwas pek cor jalan cimahi)', 0.00, 90000.00),
  ('t83c0cf7a0794', 'kas_keluar', '2026-10-26', 'CO-2610-1364', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'Kas fikri (kopi pengecoran jalan cimahi)', 0.00, 50000.00),
  ('t969f097702ca', 'kas_keluar', '2026-10-26', 'CO-2610-1365', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kas pengecoran cimahi', 0.00, 1100000.00),
  ('t3044964e70d0', 'kas_keluar', '2026-10-26', 'CO-2610-1366', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'kasbon tim jalan pak yudi cimahi (23/10)', 0.00, 10000000.00),
  ('t80887d5da98f', 'kas_keluar', '2026-10-26', 'CO-2610-1367', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'uang perbaikan akses jalan subang', 0.00, 300000.00),
  ('t4503b195b9ac', 'kas_keluar', '2026-10-26', 'CO-2610-1368', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar dan UM operator 25/10', 0.00, 1250000.00),
  ('tab8c7957f204', 'kas_keluar', '2026-10-26', 'CO-2610-1369', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'bahan matrial', 0.00, 1860000.00),
  ('t3b0b41dbfa6e', 'kas_keluar', '2026-10-26', 'CO-2610-1370', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar 40 L 24/10', 0.00, 1006000.00),
  ('ta0bd7f20a687', 'kas_keluar', '2026-10-26', 'CO-2610-1371', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar 26/10', 0.00, 1000000.00),
  ('t8e6e8aca2a1b', 'kas_keluar', '2026-10-26', 'CO-2610-1372', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Bogor', '', 'kostan hamdan', 0.00, 850000.00),
  ('t8c05cdf3b05f', 'kas_keluar', '2026-10-26', 'CO-2610-1373', 'Kas Besar', 'Biaya Upah2', 'Kemhan Bangun Rumdis Bogor', '', 'kasbon tk plafond (uang makan)', 0.00, 2000000.00),
  ('t4278d40e648d', 'kas_keluar', '2026-10-26', 'CO-2610-1374', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'kekurangan bayaran 17 - 22 okt', 0.00, 6645000.00),
  ('t77bacd695eb8', 'kas_keluar', '2026-10-26', 'CO-2610-1375', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'holo galv 2x4 (24/10)', 0.00, 202000.00),
  ('t910d6ea993a4', 'kas_keluar', '2026-10-26', 'CO-2610-1376', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'buang barangkal', 0.00, 900000.00),
  ('t96197cdbf31d', 'kas_keluar', '2026-10-26', 'CO-2610-1377', 'Kas Besar', 'Biaya Upah2', 'Kemhan 2 Gudang Selatan', '', 'kas deni (galon)', 0.00, 168000.00),
  ('t9034e7492e70', 'kas_keluar', '2026-10-26', 'CO-2610-1378', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan 2 Gudang Selatan', '', 'kas deni (obat-obatan, pertamax)', 0.00, 115000.00),
  ('tc859227ac7af', 'kas_keluar', '2026-10-26', 'CO-2610-1379', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'kas deni (angkut barang, kunci - kunci, oli jack hammer, dll)', 0.00, 313367.00),
  ('t868a56ef13e6', 'kas_keluar', '2026-10-26', 'CO-2610-1380', 'Kas Besar', 'Biaya Upah', 'Armed', '', 'h dana', 0.00, 10000000.00),
  ('t3e673d808ba0', 'kas_keluar', '2026-10-26', 'CO-2610-1381', 'Kas Besar', 'Biaya Bahan', 'Zidam Renov Rumdis Bogor', '', 'DP alumunium', 0.00, 40020000.00),
  ('t73927828063b', 'kas_keluar', '2026-10-26', 'CO-2610-1382', 'Kas Besar', 'Biaya Upah2', 'Zidam Renov Rumdis Bogor', '', 'mingguan pengawas 8 minggu 24/10', 0.00, 2000000.00),
  ('t509dad7b441f', 'kas_keluar', '2026-10-26', 'CO-2610-1383', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'ongkos narik granit 24/10', 0.00, 1500000.00),
  ('tc55d14dc1799', 'kas_keluar', '2026-10-26', 'CO-2610-1384', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'air damkar', 0.00, 250000.00),
  ('t42d722d8ab75', 'kas_keluar', '2026-10-26', 'CO-2610-1385', 'Kas Besar', 'Biaya Upah2', 'Zidam Rehab Rumdis Cimahi', '', 'mingguan pengawas', 0.00, 2002500.00),
  ('t0c8893982721', 'kas_keluar', '2026-10-26', 'CO-2610-1386', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'mesin gurinda, mt90, resibon (24/10)', 0.00, 1028000.00),
  ('t897660421438', 'kas_keluar', '2026-10-26', 'CO-2610-1387', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'ember hitam, roskam pvc, roofing 24/10', 0.00, 2990000.00),
  ('t43ff6e181363', 'kas_keluar', '2026-10-26', 'CO-2610-1388', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Rumdis Cimahi', '', 'kasbon upah kerja 24/10', 0.00, 4650000.00),
  ('t0cb9f193924a', 'kas_keluar', '2026-10-26', 'CO-2610-1389', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'buang barangkal 25/10', 0.00, 1700000.00),
  ('t215e30e0e4c6', 'kas_keluar', '2026-10-26', 'CO-2610-1390', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'benang nylon, selang elastis', 0.00, 730000.00),
  ('tc4aaf0b8f3ea', 'kas_keluar', '2026-10-26', 'CO-2610-1391', 'Kas Besar', 'Biaya Bahan', 'Zidam Rehab Rumdis Cimahi', '', 'paku 10 cm, paku 7cm, reng baja ringan', 0.00, 2085000.00),
  ('tf899c52af0b4', 'kas_keluar', '2026-10-26', 'CO-2610-1392', 'Kas Besar', 'Biaya ADM', 'Cost Center', '', 'SKA', 0.00, 4000000.00),
  ('t0c72a37c64d6', 'kas_keluar', '2026-10-26', 'CO-2610-1393', 'Kas Besar', 'Biaya Upah', 'Tugu TNI', '', 'ervan', 0.00, 10000000.00),
  ('t9b25d084f2c8', 'kas_keluar', '2026-10-26', 'CO-2610-1394', 'Kas Besar', 'Biaya Upah2', 'Kemhan Cut n Fill', '', 'opname pekerjaan jalan cimahi', 0.00, 7849500.00),
  ('taeae04b6c7e1', 'kas_masuk', '2026-10-26', 'CI-2610-0029', 'Kas Besar', 'Pendapatan Proyek', 'Zidam Rehab Gudkesrah', '', 'uang masuk gudkesrah', 217950000.00, 0.00),
  ('td3bd7d00020e', 'kas_masuk', '2026-10-26', 'CI-2610-0030', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 26 oktober', 451817580.00, 0.00);
