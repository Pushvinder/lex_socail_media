// services/media_cache_service.dart

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

enum MediaCacheType {
  image,
  video,
  audio,
  document,
  thumbnail,
}

/// Singleton service for managing media file caching
class MediaCacheService {
  static final MediaCacheService _instance = MediaCacheService._internal();
  factory MediaCacheService() => _instance;
  MediaCacheService._internal();

  static const int maxCacheSizeMB = 500;
  static const Duration cacheExpiry = Duration(days: 30);

  String? _cacheDir;
  final Map<String, Completer<File?>> _downloadingFiles = {};
  final Map<String, String> _cachedPaths = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = '${appDir.path}/media_cache';

    await Directory('$_cacheDir/images').create(recursive: true);
    await Directory('$_cacheDir/videos').create(recursive: true);
    await Directory('$_cacheDir/audio').create(recursive: true);
    await Directory('$_cacheDir/documents').create(recursive: true);
    await Directory('$_cacheDir/thumbnails').create(recursive: true);

    _isInitialized = true;
    _cleanupOldCache();
  }

  String get cacheDir => _cacheDir ?? '';

  String _generateCacheKey(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  String _getSubDirectory(MediaCacheType type) {
    switch (type) {
      case MediaCacheType.image:
        return 'images';
      case MediaCacheType.video:
        return 'videos';
      case MediaCacheType.audio:
        return 'audio';
      case MediaCacheType.document:
        return 'documents';
      case MediaCacheType.thumbnail:
        return 'thumbnails';
    }
  }

  Future<bool> isCached(String url, {MediaCacheType type = MediaCacheType.image}) async {
    await initialize();
    final cachedPath = await getCachedFilePath(url, type: type);
    return cachedPath != null;
  }

  Future<String?> getCachedFilePath(
      String url, {
        MediaCacheType type = MediaCacheType.image,
      }) async {
    await initialize();

    final cacheKey = '${type.name}_$url';
    if (_cachedPaths.containsKey(cacheKey)) {
      final path = _cachedPaths[cacheKey]!;
      if (await File(path).exists()) {
        return path;
      } else {
        _cachedPaths.remove(cacheKey);
      }
    }

    final fileName = _generateCacheKey(url);
    final extension = _getExtensionFromUrl(url);
    final subDir = _getSubDirectory(type);
    final filePath = '$_cacheDir/$subDir/$fileName$extension';

    final file = File(filePath);
    if (await file.exists()) {
      _cachedPaths[cacheKey] = filePath;
      return filePath;
    }

    return null;
  }

  Future<File?> getFile(
      String url, {
        MediaCacheType type = MediaCacheType.image,
        Function(double)? onProgress,
        bool lowPriority = false,
      }) async {
    await initialize();

    final cachedPath = await getCachedFilePath(url, type: type);
    if (cachedPath != null) {
      return File(cachedPath);
    }

    final downloadKey = '${type.name}_$url';
    if (_downloadingFiles.containsKey(downloadKey)) {
      return _downloadingFiles[downloadKey]!.future;
    }

    final completer = Completer<File?>();
    _downloadingFiles[downloadKey] = completer;

    try {
      final file = await _downloadFile(
        url,
        type: type,
        onProgress: onProgress,
        lowPriority: lowPriority,
      );
      completer.complete(file);
    } catch (e) {
      debugPrint('Error downloading file: $e');
      completer.complete(null);
    } finally {
      _downloadingFiles.remove(downloadKey);
    }

    return completer.future;
  }

  Future<File?> _downloadFile(
      String url, {
        MediaCacheType type = MediaCacheType.image,
        Function(double)? onProgress,
        bool lowPriority = false,
      }) async {
    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        debugPrint('Failed to download file: ${response.statusCode}');
        return null;
      }

      final contentLength = response.contentLength ?? 0;
      final fileName = _generateCacheKey(url);
      final extension = _getExtensionFromUrl(url);
      final subDir = _getSubDirectory(type);
      final filePath = '$_cacheDir/$subDir/$fileName$extension';

      final file = File(filePath);
      final sink = file.openWrite();

      int downloadedBytes = 0;
      await for (final chunk in response.stream) {
        sink.add(chunk);
        downloadedBytes += chunk.length;

        if (contentLength > 0 && onProgress != null) {
          onProgress(downloadedBytes / contentLength);
        }

        if (lowPriority) {
          await Future.delayed(Duration.zero);
        }
      }

      await sink.close();

      final cacheKey = '${type.name}_$url';
      _cachedPaths[cacheKey] = filePath;

      return file;
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  String _getExtensionFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      final lastDot = path.lastIndexOf('.');
      if (lastDot != -1 && lastDot < path.length - 1) {
        return path.substring(lastDot);
      }
    } catch (e) {
      debugPrint('Error parsing URL: $e');
    }
    return '';
  }

  Future<File?> saveToCache(
      String url,
      Uint8List bytes, {
        MediaCacheType type = MediaCacheType.image,
      }) async {
    await initialize();

    try {
      final fileName = _generateCacheKey(url);
      final extension = _getExtensionFromUrl(url);
      final subDir = _getSubDirectory(type);
      final filePath = '$_cacheDir/$subDir/$fileName$extension';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final cacheKey = '${type.name}_$url';
      _cachedPaths[cacheKey] = filePath;

      return file;
    } catch (e) {
      debugPrint('Error saving to cache: $e');
      return null;
    }
  }

  Future<void> deleteFromCache(
      String url, {
        MediaCacheType type = MediaCacheType.image,
      }) async {
    await initialize();

    final cachedPath = await getCachedFilePath(url, type: type);
    if (cachedPath != null) {
      try {
        final file = File(cachedPath);
        if (await file.exists()) {
          await file.delete();
        }
        final cacheKey = '${type.name}_$url';
        _cachedPaths.remove(cacheKey);
      } catch (e) {
        debugPrint('Error deleting cache: $e');
      }
    }
  }

  Future<void> clearCache() async {
    await initialize();

    try {
      final dir = Directory(_cacheDir!);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
        await Directory('$_cacheDir/images').create(recursive: true);
        await Directory('$_cacheDir/videos').create(recursive: true);
        await Directory('$_cacheDir/audio').create(recursive: true);
        await Directory('$_cacheDir/documents').create(recursive: true);
        await Directory('$_cacheDir/thumbnails').create(recursive: true);
      }
      _cachedPaths.clear();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  Future<int> getCacheSize() async {
    await initialize();

    int totalSize = 0;
    try {
      final dir = Directory(_cacheDir!);
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
    }
    return totalSize;
  }

  Future<void> _cleanupOldCache() async {
    try {
      final dir = Directory(_cacheDir!);
      final now = DateTime.now();
      final filesToDelete = <File>[];
      int totalSize = 0;

      final fileStats = <File, FileStat>{};
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          fileStats[entity] = stat;
          totalSize += stat.size;

          if (now.difference(stat.accessed) > cacheExpiry) {
            filesToDelete.add(entity);
          }
        }
      }

      for (final file in filesToDelete) {
        totalSize -= (fileStats[file]?.size ?? 0);
        await file.delete();
      }

      if (totalSize > maxCacheSizeMB * 1024 * 1024) {
        final sortedFiles = fileStats.entries.toList()
          ..sort((a, b) => a.value.accessed.compareTo(b.value.accessed));

        for (final entry in sortedFiles) {
          if (totalSize <= maxCacheSizeMB * 1024 * 1024 * 0.8) break;
          totalSize -= entry.value.size;
          await entry.key.delete();
        }
      }
    } catch (e) {
      debugPrint('Error cleaning cache: $e');
    }
  }
}