
class VerifyOtpResponse {
  dynamic status; // Change from String? to dynamic
  String? message;

  VerifyOtpResponse({this.status, this.message});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }

  // Helper method to check if status is true
  bool get isSuccess {
    if (status is bool) {
      return status == true;
    } else if (status is String) {
      return status == 'true';
    }
    return false;
  }
}