import '../../../config/app_config.dart';
import 'reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller =
      Get.isRegistered<ResetPasswordController>()
          ? Get.find<ResetPasswordController>()
          : Get.put(ResetPasswordController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top bar with back
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
                        AppStrings.resetPassword,
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
            const SizedBox(height: 16),

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // --- Current Password ---
                    AppTextField(
                      tag: AppStrings.currentPassword,
                      hintText: AppStrings.currentPassword,
                      controller: controller.currentPasswordController,
                      obscureText: true,
                      validator: controller.currentPasswordValidator,
                      hintStyle: TextStyle(
                        color: AppColors.textColor2.withOpacity(0.3),
                        fontSize: FontDimen.dimen13,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 3),

                    // --- New Password ---
                    AppTextField(
                      tag: AppStrings.newPassword,
                      hintText: AppStrings.newPassword,
                      controller: controller.newPasswordController,
                      obscureText: true,
                      validator: controller.newPasswordValidator,
                      onChanged: (val) {
                        // Live re-validate confirm
                        if (Get.isRegistered<TextFieldController>(
                            tag: AppStrings.confirmNewPassword)) {
                          final confirmFieldCtrl =
                              Get.find<TextFieldController>(
                                  tag: AppStrings.confirmNewPassword);
                          final confirmError =
                              controller.confirmPasswordValidator(
                                  controller.confirmPasswordController.text);
                          confirmFieldCtrl.setValidationMessage(confirmError);
                        }
                      },
                      hintStyle: TextStyle(
                        color: AppColors.textColor2.withOpacity(0.3),
                        fontSize: FontDimen.dimen13,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 3),

                    // --- Confirm New Password ---
                    AppTextField(
                      tag: AppStrings.confirmNewPassword,
                      hintText: AppStrings.confirmNewPassword,
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      validator: controller.confirmPasswordValidator,
                      hintStyle: TextStyle(
                        color: AppColors.textColor2.withOpacity(0.3),
                        fontSize: FontDimen.dimen13,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // --- Reset Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColorShade,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.changePassword(formKey),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.reset,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        fontSize: FontDimen.dimen15,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimens.dimen20),
          ],
        ),
      ),
    );
  }
}
