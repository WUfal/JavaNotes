package com.suat.app.backend.todo_service.dto;

public record GradingRequest(
        String questionTitle,
        String questionDescription,
        String userAnswer,
        String userThought // (新增：用户的思路，可选)
) {}