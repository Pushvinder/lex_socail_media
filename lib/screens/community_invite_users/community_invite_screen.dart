import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/screens/community_invite_users/community_invite_controller.dart';
import 'package:the_friendz_zone/utils/app_colors.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/app_img.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';
import '../../config/app_config.dart';
import '../user_profile/user_profile_screen.dart';

class CommunityInviteScreen extends StatelessWidget {

  final CommunityInviteController controller = Get.put(
      CommunityInviteController());

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
                    AppStrings.inviteMembers,
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
                        fontFamily: GoogleFonts
                            .inter()
                            .fontFamily,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppStrings.searchHere,
                        hintStyle: TextStyle(
                          color:
                          AppColors.textColor3.withOpacity(0.7),
                          fontSize: FontDimen.dimen13,
                          fontFamily: GoogleFonts
                              .inter()
                              .fontFamily,
                        ),
                      ),
                      onChanged: (value) {}
                    // controller.onChangeSearch(value),
                  )

                ),
              ],
            ),
          ),
        ),

        // Tabs


        Expanded(child:  ListView.separated(
          itemCount: 5,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          separatorBuilder: (context, idx) => SizedBox(height: 16),
          itemBuilder: (context, idx) {

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: 'user.profile!',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(
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
                      'user.fullname!',
                      style: TextStyle(
                        color: AppColors.textColor3.withOpacity(1),
                        fontFamily: GoogleFonts
                            .inter()
                            .fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: FontDimen.dimen14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 14),

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
                        AppStrings.invite,
                        style: TextStyle(
                          color: AppColors.whiteColor
                              .withOpacity(0.33),
                          fontFamily:
                          GoogleFonts
                              .inter()
                              .fontFamily,
                          fontSize: FontDimen.dimen12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ).asButton(onTap: () {
                // Get.to(() => UserProfileScreen(userId: user.id ?? ''));
              }),
            );
          },
        ),)
      ],
    ),)
    ,
    )
    ,
    );
  }

}
