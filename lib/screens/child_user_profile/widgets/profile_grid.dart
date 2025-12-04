import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../../config/app_config.dart';
import '../../../widgets/full_screen_image_viewer.dart';
import '../child_user_profile_controller.dart';

class ProfileGrid extends StatelessWidget {
  final ChildUserProfileController controller;
  const ProfileGrid({
    required this.controller,
    Key? key,
  }) : super(key: key);

  Widget _buildGridLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBehindBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.textColor5.withOpacity(0.65),
        ),
      ),
    );
  }

  Widget _buildGridErrorPlaceholder(String message) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBehindBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Tooltip(
        message: message,
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: AppColors.greyColor.withOpacity(0.72),
            size: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 1,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // PHOTOS TAB
              if (controller.selectedTab.value == 0) {
                if (index >= controller.user.photos.length)
                  return const SizedBox.shrink();
                final imageUrl = controller.user.photos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          images: controller.user.photos,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildGridLoadingPlaceholder(),
                        errorWidget: (context, url, error) =>
                            _buildGridErrorPlaceholder("Image load failed"),
                      ),
                    ),
                  ),
                );
              }
              // VIDEOS TAB
              else if (controller.selectedTab.value == 1) {
                if (index >= controller.user.videos.length ||
                    index >= controller.videoControllers.length ||
                    index >= controller.isVideoInitialized.length ||
                    index >= controller.isVideoError.length) {
                  return _buildGridErrorPlaceholder("Invalid video index");
                }
                final videoController = controller.videoControllers[index];
                final isInitialized = controller.isVideoInitialized[index];
                final hadError = controller.isVideoError[index];

                if (hadError) {
                  return _buildGridErrorPlaceholder("Video failed to load");
                }
                if (videoController != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: videoController.value.isInitialized &&
                                  videoController.value.aspectRatio > 0
                              ? videoController.value.aspectRatio
                              : 1.0,
                          child: VideoPlayer(videoController),
                        ),
                        if (!isInitialized && !hadError)
                          _buildGridLoadingPlaceholder(),
                        if (isInitialized && !videoController.value.isPlaying)
                          GestureDetector(
                            onTap: () {
                              videoController.play();
                            },
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 46,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                } else {
                  return _buildGridErrorPlaceholder("Controller error");
                }
              }
              // TAGGED TAB
              else {
                if (index >= controller.user.taggedUrls.length)
                  return const SizedBox.shrink();
                final imageUrl = controller.user.taggedUrls[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          images: controller.user.taggedUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildGridLoadingPlaceholder(),
                        errorWidget: (context, url, error) =>
                            _buildGridErrorPlaceholder("Tagged image failed"),
                      ),
                    ),
                  ),
                );
              }
            },
            childCount: controller.selectedTab.value == 0
                ? controller.user.photos.length
                : controller.selectedTab.value == 1
                    ? controller.user.videos.length
                    : controller.user.taggedUrls.length,
          ),
        ),
      ),
    );
  }
}
