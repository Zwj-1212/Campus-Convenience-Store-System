package com.campusconveniencestore.service;

import com.campusconveniencestore.dto.ProductRequest;
import com.campusconveniencestore.exception.BusinessException;
import com.campusconveniencestore.mapper.ProductMapper;
import com.campusconveniencestore.vo.ProductVO;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProductService {

    private final ProductMapper productMapper;

    public ProductService(ProductMapper productMapper) {
        this.productMapper = productMapper;
    }

    public List<ProductVO> list(String keyword, Integer categoryId, Integer status) {
        return productMapper.findAll(keyword, categoryId, status);
    }

    public ProductVO detail(Integer productId) {
        return productMapper.findById(productId)
                .orElseThrow(() -> new BusinessException("商品不存在"));
    }

    public Integer create(ProductRequest request) {
        Map<String, Object> params = new HashMap<>();
        params.put("productName", request.productName());
        params.put("categoryId", request.categoryId());
        params.put("barcode", request.barcode());
        params.put("unit", request.unit());
        params.put("spec", request.spec());
        params.put("defaultPrice", request.defaultPrice());
        params.put("alertMin", request.alertMin());
        params.put("status", request.status());
        productMapper.insert(params);
        return (Integer) params.get("id");
    }

    public void update(Integer productId, ProductRequest request) {
        int affected = productMapper.update(productId, request);
        if (affected == 0) {
            throw new BusinessException("商品不存在或未发生变更");
        }
    }

    public void updateStatus(Integer productId, Integer status) {
        int affected = productMapper.updateStatus(productId, status);
        if (affected == 0) {
            throw new BusinessException("商品不存在或未发生变更");
        }
    }
}
