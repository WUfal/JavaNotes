import 'dart:convert'; // 用于 JSON 编解码 (保存 options 列表)

class PracticeRecord {
  final int? id;
  final String title;
  final String description; // (新增) 题目描述
  final String type;

  // 选择题专用
  final List<String>? options; // (新增) 选项列表
  final String? explanation;   // (新增) 解析

  // 用户输入
  final String userAnswer;
  final String? userThought;   // (新增) 编程思路

  // AI/系统 评价
  final int score;
  final String comment;        // AI 点评
  final String? improvement;   // (新增) 改进建议
  final String? referenceAnswer; // (新增) 参考答案

  final String createdAt;

  PracticeRecord({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.options,
    this.explanation,
    required this.userAnswer,
    this.userThought,
    required this.score,
    required this.comment,
    this.improvement,
    this.referenceAnswer,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'options': options != null ? jsonEncode(options) : null, // 存为 JSON 字符串
    'explanation': explanation,
    'user_answer': userAnswer,
    'user_thought': userThought,
    'score': score,
    'comment': comment,
    'improvement': improvement,
    'reference_answer': referenceAnswer,
    'created_at': createdAt,
  };

  static PracticeRecord fromJson(Map<String, dynamic> json) => PracticeRecord(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    type: json['type'],
    options: json['options'] != null
        ? List<String>.from(jsonDecode(json['options']))
        : null,
    explanation: json['explanation'],
    userAnswer: json['user_answer'],
    userThought: json['user_thought'],
    score: json['score'],
    comment: json['comment'],
    improvement: json['improvement'],
    referenceAnswer: json['reference_answer'],
    createdAt: json['created_at'],
  );
}