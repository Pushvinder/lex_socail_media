import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/app_config.dart';
import '../models/community_profile_model.dart';

class CommunityMemberTile extends StatelessWidget {
  final CommunityMember member;
  final bool showRemove;
  final VoidCallback onRemove;

  const CommunityMemberTile({
    Key? key,
    required this.member,
    this.showRemove = true,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textColor4.withOpacity(1),
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: member.avatarUrl,
                fit: BoxFit.cover,
                width: 46,
                height: 46,
                fadeInDuration: const Duration(milliseconds: 400),
                placeholder: (context, url) =>
                    Container(color: AppColors.greyShadeColor),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.greyShadeColor,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              member.name,
              style: TextStyle(
                color: AppColors.textColor3.withOpacity(1),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: FontDimen.dimen13,
              ),
            ),
          ),
          // Remove Button
          showRemove
              ? OutlinedButton(
                  onPressed: onRemove,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.textColor4.withOpacity(1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dimen8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dimen14,
                      vertical: 0,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    AppStrings.remove,
                    style: TextStyle(
                      color: AppColors.textColor4.withOpacity(1),
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: FontDimen.dimen13,
                      height: 0.9,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
