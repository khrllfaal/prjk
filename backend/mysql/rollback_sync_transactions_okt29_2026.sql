-- Rollback sinkronisasi 29 Oktober 2026.

DELETE FROM `transactions` WHERE `ref` IN ('BO-2610-0037', 'BI-2610-0016', 'BI-2610-0017', 'CO-2610-1520', 'CO-2610-1521', 'CO-2610-1522', 'CO-2610-1523', 'CO-2610-1524', 'CO-2610-1525', 'CO-2610-1526', 'CO-2610-1527', 'CO-2610-1528', 'CO-2610-1529', 'CO-2610-1530', 'CO-2610-1531', 'CO-2610-1532', 'CO-2610-1533', 'CO-2610-1534', 'CO-2610-1535', 'CO-2610-1536', 'CO-2610-1537', 'CO-2610-1538', 'CO-2610-1539', 'CO-2610-1540', 'CO-2610-1541', 'CO-2610-1542', 'CO-2610-1543', 'CO-2610-1544', 'CO-2610-1545', 'CO-2610-1546', 'CO-2610-1547', 'CO-2610-1548', 'CO-2610-1549', 'CO-2610-1550', 'CO-2610-1551', 'CO-2610-1552', 'CO-2610-1553', 'CO-2610-1554', 'CO-2610-1555', 'CO-2610-1556', 'CO-2610-1557', 'CO-2610-1558', 'CO-2610-1559', 'CO-2610-1560', 'CO-2610-1561', 'CO-2610-1562', 'CO-2610-1563', 'CO-2610-1564', 'CO-2610-1565', 'CO-2610-1566', 'CO-2610-1567', 'CO-2610-1568', 'CO-2610-1569', 'CO-2610-1570', 'CO-2610-1571', 'CO-2610-1572', 'CO-2610-1573', 'CO-2610-1574', 'CO-2610-1575', 'CO-2610-1576', 'CI-2610-0034', 'CI-2610-0035');

UPDATE `transactions` SET `ket` = 'bayaran pesantren al mabur' WHERE `ref` = 'CO-2610-0784' AND `ket` = 'bayaran pesantren al mabrur';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-0644' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-0645' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-0459' AND `akun_lawan` = 'Biaya Upah';
UPDATE `transactions` SET `project` = 'Kodim Kuningan' WHERE `ref` = 'CO-2610-1475' AND `project` = 'Kemhan Kodim Kuningan';
UPDATE `transactions` SET `project` = 'Kodim Kuningan' WHERE `ref` = 'CO-2610-1347' AND `project` = 'Kemhan Kodim Kuningan';
UPDATE `transactions` SET `project` = 'Kodim Majalengka' WHERE `ref` = 'CO-2610-0910' AND `project` = 'Kemhan Kodim Majalengka';
UPDATE `transactions` SET `project` = 'Kodim Majalengka' WHERE `ref` = 'CO-2610-0909' AND `project` = 'Kemhan Kodim Majalengka';
UPDATE `transactions` SET `project` = 'Kodim Subang' WHERE `ref` = 'CO-2610-0852' AND `project` = 'Kemhan Kodim Subang';
UPDATE `transactions` SET `project` = 'Kodim Purwakarta' WHERE `ref` = 'CO-2610-0851' AND `project` = 'Kemhan Kodim Purwakarta';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2610-0631' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2610-0301' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-1446' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-1138' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-0855' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-0854' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-0853' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-0712' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-0624' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2609-0623' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2608-1032' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2607-1008' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2607-0641' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2607-0620' AND `project` = 'KNMP Cibalong';
UPDATE `transactions` SET `project` = 'KNMP' WHERE `ref` = 'CO-2607-0619' AND `project` = 'KNMP Cibalong';
