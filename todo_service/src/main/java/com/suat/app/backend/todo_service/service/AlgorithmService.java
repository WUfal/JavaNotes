package com.suat.app.backend.todo_service.service;

// 导入 DTO
import com.suat.app.backend.todo_service.dto.AlgorithmDetail;
import com.suat.app.backend.todo_service.dto.AlgorithmSummary;
import com.suat.app.backend.todo_service.dto.ContentBlock;

// 导入 Entity
import com.suat.app.backend.todo_service.entity.AlgorithmProblem;

// 导入 Repository
import com.suat.app.backend.todo_service.repository.AlgorithmProblemRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AlgorithmService {

    @Autowired
    private AlgorithmProblemRepository algorithmRepository;

    /**
     * API 1 的逻辑：获取所有算法列表
     */
    @Transactional(readOnly = true)
    public List<AlgorithmSummary> getAllAlgorithms() {
        // 1. 从数据库读取所有 Problem 实体
        List<AlgorithmProblem> entityProblems = algorithmRepository.findAll();

        // 2. 将 Entity 列表 转换为 DTO 列表
        return entityProblems.stream()
                .map(this::convertEntityToSummaryDto)
                .collect(Collectors.toList());
    }

    /**
     * API 2 的逻辑：获取单个算法详情
     */
    @Transactional(readOnly = true)
    public AlgorithmDetail getAlgorithmDetail(String problemId) {
        // 1. 从数据库获取 Entity
        AlgorithmProblem entityProblem = algorithmRepository.findById(problemId)
                .orElseThrow(() -> new RuntimeException("Algorithm not found with id: " + problemId));

        // 2. 将单个 Entity 转换为 DTO
        return convertEntityToDetailDto(entityProblem);
    }

    // --- 辅助转换方法 ---

    /**
     * 转换 [实体 AlgorithmProblem] -> [DTO AlgorithmSummary] (用于列表页)
     */
    private AlgorithmSummary convertEntityToSummaryDto(AlgorithmProblem entity) {
        return new AlgorithmSummary(
                entity.getId(),
                entity.getTitle(),
                entity.getDifficulty()
        );
    }

    /**
     * 转换 [实体 AlgorithmProblem] -> [DTO AlgorithmDetail] (用于详情页)
     */
    private AlgorithmDetail convertEntityToDetailDto(AlgorithmProblem entity) {

        // 关键逻辑：
        // 我们需要把一个 List<AlgorithmContentBlock> 拆分成两个 List<ContentBlock>

        // 1. 转换“题目描述”
        List<ContentBlock> descBlocks = entity.getContentBlocks().stream()
                .filter(block -> "DESCRIPTION".equals(block.getCategory())) // 过滤
                .map(this::convertBlockEntityToDto) // 转换
                .collect(Collectors.toList());

        // 2. 转换“题解”
        List<ContentBlock> solBlocks = entity.getContentBlocks().stream()
                .filter(block -> "SOLUTION".equals(block.getCategory())) // 过滤
                .map(this::convertBlockEntityToDto) // 转换
                .collect(Collectors.toList());

        return new AlgorithmDetail(
                entity.getId(),
                entity.getTitle(),
                entity.getDifficulty(),
                descBlocks,  // 传入“描述”列表
                solBlocks,    // 传入“题解”列表
                entity.getVisualizationUrl()
        );
    }

    /**
     * 转换 [实体 AlgorithmContentBlock] -> [DTO ContentBlock] (复用)
     */
    private ContentBlock convertBlockEntityToDto(com.suat.app.backend.todo_service.entity.AlgorithmContentBlock entity) {
        return new ContentBlock(
                entity.getType(),
                entity.getContent(),
                entity.getLanguage()
        );
    }
}