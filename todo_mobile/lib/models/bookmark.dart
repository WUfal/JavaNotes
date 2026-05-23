// 对应 DTO: BookmarkDto
class Bookmark {
  final int id; // (用 int 接收 Long)
  final String type;
  final String bookmarkedId;
  final String title;
  final String createdAt;

  Bookmark({
    required this.id,
    required this.type,
    required this.bookmarkedId,
    required this.title,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      type: json['type'],
      bookmarkedId: json['bookmarkedId'],
      title: json['title'],
      createdAt: json['createdAt'],
    );
  }
}