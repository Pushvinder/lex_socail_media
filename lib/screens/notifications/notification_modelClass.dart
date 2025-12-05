// Notification Model - Matching your API response
class NotificationModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String notificationType;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;
  final String? username;
  final String? fullname;
  final String? profileImage;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.notificationType,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.username,
    this.fullname,
    this.profileImage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      notificationType: json['notification_type']?.toString() ?? 'user',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      username: json['username']?.toString(),
      fullname: json['fullname']?.toString(),
      profileImage: json['profile_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'notification_type': notificationType,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt,
      'username': username,
      'fullname': fullname,
      'profile_image': profileImage,
    };
  }

  // Copy with method for updating specific fields
  NotificationModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? notificationType,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? createdAt,
    String? username,
    String? fullname,
    String? profileImage,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      notificationType: notificationType ?? this.notificationType,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

// Notification Response Model - Matching your API response
class NotificationResponse {
  final String status;
  final List<NotificationModel>? data;

  NotificationResponse({
    required this.status,
    this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status']?.toString() ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}