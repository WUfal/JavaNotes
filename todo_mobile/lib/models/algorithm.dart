// 导入我们需要的 ContentBlock
import 'course_module.dart';

// 对应 Java 的 AlgorithmSummary
class AlgorithmSummary {
  final String id;
  final String title;
  final String difficulty;

  AlgorithmSummary({
    required this.id,
    required this.title,
    required this.difficulty,
  });

  factory AlgorithmSummary.fromJson(Map<String, dynamic> json) {
    return AlgorithmSummary(
      id: json['id'],
      title: json['title'],
      difficulty: json['difficulty'],
    );
  }
}

// 对应 Java 的 AlgorithmDetail
class AlgorithmDetail {
  final String id;
  final String title;
  final String difficulty;
  final List<ContentBlock> descriptionBlocks;
  final List<ContentBlock> solutionBlocks;
  final String? visualizationUrl;
  AlgorithmDetail({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.descriptionBlocks,
    required this.solutionBlocks,
    required this.visualizationUrl,
  });

  factory AlgorithmDetail.fromJson(Map<String, dynamic> json) {
    var descList = json['descriptionBlocks'] as List;
    List<ContentBlock> description = descList
        .map((blockJson) => ContentBlock.fromJson(blockJson))
        .toList();

    var solList = json['solutionBlocks'] as List;
    List<ContentBlock> solution = solList
        .map((blockJson) => ContentBlock.fromJson(blockJson))
        .toList();

    return AlgorithmDetail(
      id: json['id'],
      title: json['title'],
      difficulty: json['difficulty'],
      descriptionBlocks: description,
      solutionBlocks: solution,
      visualizationUrl: json['visualizationUrl'], // 确保映射了后端返回的下划线字段
    );
  }
}