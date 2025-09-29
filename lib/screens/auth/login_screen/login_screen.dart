import 'dart:io';
import '../../../config/app_config.dart';
import '../../../widgets/dashed_line.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.isRegistered<LoginController>()
      ? Get.find<LoginController>()
      : Get.put(LoginController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    // Save Me switch state
    final saveMe = RxBool(false);
    

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        controller.clearData();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 52),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      AppImages.logo,
                      height: AppDimens.dimen100 + 10,
                      width: AppDimens.dimen100 + AppDimens.dimen20,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: AppDimens.dimen100 + 10,
                          width: AppDimens.dimen100 + AppDimens.dimen20,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.loginTitle,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: FontDimen.dimen25,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email TextField
                      AppTextField(
                        tag: AppStrings.emailAddress,
                        hintText: AppStrings.emailAddress,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.emailValidator,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: SizedBox(
                            height: AppDimens.dimen18,
                            width: AppDimens.dimen18,
                            child: Image.asset(
                              AppImages.email,
                              height: AppDimens.dimen18,
                              width: AppDimens.dimen18,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
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
                      const SizedBox(height: 13),

                      // Password TextField
                      AppTextField(
                        tag: AppStrings.password,
                        hintText: AppStrings.password,
                        controller: controller.passwordController,
                        obscureText: true,
                        validator: controller.passwordValidator,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: SizedBox(
                            height: AppDimens.dimen18,
                            width: AppDimens.dimen18,
                            child: Image.asset(
                              AppImages.password,
                              height: AppDimens.dimen18,
                              width: AppDimens.dimen18,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(-8, 0),
                      child: Obx(
                        () => Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  padding: const EdgeInsets.all(0),
                                  value: saveMe.value,
                                  onChanged: (val) => saveMe.value = val,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  trackColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (states) => states
                                            .contains(MaterialState.selected)
                                        ? AppColors.primaryColor
                                        : AppColors.textColor2.withOpacity(0.2),
                                  ),
                                  thumbColor: MaterialStateProperty.all(
                                      const Color(0xFFD8DBDF)),
                                ),
                              ),
                            ),
                            Text(
                              AppStrings.saveMe,
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.9),
                                fontSize: FontDimen.dimen13,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ForgotPassScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Text(
                          AppStrings.forgotPasswordQ,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(0.85),
                            fontSize: FontDimen.dimen13,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                      onPressed: () => controller.login(formKey),
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
                        AppStrings.login,
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(0.8),
                              fontSize: FontDimen.dimen12,
                              fontWeight: FontWeight.w400,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              controller.clearData();

                              Get.to(() => RegisterScreen());
                            },
                            child: Text(
                              AppStrings.register,
                              style: TextStyle(
                                color: AppColors.primaryColor.withOpacity(1),
                                fontSize: FontDimen.dimen14,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: DashedLine(
                    height: 1,
                    color: AppColors.textColor2.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    // Google Button
                    Flexible(
                      child: SocialButton(
                        onPressed: () {},
                        icon: Image.asset(
                          AppImages.google,
                          height: AppDimens.dimen30,
                          width: AppDimens.dimen30,
                          fit: BoxFit.cover,
                        ),
                        label: AppStrings.loginWithGoogle,
                      ),
                    ),
                    if (Platform.isIOS) const SizedBox(width: 14),
                    // Apple Button
                    if (Platform.isIOS)
                      Flexible(
                        child: SocialButton(
                          onPressed: () {},
                          icon: Image.asset(
                            AppImages.apple,
                            height: AppDimens.dimen30,
                            width: AppDimens.dimen30,
                            fit: BoxFit.cover,
                          ),
                          label: AppStrings.loginWithApple,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
