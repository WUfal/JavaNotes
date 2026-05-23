package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.Instant;

@Entity
@Table(name = "beginner_lesson_progress", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"app_user_id", "beginner_lesson_id"})
})
@Getter
@Setter
public class BeginnerLessonProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "app_user_id", nullable = false)
    private AppUser appUser;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beginner_lesson_id", nullable = false)
    private BeginnerLesson lesson;

    @Column(name = "completed_at", nullable = false)
    private Instant completedAt;

    @PrePersist // (在保存前自动设置时间)
    protected void onCreate() {
        completedAt = Instant.now();
    }
}