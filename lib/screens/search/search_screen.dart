import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/screens/community_feed/community_feed_screen.dart';
import 'package:the_friendz_zone/screens/community_post_detail/community_post_detail_screen.dart';

import 'package:the_friendz_zone/utils/app_colors.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/app_img.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';

import '../../config/app_config.dart';
import '../user_profile/user_profile_screen.dart';
import 'search_controller.dart';
import 'widgets/show_search_filter_bottom_sheet.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER
              Padding(
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
                      child: Center(
                        child: Text(
                          AppStrings.searchTitle,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(1),
                            fontSize: FontDimen.dimen18,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: AppDimens.dimen12),
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen14,
                        width: AppDimens.dimen14,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 9),

              // Search Box & Filter Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.cardBgColor.withOpacity(1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 18),
                            Image.asset(
                              AppImages.search,
                              height: 21,
                              width: 21,
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(1),
                                  fontSize: FontDimen.dimen13,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppStrings.searchHere,
                                  hintStyle: TextStyle(
                                    color:
                                        AppColors.textColor3.withOpacity(0.7),
                                    fontSize: FontDimen.dimen13,
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                  ),
                                ),
                                onChanged: (value) =>
                                    controller.onChangeSearch(value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () =>
                          showSearchFilterBottomSheet(context, controller , (){
                            if(controller.selectedTab.value == 0) {
                              controller.getSearchUser();
                            }else{
                              controller.getSearchCommunity();
                            }
                          }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.textColor4.withOpacity(1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              AppImages.filterIcon,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 14,
                  right: 14,
                ),
                child: Row(
                  children: [
                    buildTab('People', 0),
                    const SizedBox(width: 26),
                    buildTab('Communities', 1),
                  ],
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Divider(
                  thickness: 1,
                  color: AppColors.bgColor.withOpacity(0.76),
                  height: 0.2,
                ),
              ),

              // List Results
              Expanded(
                child: Obx(() {
                  if (controller.selectedTab.value == 0) {
                    final list = controller.filteredPeople;
                    return ListView.separated(
                      itemCount: list.length,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      separatorBuilder: (context, idx) => SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        final user = list[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: user.profile!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
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
                              SizedBox(width: 17),
                              // Name
                              Expanded(
                                child: Text(
                                  user.fullname!,
                                  style: TextStyle(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontDimen.dimen14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 14),
                              // Send Request Button
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.textColor4.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color:
                                        AppColors.textColor3.withOpacity(0.40),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 11,
                                  ),
                                  child: Text(
                                    AppStrings.sendRequest,
                                    style: TextStyle(
                                      color: AppColors.whiteColor
                                          .withOpacity(0.33),
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontSize: FontDimen.dimen12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).asButton(onTap: (){
                            Get.to(() => UserProfileScreen(userId: user.id??''));
                          }),
                        );
                      },
                    );
                  } else {
                    final list = controller.searchComunityModel.value.data ?? [];
                    return ListView.separated(
                      itemCount: list.length,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      separatorBuilder: (context, idx) => SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        final comm = list[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: comm.communityProfile??'',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
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
                              SizedBox(width: 17),
                              // Name
                              Expanded(
                                child: Text(
                                  comm.communityName??'',
                                  style: TextStyle(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontDimen.dimen14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 14),
                              // Join Community Button
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.textColor4.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color:
                                        AppColors.textColor3.withOpacity(0.40),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 9,
                                    horizontal: 18,
                                  ),
                                  child: Text(
                                    (comm.is_joined??false) ?  'Joined':   'Join Community',
                                    style: TextStyle(
                                      color: AppColors.whiteColor
                                          .withOpacity(0.33),
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontSize: FontDimen.dimen12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ).asButton(onTap: ()
                             {
                               if((comm.is_joined??false)){
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
                                       comm.communityId ?? '0', comm.created_by ?? '0');
                                   if (response != null && (response.status ?? false)) {
                                     '' == AppStrings.joinPendingStatus;
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
                             }
                              ),
                            ],
                          ).asButton(onTap: (){
                            Get.to(() => CommunityFeedScreen(communityName: comm.communityName??'', communityId: comm.communityId??''));
                          }),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTab(String label, int idx) => GestureDetector(
        onTap: () => controller.selectedTab.value = idx,
        child: Obx(
          () => Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                // border: Border(
                //   bottom: BorderSide(
                //     color: controller.selectedTab.value == idx
                //         ? AppColors.primaryColor
                //         : Colors.transparent,
                //     width: 2.3,
                //   ),
                // ),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                // const SizedBox(height: 3),
                // AnimatedContainer(
                //   duration: const Duration(milliseconds: 230),
                //   height: 2.3,
                //   width: controller.selectedTab.value == idx ? 45 : 0,
                //   color: controller.selectedTab.value == idx
                //       ? AppColors.primaryColor
                //       : Colors.transparent,
                // ),
              ],
            ),
          ),
        ),
      );
}
