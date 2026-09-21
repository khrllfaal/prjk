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
  no_faktur   VARCHAR(80) NOT NULL DEFAULT '',
  status      VARCHAR(10) NOT NULL DEFAULT 'posted',
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

-- =====================================================================
-- 7. MATERIAL / STOCK MODULE — field-admin material in/out, per-project
-- stock levels with reorder alerts, and RAP (budgeted material vs actual
-- usage) deviation tracking. Mirrors the workflow of the MPMS mockup
-- (admin lapangan input via HP), now on a real shared database instead
-- of Google Sheets so dozens of concurrent projects/users stay fast.
-- =====================================================================

-- 'lapangan' = field/branch admin: can only see & write receipts/usage
-- for the project(s) assigned to them in user_projects below. Existing
-- admin/owner rows are untouched by this ALTER.
ALTER TABLE users MODIFY COLUMN role ENUM('admin','owner','lapangan') NOT NULL;

CREATE TABLE IF NOT EXISTS user_projects (
  user_id     VARCHAR(40) NOT NULL,
  project_id  VARCHAR(40) NOT NULL,
  PRIMARY KEY (user_id, project_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Master bahan (material catalogue) — shared across all projects.
CREATE TABLE IF NOT EXISTS materials (
  id                  VARCHAR(40) PRIMARY KEY,
  kode                VARCHAR(40) NOT NULL,
  nama                VARCHAR(255) NOT NULL,
  satuan              VARCHAR(40) NOT NULL DEFAULT '',
  kategori            VARCHAR(120) NOT NULL DEFAULT '',
  stok_minimum        DECIMAL(18,3) NOT NULL DEFAULT 0, -- reorder point (minimarket-style)
  updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Master pekerjaan (BOQ work items) per project — the unit that RAP
-- material coefficients and progress % are tied to.
CREATE TABLE IF NOT EXISTS pekerjaan (
  id              VARCHAR(40) PRIMARY KEY,
  project_id      VARCHAR(40) NOT NULL,
  nama            VARCHAR(255) NOT NULL,
  satuan          VARCHAR(40) NOT NULL DEFAULT '',
  volume_kontrak  DECIMAL(18,3) NOT NULL DEFAULT 0,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_pekerjaan_project (project_id),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RAP config: how much material is *ideally* needed per unit volume of
-- a pekerjaan (koefisien). target_material_ideal for a given progress
-- % = koefisien * aktual_volume (see progress_pekerjaan below).
CREATE TABLE IF NOT EXISTS rap_material (
  id            VARCHAR(40) PRIMARY KEY,
  pekerjaan_id  VARCHAR(40) NOT NULL,
  material_id   VARCHAR(40) NOT NULL,
  koefisien     DECIMAL(18,6) NOT NULL DEFAULT 0,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_rap_pekerjaan_material (pekerjaan_id, material_id),
  FOREIGN KEY (pekerjaan_id) REFERENCES pekerjaan(id) ON DELETE CASCADE,
  FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Latest cumulative % progress per pekerjaan, reported from the field.
CREATE TABLE IF NOT EXISTS progress_pekerjaan (
  id             VARCHAR(40) PRIMARY KEY,
  pekerjaan_id   VARCHAR(40) NOT NULL,
  tgl            DATE NOT NULL,
  volume_aktual  DECIMAL(18,3) NOT NULL DEFAULT 0, -- cumulative to-date, not incremental
  ket            TEXT NULL,
  created_by     VARCHAR(40) NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_progress_pekerjaan (pekerjaan_id, tgl),
  FOREIGN KEY (pekerjaan_id) REFERENCES pekerjaan(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bahan Masuk (material receipts / stock IN), input by field admins.
CREATE TABLE IF NOT EXISTS material_receipts (
  id             VARCHAR(40) PRIMARY KEY,
  project_id     VARCHAR(40) NOT NULL,
  material_id    VARCHAR(40) NOT NULL,
  tgl            DATE NOT NULL,
  qty            DECIMAL(18,3) NOT NULL DEFAULT 0,
  harga_satuan   DECIMAL(18,2) NOT NULL DEFAULT 0,
  vendor_id      VARCHAR(40) NULL,
  no_referensi   VARCHAR(80) NOT NULL DEFAULT '', -- no. surat jalan / nota
  ket            TEXT NULL,
  created_by     VARCHAR(40) NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_receipts_project_material (project_id, material_id),
  INDEX idx_receipts_tgl (tgl),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pemakaian (material usage / stock OUT), input by field admins.
-- pekerjaan_id is optional (usage isn't always tied to one BOQ item)
-- but is required for RAP deviation analysis to work for that row.
CREATE TABLE IF NOT EXISTS material_usage (
  id             VARCHAR(40) PRIMARY KEY,
  project_id     VARCHAR(40) NOT NULL,
  pekerjaan_id   VARCHAR(40) NULL,
  material_id    VARCHAR(40) NOT NULL,
  tgl            DATE NOT NULL,
  qty            DECIMAL(18,3) NOT NULL DEFAULT 0,
  ket            TEXT NULL,
  created_by     VARCHAR(40) NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_usage_project_material (project_id, material_id),
  INDEX idx_usage_pekerjaan (pekerjaan_id),
  INDEX idx_usage_tgl (tgl),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (pekerjaan_id) REFERENCES pekerjaan(id) ON DELETE SET NULL,
  FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
