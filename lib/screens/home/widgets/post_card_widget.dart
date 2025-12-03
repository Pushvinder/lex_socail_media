// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:the_friendz_zone/screens/create_post/create_post_screen.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:the_friendz_zone/screens/user_profile/user_profile_screen.dart';
// import '../../../config/app_config.dart';
// import '../../community_post_detail/community_post_detail_screen.dart';
// import '../models/post_model.dart';
// import '../../../widgets/custom_bottom_sheet.dart';
// import 'package:the_friendz_zone/widgets/comment_bottom_sheet.dart';

// class PostCardWidget extends StatefulWidget {
//   final String communityName;
//   final Posts post;
//   final VoidCallback onDelete;
//   final VoidCallback onLike;

//   const PostCardWidget({
//     super.key,
//     required this.communityName,
//     required this.post,
//     required this.onDelete,
//     required this.onLike,
//   });

//   @override
//   State<PostCardWidget> createState() => _PostCardWidgetState();
// }

// class _PostCardWidgetState extends State<PostCardWidget> {
//   int _currentImage = 0;
//   late final PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final post = widget.post;
//     final List<String> images = post.images ?? [];

//     final int userId = StorageHelper().getUserId ?? 0;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12, top: 0),
//       padding: const EdgeInsets.all(0),
//       decoration: BoxDecoration(
//         color: AppColors.cardBgColor,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --- Post Header ---
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 5, 0),
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Avatar
//                       Container(
//                         width: 35,
//                         height: 35,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           image:
//                               (post.profile != null && post.profile!.isNotEmpty)
//                                   ? null
//                                   : DecorationImage(
//                                       image: AssetImage(AppImages.profile),
//                                       fit: BoxFit.cover,
//                                     ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: CachedNetworkImage(
//                             imageUrl: post.profile ?? '',
//                             fit: BoxFit.cover,
//                             width: 35,
//                             height: 35,
//                             fadeInDuration: Duration(milliseconds: 400),
//                             placeholder: (context, url) =>
//                                 Container(color: AppColors.greyShadeColor),
//                             errorWidget: (context, url, error) => Container(
//                               color: AppColors.greyShadeColor,
//                               child: Icon(
//                                 Icons.person,
//                                 color: AppColors.greyColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 11),
//                       // Name + handle
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             post.fullname ?? '',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: AppFonts.appFont,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen16,
//                             ),
//                           ).asButton(onTap: () {
//                             Get.to(() => UserProfileScreen(
//                                   userId: post.userId ?? '',
//                                 ));
//                           }),
//                           Text(
//                             post.username ?? '',
//                             style: TextStyle(
//                               color: AppColors.textColor4.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen11,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ui for the three dots option available to user if the post is it their own post
//               if (post.userId == userId.toString())
//                 Positioned(
//                   top: 12,
//                   right: 16,
//                   child: GestureDetector(
//                     onTap: () {
//                       showActionSheet(
//                         context,
//                         actions: [
//                           SheetAction(
//                             text: AppStrings.editPost,
//                             iconAsset: AppImages.editIcon,
//                             onTap: () {
//                               AppDialogs.showConfirmationDialog(
//                                 title: AppStrings.editPost,
//                                 description: AppStrings.dialogEditPostMessage,
//                                 iconAsset: AppImages.editIcon,
//                                 iconBgColor:
//                                     AppColors.primaryColor.withOpacity(0.13),
//                                 iconColor: AppColors.primaryColor,
//                                 cancelButtonText: AppStrings.no,
//                                 confirmButtonText: AppStrings.yes,
//                                 onConfirm: () {
//                                   // widget.post;
//                                   Get.to(() => CreatePostScreen(
//                                         comingFromScreen: "edit_post",
//                                         communityId: post.userId ?? "",
//                                         post: post, // 👈 pass model to edit
//                                         isEditing: true,
//                                       ));
//                                 },
//                                 onCancel: () {
//                                   Get.back(
//                                       closeOverlays:
//                                           true); // This will close all overlays including snackbars
//                                 },
//                               );
//                             },
//                           ),
//                           SheetAction(
//                             text: AppStrings.deletePost,
//                             iconAsset: AppImages.deleteIcon,
//                             onTap: () {
//                               AppDialogs.showConfirmationDialog(
//                                 title: AppStrings.deletePost,
//                                 description: AppStrings.dialogDeletePostMessage,
//                                 iconAsset: AppImages.deleteIcon,
//                                 iconBgColor:
//                                     AppColors.redColor.withOpacity(0.13),
//                                 iconColor: AppColors.redColor,
//                                 confirmButtonText: AppStrings.deletePost,
//                                 confirmButtonColor: AppColors.redColor,
//                                 onConfirm: () {
//                                   widget.onDelete();
//                                   // ScaffoldMessenger.of(context).showSnackBar(

//                                   // );
//                                 },
//                                 onCancel: () {
//                                   Get.back(
//                                       closeOverlays:
//                                           true); // This will close all overlays including snackbars
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.threeDottedMenu,
//                       width: 20,
//                       height: 20,
//                     ),
//                   ),
//                 ),
//             ],
//           ),

//           // --- Post Text & Hashtags ---
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 11, 16, 0),
//             child: RichText(
//               text: TextSpan(
//                 style: TextStyle(
//                   color: AppColors.textColor3.withOpacity(1),
//                   fontFamily: GoogleFonts.inter().fontFamily,
//                   height: 1.38,
//                   fontSize: FontDimen.dimen8,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: post.caption ?? '',
//                     style: TextStyle(
//                       fontSize: FontDimen.dimen12,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   // TODO:UPDATE HASTAGS NOT AVAILABLE RIGHT NOW
//                   // if (post..isNotEmpty)
//                   //   TextSpan(
//                   //     text:
//                   //         "\n" + post.hashtags.map((tag) => "#$tag").join("  "),
//                   //     style: TextStyle(
//                   //       height: 1.5,
//                   //       fontSize: FontDimen.dimen11,
//                   //       color: AppColors.textColor5,
//                   //       fontWeight: FontWeight.w500,
//                   //       letterSpacing: 0.13,
//                   //     ),
//                   //   ),
//                 ],
//               ),
//             ),
//           ),

//           // --- Post Images (Single or Multiple with Dots) ---
//           if (images.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//               child: images.length == 1
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(9),
//                       child: CachedNetworkImage(
//                         imageUrl: images.first,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         height: 206,
//                         fadeInDuration: Duration(milliseconds: 500),
//                         placeholder: (context, url) =>
//                             Container(color: AppColors.greyShadeColor),
//                         errorWidget: (context, url, error) => Container(
//                           color: AppColors.greyShadeColor,
//                           child: Icon(
//                             Icons.broken_image,
//                             color: AppColors.greyColor,
//                           ),
//                         ),
//                       ),
//                     )
//                   : Stack(
//                       children: [
//                         SizedBox(
//                           height: 206,
//                           width: double.infinity,
//                           child: PageView.builder(
//                             controller: _pageController,
//                             itemCount: images.length,
//                             onPageChanged: (i) => setState(() {
//                               _currentImage = i;
//                             }),
//                             itemBuilder: (context, idx) => ClipRRect(
//                               borderRadius: BorderRadius.circular(9),
//                               child: CachedNetworkImage(
//                                 imageUrl: images[idx],
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: 206,
//                                 fadeInDuration: Duration(milliseconds: 500),
//                                 placeholder: (context, url) =>
//                                     Container(color: AppColors.greyShadeColor),
//                                 errorWidget: (context, url, error) => Container(
//                                   color: AppColors.greyShadeColor,
//                                   child: Icon(
//                                     Icons.broken_image,
//                                     color: AppColors.greyColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 12,
//                           left: 0,
//                           right: 0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(
//                               images.length,
//                               (idx) => GestureDetector(
//                                 onTap: () {
//                                   _pageController.animateToPage(
//                                     idx,
//                                     duration: const Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                                 child: Container(
//                                   width: 10,
//                                   height: 10,
//                                   margin:
//                                       const EdgeInsets.symmetric(horizontal: 4),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: idx == _currentImage
//                                         ? Colors.white
//                                         : AppColors.greyColorShade
//                                             .withOpacity(1),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//             ),

//           // --- Likes & Comments Row ---
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 13),
//             child: GestureDetector(
//               onTap: () {
//                 Get.to(
//                   () => CommunityPostDetailScreen(
//                     communityName: widget.communityName,
//                     post: widget.post,
//                   ),
//                 );
//               },
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: AppColors.scaffoldBackgroundColor,
//                     ),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 3),
//                         InkWell(
//                           onTap: () {
//                             widget.onLike();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Image.asset(
//                               AppImages.like,
//                               width: 16,
//                               height: 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           post.likeCount ?? '0',
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontFamily: GoogleFonts.inter().fontFamily,
//                             fontWeight: FontWeight.w500,
//                             fontSize: FontDimen.dimen13,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: AppColors.scaffoldBackgroundColor,
//                     ),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 3),
//                         Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: InkWell(
//                             onTap: () {
//                               // showModalBottomSheet(
//                               //   context: context,
//                               //   isScrollControlled: true,
//                               //   builder: (context) => CommentBottomSheet(
//                               //     postId: post.id ?? '',
//                               //   ),
//                               // ).then((count) {
//                               //   if (count != null && count is String) {
//                               //     setState(() {
//                               //       post.commentCount = count;
//                               //     });
//                               //   }
//                               // });
//                             },
//                             child: Image.asset(
//                               AppImages.comments,
//                               width: 16,
//                               height: 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           post.commentCount ?? '0',
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontFamily: GoogleFonts.inter().fontFamily,
//                             fontWeight: FontWeight.w500,
//                             fontSize: FontDimen.dimen13,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//         ],
//       ),
//     ).asButton(onTap: () {
//       Get.to(() => CommunityPostDetailScreen(
//             communityName: widget.communityName,
//             post: widget.post,
//           ));
//     });
//   }
// // }
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:the_friendz_zone/screens/create_post/create_post_screen.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:the_friendz_zone/screens/user_profile/user_profile_screen.dart';
// import '../../../config/app_config.dart';
// import '../../community_post_detail/community_post_detail_screen.dart';
// import '../models/post_model.dart';
// import '../../../widgets/custom_bottom_sheet.dart';
// import 'package:the_friendz_zone/widgets/comment_bottom_sheet.dart';

// class PostCardWidget extends StatefulWidget {
//   final String communityName;
//   final Posts post;
//   final VoidCallback onDelete;
//   final VoidCallback onLike;

//   const PostCardWidget({
//     super.key,
//     required this.communityName,
//     required this.post,
//     required this.onDelete,
//     required this.onLike,
//   });

//   @override
//   State<PostCardWidget> createState() => _PostCardWidgetState();
// }

// class _PostCardWidgetState extends State<PostCardWidget> {
//   int _currentMediaIndex = 0;
//   late final PageController _pageController;
  
//   // Video player
//   VideoPlayerController? _videoController;
//   Future<void>? _initializeVideoPlayerFuture;
//   bool _isVideoInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _initializeVideo();
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
//       borderRadius: BorderRadius.circular(9),
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: 206,
//         fadeInDuration: Duration(milliseconds: 500),
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
//           borderRadius: BorderRadius.circular(9),
//         ),
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(9),
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

//   @override
//   Widget build(BuildContext context) {
//     final post = widget.post;
//     final List<Widget> mediaWidgets = _buildMediaWidgets();
//     final int userId = StorageHelper().getUserId ?? 0;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12, top: 0),
//       padding: const EdgeInsets.all(0),
//       decoration: BoxDecoration(
//         color: AppColors.cardBgColor,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --- Post Header ---
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 5, 0),
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Avatar
//                       Container(
//                         width: 35,
//                         height: 35,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           image:
//                               (post.profile != null && post.profile!.isNotEmpty)
//                                   ? null
//                                   : DecorationImage(
//                                       image: AssetImage(AppImages.profile),
//                                       fit: BoxFit.cover,
//                                     ),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(100),
//                           child: CachedNetworkImage(
//                             imageUrl: post.profile ?? '',
//                             fit: BoxFit.cover,
//                             width: 35,
//                             height: 35,
//                             fadeInDuration: Duration(milliseconds: 400),
//                             placeholder: (context, url) =>
//                                 Container(color: AppColors.greyShadeColor),
//                             errorWidget: (context, url, error) => Container(
//                               color: AppColors.greyShadeColor,
//                               child: Icon(
//                                 Icons.person,
//                                 color: AppColors.greyColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 11),
//                       // Name + handle
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             post.fullname ?? '',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(1),
//                               fontFamily: AppFonts.appFont,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen16,
//                             ),
//                           ).asButton(onTap: () {
//                             Get.to(() => UserProfileScreen(
//                                   userId: post.userId ?? '',
//                                 ));
//                           }),
//                           Text(
//                             post.username ?? '',
//                             style: TextStyle(
//                               color: AppColors.textColor4.withOpacity(1),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               fontSize: FontDimen.dimen11,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ui for the three dots option available to user if the post is it their own post
//               if (post.userId == userId.toString())
//                 Positioned(
//                   top: 12,
//                   right: 16,
//                   child: GestureDetector(
//                     onTap: () {
//                       showActionSheet(
//                         context,
//                         actions: [
//                           SheetAction(
//                             text: AppStrings.editPost,
//                             iconAsset: AppImages.editIcon,
//                             onTap: () {
//                               AppDialogs.showConfirmationDialog(
//                                 title: AppStrings.editPost,
//                                 description: AppStrings.dialogEditPostMessage,
//                                 iconAsset: AppImages.editIcon,
//                                 iconBgColor:
//                                     AppColors.primaryColor.withOpacity(0.13),
//                                 iconColor: AppColors.primaryColor,
//                                 cancelButtonText: AppStrings.no,
//                                 confirmButtonText: AppStrings.yes,
//                                 onConfirm: () {
//                                   Get.to(() => CreatePostScreen(
//                                         comingFromScreen: "edit_post",
//                                         communityId: post.userId ?? "",
//                                         post: post,
//                                         isEditing: true,
//                                       ));
//                                 },
//                                 onCancel: () {
//                                   Get.back(closeOverlays: true);
//                                 },
//                               );
//                             },
//                           ),
//                           SheetAction(
//                             text: AppStrings.deletePost,
//                             iconAsset: AppImages.deleteIcon,
//                             onTap: () {
//                               AppDialogs.showConfirmationDialog(
//                                 title: AppStrings.deletePost,
//                                 description: AppStrings.dialogDeletePostMessage,
//                                 iconAsset: AppImages.deleteIcon,
//                                 iconBgColor:
//                                     AppColors.redColor.withOpacity(0.13),
//                                 iconColor: AppColors.redColor,
//                                 confirmButtonText: AppStrings.deletePost,
//                                 confirmButtonColor: AppColors.redColor,
//                                 onConfirm: () {
//                                   widget.onDelete();
//                                 },
//                                 onCancel: () {
//                                   Get.back(closeOverlays: true);
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.threeDottedMenu,
//                       width: 20,
//                       height: 20,
//                     ),
//                   ),
//                 ),
//             ],
//           ),

//           // --- Post Text & Hashtags ---
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 11, 16, 0),
//             child: RichText(
//               text: TextSpan(
//                 style: TextStyle(
//                   color: AppColors.textColor3.withOpacity(1),
//                   fontFamily: GoogleFonts.inter().fontFamily,
//                   height: 1.38,
//                   fontSize: FontDimen.dimen8,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: post.caption ?? '',
//                     style: TextStyle(
//                       fontSize: FontDimen.dimen12,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // --- Post Media (Images + Video with Dots) ---
//           if (mediaWidgets.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//               child: mediaWidgets.length == 1
//                   ? mediaWidgets.first
//                   : Stack(
//                       children: [
//                         SizedBox(
//                           height: 206,
//                           width: double.infinity,
//                           child: PageView.builder(
//                             controller: _pageController,
//                             itemCount: mediaWidgets.length,
//                             onPageChanged: (i) {
//                               setState(() {
//                                 _currentMediaIndex = i;
//                               });
                              
//                               // Pause video when swiping away from it
//                               if (_videoController != null && _videoController!.value.isPlaying) {
//                                 _videoController!.pause();
//                               }
//                             },
//                             itemBuilder: (context, idx) => mediaWidgets[idx],
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 12,
//                           left: 0,
//                           right: 0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(
//                               mediaWidgets.length,
//                               (idx) => GestureDetector(
//                                 onTap: () {
//                                   _pageController.animateToPage(
//                                     idx,
//                                     duration: const Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                                 child: Container(
//                                   width: 10,
//                                   height: 10,
//                                   margin:
//                                       const EdgeInsets.symmetric(horizontal: 4),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: idx == _currentMediaIndex
//                                         ? Colors.white
//                                         : AppColors.greyColorShade
//                                             .withOpacity(1),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//             ),

//           // --- Likes & Comments Row ---
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 13),
//             child: GestureDetector(
//               onTap: () {
//                 Get.to(
//                   () => CommunityPostDetailScreen(
//                     communityName: widget.communityName,
//                     post: widget.post,
//                   ),
//                 );
//               },
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: AppColors.scaffoldBackgroundColor,
//                     ),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 3),
//                         InkWell(
//                           onTap: () {
//                             widget.onLike();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Image.asset(
//                               AppImages.like,
//                               width: 16,
//                               height: 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           post.likeCount ?? '0',
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontFamily: GoogleFonts.inter().fontFamily,
//                             fontWeight: FontWeight.w500,
//                             fontSize: FontDimen.dimen13,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: AppColors.scaffoldBackgroundColor,
//                     ),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 3),
//                         Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: InkWell(
//                             onTap: () {
//                               // Comment bottom sheet code
//                             },
//                             child: Image.asset(
//                               AppImages.comments,
//                               width: 16,
//                               height: 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           post.commentCount ?? '0',
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontFamily: GoogleFonts.inter().fontFamily,
//                             fontWeight: FontWeight.w500,
//                             fontSize: FontDimen.dimen13,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//         ],
//       ),
//     ).asButton(onTap: () {
//       Get.to(() => CommunityPostDetailScreen(
//             communityName: widget.communityName,
//             post: widget.post,
//           ));
//     });
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:the_friendz_zone/screens/create_post/create_post_screen.dart';
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
  int _currentMediaIndex = 0;
  late final PageController _pageController;
  
  // Video player
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isVideoInitialized = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeVideo();
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
          // Auto-play video
          _videoController!.setLooping(true);
          _videoController!.play();
        }
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  // Build list of all media (images + video)
  List<Widget> _buildMediaWidgets() {
    final post = widget.post;
    List<Widget> mediaWidgets = [];

    // Add images
    if (post.images != null && post.images!.isNotEmpty) {
      for (String imageUrl in post.images!) {
        mediaWidgets.add(_buildImageWidget(imageUrl));
      }
    }

    // Add video (show placeholder while loading)
    if (post.video != null && post.video!.isNotEmpty) {
      mediaWidgets.add(_buildVideoWidget());
    }

    return mediaWidgets;
  }

  Widget _buildImageWidget(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
        fadeInDuration: Duration(milliseconds: 500),
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
    // Show loading placeholder while video initializes
    if (_videoController == null || !_isVideoInitialized) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 12),
              Text(
                'Loading video...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final videoSize = _videoController!.value.size;
    final aspectRatio = videoSize.width / videoSize.height;
    
    // Calculate height based on aspect ratio to ensure full visibility
    double videoHeight = 250;
    if (aspectRatio < 1) {
      // Portrait video - increase height
      videoHeight = 300;
    } else if (aspectRatio > 2) {
      // Very wide video - reduce height
      videoHeight = 200;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
          // Hide controls after 3 seconds
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
              // Video Player
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),
              
              // Play/Pause overlay (always visible when paused)
              if (!_videoController!.value.isPlaying || _showControls)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.transparent,
                        Colors.black38,
                      ],
                    ),
                  ),
                ),
              
              // Center play/pause button
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
              
              // Video controls (show on tap)
              if (_showControls && _videoController!.value.isPlaying)
                Positioned.fill(
                  child: _buildVideoControls(),
                ),
              
              // Progress indicator at bottom
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
          colors: [
            Colors.black38,
            Colors.transparent,
            Colors.black54,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10s
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
              
              // Play/Pause
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
              
              // Forward 10s
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
          
          // Time display
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
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
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
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final List<Widget> mediaWidgets = _buildMediaWidgets();
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

              // Three dots menu
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
                                onConfirm: () {
                                  Get.to(() => CreatePostScreen(
                                        comingFromScreen: "edit_post",
                                        communityId: post.userId ?? "",
                                        post: post,
                                        isEditing: true,
                                      ));
                                },
                                onCancel: () {
                                  Get.back(closeOverlays: true);
                                },
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
                                },
                                onCancel: () {
                                  Get.back(closeOverlays: true);
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

          // --- Post Text ---
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
                ],
              ),
            ),
          ),

          // --- Post Media (Images + Video with Dots) ---
          if (mediaWidgets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
                              
                              // Pause video when swiping away
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
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: idx == _currentMediaIndex
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
                            onTap: () {},
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
    ).asButton(onTap: () {
      Get.to(() => CommunityPostDetailScreen(
            communityName: widget.communityName,
            post: widget.post,
          ));
    });
  }
}