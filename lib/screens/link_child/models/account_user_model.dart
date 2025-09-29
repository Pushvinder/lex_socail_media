class AccountUserModelResponse {
  AccountUserModel? data;

  AccountUserModelResponse({this.data});

  AccountUserModelResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new AccountUserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AccountUserModel {
  List<Friend>? friends;

  AccountUserModel({this.friends});

  AccountUserModel.fromJson(Map<String, dynamic> json) {
    if (json['friends'] != null) {
      friends = <Friend>[];
      json['friends'].forEach((v) {
        friends!.add(new Friend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.friends != null) {
      data['friends'] = this.friends!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Friend {
  String? id;
  String? username;
  bool? isSelected;
  String? profile;
  Friend({
    this.id,
    this.username,
    this.isSelected = false,
    this.profile ="https://randomuser.me/api/portraits/women/91.jpg"

  });

  Friend.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    return data;
  }
}
