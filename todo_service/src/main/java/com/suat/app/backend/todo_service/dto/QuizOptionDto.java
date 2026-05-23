package com.suat.app.backend.todo_service.dto;

public record QuizOptionDto(
        Long id,
        String text
        // (注意：我们 *不会* 把 isCorrect 字段发送给前端！)
) {}