class UserProfile {
  final String username;
  final String nickname;
  final String avatarId;

  UserProfile({
    required this.username,
    required this.nickname,
    required this.avatarId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? '',
      nickname: json['nickname'] ?? '',
      avatarId: json['avatarId'] ?? 'default',
    );
  }
}