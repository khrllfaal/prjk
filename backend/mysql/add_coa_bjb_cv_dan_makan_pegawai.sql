-- Dibandingkan ref-by-ref dengan Chart of Account sistem asli (21 Oktober
-- 2026, match by nama karena urutan kode di asli berbeda dari buatan):
-- 2 akun ada di Master COA asli tapi belum ada di Master COA buatan.
-- Saldo Awal keduanya Rp0 di asli, jadi aman ditambahkan tanpa mengubah
-- Trial Balance/Neraca manapun.
INSERT IGNORE INTO `coa` (`id`, `kode`, `nama`, `level`, `tipe`, `saldo_awal`, `plafond`, `updated_at`)
VALUES
  ('a_bank_bjb_cv_purbayanti', '1.1.38', 'Bank BJB CV Purbayanti', 3, 'asset', 0.00, 0.00, NOW()),
  ('a_biaya_makan_pegawai', '5.2.3', 'Biaya Makan Pegawai', 3, 'cogs', 0.00, 0.00, NOW());
