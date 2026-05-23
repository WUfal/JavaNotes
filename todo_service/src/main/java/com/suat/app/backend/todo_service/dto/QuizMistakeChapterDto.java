package com.suat.app.backend.todo_service.dto;

import java.util.List;

// (这是一个新的 DTO)
// (代表一个“包含错题的章节”)
public record QuizMistakeChapterDto(
        Long chapterId,
        String chapterTitle,
        List<QuizQuestionDto> mistakes // (复用我们已有的 QuizQuestionDto)
) {}