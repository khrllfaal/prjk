-- Found while cross-checking Data Hutang/Piutang/Prive against the
-- 14 Oktober 2026 Report exports: three older transactions (all
-- already in the database well before this sync round, unrelated to
-- today's new data) carry the wrong relasi / a blank relasi, which
-- silently misallocates them in Laporan Piutang / Laporan Prive even
-- though the money and Neraca/Trial Balance totals were always right.
--
-- 1) CO-2610-0282 ("inverter kandang D", Rp6.800.000) was tagged
--    relasi = 'Pi-Kandang' -- almost certainly auto-matched on the
--    word "kandang" in its own keterangan -- but belongs to 'Pi-MBU'.
--    Verified: swapping it is the only change that makes BOTH
--    Pi-Kandang (25.080.000) and Pi-MBU (-7.895.728) match the real
--    Data Piutang exactly; the Laporan Piutang TOTAL was already
--    correct before this fix (the two rows' errors canceled out).
UPDATE `transactions` SET `relasi` = 'Pi-MBU' WHERE `ref` = 'CO-2610-0282';

-- 2) CO-2610-0437 ("bayaran dede (pa rajab)", Rp1.500.000) and
--    CO-2610-0438 ("d.okeh albey 8/10 (pak zam)", Rp20.000) -- both
--    from 9 Oktober -- have relasi = '' despite their own keterangan
--    naming an owner -- same missing-Relasi-column-in-the-Report-
--    export pattern as the Oct 13 Prive fix, just from an earlier
--    date that was never caught until this round's Data Prive
--    cross-check.
--    Verified: these are exactly the Rp1.500.000 (Pr-R) and Rp20.000
--    (Pr-Z) gap between asli and buatan Data Prive once the 14
--    Oktober transactions are also in sync.
UPDATE `transactions` SET `relasi` = 'Pr-R' WHERE `ref` = 'CO-2610-0437';
UPDATE `transactions` SET `relasi` = 'Pr-Z' WHERE `ref` = 'CO-2610-0438';
