package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "project_step") // 表名叫 'project_step'
@Getter
@Setter
public class ProjectStep {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // 自动递增 ID
    private Long id;

    @Column(nullable = false)
    private String stepTitle; // "Step 1: 项目设置..."

    @Column(nullable = false)
    private int sortOrder; // 排序

    // "多个步骤 (Many)" 属于 "一个项目 (One)"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    // "一个步骤 (One)" 对应 "多个内容块 (Many)"
    @OneToMany(mappedBy = "step", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC") // 块也必须按顺序
    private List<ProjectContentBlock> contentBlocks;
}