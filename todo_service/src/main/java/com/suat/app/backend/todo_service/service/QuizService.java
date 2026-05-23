package com.suat.app.backend.todo_service.service;

// 导入 DTOs
import com.suat.app.backend.todo_service.dto.*;

// 导入 Entities
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.QuizChapter;
import com.suat.app.backend.todo_service.entity.QuizMistake;
import com.suat.app.backend.todo_service.entity.QuizOption;
import com.suat.app.backend.todo_service.entity.QuizQuestion;
import com.suat.app.backend.todo_service.entity.QuizMistake;

// 导入 Repositories
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.repository.QuizChapterRepository;
import com.suat.app.backend.todo_service.repository.QuizMistakeRepository;
import com.suat.app.backend.todo_service.repository.QuizQuestionRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.suat.app.backend.todo_service.service.BadgeService;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import com.suat.app.backend.todo_service.dto.QuizMistakeChapterDto; // <--- (新增)
import java.util.Comparator; // <--- (新增)
import java.util.Map;
@Service
public class QuizService {

    @Autowired
    private QuizChapterRepository chapterRepository;

    // --- ⬇️ (关键新增) 注入新依赖 ⬇️ ---
    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private QuizQuestionRepository questionRepository;

    @Autowired
    private QuizMistakeRepository mistakeRepository;

    @Autowired
    private BadgeService badgeService; // <--- 2. (新增) 注入

    // (新增一个辅助方法来获取当前用户)
    private AppUser getCurrentUser(String username) {
        return appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    /**
     * API 1 的逻辑：获取所有"测验章节"列表
     */
    @Transactional(readOnly = true)
    public List<QuizChapterSummary> getQuizChapters() {
        return chapterRepository.findByOrderBySortOrderAsc().stream()
                .map(this::convertChapterEntityToSummaryDto)
                .collect(Collectors.toList());
    }

    /**
     * API 2 的逻辑：获取单个"章节"的所有问题 (用于开始测验)
     */
    @Transactional(readOnly = true)
    public List<QuizQuestionDto> getQuizQuestions(Long chapterId) {
        QuizChapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new RuntimeException("Quiz chapter not found"));

        return chapter.getQuestions().stream()
                .map(this::convertQuestionEntityToDto)
                .collect(Collectors.toList());
    }

    /**
     * API 3 的逻辑：提交答案并评分
     */
    @Transactional
    public QuizResultResponse submitQuiz(Long chapterId, QuizResultRequest resultRequest, String username) {

        AppUser user = getCurrentUser(username);

        QuizChapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new RuntimeException("Quiz chapter not found"));

        int totalQuestions = chapter.getQuestions().size();
        int correctCount = 0;

        Map<Long, Long> correctAnswersMap = chapter.getQuestions().stream()
                .collect(Collectors.toMap(
                        QuizQuestion::getId,
                        q -> q.getOptions().stream()
                                .filter(QuizOption::isCorrect)
                                .findFirst()
                                .map(QuizOption::getId)
                                .orElse(-1L)
                ));

        // --- ⬇️ (关键新增) 错题本逻辑 ⬇️ ---
        for (QuizQuestion question : chapter.getQuestions()) {
            Long questionId = question.getId();
            Long correctOptionId = correctAnswersMap.get(questionId);

            Long selectedOptionId = resultRequest.answers().get(questionId);

            boolean isCorrect = (selectedOptionId != null && selectedOptionId.equals(correctOptionId));

            if (isCorrect) {
                correctCount++;
                Optional<QuizMistake> mistake = mistakeRepository.findByAppUserAndQuestion(user, question);
                mistake.ifPresent(mistakeRepository::delete);

            } else {
                Optional<QuizMistake> mistakeOpt = mistakeRepository.findByAppUserAndQuestion(user, question);

                if (mistakeOpt.isPresent()) {
                    QuizMistake mistake = mistakeOpt.get();
                    mistakeRepository.save(mistake);
                } else {
                    QuizMistake newMistake = new QuizMistake();
                    newMistake.setAppUser(user);
                    newMistake.setQuestion(question);
                    mistakeRepository.save(newMistake);
                }
            }
        }
        // --- ⬆️ (新增结束) ⬆️ ---

        double score = (totalQuestions > 0) ? ((double) correctCount / totalQuestions) * 100.0 : 0.0;

        // --- ⬇️ (关键新增) 3. 授予徽章 ⬇️ ---
        // (检查：是否为"第1关" 并且 分数 >= 100)
        if (chapterId == 1 && score >= 100.0) {
            badgeService.checkAndAwardBadge(user, "QUIZ_MASTER_1");
        }
        return new QuizResultResponse(
                totalQuestions,
                correctCount,
                score,
                correctAnswersMap
        );
    }


    // --- 辅助转换方法 ---

    private QuizChapterSummary convertChapterEntityToSummaryDto(QuizChapter entity) {
        return new QuizChapterSummary(entity.getId(), entity.getTitle());
    }

    private QuizQuestionDto convertQuestionEntityToDto(QuizQuestion entity) {
        List<QuizOptionDto> options = entity.getOptions().stream()
                .map(opt -> new QuizOptionDto(opt.getId(), opt.getText()))
                .collect(Collectors.toList());

        return new QuizQuestionDto(entity.getId(), entity.getText(), options);
    }

    /**
    API 4 (已修改): 获取当前用户的所有“错题”, 按章节分组
     */
    @Transactional(readOnly = true)
    public List<QuizMistakeChapterDto> getMistakes(String username) {
        AppUser user = getCurrentUser(username);

        // 1. 从错题本仓库中，根据用户查找所有错题记录
        List<QuizMistake> mistakes = mistakeRepository.findByAppUserOrderByLastAnsweredAtDesc(user);

        // 2. (关键) 将错题按“章节” (Chapter) 分组
        Map<QuizChapter, List<QuizMistake>> mistakesByChapter = mistakes.stream()
                .collect(Collectors.groupingBy(mistake -> mistake.getQuestion().getChapter()));

        // 3. 将 Map 转换为 List<QuizMistakeChapterDto>
        return mistakesByChapter.entrySet().stream()
                // (按章节的 sortOrder 排序)
                .sorted(Map.Entry.comparingByKey(Comparator.comparing(QuizChapter::getSortOrder)))
                .map(entry -> {
                    QuizChapter chapter = entry.getKey();

                    // (获取该章节下的所有错题)
                    List<QuizQuestion> questions = entry.getValue().stream()
                            .map(QuizMistake::getQuestion)
                            .collect(Collectors.toList());

                    // (将 Question 实体转换为 DTO)
                    List<QuizQuestionDto> questionDtos = questions.stream()
                            .map(this::convertQuestionEntityToDto)
                            .collect(Collectors.toList());

                    return new QuizMistakeChapterDto(
                            chapter.getId(),
                            chapter.getTitle(),
                            questionDtos
                    );
                })
                .collect(Collectors.toList());
    }
}