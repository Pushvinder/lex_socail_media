class CommunityFeedModel {
  CommunityFeedModel({
      this.status, 
      this.data,});

  CommunityFeedModel.fromJson(dynamic json) {
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
      this.postId, 
      this.communityId, 
      this.caption, 
      this.video, 
      this.location, 
      this.ageSuitability, 
      this.createdAt, 
      this.username, 
      this.profile, 
      this.bio, 
      this.likeCount, 
      this.commentCount, 
      this.postImages,});

  Data.fromJson(dynamic json) {
    postId = json['post_id'];
    communityId = json['community_id'];
    caption = json['caption'];
    video = json['video'];
    location = json['location'];
    ageSuitability = json['age_suitability'];
    createdAt = json['created_at'];
    username = json['username'];
    profile = json['profile'];
    bio = json['bio'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    if (json['post_images'] != null) {
      postImages = json['post_images'].cast<String>();
    }
  }
  num? postId;
  num? communityId;
  String? caption;
  String? video;
  String? location;
  num? ageSuitability;
  String? createdAt;
  String? username;
  String? profile;
  String? bio;
  num? likeCount;
  num? commentCount;
  List<dynamic>? postImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = postId;
    map['community_id'] = communityId;
    map['caption'] = caption;
    map['video'] = video;
    map['location'] = location;
    map['age_suitability'] = ageSuitability;
    map['created_at'] = createdAt;
    map['username'] = username;
    map['profile'] = profile;
    map['bio'] = bio;
    map['like_count'] = likeCount;
    map['comment_count'] = commentCount;
    if (postImages != null) {
      map['post_images'] = postImages?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}