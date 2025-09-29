import '../../config/app_config.dart';
import 'child_dashboard_controller.dart';
import '../post_visibility/post_visibility_screen.dart';
import 'widgets/activities_tab_content.dart';
import 'widgets/child_dashboard_tabs.dart';
import 'widgets/child_profile_header.dart';
import 'widgets/settings_tab_content.dart';

class ChildDashboardScreen extends StatelessWidget {
  final controller = Get.put(ChildDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ----- Top bar -----
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
                      child: Obx(
                        () => Text(
                          controller.child.value.username,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(1),
                            fontSize: FontDimen.dimen18,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: AppDimens.dimen12),
                    child: Opacity(
                      opacity: 0,
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen14,
                        width: AppDimens.dimen14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimens.dimen10),
            // ----- Profile Header -----
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dimen16,
                vertical: AppDimens.dimen10,
              ),
              child: Obx(
                () => ChildProfileHeader(child: controller.child.value),
              ),
            ),
            // ----- Tabs -----
            Padding(
              padding: EdgeInsets.only(
                top: AppDimens.dimen14,
                left: AppDimens.dimen16,
                right: AppDimens.dimen16,
              ),
              child: Obx(
                () => ChildDashboardTabs(
                  selectedTab: controller.selectedTab.value,
                  onSelect: controller.setTab,
                ),
              ),
            ),
            // ----- Tab content -----
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: controller.selectedTab.value == 0
                      ? ActivitiesTabContent(
                          activities: controller.child.value.recentActivities,
                        )
                      : SettingsTabContent(
                          postVisibility:
                              controller.selectedPostVisibility.value,
                          contentAgeRestriction:
                              controller.child.value.contentAgeRestriction,
                          onPostVisibilityTap: () {
                            final currentVisibility =
                                controller.child.value.postVisibility;
                            Get.to(
                              () => PostVisibilityScreen(
                                initialSelected: currentVisibility,
                                onSelected: (val) {
                                  controller.child.update(
                                    (c) {
                                      if (c != null) c.postVisibility = val;
                                    },
                                  );
                                },
                              ),
                            );
                          },
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
