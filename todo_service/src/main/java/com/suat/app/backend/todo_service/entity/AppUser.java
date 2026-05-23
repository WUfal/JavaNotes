package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "app_user") // 表名叫 'app_user' (避免和PostgreSQL的 'user' 关键字冲突)
@Getter
@Setter
public class AppUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false) // 用户名必须唯一
    private String username;

    @Column(nullable = false)
    private String password; // 我们将存储加密后的密码

    @Column(name = "selected_path")
    private String selectedPath;
    // 我们可以稍后在这里添加 'role' (角色) 等字段
    @Column(length = 50)
    private String nickname;

    @Column(name = "avatar_id", length = 50)
    private String avatarId;
}