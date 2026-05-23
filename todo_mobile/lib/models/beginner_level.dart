// 对应 DTO: BeginnerLessonSummary
class BeginnerLessonSummary {
  final int id; // (注意：我们用 int 来接收 Long)
  final String title;

  BeginnerLessonSummary({
    required this.id,
    required this.title,
  });

  factory BeginnerLessonSummary.fromJson(Map<String, dynamic> json) {
    return BeginnerLessonSummary(
      id: json['id'],
      title: json['title'],
    );
  }
}

// 对应 DTO: BeginnerLevelDto
class BeginnerLevelDto {
  final int id;
  final String title;
  final List<BeginnerLessonSummary> lessons;

  BeginnerLevelDto({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory BeginnerLevelDto.fromJson(Map<String, dynamic> json) {
    var lessonsList = json['lessons'] as List;
    List<BeginnerLessonSummary> lessons = lessonsList
        .map((itemJson) => BeginnerLessonSummary.fromJson(itemJson))
        .toList();

    return BeginnerLevelDto(
      id: json['id'],
      title: json['title'],
      lessons: lessons,
    );
  }
}