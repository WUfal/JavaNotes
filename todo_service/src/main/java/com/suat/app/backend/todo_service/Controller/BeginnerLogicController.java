package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.BeginnerLogicProblemDetail;
import com.suat.app.backend.todo_service.dto.BeginnerLogicProblemSummary;
import com.suat.app.backend.todo_service.service.BeginnerLogicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/beginner/logic") // A 路径的编程逻辑 API 前缀
public class BeginnerLogicController {

    @Autowired
    private BeginnerLogicService beginnerLogicService;

    /**
     * API 1: 获取所有编程逻辑题
     * (这个 API 会被 /api/v1/** 规则自动保护)
     */
    @GetMapping("/problems")
    public List<BeginnerLogicProblemSummary> getAllLogicProblems() {
        return beginnerLogicService.getLogicProblems();
    }

    /**
     * API 2: 获取单个编程逻辑题详情
     */
    @GetMapping("/problem/{problemId}")
    public ResponseEntity<BeginnerLogicProblemDetail> getLogicProblemDetail(@PathVariable Long problemId) {
        try {
            BeginnerLogicProblemDetail detail = beginnerLogicService.getLogicProblemDetail(problemId);
            return ResponseEntity.ok(detail);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}