import 'package:the_friendz_zone/screens/community/models/community_model_response.dart';
import 'package:the_friendz_zone/screens/search/search_screen.dart';

import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../community_feed/community_feed_screen.dart';
import '../community_profile/community_profile_screen.dart';
import '../create_community/create_community_screen.dart';
import '../home/home_screen.dart';
import 'community_controller.dart';
import 'widgets/community_card.dart';
import 'widgets/show_filter_bottom_sheet.dart';

class CommunityScreen extends StatelessWidget {
  final controller = Get.put(CommunityController());

  CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.find<BottomNavController>().setTabIndex(0);

        Get.offAll(() => const HomeScreen());
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        bottomNavigationBar: buildBottomNavBar(Get.findOrPut<BottomNavController>(BottomNavController())),
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 13, 13, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.earth,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        AppStrings.communityTitle,
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
                          AppDialogs.showConfirmationDialog(
                            title: AppStrings.dialogCreateCommunityTitle,
                            description:
                                AppStrings.dialogCreateCommunityDescription,
                            iconAsset: AppImages.groupIcon,
                            iconBgColor:
                                AppColors.primaryColor.withOpacity(0.13),
                            iconColor: AppColors.primaryColor,
                            confirmButtonText: AppStrings.createCommunity,
                            onConfirm: () {
                              Get.to(() => CreateCommunityScreen())
                                  ?.then((_) async {
                                controller.getRefreshedMyCommunity();
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBgColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.textColor3,
                                size: 18,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                AppStrings.createCommunity,
                                style: TextStyle(
                                  color: AppColors.textColor3,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontSize: FontDimen.dimen13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                // Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      buildTab(AppStrings.communityTabExplore, 0),
                      buildTab(AppStrings.communityTabJoined, 1),
                      buildTab(AppStrings.communityTabMyCommunities, 2),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: AppColors.bgColor.withOpacity(0.7),
                  height: 0,
                ),
                // Search
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 14,
                        left: 14,
                        right: 14,
                        bottom: 7,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardBgColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                onChanged: (q) =>
                                    controller.search.value = q.trim(),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      AppImages.search,
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                  hintText: AppStrings.searchCommunities,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: AppColors.textColor3,
                                    fontSize: FontDimen.dimen13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                style: TextStyle(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: AppColors.whiteColor,
                                  fontSize: FontDimen.dimen13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Filter Button
                          GestureDetector(
                            onTap: () => showFilterBottomSheet(context, controller),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.textColor4.withOpacity(1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  AppImages.filterIcon,
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                      color: Colors.transparent,
                    ).asButton(onTap: (){
                      Get.to(SearchScreen());
                    })
                    )
                  ],
                ),
                // Content
                Expanded(
                  child: Obx(
                    () {
                      if (controller.isLoadingCommunity.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textColor5.withOpacity(0.65),
                          ),
                        );
                      }

                      // todo: update for list filter search list
                      // var query = controller.search.value.toLowerCase();
                      // var filteredList =
                      //     controller.communitiesForTab.where((e) {
                      //   if (query.isNotEmpty &&
                      //       !e.name.toLowerCase().contains(query)) return false;
                      //   if (controller.selectedFilters.isNotEmpty &&
                      //       !controller.selectedFilters.any((filter) => e
                      //           .description
                      //           .toLowerCase()
                      //           .contains(filter.toLowerCase()))) return false;
                      //   return true;
                      // }).toList();

                      // if (filteredList.isEmpty) {
                      //   return Center(
                      //     child: Text(
                      //       "No communities found.",
                      //       style: TextStyle(
                      //           color: AppColors.textColor3,
                      //           fontFamily: GoogleFonts.inter().fontFamily,
                      //           fontSize: 17),
                      //     ),
                      //   );
                      // }

                      debugPrint(
                          'values ===== ${controller.exploreCommunityList.value} ,, ${controller.joinedCommunityList.value} ,, ${controller.myCommunityList.value}');

                      if (controller.selectedTab.value == 0) {
                        return _buildTabBarView(
                            context, 0, controller.exploreCommunityList.value);
                      } else if (controller.selectedTab.value == 1) {
                        return _buildTabBarView(
                            context, 1, controller.joinedCommunityList.value);
                      } else {
                        return _buildTabBarView(
                            context, 2, controller.myCommunityList.value);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String label, int idx) => Expanded(
        child: GestureDetector(
          onTap: () => controller.selectedTab.value = idx,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: controller.selectedTab.value == idx
                        ? AppColors.textColor3.withOpacity(1)
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
                  color: controller.selectedTab.value == idx
                      ? AppColors.textColor3.withOpacity(1)
                      : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTabBarView(
      BuildContext context, int index, List<CommunityModelData> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          "No communities found.",
          style: TextStyle(
              color: AppColors.textColor3,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 17),
        ),
      );
    }
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      itemBuilder: (ctx, i) => CommunityCard(
        community: data[i],
        tabIndex: controller.selectedTab.value,
        isMemberClickable: controller.selectedTab.value == index,
        onExplore: () {
          Get.to(
            () =>
                CommunityFeedScreen(communityName: data[i].communityName ?? '' , communityId: data[i].communityId ?? ''),
          );
        },
        onMember: () {
          controller.fetchCommunityDetails(data[i].communityId);
        },
        onJoin: () {
          debugPrint('join status ${data[i].joinStatus}');
          if (data[i].joinStatus != null &&
              data[i].joinStatus! != AppStrings.notRequested) {
            return;
          }
          AppDialogs.showConfirmationDialog(
            title: AppStrings.dialogJoinCommunityTitle,
            description: AppStrings.dialogJoinCommunityDescription,
            iconAsset: AppImages.groupIcon,
            iconBgColor: AppColors.primaryColor.withOpacity(0.13),
            iconColor: AppColors.primaryColor,
            confirmButtonText: AppStrings.joinCommunity,
            onConfirm: () async {
              var response = await controller.joinCommunity(
                  data[i].communityId ?? '0', data[i].commnityCreatedBy ?? '0');
              if (response != null && (response.status ?? false)) {
                data[i].joinStatus == AppStrings.joinPendingStatus;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.cardBehindBg,
                    content: Text(
                      AppStrings.joinedCommunitySnackbar,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                debugPrint('message ==== ${response?.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.redColor,
                    content: Text(
                      response?.message ?? ErrorMessages.somethingWrong,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
            },
          );
        },
        onLeave: () {
          // Get.to(() => CommunityProfileScreen(
          //       isEdit: false,
          //     ));
        },
        onMenu: () {
          showActionSheet(
            context,
            actions: [
              SheetAction(
                text: AppStrings.editGroupInfoPost,
                iconAsset: AppImages.editIcon,
                onTap: () {
                  AppDialogs.showConfirmationDialog(
                    title: AppStrings.editGroupInfoPost,
                    description: AppStrings.dialogEditGroupMessage,
                    iconAsset: AppImages.editIcon,
                    iconBgColor: AppColors.primaryColor.withOpacity(0.13),
                    iconColor: AppColors.primaryColor,
                    cancelButtonText: AppStrings.no,
                    confirmButtonText: AppStrings.yes,
                    onConfirm: () {
                      // edit group logic here
                    },
                  );
                },
              ),
              SheetAction(
                text: AppStrings.deleteGroupPost,
                iconAsset: AppImages.deleteIcon,
                // destructive: true,
                onTap: () {
                  AppDialogs.showConfirmationDialog(
                    title: AppStrings.deleteGroupPost,
                    description: AppStrings.dialogDeleteGroupMessage,
                    iconAsset: AppImages.deleteIcon,
                    iconBgColor: AppColors.redColor.withOpacity(0.13),
                    iconColor: AppColors.redColor,
                    confirmButtonText: AppStrings.deleteGroupPost,
                    confirmButtonColor: AppColors.redColor,
                    onConfirm: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.cardBehindBg,
                          content: Text(
                            AppStrings.groupDeletedSnackbar,
                            style: TextStyle(
                              color: AppColors.redColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                      // delete group logic here
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
