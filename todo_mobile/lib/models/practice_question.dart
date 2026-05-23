class PracticeQuestion {
  final String type; // "CHOICE", "CODE", "QA"
  final String title;
  final String description;
  final List<String>? options; // 仅选择题有
  final String? correctAnswer; // 仅选择题有
  final String? codeStub;      // 仅编程题有
  final String? explanation;   // 解析

  PracticeQuestion({
    required this.type,
    required this.title,
    required this.description,
    this.options,
    this.correctAnswer,
    this.codeStub,
    this.explanation,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      type: json['type'] ?? 'QA',
      title: json['title'] ?? '未知题目',
      description: json['description'] ?? '',
      options: json['options'] != null ? List<String>.from(json['options']) : [],
      correctAnswer: json['correctAnswer'],
      codeStub: json['codeStub'],
      explanation: json['explanation'],
    );
  }
}