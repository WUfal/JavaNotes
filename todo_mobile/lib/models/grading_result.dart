class GradingResult {
  final int score;
  final String comment;
  final String improvement;
  final String referenceAnswer; // <--- (新增)

  GradingResult({
    required this.score,
    required this.comment,
    required this.improvement,
    required this.referenceAnswer, // <--- (新增)
  });

  factory GradingResult.fromJson(Map<String, dynamic> json) {
    return GradingResult(
      score: json['score'] ?? 0,
      comment: json['comment'] ?? '',
      improvement: json['improvement'] ?? '',
      referenceAnswer: json['referenceAnswer'] ?? '暂无参考答案', // <--- (新增)
    );
  }
}