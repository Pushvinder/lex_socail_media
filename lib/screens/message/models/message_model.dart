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


// // models/message_model.dart
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// enum MessageType { text, image, video, audio, document, voiceNote }
//
// enum MessageStatus { sending, sent, delivered, seen, failed }
//
// class MessageModel {
//   final String messageId;
//   final String chatId;
//   final String senderId;
//   final String senderName;
//   final String? senderAvatar;
//   final MessageType type;
//   final String content;
//   final String? thumbnailUrl;
//   final String? fileName;
//   final String? fileExtension;
//   final int? fileSize;
//   final int? mediaDuration;
//   final int? mediaWidth;
//   final int? mediaHeight;
//   final MessageStatus status;
//   final DateTime timestamp;
//   final String? replyToMessageId;
//   final Map<String, dynamic>? replyToMessage;
//   final bool isDeleted;
//   final List<String> seenBy;
//   final List<String> deliveredTo;
//   final String? localFilePath;
//
//   MessageModel({
//     required this.messageId,
//     required this.chatId,
//     required this.senderId,
//     required this.senderName,
//     this.senderAvatar,
//     required this.type,
//     required this.content,
//     this.thumbnailUrl,
//     this.fileName,
//     this.fileExtension,
//     this.fileSize,
//     this.mediaDuration,
//     this.mediaWidth,
//     this.mediaHeight,
//     required this.status,
//     required this.timestamp,
//     this.replyToMessageId,
//     this.replyToMessage,
//     this.isDeleted = false,
//     this.seenBy = const [],
//     this.deliveredTo = const [],
//     this.localFilePath,
//   });
//
//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       messageId: json['messageId'] ?? '',
//       chatId: json['chatId'] ?? '',
//       senderId: json['senderId'] ?? '',
//       senderName: json['senderName'] ?? '',
//       senderAvatar: json['senderAvatar'],
//       type: _parseMessageType(json['type']),
//       content: json['content'] ?? '',
//       thumbnailUrl: json['thumbnailUrl'],
//       fileName: json['fileName'],
//       fileExtension: json['fileExtension'],
//       fileSize: json['fileSize'],
//       mediaDuration: json['mediaDuration'],
//       mediaWidth: json['mediaWidth'],
//       mediaHeight: json['mediaHeight'],
//       status: _parseMessageStatus(json['status']),
//       timestamp: _parseTimestamp(json['timestamp']),
//       replyToMessageId: json['replyToMessageId'],
//       replyToMessage: json['replyToMessage'],
//       isDeleted: json['isDeleted'] ?? false,
//       seenBy: List<String>.from(json['seenBy'] ?? []),
//       deliveredTo: List<String>.from(json['deliveredTo'] ?? []),
//       localFilePath: json['localFilePath'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'messageId': messageId,
//       'chatId': chatId,
//       'senderId': senderId,
//       'senderName': senderName,
//       'senderAvatar': senderAvatar,
//       'type': type.name,
//       'content': content,
//       'thumbnailUrl': thumbnailUrl,
//       'fileName': fileName,
//       'fileExtension': fileExtension,
//       'fileSize': fileSize,
//       'mediaDuration': mediaDuration,
//       'mediaWidth': mediaWidth,
//       'mediaHeight': mediaHeight,
//       'status': status.name,
//       'timestamp': Timestamp.fromDate(timestamp),
//       'replyToMessageId': replyToMessageId,
//       'replyToMessage': replyToMessage,
//       'isDeleted': isDeleted,
//       'seenBy': seenBy,
//       'deliveredTo': deliveredTo,
//     };
//   }
//
//   MessageModel copyWith({
//     String? messageId,
//     String? chatId,
//     String? senderId,
//     String? senderName,
//     String? senderAvatar,
//     MessageType? type,
//     String? content,
//     String? thumbnailUrl,
//     String? fileName,
//     String? fileExtension,
//     int? fileSize,
//     int? mediaDuration,
//     int? mediaWidth,
//     int? mediaHeight,
//     MessageStatus? status,
//     DateTime? timestamp,
//     String? replyToMessageId,
//     Map<String, dynamic>? replyToMessage,
//     bool? isDeleted,
//     List<String>? seenBy,
//     List<String>? deliveredTo,
//     String? localFilePath,
//   }) {
//     return MessageModel(
//       messageId: messageId ?? this.messageId,
//       chatId: chatId ?? this.chatId,
//       senderId: senderId ?? this.senderId,
//       senderName: senderName ?? this.senderName,
//       senderAvatar: senderAvatar ?? this.senderAvatar,
//       type: type ?? this.type,
//       content: content ?? this.content,
//       thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
//       fileName: fileName ?? this.fileName,
//       fileExtension: fileExtension ?? this.fileExtension,
//       fileSize: fileSize ?? this.fileSize,
//       mediaDuration: mediaDuration ?? this.mediaDuration,
//       mediaWidth: mediaWidth ?? this.mediaWidth,
//       mediaHeight: mediaHeight ?? this.mediaHeight,
//       status: status ?? this.status,
//       timestamp: timestamp ?? this.timestamp,
//       replyToMessageId: replyToMessageId ?? this.replyToMessageId,
//       replyToMessage: replyToMessage ?? this.replyToMessage,
//       isDeleted: isDeleted ?? this.isDeleted,
//       seenBy: seenBy ?? this.seenBy,
//       deliveredTo: deliveredTo ?? this.deliveredTo,
//       localFilePath: localFilePath ?? this.localFilePath,
//     );
//   }
//
//   bool get isMediaMessage =>
//       type == MessageType.image ||
//           type == MessageType.video ||
//           type == MessageType.audio ||
//           type == MessageType.document ||
//           type == MessageType.voiceNote;
//
//   bool get isImage => type == MessageType.image;
//   bool get isVideo => type == MessageType.video;
//   bool get isAudio => type == MessageType.audio || type == MessageType.voiceNote;
//   bool get isDocument => type == MessageType.document;
//
//   String get formattedFileSize {
//     if (fileSize == null) return '';
//     if (fileSize! < 1024) return '$fileSize B';
//     if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
//     if (fileSize! < 1024 * 1024 * 1024) {
//       return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
//     }
//     return '${(fileSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
//   }
//
//   String get formattedDuration {
//     if (mediaDuration == null) return '';
//     final minutes = mediaDuration! ~/ 60;
//     final seconds = mediaDuration! % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   static MessageType _parseMessageType(String? type) {
//     switch (type) {
//       case 'image':
//         return MessageType.image;
//       case 'video':
//         return MessageType.video;
//       case 'audio':
//         return MessageType.audio;
//       case 'document':
//         return MessageType.document;
//       case 'voiceNote':
//         return MessageType.voiceNote;
//       default:
//         return MessageType.text;
//     }
//   }
//
//   static MessageStatus _parseMessageStatus(String? status) {
//     switch (status) {
//       case 'sending':
//         return MessageStatus.sending;
//       case 'sent':
//         return MessageStatus.sent;
//       case 'delivered':
//         return MessageStatus.delivered;
//       case 'seen':
//         return MessageStatus.seen;
//       case 'failed':
//         return MessageStatus.failed;
//       default:
//         return MessageStatus.sent;
//     }
//   }
//
//   static DateTime _parseTimestamp(dynamic timestamp) {
//     if (timestamp is Timestamp) {
//       return timestamp.toDate();
//     } else if (timestamp is DateTime) {
//       return timestamp;
//     } else if (timestamp is int) {
//       return DateTime.fromMillisecondsSinceEpoch(timestamp);
//     }
//     return DateTime.now();
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