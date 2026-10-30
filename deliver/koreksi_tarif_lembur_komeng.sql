-- Koreksi tarif lembur Komeng (proyek Cost Center) menjadi Rp 12.000 untuk absen 23-29 Okt 2026.
-- Hanya menyentuh baris absen Komeng di rentang itu, dan hanya bila periodenya belum disetujui/dibayar.
-- Jalankan di phpMyAdmin (pilih database aplikasi), per bagian dari atas ke bawah. Bagian 1 hanya MELIHAT data.

-- ===== 1. PERIKSA DULU (tidak mengubah apa pun) =====
-- a) Harus tepat 1 proyek dan 1 pekerja:
SELECT id, nama FROM projects WHERE nama = 'Cost Center';
SELECT w.id, w.nama, w.grade, w.tarif_harian, w.tarif_lembur FROM workers w JOIN projects p ON p.id = w.project_id WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng';
-- b) Baris absennya: kolom tarif_lembur harus 11500 (itu penyebab selisih). Total jam lembur harus 33.
SELECT a.tgl, a.hari, a.lembur_jam, a.tarif_harian, a.tarif_lembur
  FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND a.tgl BETWEEN '2026-10-23' AND '2026-10-29' ORDER BY a.tgl;
-- c) Status periodenya: harus 'draft' atau 'diajukan'. Bila 'disetujui' atau 'dibayar', BERHENTI dan kabari saya.
SELECT pp.tgl_mulai, pp.tgl_akhir, pp.status FROM payroll_periods pp JOIN projects p ON p.id = pp.project_id
 WHERE p.nama = 'Cost Center' AND pp.tgl_mulai <= '2026-10-29' AND pp.tgl_akhir >= '2026-10-23';

-- ===== 2. CADANGAN (aman dijalankan ulang) =====
CREATE TABLE IF NOT EXISTS attendance_cadangan_komeng AS
SELECT a.* FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND a.tgl BETWEEN '2026-10-23' AND '2026-10-29';

-- ===== 3. KOREKSI =====
UPDATE attendance a
  JOIN workers w ON w.id = a.worker_id
  JOIN projects p ON p.id = a.project_id
   SET a.tarif_lembur = 12000, a.rev = a.rev + 1
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND a.tgl BETWEEN '2026-10-23' AND '2026-10-29'
   AND a.tarif_lembur <> 12000
   AND NOT EXISTS (SELECT 1 FROM payroll_periods pp
                    WHERE pp.project_id = a.project_id AND a.tgl BETWEEN pp.tgl_mulai AND pp.tgl_akhir
                      AND pp.status NOT IN ('draft', 'diajukan'));

-- ===== 4. PERIKSA HASIL: semua baris harus 12000; gaji Komeng = 522.500 + 33 jam x 12.000 = 918.500 =====
SELECT a.tgl, a.hari, a.lembur_jam, a.tarif_lembur FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND a.tgl BETWEEN '2026-10-23' AND '2026-10-29' ORDER BY a.tgl;
SELECT SUM(a.hari * a.tarif_harian) AS gaji_pokok, SUM(a.lembur_jam * a.tarif_lembur) AS lembur, SUM(a.hari * a.tarif_harian + a.lembur_jam * a.tarif_lembur) AS total
  FROM attendance a JOIN workers w ON w.id = a.worker_id JOIN projects p ON p.id = a.project_id
 WHERE p.nama = 'Cost Center' AND w.nama = 'Komeng' AND a.tgl BETWEEN '2026-10-23' AND '2026-10-29';

-- ===== MEMBATALKAN (bila perlu): kembalikan tarif dari cadangan =====
-- UPDATE attendance a JOIN attendance_cadangan_komeng c ON c.worker_id = a.worker_id AND c.project_id = a.project_id AND c.tgl = a.tgl
--    SET a.tarif_lembur = c.tarif_lembur, a.rev = a.rev + 1;
-- Setelah yakin benar, tabel cadangan boleh dihapus:  DROP TABLE attendance_cadangan_komeng;
