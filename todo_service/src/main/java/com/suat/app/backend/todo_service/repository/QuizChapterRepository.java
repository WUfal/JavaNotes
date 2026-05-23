package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.QuizChapter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizChapterRepository extends JpaRepository<QuizChapter, Long> {

    // Spring Data JPA 魔法：按 sortOrder 升序查找所有
    List<QuizChapter> findByOrderBySortOrderAsc();
}