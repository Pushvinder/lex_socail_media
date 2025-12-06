import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../utils/app_console_log_functions.dart';

class FirebaseNotificationHandler {
  // ✅ Store by both email AND user ID
  static Future<void> registerUserDeviceToFirebase({
    required String email,
    String? userId, // ✅ Add optional userId parameter
  }) async {
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      // Store by email (for backward compatibility)
      final Map<String, dynamic> emailData = {
        "token": token,
        "email": email.toLowerCase(),
        "userId": userId, // ✅ Store userId with email doc
        "updatedAt": FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance
          .collection("tokens")
          .doc(email.toLowerCase())
          .set(emailData, SetOptions(merge: true));

      // ✅ Also store by userId if provided (better for calls)
      if (userId != null && userId.isNotEmpty) {
        final Map<String, dynamic> userIdData = {
          "token": token,
          "email": email.toLowerCase(),
          "userId": userId,
          "updatedAt": FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance
            .collection("user_tokens") // ✅ Separate collection for userId lookup
            .doc(userId)
            .set(userIdData, SetOptions(merge: true));

        logDebug("Device Firebase Token stored for User ID: $userId");
      }

      logDebug("Device Firebase Token: $token");
    } else {
      logError("Unable to get device token.");
    }
  }

  // ✅ Get token by email (existing)
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

  // ✅ NEW: Get token by user ID (for calls)
  static Future<String?> getFirebaseTokenByUserId({required String userId}) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection("user_tokens")
        .doc(userId)
        .get();

    if (documentSnapshot.exists) {
      final token = documentSnapshot.data()?["token"];
      logDebug("Firebase Token retrieved for User ID: $userId");
      return token;
    } else {
      logError("No Firebase Token found for User ID: $userId");
      return null;
    }
  }

  static Future<void> removeFirebaseToken({
    required String email,
    String? userId,
  }) async {
    await FirebaseMessaging.instance.deleteToken();

    // Remove email-based token
    await FirebaseFirestore.instance
        .collection("tokens")
        .doc(email.toLowerCase())
        .delete();

    // ✅ Remove userId-based token
    if (userId != null && userId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("user_tokens")
          .doc(userId)
          .delete();
    }

    logSuccess("Firebase Token removed for $email");
  }

  // Enable or disable notifications based on the state of the switch
  static void toggleNotifications({
    required bool isNotificationEnabled,
    required String email,
    String? userId,
  }) {
    if (isNotificationEnabled) {
      // Enable notifications
      FirebaseNotificationHandler.registerUserDeviceToFirebase(
        email: email,
        userId: userId,
      );
      logInfo("Notifications Enabled");
    } else {
      // Disable notifications
      FirebaseNotificationHandler.removeFirebaseToken(
        email: email,
        userId: userId,
      );
      logInfo("Notifications Disabled");
    }
  }
}