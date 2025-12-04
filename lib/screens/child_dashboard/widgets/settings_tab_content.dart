import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_config.dart';
import '../child_dashboard_controller.dart';

class SettingsTabContent extends StatelessWidget {
  final String postVisibility;
  final String contentAgeRestriction;
  final VoidCallback onPostVisibilityTap;
  final VoidCallback? onContentAgeRestrictionTap;
  final ChildDashboardController? controller;

  const SettingsTabContent({
    super.key,
    required this.postVisibility,
    required this.contentAgeRestriction,
    required this.onPostVisibilityTap,
    this.onContentAgeRestrictionTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dimen16,
        AppDimens.dimen20,
        AppDimens.dimen16,
        AppDimens.dimen10,
      ),
      child: Column(
        children: [
          SettingsTile(
            title: AppStrings.postVisibility,
            value: postVisibility,
            icon: AppImages.eyeSettingsIcon,
            onTap: onPostVisibilityTap,
            controller: controller,
          ),
          SizedBox(height: AppDimens.dimen22),
          SettingsTile(
            title: AppStrings.contentAgeRestrictions,
            value: contentAgeRestriction,
            icon: null,
            onTap: onContentAgeRestrictionTap,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final String? icon;
  final VoidCallback? onTap;
  final ChildDashboardController? controller;

  const SettingsTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAgeRestriction = title == AppStrings.contentAgeRestrictions;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT SIDE: TITLE
          Text(
            title,
            style: TextStyle(
              color: AppColors.textColor3,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w500,
              fontSize: FontDimen.dimen14,
            ),
          ),

          /// RIGHT SIDE (AGE DROPDOWN)
          if (isAgeRestriction)
            _buildAgeDropdown(controller)
          else
            _buildPostVisibilityTile(),
        ],
      ),
    );
  }

  /// -------------------------------
  /// POST VISIBILITY TILE UI
  /// -------------------------------
  Widget _buildPostVisibilityTile() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              color: AppColors.textColor4,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w500,
              fontSize: FontDimen.dimen12,
            ),
          ),
          if (icon != null) ...[
            SizedBox(width: 12),
            Image.asset(icon!, width: 20, height: 20),
          ],
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textColor4.withOpacity(0.5),
          )
        ],
      ),
    );
  }

  /// -------------------------------
  /// AGE DROPDOWN UI
  /// -------------------------------
  Widget _buildAgeDropdown(ChildDashboardController? controller) {
    if (controller == null) {
      return _staticAgeBlocked();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 🔥 fixes tap issue
      onTap: () {
        print("AGE DROPDOWN CLICKED");
        _openAgeBottomSheet(controller);
      },
      child: Obx(() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.selectedContentAgeRestriction.value,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: FontDimen.dimen15,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: AppColors.primaryColor,
            ),
          ],
        );
      }),
    );
  }

  /// STATIC fallback
  Widget _staticAgeBlocked() {
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: FontDimen.dimen15,
          ),
        ),
        SizedBox(width: 6),
        Icon(
          Icons.keyboard_arrow_down,
          size: 22,
          color: AppColors.primaryColor,
        ),
      ],
    );
  }

  /// -------------------------------
  /// OPEN BOTTOM SHEET
  /// -------------------------------
  void _openAgeBottomSheet(ChildDashboardController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),

            /// Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                children: [
                  Text(
                    AppStrings.contentAgeRestrictions,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: AppColors.textColor4),
                  ),
                ],
              ),
            ),

            /// AGE LIST
            Obx(() {
              if (controller.contentAgeResponse.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.contentAgeResponse.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final age = controller.contentAgeResponse[index]!;

                  final bool selected =
                      controller.selectedAgeGroupId.value == age.id;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.selectContentAgeRestriction(
                        age.id!,
                        age.ageLabel!,
                      );
                      Get.back();
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryColor.withOpacity(0.1)
                            : AppColors.cardBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            age.ageLabel ?? "",
                            style: TextStyle(
                              color: selected
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                              fontWeight:
                              selected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          if (selected)
                            Icon(Icons.check_circle,
                                color: AppColors.primaryColor),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),

            SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
