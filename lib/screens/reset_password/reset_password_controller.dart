import '../../../config/app_config.dart';

class ResetPasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? currentPasswordValidator(String? value) =>
      AppValidation.password(value);
  String? newPasswordValidator(String? value) => AppValidation.password(value);
  String? confirmPasswordValidator(String? value) =>
      AppValidation.confirmPassword(value, newPasswordController.text);

  void changePassword(GlobalKey<FormState> formKey) {
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

    // Password Change Success
    Get.snackbar(
      AppStrings.success,
      'Password has been reset successfully.',
      snackPosition: SnackPosition.BOTTOM,
      colorText: AppColors.whiteColor,
      backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    );

    // Clear fields
    formKey.currentState?.reset();
    clearData();
    Get.back();
  }

  void _triggerExternalValidation() {
    _updateExternalValidationForField(AppStrings.currentPassword,
        currentPasswordController.text, currentPasswordValidator);
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
      // ignore
    }
  }

  void clearData() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _clearExternalValidationMessages();
  }

  void _clearExternalValidationMessages() {
    final tags = [
      AppStrings.currentPassword,
      AppStrings.newPassword,
      AppStrings.confirmNewPassword
    ];
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
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
