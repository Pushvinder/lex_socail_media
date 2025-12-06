// // services/background_preload_service.dart
//
// import 'dart:async';
// import 'dart:collection';
// import 'package:flutter/foundation.dart';
// import '../models/message_model.dart';
// import 'media_cache_service.dart';
//
// enum PreloadPriority { low, normal, high }
//
// class PreloadTask {
//   final String url;
//   final MediaCacheType type;
//   final PreloadPriority priority;
//   final String chatId;
//
//   PreloadTask({
//     required this.url,
//     required this.type,
//     required this.priority,
//     required this.chatId,
//   });
// }
//
// class PreloadStatus {
//   final bool isActive;
//   final int queueLength;
//   final int currentPreloads;
//   final String? activeChatId;
//
//   PreloadStatus({
//     required this.isActive,
//     required this.queueLength,
//     required this.currentPreloads,
//     this.activeChatId,
//   });
// }
//
// /// Service for background preloading of media files
// class BackgroundPreloadService {
//   static final BackgroundPreloadService _instance = BackgroundPreloadService._internal();
//   factory BackgroundPreloadService() => _instance;
//   BackgroundPreloadService._internal();
//
//   final MediaCacheService _cacheService = MediaCacheService();
//   final Queue<PreloadTask> _preloadQueue = Queue<PreloadTask>();
//   final Set<String> _preloadingUrls = {};
//
//   String? _activeChatId;
//   bool _isPreloading = false;
//   static const int _maxConcurrentPreloads = 2;
//   int _currentPreloads = 0;
//   bool _shouldStop = false;
//
//   void setActiveChatId(String? chatId) {
//     _activeChatId = chatId;
//     if (chatId == null) {
//       stopPreloading();
//     }
//   }
//
//   void queueForPreload(List<MessageModel> messages, String chatId) {
//     if (chatId != _activeChatId) return;
//
//     for (final message in messages) {
//       if (!message.isMediaMessage) continue;
//       if (message.content.isEmpty) continue;
//
//       final cacheType = _getCacheType(message.type);
//       final task = PreloadTask(
//         url: message.content,
//         type: cacheType,
//         priority: _getPriority(message.type),
//         chatId: chatId,
//       );
//
//       if (!_preloadingUrls.contains(message.content) &&
//           !_preloadQueue.any((t) => t.url == message.content)) {
//         _preloadQueue.add(task);
//       }
//
//       if (message.isVideo && message.thumbnailUrl != null) {
//         final thumbTask = PreloadTask(
//           url: message.thumbnailUrl!,
//           type: MediaCacheType.thumbnail,
//           priority: PreloadPriority.high,
//           chatId: chatId,
//         );
//         if (!_preloadingUrls.contains(message.thumbnailUrl!) &&
//             !_preloadQueue.any((t) => t.url == message.thumbnailUrl!)) {
//           _preloadQueue.add(thumbTask);
//         }
//       }
//     }
//
//     if (!_isPreloading) {
//       _startPreloading();
//     }
//   }
//
//   void queueSingleUrl(
//       String url, {
//         MediaCacheType type = MediaCacheType.image,
//         PreloadPriority priority = PreloadPriority.normal,
//       }) {
//     if (_activeChatId == null) return;
//     if (_preloadingUrls.contains(url)) return;
//     if (_preloadQueue.any((t) => t.url == url)) return;
//
//     final task = PreloadTask(
//       url: url,
//       type: type,
//       priority: priority,
//       chatId: _activeChatId!,
//     );
//
//     if (priority == PreloadPriority.high) {
//       final list = _preloadQueue.toList();
//       list.insert(0, task);
//       _preloadQueue.clear();
//       _preloadQueue.addAll(list);
//     } else {
//       _preloadQueue.add(task);
//     }
//
//     if (!_isPreloading) {
//       _startPreloading();
//     }
//   }
//
//   void _startPreloading() async {
//     if (_isPreloading) return;
//     _isPreloading = true;
//     _shouldStop = false;
//
//     final sortedTasks = _preloadQueue.toList()
//       ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
//     _preloadQueue.clear();
//     _preloadQueue.addAll(sortedTasks);
//
//     while (_preloadQueue.isNotEmpty && !_shouldStop) {
//       while (_currentPreloads < _maxConcurrentPreloads &&
//           _preloadQueue.isNotEmpty &&
//           !_shouldStop) {
//         final task = _preloadQueue.removeFirst();
//
//         if (task.chatId != _activeChatId) continue;
//
//         if (await _cacheService.isCached(task.url, type: task.type)) continue;
//
//         _preloadUrl(task);
//       }
//
//       await Future.delayed(const Duration(milliseconds: 100));
//     }
//
//     _isPreloading = false;
//   }
//
//   Future<void> _preloadUrl(PreloadTask task) async {
//     _currentPreloads++;
//     _preloadingUrls.add(task.url);
//
//     try {
//       await _cacheService.getFile(
//         task.url,
//         type: task.type,
//         lowPriority: true,
//       );
//       debugPrint('Preloaded: ${task.url.substring(0, 50.clamp(0, task.url.length))}...');
//     } catch (e) {
//       debugPrint('Preload error: $e');
//     } finally {
//       _currentPreloads--;
//       _preloadingUrls.remove(task.url);
//     }
//   }
//
//   void stopPreloading() {
//     _shouldStop = true;
//     _preloadQueue.clear();
//     _preloadingUrls.clear();
//     _activeChatId = null;
//     debugPrint('Background preloading stopped');
//   }
//
//   void clearQueueForChat(String chatId) {
//     _preloadQueue.removeWhere((task) => task.chatId == chatId);
//   }
//
//   MediaCacheType _getCacheType(MessageType type) {
//     switch (type) {
//       case MessageType.image:
//         return MediaCacheType.image;
//       case MessageType.video:
//         return MediaCacheType.video;
//       case MessageType.audio:
//       case MessageType.voiceNote:
//         return MediaCacheType.audio;
//       case MessageType.document:
//         return MediaCacheType.document;
//       default:
//         return MediaCacheType.image;
//     }
//   }
//
//   PreloadPriority _getPriority(MessageType type) {
//     switch (type) {
//       case MessageType.image:
//         return PreloadPriority.high;
//       case MessageType.audio:
//       case MessageType.voiceNote:
//         return PreloadPriority.high;
//       case MessageType.video:
//         return PreloadPriority.normal;
//       case MessageType.document:
//         return PreloadPriority.low;
//       default:
//         return PreloadPriority.normal;
//     }
//   }
//
//   PreloadStatus getStatus() {
//     return PreloadStatus(
//       isActive: _isPreloading,
//       queueLength: _preloadQueue.length,
//       currentPreloads: _currentPreloads,
//       activeChatId: _activeChatId,
//     );
//   }
// }
