import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/screens/home/home_screen.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/utils/app_console_log_functions.dart';
import '../notifications/firebase/firebase_notification_handler.dart';
import '../onboarding/onboarding_screen.dart';

class SplashController extends GetxController {
  // Observable FCM token
  final fcmToken = RxnString();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Get stored FCM token
    final storedToken = StorageHelper().getFcmToken;
    if (storedToken.isNotEmpty) {
      fcmToken.value = storedToken;
    }

    // Listen for token refresh
    _listenForTokenRefresh();

    // Check login status and navigate
    await checkData();
  }

  void _listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      logDebug("FCM Token refreshed: $newToken");
      fcmToken.value = newToken;
      StorageHelper().setFcmToken = newToken;

      // If user is logged in, update token in Firestore
      if (StorageHelper().isLoggedIn) {
        final email = StorageHelper().getUserEmail;
        if (email.isNotEmpty) {
          FirebaseNotificationHandler.registerUserDeviceToFirebase(
            email: email,
          );
        }
      }
    });
  }

  Future<void> checkData() async {
    // Add slight delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 2));

    bool isLoggedIn = StorageHelper().isLoggedIn;

    if (isLoggedIn) {
      // User is logged in - register device token if available
      final email = StorageHelper().getUserEmail;

      if (email.isNotEmpty && fcmToken.value != null) {
        await FirebaseNotificationHandler.registerUserDeviceToFirebase(
          email: email,
        );
      }

      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }
}