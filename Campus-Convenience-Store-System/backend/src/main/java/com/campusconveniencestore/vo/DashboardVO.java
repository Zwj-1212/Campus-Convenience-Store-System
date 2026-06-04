package com.campusconveniencestore.vo;

import java.math.BigDecimal;

public record DashboardVO(
        BigDecimal todaySalesAmount,
        Long todayOrderCount,
        BigDecimal todayAverageAmount,
        Long unprocessedAlertCount,
        Long stockAlertCount,
        Long expiryAlertCount) {
}
