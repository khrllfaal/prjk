-- Hapus SEMUA absen dan kasbon proyek "Bina Marga Kodim Bangun Jalan Cibalong".
-- Pekerja, tarif, dan proyek TIDAK dihapus. Proyek lain tidak tersentuh.
-- Jalankan di phpMyAdmin (pilih database aplikasi), per bagian dari atas ke bawah. Bagian 1 hanya MELIHAT data.

-- ===== 1. PERIKSA DULU (tidak mengubah apa pun) =====
SELECT id, nama FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong';            -- harus tepat 1 baris
SELECT 'absen' AS data, COUNT(*) AS jumlah FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')
UNION ALL SELECT 'kasbon (buku kasbon)', COUNT(*) FROM kasbon WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')
UNION ALL SELECT 'pengajuan kasbon', COUNT(*) FROM kasbon_requests WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')
UNION ALL SELECT 'potongan kasbon pada gaji', COUNT(*) FROM payroll_adjustments WHERE kategori = 'kasbon' AND period_id IN (SELECT id FROM payroll_periods WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong'));
-- Periode yang sudah disetujui/dibayar (gajinya akan menjadi 0 setelah absen dihapus; pembayarannya TETAP ada):
SELECT tgl_mulai, tgl_akhir, status FROM payroll_periods WHERE status <> 'draft' AND project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');
-- Kontrak borongan (modul Borongan): jalankan baris di bawah HANYA jika tabel borongan_kontrak sudah ada (muncul setelah aplikasi versi baru diunggah dan ada yang login).
-- Bila muncul error "Table ... borongan_kontrak doesn't exist", artinya belum ada kontrak borongan sama sekali: aman, lanjut ke bagian 2.
-- Bila ada baris hasilnya, BERHENTI dan kabari saya sebelum lanjut.
-- SELECT no_kontrak, nama_pekerjaan, status FROM borongan_kontrak WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');

-- ===== 2. CADANGAN (salinan sebelum dihapus; aman dijalankan ulang) =====
CREATE TABLE IF NOT EXISTS attendance_cadangan_cibalong AS SELECT * FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');
CREATE TABLE IF NOT EXISTS kasbon_cadangan_cibalong AS SELECT * FROM kasbon WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');
CREATE TABLE IF NOT EXISTS kasbon_requests_cadangan_cibalong AS SELECT * FROM kasbon_requests WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');
CREATE TABLE IF NOT EXISTS potongan_kasbon_cadangan_cibalong AS SELECT * FROM payroll_adjustments WHERE kategori = 'kasbon' AND period_id IN (SELECT id FROM payroll_periods WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong'));

-- ===== 3. HAPUS (jalankan hanya setelah bagian 1 menunjukkan data yang benar) =====
DELETE FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');
DELETE FROM payroll_adjustments WHERE kategori = 'kasbon' AND period_id IN (SELECT id FROM payroll_periods WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong'));
DELETE FROM kasbon_requests WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');
DELETE FROM kasbon WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong');

-- ===== 4. OPSIONAL: bersihkan periode draft yang kini kosong =====
DELETE FROM payroll_periods WHERE status = 'draft' AND project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')
   AND id NOT IN (SELECT period_id FROM payroll_adjustments) AND id NOT IN (SELECT period_id FROM payroll_payments);

-- ===== 5. HASIL: semuanya harus 0 =====
SELECT (SELECT COUNT(*) FROM attendance WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')) AS absen,
       (SELECT COUNT(*) FROM kasbon WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')) AS kasbon,
       (SELECT COUNT(*) FROM kasbon_requests WHERE project_id IN (SELECT id FROM projects WHERE nama = 'Bina Marga Kodim Bangun Jalan Cibalong')) AS pengajuan_kasbon;

-- ===== PEMULIHAN bila salah (jalankan bagian yang diperlukan) =====
-- INSERT INTO attendance SELECT * FROM attendance_cadangan_cibalong;
-- INSERT INTO kasbon SELECT * FROM kasbon_cadangan_cibalong;
-- INSERT INTO kasbon_requests SELECT * FROM kasbon_requests_cadangan_cibalong;
-- INSERT INTO payroll_adjustments SELECT * FROM potongan_kasbon_cadangan_cibalong;
-- Setelah yakin benar, hapus cadangan:
-- DROP TABLE attendance_cadangan_cibalong, kasbon_cadangan_cibalong, kasbon_requests_cadangan_cibalong, potongan_kasbon_cadangan_cibalong;
