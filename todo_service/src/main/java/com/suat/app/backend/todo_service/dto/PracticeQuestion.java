package com.suat.app.backend.todo_service.dto;

import java.util.List;

public record PracticeQuestion(
        String type,          // "CHOICE", "CODE", "QA"
        String title,         // 题目标题
        String description,   // 详细描述
        List<String> options, // 选项 (仅用于 CHOICE, e.g., ["A. ...", "B. ..."])
        String correctAnswer, // 正确选项 (仅用于 CHOICE, e.g., "A")
        String codeStub,      // 代码模板 (仅用于 CODE)
        String explanation    // 解析/参考答案 (用于用户答题后查看)
) {}