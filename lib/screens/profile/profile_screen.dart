// import 'dart:ui';
// import 'package:cached_network_image/cached_network_image.dart';
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
//   }

//   @override
//   void dispose() {
//     controller.disposeVideoControllers();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = controller.user;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final coverHeight = screenHeight * 0.27;
//     final double horizontalPadding = 20.0;
//     final double avatarRadius = 45.0;
//     final double avatarBorderWidth = 2.0;
//     final double avatarOverlap = avatarRadius + avatarBorderWidth / 2;
//     final double avatarOuterDiameter = avatarRadius * 2 + avatarBorderWidth * 2;

//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         Get.find<BottomNavController>().setTabIndex(0);

//         Get.offAll(() => const HomeScreen());
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         bottomNavigationBar: buildBottomNavBar(Get.find<BottomNavController>()),
//         body: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               elevation: 0,
//               backgroundColor: AppColors.scaffoldBackgroundColor,
//               pinned: false,
//               expandedHeight: coverHeight + avatarOverlap,
//               stretch: true,
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 18.0, top: 12.0),
//                   child: GestureDetector(
//                     onTap: () {},
//                     child: Container(
//                       width: 42,
//                       height: 42,
//                       decoration: BoxDecoration(
//                         color: AppColors.secondaryColor.withOpacity(0.16),
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: Center(
//                         child: Image.asset(
//                           AppImages.cameraBlueIcon,
//                           width: 22,
//                           height: 22,
//                           color: AppColors.whiteColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               flexibleSpace: LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Stack(
//                     clipBehavior: Clip.none,
//                     fit: StackFit.expand,
//                     children: [
//                       // todo: update it with cover image
//                       CachedNetworkImage(
//                         width: double.infinity,
//                         height: coverHeight,
//                         imageUrl: user.value.data?.profile ?? '',
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Container(
//                           color: AppColors.greyShadeColor.withOpacity(0.5),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: AppColors.greyShadeColor,
//                         ),
//                       ),
//                       Positioned(
//                         left: horizontalPadding,
//                         bottom: -avatarOverlap,
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => FullScreenImageViewer(
//                                   images: [
//                                     user.value.data?.profile ?? '',
//                                   ],
//                                   initialIndex: 0,
//                                   heroTag: user.value.data?.profile ?? '',
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Material(
//                             color: Colors.transparent,
//                             shape: const CircleBorder(),
//                             elevation: 5,
//                             child: Hero(
//                               tag: user.value.data?.profile ?? '',
//                               child: Container(
//                                 width: avatarOuterDiameter,
//                                 height: avatarOuterDiameter,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: AppColors.scaffoldBackgroundColor,
//                                     width: avatarBorderWidth,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: AppColors.greyShadeColor
//                                           .withOpacity(0.13),
//                                       blurRadius: 14,
//                                       offset: const Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Obx(
//                                   () => CircleAvatar(
//                                     radius: avatarRadius,
//                                     backgroundColor: AppColors.greyShadeColor,
//                                     backgroundImage: CachedNetworkImageProvider(
//                                       user.value.data?.profile ?? '',
//                                     ),
//                                     onBackgroundImageError:
//                                         (exception, stackTrace) {},
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Positioned(
//                     top: -(avatarOuterDiameter - (avatarOverlap)),
//                     left: horizontalPadding,
//                     child: Container(
//                       color: Colors.transparent,
//                       child: SizedBox(
//                         width: avatarOuterDiameter,
//                         height: avatarOuterDiameter,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: 0,
//                       left: horizontalPadding,
//                       right: horizontalPadding,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         // --- Profile Header (Withdraw, Menu) ---
//                         ProfileHeader(),
//                         // --- Name, Username, Bio ---
//                         Obx(
//                           () => Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 1.0, bottom: 2.0),
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text:
//                                         '${controller.user.value?.data?.fullname ?? ''}, ${controller.calculateAge(controller.user.value?.data?.dob ?? "06-12-2006")} ',
//                                     style: GoogleFonts.inter(
//                                       color:
//                                           AppColors.textColor3.withOpacity(1),
//                                       fontSize: FontDimen.dimen15,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text:
//                                         '@${controller.user.value?.data?.username ?? ''}',
//                                     style: GoogleFonts.inter(
//                                       color:
//                                           AppColors.textColor4.withOpacity(1),
//                                       fontSize: FontDimen.dimen13,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Obx(
//                           () => Text(
//                             controller.user.value?.data?.bio ?? '',
//                             style: GoogleFonts.inter(
//                               color: AppColors.textColor3.withOpacity(0.7),
//                               fontSize: FontDimen.dimen11,
//                               fontWeight: FontWeight.w500,
//                               height: 1.4,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         // --- Profile Stats (Posts, Connections, Buy Coins, Coins) ---
//                         ProfileStats(),
//                         const SizedBox(height: 12),
//                         // --- Tabs (Photos, Videos) ---
//                         ProfileTabs(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // --- Grid View ---
//             ProfileGrid(),
//             SliverPadding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).padding.bottom + 24,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../../widgets/full_screen_image_viewer.dart';
import '../home/home_screen.dart';
import 'profile_controller.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_tabs.dart';
import 'widgets/profile_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.user.value.data == null) {
        controller.getProfileDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final coverHeight = screenHeight * 0.27;
    final double horizontalPadding = 20.0;
    final double avatarRadius = 45.0;
    final double avatarBorderWidth = 2.0;
    final double avatarOverlap = avatarRadius + avatarBorderWidth / 2;
    final double avatarOuterDiameter = avatarRadius * 2 + avatarBorderWidth * 2;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.find<BottomNavController>().setTabIndex(0);
        Get.offAll(() => const HomeScreen());
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        bottomNavigationBar: buildBottomNavBar(Get.find<BottomNavController>()),
        body: _buildProfileContent(
          coverHeight,
          avatarOverlap,
          horizontalPadding,
          avatarRadius,
          avatarBorderWidth,
          avatarOuterDiameter,
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    double coverHeight,
    double avatarOverlap,
    double horizontalPadding,
    double avatarRadius,
    double avatarBorderWidth,
    double avatarOuterDiameter,
  ) {
    return CustomScrollView(
      slivers: <Widget>[
        _buildProfileAppBar(
          coverHeight,
          avatarOverlap,
          horizontalPadding,
          avatarRadius,
          avatarBorderWidth,
          avatarOuterDiameter,
        ),
        _buildProfileInfoSection(
          horizontalPadding,
          avatarOuterDiameter,
          avatarOverlap,
        ),
        ProfileGrid(),
        _buildBottomPadding(context),
      ],
    );
  }

  SliverAppBar _buildProfileAppBar(
    double coverHeight,
    double avatarOverlap,
    double horizontalPadding,
    double avatarRadius,
    double avatarBorderWidth,
    double avatarOuterDiameter,
  ) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      pinned: false,
      expandedHeight: coverHeight + avatarOverlap,
      stretch: true,
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 18.0, top: 12.0),
        //   child: GestureDetector(
        //     onTap: _showCoverPhotoOptions,
        //     child: Container(
        //       width: 42,
        //       height: 42,
        //       decoration: BoxDecoration(
        //         color: AppColors.secondaryColor.withOpacity(0.16),
        //         borderRadius: BorderRadius.circular(100),
        //       ),
        //       child: Center(
        //         child: Image.asset(
        //           AppImages.cameraBlueIcon,
        //           width: 22,
        //           height: 22,
        //           color: AppColors.whiteColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
      flexibleSpace: _buildFlexibleSpace(
        coverHeight,
        horizontalPadding,
        avatarOverlap,
        avatarOuterDiameter,
        avatarRadius,
        avatarBorderWidth,
      ),
    );
  }

  LayoutBuilder _buildFlexibleSpace(
    double coverHeight,
    double horizontalPadding,
    double avatarOverlap,
    double avatarOuterDiameter,
    double avatarRadius,
    double avatarBorderWidth,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          final hasValidProfileImage =
              _isValidImageUrl(controller.user.value.data?.profile);

          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              // Background Cover Image
              _buildCoverImage(coverHeight, hasValidProfileImage),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),

              // Profile Avatar
              Positioned(
                left: horizontalPadding,
                bottom: -avatarOverlap,
                child: _buildProfileAvatar(
                  avatarOuterDiameter,
                  avatarRadius,
                  avatarBorderWidth,
                  hasValidProfileImage,
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildCoverImage(double coverHeight, bool hasValidImage) {
    if (hasValidImage) {
      return CachedNetworkImage(
        width: double.infinity,
        height: coverHeight,
        imageUrl: controller.user.value.data?.profile ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildCoverPlaceholder(),
        errorWidget: (context, url, error) => _buildCoverPlaceholder(),
      );
    } else {
      return _buildCoverPlaceholder();
    }
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryColor.withOpacity(0.3),
      child: Center(
        child: Icon(
          Icons.photo_library,
          color: Colors.white54,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(
    double avatarOuterDiameter,
    double avatarRadius,
    double avatarBorderWidth,
    bool hasValidImage,
  ) {
    return GestureDetector(
      onTap: () {
        if (hasValidImage) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FullScreenImageViewer(
                images: [controller.user.value.data!.profile!],
                initialIndex: 0,
                heroTag: controller.user.value.data!.profile!,
              ),
            ),
          );
        }
      },
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        elevation: 5,
        child: Hero(
          tag: controller.user.value.data?.profile ?? 'default_avatar',
          child: Container(
            width: avatarOuterDiameter,
            height: avatarOuterDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.scaffoldBackgroundColor,
                width: avatarBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.greyShadeColor,
              backgroundImage: hasValidImage
                  ? CachedNetworkImageProvider(
                      controller.user.value.data!.profile!)
                  : null,
              child: !hasValidImage
                  ? Icon(
                      Icons.person,
                      size: avatarRadius,
                      color: Colors.white54,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildProfileInfoSection(
    double horizontalPadding,
    double avatarOuterDiameter,
    double avatarOverlap,
  ) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Avatar tap area overlay
          Positioned(
            top: -(avatarOuterDiameter - avatarOverlap),
            left: horizontalPadding,
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                width: avatarOuterDiameter,
                height: avatarOuterDiameter,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.only(
              top: 0,
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                // Profile Header (Withdraw, Menu)
                ProfileHeader(),

                // Name, Username, Bio
                _buildUserInfo(),

                const SizedBox(height: 4),

                // Profile Stats
                ProfileStats(),

                const SizedBox(height: 12),

                // Tabs (Photos, Videos)
                ProfileTabs(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Obx(() {
      final userData = controller.user.value.data;
      final username = userData?.username;
      final hasUsername =
          username != null && username.isNotEmpty && username != 'null';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Age
          Padding(
            padding: const EdgeInsets.only(top: 1.0, bottom: 2.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${userData?.fullname ?? ''}, ${controller.calculateAge(userData?.dob ?? "06-12-2006")} ',
                    style: GoogleFonts.inter(
                      color: AppColors.textColor3.withOpacity(1),
                      fontSize: FontDimen.dimen15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasUsername)
                    TextSpan(
                      text: '@$username',
                      style: GoogleFonts.inter(
                        color: AppColors.textColor4.withOpacity(1),
                        fontSize: FontDimen.dimen13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 2),

          // Bio
          if (userData?.bio != null &&
              userData!.bio!.isNotEmpty &&
              userData.bio != 'null')
            Text(
              userData.bio!,
              style: GoogleFonts.inter(
                color: AppColors.textColor3.withOpacity(0.7),
                fontSize: FontDimen.dimen11,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
        ],
      );
    });
  }

  SliverPadding _buildBottomPadding(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
    );
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    final hasImageExtension =
        url.endsWith('.jpg') || url.endsWith('.png') || url.endsWith('.jpeg');

    final hasFilename = Uri.tryParse(url)?.pathSegments.isNotEmpty == true &&
        !url.endsWith('/');

    return hasImageExtension && hasFilename;
  }

  void _showCoverPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Change Cover Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement cover photo change
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Cover Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement cover photo removal
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
