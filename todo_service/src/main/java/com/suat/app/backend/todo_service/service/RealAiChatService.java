package com.suat.app.backend.todo_service.service;

// --- ⬇️ (关键) 我们不再需要 Google SDK ⬇️ ---
// (删除了所有 com.google.genai 的 imports)

import com.fasterxml.jackson.annotation.JsonProperty; // (用于解析 JSON)
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
// (导入 ChatMessageDto)
import com.suat.app.backend.todo_service.dto.ChatMessageDto;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.ArrayList;
@Service
@ConditionalOnProperty(name = "ai.service.mode", havingValue = "real")
public class RealAiChatService implements AiChatService {

    // (注入 API Key)
    @Value("${ai.llm.api-key}")
    private String apiKey; // (假设豆包也用这个 Key)

    private final RestTemplate restTemplate = new RestTemplate();

    private String systemPrompt; // (用于保存系统指令)

    // (假设豆包的 API URL)
    private final String doubaoApiUrl = "https://ark.cn-beijing.volces.com/api/v3/chat/completions"; // (你需要换成真实的 URL)
    // (定义我们的“滑动窗口”大小)
    // (我们将保留最近 10 条消息 = 5 轮对话)
    private static final int MAX_HISTORY_TURNS = 10;



    @PostConstruct
    public void init() {
        // (我们保留你的系统指令, 稍后拼接到 Prompt 中
    }

    // (这是 AiChatService 接口 *旧* 的方法)


    // (这是我们 *新* 的、被 Controller 调用的方法)
    @Override
    public String getAiReply(List<ChatMessageDto> history, String contextTitle, String persona) {
        System.out.println("👉 DEBUG: 收到 AI 请求。人设: [" + persona + "]");
        // 1. (截断) 获取完整的历史记录
        List<ChatMessageDto> recentHistory = new ArrayList<>(history);

        // 2. (截断) 如果历史记录超过了我们的限制 (10条)
        if (recentHistory.size() > MAX_HISTORY_TURNS) {
            // (只保留最后 10 条)
            recentHistory = recentHistory.subList(
                    recentHistory.size() - MAX_HISTORY_TURNS, // (起始索引)
                    recentHistory.size()                  // (结束索引)
            );
        }

        // 3. (构建) 将 *截断后* 的历史转换为 JSON
        List<Map<String, String>> messages = recentHistory.stream()
                .map(msg -> Map.of(
                        "role", msg.role().equals("user") ? "user" : "assistant",
                        "content", msg.text()
                ))
                .collect(Collectors.toList());

        String systemInstruction = getSystemPrompt(persona);

        String finalSystemPrompt = systemInstruction;
        if (contextTitle != null && !contextTitle.isEmpty()) {
            finalSystemPrompt += "\n\n[当前上下文: " + contextTitle + "]";
        }
        // 插在最前面
        messages.add(0, Map.of("role", "system", "content", finalSystemPrompt));
        // 4. (构建请求 - 不变)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        Map<String, Object> requestBody = Map.of(
                "model", "doubao-seed-1-6-lite-251015",
                "messages", messages
        );

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        try {
            // 5. (调用 API - 不变)
            DoubaoResponse response = restTemplate.postForObject(
                    doubaoApiUrl,
                    entity,
                    DoubaoResponse.class
            );

            // 6. (解析响应 - 不变)
            if (response != null && response.choices != null && !response.choices.isEmpty()) {
                return response.choices.get(0).message.content;
            } else {
                return "AI (豆包) 返回了空的响应。";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "调用 AI 服务失败: " + e.getMessage();
        }
    }

    // --- ⬇️ (关键新增) ⬇️ ---
    // (我们需要创建“嵌套”的 DTOs 来匹配豆包的 JSON 响应)
    // (为了方便，我们就把它们作为 *私有* 静态类定义在这里)

    private static class DoubaoResponse {
        @JsonProperty("choices")
        public List<Choice> choices;
    }

    private static class Choice {
        @JsonProperty("message")
        public Message message;
    }

    private static class Message {
        @JsonProperty("content")
        public String content;
    }
    // --- ⬆️ (新增结束) ⬆️ ---
    // (新增) 辅助方法
    private String getSystemPrompt(String persona) {
        String base = """
        核心要求：
        1. 默认中文回复，仅当学生明确要求英文时切换；
        2. 视角前沿不陈旧，输出贴合当前技术生态的实用见解，助力学生构建岗位所需核心能力；
        3. 对学生的认知偏差或错误思路，需明确指出并给出修正方向；
        4. 若学生提问不够具体（如缺少场景、代码、需求细节），主动引导其补充信息，确保解答精准。
        5. 遵从模式风格，比如温柔老师，严厉面试官或者言简意赅的极客(重要)
        """;

        if ("strict".equals(persona)) {
            base += """
                \n【当前模式：严厉面试官 (STRICT)】
                1. 你的态度必须非常严厉、挑剔、冷漠。不要说“你好”、“不错”等客套话。
                2. 假设用户是来面试高级职位的，对任何低级错误都要毫不留情地批评。
                3. 回答要极其简练，直击要害。如果用户问得傻，直接反问回去。
                4. 你的目标是给用户压力，逼迫他思考。
                """;
        } else if ("geek".equals(persona)) {
            base += """
                \n【当前模式：硬核极客 (GEEK)】
                1. 这里的交流仅限于技术狂热者。请大量使用计算机科学专业术语（如内存屏障、指令重排、V8引擎）。
                2. 不要讲表面的 API 用法，要深入讲底层源码、汇编实现、OS 调度原理。
                3. 表现出对技术细节的极致追求，使用 emoji (🤖, ⚡, 🧠) 来表达极客精神。
                """;
        } else if("gentle".equals(persona)){
            // gentle 或 默认
            base += """
                \n【当前模式：温柔导师 (GENTLE)】
                1. 你的态度要非常亲切、耐心、充满鼓励。就像对待初学者一样。
                2. 解释概念时要多用生活中的比喻，通俗易懂。
                3. 无论用户问什么，先肯定他的好奇心，再给出答案。
                """;
        } else {
                // 默认：温柔导师 (GENTLE)
            base += """
                \n【当前模式：原始风格 (ORIGINAL)】
                1. 请保持 AI 的默认语气：客观、中立、专业。
                2. 不需要扮演任何特定角色（如老师或面试官）。
                3. 直接回答问题，不添加额外的寒暄或情感色彩。
                """;
        }

        base += "\n请简洁地回答用户的问题。如果用户提供了上下文，请优先结合上下文回答。";
        return base;
    }
}