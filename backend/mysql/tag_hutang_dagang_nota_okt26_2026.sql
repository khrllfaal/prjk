-- Tag Kas Keluar Hutang Dagang historis dengan (Nota:ref) berdasarkan tanggal nota di keterangan.
-- Dicocokkan otomatis: vendor + project + tanggal yang disebut di keterangan, dan nominal persis sama
-- dengan nilai nota di Jurnal Umum (tidak ada ambigu/tebakan). Hasil status/sisa per nota TIDAK berubah
-- (FIFO sebelumnya sudah menebak dengan benar) -- ini hanya mengunci pencocokan supaya tidak goyah
-- oleh perubahan data di masa depan. Tidak menyentuh Jurnal Umum, hanya kolom ket di Kas Keluar.
-- Idempotent: skip baris yang sudah pernah ditag.

START TRANSACTION;

UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26060014)') WHERE ref = 'CO-2608-0478' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26060018)') WHERE ref = 'CO-2608-1040' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26060015)') WHERE ref = 'CO-2608-1041' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26080044)') WHERE ref = 'CO-2609-0590' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070026)') WHERE ref = 'CO-2609-0592' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070029)') WHERE ref = 'CO-2609-0595' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070025)') WHERE ref = 'CO-2609-0605' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070021)') WHERE ref = 'CO-2609-0652' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070024)') WHERE ref = 'CO-2609-0658' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070023)') WHERE ref = 'CO-2609-0668' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26080043)') WHERE ref = 'CO-2609-0670' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070027)') WHERE ref = 'CO-2609-0934' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070030)') WHERE ref = 'CO-2609-0941' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26080045)') WHERE ref = 'CO-2609-0944' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26080046)') WHERE ref = 'CO-2609-0946' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26070028)') WHERE ref = 'CO-2609-0953' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090077)') WHERE ref = 'CO-2609-1082' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090074)') WHERE ref = 'CO-2609-1200' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090079)') WHERE ref = 'CO-2609-1222' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090050)') WHERE ref = 'CO-2609-1223' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090051)') WHERE ref = 'CO-2609-1232' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090049)') WHERE ref = 'CO-2609-1239' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090048)') WHERE ref = 'CO-2609-1241' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090055)') WHERE ref = 'CO-2610-0396' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090081)') WHERE ref = 'CO-2610-0404' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090085)') WHERE ref = 'CO-2610-0736' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090080)') WHERE ref = 'CO-2610-0737' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090056)') WHERE ref = 'CO-2610-0747' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090084)') WHERE ref = 'CO-2610-0748' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090057)') WHERE ref = 'CO-2610-0770' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090058)') WHERE ref = 'CO-2610-0786' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090078)') WHERE ref = 'CO-2610-0787' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090082)') WHERE ref = 'CO-2610-1165' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090083)') WHERE ref = 'CO-2610-1168' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090097)') WHERE ref = 'CO-2610-1173' AND ket NOT LIKE '%(Nota:%';
UPDATE transactions SET ket = CONCAT(ket, ' (Nota:JU26090098)') WHERE ref = 'CO-2610-1175' AND ket NOT LIKE '%(Nota:%';

COMMIT;
