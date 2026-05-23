package com.suat.app.backend.todo_service.dto;

import java.util.List;

// 模块详情的完整结构
public record ModuleDetail(
        String id,
        String title,
        List<ContentBlock> blocks
) {}