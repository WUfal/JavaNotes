package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record ProjectStep(
        String stepTitle,
        List<ContentBlock> blocks // 复用我们已有的 ContentBlock！
) {}