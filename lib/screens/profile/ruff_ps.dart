
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../config/app_config.dart';
// import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
// import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
// import '../../widgets/full_screen_image_viewer.dart';
// import '../home/home_screen.dart';
// import 'profile_controller.dart';
// import 'widgets/profile_header.dart';
// import 'widgets/profile_stats.dart';
// import 'widgets/profile_tabs.dart';
// import 'widgets/profile_grid.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final ProfileController controller = Get.put(ProfileController());

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (controller.user.value.data == null) {
//         controller.getProfileDetails();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 CircularProgressIndicator(color: Colors.blue),
//                 SizedBox(height: 10),
//                 Text("Loading Profile...",
//                     style: TextStyle(color: Colors.white60, fontSize: 12))
//               ],
//             ),
//           ),
//         );
//       }

//       final screenHeight = MediaQuery.of(context).size.height;
//       final coverHeight = screenHeight * 0.27;
//       const double horizontalPadding = 20;
//       const double avatarRadius = 45;
//       const double avatarBorderWidth = 2;
//       final double avatarOverlap = avatarRadius + avatarBorderWidth / 2;
//       final double avatarOuterDiameter = avatarRadius * 2 + avatarBorderWidth * 2;

//       return PopScope(
//         canPop: false,
//         onPopInvoked: (didPop) {
//           Get.find<BottomNavController>().setTabIndex(0);
//           Get.offAll(() => const HomeScreen());
//         },
//         child: Scaffold(
//           backgroundColor: AppColors.scaffoldBackgroundColor,
//           bottomNavigationBar: buildBottomNavBar(Get.find<BottomNavController>()),
//           body: _buildProfileContent(
//             coverHeight,
//             avatarOverlap,
//             horizontalPadding,
//             avatarRadius,
//             avatarBorderWidth,
//             avatarOuterDiameter,
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildProfileContent(
//     double coverHeight,
//     double avatarOverlap,
//     double horizontalPadding,
//     double avatarRadius,
//     double avatarBorderWidth,
//     double avatarOuterDiameter,
//   ) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         _buildProfileAppBar(
//           coverHeight,
//           avatarOverlap,
//           horizontalPadding,
//           avatarRadius,
//           avatarBorderWidth,
//           avatarOuterDiameter,
//         ),
//         _buildProfileInfoSection(
//           horizontalPadding,
//           avatarOuterDiameter,
//           avatarOverlap,
//         ),
//         ProfileGrid(),
//         _buildBottomPadding(context),
//       ],
//     );
//   }

//   SliverAppBar _buildProfileAppBar(
//     double coverHeight,
//     double avatarOverlap,
//     double horizontalPadding,
//     double avatarRadius,
//     double avatarBorderWidth,
//     double avatarOuterDiameter,
//   ) {
//     return SliverAppBar(
//       elevation: 0,
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       pinned: false,
//       expandedHeight: coverHeight + avatarOverlap,
//       stretch: true,
//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 18.0, top: 12.0),
//           child: GestureDetector(
//             onTap: _showCoverPhotoOptions,
//             child: Container(
//               width: 42,
//               height: 42,
//               decoration: BoxDecoration(
//                 color: AppColors.secondaryColor.withOpacity(0.16),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: Center(
//                 child: Image.asset(
//                   AppImages.cameraBlueIcon,
//                   width: 22,
//                   height: 22,
//                   color: AppColors.whiteColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//       flexibleSpace: _buildFlexibleSpace(
//         coverHeight,
//         horizontalPadding,
//         avatarOverlap,
//         avatarOuterDiameter,
//         avatarRadius,
//         avatarBorderWidth,
//       ),
//     );
//   }

//   LayoutBuilder _buildFlexibleSpace(
//     double coverHeight,
//     double horizontalPadding,
//     double avatarOverlap,
//     double avatarOuterDiameter,
//     double avatarRadius,
//     double avatarBorderWidth,
//   ) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Obx(() {
//           final hasValidProfileImage =
//               _isValidImageUrl(controller.user.value.data?.profile);

//           return Stack(
//             clipBehavior: Clip.none,
//             fit: StackFit.expand,
//             children: [
//               _buildCoverImage(coverHeight, hasValidProfileImage),
//               Container(
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withOpacity(0.2)],
//               ))),
//               Positioned(
//                 left: horizontalPadding,
//                 bottom: -avatarOverlap,
//                 child: _buildProfileAvatar(
//                   avatarOuterDiameter,
//                   avatarRadius,
//                   avatarBorderWidth,
//                   hasValidProfileImage,
//                 ),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   Widget _buildCoverImage(double coverHeight, bool hasImage) {
//     return CachedNetworkImage(
//       imageUrl: controller.user.value.data?.profile ?? "",
//       width: double.infinity,
//       height: coverHeight,
//       fit: BoxFit.cover,
//       placeholder: (_, __) => _buildCoverPlaceholder(),
//       errorWidget: (_, __, ___) => _buildCoverPlaceholder(),
//     );
//   }

//   Widget _buildCoverPlaceholder() => Container(
//         color: AppColors.primaryColor.withOpacity(0.3),
//         child: const Center(
//             child: Icon(Icons.photo_library, color: Colors.white54, size: 50)),
//       );

//   Widget _buildProfileAvatar(
//     double diameter,
//     double radius,
//     double border,
//     bool hasImage,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         if (hasImage) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => FullScreenImageViewer(
//                         images: [controller.user.value.data!.profile!],
//                         initialIndex: 0,
//                         heroTag: controller.user.value.data!.profile!,
//                       )));
//         }
//       },
//       child: Material(
//         color: Colors.transparent,
//         shape: const CircleBorder(),
//         elevation: 6,
//         child: Hero(
//           tag: controller.user.value.data?.profile ?? "avatar_tag",
//           child: Container(
//             width: diameter,
//             height: diameter,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.black, width: border),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.25),
//                     blurRadius: 10,
//                     offset: Offset(0, 6))
//               ],
//             ),
//             child: CircleAvatar(
//               radius: radius,
//               backgroundColor: AppColors.greyShadeColor,
//               backgroundImage: hasImage
//                   ? CachedNetworkImageProvider(
//                       controller.user.value.data!.profile!)
//                   : null,
//               child: !hasImage
//                   ? Icon(Icons.person, color: Colors.white54, size: radius)
//                   : null,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   SliverToBoxAdapter _buildProfileInfoSection(
//     double pad,
//     double diameter,
//     double overlap,
//   ) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: pad),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: diameter * 0.45),
//             ProfileHeader(),
//             _buildUserInfo(),
//             SizedBox(height: 6),
//             ProfileStats(),
//             SizedBox(height: 12),
//             ProfileTabs(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserInfo() {
//     return Obx(() {
//       final u = controller.user.value.data;
//       if (u == null) return const SizedBox();

//       final username = u.username ?? "";
//       final hasUsername = username.isNotEmpty && username != "null";

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("${u.fullname}, ${controller.calculateAge(u.dob ?? "01-01-2000")}",
//               style: GoogleFonts.inter(
//                   color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
//           if (hasUsername)
//             Text("@$username",
//                 style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
//           if (u.bio != null && u.bio!.isNotEmpty && u.bio != "null")
//             Padding(
//               padding: const EdgeInsets.only(top: 4),
//               child: Text(u.bio!,
//                   style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
//             )
//         ],
//       );
//     });
//   }

//   SliverPadding _buildBottomPadding(BuildContext ctx) {
//     return SliverPadding(
//       padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom + 24),
//     );
//   }

//   bool _isValidImageUrl(String? url) =>
//       url != null && (url.endsWith(".png") || url.endsWith(".jpg") || url.endsWith(".jpeg"));

//   void _showCoverPhotoOptions() {
//     showModalBottomSheet(
//         context: context,
//         builder: (_) => SafeArea(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
//                   ListTile(leading: Icon(Icons.photo_library), title: Text("Change Cover Photo")),
//                   ListTile(leading: Icon(Icons.delete), title: Text("Remove Cover Photo")),
//                 ],
//               ),
//             ));
//   }
// }
