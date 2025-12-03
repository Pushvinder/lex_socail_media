import '../../../config/app_config.dart';
import '../../buy_coins/buy_coins_screen.dart';
import '../child_user_profile_controller.dart';

class ProfileStats extends StatelessWidget {
  final ChildUserProfileController controller;
  const ProfileStats({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    return Row(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              user.posts.toString(),
              style: GoogleFonts.inter(
                color: AppColors.textColor3.withOpacity(1),
                fontSize: FontDimen.dimen15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 2),
              child: Text(
                AppStrings.profilePosts,
                style: GoogleFonts.inter(
                  color: AppColors.textColor3.withOpacity(0.7),
                  fontSize: FontDimen.dimen8 + 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              user.connections.toString(),
              style: GoogleFonts.inter(
                color: AppColors.textColor3.withOpacity(1),
                fontSize: FontDimen.dimen15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 2),
              child: Text(
                AppStrings.profileConnections,
                style: GoogleFonts.inter(
                  color: AppColors.textColor3.withOpacity(0.7),
                  fontSize: FontDimen.dimen8 + 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
