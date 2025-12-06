// widgets/video_thumbnail_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'media_cache_service.dart';

/// Widget for displaying video thumbnails with play button overlay
class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final String? localPath;
  final int? width;
  final int? height;
  final int? duration;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const VideoThumbnailWidget({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.localPath,
    this.width,
    this.height,
    this.duration,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  final MediaCacheService _cacheService = MediaCacheService();
  String? _cachedThumbnailPath;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thumbnailUrl != widget.thumbnailUrl ||
        oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    if (widget.thumbnailUrl == null) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    final cached = await _cacheService.getCachedFilePath(
      widget.thumbnailUrl!,
      type: MediaCacheType.thumbnail,
    );

    if (cached != null) {
      if (mounted) {
        setState(() {
          _cachedThumbnailPath = cached;
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final file = await _cacheService.getFile(
        widget.thumbnailUrl!,
        type: MediaCacheType.thumbnail,
      );

      if (mounted) {
        setState(() {
          _cachedThumbnailPath = file?.path;
          _isLoading = false;
          _hasError = file == null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = 220;
    double displayHeight = 160;

    if (widget.width != null && widget.height != null) {
      final aspectRatio = widget.width! / widget.height!;
      if (aspectRatio > 1) {
        displayHeight = displayWidth / aspectRatio;
      } else {
        displayWidth = displayHeight * aspectRatio;
      }
    }

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        width: displayWidth,
        height: displayHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isLoading)
              _buildShimmerPlaceholder()
            else if (_hasError || _cachedThumbnailPath == null)
              _buildErrorPlaceholder()
            else
              Image.file(
                File(_cachedThumbnailPath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              ),

            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),

            if (widget.duration != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(widget.duration!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.videocam_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(
          Icons.videocam_off_rounded,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}