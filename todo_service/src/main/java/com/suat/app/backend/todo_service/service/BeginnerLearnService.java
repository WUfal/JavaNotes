package com.suat.app.backend.todo_service.service;

// 导入 A 路径的 DTO
import com.suat.app.backend.todo_service.dto.BeginnerLevelDto;
import com.suat.app.backend.todo_service.dto.BeginnerLessonSummary;
// 导入 B 路径可复用的 DTO
import com.suat.app.backend.todo_service.dto.ContentBlock;
import com.suat.app.backend.todo_service.dto.ModuleDetail; // 复用！

// 导入 A 路径的 Entity
import com.suat.app.backend.todo_service.entity.BeginnerLesson;
// 导入 A 路径的 Repository
import com.suat.app.backend.todo_service.repository.BeginnerLevelRepository;
import com.suat.app.backend.todo_service.repository.BeginnerLessonRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.BeginnerLessonProgress;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.repository.BeginnerLessonProgressRepository;
import com.suat.app.backend.todo_service.repository.UserBadgeRepository; // <--- 1. (新增)
import com.suat.app.backend.todo_service.service.BadgeService; // <--- 2. (新增)
import java.util.Set;
@Service
public class BeginnerLearnService {

    @Autowired
    private BeginnerLevelRepository levelRepository;

    @Autowired
    private BeginnerLessonRepository lessonRepository;

    @Autowired
    private BadgeService badgeService; // <--- 3. (新增) 注入 BadgeService

    @Autowired
    private UserBadgeRepository userBadgeRepository; // <--- 4. (新增) 注入 UserBadgeRepo (用于检查)
    /**
     * API 1 的逻辑：获取所有"大关卡"列表 (用于A路径学习首页)
     */
    @Transactional(readOnly = true)
    public List<BeginnerLevelDto> getAllLevels() {
        // 1. 从数据库读取所有 Level 实体 (已排序)
        List<com.suat.app.backend.todo_service.entity.BeginnerLevel> entityLevels =
                levelRepository.findByOrderBySortOrderAsc();

        // 2. 将 Entity 列表 转换为 DTO 列表
        return entityLevels.stream()
                .map(this::convertLevelEntityToDto)
                .collect(Collectors.toList());
    }

    /**
     * API 2 的逻辑：获取单个"小关卡"详情
     */
    @Transactional(readOnly = true)
    public ModuleDetail getLessonDetail(Long lessonId) {
        // 1. 从数据库获取 Lesson 实体
        BeginnerLesson entityLesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Lesson not found with id: " + lessonId));

        // 2. 将 Lesson Entity 转换为 ModuleDetail DTO (完美复用)
        return convertLessonEntityToDetailDto(entityLesson);
    }


    // --- 辅助转换方法 ---

    private BeginnerLevelDto convertLevelEntityToDto(com.suat.app.backend.todo_service.entity.BeginnerLevel entity) {
        // 转换其内部的 Lesson 列表
        List<BeginnerLessonSummary> dtoLessons = entity.getLessons().stream()
                .map(this::convertLessonEntityToSummaryDto)
                .collect(Collectors.toList());

        return new BeginnerLevelDto(entity.getId(), entity.getTitle(), dtoLessons);
    }

    private BeginnerLessonSummary convertLessonEntityToSummaryDto(BeginnerLesson entity) {
        return new BeginnerLessonSummary(entity.getId(), entity.getTitle());
    }

    // (关键复用)
    private ModuleDetail convertLessonEntityToDetailDto(BeginnerLesson entity) {
        // 转换其内部的 ContentBlock 列表
        List<ContentBlock> dtoBlocks = entity.getContentBlocks().stream()
                .map(this::convertBlockEntityToDto)
                .collect(Collectors.toList());

        // 我们用 lessonId.toString() 作为 DTO 的 id
        return new ModuleDetail(entity.getId().toString(), entity.getTitle(), dtoBlocks);
    }

    private ContentBlock convertBlockEntityToDto(com.suat.app.backend.todo_service.entity.BeginnerLessonContentBlock entity) {
        return new ContentBlock(
                entity.getType(),
                entity.getContent(),
                entity.getLanguage()
        );
    }
    @Autowired
    private BeginnerLessonProgressRepository progressRepository; // <--- (新增)
    @Autowired
    private AppUserRepository appUserRepository; // <--- (新增)
    // (新增一个辅助方法来获取当前用户)
    private AppUser getCurrentUser(String username) {
        return appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // (新增 API 3 - 标记完成)
    @Transactional
    public void markLessonAsComplete(String username, Long lessonId) {
        AppUser user = getCurrentUser(username);
        BeginnerLesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new RuntimeException("Lesson not found"));

        // --- ⬇️ (关键修复) ⬇️ ---
        // (我们不再检查 *任何* 徽章，而是检查 *特定* 徽章)
        final String badgeId = "FIRST_COMPLETION";
        boolean hasThisBadge = userBadgeRepository.existsByAppUserAndBadgeId(user, badgeId);
        // --- ⬆️ (修复结束) ⬆️ ---

        // (标记完成" 的逻辑 - 不变)
        if (!progressRepository.existsByAppUserAndLessonId(user, lessonId)) {
            BeginnerLessonProgress progress = new BeginnerLessonProgress();
            progress.setAppUser(user);
            progress.setLesson(lesson);
            progressRepository.save(progress);
        }

        // (授予徽章的逻辑 - 已修改)
        if (!hasThisBadge) {
            // (调用 BadgeService 来授予“初来乍到”徽章)
            badgeService.checkAndAwardBadge(user, badgeId);
        }
    }

    // (新增 API 4 - 获取进度)
    @Transactional(readOnly = true)
    public Set<Long> getCompletedLessonIds(String username) {
        AppUser user = getCurrentUser(username);
        return progressRepository.findAllCompletedLessonIdsByAppUser(user);
    }
}