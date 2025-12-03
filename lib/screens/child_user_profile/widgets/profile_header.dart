import '../../../config/app_config.dart';
import '../child_user_profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final ChildUserProfileController controller;
  const ProfileHeader({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Connected status button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            AppStrings.connected,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: FontDimen.dimen10,
              fontFamily: GoogleFonts.inter().fontFamily,
              // letterSpacing: 0.3,
            ),
          ),
        ),
        const Spacer(),
        // Connect icon button
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  AppImages.linkWhiteIcon,
                  width: 26,
                  height: 26,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
