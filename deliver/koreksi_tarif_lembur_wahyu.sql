-- Koreksi tarif lembur Wahyu (proyek Gudang Utara) menjadi Rp 18.750 untuk absen tanggal 30 Okt 2026 dan seterusnya.
-- Hanya baris absen Wahyu mulai 30 Okt, dan hanya bila periodenya belum disetujui/dibayar (periode yang sudah
-- disetujui atau dibayar TIDAK diubah). Absen baru yang diinput sesudah tarif di Pekerja & Tarif diganti sudah otomatis memakai tarif baru.
-- Jalankan di phpMyAdmin (pilih database aplikasi), per bagian dari atas ke bawah. Bagian 1 hanya MELIHAT data.

-- ===== 1. PERIKSA DULU (tidak mengubah apa pun) =====
-- a) Harus tepat 1 proyek dan 1 pekerja, tarif_lembur pekerja 18750:
SELECT id, nama FROM projects WHERE nama = 'Gudang Utara';
SELECT w.id, w.nama, w.grade, w.tarif_harian, w.tarif_lembur FROM workers w JOIN projects p ON p.id = w.project_id WHERE p.nama = 'Gudang Utara' AND w.nama = 'Wahyu';
-- b) Baris absennya: kolom tarif_lembur yang akan diubah adalah yang bukan 18750 (diduga 18500).
SELECT a.tgl, a.hari, a.lembur_jam, a.tarif_harian, a.tarif_lembur
  FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Gudang Utara' AND w.nama = 'Wahyu' AND a.tgl >= '2026-10-30' ORDER BY a.tgl;
-- c) Status periodenya: yang 'draft' atau 'diajukan' akan diubah; 'disetujui' dan 'dibayar' dilewati.
SELECT pp.tgl_mulai, pp.tgl_akhir, pp.status FROM payroll_periods pp JOIN projects p ON p.id = pp.project_id
 WHERE p.nama = 'Gudang Utara' AND pp.tgl_akhir >= '2026-10-30' ORDER BY pp.tgl_mulai;

-- ===== 2. CADANGAN (aman dijalankan ulang) =====
CREATE TABLE IF NOT EXISTS attendance_cadangan_wahyu AS
SELECT a.* FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Gudang Utara' AND w.nama = 'Wahyu' AND a.tgl >= '2026-10-30';

-- ===== 3. KOREKSI =====
UPDATE attendance a
  JOIN workers w ON w.id = a.worker_id
  JOIN projects p ON p.id = a.project_id
   SET a.tarif_lembur = 18750, a.rev = a.rev + 1
 WHERE p.nama = 'Gudang Utara' AND w.nama = 'Wahyu' AND a.tgl >= '2026-10-30'
   AND a.tarif_lembur <> 18750
   AND NOT EXISTS (SELECT 1 FROM payroll_periods pp
                    WHERE pp.project_id = a.project_id AND a.tgl BETWEEN pp.tgl_mulai AND pp.tgl_akhir
                      AND pp.status NOT IN ('draft', 'diajukan'));

-- ===== 4. PERIKSA HASIL =====
-- Baris yang masih bukan 18750 berarti periodenya sudah disetujui/dibayar (dilewati); kabari saya bila ada.
SELECT a.tgl, a.hari, a.lembur_jam, a.tarif_lembur FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Gudang Utara' AND w.nama = 'Wahyu' AND a.tgl >= '2026-10-30' ORDER BY a.tgl;

-- ===== MEMBATALKAN (bila perlu): kembalikan tarif dari cadangan =====
-- UPDATE attendance a JOIN attendance_cadangan_wahyu c ON c.worker_id = a.worker_id AND c.project_id = a.project_id AND c.tgl = a.tgl
--    SET a.tarif_lembur = c.tarif_lembur, a.rev = a.rev + 1;
-- Setelah yakin benar:  DROP TABLE attendance_cadangan_wahyu;
