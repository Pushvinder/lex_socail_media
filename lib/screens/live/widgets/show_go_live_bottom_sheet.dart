import 'dart:ui';
import '../../../config/app_config.dart';
import '../live_controller.dart';

void showGoLiveBottomSheet(
  BuildContext context,
  void Function(String title) onLive,
) {
  final controller = Get.put(LiveController());

  showGeneralDialog(
    context: context,
    barrierLabel: "GoLive",
    barrierDismissible: true,
    barrierColor: AppColors.dialogBgColor.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 170),
    pageBuilder: (context, anim1, anim2) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: AppColors.dialogBgColor.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Material(
                    color: AppColors.scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: SizedBox(
                      height: 252,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                width: 55,
                                height: 3.5,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: AppColors.textColor4,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Center(
                              child: Text(
                                AppStrings.goLive,
                                style: TextStyle(
                                  fontFamily: AppFonts.appFont,
                                  fontSize: FontDimen.dimen18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor3.withOpacity(1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 19),
                            Text(
                              AppStrings.addATitle,
                              style: TextStyle(
                                color: AppColors.buyCoinPrice.withOpacity(1),
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: FontDimen.dimen14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            AppTextField(
                              tag: AppStrings.goLive,
                              hintText: AppStrings.addTitleHint,
                              controller: controller.titleController,
                              onChanged: controller.setTitle,
                              hintStyle: TextStyle(
                                color: AppColors.textColor2.withOpacity(0.5),
                                fontSize: FontDimen.dimen13,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(1),
                                fontSize: FontDimen.dimen13,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            const Spacer(),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColorShade,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: controller.title.value.isEmpty
                                      ? null
                                      : () {
                                          onLive(controller.title.value);
                                          controller.clearTitle();
                                          Navigator.of(context).pop();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    AppStrings.goLive,
                                    style: TextStyle(
                                      color: AppColors.whiteColor
                                          .withOpacity(0.92),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
}
