-- Fixes a real data bug introduced by sync_transactions_okt30_2026.sql: in
-- that file the UPDATE for CI-2610-0036 ran BEFORE the INSERT that creates
-- that row (wrong statement order), so the UPDATE matched nothing and the
-- row landed with an empty `relasi`. Laporan Piutang hides relasi-less
-- entries, so PK-Komeng's cicilan Rp300.000 never offset the Rp5.000.000
-- kasbon -- it showed Rp5.000.000 instead of the correct Rp4.700.000.
--
-- Safe to re-run (guarded by relasi = '').

UPDATE `transactions`
SET `relasi` = 'PK-Komeng'
WHERE `ref` = 'CI-2610-0036' AND `akun_lawan` = 'Piutang Karyawan' AND `relasi` = '';
