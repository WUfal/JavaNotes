package com.suat.app.backend.todo_service.dto;

public record GradingResponse(
        int score,
        String comment,
        String improvement,
        String referenceAnswer // <--- (新增) 参考答案/标准代码
) {}