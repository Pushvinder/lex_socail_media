class ChildUserModel {
  final String coverImageUrl;
  final String avatarUrl;
  final String name;
  final int age;
  final String username;
  final String bio;
  final int posts;
  final int connections;
  final int coins;
  final List<String> interests;
  final List<String> photos;
  final List<String> videos;
  final List<String> taggedUrls;

  ChildUserModel({
    required this.coverImageUrl,
    required this.avatarUrl,
    required this.name,
    required this.age,
    required this.username,
    required this.bio,
    required this.posts,
    required this.connections,
    required this.coins,
    required this.interests,
    required this.photos,
    required this.videos,
    required this.taggedUrls,
  });
}
