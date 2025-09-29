class PendingCommunityRequestResponse {
  String? status;
  int? totalRequests;
  List<CommunityRequestData>? data;

  PendingCommunityRequestResponse({this.status, this.totalRequests, this.data});

  PendingCommunityRequestResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRequests = json['total_requests'];
    if (json['data'] != null) {
      data = <CommunityRequestData>[];
      json['data'].forEach((v) {
        data!.add(new CommunityRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_requests'] = this.totalRequests;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunityRequestData {
  int? requestId;
  int? senderId;
  String? senderUsername;
  String? senderProfile;
  int? communityId;
  String? communityName;
  String? status;
  String? requestedAt;

  CommunityRequestData(
      {this.requestId,
      this.senderId,
      this.senderUsername,
      this.senderProfile,
      this.communityId,
      this.communityName,
      this.status,
      this.requestedAt});

  CommunityRequestData.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    senderId = json['sender_id'];
    senderUsername = json['sender_username'];
    senderProfile = json['sender_profile'];
    communityId = json['community_id'];
    communityName = json['community_name'];
    status = json['status'];
    requestedAt = json['requested_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['sender_id'] = this.senderId;
    data['sender_username'] = this.senderUsername;
    data['sender_profile'] = this.senderProfile;
    data['community_id'] = this.communityId;
    data['community_name'] = this.communityName;
    data['status'] = this.status;
    data['requested_at'] = this.requestedAt;
    return data;
  }
}