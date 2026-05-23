package com.suat.app.backend.todo_service.dto;

public record UserProfileResponse(
        String username,
        String nickname,
        String avatarId
) {}