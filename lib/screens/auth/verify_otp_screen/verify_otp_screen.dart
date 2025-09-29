import '../../../config/app_config.dart';

class VerifyOTPScreen extends GetView<VerifyOTPController> {
  String? screen = 'forgot';
  String email;

  VerifyOTPScreen({
    super.key,
    this.screen,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyOTPController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 154),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.otpTitle,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: FontDimen.dimen25,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.otpDesc,
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.6),
                    fontSize: FontDimen.dimen14,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  email,
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.6),
                    fontSize: FontDimen.dimen14,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 29),

              // OTP Input Field Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => StyledOtpInput(
                    controller: controller.otpControllers[index],
                    focusNode: controller.focusNodes[index],
                    verifyOtpController: controller,
                    index: index,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // ==== TIMER - REACTIVE ====
              Align(
                alignment: Alignment.centerLeft,
                child: Obx(() => Text(
                      '(${(controller.secondsLeft.value ~/ 60).toString()}:${(controller.secondsLeft.value % 60).toString().padLeft(2, '0')}) sec',
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.6),
                        fontSize: FontDimen.dimen14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    )),
              ),
              const SizedBox(height: 15),

              // Verify Button
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      controller.verifyOtp(
                          screen: screen ?? 'forgot', email: email);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.verifyOTP,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        fontSize: FontDimen.dimen15,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ---- Send Again Button ----
              Obx(
                () => DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bgColor,
                        AppColors.bgColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.secondsLeft.value == 0
                          ? () => controller.sendOtpAgain(this.email)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.sendAgainBtn,
                        style: TextStyle(
                          color: controller.secondsLeft.value == 0
                              ? AppColors.whiteColor.withOpacity(0.9)
                              : AppColors.whiteColor
                                  .withOpacity(0.4), // dim if disabled
                          fontSize: FontDimen.dimen15,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Text styles
  final titleStyle = TextStyle(
    color: AppColors.textColor1,
    fontSize: FontDimen.dimen18,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.appFont,
  );

  final otpDescStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: AppDimens.dimen20,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  final otpSentStyle = TextStyle(
    color: AppColors.textColor1,
    fontSize: AppDimens.dimen20,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  final buttonTextStyle = TextStyle(
    color: AppColors.scaffoldBackgroundColor,
    fontSize: AppDimens.dimen20,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}

// Custom Painter for Dashed Line
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    double dashWidth = 5, dashSpace = 3, startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
