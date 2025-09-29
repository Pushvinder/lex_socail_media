import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';

class FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  final String? heroTag;

  const FullScreenImageViewer({
    Key? key,
    required this.images,
    required this.initialIndex,
    this.heroTag,
  }) : super(key: key);

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, idx) {
              final tag = (heroTag != null && images.length == 1)
                  ? heroTag!
                  : images[idx];

              final imagePath = images[idx];

              Widget imageWidget;
              if (_isNetworkUrl(imagePath)) {
                imageWidget = CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.white38,
                  ),
                );
              } else {
                imageWidget = Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.white38,
                  ),
                );
              }

              return Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Hero(
                    tag: tag,
                    child: imageWidget,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryColor.withOpacity(0.12),
                            offset: const Offset(0, 4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
