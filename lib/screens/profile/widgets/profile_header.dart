import 'package:the_friendz_zone/screens/editProfile/edit_profile_info_screen/edit_profile_info_screen.dart';
import 'package:the_friendz_zone/screens/withdraw_coins/withdraw_coins_screen.dart';

import '../../../config/app_config.dart';
import '../../../widgets/custom_bottom_sheet.dart';
import '../../settings/settings_screen.dart';
import '../profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({
    Key? key,
  }) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.whiteColor.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
          ),
          onPressed: () {
            Get.to(() =>  WithdrawCoinsScreen());
          },
          child: Text(
            AppStrings.withdrawCoins,
            style: GoogleFonts.inter(
              color: AppColors.whiteColor,
              fontSize: FontDimen.dimen11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            showActionSheet(
              context,
              actions: [
                // Edit Profile Option
                SheetAction(
                  text: AppStrings.editProfile,
                  iconAsset: AppImages.editProfileIcon,
                  onTap: () {
                    AppDialogs.showConfirmationDialog(
                      title: AppStrings.editProfile,
                      description: AppStrings.dialogEditProfileMessage,
                      iconAsset: AppImages.editProfileIcon,
                      iconBgColor: AppColors.primaryColor.withOpacity(0.13),
                      iconColor: AppColors.primaryColor,
                      confirmButtonText: AppStrings.doneText,
                      onConfirm: () {
                        Get.to(() => const EditProfileInfoScreen());
                      },
                    );
                  },
                ),
                // Settings Option
                SheetAction(
                  text: AppStrings.settings,
                  iconAsset: AppImages.settingsIcon,
                  onTap: () {
                    Get.to(
                      () => SettingsScreen(),
                    );
                    // AppDialogs.showConfirmationDialog(
                    //   title: AppStrings.settings,
                    //   description: AppStrings.dialogSettingsMessage,
                    //   iconAsset: AppImages.settingsIcon,
                    //   iconBgColor: AppColors.redColor.withOpacity(0.13),
                    //   iconColor: AppColors.redColor,
                    //   confirmButtonText: AppStrings.deletePost,
                    //   confirmButtonColor: AppColors.redColor,
                    //   onConfirm: () {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         backgroundColor: AppColors.cardBehindBg,
                    //         content: Text(
                    //           AppStrings.postDeletedSnackbar,
                    //           style: TextStyle(
                    //             color: AppColors.redColor,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                ),
              ],
            );
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RotatedBox(
                quarterTurns: 3,
                child: Image.asset(
                  AppImages.threeDottedMenu,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
