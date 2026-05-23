class PracticeGenerationTask {
  final int id;
  final String status; // "PENDING", "COMPLETED", "FAILED"
  final String summary;
  final String? questionsJson;
  final String? errorMessage;
  final String createdAt;

  PracticeGenerationTask({
    required this.id,
    required this.status,
    required this.summary,
    this.questionsJson,
    this.errorMessage,
    required this.createdAt,
  });

  factory PracticeGenerationTask.fromJson(Map<String, dynamic> json) {
    return PracticeGenerationTask(
      id: json['id'],
      status: json['status'],
      summary: json['summary'],
      questionsJson: json['questionsJson'], // 后端返回的是 JSON 字符串
      errorMessage: json['errorMessage'],
      createdAt: json['createdAt'],
    );
  }
}