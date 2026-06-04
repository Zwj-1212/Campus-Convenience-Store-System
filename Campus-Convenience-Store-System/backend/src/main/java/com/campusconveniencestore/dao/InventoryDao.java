package com.campusconveniencestore.dao;

import com.campusconveniencestore.vo.AlertVO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class InventoryDao {

    private final JdbcTemplate jdbcTemplate;

    public InventoryDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<AlertVO> findAlerts(Integer status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.alertId, a.productId, p.productName, a.alertType, a.alertMsg, a.createTime, a.status ")
                .append("FROM stockalert a LEFT JOIN product p ON a.productId = p.productId WHERE 1=1");
        if (status != null) {
            sql.append(" AND a.status = ").append(status);
        }
        sql.append(" ORDER BY a.createTime DESC, a.alertId DESC");
        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> new AlertVO(
                rs.getInt("alertId"),
                rs.getInt("productId"),
                rs.getString("productName"),
                rs.getInt("alertType"),
                rs.getString("alertMsg"),
                rs.getTimestamp("createTime").toLocalDateTime(),
                rs.getInt("status")));
    }

    public int markHandled(Integer alertId) {
        return jdbcTemplate.update("UPDATE stockalert SET status = 1 WHERE alertId = ?", alertId);
    }

    public long countUnprocessed() {
        Long value = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stockalert WHERE status = 0", Long.class);
        return value == null ? 0L : value;
    }

    public long countByType(int alertType) {
        Long value = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stockalert WHERE status = 0 AND alertType = ?", Long.class, alertType);
        return value == null ? 0L : value;
    }
}
