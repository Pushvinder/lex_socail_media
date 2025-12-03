import 'package:the_friendz_zone/screens/home/widgets/post_card_widget.dart';

import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../live/live_stream_screen.dart';
import '../live/widgets/show_go_live_bottom_sheet.dart';
import '../notifications/notification_screen.dart';
import '../requests/requests_screen.dart';
import '../search/search_screen.dart';
import '../user_profile/models/user_model.dart';
import '../user_profile/user_profile_screen.dart';
import 'home_controller.dart';
import 'widgets/ad_banner_widget.dart';
import 'widgets/connections_card_widget.dart';
import 'widgets/live_users_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());
  bool _isAnimatingUp = false;

  @override
  Widget build(BuildContext context) {
    Widget buildTab(
      String text, {
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? AppColors.whiteColor
                      : AppColors.secondaryColor,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: FontDimen.dimen13,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 210),
                height: 2.5,
                width: double.infinity,
                color: selected
                    ? AppColors.textColor3.withOpacity(1)
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        bottomNavigationBar: buildBottomNavBar(
            Get.findOrPut<BottomNavController>(BottomNavController())),
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 13, 0),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.earth,
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      AppStrings.homeTitle,
                      style: TextStyle(
                        color: AppColors.textColor3.withOpacity(1),
                        fontSize: FontDimen.dimen18,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.appFont,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        showGoLiveBottomSheet(context, (title) {
                          Get.to(() => BroadcastPage(
                                isBroadcaster: false,
                                channelName: "test",
                                userName: 'user',
                              ));
                        });
                      },
                      child: Text(
                        AppStrings.goLive,
                        style: TextStyle(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: AppColors.whiteColor,
                          fontSize: FontDimen.dimen14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //! Search
                    const SizedBox(width: 18),
                    GestureDetector(
                      onTap: () => Get.to(() => SearchScreen()),
                      child: Image.asset(
                        AppImages.search,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Get.to(() => RequestsScreen()),
                      child: Obx(() => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(
                                AppImages.profileAdd,
                                width: 20,
                                height: 20,
                              ),
                              (controller.requests.length ?? 0) > 0
                                  ? Positioned(
                                      top: -9,
                                      left: 0,
                                      right: -3,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors
                                                  .scaffoldBackgroundColor,
                                              width: 1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            (controller.requests.length ?? 0) >
                                                    9
                                                ? '9+'
                                                : '${(controller.requests.length ?? 0)}',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          )),
                    ),
                    const SizedBox(width: 17),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => NotificationScreen());
                      },
                      child: Image.asset(
                        AppImages.notifications,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              LiveUsersList(users: controller.liveUsers),

              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => Row(
                    children: [
                      buildTab(
                        AppStrings.connectionsTab,
                        selected: controller.selectedTabIndex.value == 0,
                        onTap: () => controller.switchTab(0),
                      ),
                      buildTab(
                        AppStrings.postsTab,
                        selected: controller.selectedTabIndex.value == 1,
                        onTap: () => controller.switchTab(1),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: AppColors.bgColor.withOpacity(0.7),
                height: 0,
              ),
              const SizedBox(height: 9),

              // Tabs Content
              Flexible(
                child: Obx(
                  () {
                    // 1st tab connection tab
                    if (controller.selectedTabIndex.value == 0) {
                      if (controller.connections.isEmpty) {
                        // checking if the the connection list is empty
                        // if yes then showing no connection screen
                        return Center(
                          child: Text(
                            'No more connections!',
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(0.4),
                              fontFamily: AppFonts.appFont,
                              fontSize: FontDimen.dimen16,
                            ),
                          ),
                        );
                      }

                      final int availableCards = controller.connections.length;
                      final int toShow =
                          availableCards >= 3 ? 3 : availableCards;

                      // The stackIndexList ensures we always show
                      // main card: index 0
                      // 1st behind: index 1 (if present)
                      // 2nd behind: index 2 (if present)
                      // final cardIndices = List.generate(toShow, (i) => i);

                      // returning the list of cards for conenction is connections are present
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          for (int cardsIndex = toShow - 1;
                              cardsIndex >= 0;
                              cardsIndex--)
                            AnimatedPositioned(
                              duration: Duration(
                                  milliseconds: cardsIndex == 0 ? 350 : 150),
                              curve: cardsIndex == 0 && _isAnimatingUp
                                  ? Curves.easeInCubic
                                  : Curves.easeOut,
                              // Main card is index0 (top), then1st behind (index 1), then2nd behind (index 2)
                              left: cardsIndex == 0
                                  ? 20
                                  : cardsIndex == 1
                                      ? 32 // first card behind (slight horizontal)
                                      : 44,
                              // second card behind (slightly more, but NOT extreme)
                              right: cardsIndex == 0
                                  ? 20
                                  : cardsIndex == 1
                                      ? 32
                                      : 50,
                              top: (cardsIndex * 12.0) +
                                  (cardsIndex == 0 && _isAnimatingUp
                                      ? -MediaQuery.of(context).size.height *
                                          0.08
                                      : 0),
                              bottom:
                                  MediaQuery.of(context).size.height * 0.12 -
                                      (cardsIndex * 10) +
                                      (cardsIndex == 0 && _isAnimatingUp
                                          ? MediaQuery.of(context).size.height *
                                              0.13
                                          : 0),
                              child: cardsIndex == 0
                                  ? ConnectionsCardWidget(
                                      user: controller.connections[0],
                                      onConnect: () {
                                        AppDialogs.showConfirmationDialog(
                                          title: AppStrings.dialogConnectTitle,
                                          description: AppStrings
                                              .dialogConnectDescription,
                                          iconAsset: AppImages.profileAdd,
                                          iconBgColor: AppColors.primaryColor
                                              .withOpacity(0.13),
                                          iconColor: AppColors.primaryColor,
                                          cancelButtonText: AppStrings.no,
                                          confirmButtonText: AppStrings.connect,
                                          onConfirm: () {
                                            // we are sending index 0 because we are removing card from topindex from the list so everytime card 0 at the top
                                            controller.onConnect(
                                                controller.connections[0]);
                                          },
                                        );
                                      },
                                      onViewProfile: () {
                                        final connection =
                                            controller.connections[0];
                                        //TODO : UPDATE THIS ONE WITH LATEST CODE
                                        // final userProfile = UserProfile(
                                        //   coverImageUrl: connection.coverImage,
                                        //   avatarUrl: connection.profileImage,
                                        //   name: connection.name,
                                        //   age: connection.age,
                                        //   username: connection.userName,
                                        //   bio: connection.interests.join(', '),
                                        //   posts: 58,
                                        //   connections: 502,
                                        //   interests: connection.interests,
                                        //   photos: [
                                        //     "https://images.unsplash.com/photo-1615216872226-3b0d6536617b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTQzfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1510897345173-4d938815feb4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTE5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://plus.unsplash.com/premium_photo-1667251759650-7af80fe4d079?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTN8fGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D",
                                        //     "https://images.unsplash.com/photo-1506543277633-99deabfcd722?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzQ4fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1623318046551-740404b7c7d1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzk0fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1600804340584-c7db2eacf0bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=774&q=80",
                                        //     "https://plus.unsplash.com/premium_photo-1668472274328-cd239ae3586f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTkzfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1558603668-6570496b66f8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjIyfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://plus.unsplash.com/premium_photo-1681414728888-c2360c8852f6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODA5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1482881497185-d4a9ddbe4151?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzExfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixlib=rb-4.0.3&auto=format&fit=crop&w=870&q=80",
                                        //     "https://images.unsplash.com/photo-1605187151664-9d89904d62d0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTY0fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://plus.unsplash.com/premium_photo-1691741857660-4a1d329e1b6e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTA5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://plus.unsplash.com/premium_photo-1680543345236-f2b4815fcd94?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTczfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1604782206219-3b9576575203?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjM0fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1638531540339-3846e93110c5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjQzfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://plus.unsplash.com/premium_photo-1681414728724-20776252d54a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjQ5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //     "https://images.unsplash.com/photo-1648241154336-69f1dd4a7545?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzU1fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
                                        //   ],
                                        //   videos: [
                                        //     "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                                        //     "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                                        //   ],
                                        // );

                                        // todo: update to profile view
                                        Get.to(
                                          () => UserProfileScreen(
                                            userId:
                                                controller.connections[0].id ??
                                                    '',
                                          ),
                                        );
                                      },
                                      onReject: () async {
                                        setState(
                                          () {
                                            _isAnimatingUp = true;
                                          },
                                        );
                                        await Future.delayed(
                                          const Duration(milliseconds: 380),
                                        );

                                        // we are sending index 0 because we are removing card from topindex from the list so everytime card 0 at the top
                                        controller.onReject(
                                            controller.connections[0]);
                                        setState(
                                          () {
                                            _isAnimatingUp = false;
                                          },
                                        );
                                      },
                                    )
                                  : IgnorePointer(
                                      child: Opacity(
                                        opacity: 0.67 - (cardsIndex - 1) * 0.22,
                                        child: Padding(
                                          padding: EdgeInsets.zero,
                                          child: Stack(
                                            children: [
                                              ConnectionsCardWidget(
                                                user: controller
                                                    .connections[cardsIndex],
                                                onConnect: () {},
                                                onViewProfile: () {},
                                                onReject: () {},
                                              ),
                                              // Overlay gradient for behind cards
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                height: 178,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    gradient: LinearGradient(
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: [
                                                        AppColors.cardBehindBg
                                                            .withOpacity(1),
                                                        Colors.transparent,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ),

                          // Ad Banner
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: AdBannerWidget(),
                            ),
                          )
                        ],
                      );
                    }
                    // Posts tab
                    if (controller.selectedTabIndex.value == 1) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 50,
                              ),
                              itemCount: controller.posts.length + 1,
                              itemBuilder: (context, i) {
                                if (i < controller.posts.length) {
                                  return PostCardWidget(
                                    communityName: 'Post',
                                    post: controller.posts[i],
                                    onDelete: () {
                                      controller.deletePost(
                                          controller.posts[i].id ?? '', i);
                                    },
                                    onLike: () {
                                      controller.likeClick(
                                          controller.posts[i].id ?? '',
                                          i,
                                          !(controller.posts[i].likedByUser ??
                                              false));
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          // Ad Banner
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: AdBannerWidget(),
                            ),
                          )
                        ],
                      );
                    }

                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
