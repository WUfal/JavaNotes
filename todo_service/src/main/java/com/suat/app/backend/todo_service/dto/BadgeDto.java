package com.suat.app.backend.todo_service.dto;

import com.suat.app.backend.todo_service.entity.Badge;
import com.suat.app.backend.todo_service.entity.UserBadge;

// (这个 DTO 用于向前端显示“已获得”的徽章)
public record BadgeDto(
        String id,
        String title,
        String description,
        String iconName,
        String earnedAt // (获得时间)
) {
    // 辅助方法：从 UserBadge 实体转换
    public static BadgeDto fromEntity(UserBadge entity) {
        Badge badge = entity.getBadge();
        return new BadgeDto(
                badge.getId(),
                badge.getTitle(),
                badge.getDescription(),
                badge.getIconName(),
                entity.getEarnedAt().toString()
        );
    }
}