class LinkAccountListResponse {
  String? status;
  LinkAccountListData? data;

  LinkAccountListResponse({this.status, this.data});

  LinkAccountListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new LinkAccountListData.fromJson(json['data']) : null;
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

class LinkAccountListData {
  List<Children>? children;

  LinkAccountListData({this.children});

  LinkAccountListData.fromJson(Map<String, dynamic> json) {
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  int? id;
  int? parentId;
  int? childId;
  String? status;
  String? createdAt;
  String? fullname;
  String? profile;

  Children(
      {this.id,
      this.parentId,
      this.childId,
      this.status,
      this.createdAt,
      this.fullname,
      this.profile});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    childId = json['child_id'];
    status = json['status'];
    createdAt = json['created_at'];
    fullname = json['fullname'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['child_id'] = this.childId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['fullname'] = this.fullname;
    data['profile'] = this.profile;
    return data;
  }
}
