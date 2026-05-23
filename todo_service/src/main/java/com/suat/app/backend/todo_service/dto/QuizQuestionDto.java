package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record QuizQuestionDto(
        Long id,
        String text, // 题干
        List<QuizOptionDto> options // 该题的所有选项
) {}