class ConnectionListResponse {
  String? status;
  List<ConnectionData>? data;

  ConnectionListResponse({this.status, this.data});

  ConnectionListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ConnectionData>[];
      json['data'].forEach((v) {
        data!.add(new ConnectionData.fromJson(v));
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

class ConnectionData {
  String? id;
  String? username;
  String? fullname;
  String? dob;
  int? age;
  String? bio;
  String? profile;
  List<Communities>? communities;
  List<Interests>? interests;
  List<Hobbies>? hobbies;

  ConnectionData(
      {this.id,
      this.username,
      this.fullname,
      this.dob,
      this.age,
      this.bio,
      this.profile,
      this.communities,
      this.interests,
      this.hobbies});

  ConnectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
    dob = json['dob'];
    age = json['age'];
    bio = json['bio'];
    profile = json['profile'];
    if (json['communities'] != null) {
      communities = <Communities>[];
      json['communities'].forEach((v) {
        communities!.add(new Communities.fromJson(v));
      });
    }
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }
    if (json['hobbies'] != null) {
      hobbies = <Hobbies>[];
      json['hobbies'].forEach((v) {
        hobbies!.add(new Hobbies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['bio'] = this.bio;
    data['profile'] = this.profile;
    if (this.communities != null) {
      data['communities'] = this.communities!.map((v) => v.toJson()).toList();
    }
    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    if (this.hobbies != null) {
      data['hobbies'] = this.hobbies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Communities {
  String? name;

  Communities({this.name});

  Communities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}


class Interests {
  String? name;

  Interests({this.name});

  Interests.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Hobbies {
  String? name;

  Hobbies({this.name});

  Hobbies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}