package com.campusconveniencestore.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record SupplierRequest(
        @NotBlank(message = "供应商名称不能为空") String supplierName,
        String contactPerson,
        String phone,
        String address,
        @NotNull(message = "状态不能为空") Integer status) {
}
