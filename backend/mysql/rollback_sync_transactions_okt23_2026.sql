-- Membatalkan sync_transactions_okt23_2026.sql secara menyeluruh --
-- mengembalikan database persis ke kondisi sebelum file itu dijalankan.
-- Urutan dibalik dari file aslinya (hapus transaksi baru dulu, baru
-- project, baru kembalikan 5 transaksi lama ke nilai semula) supaya
-- aman dijalankan bahkan kalau sync_transactions_okt23_2026.sql baru
-- separuh jalan.

-- 1) Hapus 108 transaksi baru yang ditambahkan hari itu.
DELETE FROM `transactions` WHERE `ref` IN (
  'BI-2610-0013', 'BO-2610-0026', 'CI-2610-0028', 'CO-2610-1196', 'CO-2610-1197', 'CO-2610-1198', 'CO-2610-1199', 'CO-2610-1200', 'CO-2610-1201', 'CO-2610-1202',
  'CO-2610-1203', 'CO-2610-1204', 'CO-2610-1205', 'CO-2610-1206', 'CO-2610-1207', 'CO-2610-1208', 'CO-2610-1209', 'CO-2610-1210', 'CO-2610-1211', 'CO-2610-1212',
  'CO-2610-1213', 'CO-2610-1214', 'CO-2610-1215', 'CO-2610-1216', 'CO-2610-1217', 'CO-2610-1218', 'CO-2610-1219', 'CO-2610-1220', 'CO-2610-1221', 'CO-2610-1222',
  'CO-2610-1223', 'CO-2610-1224', 'CO-2610-1225', 'CO-2610-1226', 'CO-2610-1227', 'CO-2610-1228', 'CO-2610-1229', 'CO-2610-1230', 'CO-2610-1231', 'CO-2610-1232',
  'CO-2610-1233', 'CO-2610-1234', 'CO-2610-1235', 'CO-2610-1236', 'CO-2610-1237', 'CO-2610-1238', 'CO-2610-1239', 'CO-2610-1240', 'CO-2610-1241', 'CO-2610-1242',
  'CO-2610-1243', 'CO-2610-1244', 'CO-2610-1245', 'CO-2610-1246', 'CO-2610-1247', 'CO-2610-1248', 'CO-2610-1249', 'CO-2610-1250', 'CO-2610-1251', 'CO-2610-1252',
  'CO-2610-1253', 'CO-2610-1254', 'CO-2610-1255', 'CO-2610-1256', 'CO-2610-1257', 'CO-2610-1258', 'CO-2610-1259', 'CO-2610-1260', 'CO-2610-1261', 'CO-2610-1262',
  'CO-2610-1263', 'CO-2610-1264', 'CO-2610-1265', 'CO-2610-1266', 'CO-2610-1267', 'CO-2610-1268', 'CO-2610-1269', 'CO-2610-1270', 'CO-2610-1271', 'CO-2610-1272',
  'CO-2610-1273', 'CO-2610-1274', 'CO-2610-1275', 'CO-2610-1276', 'CO-2610-1277', 'CO-2610-1278', 'CO-2610-1279', 'CO-2610-1280', 'CO-2610-1281', 'CO-2610-1282',
  'CO-2610-1283', 'CO-2610-1284', 'CO-2610-1285', 'CO-2610-1286', 'CO-2610-1287', 'CO-2610-1288', 'CO-2610-1289', 'CO-2610-1290', 'CO-2610-1291', 'CO-2610-1292',
  'CO-2610-1293', 'CO-2610-1294', 'CO-2610-1295', 'CO-2610-1296', 'CO-2610-1297', 'CO-2610-1298', 'CO-2610-1299', 'CO-2610-1300'
);

-- 2) Hapus Master Project "BJB Prioritas Jakarta" yang dibuat untuk
-- CO-2610-1285 (sudah terhapus di langkah 1 di atas).
DELETE FROM `projects` WHERE `id` = 'p_bjb_prioritas_jakarta';

-- 3) Kembalikan 5 transaksi lama yang kemarin disesuaikan, ke nilai
-- semula sebelum sync_transactions_okt23_2026.sql.
UPDATE `transactions` SET `project` = 'Zidam Brigif 15 Zipur', `kredit` = 3000000.00, `ket` = 'pendamping' WHERE `ref` = 'CO-2608-0863';
UPDATE `transactions` SET `kredit` = 15450000.00 WHERE `ref` = 'CO-2609-0938';
UPDATE `transactions` SET `kredit` = 15450000.00 WHERE `ref` = 'CO-2609-1346';
UPDATE `transactions` SET `akun_lawan` = 'Biaya Upah' WHERE `ref` = 'CO-2610-0323';
UPDATE `transactions` SET `kredit` = 24300000.00, `ket` = 'bahan matrial alam' WHERE `ref` = 'CO-2610-1138';
