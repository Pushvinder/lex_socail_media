import '../../../config/app_config.dart';

class SettingsTabContent extends StatelessWidget {
  final String postVisibility;
  final String contentAgeRestriction;
  final VoidCallback onPostVisibilityTap;

  const SettingsTabContent({
    required this.postVisibility,
    required this.contentAgeRestriction,
    required this.onPostVisibilityTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dimen16,
        AppDimens.dimen20,
        AppDimens.dimen16,
        AppDimens.dimen10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsTile(
            title: AppStrings.postVisibility,
            value: postVisibility,
            icon: AppImages.eyeSettingsIcon,
            onTap: onPostVisibilityTap,
          ),
          SizedBox(height: AppDimens.dimen22),
          SettingsTile(
            title: AppStrings.contentAgeRestrictions,
            value: contentAgeRestriction,
            icon: null,
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final String? icon;
  final VoidCallback? onTap;

  const SettingsTile({
    required this.title,
    required this.value,
    this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBgColor,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 17),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textColor3.withOpacity(1),
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: FontDimen.dimen14,
              ),
            ),
            Spacer(),
            if (title == AppStrings.postVisibility)
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textColor4.withOpacity(1),
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen12,
                ),
              ),
            if (title == AppStrings.contentAgeRestrictions)
              Text(
                value,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: FontDimen.dimen15,
                ),
              ),
            if (icon != null) ...[
              SizedBox(width: 18),
              Image.asset(
                icon!,
                width: 20,
                height: 20,
                color: AppColors.whiteColor.withOpacity(1),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
