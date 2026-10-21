-- 3 voucher jurnal baru (21 Oktober 2026), ditemukan dari jurnal_umum
-- bertambah 116 -> 119 baris. Detail per-akun dikonfirmasi owner dari
-- Detail Jurnal sistem asli, jumlah Debit sudah dicek sama dengan
-- Kredit (31.012.000+3.411.320=34.423.320, 4.260.000+468.600=4.728.600,
-- 3.040.000+334.400=3.374.400). Semua V-HU-Berkat.
INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('jcc182c3ef09c', '2026-10-21', 'JU26100131', 'Biaya Bahan', 'Tugu Perkim Cirebon', 'V-HU-Berkat', 'Bahan', '', 'posted', 'besi 8 15btg, besi ulir 10 40btg, besi 16 60btg, wiremesh 10mm 18btg (8/10) #berkat', 31012000.00, 0.00),
  ('j83a293497ba3', '2026-10-21', 'JU26100131', 'Biaya Bahan', 'Tugu Perkim Cirebon', 'V-HU-Berkat', 'Bahan', '', 'posted', 'besi 8 15btg, besi ulir 10 40btg, besi 16 60btg, wiremesh 10mm 18btg (8/10) #berkat', 3411320.00, 0.00),
  ('j75b3dd60f318', '2026-10-21', 'JU26100131', 'Hutang Dagang', 'Tugu Perkim Cirebon', 'V-HU-Berkat', '', '', 'posted', 'besi 8 15btg, besi ulir 10 40btg, besi 16 60btg, wiremesh 10mm 18btg (8/10) #berkat', 0.00, 34423320.00),
  ('j6fe3567e56bc', '2026-10-21', 'JU26100132', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', 'V-HU-Berkat', 'Bahan', '', 'posted', 'besi 22 12btg (7/10) #berkat', 4260000.00, 0.00),
  ('j19b8d6fa8398', '2026-10-21', 'JU26100132', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', 'V-HU-Berkat', 'Bahan', '', 'posted', 'besi 22 12btg (7/10) #berkat', 468600.00, 0.00),
  ('jf8502a0a8bbe', '2026-10-21', 'JU26100132', 'Hutang Dagang', 'Bina Marga Rehab Jembatan Provinsi', 'V-HU-Berkat', '', '', 'posted', 'besi 22 12btg (7/10) #berkat', 0.00, 4728600.00),
  ('j89f04293d824', '2026-10-21', 'JU26100133', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', 'V-HU-Berkat', 'Bahan', '', 'posted', 'paku roufing 100pcs, zince calum 0.3mm 22lembar. (9/10) #berkat', 3040000.00, 0.00),
  ('j10df3df49639', '2026-10-21', 'JU26100133', 'Biaya Bahan', 'Zidam Rehab Gudkesrah', 'V-HU-Berkat', 'Bahan', '', 'posted', 'paku roufing 100pcs, zince calum 0.3mm 22lembar. (9/10) #berkat', 334400.00, 0.00),
  ('jbeff79e34fe1', '2026-10-21', 'JU26100133', 'Hutang Dagang', 'Zidam Rehab Gudkesrah', 'V-HU-Berkat', '', '', 'posted', 'paku roufing 100pcs, zince calum 0.3mm 22lembar. (9/10) #berkat', 0.00, 3374400.00);
