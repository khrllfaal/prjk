-- Rollback sinkronisasi 30 Oktober 2026.

DELETE FROM `transactions` WHERE `ref` IN ('BO-2610-0038', 'BO-2610-0039', 'BI-2610-0018', 'CO-2610-1577', 'CO-2610-1578', 'CO-2610-1579', 'CO-2610-1580', 'CO-2610-1581', 'CO-2610-1582', 'CO-2610-1583', 'CO-2610-1584', 'CO-2610-1585', 'CO-2610-1586', 'CO-2610-1587', 'CO-2610-1588', 'CO-2610-1589', 'CO-2610-1590', 'CO-2610-1591', 'CO-2610-1592', 'CO-2610-1593', 'CO-2610-1594', 'CO-2610-1595', 'CO-2610-1596', 'CO-2610-1597', 'CO-2610-1598', 'CO-2610-1599', 'CO-2610-1600', 'CO-2610-1601', 'CO-2610-1602', 'CO-2610-1603', 'CO-2610-1604', 'CO-2610-1605', 'CO-2610-1606', 'CO-2610-1607', 'CO-2610-1608', 'CO-2610-1609', 'CO-2610-1610', 'CO-2610-1611', 'CO-2610-1612', 'CO-2610-1613', 'CO-2610-1614', 'CO-2610-1615', 'CO-2610-1616', 'CO-2610-1617', 'CO-2610-1618', 'CO-2610-1619', 'CO-2610-1620', 'CO-2610-1621', 'CO-2610-1622', 'CO-2610-1623', 'CO-2610-1624', 'CO-2610-1625', 'CO-2610-1626', 'CO-2610-1627', 'CO-2610-1628', 'CO-2610-1629', 'CO-2610-1630', 'CO-2610-1631', 'CO-2610-1632', 'CO-2610-1633', 'CO-2610-1634', 'CO-2610-1635', 'CO-2610-1636', 'CO-2610-1637', 'CO-2610-1638', 'CO-2610-1639', 'CO-2610-1640', 'CO-2610-1641', 'CO-2610-1642', 'CO-2610-1643', 'CO-2610-1644', 'CO-2610-1645', 'CO-2610-1646', 'CO-2610-1647', 'CO-2610-1648', 'CO-2610-1649', 'CO-2610-1650', 'CO-2610-1651', 'CO-2610-1652', 'CO-2610-1653', 'CO-2610-1654', 'CO-2610-1655', 'CO-2610-1656', 'CO-2610-1657', 'CO-2610-1658', 'CI-2610-0036', 'CI-2610-0037');

DELETE FROM `jurnal_umum` WHERE `ref` IN ('JU26100145', 'JU26100146');

DELETE FROM `vendors` WHERE `nama` = 'V-HU-Rajawali';

UPDATE `transactions` SET `relasi` = '' WHERE `ref` = 'CI-2610-0036' AND `relasi` = 'PK-Komeng';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Gaji Pegawai', `relasi` = '' WHERE `ref` = 'CO-2610-1206' AND `akun_lawan` = 'Piutang Karyawan' AND `relasi` = 'PK-Komeng';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Gaji Pegawai' WHERE `ref` = 'CO-2608-0097' AND `akun_lawan` = 'Cadangan THR';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Gaji Pegawai' WHERE `ref` = 'CO-2608-0099' AND `akun_lawan` = 'Cadangan THR';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Gaji Pegawai' WHERE `ref` = 'CO-2608-0100' AND `akun_lawan` = 'Cadangan THR';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Gaji Pegawai' WHERE `ref` = 'CO-2609-0130' AND `akun_lawan` = 'Cadangan THR';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Gaji Pegawai' WHERE `ref` = 'CO-2609-0132' AND `akun_lawan` = 'Cadangan THR';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2607-0387' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2607-0536' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2608-0088' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2608-0349' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2608-0642' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2608-0872' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2609-0037' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2609-0835' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2609-1181' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2609-1295' AND `project` = 'Kemhan Kodim Kab. Bogor';
UPDATE `transactions` SET `project` = 'Kodim Bogor' WHERE `ref` = 'CO-2610-1537' AND `project` = 'Kemhan Kodim Kab. Bogor';

