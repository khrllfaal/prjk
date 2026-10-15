-- 1 voucher jurnal yang belum tercakup oleh sync_jurnal_okt13_2026.sql --
-- JU26100128 (tanggal 12 Oktober, nomor urutnya nyempil di antara
-- JU26100118 dan JU26100119 di Report terbaru) baru muncul di export
-- Report_2 hari ini; tidak ada di export-export sebelumnya. Detail
-- per-akun dikonfirmasi owner dari Detail Jurnal sistem asli, jumlah
-- Debit sudah dicek sama dengan Kredit (61.982.725 + 1.679.000 =
-- 63.661.725).
INSERT IGNORE INTO `jurnal_umum`
  (`id`, `tgl`, `ref`, `akun`, `project`, `relasi`, `kategori`, `no_faktur`, `status`, `ket`, `debet`, `kredit`)
VALUES
  ('j5a7a6d18fe30', '2026-10-12', 'JU26100128', 'Biaya Bahan', 'RS Guntur Belanja Dapur', '', 'Bahan', '', 'posted', 'belanja dapur 1-10 oktober', 61982725.00, 0.00),
  ('j931ac0b1b427', '2026-10-12', 'JU26100128', 'Biaya Akomodasi', 'RS Guntur Belanja Dapur', '', '', '', 'posted', 'belanja dapur 1-10 oktober', 1679000.00, 0.00),
  ('j77a62b10d93e', '2026-10-12', 'JU26100128', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', '', '', 'posted', 'belanja dapur 1-10 oktober', 0.00, 63661725.00);
