-- ============================================================
-- 高校校园便利店管理系统 - 一键执行全部SQL脚本
-- 成员A 编写
-- 使用方式：mysql -u root -p < run_all.sql
-- 日期：2026-06-02
-- ============================================================

SOURCE 01_create_tables.sql;
SOURCE 02_init_data.sql;
SOURCE 03_test_data.sql;

-- 验证数据
SOURCE 04_common_queries.sql;
