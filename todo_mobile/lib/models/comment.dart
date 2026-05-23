class Comment {
  final int id;
  final String username;
  final String content;
  final String createdAt;
  final String nickname; // <--- 新增
  final String avatarId; // <--- 新增// 后端返回的时间字符串

  Comment({
    required this.id,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.nickname,
    required this.avatarId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      username: json['username'],
      content: json['content'],
      createdAt: json['createdAt'],
      nickname: json['nickname'] ?? json['username'], // 保护性读取
      avatarId: json['avatarId'] ?? 'default',
    );
  }
}