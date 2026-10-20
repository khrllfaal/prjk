-- Owner sent the full per-owner Prive buku besar for Pr-F/Pr-I/Pr-K/Pr-R/
-- Pr-Z (every ref, every amount) -- used as ground truth to cross-check
-- ALL Prive transactions in the database, not just the ones flagged
-- earlier. Every owner's TOTAL MUTASI in that buku besar matched our
-- own computed sum exactly once these 17 refs are corrected, confirming
-- this is a complete, closed set (no other Prive refs are wrong).
--
-- These are the CO-2610-0924 (19 Oct, left unlinked pending confirmation
-- in the previous sync) and the ~13 new 20 Oct transactions whose owner
-- couldn't be verified at the time because that day's Data Prive export
-- hadn't been refreshed yet.
UPDATE `transactions` SET `relasi` = 'Pr-I' WHERE `ref` IN
  ('CO-2610-0924', 'CO-2610-1031');
UPDATE `transactions` SET `relasi` = 'Pr-K' WHERE `ref` IN
  ('CO-2610-1035', 'CO-2610-1044', 'CO-2610-1048');
UPDATE `transactions` SET `relasi` = 'Pr-R' WHERE `ref` IN
  ('CO-2610-1034', 'CO-2610-1036', 'CO-2610-1037', 'CO-2610-1039', 'CO-2610-1040', 'CO-2610-1045', 'CO-2610-1047');
UPDATE `transactions` SET `relasi` = 'Pr-Z' WHERE `ref` IN
  ('CO-2610-1033', 'CO-2610-1038', 'CO-2610-1041', 'CO-2610-1043', 'CO-2610-1046');
