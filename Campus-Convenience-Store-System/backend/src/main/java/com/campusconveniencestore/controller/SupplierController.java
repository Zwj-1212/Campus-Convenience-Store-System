package com.campusconveniencestore.controller;

import com.campusconveniencestore.common.Result;
import com.campusconveniencestore.dto.SupplierRequest;
import com.campusconveniencestore.service.SupplierService;
import com.campusconveniencestore.vo.SupplierVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "供应商管理")
@RestController
@RequestMapping("/api/suppliers")
public class SupplierController {

    private final SupplierService supplierService;

    public SupplierController(SupplierService supplierService) {
        this.supplierService = supplierService;
    }

    @Operation(summary = "供应商列表")
    @GetMapping
    public Result<List<SupplierVO>> list() {
        return Result.ok(supplierService.list());
    }

    @Operation(summary = "供应商详情")
    @GetMapping("/{id}")
    public Result<SupplierVO> detail(@PathVariable Integer id) {
        return Result.ok(supplierService.detail(id));
    }

    @Operation(summary = "新增供应商")
    @PostMapping
    public Result<Integer> create(@Valid @RequestBody SupplierRequest request) {
        return Result.ok("新增成功", supplierService.create(request));
    }

    @Operation(summary = "修改供应商")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Integer id, @Valid @RequestBody SupplierRequest request) {
        supplierService.update(id, request);
        return Result.ok("修改成功", null);
    }
}
