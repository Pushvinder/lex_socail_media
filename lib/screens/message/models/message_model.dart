import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? messageId;
  String senderId;
  String message;
  Timestamp? timestamp;
  List<String> readBy;
  bool isMedia;
  String? mimeType;
  String? url;
  bool isSent;
  bool isGift = false;

  String? giftId;
  bool? isTranslated;
  String? translatedMessage;
  bool showOriginalText;
  SharedMedia? sharedMedia;
  Message(
      {this.messageId,
      required this.senderId,
      required this.message,
      this.timestamp,
      this.readBy = const [],
      this.isMedia = false,
      this.mimeType,
      this.url,
      this.isSent = true,
      this.giftId,
      this.isGift = false,
      this.isTranslated = false,
      this.translatedMessage,
      this.showOriginalText = false,
      this.sharedMedia});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'readBy': readBy,
      'isMedia': isMedia,
      'mimeType': mimeType,
      'url': url,
      'giftId': giftId,
      'isGift': isGift,
      'isTranslated': isTranslated,
      'translatedMessage': translatedMessage,
      'sharedMedia': sharedMedia?.toMap(),
    };
  }

  static Message fromMap(Map<String, dynamic> map, String messageId) {
    return Message(
      messageId: messageId,
      senderId: map['senderId'],
      message: map['message'],
      timestamp: map['timestamp'],
      readBy: List<String>.from(map['readBy'] ?? []),
      isMedia: map['isMedia'] ?? false,
      mimeType: map['mimeType'],
      url: map['url'],
      isSent: true,
      isGift: map['isGift'] ?? false,
      giftId: map['giftId'],
      isTranslated: map['isTranslated'] ?? false,
      translatedMessage: map['translatedMessage'],
      sharedMedia: map['sharedMedia'] != null
          ? SharedMedia.fromMap(map['sharedMedia'])
          : null,
    );
  }
}

class SharedMedia {
  String? mediaId;
  String? caption;
  String? mediaUrl;
  String? name;
  String? photoUrl;
  bool? isPost;

  SharedMedia({
    this.mediaId,
    this.caption,
    this.mediaUrl,
    this.name,
    this.photoUrl,
    this.isPost = false,
  });

  static SharedMedia fromMap(Map<String, dynamic> map) {
    return SharedMedia(
      mediaId: map['mediaId'],
      caption: map['caption'],
      mediaUrl: map['mediaUrl'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      isPost: map['isPost'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mediaId': mediaId,
      'caption': caption,
      'mediaUrl': mediaUrl,
      'name': name,
      'photoUrl': photoUrl,
      'isPost': isPost,
    };
  }
}
