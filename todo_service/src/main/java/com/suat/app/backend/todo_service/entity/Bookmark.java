package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.Instant;

@Entity
@Table(name = "bookmark", uniqueConstraints = {
        // (添加唯一约束，防止同一用户重复收藏同一条目)
        @UniqueConstraint(columnNames = {"app_user_id", "bookmark_type", "bookmarked_id"})
})
@Getter
@Setter
public class Bookmark {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // "多个收藏" 属于 "一个用户"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "app_user_id", nullable = false)
    private AppUser appUser;

    // 收藏的类型 (e.g., "COURSE_MODULE", "PROJECT", "ALGORITHM")
    @Column(name = "bookmark_type", nullable = false)
    private String bookmarkType;

    // 收藏的条目 ID (e.g., "core_oop", "proj_ecommerce_api", "algo_two_sum")
    @Column(name = "bookmarked_id", nullable = false)
    private String bookmarkedId;

    // (新增) 我们把条目的标题也存一份，方便前端读取
    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @PrePersist // (在保存前自动设置时间)
    protected void onCreate() {
        createdAt = Instant.now();
    }
}