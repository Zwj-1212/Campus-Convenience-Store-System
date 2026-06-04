package com.campusconveniencestore.dao;

import com.campusconveniencestore.vo.LoginResponse;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class UserDao {

    private final JdbcTemplate jdbcTemplate;

    public UserDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Optional<LoginResponse> findByUsernameAndPassword(String username, String password) {
        String sql = "SELECT userId, username, realName, role, phone FROM `user` WHERE username = ? AND password = ?";
        return jdbcTemplate.query(sql, rs -> {
            if (!rs.next()) {
                return Optional.empty();
            }
            return Optional.of(new LoginResponse(
                    rs.getInt("userId"),
                    rs.getString("username"),
                    rs.getString("realName"),
                    rs.getInt("role"),
                    rs.getString("phone")));
        }, username, password);
    }
}
