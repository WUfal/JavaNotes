package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "project_content_block") // 表名叫 'project_content_block'
@Getter
@Setter
public class ProjectContentBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type; // "text", "code", "sub-header"

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    private String language; // "java", "xml", etc.

    @Column(nullable = false)
    private int sortOrder;

    // "多个内容块 (Many)" 属于 "一个步骤 (One)"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "step_id", nullable = false)
    private ProjectStep step;
}