package com.campusconveniencestore.service;

import com.campusconveniencestore.dao.DashboardDao;
import com.campusconveniencestore.vo.DashboardVO;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
public class DashboardService {

    private final DashboardDao dashboardDao;
    private final InventoryService inventoryService;

    public DashboardService(DashboardDao dashboardDao, InventoryService inventoryService) {
        this.dashboardDao = dashboardDao;
        this.inventoryService = inventoryService;
    }

    public DashboardVO overview() {
        BigDecimal todaySalesAmount = dashboardDao.todaySalesAmount();
        long todayOrderCount = dashboardDao.todayOrderCount();
        BigDecimal todayAverageAmount = todayOrderCount == 0
                ? BigDecimal.ZERO
                : todaySalesAmount.divide(BigDecimal.valueOf(todayOrderCount), 2, RoundingMode.HALF_UP);
        long unprocessedAlertCount = inventoryService.unprocessedCount();
        long stockAlertCount = inventoryService.stockAlertCount();
        long expiryAlertCount = inventoryService.expiryAlertCount();
        return new DashboardVO(todaySalesAmount, todayOrderCount, todayAverageAmount, unprocessedAlertCount, stockAlertCount, expiryAlertCount);
    }
}
