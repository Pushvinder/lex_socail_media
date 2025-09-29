class PostModel {
  final String userName;
  final String userHandle;
  final String userAvatar;
  final String postText;
  final List<String> hashtags;
  final List<String>? postImages;
  final String likes;
  final String comments;
  final bool isOwner;

  PostModel({
    required this.userName,
    required this.userHandle,
    required this.userAvatar,
    required this.postText,
    required this.hashtags,
    this.postImages,
    required this.likes,
    required this.comments,
    required this.isOwner,
  });
}
