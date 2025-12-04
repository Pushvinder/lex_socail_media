// To parse this JSON data, do
//
//     final communityProfileModel = communityProfileModelFromJson(jsonString);

import 'dart:convert';

CommunityProfileModel communityProfileModelFromJson(String str) => CommunityProfileModel.fromJson(json.decode(str));

String communityProfileModelToJson(CommunityProfileModel data) => json.encode(data.toJson());

class CommunityProfileModel {
  String status;
  Data data;

  CommunityProfileModel({
    required this.status,
    required this.data,
  });

  factory CommunityProfileModel.fromJson(Map<String, dynamic> json) => CommunityProfileModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  String communityId;
  String communityProfile;
  String communityName;
  String communityRules;
  String communityDescription;
  DateTime createdOn;
  List<dynamic> recentPostImages;
  int totalJoinedUsers;
  List<JoinedUser> joinedUsers;
  List<CommunitiesList> communitiesList;

  Data({
    required this.communityId,
    required this.communityProfile,
    required this.communityName,
    required this.communityRules,
    required this.communityDescription,
    required this.createdOn,
    required this.recentPostImages,
    required this.totalJoinedUsers,
    required this.joinedUsers,
    required this.communitiesList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    communityId: json["community_id"],
    communityProfile: json["community_profile"],
    communityName: json["community_name"],
    communityRules: json["community_rules"],
    communityDescription: json["community_description"],
    createdOn: DateTime.parse(json["created_on"]),
    recentPostImages: List<dynamic>.from(json["recent_post_images"].map((x) => x)),
    totalJoinedUsers: json["total_joined_users"],
    joinedUsers: List<JoinedUser>.from(json["joined_users"].map((x) => JoinedUser.fromJson(x))),
    communitiesList: List<CommunitiesList>.from(json["communities_list"].map((x) => CommunitiesList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "community_id": communityId,
    "community_profile": communityProfile,
    "community_name": communityName,
    "community_rules": communityRules,
    "community_description": communityDescription,
    "created_on": createdOn.toIso8601String(),
    "recent_post_images": List<dynamic>.from(recentPostImages.map((x) => x)),
    "total_joined_users": totalJoinedUsers,
    "joined_users": List<dynamic>.from(joinedUsers.map((x) => x.toJson())),
    "communities_list": List<dynamic>.from(communitiesList.map((x) => x.toJson())),
  };
}

class CommunitiesList {
  int communityId;
  String communityName;

  CommunitiesList({
    required this.communityId,
    required this.communityName,
  });

  factory CommunitiesList.fromJson(Map<String, dynamic> json) => CommunitiesList(
    communityId: json["community_id"],
    communityName: json["community_name"],
  );

  Map<String, dynamic> toJson() => {
    "community_id": communityId,
    "community_name": communityName,
  };
}

class JoinedUser {
  int id;
  String username;
  String fullname;
  String profile;

  JoinedUser({
    required this.id,
    required this.username,
    required this.fullname,
    required this.profile,
  });

  factory JoinedUser.fromJson(Map<String, dynamic> json) => JoinedUser(
    id: json["id"],
    username: json["username"],
    fullname: json["fullname"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "fullname": fullname,
    "profile": profile,
  };
}
