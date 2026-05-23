package com.suat.app.backend.todo_service.dto;

public record ContentBlock(
        String type,     // "text", "sub-header", "code"
        String content,  // 实际内容
        String language  // 语言类型, 仅 'code' 类型需要
) {
    // 辅助构造函数, 方便创建 "text" 和 "sub-header"
    public ContentBlock(String type, String content) {
        this(type, content, null);
    }
}
