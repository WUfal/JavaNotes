package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "algorithm_problem") // 表名叫 'algorithm_problem'
@Getter
@Setter
public class AlgorithmProblem {

    @Id
    private String id; // e.g., "algo_two_sum"

    @Column(nullable = false)
    private String title; // "两数之和"

    @Column(nullable = false)
    private String difficulty; // "Easy", "Medium", "Hard"

    // "一个题目 (One)" 对应 "多个内容块 (Many)"
    @OneToMany(mappedBy = "problem", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC") // 内容块必须按顺序
    private List<AlgorithmContentBlock> contentBlocks;

    @Column(name = "visualization_url") // 对应数据库的 visualization_url 列
    private String visualizationUrl;
}