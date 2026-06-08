package com.campusconveniencestore.service;

import com.campusconveniencestore.dao.CategoryDao;
import com.campusconveniencestore.vo.CategoryVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    private final CategoryDao categoryDao;

    public CategoryService(CategoryDao categoryDao) {
        this.categoryDao = categoryDao;
    }

    public List<CategoryVO> list() {
        return categoryDao.findAll();
    }
}
