package com.campusconveniencestore.vo;

public record SupplierVO(
        Integer supplierId,
        String supplierName,
        String contactPerson,
        String phone,
        String address,
        Integer status) {
}
