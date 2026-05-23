package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "beginner_lesson")
@Getter
@Setter
public class BeginnerLesson {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title; // "1.1 什么是变量"

    @Column(nullable = false)
    private int sortOrder;

    // "多个小关卡" 属于 "一个大关卡"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "level_id", nullable = false)
    private BeginnerLevel level;

    // "一个小关卡" 包含 "多个内容块"
    @OneToMany(mappedBy = "lesson", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC")
    private List<BeginnerLessonContentBlock> contentBlocks;
}