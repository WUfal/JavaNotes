package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record BeginnerLogicProblemDetail(
        Long id,
        String title,
        List<ContentBlock> descriptionBlocks, // 题目描述 (复用)
        String codeStub // 初始代码 (我们假设只有一个 STUB)
) {}