-- Sinkronisasi 6 November 2026.
--
-- 96 transaksi baru dari 5 file (jurnal_umum, bank_out, bank_in, cash_out, cash_in).
-- Tidak ada vendor/nota Hutang Dagang baru, tidak ada customer Piutang Usaha baru.
--
-- Penerimaan termin proyek baru (naik Rp2.063.393.859 di Trial Balance Pendapatan
-- Proyek): BI-2611-0003 'uang masuk jembatan munjul' Rp1.963.393.859 (Bina Marga Rehab
-- Jembatan Provinsi) + CI-2611-0005 'uang masuk jembatan cirebon' Rp100.000.000
-- (Jembatan Cirebon) -- jumlahnya pas 2.063.393.859, diverifikasi exact.
--
-- Piutang Lainnya: pasangan pinjam-lunas Rp50.000.000 yang menjelaskan kenaikan Saldo
-- Awal + Mutasi Kredit di Trial Balance -- bukan 2 transaksi baru, tapi 1 reklasifikasi
-- transaksi lama + 1 transaksi baru:
--  - CO-2610-1561 (29/10, lama): akun lawan 'Biaya ADM' -> 'Piutang Lainnya' (sisi pinjam,
--    makanya masuk Saldo Awal bulan November bukan Mutasi)
--  - CI-2611-0006 (baru) 'pengembalian deni (adm s)' Rp50.000.000 -> 'Piutang Lainnya'
--    (sisi lunas bulan ini, project 'BJB' sama, keterangan '(adm s)' sama persis)
--
-- Fix carry-over dari sync 5 November: CI-2608-0001 'Pinjaman Dari arif 30/7' Rp100.000.000
-- (transaksi lama, sudah ada sejak sync jauh sebelumnya) ternyata relasi-nya kosong --
-- INI (bukan pemecahan CO-2611-0212) adalah penyebab asli gap Rp100.000.000 di HPK-Arif
-- yang tadinya dikira perlu klarifikasi user. Buku Besar HPK-Arif yang user kirim untuk
-- sync ini mengkonfirmasi baris ini milik HPK-Arif. CO-2611-0212 TIDAK diubah (sudah benar
-- penuh ke HPK-Arif sejak sync 5 November).
--
-- 2 relasi Prive baru (delta Rp160.000, nominal kecil): CO-2611-0365 'benang sulam, tahu
-- (pa amzam)' Rp22.000 -> Pr-Z, CO-2611-0366 'baso, telur (pak ei)' Rp138.000 -> Pr-K
-- ('pak ei' konsisten Pr-K sepanjang riwayat).
--
-- Rename murni (anti-duplikasi, BUKAN project baru): 'RS Dustira Pengecatan Paving,
-- Genteng, Kolam & Lai' (nama lama, terpotong) -> 'RS Dustira Pengecatan Paving, Genteng,
-- dll (PL)' (nama baru dari laporan sumber) -- 120 transaksi lama. Dicek: tidak ada project
-- lain dengan nama serupa, ini satu project yang sama, bukan duplikat.
--
-- 45 koreksi NYATA lain pada transaksi lama (reklasifikasi akun lawan, kebanyakan
-- 'Biaya Upah2'/'Biaya Akomodasi' -> 'Biaya Upah3' -- upstream bulk reclass di sistem
-- sumber, konsisten dengan Trial Balance yang sekarang menampilkan '5.1.06 Biaya Upah3'
-- untuk pertama kali dengan saldo signifikan).
--
-- Pelajaran dari bug-bug sebelumnya: tidak ada UPDATE yang menyasar baris baru di-INSERT
-- di file ini -- semua relasi baru sudah langsung di nilai INSERT.

UPDATE `transactions` SET `relasi` = 'HPK-Arif' WHERE `ref` = 'CI-2608-0001' AND `relasi` = '';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'BI-2610-0005' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2606-0095' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2606-0186' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2606-0313' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2606-0525' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2606-0679' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3', `ket` = 'isi ulang galon 29/6' WHERE `ref` = 'CO-2607-0050' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2607-0316' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2607-0493' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2607-0529' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2607-0839' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0952' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0953' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0956' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0957' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0958' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0959' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-0974' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1026' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1145' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1146' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1147' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1148' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1149' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1150' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1151' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1152' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1153' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1154' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1155' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1156' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1178' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1187' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2607-1188' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0047' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0048' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0049' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2608-0055' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0110' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0111' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0112' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0113' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0114' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0115' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0116' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0117' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0118' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0119' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0120' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0121' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0122' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0124' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0196' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0197' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0198' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0199' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0275' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0296' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0330' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2608-0448' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0465' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0467' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2608-0472' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2608-0480' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0509' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0545' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0546' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0547' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0548' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0620' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0621' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0622' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0623' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0624' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0625' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0626' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0627' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2608-0640' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0692' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2608-0781' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0808' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0809' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0810' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0838' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-0898' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2608-1012' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0033' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0034' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2609-0123' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-0423' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2609-0601' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-0659' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0738' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0761' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0789' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0820' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Bahan' WHERE `ref` = 'CO-2609-0823' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0872' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-0912' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2609-0932' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1028' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1029' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1118' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1186' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1194' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1331' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1332' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2609-1350' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2609-1360' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1418' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1419' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2609-1437' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1461' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2609-1492' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0140' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0142' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0143' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-0147' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0157' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0163' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0190' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0240' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0241' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0271' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0279' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-0364' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-0400' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0474' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0475' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0476' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0567' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-0572' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0642' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-0746' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-0753' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-0765' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'Kemhan Cut n Fill', `ket` = 'kasbon tim jalan cimahi 14/10' WHERE `ref` = 'CO-2610-0767' AND `project` = 'Kemhan Bangun Rumdis Cimahi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-0869' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-0884' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1264' AND `akun_lawan` = 'Biaya Akomodasi';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1265' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1355' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1360' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1361' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-1447' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-1484' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2610-1542' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Piutang Lainnya' WHERE `ref` = 'CO-2610-1561' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1631' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2610-1633' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0068' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0069' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0070' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0071' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0072' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2611-0090' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0156' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0157' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0158' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2611-0168' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2611-0169' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah3' WHERE `ref` = 'CO-2611-0170' AND `akun_lawan` = 'Biaya Upah2';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0247' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0248' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0249' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';
UPDATE `transactions` SET `project` = 'RS Dustira Pengecatan Paving, Genteng, dll (PL)' WHERE `ref` = 'CO-2611-0317' AND `project` = 'RS Dustira Pengecatan Paving, Genteng, Kolam & Lai';

INSERT IGNORE INTO `transactions`
  (`id`, `jenis`, `tgl`, `ref`, `akun_kas`, `akun_lawan`, `project`, `relasi`, `ket`, `debet`, `kredit`)
VALUES
  ('te6979d0052d3', 'bank_keluar', '2026-11-06', 'BO-2611-0009', 'Bank BJB RC Prakasa', 'Ayat Silang Kas Besar Kas-Bank', 'Cost Center - Pendanaan Uang', '', 'penarikan 6 november', 0.00, 1333457147.00),
  ('t37d7e94cd6d6', 'bank_masuk', '2026-11-06', 'BI-2611-0003', 'Bank BJB RC Prakasa', 'Pendapatan Proyek', 'Bina Marga Rehab Jembatan Provinsi', '', 'uang masuk jembatan munjul', 1963393859.00, 0.00),
  ('t37e93e50e20e', 'kas_keluar', '2026-11-06', 'CO-2611-0351', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin cary abu', 0.00, 100000.00),
  ('t19f379eaf786', 'kas_keluar', '2026-11-06', 'CO-2611-0352', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin carry 4/11', 0.00, 200000.00),
  ('t09cfa8df6b63', 'kas_keluar', '2026-11-06', 'CO-2611-0353', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin rendy 5/11', 0.00, 30150.00),
  ('t39b04a929488', 'kas_keluar', '2026-11-06', 'CO-2611-0354', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'bensin zenix 6/11', 0.00, 500000.00),
  ('t9da7993ba2e2', 'kas_keluar', '2026-11-06', 'CO-2611-0355', 'Kas Besar', 'Biaya Bunga & Administrasi Bank', 'Cost Center', '', 'biaya firecash', 0.00, 70000.00),
  ('t1d609d83feb4', 'kas_keluar', '2026-11-06', 'CO-2611-0356', 'Kas Besar', 'Biaya Makan Kantor Direksi', 'Cost Center', '', 'kopi, bubur, bihun', 0.00, 59000.00),
  ('t46ef3a5eb8ec', 'kas_keluar', '2026-11-06', 'CO-2611-0357', 'Kas Besar', 'Biaya BBM/Parkir/Tol', 'Cost Center', '', 'parkir', 0.00, 6000.00),
  ('ta65dde7df7d0', 'kas_keluar', '2026-11-06', 'CO-2611-0359', 'Kas Besar', 'Biaya Gaji Pegawai', 'Cost Center', '', 'bayaran komeng 30 okt - 5 nov', 0.00, 1085000.00),
  ('t9035b9fe385c', 'kas_keluar', '2026-11-06', 'CO-2611-0360', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'makan di sumedang (survey)', 0.00, 1652200.00),
  ('t9fa11f252fb7', 'kas_keluar', '2026-11-06', 'CO-2611-0361', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'Op direksi takziah ke karawang (22/10)', 0.00, 945300.00),
  ('t0cb64093be42', 'kas_keluar', '2026-11-06', 'CO-2611-0362', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'OP direksi ke rindam III siliwangi ketemu pak wirdanto (27/10)', 0.00, 563328.00),
  ('t1fda0122e36d', 'kas_keluar', '2026-11-06', 'CO-2611-0363', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'Op pa fahri ke irigasi ciamis 5/11', 0.00, 709432.00),
  ('t6d9c4fb6bc94', 'kas_keluar', '2026-11-06', 'CO-2611-0364', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Cost Center', '', 'Op pa fahri ke bulog jkt TNI 3/11', 0.00, 1406300.00),
  ('tee1bb66f0cd6', 'kas_keluar', '2026-11-06', 'CO-2611-0365', 'Kas Besar', 'Prive', 'Prive', 'Pr-Z', 'benang sulam, tahu (pa amzam)', 0.00, 22000.00),
  ('td30b3272ce95', 'kas_keluar', '2026-11-06', 'CO-2611-0366', 'Kas Besar', 'Prive', 'Prive', 'Pr-K', 'baso, telur (pak ei)', 0.00, 138000.00),
  ('te16b21ec02f8', 'kas_keluar', '2026-11-06', 'CO-2611-0367', 'Kas Besar', 'Biaya ADM', 'Kemhan Tahap 2', '', 'setoran awal CV prakasa dan PT prakasa', 0.00, 2000000.00),
  ('t21fc9328c566', 'kas_keluar', '2026-11-06', 'CO-2611-0368', 'Kas Besar', 'Biaya entertain', 'Kemhan Tahap 2', '', 'makan', 0.00, 608500.00),
  ('t889de6bf0c9f', 'kas_keluar', '2026-11-06', 'CO-2611-0369', 'Kas Besar', 'Biaya ADM', 'Kemhan Tahap 2', '', 'deden', 0.00, 5000000.00),
  ('t71da31c26927', 'kas_keluar', '2026-11-06', 'CO-2611-0370', 'Kas Besar', 'Biaya Bahan', 'KNMP Pekalongan', '', 'pekalongan', 0.00, 500000000.00),
  ('t519682278bd6', 'kas_keluar', '2026-11-06', 'CO-2611-0371', 'Kas Besar', 'Biaya ADM', 'Tugu Perkim Cirebon', '', 'lsm', 0.00, 4000000.00),
  ('t7e3eb80b3e8c', 'kas_keluar', '2026-11-06', 'CO-2611-0373', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'ADM', 0.00, 54770672.00),
  ('te8e5dd43c703', 'kas_keluar', '2026-11-06', 'CO-2611-0374', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'Mingguan pengawas', 0.00, 5250000.00),
  ('t976ff955df8f', 'kas_keluar', '2026-11-06', 'CO-2611-0375', 'Kas Besar', 'Biaya ADM', 'RS Guntur Gudang Farmasi', '', 'Wasrik', 0.00, 3700000.00),
  ('t8490072a63d4', 'kas_keluar', '2026-11-06', 'CO-2611-0376', 'Kas Besar', 'Biaya Upah', 'RS Guntur Gudang Farmasi', '', 'Kasbon tim h dana', 0.00, 35000000.00),
  ('t4de84551dd39', 'kas_keluar', '2026-11-06', 'CO-2611-0377', 'Kas Besar', 'Biaya Upah', 'Zidam Renov Rumdis Bogor', '', 'Kasbon bu rina upah', 0.00, 60500000.00),
  ('td641a2cd0e2d', 'kas_keluar', '2026-11-06', 'CO-2611-0378', 'Kas Besar', 'Biaya Perjalanan Dinas Pegawai', 'Kemhan Kodim Kuningan Indramayu', '', 'op yuki kodim cirebon & indramayu 5/11', 0.00, 999900.00),
  ('t9832041506ac', 'kas_keluar', '2026-11-06', 'CO-2611-0379', 'Kas Besar', 'Biaya Perjalanan Dinas Direksi', 'Kemhan Kodim Kab Sukabumi', '', 'op pa fahri ke kodim sukabumi & bogor 4/11', 0.00, 1140000.00),
  ('tfa557d42619e', 'kas_keluar', '2026-11-06', 'CO-2611-0380', 'Kas Besar', 'Biaya Upah', 'Kemhan Kodim Subang', '', 'kodim subang', 0.00, 55461821.00),
  ('t0b95168f2fe0', 'kas_keluar', '2026-11-06', 'CO-2611-0381', 'Kas Besar', 'Biaya Dibayar Dimuka', 'RS Guntur Belanja Dapur', '', 'belanja tgl 6', 0.00, 6000000.00),
  ('tf41759fc1bdb', 'kas_keluar', '2026-11-06', 'CO-2611-0382', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'batu belah 29 rit kiriman 28 okt - 4 nov', 0.00, 37700000.00),
  ('t45314ef75e6a', 'kas_keluar', '2026-11-06', 'CO-2611-0383', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bronjong', 0.00, 16400000.00),
  ('t4dc7478a21d0', 'kas_keluar', '2026-11-06', 'CO-2611-0384', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'pasir cor 1 - 5 nov', 0.00, 12682400.00),
  ('t286ca9346d7c', 'kas_keluar', '2026-11-06', 'CO-2611-0385', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim jaga alat', 0.00, 1400000.00),
  ('t48bbfbc20db5', 'kas_keluar', '2026-11-06', 'CO-2611-0386', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran tim cihelang', 0.00, 5820000.00),
  ('t2c65e8a8c3b4', 'kas_keluar', '2026-11-06', 'CO-2611-0387', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayarn tim garut', 0.00, 8532000.00),
  ('tb05554332266', 'kas_keluar', '2026-11-06', 'CO-2611-0388', 'Kas Besar', 'Biaya Upah', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'bayaran operator beko', 0.00, 1990000.00),
  ('t3b69bf351fb9', 'kas_keluar', '2026-11-06', 'CO-2611-0389', 'Kas Besar', 'Biaya Akomodasi', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas cibalong (bensin, servis motor)', 0.00, 2330000.00),
  ('t8fa5e723dad6', 'kas_keluar', '2026-11-06', 'CO-2611-0390', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Kodim Bangun Jalan Cibalong', '', 'kas cibalong (sendok tembok, meteran, ban roda arco dll0', 0.00, 330000.00),
  ('t38ffbd684b97', 'kas_keluar', '2026-11-06', 'CO-2611-0391', 'Kas Besar', 'Biaya Bahan', 'RS Dustira Bangun Ruang Kenanga', '', 'buang barangkal', 0.00, 3600000.00),
  ('t02a5057c7537', 'kas_keluar', '2026-11-06', 'CO-2611-0392', 'Kas Besar', 'Biaya Upah2', 'RS Dustira Bangun Ruang Kenanga', '', 'upah tim agus alumunium (pot. kasbon 20 jt)', 0.00, 44833000.00),
  ('t3600362dc03d', 'kas_keluar', '2026-11-06', 'CO-2611-0393', 'Kas Besar', 'Biaya ADM', 'RS Dustira Bangun Ruang Kenanga', '', 'adm nrwidyt', 0.00, 1500000.00),
  ('t728298c02cd6', 'kas_keluar', '2026-11-06', 'CO-2611-0394', 'Kas Besar', 'Biaya Upah', 'RS Dustira Bangun Ruang Kenanga', '', 'bayaran pekerja 30 okt - 5 nov', 0.00, 8636000.00),
  ('tfc788f0d4364', 'kas_keluar', '2026-11-06', 'CO-2611-0395', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'bahan 3/11', 0.00, 3120000.00),
  ('teb10586c6af7', 'kas_keluar', '2026-11-06', 'CO-2611-0396', 'Kas Besar', 'Biaya Bahan', 'Proyek Antapani', '', 'DP lemari', 0.00, 5250000.00),
  ('t4e6ef2a130d8', 'kas_keluar', '2026-11-06', 'CO-2611-0397', 'Kas Besar', 'Biaya Upah', 'Proyek Antapani', '', 'bayaran pekerja 30 okt - 5 nov', 0.00, 4900000.00),
  ('t16cadf856c68', 'kas_keluar', '2026-11-06', 'CO-2611-0398', 'Kas Besar', 'Biaya Upah', 'Proyek Antapani', '', 'kasbon tim baja', 0.00, 7000000.00),
  ('te4baf2d4b149', 'kas_keluar', '2026-11-06', 'CO-2611-0399', 'Kas Besar', 'Biaya Upah', 'RS Dustira Pengecatan Paving, Genteng, dll (PL)', '', 'kasbon putra pek. furniture (nursetation d & kabinet wastafe))', 0.00, 32500000.00),
  ('t9e531fa6eb91', 'kas_keluar', '2026-11-06', 'CO-2611-0401', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'adm an dadang', 0.00, 500000.00),
  ('t1c8ccfca1dd3', 'kas_keluar', '2026-11-06', 'CO-2611-0402', 'Kas Besar', 'Fee Tenaga Ahli', 'Kemhan', '', 'kasbon pembuatan RAB kodim kodim', 0.00, 5000000.00),
  ('t91ada214c12e', 'kas_keluar', '2026-11-06', 'CO-2611-0403', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'uju', 0.00, 4000000.00),
  ('td1349ebe8ea6', 'kas_keluar', '2026-11-06', 'CO-2611-0404', 'Kas Besar', 'Biaya ADM', 'Kemhan', '', 'dwi', 0.00, 4000000.00),
  ('t9f225e8042ae', 'kas_keluar', '2026-11-06', 'CO-2611-0405', 'Kas Besar', 'Biaya Upah', 'Brigif kujang', '', 'h dana', 0.00, 16000000.00),
  ('tf0abd6802734', 'kas_keluar', '2026-11-06', 'CO-2611-0406', 'Kas Besar', 'Biaya Upah', 'Armed', '', 'h dana', 0.00, 25000000.00),
  ('ta6f582a75c52', 'kas_keluar', '2026-11-06', 'CO-2611-0407', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', 'kasbon septian', 0.00, 1000000.00),
  ('t7f14d4c4aa77', 'kas_keluar', '2026-11-06', 'CO-2611-0408', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Subang', '', 'upah subang kopel 1 - 5', 0.00, 24594125.00),
  ('t1101c5cdfe72', 'kas_keluar', '2026-11-06', 'CO-2611-0409', 'Kas Besar', 'Biaya Akomodasi', 'Kemhan Bangun Rumdis Subang', '', 'bensin bayu 3 - 4 nov', 0.00, 49800.00),
  ('t40ab49b44d8c', 'kas_keluar', '2026-11-06', 'CO-2611-0410', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Subang', '', 'handel pintu 100 pax, engsel 150 pak', 0.00, 18376490.00),
  ('t7fce5906d566', 'kas_keluar', '2026-11-06', 'CO-2611-0411', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Cimahi', '', 'kelistrikan', 0.00, 672000.00),
  ('tda96e03ceccc', 'kas_keluar', '2026-11-06', 'CO-2611-0412', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon upah plafond', 0.00, 5000000.00),
  ('t83fde588adf1', 'kas_keluar', '2026-11-06', 'CO-2611-0413', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon upah granit', 0.00, 5000000.00),
  ('t0753d85704fd', 'kas_keluar', '2026-11-06', 'CO-2611-0414', 'Kas Besar', 'Biaya Upah', 'Kemhan Bangun Rumdis Cimahi', '', 'egi', 0.00, 10000000.00),
  ('t4e72df39a806', 'kas_keluar', '2026-11-06', 'CO-2611-0415', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'kasbon pribadi ujang', 0.00, 500000.00),
  ('t54100856b62a', 'kas_keluar', '2026-11-06', 'CO-2611-0416', 'Kas Besar', 'Biaya Upah3', 'Kemhan Bangun Rumdis Cimahi', '', 'bayaran pekerja 30 okt - 5 nov', 0.00, 32928500.00),
  ('t8f0a7686872f', 'kas_keluar', '2026-11-06', 'CO-2611-0417', 'Kas Besar', 'Biaya Bahan', 'Kemhan Kodim Kuningan Indramayu', '', 'kasbon upah dan bahan', 0.00, 11000000.00),
  ('tca48c3c6606f', 'kas_keluar', '2026-11-06', 'CO-2611-0418', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'ritase uang lintas tim cor jalan subang', 0.00, 500000.00),
  ('tc35174ad21df', 'kas_keluar', '2026-11-06', 'CO-2611-0419', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'uang lintas truk mixer subang', 0.00, 7700000.00),
  ('t69901f0ff95c', 'kas_keluar', '2026-11-06', 'CO-2611-0420', 'Kas Besar', 'Biaya Upah', 'Kemhan Cut n Fill', '', 'kasbon pekerja jalan subang', 0.00, 15000000.00),
  ('ta0ce37ab97e6', 'kas_keluar', '2026-11-06', 'CO-2611-0421', 'Kas Besar', 'Biaya Bahan', 'Kemhan Cut n Fill', '', 'beton jalan umum subang', 0.00, 3600000.00),
  ('t2301fbcf2141', 'kas_keluar', '2026-11-06', 'CO-2611-0422', 'Kas Besar', 'Biaya Upah3', 'Bina Marga Rehab Jembatan Provinsi', '', 'upah jasa pancang', 0.00, 27500000.00),
  ('t3191b5db8f0d', 'kas_keluar', '2026-11-06', 'CO-2611-0423', 'Kas Besar', 'Biaya Bahan', 'Bina Marga Rehab Jembatan Provinsi', '', 'solar untuk pompa', 0.00, 150000.00),
  ('tab18372676a6', 'kas_keluar', '2026-11-06', 'CO-2611-0424', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan zipur', 0.00, 1500000.00),
  ('ta8e34deb54d9', 'kas_keluar', '2026-11-06', 'CO-2611-0425', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'flagman', 0.00, 5600000.00),
  ('tb7e68921963e', 'kas_keluar', '2026-11-06', 'CO-2611-0426', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'mingguan', 0.00, 1500000.00),
  ('ta8265407c36f', 'kas_keluar', '2026-11-06', 'CO-2611-0427', 'Kas Besar', 'Biaya Upah', 'Bina Marga Rehab Jembatan Provinsi', '', 'ajuan asep yudi', 0.00, 7500000.00),
  ('t2ba99c69922b', 'kas_keluar', '2026-11-06', 'CO-2611-0428', 'Kas Besar', 'Biaya Upah2', 'Bina Marga Rehab Jembatan Provinsi', '', 'jaga pancang', 0.00, 600000.00),
  ('t71a5604f5e2a', 'kas_keluar', '2026-11-06', 'CO-2611-0429', 'Kas Besar', 'Biaya Akomodasi', 'BJB Makassar', '', 'pembelian tiket makasar (kantor)', 0.00, 11917065.00),
  ('t5b290a93c8b4', 'kas_keluar', '2026-11-06', 'CO-2611-0430', 'Kas Besar', 'Biaya Akomodasi', 'BJB Makassar', '', 'pembelian tiket makasar (putra0', 0.00, 9738065.00),
  ('t38e37ed3231e', 'kas_keluar', '2026-11-06', 'CO-2611-0431', 'Kas Besar', 'Biaya Bahan', 'Kemhan Bangun Rumdis Bogor', '', 'pintu wc', 0.00, 7500000.00),
  ('t210dd5170ac7', 'kas_keluar', '2026-11-06', 'CO-2611-0432', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'roskam 60 cm 15 pcs', 0.00, 778850.00),
  ('t2e55d5a0a784', 'kas_keluar', '2026-11-06', 'CO-2611-0433', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'bayaran pekerja 30 okt - 5 nov', 0.00, 44931250.00),
  ('t3f3ec6685606', 'kas_keluar', '2026-11-06', 'CO-2611-0434', 'Kas Besar', 'Biaya Bahan', 'Kemhan 2 Gudang Selatan', '', 'buang sampah', 0.00, 1000000.00),
  ('t1bc85526d51a', 'kas_keluar', '2026-11-06', 'CO-2611-0435', 'Kas Besar', 'Biaya Upah', 'Kemhan 2 Gudang Selatan', '', 'penebangan pohon', 0.00, 2002500.00),
  ('t9b101cdebb18', 'kas_keluar', '2026-11-06', 'CO-2611-0436', 'Kas Besar', 'Biaya ADM', 'Proyek Patrakomala', '', 'pengawas', 0.00, 1752500.00),
  ('t1852a934b671', 'kas_keluar', '2026-11-06', 'CO-2611-0437', 'Kas Besar', 'Biaya ADM', 'ZIDAM Bangun Rumdis Pangandaran', '', 'adm termen', 0.00, 8700000.00),
  ('t0ed1a1ca5d1c', 'kas_keluar', '2026-11-06', 'CO-2611-0438', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'pasir pasang 2 rit', 0.00, 3700000.00),
  ('t580aab1d082f', 'kas_keluar', '2026-11-06', 'CO-2611-0439', 'Kas Besar', 'Biaya Upah', 'PUPR Bangun Satpol PP Sumedang', '', 'kasbon tim h. dana', 0.00, 80000000.00),
  ('t0bbb90636861', 'kas_keluar', '2026-11-06', 'CO-2611-0440', 'Kas Besar', 'Biaya Bahan', 'PUPR Bangun Satpol PP Sumedang', '', 'cat kolom', 0.00, 2362000.00),
  ('t8137c00af7d9', 'kas_keluar', '2026-11-06', 'CO-2611-0441', 'Kas Besar', 'Biaya Upah', 'Zidam Rehab Rumdis Cimahi', '', 'bayaran pekerja 30 okt - 5 nov', 0.00, 40253000.00),
  ('t0a81d30ba14d', 'kas_keluar', '2026-11-06', 'CO-2611-0442', 'Kas Besar', 'Biaya Upah', 'Masjid RS Guntur', '', 'upah kerja pek. wc', 0.00, 7920000.00),
  ('t13e114426af0', 'kas_keluar', '2026-11-06', 'CO-2611-0443', 'Kas Besar', 'Biaya Upah', 'Korem Garut', '', 'bayaran pekerja 4 -5 nov', 0.00, 690000.00),
  ('te919f8670978', 'kas_keluar', '2026-11-06', 'CO-2611-0444', 'Kas Besar', 'Biaya ADM', 'Bina Marga Rehab Jembatan Provinsi', '', 'kasbon sewa jajang', 0.00, 15000000.00),
  ('t2526d49e5d8a', 'kas_masuk', '2026-11-06', 'CI-2611-0005', 'Kas Besar', 'Pendapatan Proyek', 'Jembatan Cirebon', '', 'uang masuk jembatan cirebon', 100000000.00, 0.00),
  ('t9a3654cebd19', 'kas_masuk', '2026-11-06', 'CI-2611-0006', 'Kas Besar', 'Piutang Lainnya', 'BJB', '', 'pengembalian deni (adm s)', 50000000.00, 0.00),
  ('tcdf41a9ccac1', 'kas_masuk', '2026-11-06', 'CI-2611-0007', 'Kas Besar', 'Ayat Silang Kas Besar Kas-Bank', 'Bina Marga Rehab Jembatan Provinsi', '', 'penarikan 6 november', 1333457147.00, 0.00);
