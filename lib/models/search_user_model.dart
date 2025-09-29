class SearchUserModel {
  SearchUserModel({
      this.status, 
      this.data,});

  SearchUserModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  String? status;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.username, 
      this.fullname, 
      this.profile, 
      this.communities, 
      this.interests, 
      this.hobbies,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    profile = json['profile'];
    communities = json['communities'] != null ? json['communities'].cast<String>() : [];
    if (json['interests'] != null) {
      interests = [];
      json['interests'].forEach((v) {
        interests?.add(Interests.fromJson(v));
      });
    }
    if (json['hobbies'] != null) {
      hobbies = [];
      json['hobbies'].forEach((v) {
        hobbies?.add(Hobbies.fromJson(v));
      });
    }
  }
  String? id;
  dynamic username;
  String? fullname;
  String? profile;
  List<String>? communities;
  List<Interests>? interests;
  List<Hobbies>? hobbies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['fullname'] = fullname;
    map['profile'] = profile;
    map['communities'] = communities;
    if (interests != null) {
      map['interests'] = interests?.map((v) => v.toJson()).toList();
    }
    if (hobbies != null) {
      map['hobbies'] = hobbies?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Hobbies {
  Hobbies({
      this.id, 
      this.name,});

  Hobbies.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class Interests {
  Interests({
      this.id, 
      this.name,});

  Interests.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}