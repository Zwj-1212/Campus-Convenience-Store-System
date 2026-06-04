package com.campusconveniencestore.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record ProductRequest(
        @NotBlank(message = "商品名称不能为空") String productName,
        @NotNull(message = "类别不能为空") Integer categoryId,
        String barcode,
        @NotBlank(message = "单位不能为空") String unit,
        String spec,
        @NotNull(message = "默认售价不能为空") @DecimalMin(value = "0.01", message = "默认售价必须大于 0") BigDecimal defaultPrice,
        @NotNull(message = "预警阈值不能为空") @Min(value = 0, message = "预警阈值不能小于 0") Integer alertMin,
        @NotNull(message = "状态不能为空") Integer status) {
}
