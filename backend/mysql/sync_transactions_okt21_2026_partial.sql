-- Sinkronisasi SEBAGIAN dari Report export 21 Oktober 2026 -- file
-- cash_out (Kas Keluar) TIDAK ikut diupload putaran ini, jadi file ini
-- HANYA mencakup Bank Masuk, Bank Keluar, dan Kas Masuk. Kas Keluar
-- (mayoritas transaksi harian) BELUM disinkronkan -- mohon kirim
-- cash_out_Report terbaru untuk melengkapi.
--
-- Ditemukan 3 transaksi baru (1 pasangan penarikan loan Bank BJB RC
-- Prakasa -> Kas Besar, dan 1 termin masuk Rp1.360.891.726 dari Zidam Rumdis
-- Zipur). 0 penyesuaian, 0 transaksi hilang pada cakupan file ini. Jurnal
-- Umum tidak berubah sama sekali.

-- 3 transaksi baru
INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('tb0848d027ee7', 'bank_masuk', '2026-10-21', 'BI-2610-0011', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'Zidam Rumdis Zipur', '', 'uang masuk zipur', 1360891726.00, 0.00),
  ('t0237be65c1dd', 'bank_keluar', '2026-10-21', 'BO-2610-0024', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 21 oktober', 0.00, 279393525.00),
  ('tf4514cbebf74', 'kas_masuk', '2026-10-21', 'CI-2610-0026', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 21 oktober', 279393525.00, 0.00);
