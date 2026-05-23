package com.suat.app.backend.todo_service.dto;

public record BeginnerLogicProblemSummary(
        Long id,
        String title
        // (稍后可以添加 "is_completed" 状态)
) {}