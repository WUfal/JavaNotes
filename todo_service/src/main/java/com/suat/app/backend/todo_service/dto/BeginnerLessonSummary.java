package com.suat.app.backend.todo_service.dto;

public record BeginnerLessonSummary(
        Long id,
        String title
        // (我们可以稍后添加 "is_completed" 状态)
) {}