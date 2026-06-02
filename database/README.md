# 数据库开发文档（成员A）

## 目录结构

```
database/
├── 01_create_tables.sql   # 建库 + 11张建表 + 索引
├── 02_init_data.sql       # 种子数据（用户、类别、供应商、商品）
├── 03_test_data.sql       # 测试数据（进货、销售、库存扣减、预警、盘点）
├── 04_common_queries.sql  # 常用查询SQL参考（供后端DAO层参考）
└── run_all.sql            # 一键执行全部脚本
```

## 使用方法

### 方式一：逐文件执行（推荐首次）

```bash
mysql -u root -p < 01_create_tables.sql
mysql -u root -p < 02_init_data.sql
mysql -u root -p < 03_test_data.sql
```

### 方式二：一键执行

```bash
mysql -u root -p < run_all.sql
```

### 方式三：在 MySQL 客户端中

```sql
SOURCE database/01_create_tables.sql;
SOURCE database/02_init_data.sql;
SOURCE database/03_test_data.sql;
```

## 测试账号

| 用户名   | 密码      | 角色   |
| -------- | --------- | ------ |
| admin    | admin123  | 管理员 |
| zhangsan | clerk123  | 店员   |
| lisi     | clerk456  | 店员   |

## 数据概览

| 表            | 记录数 | 说明                   |
| ------------- | ------ | ---------------------- |
| user          | 3      | 1管理员 + 2店员        |
| category      | 4      | 零食/饮料/文具/日用品  |
| supplier      | 4      | 4个供应商              |
| product       | 20     | 每类5种商品            |
| purchase      | 4      | 已完成进货单           |
| purchasedetail| 26     | 进货明细               |
| sale          | 35     | 4月-5月POS销售         |
| saledetail    | ~70    | 销售明细               |
| inventory     | 26     | 批次库存               |
| stockalert    | 3      | 2临期未处理 + 1已处理  |
| stockadjust   | 2      | 盘点调整               |

## 关键设计说明

1. **批次级库存**: `inventory` 同一商品可有多条记录，通过 `detailId` 追溯进货批次
2. **FIFO扣减**: 销售时按 `expiryDate ASC` 逐批扣减
3. **行级锁**: POS销售使用 `SELECT ... FOR UPDATE` 防并发超卖
4. **库存预警**: 缺货预警由POS销售自动生成，临期预警由定时任务扫描
