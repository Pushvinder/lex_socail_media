import '../../config/app_config.dart';
import 'parental_control_controller.dart';
import 'widgets/child_account_card.dart';

class ParentalControlScreen extends StatelessWidget {
  ParentalControlScreen({super.key});

  final ParentalControlController controller =
      Get.put(ParentalControlController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingLinkedChildList.value) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.textColor5.withOpacity(0.65),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- Top Bar -----
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
                          AppStrings.parentalControl,
                          textAlign: TextAlign.center,
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
              SizedBox(height: AppDimens.dimen24),

              // Child Accounts Title
              Padding(
                padding: EdgeInsets.only(left: AppDimens.dimen18),
                child: Text(
                  AppStrings.childAccounts,
                  style: TextStyle(
                    color: AppColors.textColor4,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: FontDimen.dimen15,
                  ),
                ),
              ),
              SizedBox(height: AppDimens.dimen2),

              // --- List of Child Account Cards ---
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.only(top: AppDimens.dimen2),
                    itemCount: controller.childAccounts.value.length,
                    itemBuilder: (context, index) {
                      final child = controller.childAccounts.value[index];
                      return ChildAccountCard(
                        childAccount: child,
                        onViewDashboard: () =>
                            controller.viewChildDashboard(child),
                      );
                    },
                  ),
                ),
              ),

              // --- Link Child Account Button ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dimen16,
                  vertical: AppDimens.dimen30,
                ),
                child: GestureDetector(
                  onTap: controller.linkChildAccount,
                  child: Container(
                    width: double.infinity,
                    height: AppDimens.dimen70 + 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColorShade,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(AppDimens.dimen16),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.linkChildAccount,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(0.9),
                              fontSize: FontDimen.dimen14,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                          SizedBox(width: AppDimens.dimen10),
                          Image.asset(
                            AppImages.linkWhiteIcon,
                            height: AppDimens.dimen22,
                            width: AppDimens.dimen22,
                            color: AppColors.whiteColor.withOpacity(1),
                            filterQuality: FilterQuality.high,
                            matchTextDirection: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimens.dimen12),
            ],
          );
        }),
      ),
    );
  }
}
