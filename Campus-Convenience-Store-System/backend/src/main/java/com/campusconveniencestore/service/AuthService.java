package com.campusconveniencestore.service;

import com.campusconveniencestore.common.Result;
import com.campusconveniencestore.dao.UserDao;
import com.campusconveniencestore.dto.LoginRequest;
import com.campusconveniencestore.vo.LoginResponse;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserDao userDao;

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    public Result<LoginResponse> login(LoginRequest request) {
        return userDao.findByUsernameAndPassword(request.username(), request.password())
                .map(Result::ok)
                .orElseGet(() -> Result.fail("用户名或密码错误"));
    }
}
