package com.suat.app.backend.todo_service.repository;


import com.suat.app.backend.todo_service.entity.CourseModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseModuleRepository extends JpaRepository<CourseModule, String> {
    // 暂时不需要自定义查询方法，JpaRepository 自带的
    // findById(String id) 已经够用了。
    List<CourseModule> findByTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String title, String description);
}