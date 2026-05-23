package com.suat.app.backend.todo_service.dto;

public record QuizChapterSummary(
        Long id,
        String title
        // (稍后可以添加 "score" 等)
) {}