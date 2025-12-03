// lib/models/child_account_model.dart


import 'package:the_friendz_zone/screens/parental_control/models/linked_children_response.dart';

class ChildAccountModel {
  String id;
  String name;
  String username;
  int age;
  String avatarUrl;
  String interests;
  int postsCount;
  int connectionsCount;
  List<String> communities;
  List<String> hobbies;

  ChildAccountModel({
    required this.id,
    required this.name,
    required this.username,
    required this.age,
    required this.avatarUrl,
    required this.interests,
    required this.postsCount,
    required this.connectionsCount,
    required this.communities,
    required this.hobbies,
  });

  // Factory method to create from ChildData
  factory ChildAccountModel.fromChildData(ChildData childData) {
    return ChildAccountModel(
      id: childData.childId.toString(),
      name: childData.fullname,
      username: childData.username,
      age: childData.age,
      avatarUrl: childData.profile,
      interests: _formatInterests(
        childData.interests,
        childData.hobbies,
        childData.communities,
      ),
      postsCount: childData.postCount,
      connectionsCount: childData.connectionCount,
      communities: childData.communities,
      hobbies: childData.hobbies,
    );
  }

  static String _formatInterests(
    List<String> interests,
    List<String> hobbies,
    List<String> communities,
  ) {
    final allItems = [...interests, ...hobbies, ...communities];
    // Remove duplicates and empty strings
    final uniqueItems = allItems
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toSet()
        .toList();
    return uniqueItems.take(5).join(', '); // Show only first 5 items
  }
}