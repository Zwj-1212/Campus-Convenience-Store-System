package com.campusconveniencestore.service;

import com.campusconveniencestore.mapper.DashboardMapper;
import com.campusconveniencestore.vo.DashboardVO;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
public class DashboardService {

    private final DashboardMapper dashboardMapper;
    private final InventoryService inventoryService;

    public DashboardService(DashboardMapper dashboardMapper, InventoryService inventoryService) {
        this.dashboardMapper = dashboardMapper;
        this.inventoryService = inventoryService;
    }

    public DashboardVO overview() {
        BigDecimal todaySalesAmount = dashboardMapper.todaySalesAmount();
        long todayOrderCount = dashboardMapper.todayOrderCount();
        BigDecimal todayAverageAmount = todayOrderCount == 0
                ? BigDecimal.ZERO
                : todaySalesAmount.divide(BigDecimal.valueOf(todayOrderCount), 2, RoundingMode.HALF_UP);
        long unprocessedAlertCount = inventoryService.unprocessedCount();
        long stockAlertCount = inventoryService.stockAlertCount();
        long expiryAlertCount = inventoryService.expiryAlertCount();
        return new DashboardVO(todaySalesAmount, todayOrderCount, todayAverageAmount, unprocessedAlertCount, stockAlertCount, expiryAlertCount);
    }
}
