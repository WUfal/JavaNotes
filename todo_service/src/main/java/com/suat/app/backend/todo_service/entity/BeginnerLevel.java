package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "beginner_level")
@Getter
@Setter
public class BeginnerLevel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title; // "第1关：变量与数据类型"

    @Column(nullable = false)
    private int sortOrder; // 排序

    // "一个大关卡" 包含 "多个小关卡"
    @OneToMany(mappedBy = "level", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC")
    private List<BeginnerLesson> lessons;
}