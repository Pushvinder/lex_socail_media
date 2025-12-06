// services/file_download_service.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import 'media_cache_service.dart';

class DownloadResult {
  final bool success;
  final String message;
  final String? filePath;

  DownloadResult({
    required this.success,
    required this.message,
    this.filePath,
  });
}

class FileDownloadService {
  static final FileDownloadService _instance = FileDownloadService._internal();
  factory FileDownloadService() => _instance;
  FileDownloadService._internal();

  final MediaCacheService _cacheService = MediaCacheService();

  // Request permissions (Android 13+ compliant)
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final sdk = (await _getAndroidSdkInt());

      // ANDROID 13+ → READ_MEDIA_IMAGES / READ_MEDIA_VIDEO
      if (sdk >= 33) {
        final images = await Permission.photos.request();
        final videos = await Permission.videos.request();
        return images.isGranted || videos.isGranted;
      }

      // ANDROID 12 OR LOWER
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }

    // iOS
    final photos = await Permission.photos.request();
    return photos.isGranted || photos.isLimited;
  }

  /// Get Android SDK version
  Future<int> _getAndroidSdkInt() async {
    try {
      final release = Platform.operatingSystemVersion;
      final sdk = int.tryParse(release.replaceAll(RegExp(r'\D'), '')) ?? 0;
      return sdk;
    } catch (_) {
      return 0;
    }
  }

  /// Save image to gallery
  Future<DownloadResult> downloadImageToGallery(
      String url, {
        String? fileName,
      }) async {
    try {
      if (!await _requestPermissions()) {
        return DownloadResult(success: false, message: "Permission denied");
      }

      final file = await _cacheService.getFile(
        url,
        type: MediaCacheType.image,
      );

      if (file == null) {
        return DownloadResult(success: false, message: "Failed to load image");
      }

      final bytes = await file.readAsBytes();
      final name = fileName ?? "IMG_${DateTime.now().millisecondsSinceEpoch}";

      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(bytes),
        name: name,
        quality: 100,
      );

      if (result["isSuccess"] == true) {
        return DownloadResult(
          success: true,
          message: "Image saved to gallery",
          filePath: result["filePath"],
        );
      }

      return DownloadResult(success: false, message: "Failed to save image");
    } catch (e) {
      return DownloadResult(success: false, message: "Error: $e");
    }
  }

  /// Save video to gallery
  Future<DownloadResult> downloadVideoToGallery(
      String url, {
        String? fileName,
      }) async {
    try {
      if (!await _requestPermissions()) {
        return DownloadResult(success: false, message: "Permission denied");
      }

      final file = await _cacheService.getFile(
        url,
        type: MediaCacheType.video,
      );

      if (file == null) {
        return DownloadResult(success: false, message: "Failed to load video");
      }

      final bytes = await file.readAsBytes();
      final name = fileName ?? "VID_${DateTime.now().millisecondsSinceEpoch}";

      final result = await ImageGallerySaverPlus.saveFile(
        file.path,
        name: name,
      );


      if (result["isSuccess"] == true) {
        return DownloadResult(
          success: true,
          message: "Video saved to gallery",
          filePath: result["filePath"],
        );
      }

      return DownloadResult(success: false, message: "Failed to save video");
    } catch (e) {
      return DownloadResult(success: false, message: "Error: $e");
    }
  }

  /// Download & save document to Downloads folder
  Future<DownloadResult> downloadDocument(
      String url, {
        String? fileName,
        Function(double)? onProgress,
      }) async {
    try {
      if (!await _requestPermissions()) {
        return DownloadResult(success: false, message: "Permission denied");
      }

      final cachedFile = await _cacheService.getFile(
        url,
        type: MediaCacheType.document,
        onProgress: onProgress,
      );

      if (cachedFile == null) {
        return DownloadResult(success: false, message: "Failed to download");
      }

      final downloadsDir = await _getDownloadsDirectory();
      final finalName = fileName ?? path.basename(url);
      final dest = await _getUniqueFile("${downloadsDir.path}/$finalName");

      await cachedFile.copy(dest.path);

      return DownloadResult(
        success: true,
        message: "Saved to Downloads",
        filePath: dest.path,
      );
    } catch (e) {
      return DownloadResult(success: false, message: "Error: $e");
    }
  }

  /// Open file with device's default app
  Future<bool> openFile(
      String url, {
        MediaCacheType? type,
      }) async {
    try {
      final cacheType = type ?? _inferCacheType(url);

      String? filePath =
      await _cacheService.getCachedFilePath(url, type: cacheType);

      filePath ??= (await _cacheService.getFile(url, type: cacheType))?.path;

      if (filePath == null) return false;

      final result = await OpenFilex.open(filePath);

      return result.type == ResultType.done;
    } catch (e) {
      return false;
    }
  }

  /// Get Downloads directory
  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory("/storage/emulated/0/Download");
    }
    return await getApplicationDocumentsDirectory();
  }

  /// Create unique file to avoid overwriting
  Future<File> _getUniqueFile(String filePath) async {
    var file = File(filePath);
    int counter = 1;

    while (await file.exists()) {
      final dir = path.dirname(filePath);
      final name = path.basenameWithoutExtension(filePath);
      final ext = path.extension(filePath);
      file = File("$dir/$name ($counter)$ext");
      counter++;
    }

    return file;
  }

  /// Determine file type based on URL extension
  MediaCacheType _inferCacheType(String url) {
    final ext = path.extension(url).toLowerCase();

    if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(ext)) {
      return MediaCacheType.image;
    } else if (['.mp4', '.mov', '.mkv'].contains(ext)) {
      return MediaCacheType.video;
    } else if (['.mp3', '.wav', '.aac', '.m4a'].contains(ext)) {
      return MediaCacheType.audio;
    }
    return MediaCacheType.document;
  }
}
