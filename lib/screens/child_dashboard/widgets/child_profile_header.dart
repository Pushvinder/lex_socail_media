import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/app_config.dart';
import '../models/modelschild_dashboard_model.dart';

class ChildProfileHeader extends StatelessWidget {
  final ChildDashboardModel child;
  const ChildProfileHeader({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBgColor.withOpacity(1),
        borderRadius: BorderRadius.circular(AppDimens.dimen15),
      ),
      padding: EdgeInsets.all(AppDimens.dimen14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: child.avatarUrl,
              width: AppDimens.dimen120 + 2,
              height: AppDimens.dimen120 + 2,
              fit: BoxFit.cover,
              placeholder: (ctx, _) =>
                  Container(color: AppColors.greyShadeColor),
              errorWidget: (ctx, url, error) => Container(
                  color: AppColors.greyShadeColor,
                  child: Icon(Icons.person, color: AppColors.greyColor)),
            ),
          ),
          SizedBox(width: AppDimens.dimen16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, age
                Row(
                  children: [
                    Text(
                      '${child.fullName}, ',
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
                      '${child.age}',
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
                SizedBox(height: AppDimens.dimen3),
                // Interests (bio)
                Text(
                  child.bio,
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(0.7),
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: FontDimen.dimen10,
                    height: 1.6,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.dimen8),
                // Stats
                Row(
                  children: [
                    Text(
                      '${child.postsCount}',
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
                        fontSize: FontDimen.dimen10 - 1,
                      ),
                    ),
                    SizedBox(width: AppDimens.dimen16),
                    Text(
                      '${child.connectionsCount}',
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
                        fontSize: FontDimen.dimen10 - 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
