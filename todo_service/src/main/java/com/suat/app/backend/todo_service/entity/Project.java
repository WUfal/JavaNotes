package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "project") // 表名叫 'project'
@Getter
@Setter
public class Project {

    @Id
    private String id; // e.g., "proj_ecommerce_api"

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private String techStack; // e.g., "Spring Boot, JPA"

    // "一个项目 (One)" 对应 "多个步骤 (Many)"
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC") // 步骤必须按顺序
    private List<ProjectStep> steps;
}