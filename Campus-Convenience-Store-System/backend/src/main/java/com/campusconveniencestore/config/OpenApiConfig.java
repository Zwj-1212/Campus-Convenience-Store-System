package com.campusconveniencestore.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI campusStoreOpenAPI() {
        return new OpenAPI().info(new Info()
                .title("高校校园便利店管理系统 API")
                .version("v1.0.0")
                .description("Spring Boot + JDBC + Swagger 的课程设计后端接口文档"));
    }
}
