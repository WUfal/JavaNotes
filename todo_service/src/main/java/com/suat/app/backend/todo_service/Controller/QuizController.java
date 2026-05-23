package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.*;
import com.suat.app.backend.todo_service.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import java.util.List;
import com.suat.app.backend.todo_service.dto.QuizMistakeChapterDto; // <--- (新增)
import java.util.Set;
@RestController
@RequestMapping("/api/v1/quiz") // A 路径的测验 API 前缀
public class QuizController {

    @Autowired
    private QuizService quizService;

    /**
     * API 1: 获取所有测验章节
     * (这个 API 会被 /api/v1/** 规则自动保护)
     */
    @GetMapping("/chapters")
    public List<QuizChapterSummary> getAllQuizChapters() {
        return quizService.getQuizChapters();
    }

    /**
     * API 2: 获取单个章节的所有问题
     */
    @GetMapping("/chapter/{chapterId}")
    public ResponseEntity<List<QuizQuestionDto>> getQuizQuestions(@PathVariable Long chapterId) {
        try {
            List<QuizQuestionDto> questions = quizService.getQuizQuestions(chapterId);
            return ResponseEntity.ok(questions);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * API 3: 提交测验答案
     */
    @PostMapping("/chapter/{chapterId}/submit")
    public ResponseEntity<QuizResultResponse> submitQuiz(
            @PathVariable Long chapterId,
            @RequestBody QuizResultRequest resultRequest,
            Authentication authentication // <--- 1. (新增) 获取当前登录的用户
    ) {
        try {
            // 2. (新增) 获取用户名
            String username = authentication.getName();

            // 3. (修改) 将 username 传入 Service
            QuizResultResponse response = quizService.submitQuiz(chapterId, resultRequest, username);

            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    /**
     * API 4 (新增): 获取当前用户的所有错题
     */
    @GetMapping("/mistakes")
    public List<QuizMistakeChapterDto> getMyMistakes(Authentication authentication) { // <--- (修改返回类型)
        return quizService.getMistakes(authentication.getName());
    }
}