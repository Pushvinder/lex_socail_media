import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';

class ResetPassController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Validators with AppValidation
  String? newPasswordValidator(String? value) => AppValidation.password(value);

  String? confirmPasswordValidator(String? value) =>
      AppValidation.confirmPassword(
        value,
        newPasswordController.text,
      );

  Future<void> resetPassword(GlobalKey<FormState> formKey, String email) async {
    try {
      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      final isValid = formKey.currentState?.validate() ?? false;
      _triggerExternalValidation();

      if (!isValid) {
        Get.snackbar(
          AppStrings.validationError,
          AppStrings.pleaseFillRequiredFields,
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColors.whiteColor,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          animationDuration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }
      AppLoader.show();
      VerifyOtpResponse? response = await _resetPassword(email);
      AppLoader.hide();
      debugPrint('response === $response');

      if (response != null && response.status == AppStrings.apiSuccess) {
        // Password Reset Success
        Get.snackbar(
          AppStrings.success,
          AppStrings.resetPasswordSuccess,
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColors.whiteColor,
          backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
          animationDuration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );

        // Clear the fields after success
        formKey.currentState?.reset();
        clearData();

        Get.offAll(() => LoginScreen());
      } else {
        Get.snackbar(
          ErrorMessages.error,
          response?.message ?? ErrorMessages.passwordResetError,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          animationDuration: const Duration(milliseconds: 500),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      AppLoader.hide();
      Get.snackbar(
        ErrorMessages.error,
        ErrorMessages.passwordResetError,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        animationDuration: const Duration(milliseconds: 500),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
    }
  }

  // reset password
  Future<VerifyOtpResponse?> _resetPassword(String email) async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.email: email.trim(),
        ApiParam.password: newPasswordController.text.trim(),
        ApiParam.confirmPassword: confirmPasswordController.text.trim()
      }, endPoint: ApiUtils.resetPassword);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
      return response;
    } catch (e) {
      AppLoader.hide();
      debugPrint('error verify otp api ${e.toString()}');
    }
  }

  void _triggerExternalValidation() {
    _updateExternalValidationForField(AppStrings.newPassword,
        newPasswordController.text, newPasswordValidator);
    _updateExternalValidationForField(AppStrings.confirmNewPassword,
        confirmPasswordController.text, confirmPasswordValidator);
  }

  void _updateExternalValidationForField(
      String tag, String currentValue, String? Function(String?) validator) {
    try {
      if (Get.isRegistered<TextFieldController>(tag: tag)) {
        final fieldCtrl = Get.find<TextFieldController>(tag: tag);
        final errorMsg = validator(currentValue);
        fieldCtrl.setValidationMessage(errorMsg);
      }
    } catch (e) {
      print("Error finding/updating TextFieldController for tag '$tag': $e");
    }
  }

  void clearData() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    _clearExternalValidationMessages();
  }

  void _clearExternalValidationMessages() {
    final tags = [AppStrings.newPassword, AppStrings.confirmNewPassword];
    for (var tag in tags) {
      try {
        if (Get.isRegistered<TextFieldController>(tag: tag)) {
          Get.find<TextFieldController>(tag: tag).setValidationMessage(null);
        }
      } catch (e) {/* ignore */}
    }
  }

  @override
  void onClose() {
    clearData();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
