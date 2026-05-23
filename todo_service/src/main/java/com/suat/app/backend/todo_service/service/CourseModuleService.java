package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.dto.ModuleGroup;
import com.suat.app.backend.todo_service.dto.ContentBlock;
import com.suat.app.backend.todo_service.dto.ModuleDetail;
import com.suat.app.backend.todo_service.dto.ModuleItem;
import com.suat.app.backend.todo_service.entity.CourseModule;
import com.suat.app.backend.todo_service.entity.ModuleContentBlock;
import com.suat.app.backend.todo_service.repository.CourseModuleRepository;
import com.suat.app.backend.todo_service.repository.ModuleGroupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service // 告诉 Spring 这是一个服务 Bean
public class CourseModuleService {

    // 1. 注入(Inject) Repositories
    @Autowired
    private ModuleGroupRepository groupRepository;

    @Autowired
    private CourseModuleRepository moduleRepository;

    /**
     * API 1 的逻辑：获取所有模块分组
     * @Transactional(readOnly = true) 是一个优化，告诉 JPA 这是一个只读操作
     */
    
    @Transactional(readOnly = true)
    public List<com.suat.app.backend.todo_service.dto.ModuleGroup> getAdvancedModules() {
        // 1. 从数据库中获取所有 Entity 实体，并按 sortOrder 排序
        List<com.suat.app.backend.todo_service.entity.ModuleGroup> entityGroups =
                groupRepository.findByOrderBySortOrderAsc();

        // 2. 将 Entity 列表 转换为 DTO 列表
        return entityGroups.stream()
                .map(this::convertGroupEntityToDto) // 使用辅助方法进行转换
                .collect(Collectors.toList());
    }

    /**
     * API 2 的逻辑：获取单个模块详情
     */
    @Transactional(readOnly = true)
    public ModuleDetail getModuleDetail(String moduleId) {
        // 1. 从数据库获取 Entity (它返回一个 Optional)
        // 我们使用 .orElseThrow() 在找不到时抛出异常
        CourseModule entityModule = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not found with id: " + moduleId));

        // 2. 将单个 Entity 转换为 DTO
        return convertModuleEntityToDetailDto(entityModule);
    }


    // --- 辅助转换方法 ---

    /**
     * 转换 [实体 ModuleGroup] -> [DTO ModuleGroup]
     */
    private ModuleGroup convertGroupEntityToDto(com.suat.app.backend.todo_service.entity.ModuleGroup entity) {
        // 转换其内部的 CourseModule 列表
        List<ModuleItem> dtoItems = entity.getModules().stream()
                .map(this::convertModuleEntityToItemDto)
                .collect(Collectors.toList());

        return new ModuleGroup(entity.getTitle(), dtoItems);
    }

    /**
     * 转换 [实体 CourseModule] -> [DTO ModuleItem] (用于列表页)
     */
    private ModuleItem convertModuleEntityToItemDto(CourseModule entity) {
        return new ModuleItem(entity.getId(), entity.getTitle(), entity.getDescription());
    }

    /**
     * 转换 [实体 CourseModule] -> [DTO ModuleDetail] (用于详情页)
     */
    private ModuleDetail convertModuleEntityToDetailDto(CourseModule entity) {
        // 转换其内部的 ContentBlock 列表
        List<ContentBlock> dtoBlocks = entity.getContentBlocks().stream()
                .map(this::convertBlockEntityToDto)
                .collect(Collectors.toList());

        return new ModuleDetail(entity.getId(), entity.getTitle(), dtoBlocks);
    }

    /**
     * 转换 [实体 ModuleContentBlock] -> [DTO ContentBlock]
     */
    private ContentBlock convertBlockEntityToDto(ModuleContentBlock entity) {
        return new ContentBlock(entity.getType(), entity.getContent(), entity.getLanguage());
    }
}