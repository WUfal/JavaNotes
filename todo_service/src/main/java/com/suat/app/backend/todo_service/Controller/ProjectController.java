package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.ProjectDetail;
import com.suat.app.backend.todo_service.dto.ProjectSummary;
import com.suat.app.backend.todo_service.service.ProjectService; // 1. 导入新 Service
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/projects") // 项目API的统一前缀
public class ProjectController {

    // 2. 注入(Inject) Service
    @Autowired
    private ProjectService projectService;

    /**
     * API 1: 获取所有项目的摘要列表 (已改造)
     */
    @GetMapping
    public List<ProjectSummary> getAllProjects() {
        // 3. 调用 Service
        return projectService.getAllProjects();
    }

    /**
     * API 2: 获取单个项目的详细步骤 (已改造)
     */
    @GetMapping("/{projectId}")
    public ResponseEntity<ProjectDetail> getProjectDetail(@PathVariable String projectId) {
        try {
            // 4. 调用 Service
            ProjectDetail detail = projectService.getProjectDetail(projectId);
            return ResponseEntity.ok(detail); // 返回 200 OK
        } catch (RuntimeException e) {
            // 5. 没找到则返回 404
            return ResponseEntity.notFound().build();
        }
    }

    // 6. 所有硬编码的辅助方法 (createEcommerceProject 等)
    //    都已被删除！
}