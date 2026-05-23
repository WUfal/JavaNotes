package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.ChatRequest;
import com.suat.app.backend.todo_service.dto.ChatResponse;
import com.suat.app.backend.todo_service.service.AiChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/ai")
public class AiChatController {

    @Autowired
    private AiChatService aiChatService;

    /**
     * API: 聊天
     * (这个 API 会被 /api/v1/** 规则自动保护，必须带 Token)
     */
    @PostMapping("/chat")
    public ResponseEntity<ChatResponse> chat(@RequestBody ChatRequest request) {
        // 1. 将工作委托给 Service
        String reply = aiChatService.getAiReply(
                request.history(),
                request.contextTitle(),
                request.persona() // <--- 传入
        );
        // 2. 包装并返回
        return ResponseEntity.ok(new ChatResponse(reply));
    }
}