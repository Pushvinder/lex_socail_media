import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
import 'package:the_friendz_zone/screens/user_profile/user_profile_screen.dart';
import '../../../config/app_config.dart';
import '../../community_post_detail/community_post_detail_screen.dart';
import '../models/post_model.dart';
import '../../../widgets/custom_bottom_sheet.dart';
import 'package:the_friendz_zone/widgets/comment_bottom_sheet.dart';

class PostCardWidget extends StatefulWidget {
  final String communityName;
  final Posts post;
  final VoidCallback onDelete;
  final VoidCallback onLike;

  const PostCardWidget({
    super.key,
    required this.communityName,
    required this.post,
    required this.onDelete,
    required this.onLike,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  int _currentImage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final List<String> images = post.images ?? [];

    final int userId = StorageHelper().getUserId ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 0),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Post Header ---
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 5, 0),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image:
                              (post.profile != null && post.profile!.isNotEmpty)
                                  ? null
                                  : DecorationImage(
                                      image: AssetImage(AppImages.profile),
                                      fit: BoxFit.cover,
                                    ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: post.profile ?? '',
                            fit: BoxFit.cover,
                            width: 35,
                            height: 35,
                            fadeInDuration: Duration(milliseconds: 400),
                            placeholder: (context, url) =>
                                Container(color: AppColors.greyShadeColor),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.greyShadeColor,
                              child: Icon(
                                Icons.person,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      // Name + handle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.fullname ?? '',
                            style: TextStyle(
                              color: AppColors.textColor3.withOpacity(1),
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.w500,
                              fontSize: FontDimen.dimen16,
                            ),
                          ).asButton(onTap: () {
                            Get.to(() => UserProfileScreen(
                                  userId: post.userId ?? '',
                                ));
                          }),
                          Text(
                            post.username ?? '',
                            style: TextStyle(
                              color: AppColors.textColor4.withOpacity(1),
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontWeight: FontWeight.w500,
                              fontSize: FontDimen.dimen11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ui for the three dots option available to user if the post is it their own post
              if (post.userId == userId.toString())
                Positioned(
                  top: 12,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      showActionSheet(
                        context,
                        actions: [
                          SheetAction(
                            text: AppStrings.editPost,
                            iconAsset: AppImages.editIcon,
                            onTap: () {
                              AppDialogs.showConfirmationDialog(
                                title: AppStrings.editPost,
                                description: AppStrings.dialogEditPostMessage,
                                iconAsset: AppImages.editIcon,
                                iconBgColor:
                                    AppColors.primaryColor.withOpacity(0.13),
                                iconColor: AppColors.primaryColor,
                                cancelButtonText: AppStrings.no,
                                confirmButtonText: AppStrings.yes,
                                onConfirm: () {},
                              );
                            },
                          ),
                          SheetAction(
                            text: AppStrings.deletePost,
                            iconAsset: AppImages.deleteIcon,
                            onTap: () {
                              AppDialogs.showConfirmationDialog(
                                title: AppStrings.deletePost,
                                description: AppStrings.dialogDeletePostMessage,
                                iconAsset: AppImages.deleteIcon,
                                iconBgColor:
                                    AppColors.redColor.withOpacity(0.13),
                                iconColor: AppColors.redColor,
                                confirmButtonText: AppStrings.deletePost,
                                confirmButtonColor: AppColors.redColor,
                                onConfirm: () {
                                  widget.onDelete();
                                  // ScaffoldMessenger.of(context).showSnackBar(

                                  // );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                    child: Image.asset(
                      AppImages.threeDottedMenu,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
            ],
          ),

          // --- Post Text & Hashtags ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 11, 16, 0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(1),
                  fontFamily: GoogleFonts.inter().fontFamily,
                  height: 1.38,
                  fontSize: FontDimen.dimen8,
                ),
                children: [
                  TextSpan(
                    text: post.caption ?? '',
                    style: TextStyle(
                      fontSize: FontDimen.dimen12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // TODO:UPDATE HASTAGS NOT AVAILABLE RIGHT NOW
                  // if (post..isNotEmpty)
                  //   TextSpan(
                  //     text:
                  //         "\n" + post.hashtags.map((tag) => "#$tag").join("  "),
                  //     style: TextStyle(
                  //       height: 1.5,
                  //       fontSize: FontDimen.dimen11,
                  //       color: AppColors.textColor5,
                  //       fontWeight: FontWeight.w500,
                  //       letterSpacing: 0.13,
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),

          // --- Post Images (Single or Multiple with Dots) ---
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: images.length == 1
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: CachedNetworkImage(
                        imageUrl: images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 206,
                        fadeInDuration: Duration(milliseconds: 500),
                        placeholder: (context, url) =>
                            Container(color: AppColors.greyShadeColor),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.greyShadeColor,
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        SizedBox(
                          height: 206,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (i) => setState(() {
                              _currentImage = i;
                            }),
                            itemBuilder: (context, idx) => ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: CachedNetworkImage(
                                imageUrl: images[idx],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 206,
                                fadeInDuration: Duration(milliseconds: 500),
                                placeholder: (context, url) =>
                                    Container(color: AppColors.greyShadeColor),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.greyShadeColor,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppColors.greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              images.length,
                              (idx) => GestureDetector(
                                onTap: () {
                                  _pageController.animateToPage(
                                    idx,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: idx == _currentImage
                                        ? Colors.white
                                        : AppColors.greyColorShade
                                            .withOpacity(1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

          // --- Likes & Comments Row ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 13),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => CommunityPostDetailScreen(
                    communityName: widget.communityName,
                    post: widget.post,
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.scaffoldBackgroundColor,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 3),
                        InkWell(
                          onTap: () {
                            widget.onLike();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              AppImages.like,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          post.likeCount ?? '0',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: FontDimen.dimen13,
                          ),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.scaffoldBackgroundColor,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 3),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   isScrollControlled: true,
                              //   builder: (context) => CommentBottomSheet(
                              //     postId: post.id ?? '',
                              //   ),
                              // ).then((count) {
                              //   if (count != null && count is String) {
                              //     setState(() {
                              //       post.commentCount = count;
                              //     });
                              //   }
                              // });
                            },
                            child: Image.asset(
                              AppImages.comments,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          post.commentCount ?? '0',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: FontDimen.dimen13,
                          ),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    ).asButton(onTap: (){
      Get.to(() => CommunityPostDetailScreen(
        communityName: widget.communityName,
        post: widget.post,
      ));
    });
  }
}
