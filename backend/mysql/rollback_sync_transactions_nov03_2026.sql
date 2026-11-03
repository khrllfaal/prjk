-- Rollback sinkronisasi 3 November 2026.

DELETE FROM `transactions` WHERE `ref` IN ('BO-2611-0002', 'BO-2611-0003', 'BO-2611-0004', 'BI-2611-0001', 'CO-2611-0113', 'CO-2611-0114', 'CO-2611-0115', 'CO-2611-0116', 'CO-2611-0117', 'CO-2611-0118', 'CO-2611-0119', 'CO-2611-0120', 'CO-2611-0121', 'CO-2611-0122', 'CO-2611-0123', 'CO-2611-0124', 'CO-2611-0125', 'CO-2611-0126', 'CO-2611-0127', 'CO-2611-0128', 'CO-2611-0129', 'CO-2611-0130', 'CO-2611-0131', 'CO-2611-0132', 'CO-2611-0133', 'CO-2611-0134', 'CO-2611-0135', 'CO-2611-0136', 'CO-2611-0137', 'CO-2611-0138', 'CO-2611-0139', 'CO-2611-0140', 'CO-2611-0141', 'CO-2611-0142', 'CO-2611-0143', 'CO-2611-0144', 'CO-2611-0145', 'CO-2611-0146', 'CO-2611-0147', 'CO-2611-0148', 'CO-2611-0149', 'CO-2611-0150', 'CO-2611-0151', 'CO-2611-0152', 'CO-2611-0153', 'CO-2611-0154', 'CO-2611-0155', 'CO-2611-0156', 'CO-2611-0157', 'CO-2611-0158', 'CO-2611-0159', 'CO-2611-0160', 'CO-2611-0161', 'CO-2611-0162', 'CO-2611-0163', 'CO-2611-0164', 'CO-2611-0165', 'CO-2611-0166', 'CO-2611-0167', 'CO-2611-0168', 'CO-2611-0169', 'CO-2611-0170', 'CO-2611-0171', 'CO-2611-0172', 'CO-2611-0173', 'CO-2611-0174', 'CO-2611-0175', 'CO-2611-0176', 'CO-2611-0177', 'CO-2611-0178', 'CO-2611-0179', 'CO-2611-0180', 'CO-2611-0181', 'CO-2611-0182', 'CO-2611-0183', 'CO-2611-0184', 'CO-2611-0185', 'CO-2611-0186', 'CO-2611-0187', 'CO-2611-0188', 'CO-2611-0189', 'CO-2611-0190', 'CO-2611-0191', 'CO-2611-0192', 'CO-2611-0193', 'CO-2611-0194', 'CO-2611-0195', 'CO-2611-0196', 'CO-2611-0197', 'CO-2611-0198', 'CO-2611-0199', 'CO-2611-0200', 'CO-2611-0201', 'CO-2611-0202', 'CI-2611-0002');

UPDATE `transactions` SET `kredit` = 49900000.00 WHERE `ref` = 'CO-2611-0002' AND `kredit` = 49400000.00;
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-1628' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-1499' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-1385' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-1382' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2610-1290' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-1237' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-1141' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah2' WHERE `ref` = 'CO-2609-1061' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Perjalanan Dinas Direksi' WHERE `ref` = 'CO-2609-0288' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Alat Konstruksi' WHERE `ref` = 'CO-2608-0152' AND `akun_lawan` = 'Biaya Bahan';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Entertain Direksi' WHERE `ref` = 'CO-2608-0107' AND `akun_lawan` = 'Biaya ADM';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Alat Konstruksi' WHERE `ref` = 'CO-2608-0084' AND `akun_lawan` = 'Biaya Bahan';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Bahan', `ket` = 'beton k250 (18 dan 22 juni) 25/6' WHERE `ref` = 'CO-2607-0242' AND `akun_lawan` = 'Biaya Bahan2';

