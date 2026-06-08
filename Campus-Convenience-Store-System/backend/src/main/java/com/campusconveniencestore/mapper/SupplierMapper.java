package com.campusconveniencestore.mapper;

import com.campusconveniencestore.dto.SupplierRequest;
import com.campusconveniencestore.vo.SupplierVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface SupplierMapper {

    List<SupplierVO> findAll();

    Optional<SupplierVO> findById(@Param("supplierId") Integer supplierId);

    Optional<SupplierVO> findByName(@Param("supplierName") String supplierName);

    int insert(Map<String, Object> params);

    int update(@Param("supplierId") Integer supplierId, @Param("request") SupplierRequest request);
}
