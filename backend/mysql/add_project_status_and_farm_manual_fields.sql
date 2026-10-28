-- Adds columns to `projects` for the Master Project / Dashboard
-- Pengeluaran revisions: a project completion status, the two
-- manually-entered Farm figures (Pendapatan Kandang, Pembayaran Hutang)
-- that Dashboard Pengeluaran's new Farm table needs persisted per
-- project instead of re-typed every visit, and an optional RAP percent
-- (Nilai RAP = Nilai Kontrak * rap_percent / 100, computed client-side
-- and stored into the existing `rap` column -- rap_percent itself is
-- only kept so the Master Project form can show/re-edit the percentage
-- that produced it). Schema change only -- touches no existing row's
-- data (every existing project gets the column defaults: status
-- 'Belum', the two farm figures 0, rap_percent 0/unset).
-- Safe to re-run.

ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS status          VARCHAR(20)    NOT NULL DEFAULT 'Belum' AFTER adm_fee,
  ADD COLUMN IF NOT EXISTS farm_pendapatan DECIMAL(18,2)  NOT NULL DEFAULT 0       AFTER status,
  ADD COLUMN IF NOT EXISTS farm_hutang     DECIMAL(18,2)  NOT NULL DEFAULT 0       AFTER farm_pendapatan,
  ADD COLUMN IF NOT EXISTS rap_percent     DECIMAL(5,2)   NOT NULL DEFAULT 0       AFTER farm_hutang;
