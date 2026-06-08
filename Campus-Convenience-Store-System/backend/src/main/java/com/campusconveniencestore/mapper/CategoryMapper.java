package com.campusconveniencestore.mapper;

import com.campusconveniencestore.vo.CategoryVO;

import java.util.List;

public interface CategoryMapper {

    List<CategoryVO> findAll();
}
