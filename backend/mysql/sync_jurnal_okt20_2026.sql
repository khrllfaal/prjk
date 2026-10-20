-- 2 voucher jurnal baru (20 Oktober 2026), ditemukan dari jurnal_umum
-- bertambah 114 -> 116 baris. Detail per-akun dikonfirmasi owner dari
-- Detail Jurnal sistem asli, jumlah Debit sudah dicek sama dengan
-- Kredit (45.500.000+5.005.000=50.505.000 dan
-- 49.835.135+5.481.865=55.317.000).
INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('j1b2c3d4e5f6', '2026-10-20', 'JU26100129', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', 'V-HU-Berkat', 'Bahan', '', 'posted', 'kanal c 130btg, zince calum 130lembar (7/10) #berkat', 45500000.00, 0.00),
  ('j2a3b4c5d6e7', '2026-10-20', 'JU26100129', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', 'V-HU-Berkat', 'Bahan', '', 'posted', 'kanal c 130btg, zince calum 130lembar (7/10) #berkat', 5005000.00, 0.00),
  ('j3f4e5d6c7b8', '2026-10-20', 'JU26100129', 'Hutang Dagang', 'Kemhan 2 Gudang Selatan', 'V-HU-Berkat', '', '', 'posted', 'kanal c 130btg, zince calum 130lembar (7/10) #berkat', 0.00, 50505000.00),
  ('j4d5c6b7a8f9', '2026-10-20', 'JU26100130', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', 'V-HU-Berkat', 'Bahan', '', 'posted', 'baud bajaringan 7000pcs, kanal c 170btg, zincecalum 0.3mm 130lembar (5/10) #berkat', 49835135.00, 0.00),
  ('j5e6f7a8b9c0', '2026-10-20', 'JU26100130', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', 'V-HU-Berkat', 'Bahan', '', 'posted', 'baud bajaringan 7000pcs, kanal c 170btg, zincecalum 0.3mm 130lembar (5/10) #berkat', 5481865.00, 0.00),
  ('j6f7e8d9c0b1', '2026-10-20', 'JU26100130', 'Hutang Dagang', 'Kemhan 2 Gudang Selatan', 'V-HU-Berkat', '', '', 'posted', 'baud bajaringan 7000pcs, kanal c 170btg, zincecalum 0.3mm 130lembar (5/10) #berkat', 0.00, 55317000.00);
