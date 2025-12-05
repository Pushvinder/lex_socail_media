import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/utils/app_console_log_functions.dart';
import '../notifications/firebase/firebase_notification_service.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Initialize here when context is ready
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize Firebase Notification Service
      FirebaseNotificationService.initialize(context);

      // Request notification permission
      await _requestNotificationPermission();

      // Get and store FCM token
      await _getFcmToken();
    } catch (e) {
      logError('Error initializing app: $e');
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        logInfo("Notification permission granted");
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        logInfo("Provisional notification permission granted");
      } else {
        logInfo("Notification permission denied");
      }
    } catch (e) {
      logError('Error requesting notification permission: $e');
    }
  }

  Future<void> _getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        logDebug("FCM TOKEN: $token");

        // Store token in local storage
        StorageHelper().setFcmToken = token;

        // Also set in controller for immediate access
        if (Get.isRegistered<SplashController>()) {
          Get.find<SplashController>().fcmToken.value = token;
        }
      } else {
        logError("FCM Token is null");
      }
    } catch (e) {
      logError('Error getting FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logo,
              height: AppDimens.dimen350,
              width: AppDimens.dimen350,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.splashTextColor,
                fontSize: FontDimen.dimen24,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.appFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
