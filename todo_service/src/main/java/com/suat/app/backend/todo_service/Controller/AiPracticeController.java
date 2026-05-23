package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.GradingRequest;
import com.suat.app.backend.todo_service.dto.GradingResponse;
import com.suat.app.backend.todo_service.dto.PracticeRequest;
import com.suat.app.backend.todo_service.entity.PracticeGenerationTask;
import com.suat.app.backend.todo_service.service.AiPracticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/practice")
public class AiPracticeController {

    @Autowired
    private AiPracticeService aiPracticeService;

    /**
     * 1. 提交生成请求 (改为异步)
     * 返回: PracticeGenerationTask 对象 (状态为 PENDING)
     */
    @PostMapping("/generate")
    public ResponseEntity<PracticeGenerationTask> generate(
            @RequestBody PracticeRequest request,
            Authentication authentication
    ) {
        PracticeGenerationTask task = aiPracticeService.createGenerationTask(authentication.getName(), request);
        return ResponseEntity.ok(task);
    }

    /**
     * 2. 获取任务列表 (用于前端轮询状态)
     */
    @GetMapping("/tasks")
    public ResponseEntity<List<PracticeGenerationTask>> getTasks(Authentication authentication) {
        return ResponseEntity.ok(aiPracticeService.getUserTasks(authentication.getName()));
    }

    /**
     * 3. 提交判题 (保持同步)
     */
    @PostMapping("/grade")
    public ResponseEntity<GradingResponse> grade(@RequestBody GradingRequest request) {
        return ResponseEntity.ok(aiPracticeService.gradeAnswer(request));
    }

    /**
     * 4. 删除单个任务
     * DELETE /api/v1/practice/tasks/{id}
     */
    @DeleteMapping("/tasks/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id, Authentication authentication) {
        aiPracticeService.deleteTask(authentication.getName(), id);
        return ResponseEntity.ok().build();
    }

    /**
     * 5. 清空所有任务
     * DELETE /api/v1/practice/tasks
     */
    @DeleteMapping("/tasks")
    public ResponseEntity<Void> clearAllTasks(Authentication authentication) {
        aiPracticeService.clearAllTasks(authentication.getName());
        return ResponseEntity.ok().build();
    }


}