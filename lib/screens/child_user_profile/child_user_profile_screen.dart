import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../../widgets/full_screen_image_viewer.dart';
import '../home/home_screen.dart';
import 'child_user_profile_controller.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_tabs.dart';
import 'widgets/profile_grid.dart';

class ChildUserProfileScreen extends StatefulWidget {
  const ChildUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChildUserProfileScreen> createState() => _ChildUserProfileScreenState();
}

class _ChildUserProfileScreenState extends State<ChildUserProfileScreen> {
  final controller = ChildUserProfileController();

  @override
  void initState() {
    super.initState();
    controller.initVideoControllers();
  }

  @override
  void dispose() {
    controller.disposeVideoControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
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
        // Get.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: AppColors.scaffoldBackgroundColor,
              pinned: false,
              expandedHeight: coverHeight + avatarOverlap,
              stretch: true,
              leading: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 0.0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondaryColor.withOpacity(0.12),
                              offset: const Offset(0, 4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            AppImages.backArrow,
                            height: AppDimens.dimen12,
                            width: AppDimens.dimen12,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // actions: [],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        width: double.infinity,
                        height: coverHeight,
                        imageUrl: user.coverImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.greyShadeColor.withOpacity(0.5),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.greyShadeColor,
                        ),
                      ),
                      Positioned(
                        left: horizontalPadding,
                        bottom: -avatarOverlap,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FullScreenImageViewer(
                                  images: [user.avatarUrl],
                                  initialIndex: 0,
                                  heroTag: user.avatarUrl,
                                ),
                              ),
                            );
                          },
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            elevation: 5,
                            child: Hero(
                              tag: user.avatarUrl,
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
                                      color: AppColors.greyShadeColor
                                          .withOpacity(0.13),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundColor: AppColors.greyShadeColor,
                                  backgroundImage: CachedNetworkImageProvider(
                                      user.avatarUrl),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {},
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -(avatarOuterDiameter - (avatarOverlap)),
                    left: horizontalPadding,
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: avatarOuterDiameter,
                        height: avatarOuterDiameter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 0,
                      left: horizontalPadding,
                      right: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),
                        // --- Profile Header (Menu) ---
                        Padding(
                          padding: const EdgeInsets.only(left: 105.0),
                          child: ProfileHeader(controller: controller),
                        ),
                        // --- Name, Username, Bio ---
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 2.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${user.name}, ${user.age} ',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontSize: FontDimen.dimen15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '@${user.username}',
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
                        Text(
                          user.bio,
                          style: GoogleFonts.inter(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontSize: FontDimen.dimen10,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // --- Profile Stats (Posts, Connections) ---
                        ProfileStats(controller: controller),
                        const SizedBox(height: 13),
                        // --- Tabs (Photos, Videos, Tagged) ---
                        ProfileTabs(controller: controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // --- Grid View ---
            ProfileGrid(controller: controller),
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
