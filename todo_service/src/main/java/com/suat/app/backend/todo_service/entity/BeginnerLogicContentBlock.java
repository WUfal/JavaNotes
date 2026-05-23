package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "beginner_logic_content_block")
@Getter
@Setter
public class BeginnerLogicContentBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 关键：用于区分 "DESCRIPTION" (描述) 或 "STUB" (初始代码)
    @Column(nullable = false)
    private String category;

    @Column(nullable = false)
    private String type; // "text", "code"

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    private String language; // "java"

    @Column(nullable = false)
    private int sortOrder;

    // "多个内容块" 属于 "一个题目"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "problem_id", nullable = false)
    private BeginnerLogicProblem problem;
}