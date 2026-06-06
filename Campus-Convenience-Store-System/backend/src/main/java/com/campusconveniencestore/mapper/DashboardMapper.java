package com.campusconveniencestore.mapper;

import java.math.BigDecimal;

public interface DashboardMapper {

    BigDecimal todaySalesAmount();

    long todayOrderCount();
}
