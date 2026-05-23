package com.suat.app.backend.todo_service.service;

// 导入我们需要的 DTO
import com.suat.app.backend.todo_service.dto.ContentBlock;
import com.suat.app.backend.todo_service.dto.ProjectDetail;
import com.suat.app.backend.todo_service.dto.ProjectStep;
import com.suat.app.backend.todo_service.dto.ProjectSummary;

// 导入我们需要的 Entity
import com.suat.app.backend.todo_service.entity.Project;

// 导入 Repository
import com.suat.app.backend.todo_service.repository.ProjectRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProjectService {

    @Autowired
    private ProjectRepository projectRepository;

    /**
     * API 1 的逻辑：获取所有项目列表
     */
    @Transactional(readOnly = true)
    public List<ProjectSummary> getAllProjects() {
        // --- ⬇️ (关键修改) ⬇️ ---
        // 1. 从数据库读取所有 Project 实体 (使用我们新的 JPQL 查询)
        List<Project> entityProjects = projectRepository.findAllWithSteps();
        // (旧: projectRepository.findAll();)
        // --- ⬆️ (修改结束) ⬆️ ---

        // 2. 将 Entity 列表 转换为 DTO 列表
        return entityProjects.stream()
                .map(this::convertEntityToSummaryDto)
                .collect(Collectors.toList());
    }

    /**
     * API 2 的逻辑：获取单个项目详情
     */
    @Transactional(readOnly = true)
    public ProjectDetail getProjectDetail(String projectId) {
        // 1. 从数据库获取 Entity
        Project entityProject = projectRepository.findById(projectId)
                .orElseThrow(() -> new RuntimeException("Project not found with id: " + projectId));

        // 2. 将单个 Entity 转换为 DTO
        return convertEntityToDetailDto(entityProject);
    }

    // --- 辅助转换方法 ---

    /**
     * 转换 [实体 Project] -> [DTO ProjectSummary] (用于列表页)
     */
    private ProjectSummary convertEntityToSummaryDto(Project entity) {
        return new ProjectSummary(
                entity.getId(),
                entity.getTitle(),
                entity.getDescription(),
                entity.getTechStack()
        );
    }

    /**
     * 转换 [实体 Project] -> [DTO ProjectDetail] (用于详情页)
     */
    private ProjectDetail convertEntityToDetailDto(Project entity) {
        // 转换其内部的 ProjectStep 列表
        List<ProjectStep> dtoSteps = entity.getSteps().stream()
                .map(this::convertStepEntityToDto)
                .collect(Collectors.toList());

        return new ProjectDetail(
                entity.getId(),
                entity.getTitle(),
                entity.getDescription(),
                dtoSteps
        );
    }

    /**
     * 转换 [实体 ProjectStep] -> [DTO ProjectStep]
     */
    private ProjectStep convertStepEntityToDto(com.suat.app.backend.todo_service.entity.ProjectStep entity) {
        // 转换其内部的 ProjectContentBlock 列表
        List<ContentBlock> dtoBlocks = entity.getContentBlocks().stream()
                .map(this::convertBlockEntityToDto)
                .collect(Collectors.toList());

        return new ProjectStep(entity.getStepTitle(), dtoBlocks);
    }

    /**
     * 转换 [实体 ProjectContentBlock] -> [DTO ContentBlock] (复用)
     */
    private ContentBlock convertBlockEntityToDto(com.suat.app.backend.todo_service.entity.ProjectContentBlock entity) {
        return new ContentBlock(
                entity.getType(),
                entity.getContent(),
                entity.getLanguage()
        );
    }
}