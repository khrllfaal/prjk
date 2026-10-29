-- Adds per-IP login rate limiting, on top of the existing per-account
-- lockout (users.failed_attempts/locked_until). The per-account lockout
-- never trips on credential stuffing -- an attacker trying many
-- different accounts a few times each from one IP never hits any single
-- account's 5-attempt threshold. This table counts failures by IP
-- across every account, independent of which one was targeted.
--
-- Schema-only change -- does not touch any existing user/transaction
-- data. Safe to re-run.

CREATE TABLE IF NOT EXISTS login_rate_limits (
  ip              VARCHAR(45) PRIMARY KEY, -- IPv6 max length
  attempts        INT NOT NULL DEFAULT 0,
  window_started  DATETIME NOT NULL,
  locked_until    DATETIME NULL,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
