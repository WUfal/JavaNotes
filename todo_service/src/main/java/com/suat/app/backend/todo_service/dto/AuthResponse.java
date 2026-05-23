package com.suat.app.backend.todo_service.dto;

// 后端 /login 成功后，返回给前端的格式
public record AuthResponse(
        String token,
        String selectedPath // (这个值可以为 null)
) {}