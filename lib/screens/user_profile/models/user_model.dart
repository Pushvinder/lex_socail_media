class UserProfile {
  String? status;
  UserProfileData? data;

  UserProfile({this.status, this.data});

  UserProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? new UserProfileData.fromJson(json['data'])
        : null;
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

class UserProfileData {
  String? id;
  String? fullname;
  String? username;
  String? dob;
  int? age;
  String? bio;
  String? friend_status;
  String? profile;
  List<Communities>? communities;
  List<Interests>? interests;
  List<Hobbies>? hobbies;
  String? postCount;
  String? connCount;
  bool? isFriend;
  List<PostImages>? postImages;
  List<PostVideos>? postVideos;

  String? get fullName => fullname;
  String? get photoUrl => profile;
  String? get uId => id;

  UserProfileData(
      {this.id,
      this.fullname,
      this.username,
      this.dob,
      this.age,
      this.friend_status,
      this.bio,
      this.profile,
      this.communities,
      this.interests,
      this.hobbies,
      this.postCount,
      this.connCount,
      this.isFriend,
      this.postImages,
      this.postVideos});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    dob = json['dob'];
    age = json['age'];
    bio = json['bio'];
    profile = json['profile'];
    friend_status = json['friend_status'];
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
    postCount = json['post_count'];
    connCount = json['connCount'];
    isFriend = json['is_friend'];
    if (json['postImages'] != null) {
      postImages = <PostImages>[];
      json['postImages'].forEach((v) {
        postImages!.add(new PostImages.fromJson(v));
      });
    }
    if (json['postVideos'] != null) {
      postVideos = <PostVideos>[];
      json['postVideos'].forEach((v) {
        postVideos!.add(new PostVideos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['bio'] = this.bio;
    data['friend_status'] = this.friend_status;
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
    data['post_count'] = this.postCount;
    data['connCount'] = this.connCount;
    data['is_friend'] = this.isFriend;
    if (this.postImages != null) {
      data['postImages'] = this.postImages!.map((v) => v.toJson()).toList();
    }
    if (this.postVideos != null) {
      data['postVideos'] = this.postVideos!.map((v) => v.toJson()).toList();
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

class PostImages {
  String? postId;
  List<String>? imagepath;

  PostImages({this.postId, this.imagepath});

  PostImages.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    imagepath = json['imagepath'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['imagepath'] = this.imagepath;
    return data;
  }
}

class PostVideos {
  String? postId;
  String? video;

  PostVideos({this.postId, this.video});

  PostVideos.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['video'] = this.video;
    return data;
  }
}
