package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.QuizMistake;
import com.suat.app.backend.todo_service.entity.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;


@Repository
public interface QuizMistakeRepository extends JpaRepository<QuizMistake, Long> {

    // (查找一个特定的错题记录 - 不变)
    Optional<QuizMistake> findByAppUserAndQuestion(AppUser appUser, QuizQuestion question);

    // --- ⬇️ (关键新增) ⬇️ ---
    // (查找一个用户的所有错题，按“最后答错时间”倒序排列)
    List<QuizMistake> findByAppUserOrderByLastAnsweredAtDesc(AppUser appUser);
    // --- ⬆️ (新增结束) ⬆️ ---
}