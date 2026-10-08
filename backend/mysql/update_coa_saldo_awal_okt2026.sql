-- Penyesuaian saldo awal Master COA (Oktober 2026).
-- Hanya 9 akun yang nilainya berubah dari penyesuaian terbaru --
-- akun lain yang tidak disebutkan di sini sudah 0 dan tidak perlu diubah.
-- Jalankan lewat phpMyAdmin (tab SQL) atau `mysql -u <user> -p <db> < update_coa_saldo_awal_okt2026.sql`.

UPDATE coa SET saldo_awal = 10000000    WHERE kode = '1.1.02';  -- Kas Kecil
UPDATE coa SET saldo_awal = 320226      WHERE kode = '1.1.13';  -- Bank BNI PT
UPDATE coa SET saldo_awal = 171602782   WHERE kode = '1.1.14';  -- Bank BNI Prakasa
UPDATE coa SET saldo_awal = 75000000    WHERE kode = '1.1.21';  -- Piutang Usaha
UPDATE coa SET saldo_awal = 135160000   WHERE kode = '1.1.24';  -- Biaya Dibayar Dimuka
UPDATE coa SET saldo_awal = 9000000     WHERE kode = '1.1.37';  -- Bank BJB PT
UPDATE coa SET saldo_awal = 7000000     WHERE kode = '1.1.38';  -- Bank BJB CV Purbayanti
UPDATE coa SET saldo_awal = 32200000    WHERE kode = '1.1.41';  -- Piutang Lainnya
UPDATE coa SET saldo_awal = 506561984   WHERE kode = '2.1.1';   -- Hutang Dagang
UPDATE coa SET saldo_awal = 468410177   WHERE kode = '2.2.1';   -- Hutang Pihak Ke-3 (jk panjang)
UPDATE coa SET saldo_awal = -534689153  WHERE kode = '3.9.9';   -- Ikhtisar Laba Rugi

-- Cek hasilnya:
SELECT kode, nama, saldo_awal FROM coa
WHERE kode IN ('1.1.02','1.1.13','1.1.14','1.1.21','1.1.24','1.1.37','1.1.38','1.1.41','2.1.1','2.2.1','3.9.9')
ORDER BY kode;
