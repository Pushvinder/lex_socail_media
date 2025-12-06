// // screens/full_screen_image_viewer.dart
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:get/get.dart';
// import 'file_download_service.dart';
// import 'media_cache_service.dart';
//
// /// Full screen image viewer with zoom and pan
// class FullScreenImageViewer extends StatefulWidget {
//   final String imageUrl;
//   final String? localPath;
//   final String? heroTag;
//
//   const FullScreenImageViewer({
//     Key? key,
//     required this.imageUrl,
//     this.localPath,
//     this.heroTag,
//   }) : super(key: key);
//
//   @override
//   State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
// }
//
// class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
//   final MediaCacheService _cacheService = MediaCacheService();
//   final FileDownloadService _downloadService = FileDownloadService();
//
//   String? _cachedPath;
//   bool _isLoading = true;
//   bool _showControls = true;
//   bool _isDownloading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Set status bar to transparent
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//     _loadImage();
//   }
//
//   @override
//   void dispose() {
//     // Restore status bar
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//     );
//     super.dispose();
//   }
//
//   Future<void> _loadImage() async {
//     // Try local path first
//     if (widget.localPath != null && await File(widget.localPath!).exists()) {
//       setState(() {
//         _cachedPath = widget.localPath;
//         _isLoading = false;
//       });
//       return;
//     }
//
//     // Check cache
//     final cached = await _cacheService.getCachedFilePath(
//       widget.imageUrl,
//       type: MediaCacheType.image,
//     );
//
//     if (cached != null) {
//       setState(() {
//         _cachedPath = cached;
//         _isLoading = false;
//       });
//       return;
//     }
//
//     // Download
//     final file = await _cacheService.getFile(
//       widget.imageUrl,
//       type: MediaCacheType.image,
//     );
//
//     setState(() {
//       _cachedPath = file?.path;
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _downloadImage() async {
//     setState(() => _isDownloading = true);
//
//     try {
//       final result = await _downloadService.downloadImageToGallery(widget.imageUrl);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result.message),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Download failed: $e'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } finally {
//       setState(() => _isDownloading = false);
//     }
//   }
//
//   void _toggleControls() {
//     setState(() {
//       _showControls = !_showControls;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: _toggleControls,
//         child: Stack(
//           children: [
//             // Image viewer
//             if (_isLoading)
//               const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                 ),
//               )
//             else if (_cachedPath != null)
//               Hero(
//                 tag: widget.heroTag ?? widget.imageUrl,
//                 child: PhotoView(
//                   imageProvider: FileImage(File(_cachedPath!)),
//                   minScale: PhotoViewComputedScale.contained,
//                   maxScale: PhotoViewComputedScale.covered * 3,
//                   initialScale: PhotoViewComputedScale.contained,
//                   backgroundDecoration: const BoxDecoration(
//                     color: Colors.black,
//                   ),
//                   loadingBuilder: (context, event) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(Colors.white),
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Center(
//                       child: Icon(
//                         Icons.broken_image_rounded,
//                         color: Colors.white54,
//                         size: 64,
//                       ),
//                     );
//                   },
//                 ),
//               )
//             else
//             // Fallback to network image
//               PhotoView(
//                 imageProvider: NetworkImage(widget.imageUrl),
//                 minScale: PhotoViewComputedScale.contained,
//                 maxScale: PhotoViewComputedScale.covered * 3,
//                 initialScale: PhotoViewComputedScale.contained,
//                 backgroundDecoration: const BoxDecoration(
//                   color: Colors.black,
//                 ),
//                 loadingBuilder: (context, event) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation(Colors.white),
//                     ),
//                   );
//                 },
//               ),
//
//             // Controls overlay
//             AnimatedOpacity(
//               opacity: _showControls ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 200),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.center,
//                     colors: [
//                       Colors.black.withOpacity(0.6),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 8,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Back button
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back_ios_rounded),
//                           color: Colors.white,
//                           onPressed: () => Get.back(),
//                         ),
//                         // Actions
//                         Row(
//                           children: [
//                             // Share
//                             IconButton(
//                               icon: const Icon(Icons.share_rounded),
//                               color: Colors.white,
//                               onPressed: () {
//                                 // Share functionality
//                               },
//                             ),
//                             // Download
//                             IconButton(
//                               icon: _isDownloading
//                                   ? const SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               )
//                                   : const Icon(Icons.download_rounded),
//                               color: Colors.white,
//                               onPressed: _isDownloading ? null : _downloadImage,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Gallery viewer for multiple images
// class ImageGalleryViewer extends StatefulWidget {
//   final List<String> imageUrls;
//   final int initialIndex;
//
//   const ImageGalleryViewer({
//     Key? key,
//     required this.imageUrls,
//     this.initialIndex = 0,
//   }) : super(key: key);
//
//   @override
//   State<ImageGalleryViewer> createState() => _ImageGalleryViewerState();
// }
//
// class _ImageGalleryViewerState extends State<ImageGalleryViewer> {
//   late PageController _pageController;
//   late int _currentIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _pageController = PageController(initialPage: widget.initialIndex);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Page view
//           PageView.builder(
//             controller: _pageController,
//             itemCount: widget.imageUrls.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               return FullScreenImageViewer(
//                 imageUrl: widget.imageUrls[index],
//               );
//             },
//           ),
//
//           // Page indicator
//           if (widget.imageUrls.length > 1)
//             Positioned(
//               bottom: 50,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${_currentIndex + 1} / ${widget.imageUrls.length}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import 'file_download_service.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String? heroTag;

  const FullScreenImageViewer({
    Key? key,
    required this.images,
    required this.initialIndex,
    this.heroTag,
  }) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final FileDownloadService _downloadService = FileDownloadService();

  bool _isDownloading = false;

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Future<void> _downloadImage(String url) async {
    setState(() => _isDownloading = true);

    try {
      final result = await _downloadService.downloadImageToGallery(url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download failed: $e"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: widget.initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, idx) {
              final tag = (widget.heroTag != null && widget.images.length == 1)
                  ? widget.heroTag!
                  : widget.images[idx];

              final imagePath = widget.images[idx];
              print("🖼️ Loading image: $imagePath");
              Widget imageWidget;

              if (_isNetworkUrl(imagePath)) {
                imageWidget = CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.contain,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.white38,
                  ),
                );
              } else {
                imageWidget = Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
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

          // ---------------------------
          // LEFT TOP CLOSE BUTTON
          // ---------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Align(
                alignment: Alignment.topLeft,
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
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        iconSize: 16,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---------------------------
          // RIGHT TOP DOWNLOAD BUTTON
          // ---------------------------
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
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
                      ),
                      child: IconButton(
                        iconSize: 20,
                        icon: _isDownloading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.download_rounded,
                                color: Colors.white),
                        onPressed: _isDownloading
                            ? null
                            : () {
                                final currentUrl = widget.images[
                                    pageController.page?.round() ??
                                        widget.initialIndex];
                                _downloadImage(currentUrl);
                              },
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
