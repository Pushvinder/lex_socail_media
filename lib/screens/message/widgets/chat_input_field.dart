import '../../../config/app_config.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;

  const ChatInputField({
    required this.controller,
    required this.onSend,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top border above the entire input area
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
          child: Container(
            color: AppColors.textColor4,
            height: 1,
            width: double.infinity,
          ),
        ),
        // Input row
        Container(
          color: AppColors.scaffoldBackgroundColor,
          padding: EdgeInsets.only(
            left: AppDimens.dimen16,
            right: AppDimens.dimen16,
            top: AppDimens.dimen10,
            bottom: AppDimens.dimen20,
          ),
          child: Row(
            children: [
              // TextField with all icons inside
              Expanded(
                child: Container(
                  height: AppDimens.dimen80,
                  decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(AppDimens.dimen16),
                    border: Border.all(
                      color: AppColors.textColor4.withOpacity(0.13),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Plus icon
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppDimens.dimen12,
                          right: AppDimens.dimen8,
                        ),
                        child: Image.asset(
                          AppImages.plusBlueIcon,
                          height: AppDimens.dimen24,
                          width: AppDimens.dimen24,
                        ),
                      ),
                      // TextField
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(1),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontSize: FontDimen.dimen12,
                          ),
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            hintText: AppStrings.chatInputHint,
                            hintStyle: TextStyle(
                              color: AppColors.textColor3.withOpacity(0.7),
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontSize: FontDimen.dimen12,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: AppDimens.dimen15,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      // Mic icon
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
                        child: Image.asset(
                          AppImages.micBlueIcon,
                          height: AppDimens.dimen26,
                          width: AppDimens.dimen26,
                        ),
                      ),
                      SizedBox(width: AppDimens.dimen12),
                      // Camera icon
                      Padding(
                        padding: EdgeInsets.only(right: AppDimens.dimen8),
                        child: Image.asset(
                          AppImages.cameraBlueIcon,
                          height: AppDimens.dimen26,
                          width: AppDimens.dimen26,
                        ),
                      ),
                      SizedBox(width: AppDimens.dimen6),
                      GestureDetector(
                        onTap: onSend,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: AppColors.textColor4,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Image.asset(
                                AppImages.sendFilledIcon,
                                height: AppDimens.dimen35 - 2,
                                width: AppDimens.dimen35 - 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimens.dimen8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
