class LoginResponse {
  String? status;
  String? message;
  LoginData? data;

  LoginResponse({this.status, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  int? userId;
  String? token;

  LoginData({this.userId, this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId;
    data['token'] = this.token;
    return data;
  }
}
