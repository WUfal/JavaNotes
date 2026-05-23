package com.suat.app.backend.todo_service.dto;

public record PracticeRequest(
        String difficulty, // "初级", "中级", "高级"
        String topic,      // "Java基础", "集合", "多线程", "JVM", "Spring"...
        String type,     // "CHOICE" (选择), "CODE" (编程), "QA" (简答), "RANDOM" (随机)
        String extraRequirement // 用户输入的具体要求 (可为空)
) {}