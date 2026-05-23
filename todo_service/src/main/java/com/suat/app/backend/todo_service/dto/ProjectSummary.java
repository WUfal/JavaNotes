package com.suat.app.backend.todo_service.dto;

public record ProjectSummary(
        String id,
        String title,
        String description,
        String techStack // e.g., "Spring Boot, MySQL"
) {}
