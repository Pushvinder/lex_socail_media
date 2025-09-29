import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
import '../../../config/app_config.dart';
import '../../../models/community_feed_model.dart';
import '../../../utils/app_cache_manager.dart';
import '../../community_post_detail/community_post_detail_screen.dart';
import '../../home/models/post_model.dart';

class CommunityPostCard extends StatefulWidget {
  final String communityName;
  final Data post;
  final VoidCallback? onMenu;

  const CommunityPostCard({
    Key? key,
    required this.communityName,
    required this.post,
    this.onMenu,
  }) : super(key: key);

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
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
    final images = post.postImages ?? [];

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBgColor,
            borderRadius: BorderRadius.circular(AppDimens.dimen18),
          ),
          padding: EdgeInsets.all(AppDimens.dimen16),
          margin: EdgeInsets.only(bottom: AppDimens.dimen20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: post.profile??'',
                      fit: BoxFit.cover,
                      width: AppDimens.dimen40 + 6,
                      height: AppDimens.dimen40 + 6,
                      fadeInDuration: const Duration(milliseconds: 400),
                      cacheManager: appCacheManager,
                      useOldImageOnUrlChange: true,
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
                  SizedBox(width: AppDimens.dimen12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppDimens.dimen3),
                      Text(
                        post.username??'',
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.w500,
                          fontSize: FontDimen.dimen14,
                        ),
                      ),
                      // Text(
                      //   post.userHandle,
                      //   style: TextStyle(
                      //     color: AppColors.textColor4,
                      //     fontFamily: GoogleFonts.inter().fontFamily,
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: FontDimen.dimen10,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppDimens.dimen16),
              Text(
                post.caption??'',
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(1),
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen12,
                  height: 1.5,
                ),
              ),
              // if (post.hashtags.isNotEmpty)
              //   Padding(
              //     padding: EdgeInsets.only(top: 0),
              //     child: Text(
              //       post.hashtags.map((tag) => '#$tag').join('  '),
              //       style: TextStyle(
              //         color: AppColors.textColor5,
              //         fontFamily: GoogleFonts.inter().fontFamily,
              //         fontWeight: FontWeight.w500,
              //         fontSize: FontDimen.dimen11,
              //         height: 1.55,
              //         letterSpacing: 0.13,
              //       ),
              //     ),
              //   ),
              SizedBox(height: AppDimens.dimen12 + 1),
              // --- Post Images (Single or Multiple with Dots) ---
              if (images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: images.length == 1
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppDimens.dimen14),
                          child: CachedNetworkImage(
                            imageUrl: images.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 206,
                            fadeInDuration: const Duration(milliseconds: 400),
                            cacheManager: appCacheManager,
                            useOldImageOnUrlChange: true,
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
                                  borderRadius:
                                      BorderRadius.circular(AppDimens.dimen14),
                                  child: CachedNetworkImage(
                                    imageUrl: images[idx],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 206,
                                    fadeInDuration:
                                        const Duration(milliseconds: 400),
                                    cacheManager: appCacheManager,
                                    useOldImageOnUrlChange: true,
                                    placeholder: (context, url) => Container(
                                        color: AppColors.greyShadeColor),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: AppColors.greyShadeColor,
                                      child: Icon(
                                        Icons.person,
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
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
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
              SizedBox(height: AppDimens.dimen18),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => CommunityPostDetailScreen(
                      communityName: widget.communityName,
                      post: Posts.fromJson(post.toJson(),
                    ),
                  ));
                },
                child: Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppImages.like,
                          height: AppDimens.dimen24,
                          width: AppDimens.dimen24,
                        ),
                        SizedBox(width: AppDimens.dimen6),
                        Text(
                          post.likeCount.toString()??'0',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: FontDimen.dimen12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppDimens.dimen24),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.comments,
                          height: AppDimens.dimen24,
                          width: AppDimens.dimen24,
                        ),
                        SizedBox(
                          width: AppDimens.dimen6,
                        ),
                        Text(
                          post.commentCount.toString(),
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: FontDimen.dimen12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimens.dimen5),
            ],
          ),
        ),
        // post.isOwner
        //     ? Positioned(
        //         top: -1,
        //         right: 4,
        //         child: IconButton(
        //           icon: Image.asset(
        //             AppImages.threeDottedMenu,
        //             width: 20,
        //             height: 20,
        //           ),
        //           onPressed: widget.onMenu,
        //         ),
        //       )
        //     : Container(),
      ],
    );
  }
}
