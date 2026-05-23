package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "badge")
@Getter
@Setter
public class Badge {

    @Id
    private String id; // e.g., "FIRST_COMPLETION", "QUIZ_MASTER"

    @Column(nullable = false, unique = true)
    private String title; // "初来乍到"

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description; // "完成了你的第一个 A 路径关卡"

    @Column(nullable = false)
    private String iconName; // (用于 Flutter 映射, e.g., "star")
}