import 'dart:ui';
import '../../../config/app_config.dart';

class SheetAction {
  final String text;
  final String iconAsset;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? tileColor;
  final bool destructive;
  const SheetAction({
    required this.text,
    required this.iconAsset,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.tileColor,
    this.destructive = false,
  });
}

Future<void> showActionSheet(
  BuildContext context, {
  required List<SheetAction> actions,
  Color? blurBackgroundColor,
  double blurSigma = 1,
  double radius = 33,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor:
        blurBackgroundColor ?? AppColors.dialogBgColor.withOpacity(0.6),
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (ctx) {
      return Stack(
        children: [
          // Tappable dismissible blur
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              behavior: HitTestBehavior.translucent,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: Container(),
              ),
            ),
          ),
          // Action sheet content
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
              child: Container(
                color: AppColors.scaffoldBackgroundColor,
                padding: const EdgeInsets.only(top: 10, bottom: 38),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 54,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 34),
                      decoration: BoxDecoration(
                        color: AppColors.subscriptionBgShade,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    ...List.generate(
                      actions.length,
                      (i) {
                        final action = actions[i];
                        return Column(
                          children: [
                            _OptionsTile(
                              title: action.text,
                              iconAsset: action.iconAsset,
                              iconColor: action.iconColor ??
                                  (action.destructive
                                      ? AppColors.redColor
                                      : Colors.white.withOpacity(0.88)),
                              tileColor: action.tileColor ?? AppColors.bgColor,
                              textColor:
                                  action.textColor ?? AppColors.textColor2,
                              onTap: () {
                                Navigator.of(context).pop();
                                if (action.onTap != null) {
                                  action.onTap!();
                                }
                              },
                            ),
                            if (i < actions.length - 1)
                              const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _OptionsTile extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Color iconColor;
  final Color tileColor;
  final Color textColor;
  final VoidCallback onTap;
  const _OptionsTile({
    required this.title,
    required this.iconAsset,
    required this.iconColor,
    required this.tileColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: AppColors.whiteColor.withOpacity(0.03),
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 53,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 19),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                letterSpacing: 0.10,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            Image.asset(
              iconAsset,
              width: 20,
              height: 20,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example usage on ANY screen:
///
/// showActionSheet(
///   context,
///   actions: [
///     SheetAction(
///       text: "Edit Post",
///       iconAsset: AppImages.editIcon,
///       onTap: () { ... },
///     ),
///     SheetAction(
///       text: "Delete Post",
///       iconAsset: AppImages.deleteIcon,
///       destructive: true,
///       onTap: () { ... },
///     ),
///     SheetAction(
///       text: "Report",
///       iconAsset: AppImages.reportIcon,
///       onTap: () { ... },
///       textColor: Colors.orange,
///     ),
///   ],
/// );
