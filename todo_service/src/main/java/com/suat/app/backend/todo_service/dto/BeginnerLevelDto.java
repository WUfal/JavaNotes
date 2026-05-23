package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record BeginnerLevelDto(
        Long id,
        String title, // "第1关：变量与数据类型"
        List<BeginnerLessonSummary> lessons // 关卡下的所有小课时
) {}