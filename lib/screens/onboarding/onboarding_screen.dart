import '../../config/app_config.dart';
import 'onboarding_controller.dart';
import 'widgets/animation_next_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.onboardingData.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return _buildPage(controller, controller.onboardingData[index]);
            },
          ),

          Positioned(
            top: AppDimens.dimen60,
            left: AppDimens.dimen20,
            child: Obx(
              () => controller.currentPage.value != 0
                  ? Padding(
                      padding: EdgeInsets.only(left: AppDimens.dimen20),
                      child: GestureDetector(
                        onTap: () {
                          if (controller.currentPage.value > 0) {
                            controller.previousPage();
                          }
                        },
                        child: Container(
                          height: AppDimens.dimen60,
                          width: AppDimens.dimen60,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.secondaryColor.withOpacity(0.12),
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
                    )
                  : SizedBox.shrink(),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              AppImages.onboardingBottomPatternBg,
              height: AppDimens.dimen200,
              width: AppDimens.screenWidth,
              fit: BoxFit.contain,
              color: AppColors.secondaryColor.withOpacity(0.3),
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: AppDimens.dimen60,
            left: 0,
            right: 0,
            child: Obx(
              () => AnimatedCircularProgressButton(
                backgroundColor: controller.currentPage.value == 4
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                backgroundBottomColor: controller.currentPage.value == 4
                    ? AppColors.primaryColorShade
                    : AppColors.secondaryColor,
                progress: (controller.currentPage.value + 1) /
                    controller.onboardingData.length,
                text: controller.currentPage.value ==
                        controller.onboardingData.length - 1
                    ? ''
                    : AppStrings.next,
                icon: controller.currentPage.value ==
                        controller.onboardingData.length - 1
                    ? Icons.check
                    : null,
                onTap: () {
                  controller.nextPage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _buildPage method
  Widget _buildPage(OnboardingController controller, Map<String, String> data) {
    final image = data['image'] ?? '';
    final title = data['title'] ?? '';
    final bigTitle = data['bigTitle'] ?? '';
    final subtitle = data['subtitle'] ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen40),
      child: Column(
        children: [
          SizedBox(height: AppDimens.screenHeight * 0.136),
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                image ?? '',
                height: AppDimens.dimen300 + 10,
                width: AppDimens.dimen300 + AppDimens.dimen20,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    // Placeholder for broken image
                    height: AppDimens.dimen300 + 10,
                    width: AppDimens.dimen300 + AppDimens.dimen20,
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
          SizedBox(height: AppDimens.dimen40),
          Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryColor.withOpacity(0.12),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppDimens.dimen15,
                    right: AppDimens.dimen15,
                    top: AppDimens.dimen30 - 2,
                    bottom: AppDimens.dimen30,
                  ),
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.textColor1,
                              fontSize: FontDimen.dimen24,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.appFont,
                            ),
                          ),
                        ),

                        const SizedBox.shrink(),
                        if (controller.currentPage.value == 0 &&
                            bigTitle.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              top: title.isNotEmpty ? AppDimens.dimen8 : 0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                bigTitle + '!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textColor2,
                                  fontSize: FontDimen.dimen24,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.appFont,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),

                        SizedBox(height: AppDimens.dimen24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            subtitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.textColor3,
                              fontSize: FontDimen.dimen16,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ),

                        SizedBox(height: AppDimens.dimen30),
                        // Center(
                        //   child: SmoothPageIndicator(
                        //     controller: controller.pageController,
                        //     count: controller.onboardingData.length,
                        //     effect: ExpandingDotsEffect(
                        //       activeDotColor: AppColors.textColor1,
                        //       dotHeight: AppDimens.dimen10,
                        //       dotWidth: AppDimens.dimen10,
                        //       spacing: AppDimens.dimen8,
                        //       expansionFactor: 3,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: AppDimens.dimen20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
