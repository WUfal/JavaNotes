package com.suat.app.backend.todo_service.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.suat.app.backend.todo_service.dto.GradingRequest;
import com.suat.app.backend.todo_service.dto.GradingResponse;
import com.suat.app.backend.todo_service.dto.PracticeQuestion;
import com.suat.app.backend.todo_service.dto.PracticeRequest;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.PracticeGenerationTask;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.repository.PracticeTaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
public class AiPracticeService {

    @Value("${ai.llm.api-key}")
    private String apiKey;

    private final String apiUrl = "https://ark.cn-beijing.volces.com/api/v3/chat/completions";
    private final String modelName = "doubao-seed-1-6-flash-250828";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private PracticeTaskRepository taskRepository;

    @Autowired
    private AppUserRepository userRepository;

    // (关键) 注入自己，用于解决 @Async 同类调用失效的问题
    @Autowired
    @Lazy
    private AiPracticeService self;

    /**
     * 1. 创建任务 (同步方法，立即返回)
     * 返回创建好的任务实体
     */
    @Transactional
    public PracticeGenerationTask createGenerationTask(String username, PracticeRequest req) {
        AppUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // (阻止重复点击) 检查是否有正在进行的任务
        if (taskRepository.existsByAppUserAndStatus(user, "PENDING")) {
            throw new RuntimeException("您有一个任务正在生成中，请稍候再试。");
        }

        long count = taskRepository.countByAppUser(user);
        if (count >= 5) {
            throw new RuntimeException("任务列表已满 (5/5)。请先删除旧任务或一键清理！");
        }

        // 1. 创建数据库记录 (占位)
        PracticeGenerationTask task = new PracticeGenerationTask();
        task.setAppUser(user);
        task.setStatus("PENDING");
        task.setSummary(String.format("%s / %s / %s", req.difficulty(), req.topic(), req.type()));

        PracticeGenerationTask savedTask = taskRepository.save(task);

        // 2. (关键) 调用异步方法开始跑 AI
        // 必须通过 'self' 调用，@Async 才会生效！
        self.processBackgroundGeneration(savedTask.getId(), req);

        return savedTask;
    }

    /**
     * 2. 后台执行生成 (异步方法，耗时)
     */
    @Async
    @Transactional
    public void processBackgroundGeneration(Long taskId, PracticeRequest req) {
        // 重新获取任务 (确保拿到最新状态)
        PracticeGenerationTask task = taskRepository.findById(taskId).orElse(null);
        if (task == null) return;

        try {
            // --- (原有的 AI 生成逻辑) ---
            String systemPrompt = """
            You are a Java Interview Question Generator.
            Generate exactly 5 distinct questions based on user requirements.
            
            RULES:
            1. Return ONLY a valid JSON Array `[...]`. No markdown.
            2. JSON Structure per item:
            {
               "type": "CHOICE" | "CODE" | "QA",
               "title": "Short title",
               "description": "Question text",
               "options": ["A. Option 1", "B. Option 2", "C. Option 3", "D. Option 4"],  <-- 关键：CHOICE 类型必须有此字段
               "correctAnswer": "A",
               "codeStub": "...",
               "explanation": "..."
            }
            3. For 'CHOICE' type, 'options' MUST be a list of 4 strings.
            4. Language: Chinese.
            """;
            String userPrompt = String.format(
                    "Requirements: Difficulty [%s], Topic [%s], Type [%s]. %s",
                    req.difficulty(), req.topic(), req.type(),
                    (req.extraRequirement() != null ? "Extra: " + req.extraRequirement() : "")
            );

            // 调用 AI
            String content = callAiApi(systemPrompt, userPrompt);

            // 验证一下是不是合法的 JSON 数组 (可选，为了保险)
            objectMapper.readTree(content);

            // --- (保存结果) ---
            task.setQuestionsJson(content);
            task.setStatus("COMPLETED");
            task.setErrorMessage(null);

        } catch (Exception e) {
            e.printStackTrace();
            task.setStatus("FAILED");
            task.setErrorMessage("生成失败: " + e.getMessage());
        } finally {
            taskRepository.save(task);
        }
    }

    // --- 2. 修改：获取任务列表 (增加“自动修复卡死任务”逻辑) ---
    public List<PracticeGenerationTask> getUserTasks(String username) {
        AppUser user = userRepository.findByUsername(username).orElseThrow();
        List<PracticeGenerationTask> tasks = taskRepository.findByAppUserOrderByCreatedAtDesc(user);

        // --- ⬇️ (新增) 自动修复 "假死" (Stuck) 任务 ⬇️ ---
        boolean needSave = false;
        long now = System.currentTimeMillis();
        long timeoutThreshold = 5 * 60 * 1000; // 5分钟超时

        for (PracticeGenerationTask task : tasks) {
            // 如果状态是 PENDING，且创建时间超过了 5 分钟
            if ("PENDING".equals(task.getStatus()) &&
                    (now - task.getCreatedAt().toEpochMilli() > timeoutThreshold)) {

                // 判定为“生成失败/中断”
                task.setStatus("FAILED");
                task.setErrorMessage("生成超时 (服务可能已重启)");
                taskRepository.save(task); // 保存状态
            }
        }
        // --- ⬆️ (新增结束) ⬆️ ---

        return tasks;
    }
    // --- 3. 新增：删除单个任务 ---
    @Transactional
    public void deleteTask(String username, Long taskId) {
        AppUser user = userRepository.findByUsername(username).orElseThrow();
        PracticeGenerationTask task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Task not found"));

        // 安全检查：只能删除自己的任务
        if (!task.getAppUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        taskRepository.delete(task);
    }

    // --- 4. 新增：清空所有任务 ---
    @Transactional
    public void clearAllTasks(String username) {
        AppUser user = userRepository.findByUsername(username).orElseThrow();
        taskRepository.deleteByAppUser(user);
    }
    /**
     * 4. 智能判题 (保持同步即可，因为这个一般比较快，或者也可以改成异步，但暂不改)
     */
    public GradingResponse gradeAnswer(GradingRequest req) {
        // ... (保持之前的代码不变) ...
        String systemPrompt = """
            You are a Java Technical Interviewer. Grade the user's answer.
            RULES:
            1. Return ONLY a valid JSON object.
            2. JSON Structure:
            {
               "score": 0-10,
               "comment": "Brief evaluation of correctness and logic",
               "improvement": "Specific suggestions for optimization",
               "referenceAnswer": "Here provides the standard correct answer or code example."  <-- 关键：必须要求返回这个
            }
            3. Language: Chinese.
            """;
        String userPrompt = String.format(
                "【Question】%s\n%s\n\n【User Code/Answer】\n%s\n\n【User Thoughts】\n%s",
                req.questionTitle(),
                req.questionDescription(),
                req.userAnswer(),
                req.userThought() != null ? req.userThought() : "No thoughts provided."
        );

        try {
            String content = callAiApi(systemPrompt, userPrompt);
            return objectMapper.readValue(content, GradingResponse.class);
        } catch (Exception e) {
            return new GradingResponse(0, "判题失败", e.getMessage(), "无");
        }
    }

    // (私有辅助方法：调用 HTTP)
    private String callAiApi(String systemPrompt, String userPrompt) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);
        Map<String, String> extraBody = Collections.singletonMap("thinking_mode", "non-thinking");
        Map<String, Object> requestBody = Map.of(
                "model", modelName,
                "messages", List.of(
                        Map.of("role", "system", "content", systemPrompt),
                        Map.of("role", "user", "content", userPrompt)
                ),
                "temperature", 0.7
//                "extra_body", extraBody // 核心：添加关闭思考模式的参数
        );

        Map response = restTemplate.postForObject(apiUrl, new HttpEntity<>(requestBody, headers), Map.class);
        List<Map> choices = (List<Map>) response.get("choices");
        String content = (String) ((Map) choices.get(0).get("message")).get("content");

        return content.replace("```json", "").replace("```", "").trim();
    }

}