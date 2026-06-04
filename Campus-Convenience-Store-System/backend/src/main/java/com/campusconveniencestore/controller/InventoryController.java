package com.campusconveniencestore.controller;

import com.campusconveniencestore.common.Result;
import com.campusconveniencestore.service.InventoryService;
import com.campusconveniencestore.vo.AlertVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "库存预警")
@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @Operation(summary = "预警列表", description = "默认返回未处理预警，也可以通过 status 过滤")
    @GetMapping("/alerts")
    public Result<List<AlertVO>> alerts(@RequestParam(required = false) Integer status) {
        return Result.ok(inventoryService.listAlerts(status));
    }

    @Operation(summary = "处理预警")
    @PutMapping("/alerts/{id}")
    public Result<Void> markHandled(@PathVariable Integer id) {
        inventoryService.markAlertHandled(id);
        return Result.ok("处理成功", null);
    }
}
