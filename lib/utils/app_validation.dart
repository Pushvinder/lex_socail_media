import 'app_strings.dart';

class AppValidation {
  static const String passwordMinStrengthRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$';
  static const String emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*(\.[a-zA-Z]{2,})?)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static String? checkEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldIsRequired;
    }
    return null;
  }

  static String? email(String? value) {
    if (checkEmpty(value) != null) {
      return AppStrings.pleaseEnterYourEmail;
    }
    if (!RegExp(emailRegex).hasMatch(value!)) {
      return AppStrings.enterValidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (checkEmpty(value) != null) {
      return AppStrings.pleaseEnterYourPassword;
    }
    if (!RegExp(passwordMinStrengthRegex).hasMatch(value!)) {
      return AppStrings.passwordValidationMessage;
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (checkEmpty(value) != null) {
      return AppStrings.pleaseConfirmYourPassword;
    }
    if (value != password) {
      return AppStrings.passwordMismatchError;
    }
    return null;
  }

  static String? fullName(String? value) {
    if (checkEmpty(value) != null) {
      return AppStrings.pleaseEnterYourFullName;
    }
    return null;
  }
}
