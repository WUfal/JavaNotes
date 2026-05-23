package com.suat.app.backend.todo_service.dto;

// 前端 "运行" 代码时发送的 Body
public record CodeRunRequest(
        String code // 完整的 Java 代码字符串
) {}