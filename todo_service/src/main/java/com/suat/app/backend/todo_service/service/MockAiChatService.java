package com.suat.app.backend.todo_service.service;// ... (imports)
import com.suat.app.backend.todo_service.dto.ChatMessageDto; // <--- (新增)
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.util.List; // <--- (新增)

@Service
@ConditionalOnProperty(name = "ai.service.mode", havingValue = "mock", matchIfMissing = true)
public class MockAiChatService implements AiChatService {

    @Override // (现在匹配新合同)
    public String getAiReply(List<ChatMessageDto> history, String contextTitle, String persona) {

        // (我们只关心 *最后一条* 消息，因为这是“模拟” AI)
        String userMessage = history.get(history.size() - 1).text();

        // (模拟 AI 思考延迟)
        try { Thread.sleep(1500); } catch (InterruptedException e) {}

        String lowerMsg = userMessage.toLowerCase();
        String lowerContext = (contextTitle != null) ? contextTitle.toLowerCase() : ""; // (使用 Title)

        // --- (Bug 2 修复：现在我们比较的是“标题”) ---
        if (lowerMsg.contains("它") || lowerMsg.contains("这个")) {
            // (注意：我们现在比较的是 *可读* 的标题)
            if (lowerContext.contains("面向对象")) {
                return "你是指“面向对象编程”(OOP) 吗？OOP 是一种编程范式...";
            }
            if (lowerContext.contains("电商后端")) {
                return "你是指“电商后端API实战”项目吗？这是一个 Spring Boot 练习。";
            }
        }
        // ... (其他 if/else 不变) ...

        return "抱歉，我对 '" + userMessage + "' 这个问题还在学习中。(来自模拟 AI)";
    }
}