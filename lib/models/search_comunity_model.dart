class SearchComunityModel {
  SearchComunityModel({
      this.status, 
      this.data,});

  SearchComunityModel.fromJson(dynamic json) {
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
      this.communityId, 
      this.communityName, 
      this.communityProfile, 
      this.is_joined,
      this.created_by,
      this.tags,});

  Data.fromJson(dynamic json) {
    communityId = json['community_id'];
    created_by = json['created_by'];
    is_joined = json['is_joined'];
    communityName = json['community_name'];
    communityProfile = json['community_profile'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
  }
  String? communityId;
  String? communityName;
  String? communityProfile;
  String? created_by;
  bool? is_joined;
  List<String>? tags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['community_id'] = communityId;
    map['created_by'] = created_by;
    map['is_joined'] = is_joined;
    map['community_name'] = communityName;
    map['community_profile'] = communityProfile;
    map['tags'] = tags;
    return map;
  }

}