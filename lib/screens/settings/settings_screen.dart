import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../post_visibility/post_visibility_screen.dart';
import '../parental_control/parental_control_screen.dart';
import '../reset_password/reset_password_screen.dart';
import 'settings_controller.dart';
import 'widgets/settings_title.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dimen16,
                AppDimens.dimen22,
                AppDimens.dimen16,
                AppDimens.dimen2,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.only(right: AppDimens.dimen12),
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen14,
                        width: AppDimens.dimen14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.settings,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(1),
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: AppDimens.dimen12),
                    child: Image.asset(
                      AppImages.backArrow,
                      height: AppDimens.dimen14,
                      width: AppDimens.dimen14,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Subscription Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.textColor4.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.subscriptionStatus,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen16,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.appFont,
                            ),
                          ),
                          Text(
                            AppStrings.monthlySubscription,
                            style: TextStyle(
                              color: AppColors.textColor3.withOpacity(0.3),
                              fontSize: FontDimen.dimen8 + 1,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.nextRenewalOn,
                            style: TextStyle(
                              color: AppColors.textColor4.withOpacity(1),
                              fontSize: FontDimen.dimen8,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 1),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.connectBg.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          child: Text(
                            AppStrings.active,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen14,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.appFont,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Aug 25, 2025",
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontSize: FontDimen.dimen10 - 1,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Settings Items
            settingsTile(
              title: AppStrings.notification,
              trailing: Transform.translate(
                offset: const Offset(6, 0),
                child: Obx(
                  () => SizedBox(
                    width: 40,
                    height: 22,
                    child: Transform.scale(
                      scale: 0.5,
                      child: Switch(
                        value: controller.notificationsOn.value,
                        onChanged: (val) {
                          controller.notificationsOn.value = val;
                          controller.updateNotificationSetting(val ? 1 : 0);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        trackColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => states.contains(MaterialState.selected)
                              ? AppColors.primaryColor
                              : AppColors.textColor2.withOpacity(0.2),
                        ),
                        thumbColor:
                            MaterialStateProperty.all(const Color(0xFFD8DBDF)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            settingsTile(
              title: AppStrings.postVisibility,
              trailing: Image.asset(
                AppImages.eyeSettingsIcon,
                width: 20,
                height: 20,
              ),
              onTap: () {
                Get.to(() => PostVisibilityScreen(
                      initialSelected: controller.postVisibility.value,
                      onSelected: (val) {
                        controller.updatePostVisibility(val);
                      },
                    ));
              },
            ),
            settingsTile(
              title: AppStrings.parentalControl,
              trailing: Image.asset(
                AppImages.parentalControlSettings,
                width: 24,
                height: 24,
              ),
              onTap: () {
                Get.to(() => ParentalControlScreen());
              },
            ),
            settingsTile(
              title: AppStrings.contentAgeRestrictions,
              trailing: Image.asset(
                AppImages.eightPlusIcon,
                width: 24,
                height: 24,
              ),
              onTap: () {},
            ),

            // App Info & Policies
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 1, 19, 2),
              child: Text(
                AppStrings.appInfoPolicies,
                style: TextStyle(
                  color: AppColors.textColor4.withOpacity(1),
                  fontSize: FontDimen.dimen13,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
            ),
            settingsTile(
              title: AppStrings.aboutUs,
              trailing: Image.asset(
                AppImages.aboutUsSettings,
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),
            settingsTile(
              title: AppStrings.support,
              trailing: Image.asset(
                AppImages.supportSettings,
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),
            settingsTile(
              title: AppStrings.privacyPolicy,
              trailing: Image.asset(
                AppImages.privacyPolicySettings,
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),

            // Danger Zone
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 6, 19, 2),
              child: Text(
                AppStrings.dangerZone,
                style: TextStyle(
                  color: AppColors.textColor4.withOpacity(1),
                  fontSize: FontDimen.dimen13,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
            ),
            settingsTile(
              title: AppStrings.resetPassword,
              trailing: Image.asset(
                AppImages.resetPassSettings,
                width: 20,
                height: 20,
              ),
              onTap: () {
                Get.to(() => ResetPasswordScreen());
              },
            ),

            // --- Logout Setting ---
            settingsTile(
              title: AppStrings.logout,
              trailing: Image.asset(
                AppImages.logoutSettingsIcon,
                width: 20,
                height: 20,
              ),
              onTap: () {
                AppDialogs.showConfirmationDialog(
                  title: AppStrings.dialogLogoutTitle,
                  description: AppStrings.dialogLogoutDescription,
                  iconAsset: AppImages.logoutSettingsIcon,
                  iconBgColor: AppColors.primaryColor.withOpacity(0.13),
                  iconColor: AppColors.primaryColor,
                  confirmButtonText: AppStrings.logout,
                  onConfirm: () {
                    Get.findOrPut(BottomNavController()).setTabIndex(0);
                    Get.offAll(() => LoginScreen());
                  },
                );
              },
            ),

            // --- Delete Account Setting ---
            settingsTile(
              title: AppStrings.deleteAccount,
              trailing: Image.asset(
                AppImages.deleteAccountSettings,
                width: 20,
                height: 20,
              ),
              onTap: () {
                AppDialogs.showConfirmationDialog(
                  title: AppStrings.dialogDeleteAccountTitle,
                  description: AppStrings.dialogDeleteAccountDescription,
                  iconAsset: AppImages.deleteAccountSettings,
                  iconBgColor: AppColors.redColor.withOpacity(0.13),
                  iconColor: AppColors.redColor,
                  confirmButtonText: AppStrings.deleteAccount,
                  confirmButtonColor: AppColors.redColor,
                  onConfirm: () {},
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
