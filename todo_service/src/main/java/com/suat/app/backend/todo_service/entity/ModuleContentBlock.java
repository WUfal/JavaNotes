package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "module_content_block")
@Getter
@Setter
public class ModuleContentBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type; // "text", "code", "sub-header"

    @Column(columnDefinition = "TEXT", nullable = false) // 内容必须是长文本且不能为空
    private String content;

    private String language; // "java", "xml", etc. (可以为空)

    @Column(nullable = false)
    private int sortOrder; // 排序

    // 关键：“多对一”关系
    // "多个内容块 (Many)" 属于 "一个课程模块 (One)"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "module_id", nullable = false) // 外键列
    private CourseModule module;
}