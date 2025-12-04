import '../../../config/app_config.dart';
import '../../user_profile/widgets/profile_tab_button.dart';
import '../child_user_profile_controller.dart';

class ProfileTabs extends StatelessWidget {
  final ChildUserProfileController controller;

  const ProfileTabs({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBehindBg.withOpacity(0.0),
          border: Border.all(color: AppColors.tabBorderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ProfileTabButton(
              label: AppStrings.profilePhotos,
              selected: controller.selectedTab.value == 0,
              onTap: () => controller.selectedTab.value = 0,
            ),
            const SizedBox(width: 4),
            ProfileTabButton(
              label: AppStrings.profileVideos,
              selected: controller.selectedTab.value == 1,
              onTap: () => controller.selectedTab.value = 1,
            ),
            const SizedBox(width: 4),
            ProfileTabButton(
              label: AppStrings.profileTagged,
              selected: controller.selectedTab.value == 2,
              onTap: () => controller.selectedTab.value = 2,
            ),
          ],
        ),
      ),
    );
  }
}
