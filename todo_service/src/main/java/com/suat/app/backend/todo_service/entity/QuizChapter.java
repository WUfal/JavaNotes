package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "quiz_chapter")
@Getter
@Setter
public class QuizChapter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title; // "第1关：变量与数据类型 (测验)"

    @Column(nullable = false)
    private int sortOrder; // 排序

    // "一个章节" 包含 "多个问题"
    @OneToMany(mappedBy = "chapter", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("id ASC")
    private List<QuizQuestion> questions;
}