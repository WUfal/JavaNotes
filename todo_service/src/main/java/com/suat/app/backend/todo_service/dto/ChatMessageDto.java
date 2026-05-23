package com.suat.app.backend.todo_service.dto;

// (这个 DTO 用于前端向后端传递聊天历史)
public record ChatMessageDto(
        String role,  // "user" (用户) 或 "model" (AI)
        String text   // 消息内容
) {}