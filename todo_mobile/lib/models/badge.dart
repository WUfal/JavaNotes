// 对应 DTO: BadgeDto
class Badge {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String earnedAt;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.earnedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['iconName'],
      earnedAt: json['earnedAt'],
    );
  }
}