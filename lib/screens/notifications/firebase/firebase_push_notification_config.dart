import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../utils/app_console_log_functions.dart';
import '../../../utils/app_push_notifications.dart';

class FirebasePushNotificationConfig {
  static Future<void> configureNotifications() async {
    // Create Android notification channel if the current platform is Android
    await _createAndroidNotificationChannel(
      AppPushNotifications.flutterLocalNotificationsPlugin,
      AppPushNotifications.channel,
    );

    // Configures how foreground push notifications are presented to the user.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up a background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _createAndroidNotificationChannel(
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  AndroidNotificationChannel channel,
) async {
  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

// ✅ This handler runs in a separate isolate
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logDebug('Handling a background message: ${message.messageId}');

  // ✅ Handle notification data when app is in background/terminated
  if (message.data['type'] != null) {
    logInfo("Background notification type: ${message.data['type']}");

    // You can save data locally or show notification
    // The actual navigation will happen when user taps notification
  }
}
