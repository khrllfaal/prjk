-- Hapus SEMUA isian absen proyek Cibalong. Pekerja, tarif, kasbon, tambahan/potongan, dan pembayaran TIDAK disentuh.
-- Jalankan di phpMyAdmin (pilih database aplikasi), per bagian, dari atas ke bawah.

-- 1) PERIKSA dulu: proyek yang cocok (harus tepat 1 baris) dan jumlah absen yang akan terhapus
SELECT id, nama FROM projects WHERE nama LIKE '%cibalong%';
SELECT COUNT(*) AS jumlah_absen, MIN(tgl) AS dari, MAX(tgl) AS sampai
  FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama LIKE '%cibalong%');

-- 2) PERIKSA: periode gaji yang sudah disetujui/dibayar (jika ada, hapus absen akan membuat total gaji periode itu menjadi 0)
SELECT tgl_mulai, tgl_akhir, status FROM payroll_periods
 WHERE project_id IN (SELECT id FROM projects WHERE nama LIKE '%cibalong%') AND status <> 'draft';

-- 3) CADANGAN (sekali jalan): salinan absen yang akan dihapus
CREATE TABLE IF NOT EXISTS attendance_cadangan_cibalong AS
  SELECT * FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama LIKE '%cibalong%');

-- 4) HAPUS (jalankan hanya jika langkah 1 menunjukkan 1 proyek dan angka yang benar)
DELETE FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama LIKE '%cibalong%');

-- 5) Periode berstatus draft yang kini kosong boleh dibersihkan (opsional)
DELETE FROM payroll_periods
 WHERE project_id IN (SELECT id FROM projects WHERE nama LIKE '%cibalong%') AND status = 'draft'
   AND id NOT IN (SELECT period_id FROM payroll_adjustments) AND id NOT IN (SELECT period_id FROM payroll_payments);

-- Batalkan (kembalikan dari cadangan) bila salah:
-- INSERT INTO attendance SELECT * FROM attendance_cadangan_cibalong;
-- Setelah yakin benar: DROP TABLE attendance_cadangan_cibalong;
