package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.PracticeGenerationTask;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PracticeTaskRepository extends JpaRepository<PracticeGenerationTask, Long> {

    // 获取用户的所有任务 (按时间倒序)
    List<PracticeGenerationTask> findByAppUserOrderByCreatedAtDesc(AppUser appUser);

    // (关键) 检查用户是否有状态为 PENDING 的任务
    // 用于阻止重复提交
    boolean existsByAppUserAndStatus(AppUser appUser, String status);

    // 1. 统计用户任务数量
    long countByAppUser(AppUser appUser);

    // 2. 删除用户的所有任务
    void deleteByAppUser(AppUser appUser);
}