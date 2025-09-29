import '../../../../config/app_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/account_user_model.dart';

class LinkChildItem extends StatelessWidget {
  final Friend user;
  final VoidCallback onTap;

  const LinkChildItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 7.8, horizontal: AppDimens.dimen4),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: user.profile ??
                    "https://randomuser.me/api/portraits/women/91.jpg",
                width: AppDimens.dimen55,
                height: AppDimens.dimen55,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.greyShadeColor),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.greyShadeColor,
                  child: Icon(Icons.person, color: AppColors.greyColor),
                ),
              ),
            ),
            SizedBox(width: AppDimens.dimen16),
            Expanded(
              child: Text(
                user.username ?? "",
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
            Container(
              width: AppDimens.dimen40,
              height: AppDimens.dimen40,
              decoration: BoxDecoration(
                color: user.isSelected ?? false
                    ? AppColors.primaryColor
                    : AppColors.textColor4,
                borderRadius: BorderRadius.circular(AppDimens.dimen12),
                border: Border.all(
                  color: user.isSelected ?? false
                      ? AppColors.primaryColor
                      : AppColors.textColor4,
                  width: 2,
                ),
              ),
              child: user.isSelected ?? false
                  ? Icon(
                      Icons.check,
                      color: AppColors.whiteColor,
                      size: AppDimens.dimen24,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
