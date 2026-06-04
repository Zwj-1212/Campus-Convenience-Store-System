package com.campusconveniencestore.vo;

import java.time.LocalDateTime;

public record AlertVO(
        Integer alertId,
        Integer productId,
        String productName,
        Integer alertType,
        String alertMsg,
        LocalDateTime createTime,
        Integer status) {
}
