package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record ProjectDetail(
        String id,
        String title,
        String description,
        List<ProjectStep> steps
) {}