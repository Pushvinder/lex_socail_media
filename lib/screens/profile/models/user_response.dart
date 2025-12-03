class UserResponse {
  String? status;
  UserData? data;

  UserResponse({this.status, this.data});

  UserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? fullname;

  String? username;
  String? dob;
  String? bio;
  String? profile;
  List<Community>? communities;
  List<Community>? interests;
  List<Community>? hobbies;
  String? postCount;
  String? connCount;

  UserData(
      {this.id,
      this.fullname,
  
      this.username,
      this.dob,
      this.bio,
      this.profile,
      this.communities,
      this.interests,
      this.hobbies,
      this.postCount,
      this.connCount});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
  
    username = json['username'];
    dob = json['dob'];
    bio = json['bio'];
    profile = json['profile'];
    postCount = json['post_count'];
    connCount = json['connCount'];
    communities= json["communities"] == null ? [] : List<Community>.from(json["communities"]!.map((x) => Community.fromJson(x)));
    interests = json["interests"] == null ? [] : List<Community>.from(json["interests"]!.map((x) => Community.fromJson(x)));
    hobbies = json["hobbies"] == null ? [] : List<Community>.from(json["hobbies"]!.map((x) => Community.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
   
    data['username'] = this.username;
    data['dob'] = this.dob;
    data['bio'] = this.bio;
    data['profile'] = this.profile;
    data['hobbies'] = this.hobbies;
    data['post_count'] = this.postCount;
    data['connCount'] = this.connCount;
    data["communities"] = communities == null ? [] : List<dynamic>.from(communities!.map((x) => x.toJson()));
    data["interests"] = interests == null ? [] : List<dynamic>.from(interests!.map((x) => x.toJson()));
    data["hobbies"] = hobbies == null ? [] : List<dynamic>.from(hobbies!.map((x) => x.toJson()));

    return data;
  }
}

class Community {
  String? name;

  Community({
    this.name,
  });

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
