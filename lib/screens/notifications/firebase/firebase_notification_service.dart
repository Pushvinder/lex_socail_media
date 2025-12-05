// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import '../../../utils/app_console_log_functions.dart';
// import '../../../utils/app_push_notifications.dart';
// import 'local_notification_service.dart';
//
// class FirebaseNotificationService {
//   static void initialize(BuildContext context) {
//     // Request permission to show notifications (can be called on both iOS and Android)
//     FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     // Subscribe to a topic
//     FirebaseMessaging.instance
//         .subscribeToTopic(AppPushNotifications.notificationTopic);
//
//     // Initialize the local notification service
//     LocalNotificationService.initialize(context);
//     // AwesomeNotificationService.initialize(context);
//
//     // Handle when the app is in the background and closed and the user taps on the notification
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         logDebug("Handling initial message: ${message.messageId}");
//
//         // ✅ Navigate after a short delay to ensure app is ready
//         Future.delayed(const Duration(milliseconds: 500), () {
//           LocalNotificationService.onTapNotification(
//             payload: jsonEncode(message.data),
//             context: context,
//           );
//         });
//       }
//     });
//
//     // Handle when the app is in the foreground (or user currenlty using the app) and the user taps on the notification
//     FirebaseMessaging.onMessage.listen(
//       (message) {
//         if (WidgetsBinding.instance.lifecycleState ==
//             AppLifecycleState.resumed) {
//           if (Platform.isAndroid) {
//             LocalNotificationService.display(
//               title: message.notification!.title!,
//               body: message.notification!.body!,
//               payload: jsonEncode(
//                   message.data), // Encode the data map to a JSON string
//             );
//             // AwesomeNotificationService.display(
//             //   title: message.notification!.title!,
//             //   body: message.notification!.body!,
//             //   payload: message.data,
//             // );
//           }
//           logDebug(
//               "Handling foreground opened app message: ${message.notification!.title}");
//         }
//       },
//     );
//     // Handle when the app is in the foreground
//     FirebaseMessaging.onMessage.listen(
//       (message) {
//         if (WidgetsBinding.instance.lifecycleState ==
//             AppLifecycleState.resumed) {
//           // ✅ Show notification for both Android and iOS
//           if (message.notification != null) {
//             LocalNotificationService.display(
//               title: message.notification!.title ?? 'Notification',
//               body: message.notification!.body ?? '',
//               payload: jsonEncode(message.data),
//             );
//           }
//
//           logDebug(
//               "Handling foreground opened app message: ${message.notification?.title}");
//         }
//       },
//     );
//
//     // Handle when the app is in the background but opened and the user taps on the notification
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (message) {
//         LocalNotificationService.onTapNotification(
//           payload: jsonEncode(message.data),
//           context: context,
//         );
//
//         logDebug(
//             "Handling background opened app message: ${message.notification?.title ?? 'No title'}"); // ✅ Added null safety
//       },
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_console_log_functions.dart';
import '../../../utils/app_push_notifications.dart';
import 'local_notification_service.dart';

class FirebaseNotificationService {
  static void initialize(BuildContext context) {
    // Request permission to show notifications
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Subscribe to a topic
    FirebaseMessaging.instance
        .subscribeToTopic(AppPushNotifications.notificationTopic);

    // Initialize the local notification service
    LocalNotificationService.initialize(context);

    // Handle when the app is in the background/terminated and user taps notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        logDebug("Handling initial message: ${message.messageId}");

        // ✅ Log the complete message for debugging
        logJSON(message: "Initial Message Data:", object: message.data);
        logJSON(message: "Initial Message Notification:", object: {
          'title': message.notification?.title,
          'body': message.notification?.body,
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          LocalNotificationService.onTapNotification(
            payload: jsonEncode(message.data),
            context: context,
          );
        });
      }
    });

    // Handle when app is in FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // ✅ Log complete message for debugging
      logDebug("=== FOREGROUND MESSAGE RECEIVED ===");
      logJSON(message: "Message Data:", object: message.data);
      logJSON(message: "Message Notification:", object: {
        'title': message.notification?.title,
        'body': message.notification?.body,
      });
      logDebug("=================================");

      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        // ✅ Show notification with data
        if (message.notification != null) {
          LocalNotificationService.display(
            title: message.notification!.title ?? 'Notification',
            body: message.notification!.body ?? '',
            payload: jsonEncode(message.data), // ✅ This is where data should be
          );
        }

        logDebug("Handling foreground opened app message: ${message.notification?.title}");
      }
    });

    // Handle when app is in BACKGROUND and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ✅ Log complete message for debugging
      logDebug("=== BACKGROUND MESSAGE OPENED ===");
      logJSON(message: "Message Data:", object: message.data);
      logJSON(message: "Message Notification:", object: {
        'title': message.notification?.title,
        'body': message.notification?.body,
      });
      logDebug("=================================");

      LocalNotificationService.onTapNotification(
        payload: jsonEncode(message.data),
        context: context,
      );

      logDebug("Handling background opened app message: ${message.notification?.title ?? 'No title'}");
    });
  }
}