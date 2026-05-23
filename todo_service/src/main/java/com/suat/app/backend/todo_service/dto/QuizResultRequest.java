package com.suat.app.backend.todo_service.dto;

import java.util.Map;
//这个 DTO 用于前端提交答案。
// Body 格式: { "answers": { 1: 2, 3: 10, ... } }
// (Key: questionId, Value: selectedOptionId)
public record QuizResultRequest(
        Map<Long, Long> answers
) {}