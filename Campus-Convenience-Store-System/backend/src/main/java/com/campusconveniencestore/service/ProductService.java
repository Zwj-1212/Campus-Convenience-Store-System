package com.campusconveniencestore.service;

import com.campusconveniencestore.dao.ProductDao;
import com.campusconveniencestore.dto.ProductRequest;
import com.campusconveniencestore.exception.BusinessException;
import com.campusconveniencestore.vo.ProductVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final ProductDao productDao;

    public ProductService(ProductDao productDao) {
        this.productDao = productDao;
    }

    public List<ProductVO> list(String keyword, Integer categoryId, Integer status) {
        return productDao.findAll(keyword, categoryId, status);
    }

    public ProductVO detail(Integer productId) {
        return productDao.findById(productId)
                .orElseThrow(() -> new BusinessException("商品不存在"));
    }

    public Integer create(ProductRequest request) {
        return productDao.insert(request);
    }

    public void update(Integer productId, ProductRequest request) {
        int affected = productDao.update(productId, request);
        if (affected == 0) {
            throw new BusinessException("商品不存在或未发生变更");
        }
    }

    public void updateStatus(Integer productId, Integer status) {
        int affected = productDao.updateStatus(productId, status);
        if (affected == 0) {
            throw new BusinessException("商品不存在或未发生变更");
        }
    }
}
