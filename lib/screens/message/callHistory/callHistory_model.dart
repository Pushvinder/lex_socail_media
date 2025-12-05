class CallHistoryResponse {
  final String status;
  final List<CallHistoryModel> data;

  CallHistoryResponse({
    required this.status,
    required this.data,
  });

  factory CallHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CallHistoryResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CallHistoryModel.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class CallHistoryModel {
  final String id;
  final String callerId;
  final String callerUsername;
  final String callerFullname;
  final String callerProfile;
  final String receiverId;
  final String? receiverUsername;
  final String receiverFullname;
  final String receiverProfile;
  final String callType; // 'audio' or 'video'
  final String startedAt;
  final String endedAt;
  final String duration;
  final String status; // 'completed', 'missed', etc.

  CallHistoryModel({
    required this.id,
    required this.callerId,
    required this.callerUsername,
    required this.callerFullname,
    required this.callerProfile,
    required this.receiverId,
    this.receiverUsername,
    required this.receiverFullname,
    required this.receiverProfile,
    required this.callType,
    required this.startedAt,
    required this.endedAt,
    required this.duration,
    required this.status,
  });

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) {
    return CallHistoryModel(
      id: json['id']?.toString() ?? '',
      callerId: json['caller_id']?.toString() ?? '',
      callerUsername: json['caller_username']?.toString() ?? '',
      callerFullname: json['caller_fullname']?.toString() ?? '',
      callerProfile: json['caller_profile']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      receiverUsername: json['receiver_username']?.toString(),
      receiverFullname: json['receiver_fullname']?.toString() ?? '',
      receiverProfile: json['receiver_profile']?.toString() ?? '',
      callType: json['call_type']?.toString() ?? 'audio',
      startedAt: json['started_at']?.toString() ?? '',
      endedAt: json['ended_at']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caller_id': callerId,
      'caller_username': callerUsername,
      'caller_fullname': callerFullname,
      'caller_profile': callerProfile,
      'receiver_id': receiverId,
      'receiver_username': receiverUsername,
      'receiver_fullname': receiverFullname,
      'receiver_profile': receiverProfile,
      'call_type': callType,
      'started_at': startedAt,
      'ended_at': endedAt,
      'duration': duration,
      'status': status,
    };
  }

  // Helper method to determine if current user is caller
  bool isCaller(String currentUserId) {
    return callerId == currentUserId;
  }

  // Get the other participant's name
  String getOtherParticipantName(String currentUserId) {
    return isCaller(currentUserId) ? receiverFullname : callerFullname;
  }

  // Get the other participant's profile
  String getOtherParticipantProfile(String currentUserId) {
    return isCaller(currentUserId) ? receiverProfile : callerProfile;
  }

  // Get the other participant's ID
  String getOtherParticipantId(String currentUserId) {
    return isCaller(currentUserId) ? receiverId : callerId;
  }

  // Check if call was answered
  bool get isAnswered => status == 'completed' && int.parse(duration) > 0;

  // Check if it's a video call
  bool get isVideoCall => callType == 'video';
}