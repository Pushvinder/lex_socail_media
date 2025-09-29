import '../../config/app_config.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final currentPage = 0.obs;

  // Dynamic onboarding data based on the user role
  List<Map<String, String>> onboardingData = [];

  @override
  void onInit() {
    super.onInit();

    onboardingData = [
      {
        'image': AppImages.logo,
        'title': AppStrings.welcomeTo,
        'bigTitle': AppStrings.theFriendzZone,
        'subtitle': AppStrings.onboardingSubtitle1,
      },
      {
        'image': AppImages.onboarding1,
        'title': AppStrings.onboardingTitle1,
        'subtitle': AppStrings.onboardingSubtitle2,
      },
      {
        'image': AppImages.onboarding2,
        'title': AppStrings.onboardingTitle2,
        'subtitle': AppStrings.onboardingSubtitle3,
      },
      {
        'image': AppImages.onboarding3,
        'title': AppStrings.onboardingTitle3,
        'subtitle': AppStrings.onboardingSubtitle4,
      },
      {
        'image': AppImages.onboarding4,
        'title': AppStrings.onboardingTitle4,
        'subtitle': AppStrings.onboardingSubtitle5,
      },
    ];
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      // Navigate to the next screen
      Get.to(() => RegisterScreen());
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else if (currentPage.value == 0) {
      // Navigate to the previous screen
      Get.back();
    }
  }
}
