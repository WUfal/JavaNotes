class LocalNote {
  final int? id;
  final String title;
  final String content;
  final String summary;
  final String updatedAt; // 最后修改时间

  // --- ⬇️ (新增) ⬇️ ---
  final String createdAt; // 创建时间 (固定不变)
  final String type;      // 分类 (e.g., "Java", "日记", "未分类")
  // --- ⬆️ (新增结束) ⬆️ ---

  LocalNote({
    this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.updatedAt,
    required this.createdAt,
    this.type = "未分类", // 默认分类
  });

  static LocalNote fromJson(Map<String, dynamic> json) => LocalNote(
    id: json['id'] as int?,
    title: json['title'] as String,
    content: json['content'] as String,
    summary: json['summary'] as String,
    updatedAt: json['updated_at'] as String,
    createdAt: json['created_at'] as String, // 读取
    type: json['type'] as String,            // 读取
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'summary': summary,
    'updated_at': updatedAt,
    'created_at': createdAt, // 写入
    'type': type,            // 写入
  };
}