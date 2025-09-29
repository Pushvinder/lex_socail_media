import '../../config/app_config.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        AppStrings.notificationTitle,
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
                      color: AppColors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            // Notifications ist
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  AppStrings.noNotifications,
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(0.7),
                    fontSize: FontDimen.dimen14,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
