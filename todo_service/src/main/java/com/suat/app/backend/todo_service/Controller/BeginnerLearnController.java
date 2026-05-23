package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.BeginnerLevelDto;
import com.suat.app.backend.todo_service.dto.ModuleDetail;
import com.suat.app.backend.todo_service.service.BeginnerLearnService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import org.springframework.security.core.Authentication;
import java.util.Set;
@RestController
@RequestMapping("/api/v1/beginner") // A 路径的 API 前缀
public class BeginnerLearnController {

    @Autowired
    private BeginnerLearnService beginnerLearnService;

    /**
     * API 1: 获取所有大关卡 (A路径学习首页)
     * (这个 API 会被 /api/v1/** 规则自动保护)
     */
    @GetMapping("/levels")
    public List<BeginnerLevelDto> getAllBeginnerLevels() {
        return beginnerLearnService.getAllLevels();
    }

    /**
     * API 2: 获取单个小关卡详情
     * (这个 API 也会被自动保护)
     */
    @GetMapping("/lesson/{lessonId}")
    public ResponseEntity<ModuleDetail> getLessonDetail(@PathVariable Long lessonId) {
        try {
            ModuleDetail detail = beginnerLearnService.getLessonDetail(lessonId);
            return ResponseEntity.ok(detail); // 返回 200 OK
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build(); // 404
        }
    }
    // (新增 API 3 - 标记完成)
    @PostMapping("/lesson/{lessonId}/complete")
    public ResponseEntity<Void> markLessonComplete(
            @PathVariable Long lessonId,
            Authentication authentication) { // <--- (获取当前登录的用户)

        try {
            String username = authentication.getName(); // (获取用户名)
            beginnerLearnService.markLessonAsComplete(username, lessonId);
            return ResponseEntity.ok().build(); // 返回 200 OK
        } catch (RuntimeException e) {
            // (如果用户或关卡未找到)
            return ResponseEntity.notFound().build();
        }
    }

    // (新增 API 4 - 获取进度)
    @GetMapping("/progress/ids")
    public Set<Long> getMyCompletedLessonIds(Authentication authentication) {
        return beginnerLearnService.getCompletedLessonIds(authentication.getName());
    }
}