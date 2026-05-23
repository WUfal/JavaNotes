package com.suat.app.backend.todo_service.dto;

import com.suat.app.backend.todo_service.entity.Bookmark;

public record BookmarkDto(
        Long id,
        String type,
        String bookmarkedId,
        String title,
        String createdAt
) {
    public static BookmarkDto fromEntity(Bookmark entity) {
        return new BookmarkDto(
                entity.getId(),
                entity.getBookmarkType(),
                entity.getBookmarkedId(),
                entity.getTitle(),
                entity.getCreatedAt().toString()
        );
    }
}