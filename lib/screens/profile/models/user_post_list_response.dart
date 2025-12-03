class UserPostListResponse {
  bool? status;
  String? message;
  UserPostListData? data;

  UserPostListResponse({this.status, this.message, this.data});

  UserPostListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UserPostListData.fromJson(json['data']) : null;
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

class UserPostListData {
  List<PostImages>? postImages;
  List<PostVideos>? postVideos;

  UserPostListData({this.postImages, this.postVideos});

  UserPostListData.fromJson(Map<String, dynamic> json) {
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
    if (this.postImages != null) {
      data['postImages'] = this.postImages!.map((v) => v.toJson()).toList();
    }
    if (this.postVideos != null) {
      data['postVideos'] = this.postVideos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostImages {
  String? id;
  String? userId;
  String? video;
  String? location;
  String? ageSuitability;
  String? caption;
  String? createdAt;
  int? likeCount;
  int? commentCount;
  List<String>? postImages;

  PostImages(
      {this.id,
      this.userId,
      this.video,
      this.location,
      this.ageSuitability,
      this.caption,
      this.createdAt,
      this.likeCount,
      this.commentCount,
      this.postImages});

  PostImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    video = json['video'];
    location = json['location'];
    ageSuitability = json['age_suitability'];
    caption = json['caption'];
    createdAt = json['created_at'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    postImages = json['post_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video'] = this.video;
    data['location'] = this.location;
    data['age_suitability'] = this.ageSuitability;
    data['caption'] = this.caption;
    data['created_at'] = this.createdAt;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['post_images'] = this.postImages;
    return data;
  }
}

class PostVideos {
  String? id;
  String? userId;
  String? video;
  String? location;
  String? ageSuitability;
  String? caption;
  String? createdAt;
  int? likeCount;
  int? commentCount;
  List<String>? postImages;

  PostVideos(
      {this.id,
      this.userId,
      this.video,
      this.location,
      this.ageSuitability,
      this.caption,
      this.createdAt,
      this.likeCount,
      this.commentCount,
      this.postImages});

  PostVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    video = json['video'];
    location = json['location'];
    ageSuitability = json['age_suitability'];
    caption = json['caption'];
    createdAt = json['created_at'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
        postImages = json['post_images'].cast<String>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video'] = this.video;
    data['location'] = this.location;
    data['age_suitability'] = this.ageSuitability;
    data['caption'] = this.caption;
    data['created_at'] = this.createdAt;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
        data['post_images'] = this.postImages;

    return data;
  }
}