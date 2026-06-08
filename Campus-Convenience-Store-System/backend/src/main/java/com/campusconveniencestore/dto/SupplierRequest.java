package com.campusconveniencestore.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record SupplierRequest(
        @NotBlank(message = "供应商名称不能为空") String supplierName,
        String contactPerson,
        @Pattern(regexp = "^$|^\\d{11}$", message = "电话号码必须为11位数字") String phone,
        String address,
        @NotNull(message = "状态不能为空") Integer status) {
}
