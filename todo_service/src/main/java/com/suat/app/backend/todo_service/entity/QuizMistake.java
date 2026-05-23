package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.Instant;

@Entity
@Table(name = "quiz_mistake", uniqueConstraints = {
        // (一个用户对一道题只记录一条错题记录)
        @UniqueConstraint(columnNames = {"app_user_id", "quiz_question_id"})
})
@Getter
@Setter
public class QuizMistake {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // "多个错题" 属于 "一个用户"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "app_user_id", nullable = false)
    private AppUser appUser;

    // "多个错题" (不同用户的) 属于 "一个问题"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_question_id", nullable = false)
    private QuizQuestion question;

    @Column(name = "last_answered_at", nullable = false)
    private Instant lastAnsweredAt;

    @PrePersist // (在保存前)
    @PreUpdate // (在更新前)
    protected void onSaveOrUpdate() {
        lastAnsweredAt = Instant.now();
    }
}