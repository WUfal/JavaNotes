package com.suat.app.backend.todo_service.dto;

// (前端必须告诉我们 ID, 类型, 和标题，因为我们要存标题)
public record BookmarkRequest(
        String type, // "COURSE_MODULE", "PROJECT", "ALGORITHM"
        String id,   // "core_oop"
        String title // "面向对象 (OOP)"
) {}