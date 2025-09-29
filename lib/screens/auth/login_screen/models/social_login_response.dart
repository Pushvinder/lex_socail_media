class SocailLoginResponse {
  String? status;
  String? message;
  bool? userFlag;
  int? userId;
  String? jwt;

  SocailLoginResponse(
      {this.status, this.message, this.userFlag, this.userId, this.jwt});

  SocailLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userFlag = json['user_flag'];
    userId = json['user_id'];
    jwt = json['jwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_flag'] = this.userFlag;
    data['user_id'] = this.userId;
    data['jwt'] = this.jwt;
    return data;
  }
}