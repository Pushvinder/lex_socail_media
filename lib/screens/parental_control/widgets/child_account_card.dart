import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/screens/child_user_profile/child_user_profile_screen.dart';
import '../../../config/app_config.dart';
import '../../../utils/app_cache_manager.dart';
import '../models/child_account_model.dart';

class ChildAccountCard extends StatelessWidget {
  final ChildAccountModel childAccount;
  final VoidCallback onViewDashboard;

  const ChildAccountCard({
    Key? key,
    required this.childAccount,
    required this.onViewDashboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimens.dimen12,
        vertical: AppDimens.dimen10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dimen18,
        vertical: AppDimens.dimen15,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(AppDimens.dimen15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              GestureDetector(
                onTap: () {
                  Get.to(() => ChildUserProfileScreen());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: childAccount.avatarUrl,
                    fit: BoxFit.cover,
                    width: AppDimens.dimen120,
                    height: AppDimens.dimen120,
                    cacheManager: appCacheManager,
                    placeholder: (context, url) =>
                        Container(color: AppColors.greyShadeColor),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.greyShadeColor,
                      child: Icon(
                        Icons.person,
                        color: AppColors.greyColor,
                        size: AppDimens.dimen40,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dimen22),
              // Child Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimens.dimen2),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '${childAccount.name}, ',
                                style: TextStyle(
                                  color: AppColors.textColor1,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: FontDimen.dimen14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${childAccount.age}',
                                style: TextStyle(
                                  color: AppColors.textColor3.withOpacity(1),
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: FontDimen.dimen14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: AppDimens.dimen8),
                        // Arrow Icon
                        Image.asset(
                          AppImages.linkIcon,
                          height: AppDimens.dimen26,
                          width: AppDimens.dimen26,
                          color: AppColors.textColor3.withOpacity(1),
                          filterQuality: FilterQuality.high,
                          matchTextDirection: true,
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimens.dimen4),
                    Text(
                      childAccount.interests,
                      style: TextStyle(
                        color: AppColors.textColor3.withOpacity(1),
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: FontDimen.dimen10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppDimens.dimen14),
                    Row(
                      children: [
                        Text(
                          '${childAccount.postsCount}',
                          style: TextStyle(
                            color: AppColors.textColor1,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: FontDimen.dimen14,
                          ),
                        ),
                        SizedBox(width: AppDimens.dimen4),
                        Text(
                          AppStrings.posts,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: FontDimen.dimen10,
                          ),
                        ),
                        SizedBox(width: AppDimens.dimen16),
                        Text(
                          '${childAccount.connectionsCount}',
                          style: TextStyle(
                            color: AppColors.textColor1,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: FontDimen.dimen14,
                          ),
                        ),
                        SizedBox(width: AppDimens.dimen4),
                        Text(
                          AppStrings.connections,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: FontDimen.dimen10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dimen15),
          // View Dashboard Button
          GestureDetector(
            onTap: onViewDashboard,
            child: Container(
              height: AppDimens.dimen45,
              decoration: BoxDecoration(
                color: AppColors.subscriptionBgShade,
                borderRadius: BorderRadius.circular(AppDimens.dimen8),
              ),
              child: Center(
                child: Text(
                  AppStrings.viewDashboard,
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(1),
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: FontDimen.dimen14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
