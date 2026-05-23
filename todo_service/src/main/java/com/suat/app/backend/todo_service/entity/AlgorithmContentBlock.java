package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "algorithm_content_block") // 表名叫 'algorithm_content_block'
@Getter
@Setter
public class AlgorithmContentBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 关键：这个字段用于区分 "题目描述" 还是 "题解"
    // (我们将用 "DESCRIPTION" 或 "SOLUTION" 字符串)
    @Column(nullable = false)
    private String category;

    @Column(nullable = false)
    private String type; // "text", "code", "sub-header"

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    private String language; // "java", "plaintext", etc.

    @Column(nullable = false)
    private int sortOrder; // 在各自类别内的排序

    // "多个内容块 (Many)" 属于 "一个题目 (One)"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "problem_id", nullable = false)
    private AlgorithmProblem problem;
}