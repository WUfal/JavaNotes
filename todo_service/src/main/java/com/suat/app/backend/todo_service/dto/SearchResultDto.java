package com.suat.app.backend.todo_service.dto;

// (这是一个通用的 DTO, 用于返回任何类型的搜索结果)
public record SearchResultDto(
        String id,         // "core_oop" 或 "proj_ecommerce_api"
        String title,      // "面向对象 (OOP)"
        String snippet,    // (描述) "类、封装、继承..."
        String type        // "COURSE_MODULE", "PROJECT", "ALGORITHM"
) {}