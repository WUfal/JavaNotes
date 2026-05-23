// 对应 DTO: QuizOptionDto
class QuizOptionDto {
  final int id; // (用 int 接收 Long)
  final String text;

  QuizOptionDto({required this.id, required this.text});

  factory QuizOptionDto.fromJson(Map<String, dynamic> json) {
    return QuizOptionDto(
      id: json['id'],
      text: json['text'],
    );
  }
}

// 对应 DTO: QuizQuestionDto
class QuizQuestionDto {
  final int id;
  final String text;
  final List<QuizOptionDto> options;

  QuizQuestionDto({
    required this.id,
    required this.text,
    required this.options,
  });

  factory QuizQuestionDto.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List;
    List<QuizOptionDto> options = optionsList
        .map((itemJson) => QuizOptionDto.fromJson(itemJson))
        .toList();

    return QuizQuestionDto(
      id: json['id'],
      text: json['text'],
      options: options,
    );
  }
}

// 对应 DTO: QuizChapterSummary
class QuizChapterSummary {
  final int id;
  final String title;

  QuizChapterSummary({required this.id, required this.title});

  factory QuizChapterSummary.fromJson(Map<String, dynamic> json) {
    return QuizChapterSummary(
      id: json['id'],
      title: json['title'],
    );
  }
}

// 对应 DTO: QuizResultResponse
class QuizResultResponse {
  final int totalQuestions;
  final int correctAnswers;
  final double score;
  // (Key: questionId, Value: correctOptionId)
  final Map<String, int> correctAnswersMap;

  QuizResultResponse({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.correctAnswersMap,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    // (JSON 的 Key 是 Long(int), 但 Dart 的 Map Key 必须是 String)
    final Map<String, int> parsedMap = (json['correctAnswersMap'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as int));

    return QuizResultResponse(
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      score: (json['score'] as num).toDouble(),
      correctAnswersMap: parsedMap,
    );
  }
}
// --- ⬇️ (关键新增) ⬇️ ---
// 对应 DTO: QuizMistakeChapterDto
class QuizMistakeChapter {
  final int chapterId;
  final String chapterTitle;
  final List<QuizQuestionDto> mistakes; // (复用 QuizQuestionDto)

  QuizMistakeChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.mistakes,
  });

  factory QuizMistakeChapter.fromJson(Map<String, dynamic> json) {
    var mistakesList = json['mistakes'] as List;
    List<QuizQuestionDto> mistakes = mistakesList
        .map((itemJson) => QuizQuestionDto.fromJson(itemJson))
        .toList();

    return QuizMistakeChapter(
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      mistakes: mistakes,
    );
  }
}
// --- ⬆️ (新增结束) ⬆️ --