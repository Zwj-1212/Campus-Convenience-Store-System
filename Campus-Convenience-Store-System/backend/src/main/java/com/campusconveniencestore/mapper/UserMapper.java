package com.campusconveniencestore.mapper;

import com.campusconveniencestore.vo.LoginResponse;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

public interface UserMapper {

    Optional<LoginResponse> findByUsernameAndPassword(@Param("username") String username, @Param("password") String password);
}
