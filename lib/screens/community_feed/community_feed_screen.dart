import 'package:the_friendz_zone/screens/create_post/create_post_screen.dart';

import '../../config/app_config.dart';
import '../../widgets/custom_bottom_sheet.dart';
import 'community_feed_controller.dart';
import 'widgets/community_post_card.dart';

class CommunityFeedScreen extends StatelessWidget {
  final String communityName;
  final String communityId;

  const CommunityFeedScreen({
    Key? key,
    required this.communityName,
    required this.communityId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.findOrPut(CommunityFeedController()).getFeed(communityId);
    return GetBuilder<CommunityFeedController>(
      init: CommunityFeedController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackgroundColor,
          body: SafeArea(
            child: controller.isLoading.value ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ).align(),
                  ],
                )
                :Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dimen16,
                    AppDimens.dimen16,
                    AppDimens.dimen16,
                    AppDimens.dimen2,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: EdgeInsets.only(right: AppDimens.dimen12),
                          child: Image.asset(
                            AppImages.backArrow,
                            height: AppDimens.dimen14,
                            width: AppDimens.dimen14,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimens.dimen10),
                      Text(
                        communityName,
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          AppDialogs.showConfirmationDialog(
                            title: AppStrings.dialogCreatePostTitle,
                            description: AppStrings.dialogCreatePostDescription,
                            iconAsset: AppImages.addIcon,
                            iconBgColor:
                                AppColors.primaryColor.withOpacity(0.13),
                            // iconColor: AppColors.primaryColor,
                            confirmButtonText: AppStrings.createPost,
                            onConfirm: () {
                              Get.to(
                                () => CreatePostScreen(
                                    comingFromScreen: 'community_feed',
                                  communityId: communityId,
                                ),
                              )?.then((value) {
                                  controller.getFeed(communityId);
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBgColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.textColor3,
                                size: 18,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                AppStrings.createNewPost,
                                style: TextStyle(
                                  color: AppColors.textColor3,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontSize: FontDimen.dimen13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: (controller.posts.value.data?.length??0) < 1 ?
                    Text(
                    'No posts available in this community.'
                ).align() :
                      Obx(
                    () => ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.dimen10,
                        vertical: AppDimens.dimen6,
                      ),
                      itemCount: controller.posts.value.data?.length??0,
                      itemBuilder: (context, index) {
                        return CommunityPostCard(
                            key: ValueKey(controller.posts.value.data![index].communityId),
                            post: controller.posts.value.data![index],
                            communityName: communityName,
                            onMenu: () {
                              showActionSheet(
                                context,
                                actions: [
                                  // Edit Post Option
                                  SheetAction(
                                    text: AppStrings.editPost,
                                    iconAsset: AppImages.editIcon,
                                    onTap: () {
                                      AppDialogs.showConfirmationDialog(
                                        title: AppStrings.editPost,
                                        description:
                                            AppStrings.dialogEditPostMessage,
                                        iconAsset: AppImages.editIcon,
                                        iconBgColor: AppColors.primaryColor
                                            .withOpacity(0.13),
                                        iconColor: AppColors.primaryColor,
                                        confirmButtonText: AppStrings.doneText,
                                        onConfirm: () {
                                          // edit post logic here
                                        },
                                      );
                                    },
                                  ),
                                  // Delete Post Option
                                  SheetAction(
                                    text: AppStrings.deletePost,
                                    iconAsset: AppImages.deleteIcon,
                                    onTap: () {
                                      AppDialogs.showConfirmationDialog(
                                        title: AppStrings.deletePost,
                                        description:
                                            AppStrings.dialogDeletePostMessage,
                                        iconAsset: AppImages.deleteIcon,
                                        iconBgColor: AppColors.redColor
                                            .withOpacity(0.13),
                                        iconColor: AppColors.redColor,
                                        confirmButtonText:
                                            AppStrings.deletePost,
                                        confirmButtonColor: AppColors.redColor,
                                        onConfirm: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  AppColors.cardBehindBg,
                                              content: Text(
                                                AppStrings.postDeletedSnackbar,
                                                style: TextStyle(
                                                  color: AppColors.redColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                          // delete post logic here
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
