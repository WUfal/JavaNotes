package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.dto.CommentDto;
import com.suat.app.backend.todo_service.dto.CommentRequest;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.Comment;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CommentService {

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private AppUserRepository appUserRepository;

    private AppUser getCurrentUser(String username) {
        return appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // 获取评论列表
    @Transactional(readOnly = true)
    public List<CommentDto> getComments(String targetType, String targetId) {
        return commentRepository.findByTargetTypeAndTargetIdOrderByCreatedAtDesc(targetType, targetId)
                .stream()
                .map(c -> new CommentDto(
                        c.getId(),
                        c.getAppUser().getUsername(),
                        // 如果昵称为空，这就回退显示用户名
                        c.getAppUser().getNickname() != null ? c.getAppUser().getNickname() : c.getAppUser().getUsername(),
                        // 如果头像为空，显示默认
                        c.getAppUser().getAvatarId() != null ? c.getAppUser().getAvatarId() : "default",
                        c.getContent(),
                        c.getCreatedAt().toString()
                ))
                .collect(Collectors.toList());
    }

    // 发布评论
    @Transactional
    public CommentDto postComment(String username, CommentRequest request) {
        AppUser user = getCurrentUser(username);

        Comment comment = new Comment();
        comment.setAppUser(user);
        comment.setTargetType(request.targetType());
        comment.setTargetId(request.targetId());
        comment.setContent(request.content());

        Comment saved = commentRepository.save(comment);

        return new CommentDto(
                saved.getId(),
                user.getUsername(),
                saved.getContent(),
                saved.getCreatedAt().toString(),
                user.getAvatarId(),
                user.getNickname()
        );
    }
}