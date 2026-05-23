package com.suat.app.backend.todo_service.service;

// 1. (新增) 导入 DTO
import com.suat.app.backend.todo_service.dto.ChatMessageDto;
import java.util.List;

public interface AiChatService {

    // 2. (修改) "合同"现在要求传递“历史记录”和“上下文标题”
    String getAiReply(List<ChatMessageDto> history, String contextTitle, String persona);

}