package com.suat.app.backend.todo_service.dto;

// 后端 "运行" 完毕后返回的结果
public record CodeRunResponse(
        String output, // "stdout" (标准输出)
        String error   // "stderr" (编译错误或运行时错误)
) {}