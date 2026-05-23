package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    // 查找某个目标的所有评论，按时间倒序（最新的在前面）
    List<Comment> findByTargetTypeAndTargetIdOrderByCreatedAtDesc(String targetType, String targetId);
}