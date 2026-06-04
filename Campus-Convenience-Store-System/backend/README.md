# 校园便利店管理系统后端

Spring Boot + JDBC + Swagger UI 的后端骨架，按课程设计文档拆分了常用的管理接口，前后端通过 REST API 解耦。

## 启动方式

1. 先执行 `database/01_create_tables.sql` 和 `database/02_init_data.sql`
2. 修改 `src/main/resources/application.yml` 中的数据库连接
3. 在 `backend` 目录执行：

```bash
mvn spring-boot:run
```

## Swagger 地址

- Swagger UI: `http://localhost:8080/swagger-ui/index.html`
- OpenAPI JSON: `http://localhost:8080/v3/api-docs`

## 已提供接口

- 登录鉴权 `POST /api/auth/login`
- 商品管理 `GET/POST/PUT /api/products`
- 供应商管理 `GET/POST/PUT /api/suppliers`
- 类别查询 `GET /api/categories`
- 首页概览 `GET /api/dashboard`
- 预警列表 `GET /api/inventory/alerts`

## 前后端联调说明

后端已开启全局 CORS，前端页面可直接通过 Fetch 访问 `http://localhost:8080/api/...`。
