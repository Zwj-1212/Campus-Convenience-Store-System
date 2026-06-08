package com.campusconveniencestore.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;

@Repository
public class DashboardDao {

    private final JdbcTemplate jdbcTemplate;

    public DashboardDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public BigDecimal todaySalesAmount() {
        BigDecimal value = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(totalAmount), 0) FROM sale WHERE DATE(saleTime) = CURDATE()",
                BigDecimal.class);
        return value == null ? BigDecimal.ZERO : value;
    }

    public long todayOrderCount() {
        Long value = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM sale WHERE DATE(saleTime) = CURDATE()",
                Long.class);
        return value == null ? 0L : value;
    }
}
