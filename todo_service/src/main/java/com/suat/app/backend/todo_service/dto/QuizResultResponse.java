package com.suat.app.backend.todo_service.dto;

import java.util.Map;
//(用于返回批改结果)
public record QuizResultResponse(
        int totalQuestions,
        int correctAnswers,
        double score, // e.g., 66.7
        // (Key: questionId, Value: correctOptionId)
        // 告诉前端每道题的正确答案，用于显示“错题解析”
        Map<Long, Long> correctAnswersMap
) {}