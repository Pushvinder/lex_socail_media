import '../../config/app_config.dart';
import 'package:get/get.dart';
import 'post_visibility_controller.dart';

class PostVisibilityScreen extends StatelessWidget {
  final String initialSelected;
  final ValueChanged<String> onSelected;

  PostVisibilityScreen({
    required this.initialSelected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final List<String> options = const [
    AppStrings.everyone,
    AppStrings.connectionsOnly,
    AppStrings.private_,
  ];

  @override
  Widget build(BuildContext context) {
    // Register or find controller for THIS screen
    final controller = Get.put(PostVisibilityController());
    // Set initial value ONCE on screen open (use a post-frame-callback pattern)
    if (controller.selected.value != initialSelected) {
      controller.setInitial(initialSelected);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ---- HEADER BAR ----
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
                        AppStrings.postVisibility,
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
            // ---- LIST ----
            Expanded(
              child: Obx(
                () {
                  controller.selected.value = controller.selected.value;
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dimen16,
                      vertical: AppDimens.dimen18,
                    ),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppDimens.dimen20),
                    itemBuilder: (context, idx) {
                      final opt = options[idx];
                      final isChecked = controller.selected.value == opt;
                      return GestureDetector(
                        onTap: () {
                          controller.selected.value = opt;
                          onSelected(opt);
                          // Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimens.dimen20,
                            horizontal: AppDimens.dimen12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBgColor,
                            borderRadius:
                                BorderRadius.circular(AppDimens.dimen16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                opt,
                                style: TextStyle(
                                  color: AppColors.textColor3.withOpacity(1),
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: FontDimen.dimen14,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.textColor4,
                                    width: 2.3,
                                  ),
                                  color: isChecked
                                      ? AppColors.textColor4.withOpacity(1)
                                      : AppColors.textColor4,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: isChecked
                                    ? Transform.translate(
                                        offset: const Offset(0, 3),
                                        child: Center(
                                          child: Image.asset(
                                            AppImages.blueCheck,
                                            width: 16,
                                            height: 16,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
