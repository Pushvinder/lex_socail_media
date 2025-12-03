class ChatMessageModel {
  final String text;
  final String time;
  final bool isMe;
  final ChatMessageType type;
  final String? mediaUrl;
  final String? voiceDuration;

  ChatMessageModel({
    required this.text,
    required this.time,
    required this.isMe,
    this.type = ChatMessageType.text,
    this.mediaUrl,
    this.voiceDuration,
  });
}

enum ChatMessageType { text, image, voice }
