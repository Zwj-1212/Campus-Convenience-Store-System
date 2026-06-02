-- ============================================================
-- 高校校园便利店管理系统 - 测试数据脚本
-- 成员A 编写
-- 前置条件：已执行 01_create_tables.sql + 02_init_data.sql
-- 模拟场景：2026年4月~5月 2个月进销存数据
-- 日期：2026-06-02
-- ============================================================

USE cvs_db;

-- ============================================================
-- 场景一：2026-04-01 首次铺货进货（批发商贸，零食+饮料为主）
-- ============================================================
INSERT INTO purchase (purchaseId, supplierId, userId, purchaseDate, totalAmount, status) VALUES
(1, 1, 1, '2026-04-01 09:30:00', 3170.00, 1);

INSERT INTO purchasedetail (detailId, purchaseId, productId, quantity, purchasePrice, salePrice, productionDate, expiryDate) VALUES
(1,  1, 1,  100, 4.50,  6.50,  '2026-03-15', '2026-09-15'),
(2,  1, 2,  80,  4.80,  7.00,  '2026-03-20', '2026-09-20'),
(3,  1, 3,  80,  3.20,  5.00,  '2026-03-10', '2026-09-10'),
(4,  1, 4,  50,  2.80,  4.50,  '2026-03-25', '2026-06-25'),
(5,  1, 5,  60,  11.00, 15.00, '2026-03-18', '2026-09-18'),
(6,  1, 6,  200, 1.00,  2.00,  '2026-03-28', '2027-03-28'),
(7,  1, 7,  150, 1.80,  3.00,  '2026-03-20', '2026-09-20'),
(8,  1, 8,  120, 2.00,  3.50,  '2026-03-22', '2026-09-22'),
(9,  1, 9,  100, 2.50,  4.00,  '2026-03-25', '2026-06-25'),
(10, 1, 10, 80,  4.00,  6.00,  '2026-03-15', '2026-09-15');

-- 铺货入库 → inventory
INSERT INTO inventory (inventoryId, productId, detailId, quantity, expiryDate, updateTime) VALUES
(1,  1,  1,  100, '2026-09-15', '2026-04-01 09:30:00'),
(2,  2,  2,  80,  '2026-09-20', '2026-04-01 09:30:00'),
(3,  3,  3,  80,  '2026-09-10', '2026-04-01 09:30:00'),
(4,  4,  4,  50,  '2026-06-25', '2026-04-01 09:30:00'),
(5,  5,  5,  60,  '2026-09-18', '2026-04-01 09:30:00'),
(6,  6,  6,  200, '2027-03-28', '2026-04-01 09:30:00'),
(7,  7,  7,  150, '2026-09-20', '2026-04-01 09:30:00'),
(8,  8,  8,  120, '2026-09-22', '2026-04-01 09:30:00'),
(9,  9,  9,  100, '2026-06-25', '2026-04-01 09:30:00'),
(10, 10, 10, 80,  '2026-09-15', '2026-04-01 09:30:00');

-- ============================================================
-- 场景二：2026-04-01 文具+日用品首铺（文具代理 + 百货批发）
-- ============================================================
INSERT INTO purchase (purchaseId, supplierId, userId, purchaseDate, totalAmount, status) VALUES
(2, 3, 1, '2026-04-01 10:00:00', 660.00, 1);

INSERT INTO purchasedetail (detailId, purchaseId, productId, quantity, purchasePrice, salePrice, productionDate, expiryDate) VALUES
(11, 2, 11, 100, 1.20,  2.00,  '2026-03-01', NULL),
(12, 2, 12, 80,  2.50,  4.00,  '2026-03-01', NULL),
(13, 2, 13, 30,  5.00,  8.00,  '2026-03-01', NULL),
(14, 2, 14, 50,  2.00,  3.50,  '2026-03-01', NULL),
(15, 2, 15, 30,  3.00,  5.00,  '2026-03-01', NULL);

INSERT INTO purchase (purchaseId, supplierId, userId, purchaseDate, totalAmount, status) VALUES
(3, 4, 1, '2026-04-01 10:30:00', 850.00, 1);

INSERT INTO purchasedetail (detailId, purchaseId, productId, quantity, purchasePrice, salePrice, productionDate, expiryDate) VALUES
(16, 3, 16, 100, 1.80,  3.00,  '2026-03-20', '2027-03-20'),
(17, 3, 17, 30,  8.00,  12.00, '2026-03-15', '2027-03-15'),
(18, 3, 18, 50,  3.00,  5.00,  '2026-03-10', '2027-03-10'),
(19, 3, 19, 30,  6.00,  10.00, '2026-03-10', '2027-03-10'),
(20, 3, 20, 20,  5.00,  8.00,  '2026-03-01', '2027-03-01');

INSERT INTO inventory (inventoryId, productId, detailId, quantity, expiryDate, updateTime) VALUES
(11, 11, 11, 100, NULL, '2026-04-01 10:00:00'),
(12, 12, 12, 80,  NULL, '2026-04-01 10:00:00'),
(13, 13, 13, 30,  NULL, '2026-04-01 10:00:00'),
(14, 14, 14, 50,  NULL, '2026-04-01 10:00:00'),
(15, 15, 15, 30,  NULL, '2026-04-01 10:00:00'),
(16, 16, 16, 100, '2027-03-20', '2026-04-01 10:30:00'),
(17, 17, 17, 30,  '2027-03-15', '2026-04-01 10:30:00'),
(18, 18, 18, 50,  '2027-03-10', '2026-04-01 10:30:00'),
(19, 19, 19, 30,  '2027-03-10', '2026-04-01 10:30:00'),
(20, 20, 20, 20,  '2027-03-01', '2026-04-01 10:30:00');

-- ============================================================
-- 场景三：4月日常销售（共20笔POS交易，覆盖各种组合）
-- ============================================================

-- 4月1日下午 下课高峰 交易1: 零食饮料组合
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(1, 2, '2026-04-01 12:15:00', 21.50, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(1, 1, 1, 6.50, 6.50),
(1, 7, 2, 3.00, 6.00),
(1, 3, 1, 5.00, 5.00),
(1, 6, 2, 2.00, 4.00);

-- 4月1日下午 交易2
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(2, 2, '2026-04-01 12:18:00', 15.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(2, 5, 1, 15.00, 15.00);

-- 4月1日下午 交易3: 文具
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(3, 2, '2026-04-01 12:25:00', 10.00, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(3, 11, 3, 2.00, 6.00),
(3, 12, 1, 4.00, 4.00);

-- 4月1日晚上 交易4: 日用品
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(4, 3, '2026-04-01 20:30:00', 23.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(4, 16, 3, 3.00, 9.00),
(4, 18, 2, 5.00, 10.00),
(4, 12, 1, 4.00, 4.00);

-- 4月2日 交易5-8
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(5, 2, '2026-04-02 08:30:00', 10.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(5, 9, 1, 4.00, 4.00),
(5, 10, 1, 6.00, 6.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(6, 2, '2026-04-02 12:10:00', 27.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(6, 1, 2, 6.50, 13.00),
(6, 2, 1, 7.00, 7.00),
(6, 8, 2, 3.50, 7.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(7, 3, '2026-04-02 12:15:00', 11.00, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(7, 6, 3, 2.00, 6.00),
(7, 3, 1, 5.00, 5.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(8, 3, '2026-04-02 21:00:00', 15.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(8, 4, 2, 4.50, 9.00),
(8, 7, 2, 3.00, 6.00);

-- 4月3日 交易9-12
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(9, 2, '2026-04-03 12:05:00', 22.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(9, 2, 1, 7.00, 7.00),
(9, 5, 1, 15.00, 15.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(10, 2, '2026-04-03 12:12:00', 8.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(10, 6, 2, 2.00, 4.00),
(10, 9, 1, 4.00, 4.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(11, 3, '2026-04-03 18:30:00', 19.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(11, 17, 1, 12.00, 12.00),
(11, 14, 2, 3.50, 7.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(12, 3, '2026-04-03 18:35:00', 13.50, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(12, 1, 1, 6.50, 6.50),
(12, 8, 2, 3.50, 7.00);

-- 4月8日 交易13-16（第二周）
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(13, 2, '2026-04-08 12:20:00', 35.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(13, 5, 2, 15.00, 30.00),
(13, 3, 1, 5.00, 5.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(14, 2, '2026-04-08 12:22:00', 14.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(14, 2, 2, 7.00, 14.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(15, 3, '2026-04-08 21:15:00', 24.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(15, 13, 2, 8.00, 16.00),
(15, 11, 4, 2.00, 8.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(16, 3, '2026-04-08 21:20:00', 9.00, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(16, 16, 2, 3.00, 6.00),
(16, 7, 1, 3.00, 3.00);

-- 4月15日 交易17-20（第三周）
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(17, 2, '2026-04-15 12:08:00', 32.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(17, 1, 2, 6.50, 13.00),
(17, 2, 1, 7.00, 7.00),
(17, 10, 2, 6.00, 12.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(18, 3, '2026-04-15 18:25:00', 18.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(18, 20, 1, 8.00, 8.00),
(18, 19, 1, 10.00, 10.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(19, 2, '2026-04-15 20:40:00', 13.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(19, 4, 2, 4.50, 9.00),
(19, 9, 1, 4.00, 4.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(20, 2, '2026-04-15 20:45:00', 14.00, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(20, 6, 3, 2.00, 6.00),
(20, 7, 1, 3.00, 3.00),
(20, 3, 1, 5.00, 5.00);

-- ============================================================
-- 模拟 POS 销售后的库存扣减 (FIFO 按 expiryDate ASC)
-- 以上20笔销售模拟扣减4月铺货批次库存
-- ============================================================

-- 扣减 inventory 数据 (简化处理：直接在初始批次上扣减)
-- product 1: 初始100 → 售出 1+2+1+2+2 = 8 → 剩余92
UPDATE inventory SET quantity = 92 WHERE inventoryId = 1;
-- product 2: 初始80 → 售出 1+1+2+1 = 5 → 剩余75
UPDATE inventory SET quantity = 75 WHERE inventoryId = 2;
-- product 3: 初始80 → 售出 1+1+1 = 3 → 剩余77
UPDATE inventory SET quantity = 77 WHERE inventoryId = 3;
-- product 4: 初始50 → 售出 2+2 = 4 → 剩余46
UPDATE inventory SET quantity = 46 WHERE inventoryId = 4;
-- product 5: 初始60 → 售出 1+1+2 = 4 → 剩余56
UPDATE inventory SET quantity = 56 WHERE inventoryId = 5;
-- product 6: 初始200 → 售出 2+3+2+3 = 10 → 剩余190
UPDATE inventory SET quantity = 190 WHERE inventoryId = 6;
-- product 7: 初始150 → 售出 2+2+1+1 = 6 → 剩余144
UPDATE inventory SET quantity = 144 WHERE inventoryId = 7;
-- product 8: 初始120 → 售出 2+2 = 4 → 剩余116
UPDATE inventory SET quantity = 116 WHERE inventoryId = 8;
-- product 9: 初始100 → 售出 1+1+1 = 3 → 剩余97
UPDATE inventory SET quantity = 97 WHERE inventoryId = 9;
-- product 10: 初始80 → 售出 1+2 = 3 → 剩余77
UPDATE inventory SET quantity = 77 WHERE inventoryId = 10;
-- product 11: 初始100 → 售出 3+4 = 7 → 剩余93
UPDATE inventory SET quantity = 93 WHERE inventoryId = 11;
-- product 12: 初始80 → 售出 1+1 = 2 → 剩余78
UPDATE inventory SET quantity = 78 WHERE inventoryId = 12;
-- product 13: 初始30 → 售出 2 → 剩余28
UPDATE inventory SET quantity = 28 WHERE inventoryId = 13;
-- product 14: 初始50 → 售出 2 → 剩余48
UPDATE inventory SET quantity = 48 WHERE inventoryId = 14;
-- product 15: 初始30 → 售出 0 → 剩余30
-- product 16: 初始100 → 售出 3+2 = 5 → 剩余95
UPDATE inventory SET quantity = 95 WHERE inventoryId = 16;
-- product 17: 初始30 → 售出 1 → 剩余29
UPDATE inventory SET quantity = 29 WHERE inventoryId = 17;
-- product 18: 初始50 → 售出 2 → 剩余48
UPDATE inventory SET quantity = 48 WHERE inventoryId = 18;
-- product 19: 初始30 → 售出 1 → 剩余29
UPDATE inventory SET quantity = 29 WHERE inventoryId = 19;
-- product 20: 初始20 → 售出 1 → 剩余19
UPDATE inventory SET quantity = 19 WHERE inventoryId = 20;

-- ============================================================
-- 场景四：2026-04-20 补货（零食饮料热销品补货）
-- ============================================================
INSERT INTO purchase (purchaseId, supplierId, userId, purchaseDate, totalAmount, status) VALUES
(4, 1, 1, '2026-04-20 09:00:00', 1374.00, 1);

INSERT INTO purchasedetail (detailId, purchaseId, productId, quantity, purchasePrice, salePrice, productionDate, expiryDate) VALUES
(21, 4, 1,  60, 4.50,  6.50,  '2026-04-10', '2026-10-10'),
(22, 4, 2,  50, 4.80,  7.00,  '2026-04-08', '2026-10-08'),
(23, 4, 5,  40, 11.00, 15.00, '2026-04-05', '2026-10-05'),
(24, 4, 7,  80, 1.80,  3.00,  '2026-04-12', '2026-10-12'),
(25, 4, 8,  60, 2.00,  3.50,  '2026-04-10', '2026-10-10'),
(26, 4, 10, 40, 4.00,  6.00,  '2026-04-08', '2026-10-08');

INSERT INTO inventory (inventoryId, productId, detailId, quantity, expiryDate, updateTime) VALUES
(21, 1,  21, 60, '2026-10-10', '2026-04-20 09:00:00'),
(22, 2,  22, 50, '2026-10-08', '2026-04-20 09:00:00'),
(23, 5,  23, 40, '2026-10-05', '2026-04-20 09:00:00'),
(24, 7,  24, 80, '2026-10-12', '2026-04-20 09:00:00'),
(25, 8,  25, 60, '2026-10-10', '2026-04-20 09:00:00'),
(26, 10, 26, 40, '2026-10-08', '2026-04-20 09:00:00');

-- ============================================================
-- 场景五：5月日常销售（共15笔交易）
-- ============================================================

-- 5月6日
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(21, 2, '2026-05-06 12:10:00', 18.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(21, 1, 1, 6.50, 6.50),
(21, 8, 2, 3.50, 7.00),
(21, 4, 1, 4.50, 4.50);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(22, 3, '2026-05-06 12:15:00', 22.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(22, 5, 1, 15.00, 15.00),
(22, 2, 1, 7.00, 7.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(23, 2, '2026-05-06 20:30:00', 14.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(23, 6, 3, 2.00, 6.00),
(23, 12, 2, 4.00, 8.00);

-- 5月10日
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(24, 3, '2026-05-10 12:05:00', 27.00, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(24, 10, 2, 6.00, 12.00),
(24, 5, 1, 15.00, 15.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(25, 2, '2026-05-10 18:20:00', 9.50, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(25, 3, 1, 5.00, 5.00),
(25, 4, 1, 4.50, 4.50);

-- 5月15日
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(26, 2, '2026-05-15 12:12:00', 31.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(26, 5, 1, 15.00, 15.00),
(26, 17, 1, 12.00, 12.00),
(26, 12, 1, 4.00, 4.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(27, 3, '2026-05-15 12:15:00', 12.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(27, 7, 4, 3.00, 12.00);

-- 5月20日
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(28, 2, '2026-05-20 12:18:00', 21.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(28, 13, 2, 8.00, 16.00),
(28, 3, 1, 5.00, 5.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(29, 3, '2026-05-20 21:00:00', 16.50, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(29, 19, 1, 10.00, 10.00),
(29, 1, 1, 6.50, 6.50);

-- 5月25日（期末前文具采购小高峰）
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(30, 2, '2026-05-25 12:08:00', 23.50, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(30, 12, 3, 4.00, 12.00),
(30, 13, 1, 8.00, 8.00),
(30, 14, 1, 3.50, 3.50);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(31, 2, '2026-05-25 12:10:00', 12.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(31, 11, 5, 2.00, 10.00),
(31, 6, 1, 2.00, 2.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(32, 3, '2026-05-25 18:30:00', 8.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(32, 7, 2, 3.00, 6.00),
(32, 6, 1, 2.00, 2.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(33, 3, '2026-05-25 20:45:00', 13.00, 3);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(33, 20, 1, 8.00, 8.00),
(33, 3, 1, 5.00, 5.00);

-- 5月30日
INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(34, 2, '2026-05-30 12:15:00', 26.00, 2);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(34, 5, 1, 15.00, 15.00),
(34, 2, 1, 7.00, 7.00),
(34, 9, 1, 4.00, 4.00);

INSERT INTO sale (saleId, userId, saleTime, totalAmount, paymentMethod) VALUES
(35, 3, '2026-05-30 21:10:00', 23.00, 1);
INSERT INTO saledetail (saleId, productId, quantity, unitPrice, subtotal) VALUES
(35, 17, 1, 12.00, 12.00),
(35, 16, 2, 3.00, 6.00),
(35, 18, 1, 5.00, 5.00);

-- ============================================================
-- 5月销售后库存扣减（在4月20日补货批次+剩余库存上扣减）
-- ============================================================
-- product 1: 92+60=152 → 售出 1+1+1=3 → 149
UPDATE inventory SET quantity = 89 WHERE inventoryId = 1;   -- 第一批: 92→89
UPDATE inventory SET quantity = 60 WHERE inventoryId = 21;  -- 第二批: 60→60
-- product 2: 75+50=125 → 售出 1+1=2 → 123
UPDATE inventory SET quantity = 73 WHERE inventoryId = 2;
UPDATE inventory SET quantity = 50 WHERE inventoryId = 22;
-- product 3: 77 → 售出 1+1+1+1=4 → 73
UPDATE inventory SET quantity = 73 WHERE inventoryId = 3;
-- product 4: 46 → 售出 1+1=2 → 44
UPDATE inventory SET quantity = 44 WHERE inventoryId = 4;
-- product 5: 56+40=96 → 售出 1+1+1+1+1=5 → 91
UPDATE inventory SET quantity = 51 WHERE inventoryId = 5;
UPDATE inventory SET quantity = 40 WHERE inventoryId = 23;
-- product 6: 190 → 售出 3+1+1=5 → 185
UPDATE inventory SET quantity = 185 WHERE inventoryId = 6;
-- product 7: 144+80=224 → 售出 4+2=6 → 218
UPDATE inventory SET quantity = 138 WHERE inventoryId = 7;
UPDATE inventory SET quantity = 80 WHERE inventoryId = 24;
-- product 8: 116+60=176 → 售出 2 → 174
UPDATE inventory SET quantity = 114 WHERE inventoryId = 8;
UPDATE inventory SET quantity = 60 WHERE inventoryId = 25;
-- product 9: 97 → 售出 1 → 96
UPDATE inventory SET quantity = 96 WHERE inventoryId = 9;
-- product 10: 77+40=117 → 售出 2 → 115
UPDATE inventory SET quantity = 75 WHERE inventoryId = 10;
UPDATE inventory SET quantity = 40 WHERE inventoryId = 26;
-- product 11: 93 → 售出 5 → 88
UPDATE inventory SET quantity = 88 WHERE inventoryId = 11;
-- product 12: 78 → 售出 2+1+3=6 → 72
UPDATE inventory SET quantity = 72 WHERE inventoryId = 12;
-- product 13: 28 → 售出 2+1=3 → 25
UPDATE inventory SET quantity = 25 WHERE inventoryId = 13;
-- product 14: 48 → 售出 1 → 47
UPDATE inventory SET quantity = 47 WHERE inventoryId = 14;
-- product 16: 95 → 售出 2 → 93
UPDATE inventory SET quantity = 93 WHERE inventoryId = 16;
-- product 17: 29 → 售出 1+1=2 → 27
UPDATE inventory SET quantity = 27 WHERE inventoryId = 17;
-- product 18: 48 → 售出 1 → 47
UPDATE inventory SET quantity = 47 WHERE inventoryId = 18;
-- product 19: 29 → 售出 1 → 28
UPDATE inventory SET quantity = 28 WHERE inventoryId = 19;
-- product 20: 19 → 售出 1 → 18
UPDATE inventory SET quantity = 18 WHERE inventoryId = 20;

-- ============================================================
-- 场景六：库存预警数据
--   临期预警：product 4(百草味坚果) expiryDate=2026-06-25，当前日期6月初
--   缺货预警：product 15(得力剪刀) 初始30未补货，剩余30，alertMin=10 暂无预警
-- ============================================================

-- 临期预警 (百草味坚果和蒙牛纯牛奶均6月25日到�)
INSERT INTO stockalert (alertId, productId, alertType, alertMsg, createTime, status) VALUES
(1, 4, 2, '百草味每日坚果 库存44 批次过期日2026-06-25 仅剩23天', '2026-06-02 02:00:00', 0),
(2, 9, 2, '蒙牛纯牛奶 库存96 批次过期日2026-06-25 仅剩23天',       '2026-06-02 02:00:00', 0);

-- 模拟之前已经处理过的预警
INSERT INTO stockalert (alertId, productId, alertType, alertMsg, createTime, status) VALUES
(3, 15, 1, '得力剪刀 库存30 低于预警阈值10，但暂不缺货', '2026-05-15 12:30:00', 1);

-- ============================================================
-- 场景七：盘点调整记录
-- ============================================================
INSERT INTO stockadjust (adjustId, inventoryId, beforeQty, afterQty, diffQty, reason, userId, adjustTime) VALUES
(1, 14, 50, 47, -3, '盘点发现修正带少3个，疑似破损', 1, '2026-05-30 09:00:00'),
(2, 20, 20, 18, -2, '盘点发现电池少2板，记录差异',       1, '2026-05-30 09:00:00');

-- 同步调整后的 inventory
UPDATE inventory SET quantity = 47 WHERE inventoryId = 14;
UPDATE inventory SET quantity = 18 WHERE inventoryId = 20;

-- ============================================================
-- 脚本执行完毕 - 数据统计概览
-- ============================================================
-- 用户: 3人 (1管理员 + 2店员)
-- 类别: 4类
-- 商品: 20种
-- 供应商: 4家
-- 进货单: 4笔 (全部已完成)
-- 销售单: 35笔
-- 库存批次: 26条
-- 预警: 3条 (2条临期待处理 + 1条已处理)
-- 盘点记录: 2条
-- ============================================================
