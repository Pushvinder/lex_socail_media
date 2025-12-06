import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/screens/profile/widgets/video_screen.dart';
import 'package:video_player/video_player.dart';
import '../../../config/app_config.dart';
import '../../../widgets/full_screen_image_viewer.dart';
import '../profile_controller.dart';

class ProfileGrid extends StatelessWidget {
  ProfileGrid({
    Key? key,
  }) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();

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

  Widget _noPostError(String message) {
    return SliverToBoxAdapter(
      child: Center(
        child: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => (controller.isPhotosTab.value &&
        controller.imagePostList.isEmpty) ||
        (!controller.isPhotosTab.value && controller.videoPostList.isEmpty)
        ? _noPostError(ErrorMessages.noPostError)
        : SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: controller.isPhotosTab.value
              ? controller.imagePostList.value.length
              : controller.videoPostList.value.length,
              (BuildContext context, int index) {
            if (controller.isPhotosTab.value) {
              return _buildImageGridItem(context, index);
            } else {
              return _buildVideoGridItem(context, index);
            }
          },
        ),
      ),
    ));
  }

  Widget _buildImageGridItem(BuildContext context, int index) {
    if (index >= controller.imagePostList.length) {
      return const SizedBox.shrink();
    }

    final imagePost = controller.imagePostList[index];
    final imageUrl = imagePost.postImages?.isNotEmpty == true
        ? imagePost.postImages![0]
        : null;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildGridErrorPlaceholder("No image available");
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(
              images: imagePost.postImages ?? [],
              initialIndex: 0,
              heroTag: imageUrl,
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
            placeholder: (context, url) => _buildGridLoadingPlaceholder(),
            errorWidget: (context, url, error) =>
                _buildGridErrorPlaceholder("Image load failed"),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoGridItem(BuildContext context, int index) {
    if (index >= controller.videoPostList.length) {
      return _buildGridErrorPlaceholder("Invalid video index");
    }

    final videoPost = controller.videoPostList[index];

    return Obx(() {
      // Use the safe getter methods from controller
      final videoController = controller.getVideoController(index);
      final isInitialized = controller.isVideoReady(index);
      final hasError = controller.hasVideoError(index);

      if (hasError) {
        return _buildGridErrorPlaceholder("Video failed to load");
      }

      if (videoController == null) {
        return _buildGridLoadingPlaceholder();
      }

      return GestureDetector(
        onTap: () {
          // Open full-screen video player
          if (videoPost.video != null && videoPost.video!.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FullScreenVideoViewer(
                  videoUrl: videoPost.video!,
                  caption: videoPost.caption,
                  heroTag: 'video_${videoPost.id}',
                ),
              ),
            );
          }
        },
        child: Hero(
          tag: 'video_${videoPost.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Video thumbnail
                if (isInitialized)
                  FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoController.value.size.width,
                      height: videoController.value.size.height,
                      child: VideoPlayer(videoController),
                    ),
                  )
                else
                  _buildGridLoadingPlaceholder(),

                // Play icon overlay
                if (isInitialized)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                // Loading indicator
                if (!isInitialized && !hasError)
                  Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}