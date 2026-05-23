package com.suat.app.backend.todo_service.dto;

// 前端发送 /login 和 /register 请求时，Body 体的格式
public record AuthRequest(
        String username,
        String password
) {}