class CommentModel {
  final String id;
  final String userName;
  final String userAvatar;
  final String date;
  final String text;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.date,
    required this.text,
    required this.replies,
  });
}
