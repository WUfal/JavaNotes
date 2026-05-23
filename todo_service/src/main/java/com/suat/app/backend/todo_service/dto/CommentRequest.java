package com.suat.app.backend.todo_service.dto;

public record CommentRequest(
        String targetType, // "PROJECT", "ALGORITHM"...
        String targetId,   // "1", "core_oop"...
        String content
) {}