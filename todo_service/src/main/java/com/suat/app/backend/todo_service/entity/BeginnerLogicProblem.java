package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "beginner_logic_problem")
@Getter
@Setter
public class BeginnerLogicProblem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title; // "P1. 打印九九乘法表"

    @Column(nullable = false)
    private int sortOrder; // 排序

    // "一个题目" 包含 "多个内容块" (用于 题目描述, 提示, 初始代码)
    @OneToMany(mappedBy = "problem", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC")
    private List<BeginnerLogicContentBlock> contentBlocks;
}