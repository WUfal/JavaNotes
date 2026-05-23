package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "beginner_lesson_content_block")
@Getter
@Setter
public class BeginnerLessonContentBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type; // "text", "code", "sub-header"

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    private String language; // "java"

    @Column(nullable = false)
    private int sortOrder;

    // "多个内容块" 属于 "一个小关卡"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    private BeginnerLesson lesson;
}