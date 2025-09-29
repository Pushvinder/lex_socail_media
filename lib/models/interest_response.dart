class InterestResponse {
  String? status;
  List<InterestResponseData>? data;

  InterestResponse({this.status, this.data});

  InterestResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <InterestResponseData>[];
      json['data'].forEach((v) {
        data!.add(new InterestResponseData.fromJson(v));
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

class InterestResponseData {
  int? id;
  String? name;

  InterestResponseData({this.id, this.name});

  InterestResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

   @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InterestResponseData &&
            runtimeType == other.runtimeType &&
            (id != null && other.id != null && id == other.id ||
             name != null && other.name != null && name == other.name);
  }

  @override
  int get hashCode => id?.hashCode ?? name.hashCode;
}