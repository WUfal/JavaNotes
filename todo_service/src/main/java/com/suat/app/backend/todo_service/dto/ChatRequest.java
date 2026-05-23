package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record ChatRequest(
        List<ChatMessageDto> history, // (不再是 String message)
        String contextTitle,
        String persona // <--- (新增)// (不再是 String context)
) {}