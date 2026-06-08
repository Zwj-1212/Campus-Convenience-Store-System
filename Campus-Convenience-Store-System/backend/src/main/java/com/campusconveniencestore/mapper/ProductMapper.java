package com.campusconveniencestore.mapper;

import com.campusconveniencestore.dto.ProductRequest;
import com.campusconveniencestore.vo.ProductVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ProductMapper {

    List<ProductVO> findAll(@Param("keyword") String keyword, @Param("categoryId") Integer categoryId, @Param("status") Integer status);

    Optional<ProductVO> findById(@Param("productId") Integer productId);

    int insert(Map<String, Object> params);

    int update(@Param("productId") Integer productId, @Param("request") ProductRequest request);

    int updateStatus(@Param("productId") Integer productId, @Param("status") Integer status);
}
