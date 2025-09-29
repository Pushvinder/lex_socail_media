import '../../config/app_config.dart';
import 'subscription_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                AppImages.subscriptionBg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: AppDimens.screenHeight * 1,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.subscriptionBgShade,
                      Colors.transparent,
                    ],
                    stops: [
                      0.0,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 40),
                      Expanded(
                        child: Text(
                          AppStrings.subscriptionPlanTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: FontDimen.dimen24,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          height: 30,
                          width: 40,
                          child: Icon(
                            Icons.close,
                            color: AppColors.whiteColor,
                            size: FontDimen.dimen24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // --- ✨ Premium Feature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.stars,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      AppStrings.premiumFeature,
                      style: TextStyle(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: AppColors.whiteColor,
                        fontSize: FontDimen.dimen16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 17),

                // --- Features List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 3),
                            child: Image.asset(
                              AppImages.blueCheck,
                              height: 18,
                              width: 18,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppStrings.adFreeTitle + ' – ',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      color:
                                          AppColors.whiteColor.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                      fontSize: FontDimen.dimen13,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppStrings.adFreeDesc,
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      color:
                                          AppColors.textColor2.withOpacity(0.7),
                                      fontSize: FontDimen.dimen13,
                                      fontWeight: FontWeight.normal,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: const Offset(0, 3),
                                child: Image.asset(
                                  AppImages.blueCheck,
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  AppStrings.highQualityTitle,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color:
                                        AppColors.textColor2.withOpacity(0.7),
                                    fontSize: FontDimen.dimen13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 56),

                // --- Plan Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ---- Monthly Plan
                          Flexible(
                            child: GestureDetector(
                              onTap: () => controller.selectPlan(Plan.monthly),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 170),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                        color: controller.selectedPlan.value ==
                                                Plan.monthly
                                            ? AppColors.primaryColor
                                            : Colors.white.withOpacity(0.23),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppStrings.monthly,
                                            style: TextStyle(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.monthly
                                                  ? AppColors.primaryColor
                                                  : AppColors.whiteColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontDimen.dimen12,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                              height: 1.3,
                                            ),
                                          ),
                                          Text(
                                            "\$20.00",
                                            style: TextStyle(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.monthly
                                                  ? AppColors.primaryColor
                                                  : AppColors.whiteColor,
                                              fontSize: FontDimen.dimen20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 36),
                                          Text(
                                            AppStrings.monthlyBilled,
                                            style: TextStyle(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.monthly
                                                  ? AppColors.primaryColor
                                                  : AppColors.whiteColor
                                                      .withOpacity(0.65),
                                              fontSize: FontDimen.dimen10,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller.selectedPlan.value ==
                                      Plan.monthly)
                                    Positioned(
                                      top: -6,
                                      right: -3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.35),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Image.asset(
                                          AppImages.blackCheck,
                                          height: 8,
                                          width: 8,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          // ---- Yearly Plan
                          Flexible(
                            child: GestureDetector(
                              onTap: () => controller.selectPlan(Plan.yearly),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 170),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                        color: controller.selectedPlan.value ==
                                                Plan.yearly
                                            ? AppColors.primaryColor
                                            : Colors.white.withOpacity(0.23),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 28),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppStrings.yearly,
                                            style: TextStyle(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.yearly
                                                  ? AppColors.primaryColor
                                                  : AppColors.whiteColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontDimen.dimen12,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                              height: 1.3,
                                            ),
                                          ),
                                          Text(
                                            "\$200.00",
                                            style: TextStyle(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.yearly
                                                  ? AppColors.primaryColor
                                                  : AppColors.whiteColor,
                                              fontSize: FontDimen.dimen20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.yearly
                                                  ? AppColors.primaryColor
                                                      .withOpacity(0.5)
                                                  : AppColors.whiteColor
                                                      .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              AppStrings.saveAmount,
                                              style: TextStyle(
                                                color: AppColors.whiteColor,
                                                fontFamily: GoogleFonts.inter()
                                                    .fontFamily,
                                                fontSize: FontDimen.dimen8,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            AppStrings.freeTrial,
                                            style: TextStyle(
                                              color: controller
                                                          .selectedPlan.value ==
                                                      Plan.yearly
                                                  ? AppColors.primaryColor
                                                  : AppColors.whiteColor
                                                      .withOpacity(0.65),
                                              fontSize: FontDimen.dimen10,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller.selectedPlan.value ==
                                      Plan.yearly)
                                    Positioned(
                                      top: -6,
                                      right: -3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.35),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Image.asset(
                                          AppImages.blackCheck,
                                          height: 8,
                                          width: 8,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),

                const SizedBox(height: 50),
                // --- Terms and restore
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.termsPart1,
                          style: TextStyle(
                            height: 1.7,
                            color: AppColors.textColor2.withOpacity(0.7),
                            fontSize: FontDimen.dimen11,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: AppStrings.termsPart2,
                          style: TextStyle(
                            color: AppColors.textColor2.withOpacity(0.7),
                            fontSize: FontDimen.dimen11,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: AppStrings.termsConditions,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            fontSize: FontDimen.dimen11,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Clicked terms1!");
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 58),
                GestureDetector(
                  onTap: controller.onRestorePurchase,
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.restorePurchase,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.50),
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: FontDimen.dimen16,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.whiteColor.withOpacity(0.3),
                        decorationThickness: 1.5,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // --- Subscribe Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                        onPressed: controller.onSubscribe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppStrings.subscribeNow,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(0.9),
                            fontSize: FontDimen.dimen14,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
