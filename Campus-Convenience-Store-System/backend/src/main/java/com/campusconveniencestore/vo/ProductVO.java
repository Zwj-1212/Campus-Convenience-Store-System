package com.campusconveniencestore.vo;

import java.math.BigDecimal;

public record ProductVO(
        Integer productId,
        String productName,
        Integer categoryId,
        String categoryName,
        String barcode,
        String unit,
        String spec,
        BigDecimal defaultPrice,
        Integer alertMin,
        Integer status) {
}
