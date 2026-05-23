package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.Bookmark;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookmarkRepository extends JpaRepository<Bookmark, Long> {

    // 查找一个用户的所有收藏，按时间倒序
    List<Bookmark> findByAppUserOrderByCreatedAtDesc(AppUser appUser);

    // 查找一个特定的收藏（用于删除）
    Optional<Bookmark> findByAppUserAndBookmarkTypeAndBookmarkedId(AppUser appUser, String bookmarkType, String bookmarkedId);
}