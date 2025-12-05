import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../utils/app_console_log_functions.dart';

class FirebaseNotificationHandler {
  static Future<void> registerUserDeviceToFirebase({
    required String email,
  }) async {
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      // Store the user device token in Firestore.
      final Map<String, dynamic> data = {
        "token": token,
        "email": email.toLowerCase(), // Normalize email
        "updatedAt": FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance
          .collection("tokens")
          .doc(email.toLowerCase())
          .set(data, SetOptions(merge: true));
      logDebug("Device Firebase Token: $token");
    } else {
      logError("Unable to get device token.");
    }
  }

  static Future<String?> getFirebaseToken({required String email}) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection("tokens")
        .doc(email.toLowerCase())
        .get();

    if (documentSnapshot.exists) {
      final token = documentSnapshot.data()?["token"];
      logDebug("Firebase Token retrieved for $email");
      return token;
    } else {
      logError("No Firebase Token found for $email");
      return null;
    }
  }

  static Future<void> removeFirebaseToken({required String email}) async {
    await FirebaseMessaging.instance.deleteToken();
    await FirebaseFirestore.instance
        .collection("tokens")
        .doc(email.toLowerCase())
        .delete();
    logSuccess("Firebase Token removed for $email");
  }

  // Enable or disable notifications based on the state of the switch
  static void toggleNotifications({
    required bool isNotificationEnabled,
    required String email,
  }) {
    if (isNotificationEnabled) {
      // Enable notifications
      FirebaseNotificationHandler.registerUserDeviceToFirebase(
        email: email,
      );
      logInfo("Notifications Enabled");
    } else {
      // Disable notifications
      FirebaseNotificationHandler.removeFirebaseToken(
        email: email,
      );
      logInfo("Notifications Disabled");
    }
  }

  // Clear notification badge
  // static Future<void> clearNotificationBadge() async {
  //   try {
  //     await FirebaseMessaging.instance.setApplicationBadgeCount(0);
  //     logDebug("Notification badge cleared");
  //   } catch (e) {
  //     logError("Error clearing notification badge: $e");
  //   }
  // }
}