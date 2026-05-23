package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.Instant;

@Entity
@Table(name = "comment")
@Getter
@Setter
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 评论者
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "app_user_id", nullable = false)
    private AppUser appUser;

    // 评论内容
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    // 目标类型 (e.g., "PROJECT", "ALGORITHM", "COURSE_MODULE", "BEGINNER_LESSON")
    @Column(name = "target_type", nullable = false)
    private String targetType;

    // 目标 ID (为了兼容 A 路径的数字 ID 和 B 路径的字符串 ID，我们统一存为 String)
    @Column(name = "target_id", nullable = false)
    private String targetId;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
    }
}