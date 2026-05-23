package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.dto.BookmarkDto;
import com.suat.app.backend.todo_service.dto.BookmarkRequest;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.Bookmark;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.repository.BookmarkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class BookmarkService {

    @Autowired
    private BookmarkRepository bookmarkRepository;

    @Autowired
    private AppUserRepository appUserRepository;

    // (辅助方法：从 SecurityContext 获取当前用户)
    private AppUser getCurrentUser(String username) {
        return appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Transactional(readOnly = true)
    public List<BookmarkDto> getBookmarks(String username) {
        AppUser user = getCurrentUser(username);
        return bookmarkRepository.findByAppUserOrderByCreatedAtDesc(user)
                .stream()
                .map(BookmarkDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public BookmarkDto addBookmark(String username, BookmarkRequest request) {
        AppUser user = getCurrentUser(username);

        // (检查是否已存在)
        if (bookmarkRepository.findByAppUserAndBookmarkTypeAndBookmarkedId(user, request.type(), request.id()).isPresent()) {
            throw new RuntimeException("Already bookmarked");
        }

        Bookmark bookmark = new Bookmark();
        bookmark.setAppUser(user);
        bookmark.setBookmarkType(request.type());
        bookmark.setBookmarkedId(request.id());
        bookmark.setTitle(request.title()); // (保存标题)

        Bookmark savedBookmark = bookmarkRepository.save(bookmark);
        return BookmarkDto.fromEntity(savedBookmark);
    }

    @Transactional
    public void removeBookmark(String username, String type, String id) {
        AppUser user = getCurrentUser(username);

        // 找到这个收藏
        Bookmark bookmark = bookmarkRepository.findByAppUserAndBookmarkTypeAndBookmarkedId(user, type, id)
                .orElseThrow(() -> new RuntimeException("Bookmark not found"));

        // 删除
        bookmarkRepository.delete(bookmark);
    }
}