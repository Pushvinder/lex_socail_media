class AccountUserModelResponse {
  AccountUserModel? data;

  AccountUserModelResponse({this.data});

  AccountUserModelResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? AccountUserModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
        friends!.add(Friend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (friends != null) {
      data['friends'] = friends!.map((v) => v.toJson()).toList();
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
    this.profile,
  });

  Friend.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    username = json['username'];
    profile = json['profile_image'] ?? json['image'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['profile_image'] = profile;
    return data;
  }
}