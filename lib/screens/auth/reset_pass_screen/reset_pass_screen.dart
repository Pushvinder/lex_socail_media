import '../../../config/app_config.dart';

class ResetPassScreen extends StatelessWidget {
  String email = '';
  ResetPassScreen({
    super.key,
    required this.email,
  });

  final ResetPassController controller = Get.isRegistered<ResetPassController>()
      ? Get.find<ResetPassController>()
      : Get.put(ResetPassController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.resetPassTitle,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: FontDimen.dimen25,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
              ),
              const SizedBox(height: 41),

              Form(
                key: formKey,
                child: Column(
                  children: [
                    // New Password TextField
                    AppTextField(
                      tag: AppStrings.newPassword,
                      hintText: AppStrings.newPassword,
                      controller: controller.newPasswordController,
                      obscureText: true,
                      validator: controller.newPasswordValidator,
                      onChanged: (val) {
                        // live update confirm password error (if present)
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
                        vertical: 16,
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    SizedBox(height: AppDimens.dimen20),

                    // Confirm New Password TextField
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
                        vertical: 16,
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Reset Button
              DecoratedBox(
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
                    onPressed: () => controller.resetPassword(formKey,email),
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
              SizedBox(height: AppDimens.dimen20),
            ],
          ),
        ),
      ),
    );
  }
}
