// screens/video_player_screen.dart

import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import 'file_download_service.dart';
import 'media_cache_service.dart';


/// Full screen video player
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String? localPath;
  final String? title;

  const VideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    this.localPath,
    this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final MediaCacheService _cacheService = MediaCacheService();
  final FileDownloadService _downloadService = FileDownloadService();

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _initializePlayer();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      String? videoPath;

      // Try local path first
      if (widget.localPath != null && await File(widget.localPath!).exists()) {
        videoPath = widget.localPath;
      } else {
        // Check cache
        final cached = await _cacheService.getCachedFilePath(
          widget.videoUrl,
          type: MediaCacheType.video,
        );

        if (cached != null) {
          videoPath = cached;
        }
      }

      // Initialize video controller
      if (videoPath != null) {
        _videoController = VideoPlayerController.file(File(videoPath));
      } else {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );

        // Download in background for caching
        _cacheService.getFile(
          widget.videoUrl,
          type: MediaCacheType.video,
          lowPriority: true,
        );
      }

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        showControls: true,
        aspectRatio: _videoController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showOptions: false,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white54, size: 48),
                const SizedBox(height: 16),
                Text(errorMessage, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              ],
            ),
          );
        },
      );

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _downloadVideo() async {
    setState(() => _isDownloading = true);

    try {
      final result = await _downloadService.downloadVideoToGallery(widget.videoUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e'), behavior: SnackBarBehavior.floating),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: widget.title != null ? Text(widget.title!, style: const TextStyle(color: Colors.white)) : null,
        actions: [
          // IconButton(icon: const Icon(Icons.share_rounded, color: Colors.white), onPressed: () {}),
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
            )
                : const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: _isDownloading ? null : _downloadVideo,
          ),
        ],
      ),
      body: Center(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white));
    }

    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white54, size: 64),
          const SizedBox(height: 16),
          const Text('Failed to load video', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text(_errorMessage ?? 'Unknown error', style: const TextStyle(color: Colors.white38, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              _initializePlayer();
            },
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const SizedBox.shrink();
  }
}