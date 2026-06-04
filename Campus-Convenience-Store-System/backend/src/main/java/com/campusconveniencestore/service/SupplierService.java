package com.campusconveniencestore.service;

import com.campusconveniencestore.dao.SupplierDao;
import com.campusconveniencestore.dto.SupplierRequest;
import com.campusconveniencestore.exception.BusinessException;
import com.campusconveniencestore.vo.SupplierVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SupplierService {

    private final SupplierDao supplierDao;

    public SupplierService(SupplierDao supplierDao) {
        this.supplierDao = supplierDao;
    }

    public List<SupplierVO> list() {
        return supplierDao.findAll();
    }

    public SupplierVO detail(Integer supplierId) {
        return supplierDao.findById(supplierId)
                .orElseThrow(() -> new BusinessException("供应商不存在"));
    }

    public Integer create(SupplierRequest request) {
        return supplierDao.insert(request);
    }

    public void update(Integer supplierId, SupplierRequest request) {
        int affected = supplierDao.update(supplierId, request);
        if (affected == 0) {
            throw new BusinessException("供应商不存在或未发生变更");
        }
    }
}
