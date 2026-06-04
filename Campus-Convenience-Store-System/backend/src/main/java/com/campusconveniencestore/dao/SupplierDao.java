package com.campusconveniencestore.dao;

import com.campusconveniencestore.dto.SupplierRequest;
import com.campusconveniencestore.vo.SupplierVO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

@Repository
public class SupplierDao {

    private final JdbcTemplate jdbcTemplate;

    public SupplierDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<SupplierVO> findAll() {
        String sql = "SELECT supplierId, supplierName, contactPerson, phone, address, status FROM supplier ORDER BY supplierId DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new SupplierVO(
                rs.getInt("supplierId"),
                rs.getString("supplierName"),
                rs.getString("contactPerson"),
                rs.getString("phone"),
                rs.getString("address"),
                rs.getInt("status")));
    }

    public Optional<SupplierVO> findById(Integer supplierId) {
        String sql = "SELECT supplierId, supplierName, contactPerson, phone, address, status FROM supplier WHERE supplierId = ?";
        return jdbcTemplate.query(sql, rs -> {
            if (!rs.next()) {
                return Optional.empty();
            }
            return Optional.of(new SupplierVO(
                    rs.getInt("supplierId"),
                    rs.getString("supplierName"),
                    rs.getString("contactPerson"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getInt("status")));
        }, supplierId);
    }

    public int insert(SupplierRequest request) {
        String sql = "INSERT INTO supplier(supplierName, contactPerson, phone, address, status) VALUES(?,?,?,?,?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, request.supplierName());
            ps.setString(2, request.contactPerson());
            ps.setString(3, request.phone());
            ps.setString(4, request.address());
            ps.setInt(5, request.status());
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        return key == null ? 0 : key.intValue();
    }

    public int update(Integer supplierId, SupplierRequest request) {
        String sql = "UPDATE supplier SET supplierName = ?, contactPerson = ?, phone = ?, address = ?, status = ? WHERE supplierId = ?";
        return jdbcTemplate.update(sql,
                request.supplierName(),
                request.contactPerson(),
                request.phone(),
                request.address(),
                request.status(),
                supplierId);
    }
}
