import '../../../config/app_config.dart';
import '../../user_profile/widgets/profile_tab_button.dart';
import '../profile_controller.dart';

class ProfileTabs extends StatelessWidget {
   ProfileTabs({ Key? key}) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();


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
              selected: controller.isPhotosTab.value,
              onTap: () => controller.isPhotosTab.value = true,
            ),
            const SizedBox(width: 4),
            ProfileTabButton(
              label: AppStrings.profileVideos,
              selected: !controller.isPhotosTab.value,
              onTap: () => controller.isPhotosTab.value = false,
            ),
          ],
        ),
      ),
    );
  }
}
