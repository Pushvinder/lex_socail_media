class CommunityProfileModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String rules;
  final int membersCount;
  final List<CommunityMember> members;

  CommunityProfileModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.rules,
    required this.membersCount,
    required this.members,
  });
}

class CommunityMember {
  final String id;
  final String name;
  final String avatarUrl;

  CommunityMember({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}
