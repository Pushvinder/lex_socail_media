import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_config.dart';

class AppDialogs {
  static void showConfirmationDialog({
    required String title,
    required String description,
    String? secondaryDescription,
    required String iconAsset,
    required Color iconBgColor,
    Color? iconColor,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    Color? confirmButtonColor,
    String cancelButtonText = AppStrings.cancel,
    VoidCallback? onCancel,
  }) {
    final Color finalConfirmButtonColor =
        confirmButtonColor ?? AppColors.primaryColor;
    final bool isDestructiveAction = confirmButtonColor == AppColors.redColor;

    final titleStyle = TextStyle(
      fontFamily: AppFonts.appFont,
      fontSize: FontDimen.dimen20,
      color: AppColors.textColor3.withOpacity(0.85),
      fontWeight: FontWeight.bold,
    );
    final descriptionStyle = GoogleFonts.inter(
      fontSize: FontDimen.dimen16,
      color: AppColors.textColor3.withOpacity(0.8),
      fontWeight: FontWeight.w500,
      height: 1.5,
    );
    final secondaryDescriptionStyle = GoogleFonts.inter(
      fontSize: FontDimen.dimen12,
      color: AppColors.textColor3.withOpacity(0.4),
      fontWeight: FontWeight.w500,
      height: 1.5,
    );
    final cancelButtonTextStyle = GoogleFonts.inter(
      fontSize: FontDimen.dimen13,
      color: AppColors.textColor3.withOpacity(0.7),
      fontWeight: FontWeight.w600,
    );
    final confirmButtonTextStyle = GoogleFonts.inter(
      fontSize: FontDimen.dimen13,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold,
    );

    Get.dialog(
      barrierDismissible: true,
      barrierColor: AppColors.dialogBgColor.withOpacity(0.6),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Dialog(
          backgroundColor: AppColors.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.dimen24),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.dimen24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(AppDimens.dimen15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBgColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Image.asset(
                      iconAsset,
                      height: AppDimens.dimen40,
                      width: AppDimens.dimen40,
                      color: iconColor,
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.dimen20),

                // Title
                Text(
                  title,
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimens.dimen22),

                // Description
                Text(
                  description,
                  style: descriptionStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimens.dimen10),

                if (secondaryDescription != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(
                      secondaryDescription,
                      style: secondaryDescriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppDimens.dimen30),
                ],

                // BUTTONS
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          onCancel?.call();
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              AppColors.textColor3.withOpacity(0.7),
                          side: BorderSide(
                            color: AppColors.textColor3.withOpacity(0.2),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimen12),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: AppDimens.dimen15),
                        ),
                        child: Center(
                          child: Text(
                            cancelButtonText,
                            style: cancelButtonTextStyle,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.dimenW30),
                    // Confirm Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Future.microtask(onConfirm);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: finalConfirmButtonColor,
                          foregroundColor: AppColors.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimen12),
                          ),
                          elevation: isDestructiveAction ? 0 : 1,
                          padding:
                              EdgeInsets.symmetric(vertical: AppDimens.dimen16),
                        ),
                        child: Center(
                          child: Text(
                            confirmButtonText,
                            style: confirmButtonTextStyle,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

   static successSnackBar(String msg) {
    if (msg.isNotEmpty) {
      return ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
            backgroundColor: AppColors.terneryColor,
            content: Text(
              msg,
              style: TextStyle(
                  fontSize: FontDimen.dimen14, color: AppColors.secondaryColor),
            )),
      );
    }
  }

  static errorSnackBar(String msg) {
    if (msg.isNotEmpty) {
      return ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
            backgroundColor: AppColors.redColor,
            content: Text(
              msg,
              style: TextStyle(
                  fontSize: FontDimen.dimen14, color: AppColors.secondaryColor),
            )),
      );
    }
  }
}
