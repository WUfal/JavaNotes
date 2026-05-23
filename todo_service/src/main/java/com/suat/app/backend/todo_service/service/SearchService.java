package com.suat.app.backend.todo_service.service;

// 1. 导入 DTO 和 Repositories
import com.suat.app.backend.todo_service.dto.SearchResultDto;
import com.suat.app.backend.todo_service.entity.AlgorithmProblem;
import com.suat.app.backend.todo_service.entity.CourseModule;
import com.suat.app.backend.todo_service.entity.Project;
import com.suat.app.backend.todo_service.repository.AlgorithmProblemRepository;
import com.suat.app.backend.todo_service.repository.CourseModuleRepository;
import com.suat.app.backend.todo_service.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SearchService {

    // 2. 注入所有三个内容仓库
    @Autowired
    private CourseModuleRepository courseModuleRepository;

    @Autowired
    private ProjectRepository projectRepository;

    @Autowired
    private AlgorithmProblemRepository algorithmRepository;

    /**
     * 核心：执行全局搜索
     * @param query 用户的搜索词 (e.g., "java", "spring")
     * @return 一个统一的 SearchResultDto 列表
     */
    @Transactional(readOnly = true)
    public List<SearchResultDto> search(String query) {

        // 3. (A) 搜索“课程模块”
        List<CourseModule> modules = courseModuleRepository
                .findByTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(query, query);

        // 4. (B) 搜索“项目”
        List<Project> projects = projectRepository
                .findByTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(query, query);

        // 5. (C) 搜索“算法”
        List<AlgorithmProblem> algorithms = algorithmRepository
                .findByTitleContainingIgnoreCase(query);

        // 6. (关键) 将所有不同类型的结果，*转换* 并 *合并* 到一个列表中

        List<SearchResultDto> moduleResults = modules.stream()
                .map(this::convertModuleToSearchDto)
                .collect(Collectors.toList());

        List<SearchResultDto> projectResults = projects.stream()
                .map(this::convertProjectToSearchDto)
                .collect(Collectors.toList());

        List<SearchResultDto> algorithmResults = algorithms.stream()
                .map(this::convertAlgorithmToSearchDto)
                .collect(Collectors.toList());

        // 7. 合并所有列表
        List<SearchResultDto> results = new ArrayList<>();
        results.addAll(moduleResults);
        results.addAll(projectResults);
        results.addAll(algorithmResults);

        // (TODO: 我们可以稍后在这里添加“按相关性排序”的逻辑)

        return results;
    }


    // --- 辅助转换方法 ---

    private SearchResultDto convertModuleToSearchDto(CourseModule entity) {
        return new SearchResultDto(
                entity.getId(),
                entity.getTitle(),
                entity.getDescription(), // (使用描述作为摘要)
                "COURSE_MODULE"          // (类型)
        );
    }

    private SearchResultDto convertProjectToSearchDto(Project entity) {
        return new SearchResultDto(
                entity.getId(),
                entity.getTitle(),
                entity.getDescription(), // (使用描述作为摘要)
                "PROJECT"                // (类型)
        );
    }

    private SearchResultDto convertAlgorithmToSearchDto(AlgorithmProblem entity) {
        return new SearchResultDto(
                entity.getId(),
                entity.getTitle(),
                entity.getDifficulty(), // (使用“难度”作为摘要)
                "ALGORITHM"             // (类型)
        );
    }
}