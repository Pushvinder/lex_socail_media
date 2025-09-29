import '../../config/app_config.dart';
import 'bottom_nav_controller.dart';

Widget buildBottomNavBar(BottomNavController navController) {
  final indicatorColor = AppColors.navIndicatorColor;
  final unselectedColor = AppColors.textColor4;
  final selectedColor = AppColors.primaryColor;
  final navBarBackgroundColor = AppColors.bottomNavBarBgColor;
  final plusIconColor = Colors.white;

  const double navBarHeight = 85.0;
  const double fabSize = 60.0;
  const double fabVerticalOffset = -20.0;

  return Obx(
    () {
      navController.updateSystemUI();

      return SizedBox(
        height: navBarHeight + MediaQuery.of(Get.context!).padding.bottom,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // --- Base Navigation Bar Row ---
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: navBarHeight +
                    MediaQuery.of(Get.context!).padding.bottom +
                    (fabSize / 8 + fabVerticalOffset.abs()),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(Get.context!).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: navBarBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStandardNavItem(
                      navController: navController,
                      selectedIconAsset: AppImages.homeSelected,
                      unselectedIconAsset: AppImages.homeUnselected,
                      fallbackIcon: Icons.home_filled,
                      label: AppStrings.home,
                      index: 0,
                      isSelected: navController.selectedIndex.value == 0,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      indicatorColor: indicatorColor,
                    ),
                    _buildStandardNavItem(
                      navController: navController,
                      selectedIconAsset: AppImages.communitySelected,
                      unselectedIconAsset: AppImages.communityUnselected,
                      fallbackIcon: Icons.groups,
                      label: AppStrings.community,
                      index: 1,
                      isSelected: navController.selectedIndex.value == 1,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      indicatorColor: indicatorColor,
                    ),
                    // --- Placeholder for Plus Button ---
                    Expanded(child: Container()),
                    _buildStandardNavItem(
                      navController: navController,
                      selectedIconAsset: AppImages.messageSelected,
                      unselectedIconAsset: AppImages.messageUnselected,
                      fallbackIcon: Icons.chat_bubble_outline,
                      label: AppStrings.message,
                      index: 3,
                      isSelected: navController.selectedIndex.value == 3,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      indicatorColor: indicatorColor,
                    ),
                    _buildStandardNavItem(
                      navController: navController,
                      selectedIconAsset: AppImages.profileSelected,
                      unselectedIconAsset: AppImages.profileUnselected,
                      fallbackIcon: Icons.person_outline,
                      label: AppStrings.profile,
                      index: 4,
                      isSelected: navController.selectedIndex.value == 4,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      indicatorColor: indicatorColor,
                    ),
                  ],
                ),
              ),
            ),

            // --- Floating Plus Button ---
            Positioned(
              bottom: MediaQuery.of(Get.context!).padding.bottom +
                  navBarHeight +
                  fabVerticalOffset -
                  (fabSize / 1.24),
              child: GestureDetector(
                onTap: () => navController.changeTabIndex(2),
                child: Center(
                  child: Image.asset(
                    AppImages.plusIcon,
                    width: fabSize,
                    height: fabSize,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.add,
                      color: plusIconColor,
                      size: fabSize * 0.6,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildStandardNavItem({
  required BottomNavController navController,
  required String selectedIconAsset,
  required String unselectedIconAsset,
  required IconData fallbackIcon,
  required String label,
  required int index,
  required bool isSelected,
  required Color selectedColor,
  required Color unselectedColor,
  required Color indicatorColor,
}) {
  final Color currentIconColor = isSelected ? selectedColor : unselectedColor;
  final Color textColor = isSelected ? selectedColor : unselectedColor;
  final FontWeight weight = isSelected ? FontWeight.bold : FontWeight.w500;

  final String currentIconAsset =
      isSelected ? selectedIconAsset : unselectedIconAsset;

  const double itemHeight = 63.0;

  return Expanded(
    child: InkWell(
      onTap: () => navController.changeTabIndex(index),
      child: Container(
        height: itemHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: AppDimens.dimen4,
              width: AppDimens.dimen35,
              decoration: BoxDecoration(
                color: isSelected ? indicatorColor : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimens.dimen2),
              ),
            ),
            SizedBox(height: AppDimens.dimen12),
            Image.asset(
              currentIconAsset,
              height: AppDimens.dimen26 + 1,
              width: AppDimens.dimen26 + 1,
              color: currentIconColor,
              errorBuilder: (_, __, ___) => Icon(
                fallbackIcon,
                size: AppDimens.dimen24,
                color: currentIconColor,
              ),
            ),
            SizedBox(height: AppDimens.dimen8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: FontDimen.dimen8 + 1,
                fontWeight: weight,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}
