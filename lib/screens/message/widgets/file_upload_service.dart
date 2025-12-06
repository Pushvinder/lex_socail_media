// services/file_upload_service.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import '../../../api_helpers/api_manager.dart';
import '../../../api_helpers/api_param.dart';
import '../../../api_helpers/api_utils.dart';
import '../../../helpers/storage_helper.dart';
import '../models/upload_response_model.dart';

class FileUploadService {
  static final FileUploadService _instance = FileUploadService._internal();
  factory FileUploadService() => _instance;
  FileUploadService._internal();

  /// Upload multiple files using ApiManager format
  Future<UploadResponseModel?> uploadFiles({
    required List<File> files,
  }) async {
    try {
      int userId = StorageHelper().getUserId;

      debugPrint("Uploading ${files.length} files for user: $userId");

      // Convert file objects to file paths
      List<String> filePaths = files.map((e) => e.path).toList();

      // API CALL
      var result = await ApiManager.smsFileUploadCallPostWithFormData(
        body: {
          ApiParam.request: 'upload_sms_files',
          ApiParam.userId: "$userId",
        },
        fileKey: 'files[]',    // BACKEND expects file[]
        filePaths: filePaths, // ONLY file paths accepted
        endPoint: ApiUtils.uploadSmsFiles,
      );

      debugPrint("Upload Response: $result");

      if (result == null) return null;

      return UploadResponseModel.fromJson(result);

    } catch (e, s) {
      debugPrint("❌ Upload Error: $e");
      debugPrint("StackTrace:\n$s");
      return null;
    }
  }

  /// Upload a single file using same API
  Future<UploadResponseModel?> uploadSingleFile(File file) async {
    return uploadFiles(files: [file]);
  }

  /// Detect file type category
  static String getFileTypeCategory(String fileName) {
    final ext = path.extension(fileName).toLowerCase();

    if (['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(ext)) {
      return 'image';
    } else if (['.mp4', '.mov', '.avi', '.mkv', '.wmv', '.flv'].contains(ext)) {
      return 'video';
    } else if (['.mp3', '.wav', '.aac', '.m4a', '.ogg', '.flac'].contains(ext)) {
      return 'audio';
    } else {
      return 'document';
    }
  }
}
