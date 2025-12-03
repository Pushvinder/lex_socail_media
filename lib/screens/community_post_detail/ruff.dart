
// class CommunityPostDetailScreen extends StatefulWidget {
//   final String communityName;
//   final Posts post;
//
//   const CommunityPostDetailScreen({
//     Key? key,
//     required this.communityName,
//     required this.post,
//   }) : super(key: key);
//
//   @override
//   State<CommunityPostDetailScreen> createState() =>
//       _CommunityPostDetailScreenState();
// }
//
// class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
//   int _currentImage = 0;
//   late final PageController _pageController;
//
//   final FocusNode _commentFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     final controller = Get.findOrPut(CommunityPostDetailController());
//     controller.fetchComments(widget.post.id);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _commentFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CommunityPostDetailController());
//     final post = widget.post;
//     final images = post.images ?? [];
//
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
//                 // Use SliverToBoxAdapter for non-scrollable widgets in CustomScrollView
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
//                           Get.back(
//                               closeOverlays:
//                                   true); // This will close all overlays including snackbars
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
//
//               // --- Post Header ---
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
//                           // Name, handle, post text, tags
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
//                     post.userId == StorageHelper().getUserId.toString()
//                         ? Positioned(
//                             top: -1,
//                             right: 4,
//                             child: IconButton(
//                               icon: Image.asset(
//                                 AppImages.threeDottedMenu,
//                                 width: 20,
//                                 height: 20,
//                               ),
//                               onPressed: () {},
//                             ),
//                           )
//                         : Container(),
//                   ],
//                 ),
//               ),