package com.campusconveniencestore.dao;

import com.campusconveniencestore.vo.CategoryVO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoryDao {

    private final JdbcTemplate jdbcTemplate;

    public CategoryDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<CategoryVO> findAll() {
        String sql = "SELECT categoryId, categoryName FROM category ORDER BY categoryId";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new CategoryVO(
                rs.getInt("categoryId"),
                rs.getString("categoryName")));
    }
}
