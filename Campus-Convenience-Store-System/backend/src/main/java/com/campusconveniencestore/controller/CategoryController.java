package com.campusconveniencestore.controller;

import com.campusconveniencestore.common.Result;
import com.campusconveniencestore.service.CategoryService;
import com.campusconveniencestore.vo.CategoryVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "商品类别")
@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @Operation(summary = "类别列表")
    @GetMapping
    public Result<List<CategoryVO>> list() {
        return Result.ok(categoryService.list());
    }
}
