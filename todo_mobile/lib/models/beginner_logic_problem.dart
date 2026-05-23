// 导入可复用的 ContentBlock
import 'course_module.dart';

// 对应 DTO: BeginnerLogicProblemSummary
class BeginnerLogicProblemSummary {
  final int id; // (用 int 接收 Long)
  final String title;

  BeginnerLogicProblemSummary({
    required this.id,
    required this.title,
  });

  factory BeginnerLogicProblemSummary.fromJson(Map<String, dynamic> json) {
    return BeginnerLogicProblemSummary(
      id: json['id'],
      title: json['title'],
    );
  }
}

// 对应 DTO: BeginnerLogicProblemDetail
class BeginnerLogicProblemDetail {
  final int id;
  final String title;
  final List<ContentBlock> descriptionBlocks;
  final String codeStub;

  BeginnerLogicProblemDetail({
    required this.id,
    required this.title,
    required this.descriptionBlocks,
    required this.codeStub,
  });

  factory BeginnerLogicProblemDetail.fromJson(Map<String, dynamic> json) {
    var blocksList = json['descriptionBlocks'] as List;
    List<ContentBlock> blocks = blocksList
        .map((blockJson) => ContentBlock.fromJson(blockJson))
        .toList();

    return BeginnerLogicProblemDetail(
      id: json['id'],
      title: json['title'],
      descriptionBlocks: blocks,
      codeStub: json['codeStub'],
    );
  }
}