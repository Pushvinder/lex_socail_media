class RegisterResponse {
  String? status;
  String? message;
  int? userId;
  String? jwt;

  RegisterResponse({this.status, this.message, this.userId, this.jwt});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    jwt = json['jwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['jwt'] = this.jwt;
    return data;
  }
}