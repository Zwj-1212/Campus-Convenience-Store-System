package com.campusconveniencestore.service;

import com.campusconveniencestore.exception.BusinessException;
import com.campusconveniencestore.mapper.InventoryMapper;
import com.campusconveniencestore.vo.AlertVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InventoryService {

    private final InventoryMapper inventoryMapper;

    public InventoryService(InventoryMapper inventoryMapper) {
        this.inventoryMapper = inventoryMapper;
    }

    public List<AlertVO> listAlerts(Integer status) {
        return inventoryMapper.findAlerts(status);
    }

    public void markAlertHandled(Integer alertId) {
        int affected = inventoryMapper.markHandled(alertId);
        if (affected == 0) {
            throw new BusinessException("预警不存在或已经处理");
        }
    }

    public long unprocessedCount() {
        return inventoryMapper.countUnprocessed();
    }

    public long stockAlertCount() {
        return inventoryMapper.countByType(1);
    }

    public long expiryAlertCount() {
        return inventoryMapper.countByType(2);
    }
}
