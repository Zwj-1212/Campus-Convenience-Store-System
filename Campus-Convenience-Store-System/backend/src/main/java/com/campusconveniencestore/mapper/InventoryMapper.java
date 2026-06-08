package com.campusconveniencestore.mapper;

import com.campusconveniencestore.vo.AlertVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface InventoryMapper {

    List<AlertVO> findAlerts(@Param("status") Integer status);

    int markHandled(@Param("alertId") Integer alertId);

    long countUnprocessed();

    long countByType(@Param("alertType") int alertType);
}
