package com.campusconveniencestore.controller;

import com.campusconveniencestore.common.Result;
import com.campusconveniencestore.dto.ProductRequest;
import com.campusconveniencestore.service.ProductService;
import com.campusconveniencestore.vo.ProductVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "商品管理")
@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @Operation(summary = "商品列表", description = "支持关键词、类别和状态筛选")
    @GetMapping
    public Result<List<ProductVO>> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) Integer status) {
        return Result.ok(productService.list(keyword, categoryId, status));
    }

    @Operation(summary = "商品详情")
    @GetMapping("/{id}")
    public Result<ProductVO> detail(@Parameter(description = "商品 ID") @PathVariable Integer id) {
        return Result.ok(productService.detail(id));
    }

    @Operation(summary = "新增商品")
    @PostMapping
    public Result<Integer> create(@Valid @RequestBody ProductRequest request) {
        return Result.ok("新增成功", productService.create(request));
    }

    @Operation(summary = "修改商品")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Integer id, @Valid @RequestBody ProductRequest request) {
        productService.update(id, request);
        return Result.ok("修改成功", null);
    }

    @Operation(summary = "修改商品状态")
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Integer id, @RequestParam Integer status) {
        productService.updateStatus(id, status);
        return Result.ok("状态更新成功", null);
    }
}
