import 'package:cached_network_image/cached_network_image.dart';
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
      child:
       Center(
        child: Text(
      message
          // color: AppColors.textColor5.withOpacity(0.65),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() => 
    (controller.isPhotosTab.value && controller.imagePostList.isEmpty ) || (!controller.isPhotosTab.value && controller.videoPostList.isEmpty) ?
 _noPostError(ErrorMessages.noPostError)
    :
    SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount:
              controller.isPhotosTab.value ? controller.imagePostList.value.length : controller.videoPostList.value.length,
              (BuildContext context, int index) {
                // return Container();
                if (controller.isPhotosTab.value) {
                  if (index >= controller.imagePostList.length)
                    return const SizedBox.shrink();
                  final imageUrl = controller.imagePostList[index].postImages?[0];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FullScreenImageViewer(
                            images: controller.imagePostList[index].postImages ?? [],
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: imageUrl ?? '',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _buildGridLoadingPlaceholder(),
                          errorWidget: (context, url, error) =>
                              _buildGridErrorPlaceholder("Image load failed"),
                        ),
                      ),
                    ),
                  );
                } else {
                  // return _buildGridErrorPlaceholder("Controller error");
                  if (index >= controller.videoPostList.length ||
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
                                // videoController.play();
                                videoController.pause();
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
              },
             
            ),
          ),
        ));
  }
}
