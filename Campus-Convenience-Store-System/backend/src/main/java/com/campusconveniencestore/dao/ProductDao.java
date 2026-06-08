package com.campusconveniencestore.dao;

import com.campusconveniencestore.dto.ProductRequest;
import com.campusconveniencestore.vo.ProductVO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class ProductDao {

    private final JdbcTemplate jdbcTemplate;

    public ProductDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<ProductVO> findAll(String keyword, Integer categoryId, Integer status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.productId, p.productName, p.categoryId, c.categoryName, p.barcode, ")
                .append("p.unit, p.spec, p.defaultPrice, p.alertMin, p.status ")
                .append("FROM product p LEFT JOIN category c ON p.categoryId = c.categoryId WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (StringUtils.hasText(keyword)) {
            sql.append(" AND (p.productName LIKE ? OR p.barcode LIKE ?)");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (categoryId != null) {
            sql.append(" AND p.categoryId = ?");
            params.add(categoryId);
        }
        if (status != null) {
            sql.append(" AND p.status = ?");
            params.add(status);
        }
        sql.append(" ORDER BY p.productId DESC");
        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> new ProductVO(
                rs.getInt("productId"),
                rs.getString("productName"),
                rs.getInt("categoryId"),
                rs.getString("categoryName"),
                rs.getString("barcode"),
                rs.getString("unit"),
                rs.getString("spec"),
                rs.getBigDecimal("defaultPrice"),
                rs.getInt("alertMin"),
                rs.getInt("status")), params.toArray());
    }

    public Optional<ProductVO> findById(Integer productId) {
        String sql = "SELECT p.productId, p.productName, p.categoryId, c.categoryName, p.barcode, p.unit, p.spec, p.defaultPrice, p.alertMin, p.status "
                + "FROM product p LEFT JOIN category c ON p.categoryId = c.categoryId WHERE p.productId = ?";
        return jdbcTemplate.query(sql, rs -> {
            if (!rs.next()) {
                return Optional.empty();
            }
            return Optional.of(new ProductVO(
                    rs.getInt("productId"),
                    rs.getString("productName"),
                    rs.getInt("categoryId"),
                    rs.getString("categoryName"),
                    rs.getString("barcode"),
                    rs.getString("unit"),
                    rs.getString("spec"),
                    rs.getBigDecimal("defaultPrice"),
                    rs.getInt("alertMin"),
                    rs.getInt("status")));
        }, productId);
    }

    public int insert(ProductRequest request) {
        String sql = "INSERT INTO product(productName, categoryId, barcode, unit, spec, defaultPrice, alertMin, status) VALUES(?,?,?,?,?,?,?,?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, request.productName());
            ps.setInt(2, request.categoryId());
            if (StringUtils.hasText(request.barcode())) {
                ps.setString(3, request.barcode().trim());
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            ps.setString(4, request.unit());
            ps.setString(5, request.spec());
            ps.setBigDecimal(6, request.defaultPrice());
            ps.setInt(7, request.alertMin());
            ps.setInt(8, request.status());
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        return key == null ? 0 : key.intValue();
    }

    public int update(Integer productId, ProductRequest request) {
        String sql = "UPDATE product SET productName = ?, categoryId = ?, barcode = ?, unit = ?, spec = ?, defaultPrice = ?, alertMin = ?, status = ? WHERE productId = ?";
        return jdbcTemplate.update(sql,
                request.productName(),
                request.categoryId(),
                StringUtils.hasText(request.barcode()) ? request.barcode().trim() : null,
                request.unit(),
                request.spec(),
                request.defaultPrice(),
                request.alertMin(),
                request.status(),
                productId);
    }

    public int updateStatus(Integer productId, Integer status) {
        return jdbcTemplate.update("UPDATE product SET status = ? WHERE productId = ?", status, productId);
    }
}
