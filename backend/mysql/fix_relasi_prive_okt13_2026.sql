-- The 5 new Prive drawdowns added by sync_transactions_okt13_2026.sql
-- (CO-2610-0624..0628) came from the Kas Keluar Report export, which
-- has no "Relasi" column at all -- so they were inserted with
-- relasi = '' and silently dropped from Laporan Prive (which groups by
-- `relasi`, not `project`, and hides anything with no relasi --
-- see relasiReport()'s hideUnlinked:true in index.html).
--
-- Owner identified from each entry's own keterangan, matching the
-- Pr-R/Pr-Z convention already used on every other Prive transaction
-- for these same two owners ("pak rajab" -> Pr-R, "pa zamzam" -> Pr-Z).
-- Verified: 87.000+166.000+200.000+90.000 = 543.000 (Pr-R) and
-- 78.200 (Pr-Z) are exactly the Rp621.200 gap between asli and
-- buatan's Data Prive totals.
UPDATE `transactions` SET `relasi` = 'Pr-R' WHERE `ref` IN
  ('CO-2610-0624', 'CO-2610-0625', 'CO-2610-0626', 'CO-2610-0627');
UPDATE `transactions` SET `relasi` = 'Pr-Z' WHERE `ref` = 'CO-2610-0628';
