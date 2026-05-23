package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record ModuleGroup(
        String groupTitle,
        List<ModuleItem> items
) {}