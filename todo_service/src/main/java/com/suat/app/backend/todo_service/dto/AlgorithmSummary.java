package com.suat.app.backend.todo_service.dto;

public record AlgorithmSummary(
        String id,
        String title,
        String difficulty // "Easy", "Medium", "Hard"
) {}