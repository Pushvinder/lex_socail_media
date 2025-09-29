import '../../config/app_config.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logo,
              height: AppDimens.dimen350,
              width: AppDimens.dimen350,
            ),
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.splashTextColor,
                fontSize: FontDimen.dimen24,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.appFont,
              ),
            )
          ],
        ),
      ),
    );
  }
}
