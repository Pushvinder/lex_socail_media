class PostListResponse {
  String? status;
  List<Posts>? posts;

  PostListResponse({this.status, this.posts});

  PostListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  String? id;
  String? userId;
  String? likeCount;
  String? commentCount;
  String? image;
  String? video;
  String? location;
  String? ageSuitability;
  String? caption;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? fullname;
  String? profile;
  List<String>? images;
  bool? likedByUser;

  Posts(
      {this.id,
      this.userId,
      this.likeCount,
      this.commentCount,
      this.image,
      this.video,
      this.location,
      this.ageSuitability,
      this.caption,
      this.createdAt,
      this.updatedAt,
      this.username,
      this.fullname,
      this.profile,
      this.images,
      this.likedByUser});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    likeCount = json['like_count'];
    likedByUser = json['liked_by_user'];

    commentCount = json['comment_count'];
    image = json['image'];
    video = json['video'];
    location = json['location'];
    ageSuitability = json['age_suitability'];
    caption = json['caption'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    username = json['username'];
    fullname = json['fullname'];
    profile = json['profile'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['liked_by_user'] = this.likedByUser;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['image'] = this.image;
    data['video'] = this.video;
    data['location'] = this.location;
    data['age_suitability'] = this.ageSuitability;
    data['caption'] = this.caption;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['profile'] = this.profile;
    data['images'] = this.images;

    return data;
  }
}
