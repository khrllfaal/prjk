-- Adds the `plafond` column to `coa`, powering the Dashboard's new
-- "Posisi Hutang" table (Plafond diisi manual per akun, Saldo dari
-- Neraca, Hutang = Plafond - Saldo). Safe to run once; re-running on a
-- database that already has the column is a no-op thanks to the
-- information_schema guard below (plain `ADD COLUMN` without IF NOT
-- EXISTS errors on a repeat run on MySQL < 8.0).
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'coa' AND COLUMN_NAME = 'plafond'
);
SET @sql = IF(@col_exists = 0,
  'ALTER TABLE `coa` ADD COLUMN `plafond` DECIMAL(18,2) NOT NULL DEFAULT 0 AFTER `saldo_awal`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
