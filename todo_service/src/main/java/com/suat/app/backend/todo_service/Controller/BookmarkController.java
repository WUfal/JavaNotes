package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.BookmarkDto;
import com.suat.app.backend.todo_service.dto.BookmarkRequest;
import com.suat.app.backend.todo_service.service.BookmarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/bookmarks") // (受 /api/v1/** 保护)
public class BookmarkController {

    @Autowired
    private BookmarkService bookmarkService;

    // (辅助方法：获取当前用户名)
    private String getUsername(Authentication authentication) {
        return authentication.getName();
    }

    /**
     * API 1: 获取当前用户的所有收藏
     */
    @GetMapping
    public List<BookmarkDto> getMyBookmarks(Authentication authentication) {
        return bookmarkService.getBookmarks(getUsername(authentication));
    }

    /**
     * API 2: 添加一个新收藏
     */
    @PostMapping
    public BookmarkDto addBookmark(@RequestBody BookmarkRequest request, Authentication authentication) {
        return bookmarkService.addBookmark(getUsername(authentication), request);
    }

    /**
     * API 3: 删除一个收藏
     * (我们使用 Query Parameters, e.g., /api/v1/bookmarks?type=COURSE_MODULE&id=core_oop)
     */
    @DeleteMapping
    public ResponseEntity<Void> removeBookmark(
            @RequestParam String type,
            @RequestParam String id,
            Authentication authentication) {

        bookmarkService.removeBookmark(getUsername(authentication), type, id);
        return ResponseEntity.noContent().build(); // 返回 204 No Content
    }
}