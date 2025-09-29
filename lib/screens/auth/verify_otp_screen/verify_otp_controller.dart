import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';
import '../../profile_creation/profile_info/profile_info_screen.dart';

class VerifyOTPController extends GetxController {
  var otpControllers = List.generate(5, (_) => TextEditingController()).obs;
  var focusNodes = List.generate(5, (_) => FocusNode()).obs;

  // === TIMER STATE ===
  RxInt secondsLeft = 45.obs;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void _restartTimer() {
    _startTimer();
  }

  Future<void> verifyOtp(
      {String screen = 'forgot', required String email}) async {
    try {
      String otp = otpControllers.fold(
        '',
        (previousValue, controller) => previousValue + controller.text,
      );
      if (otp.length == 5) {
        AppLoader.show();
        await _verifyOtp(email, otp);
        AppLoader.hide();
        Get.snackbar(
          AppStrings.success,
          AppStrings.otpSuccess,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
          animationDuration: const Duration(milliseconds: 500),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        if (screen == 'forgot') {
          Get.to(
            () => ResetPassScreen(
              email: email,
            ),
          );
        } else {
          Get.to(() => const ProfileInfoScreen());
        }
      } else {
        Get.snackbar(
          ErrorMessages.error,
          ErrorMessages.incompleteOtp,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          animationDuration: const Duration(milliseconds: 500),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
      }
    } catch (e) {
      Get.snackbar(
        ErrorMessages.error,
        ErrorMessages.somethingWrong,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        animationDuration: const Duration(milliseconds: 500),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  // on send again button click
  Future<void> sendOtpAgain(String email) async {
    try {
      AppLoader.show();
      await _resendOtp(email);
      _restartTimer();
      AppLoader.hide();

      Get.snackbar(
        AppStrings.success,
        AppStrings.otpResent,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.greenColor,
        animationDuration: const Duration(milliseconds: 500),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
    } catch (e) {
      AppLoader.hide();
      Get.snackbar(
        ErrorMessages.error,
        ErrorMessages.resentOtp,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        animationDuration: const Duration(milliseconds: 500),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
    }
  }

  // verify otp api
  Future<VerifyOtpResponse?> _verifyOtp(String email, String otp) async {
    try {
      var result = await ApiManager.callPostWithFormData(
          body: {ApiParam.email: email.trim(), 'otp': otp.trim()},
          endPoint: ApiUtils.verifyOtp);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
    } catch (e) {
      AppLoader.hide();
      debugPrint('error verify otp api ${e.toString()}');
    }
  }

  // resend otp api
  Future<void> _resendOtp(String email) async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.email: email.trim(),
      }, endPoint: ApiUtils.resendOtp);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
    } catch (e) {
      AppLoader.hide();
      debugPrint('error verify otp api ${e.toString()}');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }
}
