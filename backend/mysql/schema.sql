-- =====================================================================
-- Prakasa Group ACC v2 — MySQL schema (Hostinger / any MySQL 8+/MariaDB)
-- Run this once against a fresh database, e.g.:
--   mysql -u <user> -p <database> < schema.sql
-- Safe to re-run (CREATE TABLE IF NOT EXISTS).
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 1. users — admin/owner logins. No public signup: rows are inserted
-- manually by whoever runs the deploy (see docs/DEPLOY_HOSTINGER.md).
-- Sessions are plain PHP sessions (cookie-based), so the same account
-- can be logged in on several devices/browsers at once — each gets its
-- own session, none of them invalidate each other.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id              VARCHAR(40) PRIMARY KEY,
  email           VARCHAR(190) NOT NULL UNIQUE,
  password_hash   VARCHAR(255) NOT NULL,
  nama            VARCHAR(190) NOT NULL,
  role            ENUM('admin','owner') NOT NULL,
  failed_attempts INT NOT NULL DEFAULT 0,
  locked_until    DATETIME NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 2. master data
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
  id      VARCHAR(40) PRIMARY KEY,
  kode    VARCHAR(40) NOT NULL,
  nama    VARCHAR(255) NOT NULL,
  alamat  VARCHAR(500) NOT NULL DEFAULT '',
  telp    VARCHAR(60) NOT NULL DEFAULT '',
  email   VARCHAR(190) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vendors (
  id      VARCHAR(40) PRIMARY KEY,
  kode    VARCHAR(40) NOT NULL,
  nama    VARCHAR(255) NOT NULL,
  alamat  VARCHAR(500) NOT NULL DEFAULT '',
  telp    VARCHAR(60) NOT NULL DEFAULT '',
  email   VARCHAR(190) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS projects (
  id              VARCHAR(40) PRIMARY KEY,
  nama            VARCHAR(255) NOT NULL,
  ledger_name     VARCHAR(255) NOT NULL DEFAULT '', -- name used on kas/bank/jurnal entries, if different from `nama`
  kontrak         DECIMAL(18,2) NOT NULL DEFAULT 0,
  rap             DECIMAL(18,2) NOT NULL DEFAULT 0,
  progress        DECIMAL(6,4) NULL,                -- 0..1, NULL = belum lapor
  pemberi_proyek  VARCHAR(120) NOT NULL DEFAULT '',
  cost_center     DECIMAL(18,2) NOT NULL DEFAULT 0,
  adm_fee         DECIMAL(18,2) NOT NULL DEFAULT 0,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_projects_ledger (ledger_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS coa (
  id          VARCHAR(40) PRIMARY KEY,
  kode        VARCHAR(40) NOT NULL UNIQUE,
  nama        VARCHAR(255) NOT NULL,
  level       TINYINT NOT NULL,
  tipe        VARCHAR(20) NOT NULL,
  saldo_awal  DECIMAL(18,2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 3. transactions — kas_masuk / kas_keluar / bank_masuk / bank_keluar
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS transactions (
  id           VARCHAR(40) PRIMARY KEY,
  jenis        ENUM('kas_masuk','kas_keluar','bank_masuk','bank_keluar') NOT NULL,
  tgl          DATE NOT NULL,
  ref          VARCHAR(40) NOT NULL,
  akun_kas     VARCHAR(255) NOT NULL,
  akun_lawan   VARCHAR(255) NOT NULL DEFAULT '',
  project      VARCHAR(255) NOT NULL DEFAULT '',
  relasi       VARCHAR(255) NOT NULL DEFAULT '',
  customer_id  VARCHAR(40) NULL,
  vendor_id    VARCHAR(40) NULL,
  ket          TEXT NULL,
  debet        DECIMAL(18,2) NOT NULL DEFAULT 0,
  kredit       DECIMAL(18,2) NOT NULL DEFAULT 0,
  created_by   VARCHAR(40) NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_txn_jenis_tgl (jenis, tgl),
  INDEX idx_txn_project (project),
  INDEX idx_txn_ref_prefix (ref),
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 4. jurnal umum
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS jurnal_umum (
  id          VARCHAR(40) PRIMARY KEY,
  tgl         DATE NOT NULL,
  ref         VARCHAR(40) NOT NULL,
  akun        VARCHAR(255) NOT NULL,
  project     VARCHAR(255) NOT NULL DEFAULT '',
  relasi      VARCHAR(255) NOT NULL DEFAULT '',
  kategori    VARCHAR(120) NOT NULL DEFAULT '',
  ket         TEXT NULL,
  debet       DECIMAL(18,2) NOT NULL DEFAULT 0,
  kredit      DECIMAL(18,2) NOT NULL DEFAULT 0,
  created_by  VARCHAR(40) NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 5. Trial Hutang manual overrides (one row per jurnal_umum nota id)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS hutang_overrides (
  nota_id     VARCHAR(40) PRIMARY KEY,
  paid        DECIMAL(18,2) NOT NULL DEFAULT 0,
  status      ENUM('BELUM_BAYAR','SEBAGIAN','LUNAS') NOT NULL,
  updated_by  VARCHAR(40) NULL,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (nota_id) REFERENCES jurnal_umum(id) ON DELETE CASCADE,
  FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 6. Audit log — who changed what, when (append-only, never edited).
-- Cheap but real accountability now that this is a shared backend.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_log (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id     VARCHAR(40) NULL,
  user_email  VARCHAR(190) NULL,
  action      ENUM('create','update','delete') NOT NULL,
  entity      VARCHAR(40) NOT NULL,   -- e.g. 'transactions', 'projects'
  entity_id   VARCHAR(40) NOT NULL,
  detail      TEXT NULL,              -- short human-readable summary
  ip_address  VARCHAR(45) NULL,       -- IPv4 or IPv6
  user_agent  VARCHAR(255) NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_audit_entity (entity, entity_id),
  INDEX idx_audit_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Safe to re-run against a database created before ip_address/user_agent
-- existed (MariaDB 10.0.2+ / MySQL 8.0.29+ — Hostinger's stack qualifies).
ALTER TABLE audit_log ADD COLUMN IF NOT EXISTS ip_address VARCHAR(45) NULL AFTER detail;
ALTER TABLE audit_log ADD COLUMN IF NOT EXISTS user_agent VARCHAR(255) NULL AFTER ip_address;
