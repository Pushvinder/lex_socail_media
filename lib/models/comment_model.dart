class CommentModel {
  CommentModel({
      this.status, 
      this.message, 
      this.totalCount, 
      this.data,});

  CommentModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    totalCount = json['total_count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  num? totalCount;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['total_count'] = totalCount;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.comment, 
      this.name, 
      this.image,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    comment = json['comment'];
    name = json['name'];
    image = json['image'];
  }
  String? id;
  String? comment;
  String? name;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['comment'] = comment;
    map['name'] = name;
    map['image'] = image;
    return map;
  }

}