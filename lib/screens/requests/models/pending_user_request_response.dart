class PendingUserRequestResponse {
  String? status;
  List<UserRequestData>? data;

  PendingUserRequestResponse({this.status, this.data});

  PendingUserRequestResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <UserRequestData>[];
      json['data'].forEach((v) {
        data!.add(new UserRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserRequestData {
  int? requestId;
  int? id;
  String? username;
  String? fullname;
  String? profile;

  UserRequestData({this.requestId, this.id, this.username , this.fullname , this.profile});

  UserRequestData.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['profile'] = this.profile;
    data['username'] = this.username;
    return data;
  }
}