class CallResponseModel {
  final String? status;
  final String? message;
  final CallData? data;

  CallResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CallResponseModel.fromJson(Map<String, dynamic> json) {
    return CallResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null ? CallData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CallData {
  final int? callId;
  final String? channelName;
  final String? token;
  final int? uid;

  CallData({
    this.callId,
    this.channelName,
    this.token,
    this.uid,
  });

  factory CallData.fromJson(Map<String, dynamic> json) {
    return CallData(
      callId: json['call_id'] as int?,
      channelName: json['channel_name'] as String?,
      token: json['token'] as String?,
      uid: json['uid'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_id': callId,
      'channel_name': channelName,
      'token': token,
      'uid': uid,
    };
  }
}