// 对应 DTO: SearchResultDto
class SearchResult {
  final String id;
  final String title;
  final String snippet; // (描述或难度)
  final String type;    // "COURSE_MODULE", "PROJECT", "ALGORITHM"

  SearchResult({
    required this.id,
    required this.title,
    required this.snippet,
    required this.type,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      title: json['title'],
      snippet: json['snippet'],
      type: json['type'],
    );
  }
}