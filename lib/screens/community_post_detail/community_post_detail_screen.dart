// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../config/app_config.dart';
// import '../../utils/app_cache_manager.dart';
// import '../../widgets/custom_bottom_sheet.dart';
// import '../create_post/create_post_screen.dart';
// import '../home/home_controller.dart';
// import '../home/models/post_list_response.dart';
// import '../home/models/post_model.dart';
// import 'community_post_detail_controller.dart';
// import 'widgets/comment_item.dart';

// class CommunityPostDetailScreen extends StatefulWidget {
//   final String communityName;
//   final Posts post;

//   const CommunityPostDetailScreen({
//     Key? key,
//     required this.communityName,
//     required this.post,
//   }) : super(key: key);

//   @override
//   State<CommunityPostDetailScreen> createState() =>
//       _CommunityPostDetailScreenState();
// }

// class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
//   int _currentImage = 0;
//   late final PageController _pageController;
//   final FocusNode _commentFocusNode = FocusNode();

//   // Get HomeController instance (SAME as in HomeScreen)
//   final HomeController homeController = Get.find<HomeController>();

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     final controller = Get.findOrPut(CommunityPostDetailController());
//     controller.fetchComments(widget.post.id);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _commentFocusNode.dispose();
//     super.dispose();
//   }

//   // ===== EDIT POST METHOD =====
//   void _editPost() {
//     // Same as in PostCardWidget
//     AppDialogs.showConfirmationDialog(
//       title: AppStrings.editPost,
//       description: AppStrings.dialogEditPostMessage,
//       iconAsset: AppImages.editIcon,
//       iconBgColor: AppColors.primaryColor.withOpacity(0.13),
//       iconColor: AppColors.primaryColor,
//       cancelButtonText: AppStrings.no,
//       confirmButtonText: AppStrings.yes,
//       onConfirm: () {
//         Get.to(() => CreatePostScreen(
//               comingFromScreen: "edit_post",
//               communityId: widget.post.userId ?? "",
//               post: widget.post, // Pass the post data for editing
//               isEditing: true,
//             ));
//       },
//       onCancel: () {
//         Get.back(closeOverlays: true);
//       },
//     );
//   }

//   // ===== DELETE POST METHOD =====
//   void _deletePost() {
//     // Same as in PostCardWidget
//     AppDialogs.showConfirmationDialog(
//       title: AppStrings.deletePost,
//       description: AppStrings.dialogDeletePostMessage,
//       iconAsset: AppImages.deleteIcon,
//       iconBgColor: AppColors.redColor.withOpacity(0.13),
//       iconColor: AppColors.redColor,
//       confirmButtonText: AppStrings.deletePost,
//       confirmButtonColor: AppColors.redColor,
//       onConfirm: () async {
//         // Find the index of this post in HomeController's posts list
//         final postIndex = homeController.posts
//             .indexWhere((post) => post.id == widget.post.id);

//         if (postIndex != -1) {
//           // Call the SAME deletePost method that PostCardWidget uses
//           await homeController.deletePost(widget.post.id ?? '', postIndex);

//           // Navigate back to HomeScreen
//           Get.back();

//           // Show success message
//           Get.snackbar(
//             'Success',
//             'Post deleted successfully',
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         } else {
//           // If post not found in list (shouldn't happen), still delete
//           await homeController.deletePost(widget.post.id ?? '', 0);
//           Get.back();
//         }
//       },
//       onCancel: () {
//         Get.back(closeOverlays: true);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CommunityPostDetailController());
//     final post = widget.post;
//     final images = post.images ?? [];

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: CustomScrollView(
//             slivers: <Widget>[
//               // ----- Top Bar -----
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                     AppDimens.dimen16,
//                     AppDimens.dimen22,
//                     AppDimens.dimen16,
//                     AppDimens.dimen2,
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.back(closeOverlays: true);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(right: AppDimens.dimen12),
//                           child: Image.asset(
//                             AppImages.backArrow,
//                             height: AppDimens.dimen14,
//                             width: AppDimens.dimen14,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           widget.communityName,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen18 - 1,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: AppDimens.dimen12),
//                         child: Image.asset(
//                           AppImages.backArrow,
//                           height: AppDimens.dimen14,
//                           width: AppDimens.dimen14,
//                           color: AppColors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // --- Post Header (WITH THREE DOTS MENU) ---
//               SliverToBoxAdapter(
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Avatar
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(100),
//                             child: CachedNetworkImage(
//                               imageUrl: post.image ?? '',
//                               fit: BoxFit.cover,
//                               width: AppDimens.dimen40 + 8,
//                               height: AppDimens.dimen40 + 8,
//                               fadeInDuration: const Duration(milliseconds: 400),
//                               cacheManager: appCacheManager,
//                               useOldImageOnUrlChange: true,
//                               placeholder: (context, url) =>
//                                   Container(color: AppColors.greyShadeColor),
//                               errorWidget: (context, url, error) => Container(
//                                 color: AppColors.greyShadeColor,
//                                 child: Icon(
//                                   Icons.person,
//                                   color: AppColors.greyColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           // Name, handle
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   post.username ?? '',
//                                   style: TextStyle(
//                                     color: AppColors.textColor3.withOpacity(1),
//                                     fontFamily: AppFonts.appFont,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: FontDimen.dimen14,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'post.userHandle',
//                                   style: TextStyle(
//                                     color: AppColors.textColor4.withOpacity(1),
//                                     fontFamily: GoogleFonts.inter().fontFamily,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: FontDimen.dimen11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // ===== THREE DOTS MENU (SAME AS PostCardWidget) =====
//                     post.userId == StorageHelper().getUserId.toString()
//                         ? Positioned(
//                             top: -1,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () {
//                                 // Show the same action sheet as PostCardWidget
//                                 showActionSheet(
//                                   context,
//                                   actions: [
//                                     SheetAction(
//                                       text: AppStrings.editPost,
//                                       iconAsset: AppImages.editIcon,
//                                       onTap: _editPost,
//                                     ),
//                                     SheetAction(
//                                       text: AppStrings.deletePost,
//                                       iconAsset: AppImages.deleteIcon,
//                                       onTap: _deletePost,
//                                     ),
//                                   ],
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Image.asset(
//                                   AppImages.threeDottedMenu,
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ],
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: const SizedBox(height: 8),
//               ),

//               // Post Text
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         post.caption ?? '',
//                         style: TextStyle(
//                           color: AppColors.textColor3.withOpacity(1),
//                           fontFamily: GoogleFonts.inter().fontFamily,
//                           fontWeight: FontWeight.w400,
//                           fontSize: FontDimen.dimen12,
//                         ),
//                       ),
//                       // Tags
//                       // if (post.hashtags.isNotEmpty)
//                       //   Padding(
//                       //     padding: const EdgeInsets.only(top: 1, right: 20),
//                       //     child: Text(
//                       //       post.hashtags.map((tag) => '#$tag').join('  '),
//                       //       style: TextStyle(
//                       //         color: AppColors.textColor5,
//                       //         fontFamily: GoogleFonts.inter().fontFamily,
//                       //         fontWeight: FontWeight.w500,
//                       //         fontSize: FontDimen.dimen11,
//                       //         height: 1.55,
//                       //         letterSpacing: 0.13,
//                       //       ),
//                       //     ),
//                       //   ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(child: const SizedBox(height: 9)),

//               // --- Post Images (Single or Multiple with Dots) ---
//               if (images.isNotEmpty)
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: images.length == 1
//                         ? ClipRRect(
//                             borderRadius:
//                                 BorderRadius.circular(AppDimens.dimen14),
//                             child: CachedNetworkImage(
//                               imageUrl: images.first,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: 206,
//                               fadeInDuration: const Duration(milliseconds: 400),
//                               cacheManager: appCacheManager,
//                               useOldImageOnUrlChange: true,
//                               placeholder: (context, url) =>
//                                   Container(color: AppColors.greyShadeColor),
//                               errorWidget: (context, url, error) => Container(
//                                 color: AppColors.greyShadeColor,
//                                 child: Icon(
//                                   Icons.person,
//                                   color: AppColors.greyColor,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Stack(
//                             children: [
//                               SizedBox(
//                                 height: 206,
//                                 width: double.infinity,
//                                 child: PageView.builder(
//                                   controller: _pageController,
//                                   itemCount: images.length,
//                                   onPageChanged: (i) => setState(() {
//                                     _currentImage = i;
//                                   }),
//                                   itemBuilder: (context, idx) => ClipRRect(
//                                     borderRadius: BorderRadius.circular(
//                                       AppDimens.dimen14,
//                                     ),
//                                     child: CachedNetworkImage(
//                                       imageUrl: images[idx],
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                       height: 206,
//                                       fadeInDuration:
//                                           const Duration(milliseconds: 400),
//                                       cacheManager: appCacheManager,
//                                       useOldImageOnUrlChange: true,
//                                       placeholder: (context, url) => Container(
//                                           color: AppColors.greyShadeColor),
//                                       errorWidget: (context, url, error) =>
//                                           Container(
//                                         color: AppColors.greyShadeColor,
//                                         child: Icon(
//                                           Icons.person,
//                                           color: AppColors.greyColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 12,
//                                 left: 0,
//                                 right: 0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(
//                                     images.length,
//                                     (idx) => GestureDetector(
//                                       onTap: () {
//                                         _pageController.animateToPage(
//                                           idx,
//                                           duration:
//                                               const Duration(milliseconds: 300),
//                                           curve: Curves.easeInOut,
//                                         );
//                                       },
//                                       child: Container(
//                                         width: 10,
//                                         height: 10,
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 4),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: idx == _currentImage
//                                               ? Colors.white
//                                               : AppColors.greyColorShade
//                                                   .withOpacity(1),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               SliverToBoxAdapter(
//                 child: const SizedBox(height: 9),
//               ),

//               // Likes & Comments Row
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//                   child: Row(
//                     children: [
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.like,
//                             height: AppDimens.dimen24,
//                             width: AppDimens.dimen24,
//                           ),
//                           SizedBox(width: AppDimens.dimen6),
//                           Text(
//                             post.likeCount ?? '0',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: AppDimens.dimen24),
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.comments,
//                             height: AppDimens.dimen24,
//                             width: AppDimens.dimen24,
//                           ),
//                           SizedBox(
//                             width: AppDimens.dimen6,
//                           ),
//                           Text(
//                             post.commentCount ?? '0',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // --- COMMENTS LIST: Takes Remaining Height & Scrolls ---
//               SliverPadding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 sliver: Obx(
//                   () => SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final comment = controller.comments.value.data?[index];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: CommentItem(
//                             comment: comment!,
//                             onReply: () {
//                               // controller.setReplyingTo(comment);

//                               _commentFocusNode.requestFocus();
//                             },
//                             replyingTo: false,
//                             onAddReply: (value) {},
//                             // replyingTo: controller.replyingTo.value?.id == comment.id,
//                             // onAddReply: (replyText) => controller.addReply(
//                             //   comment.id,
//                             //   replyText,
//                             //),
//                           ),
//                         );
//                       },
//                       childCount: controller.comments.value.data?.length ?? 0,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: const SizedBox(height: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//             AppDimens.dimen12,
//             0,
//             AppDimens.dimen12,
//             MediaQuery.of(context).viewInsets.bottom > 0
//                 ? MediaQuery.of(context).viewInsets.bottom + AppDimens.dimen12
//                 : AppDimens.dimen24,
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Obx(
//                   () => TextField(
//                     focusNode: _commentFocusNode,
//                     controller: controller.commentController,
//                     style: TextStyle(
//                       color: AppColors.whiteColor.withOpacity(1),
//                       fontFamily: GoogleFonts.inter().fontFamily,
//                       fontSize: FontDimen.dimen12,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: controller.replyingTo.value == null
//                           ? AppStrings.addComment
//                           : 'Reply to @{controller.replyingTo.value?.userName}',
//                       hintStyle: TextStyle(
//                         color: AppColors.textColor3.withOpacity(0.7),
//                         fontFamily: GoogleFonts.inter().fontFamily,
//                         fontSize: FontDimen.dimen12,
//                       ),
//                       filled: true,
//                       fillColor: AppColors.cardBgColor,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 22,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onSubmitted: (val) {
//                       if (val.trim().isNotEmpty) {
//                         if (controller.replyingTo.value == null) {
//                           controller.postComment(widget.post.id);
//                         } else {
//                           // controller.addReply(
//                           //     controller.replyingTo.value!.id, val.trim());
//                         }
//                         // Optional: Unfocus after submitting
//                         _commentFocusNode.unfocus();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(width: AppDimens.dimen8),
//               GestureDetector(
//                 onTap: () async {
//                   final val = controller.commentController.text.trim();
//                   if (val.isNotEmpty) {
//                     if (controller.replyingTo.value == null) {
//                       var isSuccess =
//                           await controller.postComment(widget.post.id);
//                       if (isSuccess) {
//                         widget.post.commentCount =
//                             ((int.tryParse(widget.post.commentCount ?? '0') ??
//                                         0) +
//                                     1)
//                                 .toString();
//                       }
//                     } else {
//                       //   controller.addReply(controller.replyingTo.value!.id, val);
//                     }
//                     // Optional: Unfocus after sending
//                     _commentFocusNode.unfocus();
//                   }
//                 },
//                 child: Container(
//                   width: 55,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     color: AppColors.textColor4,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: Image.asset(
//                         AppImages.sendFilledIcon,
//                         height: AppDimens.dimen35,
//                         width: AppDimens.dimen35,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import '../../config/app_config.dart';
// import '../../utils/app_cache_manager.dart';
// import '../../widgets/custom_bottom_sheet.dart';
// import '../create_post/create_post_screen.dart';
// import '../home/home_controller.dart';
// import '../home/models/post_list_response.dart';
// import '../home/models/post_model.dart';
// import 'community_post_detail_controller.dart';
// import 'widgets/comment_item.dart';

// class CommunityPostDetailScreen extends StatefulWidget {
//   final String communityName;
//   final Posts post;

//   const CommunityPostDetailScreen({
//     Key? key,
//     required this.communityName,
//     required this.post,
//   }) : super(key: key);

//   @override
//   State<CommunityPostDetailScreen> createState() =>
//       _CommunityPostDetailScreenState();
// }

// class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
//   int _currentMediaIndex = 0;
//   late final PageController _pageController;
//   final FocusNode _commentFocusNode = FocusNode();

//   // Video player
//   VideoPlayerController? _videoController;
//   Future<void>? _initializeVideoPlayerFuture;
//   bool _isVideoInitialized = false;

//   // Get HomeController instance (SAME as in HomeScreen)
//   final HomeController homeController = Get.find<HomeController>();

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _initializeVideo();
//     final controller = Get.findOrPut(CommunityPostDetailController());
//     controller.fetchComments(widget.post.id);
//   }

//   void _initializeVideo() {
//     final post = widget.post;
//     if (post.video != null && post.video!.isNotEmpty) {
//       _videoController = VideoPlayerController.network(post.video!);
//       _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
//         setState(() {
//           _isVideoInitialized = true;
//         });
//         // Auto-play video
//         _videoController!.setLooping(true);
//         _videoController!.play();
//       }).catchError((error) {
//         debugPrint("Error initializing video: $error");
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _commentFocusNode.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   // Build list of all media (images + video)
//   List<Widget> _buildMediaWidgets() {
//     final post = widget.post;
//     List<Widget> mediaWidgets = [];

//     // Add images
//     if (post.images != null && post.images!.isNotEmpty) {
//       for (String imageUrl in post.images!) {
//         mediaWidgets.add(_buildImageWidget(imageUrl));
//       }
//     }

//     // Add video
//     if (post.video != null && post.video!.isNotEmpty && _isVideoInitialized) {
//       mediaWidgets.add(_buildVideoWidget());
//     }

//     return mediaWidgets;
//   }

//   Widget _buildImageWidget(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(AppDimens.dimen14),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: 206,
//         fadeInDuration: const Duration(milliseconds: 400),
//         cacheManager: appCacheManager,
//         useOldImageOnUrlChange: true,
//         placeholder: (context, url) => Container(color: AppColors.greyShadeColor),
//         errorWidget: (context, url, error) => Container(
//           color: AppColors.greyShadeColor,
//           child: Icon(Icons.broken_image, color: AppColors.greyColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoWidget() {
//     if (_videoController == null || !_isVideoInitialized) {
//       return Container(
//         height: 206,
//         decoration: BoxDecoration(
//           color: AppColors.greyShadeColor,
//           borderRadius: BorderRadius.circular(AppDimens.dimen14),
//         ),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(AppDimens.dimen14),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             if (_videoController!.value.isPlaying) {
//               _videoController!.pause();
//             } else {
//               _videoController!.play();
//             }
//           });
//         },
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               height: 206,
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: SizedBox(
//                   width: _videoController!.value.size.width,
//                   height: _videoController!.value.size.height,
//                   child: VideoPlayer(_videoController!),
//                 ),
//               ),
//             ),
//             if (!_videoController!.value.isPlaying)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   shape: BoxShape.circle,
//                 ),
//                 padding: EdgeInsets.all(12),
//                 child: Icon(
//                   Icons.play_arrow_rounded,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ===== EDIT POST METHOD =====
//   void _editPost() {
//     AppDialogs.showConfirmationDialog(
//       title: AppStrings.editPost,
//       description: AppStrings.dialogEditPostMessage,
//       iconAsset: AppImages.editIcon,
//       iconBgColor: AppColors.primaryColor.withOpacity(0.13),
//       iconColor: AppColors.primaryColor,
//       cancelButtonText: AppStrings.no,
//       confirmButtonText: AppStrings.yes,
//       onConfirm: () {
//         Get.to(() => CreatePostScreen(
//               comingFromScreen: "edit_post",
//               communityId: widget.post.userId ?? "",
//               post: widget.post,
//               isEditing: true,
//             ));
//       },
//       onCancel: () {
//         Get.back(closeOverlays: true);
//       },
//     );
//   }

//   // ===== DELETE POST METHOD =====
//   void _deletePost() {
//     AppDialogs.showConfirmationDialog(
//       title: AppStrings.deletePost,
//       description: AppStrings.dialogDeletePostMessage,
//       iconAsset: AppImages.deleteIcon,
//       iconBgColor: AppColors.redColor.withOpacity(0.13),
//       iconColor: AppColors.redColor,
//       confirmButtonText: AppStrings.deletePost,
//       confirmButtonColor: AppColors.redColor,
//       onConfirm: () async {
//         final postIndex = homeController.posts
//             .indexWhere((post) => post.id == widget.post.id);

//         if (postIndex != -1) {
//           await homeController.deletePost(widget.post.id ?? '', postIndex);
//           Get.back();
//           Get.snackbar(
//             'Success',
//             'Post deleted successfully',
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         } else {
//           await homeController.deletePost(widget.post.id ?? '', 0);
//           Get.back();
//         }
//       },
//       onCancel: () {
//         Get.back(closeOverlays: true);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CommunityPostDetailController());
//     final post = widget.post;
//     final List<Widget> mediaWidgets = _buildMediaWidgets();

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: CustomScrollView(
//             slivers: <Widget>[
//               // ----- Top Bar -----
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                     AppDimens.dimen16,
//                     AppDimens.dimen22,
//                     AppDimens.dimen16,
//                     AppDimens.dimen2,
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.back(closeOverlays: true);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(right: AppDimens.dimen12),
//                           child: Image.asset(
//                             AppImages.backArrow,
//                             height: AppDimens.dimen14,
//                             width: AppDimens.dimen14,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           widget.communityName,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen18 - 1,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: AppDimens.dimen12),
//                         child: Image.asset(
//                           AppImages.backArrow,
//                           height: AppDimens.dimen14,
//                           width: AppDimens.dimen14,
//                           color: AppColors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // --- Post Header (WITH THREE DOTS MENU) ---
//               SliverToBoxAdapter(
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Avatar
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(100),
//                             child: CachedNetworkImage(
//                               imageUrl: post.profile ?? '',
//                               fit: BoxFit.cover,
//                               width: AppDimens.dimen40 + 8,
//                               height: AppDimens.dimen40 + 8,
//                               fadeInDuration: const Duration(milliseconds: 400),
//                               cacheManager: appCacheManager,
//                               useOldImageOnUrlChange: true,
//                               placeholder: (context, url) =>
//                                   Container(color: AppColors.greyShadeColor),
//                               errorWidget: (context, url, error) => Container(
//                                 color: AppColors.greyShadeColor,
//                                 child: Icon(
//                                   Icons.person,
//                                   color: AppColors.greyColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           // Name, handle
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   post.fullname ?? '',
//                                   style: TextStyle(
//                                     color: AppColors.textColor3.withOpacity(1),
//                                     fontFamily: AppFonts.appFont,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: FontDimen.dimen14,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   post.username ?? '',
//                                   style: TextStyle(
//                                     color: AppColors.textColor4.withOpacity(1),
//                                     fontFamily: GoogleFonts.inter().fontFamily,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: FontDimen.dimen11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // ===== THREE DOTS MENU =====
//                     post.userId == StorageHelper().getUserId.toString()
//                         ? Positioned(
//                             top: -1,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () {
//                                 showActionSheet(
//                                   context,
//                                   actions: [
//                                     SheetAction(
//                                       text: AppStrings.editPost,
//                                       iconAsset: AppImages.editIcon,
//                                       onTap: _editPost,
//                                     ),
//                                     SheetAction(
//                                       text: AppStrings.deletePost,
//                                       iconAsset: AppImages.deleteIcon,
//                                       onTap: _deletePost,
//                                     ),
//                                   ],
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Image.asset(
//                                   AppImages.threeDottedMenu,
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ],
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: const SizedBox(height: 8),
//               ),

//               // Post Text
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         post.caption ?? '',
//                         style: TextStyle(
//                           color: AppColors.textColor3.withOpacity(1),
//                           fontFamily: GoogleFonts.inter().fontFamily,
//                           fontWeight: FontWeight.w400,
//                           fontSize: FontDimen.dimen12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(child: const SizedBox(height: 9)),

//               // --- Post Media (Images + Video with Dots) ---
//               if (mediaWidgets.isNotEmpty)
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: mediaWidgets.length == 1
//                         ? mediaWidgets.first
//                         : Stack(
//                             children: [
//                               SizedBox(
//                                 height: 206,
//                                 width: double.infinity,
//                                 child: PageView.builder(
//                                   controller: _pageController,
//                                   itemCount: mediaWidgets.length,
//                                   onPageChanged: (i) {
//                                     setState(() {
//                                       _currentMediaIndex = i;
//                                     });
                                    
//                                     // Pause video when swiping away
//                                     if (_videoController != null && _videoController!.value.isPlaying) {
//                                       _videoController!.pause();
//                                     }
//                                   },
//                                   itemBuilder: (context, idx) => mediaWidgets[idx],
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 12,
//                                 left: 0,
//                                 right: 0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(
//                                     mediaWidgets.length,
//                                     (idx) => GestureDetector(
//                                       onTap: () {
//                                         _pageController.animateToPage(
//                                           idx,
//                                           duration: const Duration(milliseconds: 300),
//                                           curve: Curves.easeInOut,
//                                         );
//                                       },
//                                       child: Container(
//                                         width: 10,
//                                         height: 10,
//                                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: idx == _currentMediaIndex
//                                               ? Colors.white
//                                               : AppColors.greyColorShade.withOpacity(1),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               SliverToBoxAdapter(
//                 child: const SizedBox(height: 9),
//               ),

//               // Likes & Comments Row
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//                   child: Row(
//                     children: [
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.like,
//                             height: AppDimens.dimen24,
//                             width: AppDimens.dimen24,
//                           ),
//                           SizedBox(width: AppDimens.dimen6),
//                           Text(
//                             post.likeCount ?? '0',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: AppDimens.dimen24),
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.comments,
//                             height: AppDimens.dimen24,
//                             width: AppDimens.dimen24,
//                           ),
//                           SizedBox(
//                             width: AppDimens.dimen6,
//                           ),
//                           Text(
//                             post.commentCount ?? '0',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // --- COMMENTS LIST ---
//               SliverPadding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 sliver: Obx(
//                   () => SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final comment = controller.comments.value.data?[index];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: CommentItem(
//                             comment: comment!,
//                             onReply: () {
//                               _commentFocusNode.requestFocus();
//                             },
//                             replyingTo: false,
//                             onAddReply: (value) {},
//                           ),
//                         );
//                       },
//                       childCount: controller.comments.value.data?.length ?? 0,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: const SizedBox(height: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//             AppDimens.dimen12,
//             0,
//             AppDimens.dimen12,
//             MediaQuery.of(context).viewInsets.bottom > 0
//                 ? MediaQuery.of(context).viewInsets.bottom + AppDimens.dimen12
//                 : AppDimens.dimen24,
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Obx(
//                   () => TextField(
//                     focusNode: _commentFocusNode,
//                     controller: controller.commentController,
//                     style: TextStyle(
//                       color: AppColors.whiteColor.withOpacity(1),
//                       fontFamily: GoogleFonts.inter().fontFamily,
//                       fontSize: FontDimen.dimen12,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: controller.replyingTo.value == null
//                           ? AppStrings.addComment
//                           : 'Reply to @{controller.replyingTo.value?.userName}',
//                       hintStyle: TextStyle(
//                         color: AppColors.textColor3.withOpacity(0.7),
//                         fontFamily: GoogleFonts.inter().fontFamily,
//                         fontSize: FontDimen.dimen12,
//                       ),
//                       filled: true,
//                       fillColor: AppColors.cardBgColor,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 22,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onSubmitted: (val) {
//                       if (val.trim().isNotEmpty) {
//                         if (controller.replyingTo.value == null) {
//                           controller.postComment(widget.post.id);
//                         }
//                         _commentFocusNode.unfocus();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(width: AppDimens.dimen8),
//               GestureDetector(
//                 onTap: () async {
//                   final val = controller.commentController.text.trim();
//                   if (val.isNotEmpty) {
//                     if (controller.replyingTo.value == null) {
//                       var isSuccess =
//                           await controller.postComment(widget.post.id);
//                       if (isSuccess) {
//                         widget.post.commentCount =
//                             ((int.tryParse(widget.post.commentCount ?? '0') ??
//                                         0) +
//                                     1)
//                                 .toString();
//                       }
//                     }
//                     _commentFocusNode.unfocus();
//                   }
//                 },
//                 child: Container(
//                   width: 55,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     color: AppColors.textColor4,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: Image.asset(
//                         AppImages.sendFilledIcon,
//                         height: AppDimens.dimen35,
//                         width: AppDimens.dimen35,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),  
//         ),
//       ),
//     );
//   }
// }
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import '../../config/app_config.dart';
// import '../../utils/app_cache_manager.dart';
// import '../../widgets/custom_bottom_sheet.dart';
// import '../create_post/create_post_screen.dart';
// import '../home/home_controller.dart';
// import '../home/models/post_list_response.dart';
// import '../home/models/post_model.dart';
// import 'community_post_detail_controller.dart';
// import 'widgets/comment_item.dart';

// class CommunityPostDetailScreen extends StatefulWidget {
//   final String communityName;
//   final Posts post;

//   const CommunityPostDetailScreen({
//     Key? key,
//     required this.communityName,
//     required this.post,
//   }) : super(key: key);

//   @override
//   State<CommunityPostDetailScreen> createState() =>
//       _CommunityPostDetailScreenState();
// }

// class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
//   int _currentMediaIndex = 0;
//   late final PageController _pageController;
//   final FocusNode _commentFocusNode = FocusNode();

//   // Video player
//   VideoPlayerController? _videoController;
//   Future<void>? _initializeVideoPlayerFuture;
//   bool _isVideoInitialized = false;
//   bool _showControls = false;

//   final HomeController homeController = Get.find<HomeController>();

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _initializeVideo();
//     final controller = Get.findOrPut(CommunityPostDetailController());
//     controller.fetchComments(widget.post.id);
//   }

//   void _initializeVideo() {
//     final post = widget.post;
//     if (post.video != null && post.video!.isNotEmpty) {
//       _videoController = VideoPlayerController.network(post.video!);
//       _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
//         if (mounted) {
//           setState(() {
//             _isVideoInitialized = true;
//           });
//           _videoController!.setLooping(true);
//           _videoController!.play();
//         }
//       }).catchError((error) {
//         debugPrint("Error initializing video: $error");
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _commentFocusNode.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   List<Widget> _buildMediaWidgets() {
//     final post = widget.post;
//     List<Widget> mediaWidgets = [];

//     if (post.images != null && post.images!.isNotEmpty) {
//       for (String imageUrl in post.images!) {
//         mediaWidgets.add(_buildImageWidget(imageUrl));
//       }
//     }

//     if (post.video != null && post.video!.isNotEmpty) {
//       mediaWidgets.add(_buildVideoWidget());
//     }

//     return mediaWidgets;
//   }

//   Widget _buildImageWidget(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(AppDimens.dimen14),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: 250,
//         fadeInDuration: const Duration(milliseconds: 400),
//         cacheManager: appCacheManager,
//         useOldImageOnUrlChange: true,
//         placeholder: (context, url) => Container(
//           color: AppColors.greyShadeColor,
//           child: Center(child: CircularProgressIndicator()),
//         ),
//         errorWidget: (context, url, error) => Container(
//           color: AppColors.greyShadeColor,
//           child: Icon(Icons.broken_image, color: AppColors.greyColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoWidget() {
//     if (_videoController == null || !_isVideoInitialized) {
//       return Container(
//         height: 250,
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(AppDimens.dimen14),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(color: AppColors.primaryColor),
//               SizedBox(height: 12),
//               Text(
//                 'Loading video...',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final videoSize = _videoController!.value.size;
//     final aspectRatio = videoSize.width / videoSize.height;
    
//     double videoHeight = 250;
//     if (aspectRatio < 1) {
//       videoHeight = 300;
//     } else if (aspectRatio > 2) {
//       videoHeight = 200;
//     }

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(AppDimens.dimen14),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//           });
//           if (_showControls) {
//             Future.delayed(Duration(seconds: 3), () {
//               if (mounted) {
//                 setState(() {
//                   _showControls = false;
//                 });
//               }
//             });
//           }
//         },
//         child: Container(
//           height: videoHeight,
//           width: double.infinity,
//           color: Colors.black,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Center(
//                 child: AspectRatio(
//                   aspectRatio: aspectRatio,
//                   child: VideoPlayer(_videoController!),
//                 ),
//               ),
              
//               if (!_videoController!.value.isPlaying || _showControls)
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [Colors.black26, Colors.transparent, Colors.black38],
//                     ),
//                   ),
//                 ),
              
//               if (!_videoController!.value.isPlaying)
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     shape: BoxShape.circle,
//                   ),
//                   padding: EdgeInsets.all(16),
//                   child: Icon(
//                     Icons.play_arrow_rounded,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
              
//               if (_showControls && _videoController!.value.isPlaying)
//                 Positioned.fill(child: _buildVideoControls()),
              
//               if (_videoController!.value.isPlaying)
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: VideoProgressIndicator(
//                     _videoController!,
//                     allowScrubbing: true,
//                     colors: VideoProgressColors(
//                       playedColor: AppColors.primaryColor,
//                       bufferedColor: Colors.white30,
//                       backgroundColor: Colors.white12,
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 4),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoControls() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.black38, Colors.transparent, Colors.black54],
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildControlButton(
//                 icon: Icons.replay_10,
//                 onTap: () {
//                   final currentPosition = _videoController!.value.position;
//                   final newPosition = currentPosition - Duration(seconds: 10);
//                   _videoController!.seekTo(
//                     newPosition < Duration.zero ? Duration.zero : newPosition,
//                   );
//                 },
//               ),
//               SizedBox(width: 32),
//               _buildControlButton(
//                 icon: _videoController!.value.isPlaying
//                     ? Icons.pause
//                     : Icons.play_arrow,
//                 onTap: () {
//                   setState(() {
//                     if (_videoController!.value.isPlaying) {
//                       _videoController!.pause();
//                     } else {
//                       _videoController!.play();
//                     }
//                   });
//                 },
//                 size: 50,
//               ),
//               SizedBox(width: 32),
//               _buildControlButton(
//                 icon: Icons.forward_10,
//                 onTap: () {
//                   final currentPosition = _videoController!.value.position;
//                   final duration = _videoController!.value.duration;
//                   final newPosition = currentPosition + Duration(seconds: 10);
//                   _videoController!.seekTo(
//                     newPosition > duration ? duration : newPosition,
//                   );
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _formatDuration(_videoController!.value.position),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   _formatDuration(_videoController!.value.duration),
//                   style: TextStyle(color: Colors.white70, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     double size = 40,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.black45,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: Colors.white, size: size),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   void _editPost() {
//     AppDialogs.showConfirmationDialog(
//       title: AppStrings.editPost,
//       description: AppStrings.dialogEditPostMessage,
//       iconAsset: AppImages.editIcon,
//       iconBgColor: AppColors.primaryColor.withOpacity(0.13),
//       iconColor: AppColors.primaryColor,
//       cancelButtonText: AppStrings.no,
//       confirmButtonText: AppStrings.yes,
//       onConfirm: () {
//         Get.to(() => CreatePostScreen(
//               comingFromScreen: "edit_post",
//               communityId: widget.post.userId ?? "",
//               post: widget.post,
//               isEditing: true,
//             ));
//       },
//       onCancel: () {
//         Get.back(closeOverlays: true);
//       },
//     );
//   }

//   void _deletePost() {
//     AppDialogs.showConfirmationDialog(
//       title: AppStrings.deletePost,
//       description: AppStrings.dialogDeletePostMessage,
//       iconAsset: AppImages.deleteIcon,
//       iconBgColor: AppColors.redColor.withOpacity(0.13),
//       iconColor: AppColors.redColor,
//       confirmButtonText: AppStrings.deletePost,
//       confirmButtonColor: AppColors.redColor,
//       onConfirm: () async {
//         final postIndex = homeController.posts
//             .indexWhere((post) => post.id == widget.post.id);

//         if (postIndex != -1) {
//           await homeController.deletePost(widget.post.id ?? '', postIndex);
//           Get.back();
//           Get.snackbar(
//             'Success',
//             'Post deleted successfully',
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         } else {
//           await homeController.deletePost(widget.post.id ?? '', 0);
//           Get.back();
//         }
//       },
//       onCancel: () {
//         Get.back(closeOverlays: true);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CommunityPostDetailController());
//     final post = widget.post;
//     final List<Widget> mediaWidgets = _buildMediaWidgets();

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: CustomScrollView(
//             slivers: <Widget>[
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                     AppDimens.dimen16,
//                     AppDimens.dimen22,
//                     AppDimens.dimen16,
//                     AppDimens.dimen2,
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.back(closeOverlays: true);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(right: AppDimens.dimen12),
//                           child: Image.asset(
//                             AppImages.backArrow,
//                             height: AppDimens.dimen14,
//                             width: AppDimens.dimen14,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           widget.communityName,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen18 - 1,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: AppDimens.dimen12),
//                         child: Image.asset(
//                           AppImages.backArrow,
//                           height: AppDimens.dimen14,
//                           width: AppDimens.dimen14,
//                           color: AppColors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               SliverToBoxAdapter(
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(100),
//                             child: CachedNetworkImage(
//                               imageUrl: post.profile ?? '',
//                               fit: BoxFit.cover,
//                               width: AppDimens.dimen40 + 8,
//                               height: AppDimens.dimen40 + 8,
//                               fadeInDuration: const Duration(milliseconds: 400),
//                               cacheManager: appCacheManager,
//                               useOldImageOnUrlChange: true,
//                               placeholder: (context, url) =>
//                                   Container(color: AppColors.greyShadeColor),
//                               errorWidget: (context, url, error) => Container(
//                                 color: AppColors.greyShadeColor,
//                                 child: Icon(
//                                   Icons.person,
//                                   color: AppColors.greyColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   post.fullname ?? '',
//                                   style: TextStyle(
//                                     color: AppColors.textColor3.withOpacity(1),
//                                     fontFamily: AppFonts.appFont,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: FontDimen.dimen14,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   post.username ?? '',
//                                   style: TextStyle(
//                                     color: AppColors.textColor4.withOpacity(1),
//                                     fontFamily: GoogleFonts.inter().fontFamily,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: FontDimen.dimen11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     post.userId == StorageHelper().getUserId.toString()
//                         ? Positioned(
//                             top: -1,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () {
//                                 showActionSheet(
//                                   context,
//                                   actions: [
//                                     SheetAction(
//                                       text: AppStrings.editPost,
//                                       iconAsset: AppImages.editIcon,
//                                       onTap: _editPost,
//                                     ),
//                                     SheetAction(
//                                       text: AppStrings.deletePost,
//                                       iconAsset: AppImages.deleteIcon,
//                                       onTap: _deletePost,
//                                     ),
//                                   ],
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Image.asset(
//                                   AppImages.threeDottedMenu,
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ],
//                 ),
//               ),
//               SliverToBoxAdapter(child: const SizedBox(height: 8)),

//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Text(
//                     post.caption ?? '',
//                     style: TextStyle(
//                       color: AppColors.textColor3.withOpacity(1),
//                       fontFamily: GoogleFonts.inter().fontFamily,
//                       fontWeight: FontWeight.w400,
//                       fontSize: FontDimen.dimen12,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(child: const SizedBox(height: 9)),

//               if (mediaWidgets.isNotEmpty)
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: mediaWidgets.length == 1
//                         ? mediaWidgets.first
//                         : Stack(
//                             children: [
//                               SizedBox(
//                                 height: 250,
//                                 width: double.infinity,
//                                 child: PageView.builder(
//                                   controller: _pageController,
//                                   itemCount: mediaWidgets.length,
//                                   onPageChanged: (i) {
//                                     setState(() {
//                                       _currentMediaIndex = i;
//                                     });
//                                     if (_videoController != null && _videoController!.value.isPlaying) {
//                                       _videoController!.pause();
//                                     }
//                                   },
//                                   itemBuilder: (context, idx) => mediaWidgets[idx],
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 12,
//                                 left: 0,
//                                 right: 0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(
//                                     mediaWidgets.length,
//                                     (idx) => GestureDetector(
//                                       onTap: () {
//                                         _pageController.animateToPage(
//                                           idx,
//                                           duration: const Duration(milliseconds: 300),
//                                           curve: Curves.easeInOut,
//                                         );
//                                       },
//                                       child: Container(
//                                         width: 10,
//                                         height: 10,
//                                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: idx == _currentMediaIndex
//                                               ? Colors.white
//                                               : AppColors.greyColorShade.withOpacity(1),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               SliverToBoxAdapter(child: const SizedBox(height: 9)),

//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//                   child: Row(
//                     children: [
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.like,
//                             height: AppDimens.dimen24,
//                             width: AppDimens.dimen24,
//                           ),
//                           SizedBox(width: AppDimens.dimen6),
//                           Text(
//                             post.likeCount ?? '0',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: AppDimens.dimen24),
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.comments,
//                             height: AppDimens.dimen24,
//                             width: AppDimens.dimen24,
//                           ),
//                           SizedBox(width: AppDimens.dimen6),
//                           Text(
//                             post.commentCount ?? '0',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 sliver: Obx(
//                   () => SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final comment = controller.comments.value.data?[index];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: CommentItem(
//                             comment: comment!,
//                             onReply: () {
//                               _commentFocusNode.requestFocus();
//                             },
//                             replyingTo: false,
//                             onAddReply: (value) {},
//                           ),
//                         );
//                       },
//                       childCount: controller.comments.value.data?.length ?? 0,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(child: const SizedBox(height: 18)),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//             AppDimens.dimen12,
//             0,
//             AppDimens.dimen12,
//             MediaQuery.of(context).viewInsets.bottom > 0
//                 ? MediaQuery.of(context).viewInsets.bottom + AppDimens.dimen12
//                 : AppDimens.dimen24,
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Obx(
//                   () => TextField(
//                     focusNode: _commentFocusNode,
//                     controller: controller.commentController,
//                     style: TextStyle(
//                       color: AppColors.whiteColor.withOpacity(1),
//                       fontFamily: GoogleFonts.inter().fontFamily,
//                       fontSize: FontDimen.dimen12,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: controller.replyingTo.value == null
//                           ? AppStrings.addComment
//                           : 'Reply to @{controller.replyingTo.value?.userName}',
//                       hintStyle: TextStyle(
//                         color: AppColors.textColor3.withOpacity(0.7),
//                         fontFamily: GoogleFonts.inter().fontFamily,
//                         fontSize: FontDimen.dimen12,
//                       ),
//                       filled: true,
//                       fillColor: AppColors.cardBgColor,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 22,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onSubmitted: (val) {
//                       if (val.trim().isNotEmpty) {
//                         if (controller.replyingTo.value == null) {
//                           controller.postComment(widget.post.id);
//                         }
//                         _commentFocusNode.unfocus();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(width: AppDimens.dimen8),
//               GestureDetector(
//                 onTap: () async {
//                   final val = controller.commentController.text.trim();
//                   if (val.isNotEmpty) {
//                     if (controller.replyingTo.value == null) {
//                       var isSuccess = await controller.postComment(widget.post.id);
//                       if (isSuccess) {
//                         widget.post.commentCount =
//                             ((int.tryParse(widget.post.commentCount ?? '0') ?? 0) + 1)
//                                 .toString();
//                       }
//                     }
//                     _commentFocusNode.unfocus();
//                   }
//                 },
//                 child: Container(
//                   width: 55,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     color: AppColors.textColor4,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: Image.asset(
//                         AppImages.sendFilledIcon,
//                         height: AppDimens.dimen35,
//                         width: AppDimens.dimen35,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../config/app_config.dart';
import '../../utils/app_cache_manager.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../create_post/create_post_screen.dart';
import '../home/home_controller.dart';
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
  int _currentMediaIndex = 0;
  late final PageController _pageController;
  final FocusNode _commentFocusNode = FocusNode();

  // Video player
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isVideoInitialized = false;
  bool _showControls = false;

  final HomeController homeController = Get.find<HomeController>();

  // Keep track of current video URL to detect changes
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentVideoUrl = widget.post.video;
    _initializeVideo();
    final controller = Get.findOrPut(CommunityPostDetailController());
    controller.fetchComments(widget.post.id);
  }

  @override
  void didUpdateWidget(CommunityPostDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the video URL has changed
    if (oldWidget.post.video != widget.post.video) {
      _currentVideoUrl = widget.post.video;
      // Dispose old controller and reinitialize with new video
      _disposeVideoController();
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    final post = widget.post;
    if (post.video != null && post.video!.isNotEmpty) {
      _videoController = VideoPlayerController.network(post.video!);
      _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
        }
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
        if (mounted) {
          setState(() {
            _isVideoInitialized = false;
          });
        }
      });
    }
  }

  void _disposeVideoController() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
    _isVideoInitialized = false;
    _initializeVideoPlayerFuture = null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentFocusNode.dispose();
    _disposeVideoController();
    super.dispose();
  }

  List<Widget> _buildMediaWidgets() {
    final post = widget.post;
    List<Widget> mediaWidgets = [];

    if (post.images != null && post.images!.isNotEmpty) {
      for (String imageUrl in post.images!) {
        mediaWidgets.add(_buildImageWidget(imageUrl));
      }
    }

    if (post.video != null && post.video!.isNotEmpty) {
      mediaWidgets.add(_buildVideoWidget());
    }

    return mediaWidgets;
  }

  Widget _buildImageWidget(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.dimen14),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
        fadeInDuration: const Duration(milliseconds: 400),
        cacheManager: appCacheManager,
        useOldImageOnUrlChange: true,
        placeholder: (context, url) => Container(
          color: AppColors.greyShadeColor,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.greyShadeColor,
          child: Icon(Icons.broken_image, color: AppColors.greyColor),
        ),
      ),
    );
  }

  Widget _buildVideoWidget() {
    if (_videoController == null || !_isVideoInitialized) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(AppDimens.dimen14),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryColor),
              SizedBox(height: 12),
              Text(
                'Loading video...',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    final videoSize = _videoController!.value.size;
    final aspectRatio = videoSize.width / videoSize.height;
    
    double videoHeight = 250;
    if (aspectRatio < 1) {
      videoHeight = 300;
    } else if (aspectRatio > 2) {
      videoHeight = 200;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.dimen14),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
          if (_showControls) {
            Future.delayed(Duration(seconds: 3), () {
              if (mounted) {
                setState(() {
                  _showControls = false;
                });
              }
            });
          }
        },
        child: Container(
          height: videoHeight,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),
              
              if (!_videoController!.value.isPlaying || _showControls)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black26, Colors.transparent, Colors.black38],
                    ),
                  ),
                ),
              
              if (!_videoController!.value.isPlaying)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              
              if (_showControls && _videoController!.value.isPlaying)
                Positioned.fill(child: _buildVideoControls()),
              
              if (_videoController!.value.isPlaying)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    _videoController!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: AppColors.primaryColor,
                      bufferedColor: Colors.white30,
                      backgroundColor: Colors.white12,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black38, Colors.transparent, Colors.black54],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: Icons.replay_10,
                onTap: () {
                  final currentPosition = _videoController!.value.position;
                  final newPosition = currentPosition - Duration(seconds: 10);
                  _videoController!.seekTo(
                    newPosition < Duration.zero ? Duration.zero : newPosition,
                  );
                },
              ),
              SizedBox(width: 32),
              _buildControlButton(
                icon: _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                size: 50,
              ),
              SizedBox(width: 32),
              _buildControlButton(
                icon: Icons.forward_10,
                onTap: () {
                  final currentPosition = _videoController!.value.position;
                  final duration = _videoController!.value.duration;
                  final newPosition = currentPosition + Duration(seconds: 10);
                  _videoController!.seekTo(
                    newPosition > duration ? duration : newPosition,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_videoController!.value.position),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(_videoController!.value.duration),
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 40,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _editPost() {
    AppDialogs.showConfirmationDialog(
      title: AppStrings.editPost,
      description: AppStrings.dialogEditPostMessage,
      iconAsset: AppImages.editIcon,
      iconBgColor: AppColors.primaryColor.withOpacity(0.13),
      iconColor: AppColors.primaryColor,
      cancelButtonText: AppStrings.no,
      confirmButtonText: AppStrings.yes,
      onConfirm: () async {
        // Pause video before navigating
        if (_videoController != null && _videoController!.value.isPlaying) {
          _videoController!.pause();
        }

        final result = await Get.to(() => CreatePostScreen(
              comingFromScreen: "edit_post",
              communityId: widget.post.userId ?? "",
              post: widget.post,
              isEditing: true,
            ));

        // If post was edited, reinitialize video
        if (result == true && mounted) {
          setState(() {
            _disposeVideoController();
            _currentVideoUrl = widget.post.video;
            _initializeVideo();
          });
        }
      },
      onCancel: () {
        Get.back(closeOverlays: true);
      },
    );
  }

  void _deletePost() {
    AppDialogs.showConfirmationDialog(
      title: AppStrings.deletePost,
      description: AppStrings.dialogDeletePostMessage,
      iconAsset: AppImages.deleteIcon,
      iconBgColor: AppColors.redColor.withOpacity(0.13),
      iconColor: AppColors.redColor,
      confirmButtonText: AppStrings.deletePost,
      confirmButtonColor: AppColors.redColor,
      onConfirm: () async {
        final postIndex = homeController.posts
            .indexWhere((post) => post.id == widget.post.id);

        if (postIndex != -1) {
          await homeController.deletePost(widget.post.id ?? '', postIndex);
          Get.back();
          Get.snackbar(
            'Success',
            'Post deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          await homeController.deletePost(widget.post.id ?? '', 0);
          Get.back();
        }
      },
      onCancel: () {
        Get.back(closeOverlays: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityPostDetailController());
    final post = widget.post;
    final List<Widget> mediaWidgets = _buildMediaWidgets();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
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
                        onTap: () {
                          Get.back(closeOverlays: true);
                        },
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

              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: post.profile ?? '',
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.fullname ?? '',
                                  style: TextStyle(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontDimen.dimen14,
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                          ),
                        ],
                      ),
                    ),
                    post.userId == StorageHelper().getUserId.toString()
                        ? Positioned(
                            top: -1,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                showActionSheet(
                                  context,
                                  actions: [
                                    SheetAction(
                                      text: AppStrings.editPost,
                                      iconAsset: AppImages.editIcon,
                                      onTap: _editPost,
                                    ),
                                    SheetAction(
                                      text: AppStrings.deletePost,
                                      iconAsset: AppImages.deleteIcon,
                                      onTap: _deletePost,
                                    ),
                                  ],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  AppImages.threeDottedMenu,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 8)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    post.caption ?? '',
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(1),
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: FontDimen.dimen12,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 9)),

              if (mediaWidgets.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: mediaWidgets.length == 1
                        ? mediaWidgets.first
                        : Stack(
                            children: [
                              SizedBox(
                                height: 250,
                                width: double.infinity,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: mediaWidgets.length,
                                  onPageChanged: (i) {
                                    setState(() {
                                      _currentMediaIndex = i;
                                    });
                                    if (_videoController != null && _videoController!.value.isPlaying) {
                                      _videoController!.pause();
                                    }
                                  },
                                  itemBuilder: (context, idx) => mediaWidgets[idx],
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    mediaWidgets.length,
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
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: idx == _currentMediaIndex
                                              ? Colors.white
                                              : AppColors.greyColorShade.withOpacity(1),
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
              SliverToBoxAdapter(child: const SizedBox(height: 9)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
                          SizedBox(width: AppDimens.dimen6),
                          Text(
                            post.commentCount ?? '0',
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

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                              _commentFocusNode.requestFocus();
                            },
                            replyingTo: false,
                            onAddReply: (value) {},
                          ),
                        );
                      },
                      childCount: controller.comments.value.data?.length ?? 0,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 18)),
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
                      // hintText: controller.replyingTo.value == null
                      //     ? AppStrings.addComment
                      //     : 'Reply to @${controller.replyingTo.value?.userName}',
                        hintText: controller.replyingTo.value == null
                          ? AppStrings.addComment
                          : '',
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
                        }
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
                      var isSuccess = await controller.postComment(widget.post.id);
                      if (isSuccess) {
                        widget.post.commentCount =
                            ((int.tryParse(widget.post.commentCount ?? '0') ?? 0) + 1)
                                .toString();
                      }
                    }
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