-- Realigns 13 COA account codes to match the reference ("asli") system's
-- numbering -- names and balances are identical between the two systems,
-- only the CODE differs for these accounts. Matched by `nama` (never by
-- the old `kode`, so this is safe to re-run even if partially applied).
--
-- Does NOT touch jurnal_umum/transactions data: those reference an
-- account by NAME (current app forms always save a plain name, never a
-- coded "kode-nama" string -- see akunNamaOnly()/matchesPlainCost() in
-- frontend/index.html), so a coa.kode change here is picked up
-- automatically by every report. A handful of much older jurnal_umum
-- rows may still carry a legacy embedded code prefix from before that
-- convention (see the RAP_COST_CODES comment in frontend/index.html) --
-- those were already untouched by the PREVIOUS renumbering for the same
-- reason, and frontend/index.html's RAP_COST_CODES list is updated in
-- the same commit as this migration to keep matching both the legacy
-- codes AND these new ones, exactly as it already did for the old ones.
--
-- Order matters -- codes being vacated must move before the account
-- that wants to reuse that code moves in, or the UNIQUE(kode) constraint
-- rejects the statement. Verified dependency order below.
-- Safe to re-run: each UPDATE only fires while the row still has its old code.

START TRANSACTION;

-- 1.1.x: Ayat Silang accounts + Bank BJB PT
-- "Ayat Silang Kas Besar Kas-Bank" must vacate 1.1.19 before "Bank BJB PT" can take it.
UPDATE coa SET kode='1.1.49' WHERE nama='Ayat Silang Kas Besar Kas-Bank' AND kode='1.1.19';
UPDATE coa SET kode='1.1.48' WHERE nama='Ayat Silang Kas Besar Kas-Kecil' AND kode='1.1.18';
UPDATE coa SET kode='1.1.50' WHERE nama='Ayat Silang Antar Bank' AND kode='1.1.20';
UPDATE coa SET kode='1.1.19' WHERE nama='Bank BJB PT' AND kode='1.1.37';

-- 5.1.x: Biaya Produksi -- dependency order so no two rows ever collide
-- on the same code mid-sequence (see migration notes above).
UPDATE coa SET kode='5.1.06' WHERE nama='Biaya Upah3' AND kode='5.1.10';
UPDATE coa SET kode='5.1.05' WHERE nama='Biaya Upah2' AND kode='5.1.09';
UPDATE coa SET kode='5.1.07' WHERE nama='Biaya Akomodasi' AND kode='5.1.11';
UPDATE coa SET kode='5.1.10' WHERE nama='Biaya ADM' AND kode='5.1.04';
UPDATE coa SET kode='5.1.04' WHERE nama='Biaya Upah' AND kode='5.1.02';
UPDATE coa SET kode='5.1.02' WHERE nama='Biaya Bahan2' AND kode='5.1.18';
UPDATE coa SET kode='5.1.03' WHERE nama='Biaya Bahan3' AND kode='5.1.19';
UPDATE coa SET kode='5.1.11' WHERE nama='Biaya ADM Fee' AND kode='5.1.13';
UPDATE coa SET kode='5.1.13' WHERE nama='Biaya Alat Konstruksi' AND kode='5.1.20';

COMMIT;

-- Left unchanged on purpose (present in our COA, no equivalent entry in
-- "asli" to align to -- not an error, just accounts the reference
-- system's export doesn't carry): 1.1.38 Bank BJB CV Purbayanti,
-- 1.2.8 Peralatan Kandang, 5.2.3 Biaya Makan Pegawai.
