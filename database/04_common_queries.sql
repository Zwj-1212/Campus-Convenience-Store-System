-- ============================================================
-- 高校校园便利店管理系统 - 常用业务查询SQL参考
-- 成员A 编写
-- 供成员B(后端DAO层)和成员C(前端联调)参考
-- 日期：2026-06-02
-- ============================================================

USE cvs_db;

-- ============================================================
-- 一、登录相关
-- ============================================================

-- 1.1 用户登录验证
SELECT userId, username, realName, role, phone
FROM user
WHERE username = 'zhangsan' AND password = 'a3630b8b8f6c82d33b0695f77f915e69ed7b0c5214062f8b870219845e069d30';

-- 1.2 管理员查看所有用户
SELECT userId, username, realName, role, phone, createTime FROM user ORDER BY createTime DESC;

-- ============================================================
-- 二、商品管理
-- ============================================================

-- 2.1 商品列表（含类别名，支持按关键字搜索）
SELECT p.productId, p.productName, p.barcode, p.defaultPrice,
       p.unit, p.spec, p.alertMin, p.status,
       c.categoryName,
       COALESCE(SUM(i.quantity), 0) AS totalStock
FROM product p
LEFT JOIN category c ON p.categoryId = c.categoryId
LEFT JOIN inventory i ON p.productId = i.productId
WHERE (p.productName LIKE '%可乐%' OR p.barcode LIKE '%可乐%')
GROUP BY p.productId, p.productName, p.barcode, p.defaultPrice,
         p.unit, p.spec, p.alertMin, p.status, c.categoryName
ORDER BY p.productId;

-- 2.2 按类别筛选商品
SELECT p.productId, p.productName, p.defaultPrice, p.status,
       COALESCE(SUM(i.quantity), 0) AS totalStock
FROM product p
LEFT JOIN inventory i ON p.productId = i.productId
WHERE p.categoryId = 2  -- 饮料
GROUP BY p.productId;

-- 2.3 扫码查找（barcode精确匹配）
SELECT p.*, c.categoryName,
       COALESCE(SUM(i.quantity), 0) AS totalStock
FROM product p
LEFT JOIN category c ON p.categoryId = c.categoryId
LEFT JOIN inventory i ON p.productId = i.productId
WHERE p.barcode = '6923456789012'
GROUP BY p.productId;

-- ============================================================
-- 三、供应商管理
-- ============================================================

-- 3.1 供应商列表
SELECT * FROM supplier ORDER BY status DESC, supplierId;

-- 3.2 合作中供应商
SELECT * FROM supplier WHERE status = 1;

-- ============================================================
-- 四、进货管理
-- ============================================================

-- 4.1 进货单列表（含供应商名、操作员名）
SELECT pu.purchaseId, s.supplierName, u.realName AS operator,
       pu.purchaseDate, pu.totalAmount, pu.status
FROM purchase pu
JOIN supplier s ON pu.supplierId = s.supplierId
JOIN user u ON pu.userId = u.userId
ORDER BY pu.purchaseDate DESC;

-- 4.2 进货单明细
SELECT pd.detailId, pd.productId, p.productName, pd.quantity,
       pd.purchasePrice, pd.salePrice,
       pd.productionDate, pd.expiryDate,
       (pd.purchasePrice * pd.quantity) AS itemTotal
FROM purchasedetail pd
JOIN product p ON pd.productId = p.productId
WHERE pd.purchaseId = 1;

-- ============================================================
-- 五、POS 销售核心查询
-- ============================================================

-- 5.1 按批次查看库存（FIFO扣减用：expiryDate ASC）
SELECT i.inventoryId, i.productId, p.productName, p.defaultPrice,
       i.quantity, i.expiryDate, i.detailId,
       pd.purchasePrice
FROM inventory i
JOIN product p ON i.productId = p.productId
LEFT JOIN purchasedetail pd ON i.detailId = pd.detailId
WHERE i.productId = 1 AND i.quantity > 0
ORDER BY i.expiryDate ASC;

-- 5.2 商品总库存汇总（用于校验库存是否充足）
SELECT productId, SUM(quantity) AS totalStock
FROM inventory
WHERE productId IN (1, 2, 5, 7)
GROUP BY productId;

-- 5.3 商品在售状态 + 库存校验
SELECT p.productId, p.productName, p.status,
       COALESCE(SUM(i.quantity), 0) AS totalStock
FROM product p
LEFT JOIN inventory i ON p.productId = i.productId
WHERE p.productId = 1
GROUP BY p.productId;

-- 5.4 销售记录列表
SELECT s.saleId, u.realName AS cashier, s.saleTime,
       s.totalAmount, s.paymentMethod
FROM sale s
JOIN user u ON s.userId = u.userId
ORDER BY s.saleTime DESC
LIMIT 20;

-- 5.5 某笔销售详情（含明细）
SELECT sd.detailId, sd.productId, p.productName,
       sd.quantity, sd.unitPrice, sd.subtotal
FROM saledetail sd
JOIN product p ON sd.productId = p.productId
WHERE sd.saleId = 1;

-- ============================================================
-- 六、库存管理与预警
-- ============================================================

-- 6.1 按商品汇总库存
SELECT p.productId, p.productName, c.categoryName,
       p.alertMin, p.defaultPrice,
       COALESCE(SUM(i.quantity), 0) AS totalStock,
       CASE WHEN COALESCE(SUM(i.quantity), 0) < p.alertMin THEN '⚠缺货' ELSE '正常' END AS stockStatus
FROM product p
LEFT JOIN category c ON p.categoryId = c.categoryId
LEFT JOIN inventory i ON p.productId = i.productId
WHERE p.status = 1
GROUP BY p.productId, p.productName, c.categoryName, p.alertMin, p.defaultPrice
ORDER BY totalStock ASC;

-- 6.2 按批次查看库存明细（含过期日期）
SELECT i.inventoryId, i.productId, p.productName,
       i.quantity, i.expiryDate, i.detailId,
       DATEDIFF(i.expiryDate, CURDATE()) AS daysToExpire,
       pd.purchasePrice, pu.purchaseDate
FROM inventory i
JOIN product p ON i.productId = p.productId
LEFT JOIN purchasedetail pd ON i.detailId = pd.detailId
LEFT JOIN purchase pu ON pd.purchaseId = pu.purchaseId
WHERE i.productId = 1
ORDER BY i.expiryDate ASC;

-- 6.3 临期商品列表（距过期 ≤ 7 天）
SELECT i.inventoryId, i.productId, p.productName,
       i.quantity, i.expiryDate,
       DATEDIFF(i.expiryDate, CURDATE()) AS daysToExpire
FROM inventory i
JOIN product p ON i.productId = p.productId
WHERE i.expiryDate IS NOT NULL
  AND i.expiryDate <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
  AND i.quantity > 0
ORDER BY i.expiryDate ASC;

-- 6.4 未处理预警列表
SELECT a.alertId, a.productId, p.productName,
       a.alertType, a.alertMsg, a.createTime, a.status
FROM stockalert a
JOIN product p ON a.productId = p.productId
WHERE a.status = 0
ORDER BY a.createTime DESC;

-- 6.5 盘点调整记录
SELECT sa.adjustId, sa.inventoryId, p.productName,
       sa.beforeQty, sa.afterQty, sa.diffQty,
       sa.reason, u.realName AS operator, sa.adjustTime
FROM stockadjust sa
JOIN inventory i ON sa.inventoryId = i.inventoryId
JOIN product p ON i.productId = p.productId
JOIN user u ON sa.userId = u.userId
ORDER BY sa.adjustTime DESC;

-- ============================================================
-- 七、数据统计
-- ============================================================

-- 7.1 首页仪表盘 - 今日销售概览
SELECT
    COUNT(*) AS todayOrders,
    COALESCE(SUM(totalAmount), 0) AS todaySales,
    ROUND(COALESCE(AVG(totalAmount), 0), 2) AS avgOrderValue
FROM sale
WHERE DATE(saleTime) = CURDATE();

-- 7.2 首页 - 近7日销售趋势
SELECT DATE(saleTime) AS saleDate,
       COUNT(*) AS orderCount,
       SUM(totalAmount) AS dailySales
FROM sale
WHERE saleTime >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
GROUP BY DATE(saleTime)
ORDER BY saleDate;

-- 7.3 首页 - 未处理预警数量
SELECT COUNT(*) AS alertCount FROM stockalert WHERE status = 0;

-- 7.4 按月统计供应商送货量/金额
SELECT DATE_FORMAT(pu.purchaseDate, '%Y-%m') AS month,
       s.supplierName,
       COUNT(DISTINCT pu.purchaseId) AS orderCount,
       SUM(pd.quantity) AS totalQuantity,
       SUM(pd.purchasePrice * pd.quantity) AS totalAmount
FROM purchase pu
JOIN supplier s ON pu.supplierId = s.supplierId
JOIN purchasedetail pd ON pu.purchaseId = pd.purchaseId
WHERE pu.status = 1
GROUP BY month, pu.supplierId, s.supplierName
ORDER BY month DESC, totalAmount DESC;

-- 7.5 按商品类别统计月度销量/销售额
SELECT DATE_FORMAT(s.saleTime, '%Y-%m') AS month,
       c.categoryName,
       SUM(sd.quantity) AS totalQuantity,
       SUM(sd.subtotal) AS totalSales
FROM sale s
JOIN saledetail sd ON s.saleId = sd.saleId
JOIN product p ON sd.productId = p.productId
JOIN category c ON p.categoryId = c.categoryId
GROUP BY month, c.categoryId, c.categoryName
ORDER BY month DESC, totalSales DESC;

-- 7.6 单品月度销量/销售额排行（TOP 10）
SELECT DATE_FORMAT(s.saleTime, '%Y-%m') AS month,
       p.productId, p.productName, c.categoryName,
       SUM(sd.quantity) AS totalQuantity,
       SUM(sd.subtotal) AS totalSales
FROM sale s
JOIN saledetail sd ON s.saleId = sd.saleId
JOIN product p ON sd.productId = p.productId
JOIN category c ON p.categoryId = c.categoryId
GROUP BY month, p.productId, p.productName, c.categoryName
ORDER BY month DESC, totalQuantity DESC
LIMIT 10;

-- 7.7 支付方式占比统计
SELECT paymentMethod,
       CASE paymentMethod
           WHEN 1 THEN '现金'
           WHEN 2 THEN '微信支付'
           WHEN 3 THEN '支付宝'
       END AS paymentName,
       COUNT(*) AS count,
       SUM(totalAmount) AS totalAmount
FROM sale
GROUP BY paymentMethod;

-- ============================================================
-- 八、数据维护
-- ============================================================

-- 8.1 查看各表数据量
SELECT 'user' AS tableName, COUNT(*) AS rowCount FROM user
UNION ALL SELECT 'supplier', COUNT(*) FROM supplier
UNION ALL SELECT 'category', COUNT(*) FROM category
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'purchase', COUNT(*) FROM purchase
UNION ALL SELECT 'purchasedetail', COUNT(*) FROM purchasedetail
UNION ALL SELECT 'sale', COUNT(*) FROM sale
UNION ALL SELECT 'saledetail', COUNT(*) FROM saledetail
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'stockadjust', COUNT(*) FROM stockadjust
UNION ALL SELECT 'stockalert', COUNT(*) FROM stockalert;

-- 8.2 重置所有数据（重新开始）
-- 警告：以下操作会清空所有数据！
/*
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE stockalert;
TRUNCATE TABLE stockadjust;
TRUNCATE TABLE inventory;
TRUNCATE TABLE saledetail;
TRUNCATE TABLE sale;
TRUNCATE TABLE purchasedetail;
TRUNCATE TABLE purchase;
TRUNCATE TABLE product;
TRUNCATE TABLE category;
TRUNCATE TABLE supplier;
TRUNCATE TABLE user;
SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE user AUTO_INCREMENT = 1;
ALTER TABLE supplier AUTO_INCREMENT = 1;
ALTER TABLE category AUTO_INCREMENT = 1;
ALTER TABLE product AUTO_INCREMENT = 1;
ALTER TABLE purchase AUTO_INCREMENT = 1;
ALTER TABLE purchasedetail AUTO_INCREMENT = 1;
ALTER TABLE sale AUTO_INCREMENT = 1;
ALTER TABLE saledetail AUTO_INCREMENT = 1;
ALTER TABLE inventory AUTO_INCREMENT = 1;
ALTER TABLE stockadjust AUTO_INCREMENT = 1;
ALTER TABLE stockalert AUTO_INCREMENT = 1;
*/

-- ============================================================
-- 脚本执行完毕
-- ============================================================
