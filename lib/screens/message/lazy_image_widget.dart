// widgets/lazy_image_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_friendz_zone/screens/message/widgets/media_cache_service.dart';


/// Widget for lazy loading images with caching
class LazyImageWidget extends StatefulWidget {
  final String imageUrl;
  final String? localPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showLoadingProgress;

  const LazyImageWidget({
    Key? key,
    required this.imageUrl,
    this.localPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.onTap,
    this.onLongPress,
    this.showLoadingProgress = false,
  }) : super(key: key);

  @override
  State<LazyImageWidget> createState() => _LazyImageWidgetState();
}

class _LazyImageWidgetState extends State<LazyImageWidget> {
  final MediaCacheService _cacheService = MediaCacheService();
  String? _cachedPath;
  bool _isLoading = true;
  bool _hasError = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(LazyImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (widget.localPath != null && await File(widget.localPath!).exists()) {
      if (mounted) {
        setState(() {
          _cachedPath = widget.localPath;
          _isLoading = false;
        });
      }
      return;
    }

    final cached = await _cacheService.getCachedFilePath(
      widget.imageUrl,
      type: MediaCacheType.image,
    );

    if (cached != null) {
      if (mounted) {
        setState(() {
          _cachedPath = cached;
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final file = await _cacheService.getFile(
        widget.imageUrl,
        type: MediaCacheType.image,
        onProgress: (progress) {
          if (mounted && widget.showLoadingProgress) {
            setState(() {
              _progress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _cachedPath = file?.path;
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

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isLoading) {
      imageWidget = widget.placeholder ?? _buildShimmerPlaceholder();
    } else if (_hasError || _cachedPath == null) {
      imageWidget = widget.errorWidget ?? _buildErrorWidget();
    } else {
      imageWidget = Image.file(
        File(_cachedPath!),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ?? _buildErrorWidget();
        },
      );
    }

    Widget content = ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: imageWidget,
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      content = GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: content,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          content,
          if (_isLoading && widget.showLoadingProgress)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}

/// Widget specifically for message image bubbles
class MessageImageWidget extends StatelessWidget {
  final String imageUrl;
  final String? localPath;
  final int? width;
  final int? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MessageImageWidget({
    Key? key,
    required this.imageUrl,
    this.localPath,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double displayWidth = 220;
    double displayHeight = 220;

    if (width != null && height != null) {
      final aspectRatio = width! / height!;
      if (aspectRatio > 1) {
        displayHeight = displayWidth / aspectRatio;
      } else {
        displayWidth = displayHeight * aspectRatio;
      }
    }

    return LazyImageWidget(
      imageUrl: imageUrl,
      localPath: localPath,
      width: displayWidth,
      height: displayHeight,
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onLongPress,
      showLoadingProgress: true,
    );
  }
}