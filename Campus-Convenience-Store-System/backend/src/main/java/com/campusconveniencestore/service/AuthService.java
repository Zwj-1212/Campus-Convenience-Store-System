package com.campusconveniencestore.service;

import com.campusconveniencestore.common.Result;
import com.campusconveniencestore.dto.LoginRequest;
import com.campusconveniencestore.mapper.UserMapper;
import com.campusconveniencestore.vo.LoginResponse;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserMapper userMapper;

    public AuthService(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    public Result<LoginResponse> login(LoginRequest request) {
        return userMapper.findByUsernameAndPassword(request.username(), request.password())
                .map(Result::ok)
                .orElseGet(() -> Result.fail("用户名或密码错误"));
    }
}
