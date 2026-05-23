package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.CommentDto;
import com.suat.app.backend.todo_service.dto.CommentRequest;
import com.suat.app.backend.todo_service.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/comments")
public class CommentController {

    @Autowired
    private CommentService commentService;

    // 获取评论
    // GET /api/v1/comments?type=PROJECT&id=proj_chat_app
    @GetMapping
    public List<CommentDto> getComments(
            @RequestParam("type") String targetType,
            @RequestParam("id") String targetId) {
        return commentService.getComments(targetType, targetId);
    }

    // 发布评论
    @PostMapping
    public ResponseEntity<CommentDto> postComment(
            @RequestBody CommentRequest request,
            Authentication authentication) {

        CommentDto newComment = commentService.postComment(authentication.getName(), request);
        return ResponseEntity.ok(newComment);
    }
}