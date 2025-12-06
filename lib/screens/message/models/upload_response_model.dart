// models/upload_response_model.dart

class UploadResponseModel {
  final bool status;
  final String message;
  final List<UploadedFile> files;

  UploadResponseModel({
    required this.status,
    required this.message,
    required this.files,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => UploadedFile.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'files': files.map((e) => e.toJson()).toList(),
    };
  }
}

class UploadedFile {
  final int id;
  final String fileType;
  final String url;

  UploadedFile({
    required this.id,
    required this.fileType,
    required this.url,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      id: json['id'] ?? 0,
      fileType: json['file_type'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_type': fileType,
      'url': url,
    };
  }
}