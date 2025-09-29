class CommunityModel {
  final String name;
  final String description;
  final String avatarUrl;
  final List<String> posts;
  final int members;
  final bool isJoined;
  final bool isMine;

  CommunityModel({
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.posts,
    required this.members,
    this.isJoined = false,
    this.isMine = false,
  });
}
