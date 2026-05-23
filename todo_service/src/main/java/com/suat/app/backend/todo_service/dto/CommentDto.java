package com.suat.app.backend.todo_service.dto;

public record CommentDto(
        Long id,
        String username, // 显示是谁评论的
        String nickname, // <--- 新增
        String avatarId, // <--- 新增
        String content,
        String createdAt

) {}