-- Sinkronisasi lanjutan dari Report export terbaru (s/d 9 Oktober 2026,
-- upload kedua) dibandingkan ref-by-ref terhadap dump database TERKINI
-- yang Anda kirim (u856744921_acc_3.sql, 5.464 transaksi, 264 baris
-- jurnal) -- bukan lagi dump lama, jadi file ini SUDAH memperhitungkan
-- bahwa sync_transactions_okt8_2026.sql dan sync_transactions_okt9_2026.sql
-- sudah dijalankan (semua UPDATE dari file itu sudah kebaca di dump ini).
--
-- PENTING -- ditemukan 2 transaksi DOBEL (bukan dari sync kemarin, tapi
-- dari input manual yang bentrok dengan sync kemarin):
--  - 'bunga giro' Rp877.988 (8 Okt) tersimpan 2x: BI-2610-0006 (dari
--    sync kemarin, ref sesuai nomor asli di Report) DAN BI-2610-0016
--    (dientri manual lewat aplikasi jam 02:28, SEBELUM sync kemarin
--    jalan jam 04:14 -- jadi begitu sync jalan, transaksi yang sama
--    jadi tercatat dua kali).
--  - 'biaya adm bank' Rp195.598 (8 Okt) sama persis: BO-2610-0011 (sync)
--    DAN BO-2610-0036 (manual, jam 02:26-02:27).
-- Baris manual (BI-2610-0016, BO-2610-0036) yang dihapus di bawah --
-- bukan baris sync -- karena nomor ref BI-2610-0006/BO-2610-0011 itu
-- yang cocok dengan nomor asli di Report export sistem asli, sedangkan
-- -0016/-0036 adalah nomor otomatis aplikasi untuk entri manual yang
-- ternyata transaksi yang sama. DELETE ini aman dijalankan ulang (baris
-- yang sudah tidak ada otomatis dilewati, bukan error).
--
-- Selain itu ditemukan:
--  - 3 transaksi baru (9 Oktober 2026): penarikan bank->kas Rp855.709.768
--    (pasangan BO-2610-0012 / CI-2610-0013), dan CO-2610-0536 (bahan
--    alumunium Kodim Cirebon Rp22.205.329 -- pecahan dari CO-2609-0557,
--    lihat UPDATE di bawah).
--  - CO-2609-0557 ternyata gabungan 2 project (Korem + Kodim Cirebon)
--    yang dipisah sistem asli: nilainya dikoreksi dari Rp133.231.975
--    jadi Rp111.026.646 (porsi Korem saja), sisanya Rp22.205.329 jadi
--    transaksi baru CO-2610-0536 di atas (porsi Kodim).
--  - 4 akun lawan pada transaksi yang baru disinkron kemarin (9 Okt)
--    direklasifikasi lagi oleh sistem asli, jumlah/tanggal tidak berubah.
--
-- Data yang sudah benar (Trial Balance, Neraca, Laba Rugi, Hutang, Prive,
-- logika index.html) tidak disentuh sama sekali oleh file ini.

-- 1) Hapus 2 baris dobel (entri manual yang bentrok dengan sync Okt 8)
DELETE FROM `transactions` WHERE `ref` IN ('BI-2610-0016', 'BO-2610-0036');

-- 2) 3 transaksi baru (9 Oktober 2026)
INSERT IGNORE INTO `transactions` (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `customer_id`, `vendor_id`, `ket`, `debet`, `kredit`, `created_by`, `created_at`, `updated_at`) VALUES
('t257e7d9ac9ed', 'bank_keluar', '2026-10-09', 'BO-2610-0012', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'penarikan 9 oktober', 0.0, 855709768.0, NULL, NOW(), NOW()),
('t4ee1b6925d56', 'kas_masuk', '2026-10-09', 'CI-2610-0013', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', NULL, NULL, 'penarikan 9 oktober', 855709768.0, 0.0, NULL, NOW(), NOW()),
('t2c9b362816ca', 'kas_keluar', '2026-09-08', 'CO-2610-0536', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Kodim Cirebon', '', NULL, NULL, 'bahan alumunium cirebon (CKA) total 133.231.975 (korem kodim)', 0.0, 22205329.0, NULL, NOW(), NOW());

-- 3) Koreksi split CO-2609-0557 (porsi Korem Cirebon saja, sisanya -> CO-2610-0536 di atas)
UPDATE `transactions` SET `kredit`=111026646.0, `ket`='bahan alumunium cirebon (CKA) total 133.231.975 (korem kodim)' WHERE `ref`='CO-2609-0557';

-- 4) Reklasifikasi akun lawan (4 baris, hasil sync 9 Okt yang dikoreksi lagi oleh sistem asli)
UPDATE `transactions` SET `akun_lawan`='Biaya Listrik & Internet' WHERE `ref`='CO-2610-0432';
UPDATE `transactions` SET `akun_lawan`='Biaya Pemeliharaan Kantor' WHERE `ref`='CO-2610-0434';
UPDATE `transactions` SET `akun_lawan`='Biaya Upah' WHERE `ref`='CO-2610-0436';
UPDATE `transactions` SET `akun_lawan`='Atensi' WHERE `ref`='CO-2610-0440';

-- Verifikasi (harapan setelah file ini jalan): 5464 - 2 (dobel dihapus) + 3 (baru) = 5465
SELECT COUNT(*) AS total_transactions FROM `transactions`;
