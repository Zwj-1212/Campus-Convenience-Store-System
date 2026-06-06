package com.campusconveniencestore;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.campusconveniencestore.mapper")
public class CampusConvenienceStoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(CampusConvenienceStoreApplication.class, args);
    }
}
