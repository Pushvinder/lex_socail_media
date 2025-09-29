class LiveUser {
  final String name;
  final String imageUrl;
  final bool isLive;

  LiveUser({
    required this.name,
    required this.imageUrl,
    this.isLive = true,
  });
}
