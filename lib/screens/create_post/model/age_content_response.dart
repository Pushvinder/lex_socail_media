class ContentAgeResponse {
  String? status;
  List<ContentAgeData>? data;

  ContentAgeResponse({this.status, this.data});

  ContentAgeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ContentAgeData>[];
      json['data'].forEach((v) {
        data!.add(new ContentAgeData.fromJson(v));
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

class ContentAgeData {
  int? id;
  String? ageLabel;

  ContentAgeData({this.id, this.ageLabel});

  ContentAgeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ageLabel = json['age_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['age_label'] = this.ageLabel;
    return data;
  }
}
