package com.campusconveniencestore.service;

import com.campusconveniencestore.mapper.CategoryMapper;
import com.campusconveniencestore.vo.CategoryVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    private final CategoryMapper categoryMapper;

    public CategoryService(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    public List<CategoryVO> list() {
        return categoryMapper.findAll();
    }
}
