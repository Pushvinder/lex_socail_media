import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';

class ForgotPassController extends GetxController {
  final emailController = TextEditingController();

  Future<void> forgotPass(formKey) async {
    try {
      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      // Validate
      final isValid = formKey.currentState?.validate() ?? false;

      _triggerExternalValidation();

      if (!isValid) {
        Get.snackbar(
          ErrorMessages.validationError,
          ErrorMessages.invalidEmail,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      AppLoader.show();
      await _sendOtp();
      AppLoader.hide();

      String email = emailController.text;
      formKey.currentState?.reset();
      clearData();

      Get.to(
        () => VerifyOTPScreen(
          screen: 'forgot',
          email: email,
        ),
      );
    } catch (e) {
      Get.snackbar(
        ErrorMessages.validationError,
        ErrorMessages.invalidEmail,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        colorText: AppColors.whiteColor,
        margin: const EdgeInsets.all(15),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // forget password api
  Future<void> _sendOtp() async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.email: emailController.text.trim(),
      }, endPoint: ApiUtils.forgetPassowrd);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
    } catch (e) {
      AppLoader.hide();
      debugPrint('error forgot api ${e.toString()}');
    }
  }

  // --- Helper to manually update external error messages on submit ---
  void _triggerExternalValidation() {
    _updateExternalValidationForField(
        AppStrings.emailAddress, emailController.text);
  }

  void _updateExternalValidationForField(String tag, String currentValue) {
    try {
      if (Get.isRegistered<TextFieldController>(tag: tag)) {
        final fieldCtrl = Get.find<TextFieldController>(tag: tag);
      }
    } catch (e) {
      print("Error finding/updating TextFieldController for tag '$tag': $e");
    }
  }

  void clearData() {
    emailController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
