package com.campusconveniencestore.service;

import com.campusconveniencestore.dao.InventoryDao;
import com.campusconveniencestore.exception.BusinessException;
import com.campusconveniencestore.vo.AlertVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InventoryService {

    private final InventoryDao inventoryDao;

    public InventoryService(InventoryDao inventoryDao) {
        this.inventoryDao = inventoryDao;
    }

    public List<AlertVO> listAlerts(Integer status) {
        return inventoryDao.findAlerts(status);
    }

    public void markAlertHandled(Integer alertId) {
        int affected = inventoryDao.markHandled(alertId);
        if (affected == 0) {
            throw new BusinessException("预警不存在或已经处理");
        }
    }

    public long unprocessedCount() {
        return inventoryDao.countUnprocessed();
    }

    public long stockAlertCount() {
        return inventoryDao.countByType(1);
    }

    public long expiryAlertCount() {
        return inventoryDao.countByType(2);
    }
}
