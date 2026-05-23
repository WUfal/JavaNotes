package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.BeginnerLessonProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public interface BeginnerLessonProgressRepository extends JpaRepository<BeginnerLessonProgress, Long> {

    // (优化) 检查一个特定的进度记录是否存在
    boolean existsByAppUserAndLessonId(AppUser appUser, Long lessonId);

    // (优化) 查找一个用户所有已完成的关卡 ID (我们只需要 ID 集合)
    @Query("SELECT blp.lesson.id FROM BeginnerLessonProgress blp WHERE blp.appUser = :appUser")
    Set<Long> findAllCompletedLessonIdsByAppUser(AppUser appUser);
}