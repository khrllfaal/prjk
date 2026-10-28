-- Adds 3 columns to `projects` for the Master Project / Dashboard
-- Pengeluaran revisions: a project completion status, and the two
-- manually-entered Farm figures (Pendapatan Kandang, Pembayaran Hutang)
-- that Dashboard Pengeluaran's new Farm table needs persisted per
-- project instead of re-typed every visit. Schema change only --
-- touches no existing row's data (every existing project gets the
-- column defaults: status 'Belum', the two farm figures 0).
-- Safe to re-run.

ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS status          VARCHAR(20)    NOT NULL DEFAULT 'Belum' AFTER adm_fee,
  ADD COLUMN IF NOT EXISTS farm_pendapatan DECIMAL(18,2)  NOT NULL DEFAULT 0       AFTER status,
  ADD COLUMN IF NOT EXISTS farm_hutang     DECIMAL(18,2)  NOT NULL DEFAULT 0       AFTER farm_pendapatan;
