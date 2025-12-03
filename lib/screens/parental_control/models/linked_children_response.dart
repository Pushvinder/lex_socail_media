// lib/models/linked_children_response.dart

import 'dart:convert';

LinkedChildrenResponse linkedChildrenResponseFromJson(String str) =>
    LinkedChildrenResponse.fromJson(json.decode(str));

String linkedChildrenResponseToJson(LinkedChildrenResponse data) =>
    json.encode(data.toJson());

class LinkedChildrenResponse {
  String status;
  LinkedChildrenData data;

  LinkedChildrenResponse({
    required this.status,
    required this.data,
  });

  factory LinkedChildrenResponse.fromJson(Map<String, dynamic> json) =>
      LinkedChildrenResponse(
        status: json["status"],
        data: LinkedChildrenData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class LinkedChildrenData {
  List<ChildData> children;

  LinkedChildrenData({
    required this.children,
  });

  factory LinkedChildrenData.fromJson(Map<String, dynamic> json) =>
      LinkedChildrenData(
        children: List<ChildData>.from(
            json["children"].map((x) => ChildData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
      };
}

class ChildData {
  int childId;
  String fullname;
  String username;
  String profile;
  int age;
  List<String> communities;
  List<String> interests;
  List<String> hobbies;
  int postCount;
  int connectionCount;

  ChildData({
    required this.childId,
    required this.fullname,
    required this.username,
    required this.profile,
    required this.age,
    required this.communities,
    required this.interests,
    required this.hobbies,
    required this.postCount,
    required this.connectionCount,
  });

  factory ChildData.fromJson(Map<String, dynamic> json) => ChildData(
        childId: json["child_id"],
        fullname: json["fullname"],
        username: json["username"],
        profile: json["profile"],
        age: json["age"],
        communities: List<String>.from(json["communities"].map((x) => x)),
        interests: List<String>.from(json["interests"].map((x) => x)),
        hobbies: List<String>.from(json["hobbies"].map((x) => x)),
        postCount: json["post_count"],
        connectionCount: json["connection_count"],
      );

  Map<String, dynamic> toJson() => {
        "child_id": childId,
        "fullname": fullname,
        "username": username,
        "profile": profile,
        "age": age,
        "communities": List<dynamic>.from(communities.map((x) => x)),
        "interests": List<dynamic>.from(interests.map((x) => x)),
        "hobbies": List<dynamic>.from(hobbies.map((x) => x)),
        "post_count": postCount,
        "connection_count": connectionCount,
      };
}