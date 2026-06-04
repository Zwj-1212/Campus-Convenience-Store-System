package com.campusconveniencestore.vo;

public record LoginResponse(
        Integer userId,
        String username,
        String realName,
        Integer role,
        String phone) {
}
