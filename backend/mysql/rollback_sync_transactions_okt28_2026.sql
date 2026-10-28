-- Rollback sinkronisasi 28 Oktober 2026.

DELETE FROM `transactions` WHERE `ref` IN ('BO-2610-0036', 'BI-2610-0014', 'BI-2610-0015', 'CO-2610-1448', 'CO-2610-1449', 'CO-2610-1450', 'CO-2610-1451', 'CO-2610-1452', 'CO-2610-1453', 'CO-2610-1454', 'CO-2610-1455', 'CO-2610-1456', 'CO-2610-1457', 'CO-2610-1458', 'CO-2610-1459', 'CO-2610-1460', 'CO-2610-1461', 'CO-2610-1462', 'CO-2610-1463', 'CO-2610-1464', 'CO-2610-1465', 'CO-2610-1466', 'CO-2610-1467', 'CO-2610-1468', 'CO-2610-1469', 'CO-2610-1470', 'CO-2610-1471', 'CO-2610-1472', 'CO-2610-1473', 'CO-2610-1474', 'CO-2610-1475', 'CO-2610-1476', 'CO-2610-1477', 'CO-2610-1478', 'CO-2610-1479', 'CO-2610-1480', 'CO-2610-1481', 'CO-2610-1482', 'CO-2610-1483', 'CO-2610-1484', 'CO-2610-1485', 'CO-2610-1486', 'CO-2610-1487', 'CO-2610-1488', 'CO-2610-1489', 'CO-2610-1490', 'CO-2610-1491', 'CO-2610-1492', 'CO-2610-1493', 'CO-2610-1494', 'CO-2610-1495', 'CO-2610-1496', 'CO-2610-1497', 'CO-2610-1498', 'CO-2610-1499', 'CO-2610-1500', 'CO-2610-1501', 'CO-2610-1502', 'CO-2610-1503', 'CO-2610-1504', 'CO-2610-1505', 'CO-2610-1506', 'CO-2610-1507', 'CO-2610-1508', 'CO-2610-1509', 'CO-2610-1510', 'CO-2610-1511', 'CO-2610-1512', 'CO-2610-1513', 'CO-2610-1514', 'CO-2610-1515', 'CO-2610-1516', 'CO-2610-1517', 'CO-2610-1518', 'CO-2610-1519', 'CI-2610-0032', 'CI-2610-0033');

UPDATE `transactions` SET `kredit` = 6992000.00, `ket` = 'paku rivet, silicone dowsil, kaca' WHERE `ref` = 'CO-2610-1417' AND `kredit` = 1112000.00;
UPDATE `transactions` SET `relasi` = '' WHERE `ref` = 'CO-2608-0325' AND `relasi` = 'V-HU-Berkat';
UPDATE `transactions` SET `ket` = 'belanja tgl 27' WHERE `ref` = 'CO-2610-1329' AND `ket` = 'belanja tgl 26';
UPDATE `transactions` SET `project` = 'Farm Cilame 1 periode 5', `akun_lawan` = 'Biaya CSR/Kompensasi/Sumbangan' WHERE `ref` = 'CO-2609-0952' AND `project` = 'Farm Cilame 1 periode 4';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Listrik, Air & Telepon' WHERE `ref` = 'CO-2609-0947' AND `akun_lawan` = 'Hutang lancar Lainnya';
UPDATE `transactions` SET `akun_lawan` = 'Peralatan Kandang' WHERE `ref` = 'CO-2608-0818' AND `akun_lawan` = 'Biaya Perlengkapan Kandang';

UPDATE `jurnal_umum` SET `kredit` = 21822400.00 WHERE `id` = 'j61' AND `kredit` = 21812400.00;
UPDATE `jurnal_umum` SET `debet` = 21822400.00 WHERE `id` = 'j60' AND `debet` = 21812400.00;
UPDATE `jurnal_umum` SET `kredit` = 7469200.00 WHERE `id` = 'j162' AND `kredit` = 7459200.00;
UPDATE `jurnal_umum` SET `debet` = 6729009.00 WHERE `id` = 'j160' AND `debet` = 6719009.00;
UPDATE `jurnal_umum` SET `kredit` = 7469200.00 WHERE `id` = 'j159' AND `kredit` = 7459200.00;
UPDATE `jurnal_umum` SET `debet` = 6729009.00 WHERE `id` = 'j157' AND `debet` = 6719009.00;
