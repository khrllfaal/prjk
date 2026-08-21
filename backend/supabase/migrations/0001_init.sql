-- =====================================================================
-- Prakasa Group ACC v2 — initial schema
-- Run this once in the Supabase SQL editor (or via `supabase db push`)
-- on a fresh Supabase project. Safe to re-run (uses IF NOT EXISTS).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. profiles — one row per login (admin or owner), keyed to auth.users
-- ---------------------------------------------------------------------
create table if not exists profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  nama        text not null,
  role        text not null check (role in ('admin','owner')),
  created_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 2. master data
-- ---------------------------------------------------------------------
create table if not exists customers (
  id      text primary key,
  kode    text not null,
  nama    text not null,
  alamat  text default '',
  telp    text default '',
  email   text default ''
);

create table if not exists vendors (
  id      text primary key,
  kode    text not null,
  nama    text not null,
  alamat  text default '',
  telp    text default '',
  email   text default ''
);

create table if not exists projects (
  id              text primary key,
  nama            text not null,
  kontrak         numeric not null default 0,
  rap             numeric not null default 0,
  progress        numeric not null default 0,        -- 0..1 progress lapangan
  pemberi_proyek  text default '',                    -- e.g. 'Kemhan','Bina Marga','PUPR' — used by dashboard filter
  cost_center     text default '',
  adm_fee         numeric not null default 0,
  updated_at      timestamptz not null default now()
);

create table if not exists coa (
  id      text primary key,
  kode    text not null unique,
  nama    text not null,
  level   int not null,
  tipe    text not null
);

-- ---------------------------------------------------------------------
-- 3. transactions — kas_masuk / kas_keluar / bank_masuk / bank_keluar
-- customer_id is set when jenis ends in 'masuk' (piutang side),
-- vendor_id is set when jenis ends in 'keluar' (hutang side).
-- `relasi` stays as a denormalised display name so the existing
-- frontend rendering code (which reads r.relasi directly) keeps working.
-- ---------------------------------------------------------------------
create table if not exists transactions (
  id           text primary key,
  jenis        text not null check (jenis in ('kas_masuk','kas_keluar','bank_masuk','bank_keluar')),
  tgl          date not null,
  ref          text not null,
  akun_kas     text not null,
  akun_lawan   text default '',
  project      text default '',
  relasi       text default '',
  customer_id  text references customers(id) on delete set null,
  vendor_id    text references vendors(id) on delete set null,
  ket          text default '',
  debet        numeric not null default 0,
  kredit       numeric not null default 0,
  created_by   uuid references profiles(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index if not exists idx_transactions_jenis_tgl on transactions(jenis, tgl);
create index if not exists idx_transactions_project on transactions(project);
create index if not exists idx_transactions_vendor on transactions(vendor_id);
create index if not exists idx_transactions_customer on transactions(customer_id);

-- ---------------------------------------------------------------------
-- 4. jurnal umum (adjusting entries, outside kas/bank)
-- ---------------------------------------------------------------------
create table if not exists jurnal_umum (
  id          text primary key,
  tgl         date not null,
  ref         text not null,
  akun        text not null,
  project     text default '',
  relasi      text default '',
  kategori    text default '',
  ket         text default '',
  debet       numeric not null default 0,
  kredit      numeric not null default 0,
  created_by  uuid references profiles(id),
  created_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 5. hutang dagang (nota-level payable tracking) — powers the new
-- "Trial Hutang" menu: which notes/invoices are unpaid vs paid, and
-- against which project.
-- ---------------------------------------------------------------------
create table if not exists hutang_dagang (
  id            text primary key,
  tgl           date not null,
  ref_no        text not null,
  vendor_id     text references vendors(id) on delete set null,
  project       text default '',
  description   text default '',
  amount        numeric not null default 0,
  status        text not null default 'belum_bayar' check (status in ('belum_bayar','sudah_bayar')),
  paid_txn_id   text references transactions(id) on delete set null,  -- auto-linked kas_keluar/bank_keluar payment
  paid_date     date,
  created_by    uuid references profiles(id),
  created_at    timestamptz not null default now()
);
create index if not exists idx_hutang_status on hutang_dagang(status);
create index if not exists idx_hutang_vendor on hutang_dagang(vendor_id);

-- =====================================================================
-- Row Level Security — any authenticated user with a `profiles` row
-- (role admin or owner) gets full read/write. Anonymous / unlisted
-- users get nothing. Tighten per-role rules later if needed.
-- =====================================================================
create or replace function is_app_user()
returns boolean
language sql
security definer
stable
as $$
  select exists (select 1 from profiles where id = auth.uid());
$$;

do $$
declare
  t text;
begin
  for t in select unnest(array['customers','vendors','projects','coa','transactions','jurnal_umum','hutang_dagang'])
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists app_user_all on %I', t);
    execute format(
      'create policy app_user_all on %I for all using (is_app_user()) with check (is_app_user())',
      t
    );
  end loop;
end $$;

alter table profiles enable row level security;
drop policy if exists profiles_self_read on profiles;
create policy profiles_self_read on profiles for select using (is_app_user());
-- profiles rows are created by an admin via the Supabase dashboard / service role key,
-- never by the app itself, so no insert/update/delete policy is granted here.
