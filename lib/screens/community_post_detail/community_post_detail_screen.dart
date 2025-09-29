import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_config.dart';
import '../../utils/app_cache_manager.dart';
import '../home/models/post_list_response.dart';
import '../home/models/post_model.dart';
import 'community_post_detail_controller.dart';
import 'widgets/comment_item.dart';

class CommunityPostDetailScreen extends StatefulWidget {
  final String communityName;
  final Posts post;

  const CommunityPostDetailScreen({
    Key? key,
    required this.communityName,
    required this.post,
  }) : super(key: key);

  @override
  State<CommunityPostDetailScreen> createState() =>
      _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  int _currentImage = 0;
  late final PageController _pageController;

  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final controller = Get.findOrPut(CommunityPostDetailController());
    controller.fetchComments(widget.post.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityPostDetailController());
    final post = widget.post;
    final images = post.images ?? [];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: <Widget>[
              // ----- Top Bar -----
              SliverToBoxAdapter(
                // Use SliverToBoxAdapter for non-scrollable widgets in CustomScrollView
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dimen16,
                    AppDimens.dimen22,
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
                      Expanded(
                        child: Text(
                          widget.communityName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontSize: FontDimen.dimen18 - 1,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: AppDimens.dimen12),
                        child: Image.asset(
                          AppImages.backArrow,
                          height: AppDimens.dimen14,
                          width: AppDimens.dimen14,
                          color: AppColors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Post Header ---
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: post.image ?? '',
                              fit: BoxFit.cover,
                              width: AppDimens.dimen40 + 8,
                              height: AppDimens.dimen40 + 8,
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
                          const SizedBox(width: 10),
                          // Name, handle, post text, tags
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.username??'',
                                  style: TextStyle(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontDimen.dimen14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                    'post.userHandle',
                                  style: TextStyle(
                                    color: AppColors.textColor4.withOpacity(1),
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontDimen.dimen11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    post.userId == StorageHelper().getUserId.toString()
                        ? Positioned(
                            top: -1,
                            right: 4,
                            child: IconButton(
                              icon: Image.asset(
                                AppImages.threeDottedMenu,
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {},
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: 8),
              ),

              // Post Text
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.caption ?? '',
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: FontDimen.dimen12,
                        ),
                      ),
                      // Tags
                      // if (post.hashtags.isNotEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 1, right: 20),
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
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 9)),

              // --- Post Images (Single or Multiple with Dots) ---
              if (images.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.dimen14,
                                    ),
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
                ),
              SliverToBoxAdapter(
                child: const SizedBox(height: 9),
              ),

              // Likes & Comments Row
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
                            post.likeCount ?? '0',
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
                            post.commentCount??'0',
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
              ),

              // --- COMMENTS LIST: Takes Remaining Height & Scrolls ---
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                sliver: Obx(
                  () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final comment = controller.comments.value.data?[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CommentItem(
                            comment: comment!,
                            onReply: () {
                             // controller.setReplyingTo(comment);

                              _commentFocusNode.requestFocus();
                            },
                            replyingTo: false,
                            onAddReply: (value){},
                            // replyingTo: controller.replyingTo.value?.id == comment.id,
                            // onAddReply: (replyText) => controller.addReply(
                            //   comment.id,
                            //   replyText,
                            //),
                          ),
                        );
                      },
                      childCount: controller.comments.value.data?.length ?? 0,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: 18),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.dimen12,
            0,
            AppDimens.dimen12,
            MediaQuery.of(context).viewInsets.bottom > 0
                ? MediaQuery.of(context).viewInsets.bottom + AppDimens.dimen12
                : AppDimens.dimen24,
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => TextField(
                    focusNode: _commentFocusNode,
                    controller: controller.commentController,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(1),
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: FontDimen.dimen12,
                    ),
                    decoration: InputDecoration(
                      hintText: controller.replyingTo.value == null
                          ? AppStrings.addComment
                          : 'Reply to @{controller.replyingTo.value?.userName}',
                      hintStyle: TextStyle(
                        color: AppColors.textColor3.withOpacity(0.7),
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: FontDimen.dimen12,
                      ),
                      filled: true,
                      fillColor: AppColors.cardBgColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 22,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        if (controller.replyingTo.value == null) {
                          controller.postComment(widget.post.id);
                        } else {
                          // controller.addReply(
                          //     controller.replyingTo.value!.id, val.trim());
                        }
                        // Optional: Unfocus after submitting
                        _commentFocusNode.unfocus();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dimen8),
              GestureDetector(
                onTap: () async {
                  final val = controller.commentController.text.trim();
                  if (val.isNotEmpty) {
                    if (controller.replyingTo.value == null) {
                    var isSuccess =  await controller.postComment(widget.post.id);
                    if(isSuccess){
                      widget.post.commentCount = ((int.tryParse(widget.post.commentCount ?? '0') ?? 0) + 1).toString();
                    }
                    }
                    else {
                   //   controller.addReply(controller.replyingTo.value!.id, val);
                    }
                    // Optional: Unfocus after sending
                    _commentFocusNode.unfocus();
                  }
                },
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.textColor4,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(
                        AppImages.sendFilledIcon,
                        height: AppDimens.dimen35,
                        width: AppDimens.dimen35,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
