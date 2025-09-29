import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/main.dart';
import 'package:the_friendz_zone/screens/auth/login_screen/models/login_response.dart';
import 'package:the_friendz_zone/screens/auth/login_screen/models/social_login_response.dart';
import 'package:the_friendz_zone/utils/app_const.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';
import '../../home/home_screen.dart';


const List<String> scopes = <String>[
  'email',
  'profile',
];

const String android = 'android';
const String ios = 'ios';
const String apple = 'apple';
const String google = 'google';
const String phone = 'phone';

class LoginController extends GetxController {
  // Input Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Validators WITH AppValidation
  String? emailValidator(String? value) => AppValidation.email(value);
  String? passwordValidator(String? value) => AppValidation.password(value);



/// firebase login variables
 final GoogleSignIn googleSignIn = GoogleSignIn.instance;
   final FirebaseAuth auth = FirebaseAuth.instance;



  Future<void> login(GlobalKey<FormState> formKey) async {
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

    AppLoader.show(); // ✅ Show loader only once

    try {
      final loginResponse = await _loginUser(); // await result

      AppLoader.hide(); // ✅ Hide loader before navigation or error dialog

      // checking if api hit was success or not
      if (loginResponse != null &&
          loginResponse.status == AppStrings.apiSuccess) {
        print('Token set in headers: Bearer 1 ${loginResponse.data?.token ?? ''}');
        StorageHelper().setAuthToken = loginResponse.data?.token ?? '';
        StorageHelper().isLoggedIn = true;

        StorageHelper().setUserId = loginResponse.data?.userId ?? -1;

        formKey.currentState?.reset();
        clearData();
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar(
          ErrorMessages.error,
          loginResponse?.message ?? 'Invalid email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      AppLoader.hide(); // ✅ ensure loader is hidden
      debugPrint('Login failed: $e');
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



  Future<void> loginWithGoogle() async {
    AppLoader.show();
    try {
      final googleUser = await googleSignIn.authenticate();
      if (googleUser != null) {
        await _handleGoogleSignIn(googleUser);
      } else {
        _handleSignInError();
      }
    } catch (error) {
      _handleSignInError();
    }
  }


  Future<void> _handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =  googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    try {
      final userCredential = await auth.signInWithCredential(credential);
      if (userCredential.user != null) {
       SocailLoginResponse? loginResponse = await _socialLogin(AppStrings.google, googleUser.email, googleUser.displayName ?? '');

          // checking if api hit was success or not
      if (loginResponse != null &&
          loginResponse.status == AppStrings.apiSuccess) {
        StorageHelper().setAuthToken = loginResponse.jwt ?? '';
        StorageHelper().isLoggedIn = true;

        StorageHelper().setUserId = loginResponse.userId ?? -1;
        if(loginResponse.userFlag ?? true) {

        }else {
        Get.offAll(() => HomeScreen());

        }
      } else {
        Get.snackbar(
          ErrorMessages.error,
          loginResponse?.message ?? 'Invalid email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      }
        // dName = userCredential.user?.displayName ?? '';
        // email = userCredential.user?.email;
        // await getDeviceToken(
        //     isLogin: !userCredential.additionalUserInfo!.isNewUser);
      } else {
        _handleSignInError();
      }
    } catch (error) {
      _handleSignInError();
    }
  }

  Future<void> loginWithApple() async {
    AppLoader.show();
    final rawNonce = generateNonce();
   

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],

      );

      await _signInWithAppleCredential(appleCredential, rawNonce);
    } catch (error) {
      _handleSignInError();
    }
  }

  Future<void> _signInWithAppleCredential(
      AuthorizationCredentialAppleID appleCredential, String rawNonce) async {
    final credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      // rawNonce: Platform.isIOS ? rawNonce : null,
      // accessToken: Platform.isIOS ? null : appleCredential.authorizationCode,
    );

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      SocailLoginResponse? loginResponse = await _socialLogin(AppStrings.google, appleCredential.email ?? '', ((appleCredential.givenName ?? "") + (appleCredential.familyName??'')));


          // checking if api hit was success or not
      if (loginResponse != null &&
          loginResponse.status == AppStrings.apiSuccess) {
        StorageHelper().setAuthToken = loginResponse.jwt ?? '';
        StorageHelper().isLoggedIn = true;

        StorageHelper().setUserId = loginResponse.userId ?? -1;
        if(loginResponse.userFlag ?? true) {

        }else {
        Get.offAll(() => HomeScreen());

        }
      } else {
        Get.snackbar(
          ErrorMessages.error,
          loginResponse?.message ?? 'Invalid email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (error) {
      _handleSignInError();
    }
  }

  void _handleSignInError() {
    AppLoader.hide();
    AppDialogs.errorSnackBar(ErrorMessages.somethingWrong);
  }




  // login user for form and manually entering details
  Future<LoginResponse?> _loginUser() async {
    try {
      final response = await ApiManager.callPostWithFormData(body: {
        ApiParam.email: emailController.text.trim(),
        ApiParam.password: passwordController.text.trim()
      }, endPoint: ApiUtils.login);

      LoginResponse loginResponse = LoginResponse.fromJson(response);

      // returning reponse be it either success or failure
      return loginResponse;
    } catch (e) {
      debugPrint('Error in loginUser: $e');
      return null;
    }
  }

  // login user for form and manually entering details
  Future<SocailLoginResponse?> _socialLogin(String loginType,String email,String fullname) async {
    try {
      final response = await ApiManager.callPostWithFormData(body: {
        ApiParam.email: email,
        ApiParam.fullname: fullname
      }, endPoint: ApiUtils.socialLogin);

      SocailLoginResponse loginResponse = SocailLoginResponse.fromJson(response);

      // returning reponse be it either success or failure
      return loginResponse;
    } catch (e) {
      debugPrint('Error in social loginUser: $e');
return null;
    }
  }

  /// Triggers external validation for each field, so external error message widgets update
  void _triggerExternalValidation() {
    _updateExternalValidationForField(
        AppStrings.emailAddress, emailController.text, emailValidator);
    _updateExternalValidationForField(
        AppStrings.password, passwordController.text, passwordValidator);
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

  // clear all data and external messages
  void clearData() {
    emailController.clear();
    passwordController.clear();
    _clearExternalValidationMessages();
  }

  void _clearExternalValidationMessages() {
    final tags = [AppStrings.emailAddress, AppStrings.password];
    for (var tag in tags) {
      try {
        if (Get.isRegistered<TextFieldController>(tag: tag)) {
          Get.find<TextFieldController>(tag: tag).setValidationMessage(null);
        }
      } catch (e) {
        print("Error finding/clearing TextFieldController for tag '$tag': $e");
      }
    }
  }

  @override
  void onClose() {
    clearData();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
