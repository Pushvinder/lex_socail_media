// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/main.dart';
// import 'package:the_friendz_zone/models/register_response.dart';
// import 'package:the_friendz_zone/utils/app_loader.dart';
//
// import '../../../config/app_config.dart';
//
// class RegisterController extends GetxController {
//   // Input Controllers
//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//
//   // Validators WITH AppValidation only!
//   String? fullNameValidator(String? value) => AppValidation.fullName(value);
//
//   String? emailValidator(String? value) => AppValidation.email(value);
//
//   String? passwordValidator(String? value) => AppValidation.password(value);
//
//   String? confirmPasswordValidator(String? value) =>
//       AppValidation.confirmPassword(
//         value,
//         passwordController.text,
//       );
//
//   void register(GlobalKey<FormState> formKey) async {
//     try {
//       // Dismiss keyboard
//       FocusManager.instance.primaryFocus?.unfocus();
//
//       final isValid = formKey.currentState?.validate() ?? false;
//       _triggerExternalValidation();
//
//       if (!isValid) {
//         Get.snackbar(
//           'Validation Error',
//           'Please fill in all required fields.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//         return;
//       }
//
//       // --- Validation Passed ---
//
//       String email = emailController.text;
//       AppLoader.show();
//
//       RegisterResponse? registerResponse = await _registerUser();
//       AppLoader.hide(); // ✅ Hide loader before navigation or error dialog
//
//       // checking if api hit was success or not
//       if (registerResponse != null &&
//           registerResponse.status == AppStrings.apiSuccess) {
//         StorageHelper().setAuthToken = registerResponse.jwt ?? '';
//         StorageHelper().isLoggedIn = true;
//
//         StorageHelper().setUserId = registerResponse.userId ?? -1;
//         formKey.currentState?.reset();
//         clearData();
//
//         Get.to(
//           () => VerifyOTPScreen(
//             screen: 'register',
//             email: email,
//           ),
//           preventDuplicates: false,
//         );
//       } else {
//         Get.snackbar(
//           ErrorMessages.error,
//           registerResponse?.message ?? 'Invalid email or password.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//       }
//     } catch (e) {
//       AppLoader.hide(); // ✅ ensure loader is hidden
//       Get.snackbar(
//         ErrorMessages.error,
//         ErrorMessages.somethingWrong,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//         borderRadius: 8,
//       );
//     }
//   }
//
//   // register api
//   Future<RegisterResponse?> _registerUser() async {
//     try {
//       var result = await ApiManager.callPostWithFormData(body: {
//         ApiParam.fullname: fullNameController.text.trim(),
//         ApiParam.email: emailController.text.trim(),
//         ApiParam.password: passwordController.text.trim()
//       }, endPoint: ApiUtils.register);
//
//       RegisterResponse registerResponse = RegisterResponse.fromJson(result);
//       return registerResponse;
//     } catch (e) {
//       AppLoader.hide();
//
//       debugPrint('error register api ${e.toString()}');
//     }
//   }
//
//   void _triggerExternalValidation() {
//     _updateExternalValidationForField(
//         AppStrings.fullName, fullNameController.text, fullNameValidator);
//     _updateExternalValidationForField(
//         AppStrings.emailAddress, emailController.text, emailValidator);
//     _updateExternalValidationForField(
//         AppStrings.password, passwordController.text, passwordValidator);
//     _updateExternalValidationForField(AppStrings.confirmPassword,
//         confirmPasswordController.text, confirmPasswordValidator);
//   }
//
//   void _updateExternalValidationForField(
//     String tag,
//     String currentValue,
//     String? Function(String?) validator,
//   ) {
//     try {
//       if (Get.isRegistered<TextFieldController>(tag: tag)) {
//         final fieldCtrl = Get.find<TextFieldController>(tag: tag);
//         final errorMsg = validator(currentValue);
//         fieldCtrl.setValidationMessage(errorMsg);
//       }
//     } catch (e) {
//       print("Error finding/updating TextFieldController for tag '$tag': $e");
//     }
//   }
//
//   void clearData() {
//     fullNameController.clear();
//     emailController.clear();
//     passwordController.clear();
//     confirmPasswordController.clear();
//     _clearExternalValidationMessages();
//   }
//
//   void _clearExternalValidationMessages() {
//     final tags = [
//       AppStrings.fullName,
//       AppStrings.emailAddress,
//       AppStrings.password,
//       AppStrings.confirmPassword
//     ];
//     for (var tag in tags) {
//       try {
//         if (Get.isRegistered<TextFieldController>(tag: tag)) {
//           Get.find<TextFieldController>(tag: tag).setValidationMessage(null);
//         }
//       } catch (e) {/* ignore */}
//     }
//   }
//
//   @override
//   void onClose() {
//     clearData();
//     emailController.dispose();
//     passwordController.dispose();
//     fullNameController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
// }
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/main.dart';
import 'package:the_friendz_zone/models/register_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';
import 'package:the_friendz_zone/utils/app_console_log_functions.dart';
import '../../../config/app_config.dart';
import '../../notifications/firebase/firebase_notification_handler.dart';

class RegisterController extends GetxController {
  // Input Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Validators WITH AppValidation only!
  String? fullNameValidator(String? value) => AppValidation.fullName(value);
  String? emailValidator(String? value) => AppValidation.email(value);
  String? passwordValidator(String? value) => AppValidation.password(value);
  String? confirmPasswordValidator(String? value) =>
      AppValidation.confirmPassword(value, passwordController.text);

  void register(GlobalKey<FormState> formKey) async {
    try {
      // Dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      final isValid = formKey.currentState?.validate() ?? false;
      _triggerExternalValidation();

      if (!isValid) {
        Get.snackbar(
          'Validation Error',
          'Please fill in all required fields.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // --- Validation Passed ---

      String email = emailController.text.trim();
      AppLoader.show();

      RegisterResponse? registerResponse = await _registerUser();
      AppLoader.hide();

      // checking if api hit was success or not
      if (registerResponse != null &&
          registerResponse.status == AppStrings.apiSuccess) {

        // ✅ Store user data
        StorageHelper().setAuthToken = registerResponse.jwt ?? '';
        StorageHelper().isLoggedIn = true;
        StorageHelper().setUserId = registerResponse.userId ?? -1;
        StorageHelper().setUserEmail = email;

        // ✅ Register FCM token to Firestore
        await FirebaseNotificationHandler.registerUserDeviceToFirebase(
          email: email,
        );

        formKey.currentState?.reset();
        clearData();

        Get.to(
              () => VerifyOTPScreen(
            screen: 'register',
            email: email,
          ),
          preventDuplicates: false,
        );
      } else {
        Get.snackbar(
          ErrorMessages.error,
          registerResponse?.message ?? 'Registration failed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      AppLoader.hide();
      logError('Registration error: $e');
      Get.snackbar(
        ErrorMessages.error,
        ErrorMessages.somethingWrong,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        colorText: AppColors.whiteColor,
        margin: const EdgeInsets.all(15),
        borderRadius: 8,
      );
    }
  }

  // register api
  Future<RegisterResponse?> _registerUser() async {
    try {
      // ✅ Get FCM token from storage
      final fcmToken = StorageHelper().getFcmToken;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.fullname: fullNameController.text.trim(),
          ApiParam.email: emailController.text.trim(),
          ApiParam.password: passwordController.text.trim(),
          ApiParam.fcmToken: fcmToken, // ✅ Send FCM token to backend
        },
        endPoint: ApiUtils.register,
      );

      RegisterResponse registerResponse = RegisterResponse.fromJson(result);
      return registerResponse;
    } catch (e) {
      AppLoader.hide();
      debugPrint('error register api ${e.toString()}');
      return null;
    }
  }

  void _triggerExternalValidation() {
    _updateExternalValidationForField(
        AppStrings.fullName, fullNameController.text, fullNameValidator);
    _updateExternalValidationForField(
        AppStrings.emailAddress, emailController.text, emailValidator);
    _updateExternalValidationForField(
        AppStrings.password, passwordController.text, passwordValidator);
    _updateExternalValidationForField(AppStrings.confirmPassword,
        confirmPasswordController.text, confirmPasswordValidator);
  }

  void _updateExternalValidationForField(
      String tag,
      String currentValue,
      String? Function(String?) validator,
      ) {
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
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _clearExternalValidationMessages();
  }

  void _clearExternalValidationMessages() {
    final tags = [
      AppStrings.fullName,
      AppStrings.emailAddress,
      AppStrings.password,
      AppStrings.confirmPassword
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
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}