// 导入我们需要的 ContentBlock，它在 course_module.dart 文件里
import 'course_module.dart';

// 对应 Java 的 ProjectSummary
class ProjectSummary {
  final String id;
  final String title;
  final String description;
  final String techStack;

  ProjectSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      techStack: json['techStack'],
    );
  }
}

// 对应 Java 的 ProjectStep
class ProjectStep {
  final String stepTitle;
  final List<ContentBlock> blocks;

  ProjectStep({required this.stepTitle, required this.blocks});

  factory ProjectStep.fromJson(Map<String, dynamic> json) {
    var blocksList = json['blocks'] as List;
    List<ContentBlock> blocks = blocksList
        .map((blockJson) => ContentBlock.fromJson(blockJson))
        .toList();

    return ProjectStep(
      stepTitle: json['stepTitle'],
      blocks: blocks,
    );
  }
}

// 对应 Java 的 ProjectDetail
class ProjectDetail {
  final String id;
  final String title;
  final String description;
  final List<ProjectStep> steps;

  ProjectDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    var stepsList = json['steps'] as List;
    List<ProjectStep> steps = stepsList
        .map((stepJson) => ProjectStep.fromJson(stepJson))
        .toList();

    return ProjectDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      steps: steps,
    );
  }
}