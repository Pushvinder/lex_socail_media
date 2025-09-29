import 'package:the_friendz_zone/screens/home/home_screen.dart';

import '../../config/app_config.dart';
import '../onboarding/onboarding_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    checkData();
    super.onInit();
  }

  Future<void> checkData() async {
    bool isLoggedin = await StorageHelper().isLoggedIn;
    if (isLoggedin) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.off(() => OnboardingScreen());
    }
    // Future.delayed(
    //   const Duration(seconds: 3),
    //   () {
    //   },
    // );
  }
}
