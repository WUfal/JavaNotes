package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.ModuleDetail;
import com.suat.app.backend.todo_service.entity.ModuleGroup;
import com.suat.app.backend.todo_service.service.CourseModuleService; // 1. 导入新 Service
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/modules")
public class CourseModuleController {

    // 2. 注入(Inject) Service，而不是 Repository
    @Autowired
    private CourseModuleService courseModuleService;

    /**
     * API 1: 获取所有模块分组 (已改造)
     * - 完全删除了硬编码数据
     * - 调用 Service 层获取数据
     */
    @GetMapping("/advanced")
    public List<com.suat.app.backend.todo_service.dto.ModuleGroup> getAdvancedModules() {
        // 3. 将工作委托给 Service
        return courseModuleService.getAdvancedModules();
    }

    /**
     * API 2: 获取单个模块的详细内容 (已改造)
     * - 完全删除了 switch 和硬编码
     * - 调用 Service 层获取数据
     */
    @GetMapping("/advanced/{moduleId}")
    public ResponseEntity<ModuleDetail> getModuleDetail(@PathVariable String moduleId) {
        try {
            // 4. 将工作委托给 Service
            ModuleDetail detail = courseModuleService.getModuleDetail(moduleId);
            return ResponseEntity.ok(detail); // 返回 200 OK 和数据
        } catch (RuntimeException e) {
            // 5. 如果 Service 抛出异常 (没找到)，则返回 404 Not Found
            return ResponseEntity.notFound().build();
        }
    }

    // 6. 所有硬编码的辅助方法 (createOopDetail, createCollectionsDetail 等)
    //    都已被删除！
}