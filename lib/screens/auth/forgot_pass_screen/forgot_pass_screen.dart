import '../../../config/app_config.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});

  final ForgotPassController controller =
      Get.isRegistered<ForgotPassController>()
          ? Get.find<ForgotPassController>()
          : Get.put(ForgotPassController());

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
              const SizedBox(height: 58),

              // Back Arrow Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: AppDimens.dimen60,
                    width: AppDimens.dimen60,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryColor.withOpacity(0.12),
                          offset: const Offset(0, 4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen20,
                        width: AppDimens.dimen20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 45),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.forgotPassTitle,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: FontDimen.dimen25,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.forgotPassDesc,
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.6),
                    fontSize: FontDimen.dimen14,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 45),

              // Email TextField
              Form(
                key: formKey,
                child: AppTextField(
                  tag: AppStrings.emailAddress,
                  hintText: AppStrings.emailAddress,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(AppValidation.emailRegex)
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
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
              ),

              const SizedBox(height: 13),

              // Send OTP Button
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
                    onPressed: () => controller.forgotPass(formKey),
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
                      AppStrings.sendOTPbtn,
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
