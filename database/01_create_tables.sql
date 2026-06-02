-- ============================================================
-- 高校校园便利店管理系统 - 数据库建表脚本
-- 成员A 编写
-- 数据库：cvs_db (campus convenience store)
-- 日期：2026-06-02
-- ============================================================

-- 创建数据库
DROP DATABASE IF EXISTS cvs_db;
CREATE DATABASE cvs_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cvs_db;

-- ============================================================
-- 1. user — 用户表（店员/管理员）
-- ============================================================
CREATE TABLE user (
    userId     INT PRIMARY KEY AUTO_INCREMENT,
    username   VARCHAR(50) NOT NULL UNIQUE,
    password   VARCHAR(64) NOT NULL COMMENT 'SHA-256哈希存储',
    realName   VARCHAR(50) NOT NULL,
    role       TINYINT NOT NULL DEFAULT 1 COMMENT '1=店员,2=管理员',
    phone      VARCHAR(20),
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 2. supplier — 供应商表
-- ============================================================
CREATE TABLE supplier (
    supplierId    INT PRIMARY KEY AUTO_INCREMENT,
    supplierName  VARCHAR(100) NOT NULL,
    contactPerson VARCHAR(50),
    phone         VARCHAR(20),
    address       VARCHAR(200),
    status        TINYINT NOT NULL DEFAULT 1 COMMENT '0=停用,1=合作中'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 3. category — 商品类别表
-- ============================================================
CREATE TABLE category (
    categoryId   INT PRIMARY KEY AUTO_INCREMENT,
    categoryName VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 4. product — 商品表
-- ============================================================
CREATE TABLE product (
    productId    INT PRIMARY KEY AUTO_INCREMENT,
    productName  VARCHAR(100) NOT NULL,
    categoryId   INT NOT NULL,
    barcode      VARCHAR(50) UNIQUE COMMENT '允许NULL，无条码商品可为空',
    unit         VARCHAR(20) NOT NULL DEFAULT '个',
    spec         VARCHAR(50),
    defaultPrice DECIMAL(10,2) NOT NULL,
    alertMin     INT NOT NULL DEFAULT 10 COMMENT '缺货预警阈值',
    status       TINYINT NOT NULL DEFAULT 1 COMMENT '0=下架,1=在售',
    CONSTRAINT fk_product_category FOREIGN KEY (categoryId) REFERENCES category(categoryId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 5. purchase — 进货单表
-- ============================================================
CREATE TABLE purchase (
    purchaseId   INT PRIMARY KEY AUTO_INCREMENT,
    supplierId   INT NOT NULL,
    userId       INT NOT NULL,
    purchaseDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totalAmount  DECIMAL(10,2) NOT NULL,
    status       TINYINT NOT NULL DEFAULT 0 COMMENT '0=草稿,1=已完成,2=已取消',
    CONSTRAINT fk_purchase_supplier FOREIGN KEY (supplierId) REFERENCES supplier(supplierId),
    CONSTRAINT fk_purchase_user FOREIGN KEY (userId) REFERENCES user(userId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 6. purchasedetail — 进货明细表
-- ============================================================
CREATE TABLE purchasedetail (
    detailId       INT PRIMARY KEY AUTO_INCREMENT,
    purchaseId     INT NOT NULL,
    productId      INT NOT NULL,
    quantity       INT NOT NULL,
    purchasePrice  DECIMAL(10,2) NOT NULL,
    salePrice      DECIMAL(10,2) NOT NULL,
    productionDate DATE,
    expiryDate     DATE,
    CONSTRAINT fk_purchasedetail_purchase FOREIGN KEY (purchaseId) REFERENCES purchase(purchaseId),
    CONSTRAINT fk_purchasedetail_product  FOREIGN KEY (productId) REFERENCES product(productId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 7. sale — 销售单表
-- ============================================================
CREATE TABLE sale (
    saleId        INT PRIMARY KEY AUTO_INCREMENT,
    userId        INT NOT NULL,
    saleTime      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totalAmount   DECIMAL(10,2) NOT NULL,
    paymentMethod TINYINT NOT NULL DEFAULT 1 COMMENT '1=现金,2=微信,3=支付宝',
    CONSTRAINT fk_sale_user FOREIGN KEY (userId) REFERENCES user(userId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 8. saledetail — 销售明细表
-- ============================================================
CREATE TABLE saledetail (
    detailId  INT PRIMARY KEY AUTO_INCREMENT,
    saleId    INT NOT NULL,
    productId INT NOT NULL,
    quantity  INT NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    subtotal  DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_saledetail_sale    FOREIGN KEY (saleId) REFERENCES sale(saleId),
    CONSTRAINT fk_saledetail_product FOREIGN KEY (productId) REFERENCES product(productId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 9. inventory — 库存表（批次级）
-- ============================================================
CREATE TABLE inventory (
    inventoryId INT PRIMARY KEY AUTO_INCREMENT,
    productId   INT NOT NULL,
    detailId    INT COMMENT 'FK→purchasedetail，追溯进货批次',
    quantity    INT NOT NULL DEFAULT 0,
    expiryDate  DATE COMMENT '该批次过期日期',
    updateTime  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product       FOREIGN KEY (productId) REFERENCES product(productId),
    CONSTRAINT fk_inventory_purchasedetail FOREIGN KEY (detailId) REFERENCES purchasedetail(detailId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 10. stockadjust — 库存调整记录表（盘点差异追踪）
-- ============================================================
CREATE TABLE stockadjust (
    adjustId    INT PRIMARY KEY AUTO_INCREMENT,
    inventoryId INT NOT NULL,
    beforeQty   INT NOT NULL COMMENT '调整前数量',
    afterQty    INT NOT NULL COMMENT '调整后数量',
    diffQty     INT NOT NULL COMMENT '正=盘盈,负=盘亏',
    reason      VARCHAR(200),
    userId      INT NOT NULL,
    adjustTime  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stockadjust_inventory FOREIGN KEY (inventoryId) REFERENCES inventory(inventoryId),
    CONSTRAINT fk_stockadjust_user      FOREIGN KEY (userId) REFERENCES user(userId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 11. stockalert — 库存预警表
-- ============================================================
CREATE TABLE stockalert (
    alertId    INT PRIMARY KEY AUTO_INCREMENT,
    productId  INT NOT NULL,
    alertType  TINYINT NOT NULL COMMENT '1=缺货,2=临期',
    alertMsg   VARCHAR(200),
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status     TINYINT NOT NULL DEFAULT 0 COMMENT '0=未处理,1=已处理',
    CONSTRAINT fk_stockalert_product FOREIGN KEY (productId) REFERENCES product(productId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 索引创建（提升查询性能）
-- ============================================================

-- product 表按条码和类别查询频率高
CREATE INDEX idx_product_barcode   ON product(barcode);
CREATE INDEX idx_product_category  ON product(categoryId);

-- purchase 表按供应商和时间查询
CREATE INDEX idx_purchase_supplier ON purchase(supplierId);
CREATE INDEX idx_purchase_date     ON purchase(purchaseDate);

-- purchasedetail 按进货单查询明细
CREATE INDEX idx_purchasedetail_purchase ON purchasedetail(purchaseId);
CREATE INDEX idx_purchasedetail_product  ON purchasedetail(productId);

-- sale 表按时间和收银员查询
CREATE INDEX idx_sale_time ON sale(saleTime);
CREATE INDEX idx_sale_user ON sale(userId);

-- saledetail 按销售单查询明细
CREATE INDEX idx_saledetail_sale    ON saledetail(saleId);
CREATE INDEX idx_saledetail_product ON saledetail(productId);

-- inventory 按商品和过期日期查询（FIFO扣减 + 临期扫描核心索引）
CREATE INDEX idx_inventory_product   ON inventory(productId);
CREATE INDEX idx_inventory_expiry    ON inventory(expiryDate);
CREATE INDEX idx_inventory_detail    ON inventory(detailId);

-- stockadjust 按库存记录查询
CREATE INDEX idx_stockadjust_inventory ON stockadjust(inventoryId);

-- stockalert 按商品和状态查询（首页预警列表）
CREATE INDEX idx_stockalert_product ON stockalert(productId);
CREATE INDEX idx_stockalert_status  ON stockalert(status);

-- ============================================================
-- 脚本执行完毕
-- ============================================================
