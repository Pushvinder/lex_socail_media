// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:video_player/video_player.dart';
// import 'package:dotted_border/dotted_border.dart';
// import '../../config/app_config.dart';
// import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
// import '../../widgets/full_screen_image_viewer.dart';
// import 'create_post_controller.dart';
// import 'widgets/create_post_tab_button.dart';

// class CreatePostScreen extends StatefulWidget {
//   final String comingFromScreen;
//   final String communityId;

//   /// For EDIT POST MODE
//   final Posts? post;
//   final bool isEditing;

//   CreatePostScreen({
//     super.key,
//     required this.comingFromScreen,
//     required this.communityId,
//     this.post,
//     this.isEditing = false,
//   });

//   @override
//   State<CreatePostScreen> createState() => _CreatePostScreenState();
// }

// // ---------------------------------------------------------------------------//

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final CreatePostController controller = Get.put(CreatePostController());

//   bool _editDataLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditing && widget.post != null) {
//       loadEditData();
//     } else {
//       _editDataLoaded = true;
//     }
//   }

//   /// 🔥 Pre-fill previous post data safely (No Crash)
//   void loadEditData() async {
//     _editDataLoaded = false;
//     setState(() {});

//     await Future.delayed(Duration(milliseconds: 400)); // Wait for dropdown API

//     controller.captionController.text = widget.post?.caption ?? "";
//     controller.locationController.text = widget.post?.location ?? "";

//     if (widget.post?.images != null && widget.post!.images!.isNotEmpty) {
//       controller.imagesFromServer.assignAll(widget.post!.images!);
//     }

//     // ---------------- AGE SECTION (Final & Safe) -----------------
//     if (widget.post?.ageSuitability != null &&
//         controller.contentAgeResponse.isNotEmpty) {
//       List<ContentAgeData?> found = controller.contentAgeResponse
//           .where((e) => e?.id.toString() == widget.post!.ageSuitability!)
//           .toList();

//       if (found.isNotEmpty && found.first != null) {
//         controller.contentAgeSuitabilityId.value = found.first!.id ?? 0;
//         controller.contentAgeSuitability.value = found.first!.ageLabel ?? "";
//       } else {
//         controller.contentAgeSuitabilityId.value =
//             int.tryParse(widget.post!.ageSuitability!) ?? 0;
//         controller.contentAgeSuitability.value =
//             ""; // keeps dropdown safe, No crash
//       }
//     }

//     _editDataLoaded = true;
//     setState(() {});
//   }

//   // ---------------------------------------------------------------------------//

//   @override
//   Widget build(BuildContext context) {
//     final BottomNavController navController = Get.find<BottomNavController>();

//     return PopScope(
//       canPop: widget.comingFromScreen == 'community_feed',
//       onPopInvoked: (didPop) {
//         controller.clearData();
//         if (widget.comingFromScreen != 'community_feed') {
//           navController.changeTabIndex(0);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: SafeArea(
//           child: Column(
//             children: [
//               buildHeader(navController),
//               if (!_editDataLoaded)
//                 Expanded(
//                   child: Center(
//                     child: CircularProgressIndicator(
//                         color: AppColors.primaryColor),
//                   ),
//                 ),
//               if (_editDataLoaded) Expanded(child: buildForm()),
//               if (_editDataLoaded) buildSubmit(navController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //──────────────────────── HEADER ─────────────────────────────//

//   Widget buildHeader(BottomNavController nav) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => widget.comingFromScreen == 'community_feed'
//                 ? Get.back()
//                 : nav.changeTabIndex(0),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Image.asset(AppImages.backArrow, height: 12, width: 12),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text(
//                 widget.isEditing ? "Edit Post" : AppStrings.createNewPostTitle,
//                 style: TextStyle(
//                   color: AppColors.textColor3,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 20)
//         ],
//       ),
//     );
//   }

//   //──────────────────────── FORM UI ─────────────────────────────//

//   Widget buildForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(horizontal: 22),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           postTabs(),
//           SizedBox(height: 15),
//           mediaPicker(),
//           SizedBox(height: 15),
//           locationInput(),
//           SizedBox(height: 18),
//           ageSelector(),
//           SizedBox(height: 28),
//           captionInput(),
//           SizedBox(height: 40),
//         ],
//       ),
//     );
//   }

//   //──────────────────────── TABS ─────────────────────────────//

//   Widget postTabs() => SizedBox(
//         height: 32,
//         child: Obx(() => Row(children: [
//               Expanded(
//                 child: CreatePostTabButton(
//                   label: "Images",
//                   selected: controller.tabIndex.value == 0,
//                   onTap: () => controller.tabIndex.value = 0,
//                 ),
//               ),
//               SizedBox(width: 15),
//               Expanded(
//                 child: CreatePostTabButton(
//                   label: "Video",
//                   selected: controller.tabIndex.value == 1,
//                   onTap: () => controller.tabIndex.value = 1,
//                 ),
//               ),
//             ])),
//       );

//   //──────────────────────── IMAGE / VIDEO PICKERS ─────────────────────────────//

//   Widget mediaPicker() => Obx(
//         () => IndexedStack(
//           index: controller.tabIndex.value,
//           children: [buildImagePicker(), buildVideoPicker()],
//         ),
//       );

//   Widget buildImagePicker() {
//     return DottedBorder(
//       color: AppColors.bgColor,
//       strokeWidth: 2,
//       dashPattern: [3, 3],
//       borderType: BorderType.RRect,
//       radius: Radius.circular(15),
//       child: Container(
//         height: 185,
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
//         child: controller.imagesFromServer.isNotEmpty
//             ? serverImagesList()
//             : controller.images.isEmpty
//                 ? addImageButton()
//                 : pickedImagesList(),
//       ),
//     );
//   }

//   Widget serverImagesList() => ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.all(10),
//         separatorBuilder: (_, __) => SizedBox(width: 10),
//         itemCount: controller.imagesFromServer.length,
//         itemBuilder: (_, i) => Stack(children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(13),
//             child: Image.network(controller.imagesFromServer[i],
//                 width: 150, fit: BoxFit.cover),
//           ),
//           Positioned(
//             right: 4,
//             top: 4,
//             child: removeBtn(() => controller.removeServerImage(i)),
//           ),
//         ]),
//       );

//   Widget pickedImagesList() => ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.all(10),
//         separatorBuilder: (_, __) => SizedBox(width: 10),
//         itemCount: controller.images.length,
//         itemBuilder: (_, i) => Stack(children: [
//           GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => FullScreenImageViewer(
//                   images: controller.images.map((e) => e.path).toList(),
//                   initialIndex: i,
//                 ),
//               ),
//             ),
//             child: Hero(
//               tag: controller.images[i].path,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(13),
//                 child: Image.file(controller.images[i],
//                     width: 150, fit: BoxFit.cover),
//               ),
//             ),
//           ),
//           Positioned(
//             right: 4,
//             top: 4,
//             child: removeBtn(() => controller.removeImageAt(i)),
//           ),
//         ]),
//       );

//   Widget addImageButton() => Center(
//         child: GestureDetector(
//           onTap: controller.pickImages,
//           child: circleBtn(AppImages.profilePicIcon),
//         ),
//       );

//   //──────────────────────── VIDEO ─────────────────────────────//

//   Widget buildVideoPicker() => DottedBorder(
//         dashPattern: [3, 3],
//         borderType: BorderType.RRect,
//         radius: Radius.circular(15),
//         color: AppColors.bgColor,
//         child: Container(
//           height: 185,
//           child: controller.video.value == null
//               ? GestureDetector(
//                   onTap: controller.pickVideo,
//                   child: Center(child: circleBtn(AppImages.videoIcon)))
//               : videoPreview(),
//         ),
//       );

//   Widget videoPreview() => GetBuilder<CreatePostController>(
//         id: 'video_player',
//         builder: (c) {
//           if (c.videoPlayerFuture == null)
//             return Center(child: CircularProgressIndicator());

//           return FutureBuilder(
//             future: c.videoPlayerFuture,
//             builder: (_, snap) {
//               if (snap.connectionState != ConnectionState.done)
//                 return Center(child: CircularProgressIndicator());

//               return Stack(children: [
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: VideoPlayer(c.videoPlayerController!)),
//                 Center(
//                     child: GestureDetector(
//                         onTap: () => c.toggleVideoPlayback(),
//                         child: circlePlay(c))),
//                 Positioned(
//                     right: 4, top: 4, child: removeBtn(() => c.removeVideo()))
//               ]);
//             },
//           );
//         },
//       );

//   Widget circlePlay(CreatePostController c) => Container(
//         width: 52,
//         height: 52,
//         decoration:
//             BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//         child: Icon(
//           c.videoPlayerController!.value.isPlaying
//               ? Icons.pause
//               : Icons.play_arrow,
//           color: Colors.white,
//           size: 32,
//         ),
//       );

//   //──────────────────────── LOCATION ─────────────────────────────//

//   Widget locationInput() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label("Tag Location"),
//           SizedBox(height: 7),
//           inputBox(controller.locationController,
//               hint: "Add Location", maxLines: 1),
//         ],
//       );

//   //──────────────────────── AGE DROPDOWN ─────────────────────────────//

//   Widget ageSelector() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label("Content Age Suitability"),
//           SizedBox(height: 12),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 14),
//             height: 52,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(13),
//                 border:
//                     Border.all(color: AppColors.textColor3.withOpacity(0.18))),
//             child: StreamBuilder(
//               stream: controller.contentAgeResponse.stream,
//               builder: (_, snap) {
//                 if (controller.contentAgeResponse.isEmpty) return SizedBox();

//                 List<String> items = controller.contentAgeResponse
//                     .map((e) => e!.ageLabel ?? '')
//                     .toList();

//                 return Obx(
//                   () => DropdownButton(
//                     value: controller.contentAgeSuitability.value.isNotEmpty
//                         ? controller.contentAgeSuitability.value
//                         : null,
//                     isExpanded: true,
//                     dropdownColor: AppColors.cardBgColor,
//                     underline: SizedBox(),
//                     items: items
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (val) => controller.setAge(val),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       );

//   //──────────────────────── CAPTION ─────────────────────────────//

//   Widget captionInput() => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label("Caption"),
//           SizedBox(height: 8),
//           inputBox(controller.captionController,
//               hint: "Write something...", maxLines: 4, maxLength: 300),
//         ],
//       );

//   //──────────────────────── CREATE / UPDATE ─────────────────────────────//

//   Widget buildSubmit(BottomNavController nav) => Padding(
//         padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 AppColors.primaryColor,
//                 AppColors.primaryColorShade
//               ]),
//               borderRadius: BorderRadius.circular(12)),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 padding: EdgeInsets.symmetric(vertical: 15)),
//             onPressed: () {
//               widget.isEditing
//                   ? controller.updatePost(widget.post!.id!)
//                   : controller.createPost(
//                       () => nav.changeTabIndex(0), widget.communityId);
//             },
//             child: Text(
//               widget.isEditing ? "Update Post" : "Create Post",
//               style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//           ),
//         ),
//       );

//   //──────────────────────── HELPERS ─────────────────────────────//

//   Widget circleBtn(String icon) => Container(
//         decoration:
//             BoxDecoration(shape: BoxShape.circle, color: AppColors.cardBgColor),
//         padding: EdgeInsets.all(16),
//         child: Image.asset(icon, height: 38, width: 38),
//       );

//   Widget removeBtn(VoidCallback tap) => GestureDetector(
//         onTap: tap,
//         child: CircleAvatar(
//           radius: 12,
//           backgroundColor: Colors.black54,
//           child: Icon(Icons.close, color: Colors.white, size: 14),
//         ),
//       );

//   Widget label(String text) => Text(
//         text,
//         style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: AppColors.textColor3),
//       );

//   Widget inputBox(TextEditingController ctr,
//       {required String hint, int? maxLines, int? maxLength}) {
//     return TextField(
//       controller: ctr,
//       maxLines: maxLines,
//       maxLength: maxLength,
//       style: TextStyle(color: Colors.white, fontSize: 14),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white60),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
// }


//-------------latest 


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import 'package:video_player/video_player.dart';
// import 'package:dotted_border/dotted_border.dart';
// import '../../config/app_config.dart';
// import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
// import '../../widgets/full_screen_image_viewer.dart';
// import '../home/home_screen.dart';
// import 'create_post_controller.dart';
// import 'widgets/create_post_tab_button.dart';

// class CreatePostScreen extends StatelessWidget {
//   final String comingFromScreen;
//   final String communityId;

//   CreatePostScreen({
//     Key? key,
//     required this.comingFromScreen,
//     required this.communityId,
//   }) : super(key: key);

//   final CreatePostController controller = Get.put(CreatePostController());

//   @override
//   Widget build(BuildContext context) {
//     final BottomNavController navController = Get.find<BottomNavController>();

//     return PopScope(
//       canPop: comingFromScreen != 'community_feed' ? false : true,
//       onPopInvoked: (didPop) {
//         controller.clearData();

//         if (comingFromScreen != 'community_feed') {
//           navController.changeTabIndex(0);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: SafeArea(
//           child: Column(
//             children: [
//               // Top AppBar
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 14,
//                   left: 8,
//                   right: 8,
//                   bottom: 6,
//                 ),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         controller.clearData();

//                         if (comingFromScreen == 'community_feed') {
//                           Get.back();
//                         } else {
//                           navController.changeTabIndex(0);
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Image.asset(
//                           AppImages.backArrow,
//                           height: 11,
//                           width: 11,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           AppStrings.createNewPostTitle,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen20,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 19),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 3),

//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 22),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Tabs
//                       SizedBox(
//                         height: 32,
//                         child: Obx(
//                           () => Row(
//                             children: [
//                               Expanded(
//                                 child: CreatePostTabButton(
//                                   label: AppStrings.addImagesTab,
//                                   selected: controller.tabIndex.value == 0,
//                                   onTap: () => controller.tabIndex.value = 0,
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Expanded(
//                                 child: CreatePostTabButton(
//                                   label: AppStrings.addVideoTab,
//                                   selected: controller.tabIndex.value == 1,
//                                   onTap: () => controller.tabIndex.value = 1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 18),

//                       // IMAGE/VIDEO Picker Area with dotted border!
//                       Obx(() => IndexedStack(
//                             index: controller.tabIndex.value,
//                             children: [
//                               // Images Tab
//                               DottedBorder(
//                                 color: AppColors.bgColor.withOpacity(1),
//                                 strokeWidth: 2,
//                                 borderType: BorderType.RRect,
//                                 dashPattern: const [3, 3],
//                                 radius: const Radius.circular(15),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 185,
//                                   decoration: BoxDecoration(
//                                     color: Colors.transparent,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: controller.images.isEmpty
//                                       ? GestureDetector(
//                                           onTap: controller.pickImages,
//                                           child: Center(
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: AppColors.cardBgColor,
//                                               ),
//                                               padding: const EdgeInsets.all(16),
//                                               child: Image.asset(
//                                                 AppImages.profilePicIcon,
//                                                 height: 40,
//                                                 width: 40,
//                                                 color: AppColors.primaryColor,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : ListView.separated(
//                                           key: const PageStorageKey(
//                                             'images_list',
//                                           ),
//                                           scrollDirection: Axis.horizontal,
//                                           itemCount: controller.images.length,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 12),
//                                           separatorBuilder: (_, __) =>
//                                               SizedBox(width: 10),
//                                           itemBuilder: (ctx, i) => Stack(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.of(context).push(
//                                                     MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           FullScreenImageViewer(
//                                                         images: controller
//                                                             .images
//                                                             .map((f) => f.path)
//                                                             .toList(),
//                                                         initialIndex: i,
//                                                         heroTag: controller
//                                                             .images[i].path,
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Hero(
//                                                   tag:
//                                                       controller.images[i].path,
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             13),
//                                                     child: Image.file(
//                                                       controller.images[i],
//                                                       key: ValueKey(controller
//                                                           .images[i].path),
//                                                       width: 150,
//                                                       fit: BoxFit.cover,
//                                                       gaplessPlayback: true,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 2,
//                                                 right: 2,
//                                                 child: GestureDetector(
//                                                   onTap: () => controller
//                                                       .removeImageAt(i),
//                                                   child: CircleAvatar(
//                                                     radius: 11,
//                                                     backgroundColor:
//                                                         Colors.black45,
//                                                     child: Icon(Icons.close,
//                                                         color: Colors.white,
//                                                         size: 14),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                               // Video Tab
//                               DottedBorder(
//                                 color: AppColors.bgColor.withOpacity(1),
//                                 strokeWidth: 2,
//                                 borderType: BorderType.RRect,
//                                 dashPattern: const [3, 3],
//                                 radius: const Radius.circular(15),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: 185,
//                                   decoration: BoxDecoration(
//                                     color: Colors.transparent,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: controller.video.value == null
//                                       ? GestureDetector(
//                                           onTap: controller.pickVideo,
//                                           child: Center(
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: AppColors.cardBgColor,
//                                               ),
//                                               padding: const EdgeInsets.all(14),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: AppColors.primaryColor
//                                                       .withOpacity(0.1),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(9.0),
//                                                   child: Image.asset(
//                                                     AppImages.videoIcon,
//                                                     height: 24,
//                                                     width: 24,
//                                                     color:
//                                                         AppColors.primaryColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : GetBuilder<CreatePostController>(
//                                           id: 'video_player',
//                                           builder: (ctrl) {
//                                             if (ctrl.videoPlayerFuture ==
//                                                 null) {
//                                               return Center(
//                                                   child:
//                                                       CircularProgressIndicator());
//                                             }
//                                             return FutureBuilder(
//                                               future: ctrl.videoPlayerFuture,
//                                               builder: (context, snapshot) {
//                                                 if (snapshot.connectionState !=
//                                                     ConnectionState.done) {
//                                                   return Center(
//                                                       child:
//                                                           CircularProgressIndicator());
//                                                 }
//                                                 final controller =
//                                                     ctrl.videoPlayerController!;
//                                                 final size =
//                                                     controller.value.size;
//                                                 if (size.width == 0 ||
//                                                     size.height == 0) {
//                                                   return Center(
//                                                       child: Text(
//                                                           'Loading video...'));
//                                                 }
//                                                 final isLandscape =
//                                                     size.width > size.height;
//                                                 return Stack(
//                                                   children: [
//                                                     ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15),
//                                                       child: SizedBox(
//                                                         width: double.infinity,
//                                                         height: 185,
//                                                         child: isLandscape
//                                                             ? LayoutBuilder(
//                                                                 builder: (context,
//                                                                     constraints) {
//                                                                   final containerWidth =
//                                                                       constraints
//                                                                           .maxWidth;
//                                                                   final aspectRatio =
//                                                                       size.width /
//                                                                           size.height;
//                                                                   final videoHeight =
//                                                                       containerWidth /
//                                                                           aspectRatio;
//                                                                   return OverflowBox(
//                                                                     maxWidth:
//                                                                         containerWidth,
//                                                                     maxHeight:
//                                                                         double
//                                                                             .infinity,
//                                                                     child:
//                                                                         SizedBox(
//                                                                       width:
//                                                                           containerWidth,
//                                                                       height:
//                                                                           videoHeight,
//                                                                       child: VideoPlayer(
//                                                                           controller),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                               )
//                                                             : Center(
//                                                                 child:
//                                                                     FittedBox(
//                                                                   fit: BoxFit
//                                                                       .cover,
//                                                                   alignment:
//                                                                       Alignment
//                                                                           .center,
//                                                                   child:
//                                                                       SizedBox(
//                                                                     width: size
//                                                                         .width,
//                                                                     height: size
//                                                                         .height,
//                                                                     child: VideoPlayer(
//                                                                         controller),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                       ),
//                                                     ),
//                                                     // Play/Pause overlay
//                                                     Positioned.fill(
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             if (ctrl
//                                                                 .videoPlayerController!
//                                                                 .value
//                                                                 .isPlaying) {
//                                                               ctrl.videoPlayerController!
//                                                                   .pause();
//                                                             } else {
//                                                               ctrl.videoPlayerController!
//                                                                   .play();
//                                                             }
//                                                             ctrl.update([
//                                                               'video_player'
//                                                             ]);
//                                                           },
//                                                           child: Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: Colors
//                                                                   .black54,
//                                                               shape: BoxShape
//                                                                   .circle,
//                                                             ),
//                                                             width: 48,
//                                                             height: 48,
//                                                             child: Icon(
//                                                               ctrl
//                                                                       .videoPlayerController!
//                                                                       .value
//                                                                       .isPlaying
//                                                                   ? Icons.pause
//                                                                   : Icons
//                                                                       .play_arrow_rounded,
//                                                               color: AppColors
//                                                                   .whiteColor,
//                                                               size: 32,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     // Close button
//                                                     Positioned(
//                                                       top: 2,
//                                                       right: 2,
//                                                       child: GestureDetector(
//                                                         onTap: () =>
//                                                             ctrl.removeVideo(),
//                                                         child: CircleAvatar(
//                                                           radius: 11,
//                                                           backgroundColor:
//                                                               Colors.black45,
//                                                           child: Icon(
//                                                               Icons.close,
//                                                               color:
//                                                                   Colors.white,
//                                                               size: 14),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             );
//                                           },
//                                         ),
//                                 ),
//                               ),
//                             ],
//                           )),
//                       const SizedBox(height: 6),

//                       // Add Images/Video Button
//                       Obx(() {
//                         if (controller.tabIndex.value == 0) {
//                           // Images tab
//                           return Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: controller.pickImages,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 5,
//                                     horizontal: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Image.asset(
//                                         AppImages.addMore,
//                                         height: 22,
//                                         width: 22,
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Text(
//                                         AppStrings.addMoreImages,
//                                         style: TextStyle(
//                                           color: AppColors.whiteColor
//                                               .withOpacity(0.5),
//                                           fontSize: FontDimen.dimen11,
//                                           fontFamily:
//                                               GoogleFonts.inter().fontFamily,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else {
//                           // Video tab
//                           return Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: controller.pickVideo,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 5,
//                                     horizontal: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.video_call,
//                                         color: AppColors.primaryColor,
//                                         size: 22,
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Text(
//                                         AppStrings.addVideo,
//                                         style: TextStyle(
//                                           color: AppColors.whiteColor
//                                               .withOpacity(0.5),
//                                           fontSize: FontDimen.dimen11,
//                                           fontFamily:
//                                               GoogleFonts.inter().fontFamily,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }
//                       }),
//                       const SizedBox(height: 11),

//                       // Tag Location
//                       Text(
//                         AppStrings.tagLocation,
//                         style: TextStyle(
//                           color: AppColors.textColor3.withOpacity(1),
//                           fontSize: FontDimen.dimen13,
//                           fontFamily: GoogleFonts.inter().fontFamily,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 7),
//                       _buildTextInput(
//                         controller: controller.locationController,
//                         hintText: AppStrings.addLocationHint,
//                         keyboardType: TextInputType.text,
//                         maxLines: 1,
//                       ),
//                       const SizedBox(height: 19),

//                       // Age Suitability Dropdown
//                       Text(
//                         AppStrings.setContentAgeSuitability,
//                         style: TextStyle(
//                           color: AppColors.textColor3.withOpacity(1),
//                           fontSize: FontDimen.dimen13,
//                           fontFamily: GoogleFonts.inter().fontFamily,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           border: Border.all(
//                             color: AppColors.textColor3.withOpacity(0.17),
//                             width: 1.1,
//                           ),
//                           borderRadius: BorderRadius.circular(13),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 14),
//                         child: SizedBox(
//                           height: 52,
//                           child: StreamBuilder(
//                               stream: controller.contentAgeResponse.stream,
//                               builder: (context, snapshot) {
//                                 if (controller
//                                     .contentAgeResponse.value.isEmpty) {
//                                   return Container();
//                                 }

//                                 List<String> options = [];
//                                 controller.contentAgeResponse.value
//                                     .map((e) => options.add(e?.ageLabel ?? ''))
//                                     .toList();
//                                 return Obx(
//                                   () => DropdownButton<String>(
//                                       value: controller.contentAgeSuitability
//                                               .value.isNotEmpty
//                                           ? controller
//                                               .contentAgeSuitability.value
//                                           : null,
//                                       isExpanded: true,
//                                       underline: SizedBox.shrink(),
//                                       icon: Padding(
//                                         padding: const EdgeInsets.only(
//                                           right: 9,
//                                           top: 8,
//                                         ),
//                                         child: RotatedBox(
//                                           quarterTurns: 3,
//                                           child: Image.asset(
//                                             AppImages.backArrow,
//                                             height: 11,
//                                             width: 11,
//                                           ),
//                                         ),
//                                       ),
//                                       dropdownColor: AppColors.cardBgColor,
//                                       style: TextStyle(
//                                         color: AppColors.textColor3
//                                             .withOpacity(0.67),
//                                         fontFamily: AppFonts.appFont,
//                                         fontSize: FontDimen.dimen13,
//                                       ),
//                                       items: options
//                                           .map(
//                                             (e) => DropdownMenuItem<String>(
//                                               value: e,
//                                               child: Text(
//                                                 e,
//                                                 style: TextStyle(
//                                                   color: AppColors.textColor3
//                                                       .withOpacity(1),
//                                                   fontSize: FontDimen.dimen13,
//                                                   fontFamily:
//                                                       GoogleFonts.inter()
//                                                           .fontFamily,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                           .toList(),
//                                       onChanged: (val) {
//                                         controller.contentAgeSuitability.value =
//                                             val ?? AppStrings.contentAge16;

//                                         if (val != null) {
//                                           ContentAgeData? data = controller
//                                               .contentAgeResponse.value
//                                               .firstWhere(
//                                                   (e) => e!.ageLabel == val);

//                                           if (data != null) {
//                                             controller.contentAgeSuitabilityId
//                                                 .value = data.id ?? 0;
//                                             debugPrint(
//                                                 'content age suit ${controller.contentAgeSuitabilityId.value}');
//                                           }
//                                         }
//                                       }),
//                                 );
//                               }),
//                         ),
//                       ),

//                       const SizedBox(height: 32),

//                       // Caption
//                       Text(
//                         AppStrings.caption,
//                         style: TextStyle(
//                           color: AppColors.textColor3.withOpacity(1),
//                           fontSize: FontDimen.dimen13,
//                           fontFamily: GoogleFonts.inter().fontFamily,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildTextInput(
//                         controller: controller.captionController,
//                         hintText: AppStrings.addCaptionHint,
//                         keyboardType: TextInputType.text,
//                         maxLines: 4,
//                         maxLength: 300,
//                         showCharCount: true,
//                       ),
//                       const SizedBox(height: 33),
//                     ],
//                   ),
//                 ),
//               ),

//               // Create Post Button
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.primaryColor,
//                         AppColors.primaryColorShade,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // on success function used for navigation to bottom tab or back depending upon from where it is coming from
//                         controller.createPost(() {
//                           controller.clearData();

//                           if (comingFromScreen == 'community_feed') {
//                             Get.back();
//                           } else {
//                             navController.changeTabIndex(0);
//                           }
//                         } , communityId.toString());
//                         // validation and upload logic here!
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         AppStrings.createPostBtn,
//                         style: TextStyle(
//                           color: AppColors.whiteColor.withOpacity(0.92),
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: GoogleFonts.inter().fontFamily,
//                         ),
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

//   Widget _buildTextInput({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType keyboardType = TextInputType.text,
//     int? maxLines,
//     int? maxLength,
//     bool showCharCount = false,
//     Widget? suffixIcon,
//     bool readOnly = false,
//     Function()? onTap,
//     void Function(String)? onChanged,
//   }) {
//     return Stack(
//       children: [
//         Center(
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             onTap: onTap,
//             onChanged: onChanged,
//             maxLines: maxLines,
//             maxLength: maxLength,
//             style: TextStyle(
//               color: AppColors.textColor3.withOpacity(1),
//               fontSize: FontDimen.dimen14,
//               fontFamily: GoogleFonts.inter().fontFamily,
//             ),
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(
//                 color: AppColors.textColor2.withOpacity(0.3),
//                 fontSize: FontDimen.dimen13,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: GoogleFonts.inter().fontFamily,
//               ),
//               contentPadding: showCharCount && maxLength != null
//                   ? const EdgeInsets.fromLTRB(16, 16, 16, 36)
//                   : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: AppColors.textColor3.withOpacity(0.17),
//                   width: 1.1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: AppColors.primaryColor,
//                   width: 1.1,
//                 ),
//               ),
//               suffixIcon: suffixIcon,
//               counterText: "",
//             ),
//           ),
//         ),
//         if (showCharCount && maxLength != null)
//           Positioned(
//             right: 18,
//             bottom: 12,
//             child: ValueListenableBuilder<TextEditingValue>(
//               valueListenable: controller,
//               builder: (context, value, _) {
//                 return Text(
//                   '${value.text.characters.length}/$maxLength',
//                   style: TextStyle(
//                     color: AppColors.textColor2.withOpacity(0.5),
//                     fontSize: FontDimen.dimen12,
//                     fontFamily: GoogleFonts.inter().fontFamily,
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
//---------------------- CREATE POST SCREEN UPDATED FULL ---------------------//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:video_player/video_player.dart';
// import 'package:dotted_border/dotted_border.dart';
// import '../../config/app_config.dart';
// import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
// import '../../widgets/full_screen_image_viewer.dart';
// import 'create_post_controller.dart';
// import 'widgets/create_post_tab_button.dart';

// class CreatePostScreen extends StatefulWidget {
//   final String comingFromScreen;
//   final String communityId;

//   /// For EDIT POST MODE
//   final Posts? post;
//   final bool isEditing;

//   CreatePostScreen({
//     super.key,
//     required this.comingFromScreen,
//     required this.communityId,
//     this.post,
//     this.isEditing = false,
//   });

//   @override
//   State<CreatePostScreen> createState() => _CreatePostScreenState();
// }

// // ---------------------------------------------------------------------------//

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final CreatePostController controller = Get.put(CreatePostController());
//   bool _editDataLoaded = false;
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditing && widget.post != null) {
//       loadEditData();
//     } else {
//       _editDataLoaded = true;
//     }
//   }

//   /// 🔥 Pre-fill previous post data safely (No Crash)
//   /// 🔥 Pre-fill previous post data safely (No Crash)
//   void loadEditData() async {
//     _editDataLoaded = false;
//     setState(() {});

//     await Future.delayed(Duration(milliseconds: 400)); // Wait for dropdown API

//     controller.captionController.text = widget.post?.caption ?? "";
//     controller.locationController.text = widget.post?.location ?? "";

//     if (widget.post?.images != null && widget.post!.images!.isNotEmpty) {
//       controller.imagesFromServer.assignAll(widget.post!.images!);
//     }

//     // Set video from server if exists
//     if (widget.post?.video != null && widget.post!.video!.isNotEmpty) {
//       controller.serverVideoUrl.value = widget.post!.video!;

//       // If editing a video post, switch to video tab
//       if (controller.tabIndex.value == 1) {
//         await controller.initializeVideoPlayerFromUrl(widget.post!.video!);
//       }
//     }

//     // ---------------- AGE SECTION (Final & Safe) -----------------
//     if (widget.post?.ageSuitability != null &&
//         controller.contentAgeResponse.isNotEmpty) {
//       List<ContentAgeData?> found = controller.contentAgeResponse
//           .where((e) => e?.id.toString() == widget.post!.ageSuitability!)
//           .toList();

//       if (found.isNotEmpty && found.first != null) {
//         controller.contentAgeSuitabilityId.value = found.first!.id ?? 0;
//         controller.contentAgeSuitability.value = found.first!.ageLabel ?? "";
//       } else {
//         controller.contentAgeSuitabilityId.value =
//             int.tryParse(widget.post!.ageSuitability!) ?? 0;
//         controller.contentAgeSuitability.value =
//             ""; // keeps dropdown safe, No crash
//       }
//     }

//     _editDataLoaded = true;
//     setState(() {});
//   }
//   // ---------------------------------------------------------------------------//

//   void _handleSubmission() async {
//     if (_isSubmitting) return;

//     _isSubmitting = true;
//     setState(() {});

//     try {
//       if (widget.isEditing) {
//         await controller.updatePost(widget.post!.id!);
//         _navigateAfterSuccess(); // Call navigation after successful update
//       } else {
//         // FIX: Pass communityId as second parameter and navigation callback as first
//         await controller.createPost(_navigateAfterSuccess, widget.communityId);
//       }

//       // Navigation is now handled in _navigateAfterSuccess callback
//     } catch (e) {
//       // Handle error - don't navigate
//       print('Error in submission: $e');
//       if (mounted) {
//         _isSubmitting = false;
//         setState(() {});
//       }
//     }
//   }

//   void _navigateAfterSuccess() {
//     if (mounted) {
//       controller.clearData();
//       if (widget.comingFromScreen == 'community_feed') {
//         Get.back();
//       } else {
//         final navController = Get.find<BottomNavController>();
//         navController.changeTabIndex(0);
//       }
//     }
//   }

//   void _handleBackPress() {
//     controller.clearData();
//     if (widget.comingFromScreen == 'community_feed') {
//       Get.back(closeOverlays: true);
//     } else {
//       // final navController = Get.find<BottomNavController>();
//       // navController.changeTabIndex(0);
//       Get.back(closeOverlays: true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _handleBackPress();
//         return false; // Prevent default back behavior since we're handling it manually
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: SafeArea(
//           child: Column(
//             children: [
//               // Top AppBar
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 14,
//                   left: 8,
//                   right: 8,
//                   bottom: 6,
//                 ),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: _handleBackPress,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Image.asset(
//                           AppImages.backArrow,
//                           height: 11,
//                           width: 11,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           widget.isEditing
//                               ? "Edit Post"
//                               : AppStrings.createNewPostTitle,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen20,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 19),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 3),

//               if (!_editDataLoaded)
//                 Expanded(
//                   child: Center(
//                     child: CircularProgressIndicator(
//                         color: AppColors.primaryColor),
//                   ),
//                 ),

//               if (_editDataLoaded)
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(horizontal: 22),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Tabs
//                         SizedBox(
//                           height: 32,
//                           child: Obx(
//                             () => Row(
//                               children: [
//                                 Expanded(
//                                   child: CreatePostTabButton(
//                                     label: AppStrings.addImagesTab,
//                                     selected: controller.tabIndex.value == 0,
//                                     onTap: () => controller.tabIndex.value = 0,
//                                   ),
//                                 ),
//                                 SizedBox(width: 15),
//                                 Expanded(
//                                   child: CreatePostTabButton(
//                                     label: AppStrings.addVideoTab,
//                                     selected: controller.tabIndex.value == 1,
//                                     onTap: () => controller.tabIndex.value = 1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 18),

//                         // IMAGE/VIDEO Picker Area with dotted border!
//                         Obx(() => IndexedStack(
//                               index: controller.tabIndex.value,
//                               children: [
//                                 // Images Tab
//                                 DottedBorder(
//                                   color: AppColors.bgColor.withOpacity(1),
//                                   strokeWidth: 2,
//                                   borderType: BorderType.RRect,
//                                   dashPattern: const [3, 3],
//                                   radius: const Radius.circular(15),
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: 185,
//                                     decoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: _buildImageContent(),
//                                   ),
//                                 ),

//                                 // Video Tab
//                                 DottedBorder(
//                                   color: AppColors.bgColor.withOpacity(1),
//                                   strokeWidth: 2,
//                                   borderType: BorderType.RRect,
//                                   dashPattern: const [3, 3],
//                                   radius: const Radius.circular(15),
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: 185,
//                                     decoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: _buildVideoContent(),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                         const SizedBox(height: 6),

//                         // Add Images/Video Button
//                         Obx(() {
//                           if (controller.tabIndex.value == 0) {
//                             // Images tab
//                             return Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: controller.pickImages,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 5,
//                                       horizontal: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Image.asset(
//                                           AppImages.addMore,
//                                           height: 22,
//                                           width: 22,
//                                         ),
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           AppStrings.addMoreImages,
//                                           style: TextStyle(
//                                             color: AppColors.whiteColor
//                                                 .withOpacity(0.5),
//                                             fontSize: FontDimen.dimen11,
//                                             fontFamily: AppFonts.appFont,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           } else {
//                             // Video tab
//                             return Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: controller.pickVideo,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 5,
//                                       horizontal: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           Icons.video_call,
//                                           color: AppColors.primaryColor,
//                                           size: 22,
//                                         ),
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           AppStrings.addVideo,
//                                           style: TextStyle(
//                                             color: AppColors.whiteColor
//                                                 .withOpacity(0.5),
//                                             fontSize: FontDimen.dimen11,
//                                             fontFamily: AppFonts.appFont,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }
//                         }),
//                         const SizedBox(height: 11),

//                         // Tag Location
//                         Text(
//                           AppStrings.tagLocation,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen13,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 7),
//                         _buildTextInput(
//                           controller: controller.locationController,
//                           hintText: AppStrings.addLocationHint,
//                           keyboardType: TextInputType.text,
//                           maxLines: 1,
//                         ),
//                         const SizedBox(height: 19),

//                         // Age Suitability Dropdown
//                         Text(
//                           AppStrings.setContentAgeSuitability,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen13,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.transparent,
//                             border: Border.all(
//                               color: AppColors.textColor3.withOpacity(0.17),
//                               width: 1.1,
//                             ),
//                             borderRadius: BorderRadius.circular(13),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 14),
//                           child: SizedBox(
//                             height: 52,
//                             child: StreamBuilder(
//                               stream: controller.contentAgeResponse.stream,
//                               builder: (context, snapshot) {
//                                 if (controller
//                                     .contentAgeResponse.value.isEmpty) {
//                                   return Container();
//                                 }
//                                 List<String> options = [];
//                                 controller.contentAgeResponse.value
//                                     .map((e) => options.add(e?.ageLabel ?? ''))
//                                     .toList();
//                                 return Obx(
//                                   () => DropdownButton<String>(
//                                     value: controller.contentAgeSuitability
//                                             .value.isNotEmpty
//                                         ? controller.contentAgeSuitability.value
//                                         : null,
//                                     isExpanded: true,
//                                     underline: SizedBox.shrink(),
//                                     icon: Padding(
//                                       padding: const EdgeInsets.only(
//                                         right: 9,
//                                         top: 8,
//                                       ),
//                                       child: RotatedBox(
//                                         quarterTurns: 3,
//                                         child: Image.asset(
//                                           AppImages.backArrow,
//                                           height: 11,
//                                           width: 11,
//                                         ),
//                                       ),
//                                     ),
//                                     dropdownColor: AppColors.cardBgColor,
//                                     style: TextStyle(
//                                       color: AppColors.textColor3
//                                           .withOpacity(0.67),
//                                       fontFamily: AppFonts.appFont,
//                                       fontSize: FontDimen.dimen13,
//                                     ),
//                                     items: options
//                                         .map(
//                                           (e) => DropdownMenuItem<String>(
//                                             value: e,
//                                             child: Text(
//                                               e,
//                                               style: TextStyle(
//                                                 color: AppColors.textColor3
//                                                     .withOpacity(1),
//                                                 fontSize: FontDimen.dimen13,
//                                                 fontFamily: AppFonts.appFont,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                                     onChanged: (val) {
//                                       controller.contentAgeSuitability.value =
//                                           val ?? AppStrings.contentAge16;
//                                       if (val != null) {
//                                         ContentAgeData? data = controller
//                                             .contentAgeResponse.value
//                                             .firstWhere(
//                                                 (e) => e!.ageLabel == val);
//                                         if (data != null) {
//                                           controller.contentAgeSuitabilityId
//                                               .value = data.id ?? 0;
//                                         }
//                                       }
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         // Caption
//                         Text(
//                           AppStrings.caption,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen13,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _buildTextInput(
//                           controller: controller.captionController,
//                           hintText: AppStrings.addCaptionHint,
//                           keyboardType: TextInputType.text,
//                           maxLines: 4,
//                           maxLength: 300,
//                           showCharCount: true,
//                         ),
//                         const SizedBox(height: 33),
//                       ],
//                     ),
//                   ),
//                 ),

//               if (_editDataLoaded)
//                 // Create/Update Post Button
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColors.primaryColor,
//                           AppColors.primaryColorShade,
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isSubmitting ? null : _handleSubmission,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _isSubmitting
//                             ? SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white),
//                                 ),
//                               )
//                             : Text(
//                                 widget.isEditing
//                                     ? "Update Post"
//                                     : AppStrings.createPostBtn,
//                                 style: TextStyle(
//                                   color: AppColors.whiteColor.withOpacity(0.92),
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: AppFonts.appFont,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //──────────────────────── IMAGE CONTENT BUILDER ─────────────────────────────//

//   Widget _buildImageContent() {
//     // For edit mode: Show both server images and newly picked images
//     // For create mode: Show only picked images
//     bool hasServerImages =
//         widget.isEditing && controller.imagesFromServer.isNotEmpty;
//     bool hasPickedImages = controller.images.isNotEmpty;
//     bool hasAnyImages = hasServerImages || hasPickedImages;

//     if (!hasAnyImages) {
//       return addImageButton();
//     }

//     return ListView.separated(
//       key: const PageStorageKey('images_list'),
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       separatorBuilder: (_, __) => SizedBox(width: 10),
//       itemCount: _getTotalImageCount(),
//       itemBuilder: (ctx, index) {
//         if (widget.isEditing && index < controller.imagesFromServer.length) {
//           // Server image in edit mode
//           return _buildServerImageItem(index);
//         } else {
//           // Newly picked image (in both create and edit modes)
//           int pickedImageIndex = widget.isEditing
//               ? index - controller.imagesFromServer.length
//               : index;
//           return _buildPickedImageItem(pickedImageIndex);
//         }
//       },
//     );
//   }

//   int _getTotalImageCount() {
//     if (widget.isEditing) {
//       return controller.imagesFromServer.length + controller.images.length;
//     } else {
//       return controller.images.length;
//     }
//   }

//   Widget _buildServerImageItem(int index) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             _openFullScreenImageViewer(
//               images: controller.imagesFromServer,
//               initialIndex: index,
//               heroTag: controller.imagesFromServer[index],
//             );
//           },
//           child: Hero(
//             tag: controller.imagesFromServer[index],
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: Image.network(
//                 controller.imagesFromServer[index],
//                 key: ValueKey(controller.imagesFromServer[index]),
//                 width: 150,
//                 fit: BoxFit.cover,
//                 gaplessPlayback: true,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: () => controller.removeServerImage(index),
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.black45,
//               child: Icon(Icons.close, color: Colors.white, size: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPickedImageItem(int index) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             List<String> allImagePaths = [];
//             if (widget.isEditing) {
//               allImagePaths.addAll(controller.imagesFromServer);
//             }
//             allImagePaths.addAll(controller.images.map((f) => f.path).toList());

//             _openFullScreenImageViewer(
//               images: allImagePaths,
//               initialIndex: widget.isEditing
//                   ? controller.imagesFromServer.length + index
//                   : index,
//               heroTag: controller.images[index].path,
//             );
//           },
//           child: Hero(
//             tag: controller.images[index].path,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: Image.file(
//                 controller.images[index],
//                 key: ValueKey(controller.images[index].path),
//                 width: 150,
//                 fit: BoxFit.cover,
//                 gaplessPlayback: true,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: () => controller.removeImageAt(index),
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.black45,
//               child: Icon(Icons.close, color: Colors.white, size: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _openFullScreenImageViewer({
//     required List<String> images,
//     required int initialIndex,
//     required String heroTag,
//   }) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => FullScreenImageViewer(
//           images: images,
//           initialIndex: initialIndex,
//           heroTag: heroTag,
//         ),
//       ),
//     );
//   }

//   Widget addImageButton() => GestureDetector(
//         onTap: controller.pickImages,
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.cardBgColor,
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Image.asset(
//               AppImages.profilePicIcon,
//               height: 40,
//               width: 40,
//               color: AppColors.primaryColor,
//             ),
//           ),
//         ),
//       );

//   //──────────────────────── VIDEO CONTENT BUILDER ─────────────────────────────//

//   Widget _buildVideoContent() {
//     // For edit mode: Show server video if exists, otherwise show picked video
//     // For create mode: Show picked video
//     bool hasServerVideo = widget.isEditing &&
//         widget.post?.video != null &&
//         widget.post!.video!.isNotEmpty;
//     bool hasPickedVideo = controller.video.value != null;

//     if (hasServerVideo && !hasPickedVideo) {
//       return _buildServerVideo();
//     } else if (hasPickedVideo) {
//       return _buildPickedVideo();
//     } else {
//       return _buildAddVideoButton();
//     }
//   }

//   Widget _buildServerVideo() {
//     return Stack(
//       children: [
//         Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.video_library,
//                   size: 50, color: AppColors.primaryColor),
//               SizedBox(height: 10),
//               Text(
//                 "Server Video",
//                 style: TextStyle(
//                   color: AppColors.textColor3,
//                   fontSize: FontDimen.dimen14,
//                   fontFamily: AppFonts.appFont,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: () {
//               controller.removeVideo();
//             },
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.black45,
//               child: Icon(Icons.close, color: Colors.white, size: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPickedVideo() => GetBuilder<CreatePostController>(
//         id: 'video_player',
//         builder: (ctrl) {
//           if (ctrl.videoPlayerFuture == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return FutureBuilder(
//             future: ctrl.videoPlayerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               final controller = ctrl.videoPlayerController!;
//               final size = controller.value.size;
//               if (size.width == 0 || size.height == 0) {
//                 return Center(
//                     child: Text(
//                   'Loading video...',
//                   style: TextStyle(
//                     fontFamily: AppFonts.appFont,
//                     color: AppColors.textColor3,
//                   ),
//                 ));
//               }
//               final isLandscape = size.width > size.height;
//               return Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 185,
//                       child: isLandscape
//                           ? LayoutBuilder(
//                               builder: (context, constraints) {
//                                 final containerWidth = constraints.maxWidth;
//                                 final aspectRatio = size.width / size.height;
//                                 final videoHeight =
//                                     containerWidth / aspectRatio;
//                                 return OverflowBox(
//                                   maxWidth: containerWidth,
//                                   maxHeight: double.infinity,
//                                   child: SizedBox(
//                                     width: containerWidth,
//                                     height: videoHeight,
//                                     child: VideoPlayer(controller),
//                                   ),
//                                 );
//                               },
//                             )
//                           : Center(
//                               child: FittedBox(
//                                 fit: BoxFit.cover,
//                                 alignment: Alignment.center,
//                                 child: SizedBox(
//                                   width: size.width,
//                                   height: size.height,
//                                   child: VideoPlayer(controller),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                   // Play/Pause overlay
//                   Positioned.fill(
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (ctrl.videoPlayerController!.value.isPlaying) {
//                             ctrl.videoPlayerController!.pause();
//                           } else {
//                             ctrl.videoPlayerController!.play();
//                           }
//                           ctrl.update(['video_player']);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black54,
//                             shape: BoxShape.circle,
//                           ),
//                           width: 48,
//                           height: 48,
//                           child: Icon(
//                             ctrl.videoPlayerController!.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow_rounded,
//                             color: AppColors.whiteColor,
//                             size: 32,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Close button
//                   Positioned(
//                     top: 2,
//                     right: 2,
//                     child: GestureDetector(
//                       onTap: () => ctrl.removeVideo(),
//                       child: CircleAvatar(
//                         radius: 11,
//                         backgroundColor: Colors.black45,
//                         child: Icon(Icons.close, color: Colors.white, size: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );

//   Widget _buildAddVideoButton() => GestureDetector(
//         onTap: controller.pickVideo,
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.cardBgColor,
//             ),
//             padding: const EdgeInsets.all(14),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.primaryColor.withOpacity(0.1),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(9.0),
//                 child: Image.asset(
//                   AppImages.videoIcon,
//                   height: 24,
//                   width: 24,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );

//   //──────────────────────── TEXT INPUT WIDGET ─────────────────────────────//

//   Widget _buildTextInput({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType keyboardType = TextInputType.text,
//     int? maxLines,
//     int? maxLength,
//     bool showCharCount = false,
//     Widget? suffixIcon,
//     bool readOnly = false,
//     Function()? onTap,
//     void Function(String)? onChanged,
//   }) {
//     return Stack(
//       children: [
//         Center(
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             onTap: onTap,
//             onChanged: onChanged,
//             maxLines: maxLines,
//             maxLength: maxLength,
//             style: TextStyle(
//               color: AppColors.textColor3.withOpacity(1),
//               fontSize: FontDimen.dimen14,
//               fontFamily: AppFonts.appFont,
//             ),
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(
//                 color: AppColors.textColor2.withOpacity(0.3),
//                 fontSize: FontDimen.dimen13,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: AppFonts.appFont,
//               ),
//               contentPadding: showCharCount && maxLength != null
//                   ? const EdgeInsets.fromLTRB(16, 16, 16, 36)
//                   : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: AppColors.textColor3.withOpacity(0.17),
//                   width: 1.1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: AppColors.primaryColor,
//                   width: 1.1,
//                 ),
//               ),
//               suffixIcon: suffixIcon,
//               counterText: "",
//             ),
//           ),
//         ),
//         if (showCharCount && maxLength != null)
//           Positioned(
//             right: 18,
//             bottom: 12,
//             child: ValueListenableBuilder<TextEditingValue>(
//               valueListenable: controller,
//               builder: (context, value, _) {
//                 return Text(
//                   '${value.text.characters.length}/$maxLength',
//                   style: TextStyle(
//                     color: AppColors.textColor2.withOpacity(0.5),
//                     fontSize: FontDimen.dimen12,
//                     fontFamily: AppFonts.appFont,
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }

///////////////////////////-------------------------
///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:video_player/video_player.dart';
// import 'package:dotted_border/dotted_border.dart';
// import '../../config/app_config.dart';
// import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
// import '../../widgets/full_screen_image_viewer.dart';
// import 'create_post_controller.dart';
// import 'widgets/create_post_tab_button.dart';

// class CreatePostScreen extends StatefulWidget {
//   final String comingFromScreen;
//   final String communityId;
//   final Posts? post;
//   final bool isEditing;

//   CreatePostScreen({
//     super.key,
//     required this.comingFromScreen,
//     required this.communityId,
//     this.post,
//     this.isEditing = false,
//   });

//   @override
//   State<CreatePostScreen> createState() => _CreatePostScreenState();
// }

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final CreatePostController controller = Get.put(CreatePostController());
//   bool _editDataLoaded = false;
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditing && widget.post != null) {
//       loadEditData();
//     } else {
//       _editDataLoaded = true;
//     }
//   }

//   void loadEditData() async {
//     _editDataLoaded = false;
//     setState(() {});

//     await Future.delayed(Duration(milliseconds: 400));

//     controller.captionController.text = widget.post?.caption ?? "";
//     controller.locationController.text = widget.post?.location ?? "";

//     if (widget.post?.images != null && widget.post!.images!.isNotEmpty) {
//       controller.imagesFromServer.assignAll(widget.post!.images!);
//     }

//     if (widget.post?.video != null && widget.post!.video!.isNotEmpty) {
//       controller.serverVideoUrl.value = widget.post!.video!;
//       if (controller.tabIndex.value == 1) {
//         await controller.initializeVideoPlayerFromUrl(widget.post!.video!);
//       }
//     }

//     if (widget.post?.ageSuitability != null &&
//         controller.contentAgeResponse.isNotEmpty) {
//       List<ContentAgeData?> found = controller.contentAgeResponse
//           .where((e) => e?.id.toString() == widget.post!.ageSuitability!)
//           .toList();

//       if (found.isNotEmpty && found.first != null) {
//         controller.contentAgeSuitabilityId.value = found.first!.id ?? 0;
//         controller.contentAgeSuitability.value = found.first!.ageLabel ?? "";
//       } else {
//         controller.contentAgeSuitabilityId.value =
//             int.tryParse(widget.post!.ageSuitability!) ?? 0;
//         controller.contentAgeSuitability.value = "";
//       }
//     }

//     _editDataLoaded = true;
//     setState(() {});
//   }

//   void _handleSubmission() async {
//     if (_isSubmitting) return;

//     setState(() {
//       _isSubmitting = true;
//     });

//     try {
//       if (widget.isEditing) {
//         // FIXED: Pass onSuccess callback to updatePost
//         await controller.updatePost(widget.post!.id!, _navigateAfterSuccess);
//       } else {
//         // FIXED: Already has callback as first parameter
//         await controller.createPost(_navigateAfterSuccess, widget.communityId);
//       }
//     } catch (e) {
//       print('Error in submission: $e');
//       if (mounted) {
//         setState(() {
//           _isSubmitting = false;
//         });
//       }
//     }
//   }

//   void _navigateAfterSuccess() {
//     if (!mounted) return;

//     // Clear controller data
//     controller.clearData();

//     // Reset submission flag
//     if (mounted) {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }

//     // Navigate based on where we came from
//     if (widget.comingFromScreen == 'community_feed') {
//       // Return to community feed with refresh signal
//       Get.back(result: true);
//     } else {
//       // Return to home feed
//       try {
//         final navController = Get.find<BottomNavController>();
//         navController.changeTabIndex(0);
//       } catch (e) {
//         // If nav controller not found, just go back
//         Get.back(result: true);
//       }
//     }
//   }

//   void _handleBackPress() {
//     controller.clearData();
//     if (widget.comingFromScreen == 'community_feed') {
//       Get.back(closeOverlays: true);
//     } else {
//       Get.back(closeOverlays: true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _handleBackPress();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: SafeArea(
//           child: Column(
//             children: [
//               // Top AppBar
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 14,
//                   left: 8,
//                   right: 8,
//                   bottom: 6,
//                 ),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: _handleBackPress,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8),
//                         child: Image.asset(
//                           AppImages.backArrow,
//                           height: 11,
//                           width: 11,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           widget.isEditing
//                               ? "Edit Post"
//                               : AppStrings.createNewPostTitle,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen20,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 19),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 3),

//               if (!_editDataLoaded)
//                 Expanded(
//                   child: Center(
//                     child: CircularProgressIndicator(
//                         color: AppColors.primaryColor),
//                   ),
//                 ),

//               if (_editDataLoaded)
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(horizontal: 22),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Tabs
//                         SizedBox(
//                           height: 32,
//                           child: Obx(
//                             () => Row(
//                               children: [
//                                 Expanded(
//                                   child: CreatePostTabButton(
//                                     label: AppStrings.addImagesTab,
//                                     selected: controller.tabIndex.value == 0,
//                                     onTap: () => controller.tabIndex.value = 0,
//                                   ),
//                                 ),
//                                 SizedBox(width: 15),
//                                 Expanded(
//                                   child: CreatePostTabButton(
//                                     label: AppStrings.addVideoTab,
//                                     selected: controller.tabIndex.value == 1,
//                                     onTap: () => controller.tabIndex.value = 1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 18),

//                         // IMAGE/VIDEO Picker Area
//                         Obx(() => IndexedStack(
//                               index: controller.tabIndex.value,
//                               children: [
//                                 // Images Tab
//                                 DottedBorder(
//                                   color: AppColors.bgColor.withOpacity(1),
//                                   strokeWidth: 2,
//                                   borderType: BorderType.RRect,
//                                   dashPattern: const [3, 3],
//                                   radius: const Radius.circular(15),
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: 185,
//                                     decoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: _buildImageContent(),
//                                   ),
//                                 ),

//                                 // Video Tab
//                                 DottedBorder(
//                                   color: AppColors.bgColor.withOpacity(1),
//                                   strokeWidth: 2,
//                                   borderType: BorderType.RRect,
//                                   dashPattern: const [3, 3],
//                                   radius: const Radius.circular(15),
//                                   child: Container(
//                                     width: double.infinity,
//                                     height: 185,
//                                     decoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: _buildVideoContent(),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                         const SizedBox(height: 6),

//                         // Add Images/Video Button
//                         Obx(() {
//                           if (controller.tabIndex.value == 0) {
//                             return Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: controller.pickImages,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 5,
//                                       horizontal: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Image.asset(
//                                           AppImages.addMore,
//                                           height: 22,
//                                           width: 22,
//                                         ),
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           AppStrings.addMoreImages,
//                                           style: TextStyle(
//                                             color: AppColors.whiteColor
//                                                 .withOpacity(0.5),
//                                             fontSize: FontDimen.dimen11,
//                                             fontFamily: AppFonts.appFont,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           } else {
//                             return Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: controller.pickVideo,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 5,
//                                       horizontal: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           Icons.video_call,
//                                           color: AppColors.primaryColor,
//                                           size: 22,
//                                         ),
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           AppStrings.addVideo,
//                                           style: TextStyle(
//                                             color: AppColors.whiteColor
//                                                 .withOpacity(0.5),
//                                             fontSize: FontDimen.dimen11,
//                                             fontFamily: AppFonts.appFont,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }
//                         }),
//                         const SizedBox(height: 11),

//                         // Tag Location
//                         Text(
//                           AppStrings.tagLocation,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen13,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 7),
//                         _buildTextInput(
//                           controller: controller.locationController,
//                           hintText: AppStrings.addLocationHint,
//                           keyboardType: TextInputType.text,
//                           maxLines: 1,
//                         ),
//                         const SizedBox(height: 19),

//                         // Age Suitability Dropdown
//                         Text(
//                           AppStrings.setContentAgeSuitability,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen13,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.transparent,
//                             border: Border.all(
//                               color: AppColors.textColor3.withOpacity(0.17),
//                               width: 1.1,
//                             ),
//                             borderRadius: BorderRadius.circular(13),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 14),
//                           child: SizedBox(
//                             height: 52,
//                             child: StreamBuilder(
//                               stream: controller.contentAgeResponse.stream,
//                               builder: (context, snapshot) {
//                                 if (controller
//                                     .contentAgeResponse.value.isEmpty) {
//                                   return Container();
//                                 }
//                                 List<String> options = [];
//                                 controller.contentAgeResponse.value
//                                     .map((e) => options.add(e?.ageLabel ?? ''))
//                                     .toList();
//                                 return Obx(
//                                   () => DropdownButton<String>(
//                                     value: controller.contentAgeSuitability
//                                             .value.isNotEmpty
//                                         ? controller.contentAgeSuitability.value
//                                         : null,
//                                     isExpanded: true,
//                                     underline: SizedBox.shrink(),
//                                     icon: Padding(
//                                       padding: const EdgeInsets.only(
//                                         right: 9,
//                                         top: 8,
//                                       ),
//                                       child: RotatedBox(
//                                         quarterTurns: 3,
//                                         child: Image.asset(
//                                           AppImages.backArrow,
//                                           height: 11,
//                                           width: 11,
//                                         ),
//                                       ),
//                                     ),
//                                     dropdownColor: AppColors.cardBgColor,
//                                     style: TextStyle(
//                                       color: AppColors.textColor3
//                                           .withOpacity(0.67),
//                                       fontFamily: AppFonts.appFont,
//                                       fontSize: FontDimen.dimen13,
//                                     ),
//                                     items: options
//                                         .map(
//                                           (e) => DropdownMenuItem<String>(
//                                             value: e,
//                                             child: Text(
//                                               e,
//                                               style: TextStyle(
//                                                 color: AppColors.textColor3
//                                                     .withOpacity(1),
//                                                 fontSize: FontDimen.dimen13,
//                                                 fontFamily: AppFonts.appFont,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                         .toList(),
//                                     onChanged: (val) {
//                                       controller.contentAgeSuitability.value =
//                                           val ?? AppStrings.contentAge16;
//                                       if (val != null) {
//                                         ContentAgeData? data = controller
//                                             .contentAgeResponse.value
//                                             .firstWhere(
//                                                 (e) => e!.ageLabel == val);
//                                         if (data != null) {
//                                           controller.contentAgeSuitabilityId
//                                               .value = data.id ?? 0;
//                                         }
//                                       }
//                                     },
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 32),

//                         // Caption
//                         Text(
//                           AppStrings.caption,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontSize: FontDimen.dimen13,
//                             fontFamily: AppFonts.appFont,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _buildTextInput(
//                           controller: controller.captionController,
//                           hintText: AppStrings.addCaptionHint,
//                           keyboardType: TextInputType.text,
//                           maxLines: 4,
//                           maxLength: 300,
//                           showCharCount: true,
//                         ),
//                         const SizedBox(height: 33),
//                       ],
//                     ),
//                   ),
//                 ),

//               if (_editDataLoaded)
//                 // Create/Update Post Button
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColors.primaryColor,
//                           AppColors.primaryColorShade,
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isSubmitting ? null : _handleSubmission,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _isSubmitting
//                             ? SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white),
//                                 ),
//                               )
//                             : Text(
//                                 widget.isEditing
//                                     ? "Update Post"
//                                     : AppStrings.createPostBtn,
//                                 style: TextStyle(
//                                   color: AppColors.whiteColor.withOpacity(0.92),
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: AppFonts.appFont,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //──────────────────────── IMAGE CONTENT BUILDER ─────────────────────────────//

//   Widget _buildImageContent() {
//     bool hasServerImages =
//         widget.isEditing && controller.imagesFromServer.isNotEmpty;
//     bool hasPickedImages = controller.images.isNotEmpty;
//     bool hasAnyImages = hasServerImages || hasPickedImages;

//     if (!hasAnyImages) {
//       return addImageButton();
//     }

//     return ListView.separated(
//       key: const PageStorageKey('images_list'),
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       separatorBuilder: (_, __) => SizedBox(width: 10),
//       itemCount: _getTotalImageCount(),
//       itemBuilder: (ctx, index) {
//         if (widget.isEditing && index < controller.imagesFromServer.length) {
//           return _buildServerImageItem(index);
//         } else {
//           int pickedImageIndex = widget.isEditing
//               ? index - controller.imagesFromServer.length
//               : index;
//           return _buildPickedImageItem(pickedImageIndex);
//         }
//       },
//     );
//   }

//   int _getTotalImageCount() {
//     if (widget.isEditing) {
//       return controller.imagesFromServer.length + controller.images.length;
//     } else {
//       return controller.images.length;
//     }
//   }

//   Widget _buildServerImageItem(int index) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             _openFullScreenImageViewer(
//               images: controller.imagesFromServer,
//               initialIndex: index,
//               heroTag: controller.imagesFromServer[index],
//             );
//           },
//           child: Hero(
//             tag: controller.imagesFromServer[index],
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: Image.network(
//                 controller.imagesFromServer[index],
//                 key: ValueKey(controller.imagesFromServer[index]),
//                 width: 150,
//                 fit: BoxFit.cover,
//                 gaplessPlayback: true,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: () => controller.removeServerImage(index),
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.black45,
//               child: Icon(Icons.close, color: Colors.white, size: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPickedImageItem(int index) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             List<String> allImagePaths = [];
//             if (widget.isEditing) {
//               allImagePaths.addAll(controller.imagesFromServer);
//             }
//             allImagePaths.addAll(controller.images.map((f) => f.path).toList());

//             _openFullScreenImageViewer(
//               images: allImagePaths,
//               initialIndex: widget.isEditing
//                   ? controller.imagesFromServer.length + index
//                   : index,
//               heroTag: controller.images[index].path,
//             );
//           },
//           child: Hero(
//             tag: controller.images[index].path,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: Image.file(
//                 controller.images[index],
//                 key: ValueKey(controller.images[index].path),
//                 width: 150,
//                 fit: BoxFit.cover,
//                 gaplessPlayback: true,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: () => controller.removeImageAt(index),
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.black45,
//               child: Icon(Icons.close, color: Colors.white, size: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _openFullScreenImageViewer({
//     required List<String> images,
//     required int initialIndex,
//     required String heroTag,
//   }) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => FullScreenImageViewer(
//           images: images,
//           initialIndex: initialIndex,
//           heroTag: heroTag,
//         ),
//       ),
//     );
//   }

//   Widget addImageButton() => GestureDetector(
//         onTap: controller.pickImages,
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.cardBgColor,
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Image.asset(
//               AppImages.profilePicIcon,
//               height: 40,
//               width: 40,
//               color: AppColors.primaryColor,
//             ),
//           ),
//         ),
//       );

//   //──────────────────────── VIDEO CONTENT BUILDER ─────────────────────────────//

//   Widget _buildVideoContent() {
//     bool hasServerVideo = widget.isEditing &&
//         widget.post?.video != null &&
//         widget.post!.video!.isNotEmpty;
//     bool hasPickedVideo = controller.video.value != null;

//     if (hasServerVideo && !hasPickedVideo) {
//       return _buildServerVideo();
//     } else if (hasPickedVideo) {
//       return _buildPickedVideo();
//     } else {
//       return _buildAddVideoButton();
//     }
//   }

//   Widget _buildServerVideo() {
//     return Stack(
//       children: [
//         Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.video_library,
//                   size: 50, color: AppColors.primaryColor),
//               SizedBox(height: 10),
//               Text(
//                 "Server Video",
//                 style: TextStyle(
//                   color: AppColors.textColor3,
//                   fontSize: FontDimen.dimen14,
//                   fontFamily: AppFonts.appFont,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 2,
//           right: 2,
//           child: GestureDetector(
//             onTap: () {
//               controller.removeVideo();
//             },
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.black45,
//               child: Icon(Icons.close, color: Colors.white, size: 14),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPickedVideo() => GetBuilder<CreatePostController>(
//         id: 'video_player',
//         builder: (ctrl) {
//           if (ctrl.videoPlayerFuture == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return FutureBuilder(
//             future: ctrl.videoPlayerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               final controller = ctrl.videoPlayerController!;
//               final size = controller.value.size;
//               if (size.width == 0 || size.height == 0) {
//                 return Center(
//                     child: Text(
//                   'Loading video...',
//                   style: TextStyle(
//                     fontFamily: AppFonts.appFont,
//                     color: AppColors.textColor3,
//                   ),
//                 ));
//               }
//               final isLandscape = size.width > size.height;
//               return Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 185,
//                       child: isLandscape
//                           ? LayoutBuilder(
//                               builder: (context, constraints) {
//                                 final containerWidth = constraints.maxWidth;
//                                 final aspectRatio = size.width / size.height;
//                                 final videoHeight =
//                                     containerWidth / aspectRatio;
//                                 return OverflowBox(
//                                   maxWidth: containerWidth,
//                                   maxHeight: double.infinity,
//                                   child: SizedBox(
//                                     width: containerWidth,
//                                     height: videoHeight,
//                                     child: VideoPlayer(controller),
//                                   ),
//                                 );
//                               },
//                             )
//                           : Center(
//                               child: FittedBox(
//                                 fit: BoxFit.cover,
//                                 alignment: Alignment.center,
//                                 child: SizedBox(
//                                   width: size.width,
//                                   height: size.height,
//                                   child: VideoPlayer(controller),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (ctrl.videoPlayerController!.value.isPlaying) {
//                             ctrl.videoPlayerController!.pause();
//                           } else {
//                             ctrl.videoPlayerController!.play();
//                           }
//                           ctrl.update(['video_player']);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black54,
//                             shape: BoxShape.circle,
//                           ),
//                           width: 48,
//                           height: 48,
//                           child: Icon(
//                             ctrl.videoPlayerController!.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow_rounded,
//                             color: AppColors.whiteColor,
//                             size: 32,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 2,
//                     right: 2,
//                     child: GestureDetector(
//                       onTap: () => ctrl.removeVideo(),
//                       child: CircleAvatar(
//                         radius: 11,
//                         backgroundColor: Colors.black45,
//                         child: Icon(Icons.close, color: Colors.white, size: 14),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );

//   Widget _buildAddVideoButton() => GestureDetector(
//         onTap: controller.pickVideo,
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.cardBgColor,
//             ),
//             padding: const EdgeInsets.all(14),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.primaryColor.withOpacity(0.1),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(9.0),
//                 child: Image.asset(
//                   AppImages.videoIcon,
//                   height: 24,
//                   width: 24,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );

//   //──────────────────────── TEXT INPUT WIDGET ─────────────────────────────//

//   Widget _buildTextInput({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType keyboardType = TextInputType.text,
//     int? maxLines,
//     int? maxLength,
//     bool showCharCount = false,
//     Widget? suffixIcon,
//     bool readOnly = false,
//     Function()? onTap,
//     void Function(String)? onChanged,
//   }) {
//     return Stack(
//       children: [
//         Center(
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             onTap: onTap,
//             onChanged: onChanged,
//             maxLines: maxLines,
//             maxLength: maxLength,
//             style: TextStyle(
//               color: AppColors.textColor3.withOpacity(1),
//               fontSize: FontDimen.dimen14,
//               fontFamily: AppFonts.appFont,
//             ),
//             decoration: InputDecoration(
//               hintText: hintText,
//               hintStyle: TextStyle(
//                 color: AppColors.textColor2.withOpacity(0.3),
//                 fontSize: FontDimen.dimen13,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: AppFonts.appFont,
//               ),
//               contentPadding: showCharCount && maxLength != null
//                   ? const EdgeInsets.fromLTRB(16, 16, 16, 36)
//                   : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: AppColors.textColor3.withOpacity(0.17),
//                   width: 1.1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: AppColors.primaryColor,
//                   width: 1.1,
//                 ),
//               ),
//               suffixIcon: suffixIcon,
//               counterText: "",
//             ),
//           ),
//         ),
//         if (showCharCount && maxLength != null)
//           Positioned(
//             right: 18,
//             bottom: 12,
//             child: ValueListenableBuilder<TextEditingValue>(
//               valueListenable: controller,
//               builder: (context, value, _) {
//                 return Text(
//                   '${value.text.characters.length}/$maxLength',
//                   style: TextStyle(
//                     color: AppColors.textColor2.withOpacity(0.5),
//                     fontSize: FontDimen.dimen12,
//                     fontFamily: AppFonts.appFont,
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }