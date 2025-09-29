class CommunityModelResponse {
  String? status;
  List<CommunityModelData>? data;

  CommunityModelResponse({this.status, this.data});

  CommunityModelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CommunityModelData>[];
      json['data'].forEach((v) {
        data!.add(new CommunityModelData.fromJson(v));
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

class CommunityModelData {
  String? communityId;
  String? communityProfile;
  String? communityName;
  String? communityDescription;
  String? commnityCreatedBy;
  List<String>? recentPostImages;
  int? joinedMemberCount;
  String? joinStatus;

  CommunityModelData(
      {this.communityId,
      this.communityProfile,
      this.communityName,
      this.communityDescription,
      this.commnityCreatedBy,
      this.recentPostImages,
      this.joinedMemberCount,
      this.joinStatus});

  CommunityModelData.fromJson(Map<String, dynamic> json) {
    communityId = json['community_id'];
    communityProfile = json['community_profile'];
    communityName = json['community_name'];
    communityDescription = json['community_description'];
    commnityCreatedBy = json['commnity_created_by'];
    recentPostImages = json['recent_post_images'].cast<String>();
    joinedMemberCount = json['joined_member_count'];
    joinStatus = json['join_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['community_id'] = this.communityId;
    data['community_profile'] = this.communityProfile;
    data['community_name'] = this.communityName;
    data['community_description'] = this.communityDescription;
    data['commnity_created_by'] = this.commnityCreatedBy;
    data['recent_post_images'] = this.recentPostImages;
    data['joined_member_count'] = this.joinedMemberCount;
    data['join_status'] = this.joinStatus;
    return data;
  }
}
