package com.suat.app.backend.todo_service.service;

// 导入 DTOs
import com.suat.app.backend.todo_service.dto.BeginnerLogicProblemDetail;
import com.suat.app.backend.todo_service.dto.BeginnerLogicProblemSummary;
import com.suat.app.backend.todo_service.dto.ContentBlock; // 复用

// 导入 Entities
import com.suat.app.backend.todo_service.entity.BeginnerLogicContentBlock;
import com.suat.app.backend.todo_service.entity.BeginnerLogicProblem;

// 导入 Repositories
import com.suat.app.backend.todo_service.repository.BeginnerLogicProblemRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class BeginnerLogicService {

    @Autowired
    private BeginnerLogicProblemRepository problemRepository;

    /**
     * API 1 的逻辑：获取所有"编程逻辑题"列表
     */
    @Transactional(readOnly = true)
    public List<BeginnerLogicProblemSummary> getLogicProblems() {
        return problemRepository.findByOrderBySortOrderAsc().stream()
                .map(this::convertEntityToSummaryDto)
                .collect(Collectors.toList());
    }

    /**
     * API 2 的逻辑：获取单个"编程逻辑题"详情
     */
    @Transactional(readOnly = true)
    public BeginnerLogicProblemDetail getLogicProblemDetail(Long problemId) {
        BeginnerLogicProblem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new RuntimeException("Logic problem not found"));

        // 1. 转换"题目描述" (CATEGORY = "DESCRIPTION")
        List<ContentBlock> descBlocks = problem.getContentBlocks().stream()
                .filter(block -> "DESCRIPTION".equals(block.getCategory()))
                .map(this::convertBlockEntityToDto)
                .collect(Collectors.toList());

        // 2. 转换"初始代码" (CATEGORY = "STUB")
        String codeStub = problem.getContentBlocks().stream()
                .filter(block -> "STUB".equals(block.getCategory()))
                .map(BeginnerLogicContentBlock::getContent)
                .findFirst() // 假设只有一个 STUB
                .orElse("public class Solution {\n    // No stub found\n}");

        return new BeginnerLogicProblemDetail(
                problem.getId(),
                problem.getTitle(),
                descBlocks,
                codeStub
        );
    }

    // --- 辅助转换方法 ---

    private BeginnerLogicProblemSummary convertEntityToSummaryDto(BeginnerLogicProblem entity) {
        return new BeginnerLogicProblemSummary(entity.getId(), entity.getTitle());
    }

    private ContentBlock convertBlockEntityToDto(BeginnerLogicContentBlock entity) {
        return new ContentBlock(
                entity.getType(),
                entity.getContent(),
                entity.getLanguage()
        );
    }
}