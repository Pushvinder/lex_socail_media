// import 'package:cloud_firestore/cloud_firestore.dart';

// class Message {
//   String? messageId;
//   String senderId;
//   String message;
//   Timestamp? timestamp;
//   List<String> readBy;
//   bool isMedia;
//   String? mimeType;
//   String? url;
//   bool isSent;
//   bool isGift = false;

//   String? giftId;
//   bool? isTranslated;
//   String? translatedMessage;
//   bool showOriginalText;
//   SharedMedia? sharedMedia;
//   Message(
//       {this.messageId,
//       required this.senderId,
//       required this.message,
//       this.timestamp,
//       this.readBy = const [],
//       this.isMedia = false,
//       this.mimeType,
//       this.url,
//       this.isSent = true,
//       this.giftId,
//       this.isGift = false,
//       this.isTranslated = false,
//       this.translatedMessage,
//       this.showOriginalText = false,
//       this.sharedMedia});

//   Map<String, dynamic> toMap() {
//     return {
//       'senderId': senderId,
//       'message': message,
//       'timestamp': timestamp ?? FieldValue.serverTimestamp(),
//       'readBy': readBy,
//       'isMedia': isMedia,
//       'mimeType': mimeType,
//       'url': url,
//       'giftId': giftId,
//       'isGift': isGift,
//       'isTranslated': isTranslated,
//       'translatedMessage': translatedMessage,
//       'sharedMedia': sharedMedia?.toMap(),
//     };
//   }

//   static Message fromMap(Map<String, dynamic> map, String messageId) {
//     return Message(
//       messageId: messageId,
//       senderId: map['senderId'],
//       message: map['message'],
//       timestamp: map['timestamp'],
//       readBy: List<String>.from(map['readBy'] ?? []),
//       isMedia: map['isMedia'] ?? false,
//       mimeType: map['mimeType'],
//       url: map['url'],
//       isSent: true,
//       isGift: map['isGift'] ?? false,
//       giftId: map['giftId'],
//       isTranslated: map['isTranslated'] ?? false,
//       translatedMessage: map['translatedMessage'],
//       sharedMedia: map['sharedMedia'] != null
//           ? SharedMedia.fromMap(map['sharedMedia'])
//           : null,
//     );
//   }
// }

// class SharedMedia {
//   String? mediaId;
//   String? caption;
//   String? mediaUrl;
//   String? name;
//   String? photoUrl;
//   bool? isPost;

//   SharedMedia({
//     this.mediaId,
//     this.caption,
//     this.mediaUrl,
//     this.name,
//     this.photoUrl,
//     this.isPost = false,
//   });

//   static SharedMedia fromMap(Map<String, dynamic> map) {
//     return SharedMedia(
//       mediaId: map['mediaId'],
//       caption: map['caption'],
//       mediaUrl: map['mediaUrl'],
//       name: map['name'],
//       photoUrl: map['photoUrl'],
//       isPost: map['isPost'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'mediaId': mediaId,
//       'caption': caption,
//       'mediaUrl': mediaUrl,
//       'name': name,
//       'photoUrl': photoUrl,
//       'isPost': isPost,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String senderId;
  String message;
  String type; // 'text', 'image', 'file', 'audio'
  Timestamp timestamp;
  List<String> readBy;
  bool isSent;
  bool isMedia;
  String? mimeType;
  String? url;
  String? mediaUrl;
  String? fileName;
  bool isGift;
  String? giftId;
  bool? isTranslated;
  String? translatedMessage;
  bool showOriginalText;
  SharedMedia? sharedMedia;

  Message({
    this.id = '',
    required this.senderId,
    required this.message,
    required this.type,
    Timestamp? timestamp,
    this.readBy = const [],
    this.isSent = false,
    this.isMedia = false,
    this.mimeType,
    this.url,
    this.mediaUrl,
    this.fileName,
    this.isGift = false,
    this.giftId,
    this.isTranslated = false,
    this.translatedMessage,
    this.showOriginalText = false,
    this.sharedMedia,
  }) : timestamp = timestamp ?? Timestamp.now();

  // Copy with method for updating
  Message copyWith({
    String? id,
    String? senderId,
    String? message,
    String? type,
    Timestamp? timestamp,
    List<String>? readBy,
    bool? isSent,
    bool? isMedia,
    String? mimeType,
    String? url,
    String? mediaUrl,
    String? fileName,
    bool? isGift,
    String? giftId,
    bool? isTranslated,
    String? translatedMessage,
    bool? showOriginalText,
    SharedMedia? sharedMedia,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      isSent: isSent ?? this.isSent,
      isMedia: isMedia ?? this.isMedia,
      mimeType: mimeType ?? this.mimeType,
      url: url ?? this.url,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      fileName: fileName ?? this.fileName,
      isGift: isGift ?? this.isGift,
      giftId: giftId ?? this.giftId,
      isTranslated: isTranslated ?? this.isTranslated,
      translatedMessage: translatedMessage ?? this.translatedMessage,
      showOriginalText: showOriginalText ?? this.showOriginalText,
      sharedMedia: sharedMedia ?? this.sharedMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'readBy': readBy,
      'isSent': isSent,
      'isMedia': isMedia,
      'mimeType': mimeType,
      'url': url,
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'isGift': isGift,
      'giftId': giftId,
      'isTranslated': isTranslated,
      'translatedMessage': translatedMessage,
      'showOriginalText': showOriginalText,
      'sharedMedia': sharedMedia?.toMap(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map, String id) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'text',
      timestamp: map['timestamp'],
      readBy: List<String>.from(map['readBy'] ?? []),
      isSent: map['isSent'] ?? false,
      isMedia: map['isMedia'] ?? false,
      mimeType: map['mimeType'],
      url: map['url'],
      mediaUrl: map['mediaUrl'],
      fileName: map['fileName'],
      isGift: map['isGift'] ?? false,
      giftId: map['giftId'],
      isTranslated: map['isTranslated'] ?? false,
      translatedMessage: map['translatedMessage'],
      showOriginalText: map['showOriginalText'] ?? false,
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