package com.campusconveniencestore.service;

import com.campusconveniencestore.dto.SupplierRequest;
import com.campusconveniencestore.exception.BusinessException;
import com.campusconveniencestore.mapper.SupplierMapper;
import com.campusconveniencestore.vo.SupplierVO;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SupplierService {

    private final SupplierMapper supplierMapper;

    public SupplierService(SupplierMapper supplierMapper) {
        this.supplierMapper = supplierMapper;
    }

    public List<SupplierVO> list() {
        return supplierMapper.findAll();
    }

    public SupplierVO detail(Integer supplierId) {
        return supplierMapper.findById(supplierId)
                .orElseThrow(() -> new BusinessException("供应商不存在"));
    }

    public Integer create(SupplierRequest request) {
        // 检查供应商名称是否已存在，避免重复创建
        supplierMapper.findByName(request.supplierName())
                .ifPresent(s -> {
                    throw new BusinessException("供应商名称「" + request.supplierName() + "」已存在");
                });

        Map<String, Object> params = new HashMap<>();
        params.put("supplierName", request.supplierName());
        params.put("contactPerson", request.contactPerson());
        params.put("phone", request.phone());
        params.put("address", request.address());
        params.put("status", request.status());
        supplierMapper.insert(params);
        return (Integer) params.get("id");
    }

    public void update(Integer supplierId, SupplierRequest request) {
        // 检查供应商名称是否与其他供应商重复
        supplierMapper.findByName(request.supplierName())
                .filter(existing -> !existing.supplierId().equals(supplierId))
                .ifPresent(existing -> {
                    throw new BusinessException("供应商名称「" + request.supplierName() + "」已被其他供应商使用");
                });

        int affected = supplierMapper.update(supplierId, request);
        if (affected == 0) {
            throw new BusinessException("供应商不存在或未发生变更");
        }
    }
}
