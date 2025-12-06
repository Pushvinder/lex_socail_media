// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import '../../../utils/app_console_log_functions.dart';
// import '../../../utils/app_enums.dart';
// import '../../../utils/app_push_notifications.dart';
// import '../../../utils/app_string_functions.dart';
// import '../../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
// import '../../home/home_screen.dart';
// import '../../message/chat_screen.dart';
// // Import other screens as needed
// // import '../../profile/profile_screen.dart';
// // import '../../friends/friend_requests_screen.dart';
// // import '../../posts/post_detail_screen.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static Future<void> initialize(BuildContext context) async {
//     try {
//       if (Platform.isIOS) {
//         await notificationsPlugin
//             .resolvePlatformSpecificImplementation<
//                 IOSFlutterLocalNotificationsPlugin>()
//             ?.requestPermissions(
//               alert: true,
//               badge: true,
//               sound: true,
//             );
//       }
//
//       const InitializationSettings initializationSettings =
//           InitializationSettings(
//         android: AndroidInitializationSettings(AppPushNotifications.appIcon),
//         iOS: DarwinInitializationSettings(
//           requestSoundPermission: true,
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//         ),
//       );
//
//       await notificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse response) async {
//           // Handle notification tap when app is in foreground
//           onTapNotification(payload: response.payload, context: context);
//         },
//       );
//     } catch (e) {
//       logError('Error initializing local notifications: $e');
//     }
//   }
//
//   static void onTapNotification({
//     required String? payload,
//     required BuildContext context,
//   }) {
//     if (payload == null || payload.isEmpty) {
//       logWarning("Notification payload is null or empty");
//       return;
//     }
//
//     try {
//       Map<String, dynamic> data = jsonDecode(payload);
//       logInfo("onSelectNotification: $payload");
//
//       // Get notification type from payload
//       final typeString = data['type'] as String?;
//       if (typeString == null) {
//         logWarning("Notification type is null");
//         Get.offAll(() => const HomeScreen());
//         return;
//       }
//
//       final notificationType = NotificationTypeExtension.fromString(typeString);
//
//       // Navigate based on notification type
//       switch (notificationType) {
//         case NotificationType.message:
//           _handleMessageNotification(data);
//           break;
//
//         case NotificationType.call:
//           _handleCallNotification(data);
//           break;
//
//         case NotificationType.friendRequest:
//           _handleFriendRequestNotification(data);
//           break;
//
//         case NotificationType.friendAccepted:
//           _handleFriendAcceptedNotification(data);
//           break;
//
//         case NotificationType.like:
//         case NotificationType.comment:
//           _handlePostInteractionNotification(data);
//           break;
//
//         case NotificationType.mention:
//           _handleMentionNotification(data);
//           break;
//
//         case NotificationType.follow:
//           _handleFollowNotification(data);
//           break;
//
//         case NotificationType.post:
//           _handlePostNotification(data);
//           break;
//
//         case NotificationType.groupInvite:
//           _handleGroupInviteNotification(data);
//           break;
//
//         case NotificationType.general:
//         default:
//           _handleGeneralNotification(data);
//           break;
//       }
//     } catch (e) {
//       logError('Error handling notification tap: $e');
//       // Default fallback: navigate to home
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Message Notification
//   static void _handleMessageNotification(Map<String, dynamic> data) {
//     try {
//       // Navigate to Messages tab
//       if (Get.isRegistered<BottomNavController>()) {
//         Get.find<BottomNavController>().selectedIndex.value =
//             1; // Messages tab index
//       }
//
//       // Navigate to specific chat
//       // Get.to(
//       //       () => ChatScreen(
//       //     title: data['title'] ?? 'Chat',
//       //     id: data['id'] ?? '',
//       //     isGroupChat: AppStringFunctions.stringToBool(
//       //       data['isGroupChat'] ?? 'false',
//       //     ),
//       //     profilePictureUrl: data['profilePictureUrl'] ?? '',
//       //     isProfilePictureVisible: AppStringFunctions.stringToBool(
//       //       data['isProfilePictureVisible'] ?? 'true',
//       //     ),
//       //   ),
//       // );
//     } catch (e) {
//       logError('Error handling message notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Call Notification
//   static void _handleCallNotification(Map<String, dynamic> data) {
//     try {
//       // Navigate to call screen or home
//       // Get.to(() => CallScreen(callId: data['id']));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling call notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Friend Request Notification
//   static void _handleFriendRequestNotification(Map<String, dynamic> data) {
//     try {
//       // Navigate to Friend Requests screen
//       if (Get.isRegistered<BottomNavController>()) {
//         Get.find<BottomNavController>().selectedIndex.value = 2; // Adjust index
//       }
//       // Get.to(() => FriendRequestsScreen());
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling friend request notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Friend Accepted Notification
//   static void _handleFriendAcceptedNotification(Map<String, dynamic> data) {
//     try {
//       final userId = data['userId'] ?? data['id'];
//       // Navigate to user's profile
//       // Get.to(() => ProfileScreen(userId: userId));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling friend accepted notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Post Interaction (Like/Comment) Notification
//   static void _handlePostInteractionNotification(Map<String, dynamic> data) {
//     try {
//       final postId = data['postId'] ?? data['id'];
//       // Navigate to post detail
//       // Get.to(() => PostDetailScreen(postId: postId));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling post interaction notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Mention Notification
//   static void _handleMentionNotification(Map<String, dynamic> data) {
//     try {
//       final postId = data['postId'] ?? data['id'];
//       // Navigate to post where user was mentioned
//       // Get.to(() => PostDetailScreen(postId: postId));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling mention notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Follow Notification
//   static void _handleFollowNotification(Map<String, dynamic> data) {
//     try {
//       final userId = data['userId'] ?? data['id'];
//       // Navigate to follower's profile
//       // Get.to(() => ProfileScreen(userId: userId));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling follow notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Post Notification
//   static void _handlePostNotification(Map<String, dynamic> data) {
//     try {
//       final postId = data['postId'] ?? data['id'];
//       // Navigate to specific post
//       // Get.to(() => PostDetailScreen(postId: postId));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling post notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle Group Invite Notification
//   static void _handleGroupInviteNotification(Map<String, dynamic> data) {
//     try {
//       final groupId = data['groupId'] ?? data['id'];
//       // Navigate to group or group invites screen
//       // Get.to(() => GroupDetailScreen(groupId: groupId));
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling group invite notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   // ✅ Handle General Notification
//   static void _handleGeneralNotification(Map<String, dynamic> data) {
//     try {
//       // Navigate to notifications screen or home
//       if (Get.isRegistered<BottomNavController>()) {
//         Get.find<BottomNavController>().selectedIndex.value =
//             3; // Notifications tab
//       }
//       Get.offAll(() => const HomeScreen());
//     } catch (e) {
//       logError('Error handling general notification: $e');
//       Get.offAll(() => const HomeScreen());
//     }
//   }
//
//   static Future<void> display({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           AppPushNotifications.androidChannelId,
//           AppPushNotifications.androidChannelName,
//           channelDescription: AppPushNotifications.androidChannelDescription,
//           importance: AppPushNotifications.androidChannelImportance,
//           priority: AppPushNotifications.androidChannelPriority,
//           playSound: true,
//           enableVibration: true,
//           icon: AppPushNotifications.appIcon,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       );
//
//       await notificationsPlugin.show(
//         id,
//         title,
//         body,
//         notificationDetails,
//         payload: payload,
//       );
//
//       logDebug('Notification displayed: $title');
//     } catch (e) {
//       logError('Error displaying notification: $e');
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../utils/app_console_log_functions.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/app_push_notifications.dart';
import '../../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../../audio_call/audio_call_screen.dart';
import '../../home/home_screen.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        await notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: AndroidInitializationSettings(AppPushNotifications.appIcon),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestAlertPermission: true,
          requestBadgePermission: true,
        ),
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          // Handle notification tap when app is in foreground
          onTapNotification(payload: response.payload, context: context);
        },
      );
    } catch (e) {
      logError('Error initializing local notifications: $e');
    }
  }

  static void onTapNotification({
    required String? payload,
    required BuildContext context,
  }) {
    if (payload == null || payload.isEmpty) {
      logWarning("Notification payload is null or empty");
      return;
    }

    try {
      Map<String, dynamic> data = jsonDecode(payload);
      logInfo("onSelectNotification: $payload");

      // Get notification type from payload
      final typeString = data['type'] as String?;
      if (typeString == null) {
        logWarning("Notification type is null");
        Get.offAll(() => const HomeScreen());
        return;
      }

      final notificationType = NotificationTypeExtension.fromString(typeString);

      // Navigate based on notification type
      switch (notificationType) {
        case NotificationType.message:
          _handleMessageNotification(data);
          break;

        case NotificationType.call:
          _handleCallNotification(data);
          break;

        case NotificationType.friendRequest:
          _handleFriendRequestNotification(data);
          break;

        case NotificationType.friendAccepted:
          _handleFriendAcceptedNotification(data);
          break;

        case NotificationType.like:
        case NotificationType.comment:
          _handlePostInteractionNotification(data);
          break;

        case NotificationType.mention:
          _handleMentionNotification(data);
          break;

        case NotificationType.follow:
          _handleFollowNotification(data);
          break;

        case NotificationType.post:
          _handlePostNotification(data);
          break;

        case NotificationType.groupInvite:
          _handleGroupInviteNotification(data);
          break;

        case NotificationType.general:
        default:
          _handleGeneralNotification(data);
          break;
      }
    } catch (e) {
      logError('Error handling notification tap: $e');
      // Default fallback: navigate to home
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Message Notification
  static void _handleMessageNotification(Map<String, dynamic> data) {
    try {
      // Navigate to Messages tab
      if (Get.isRegistered<BottomNavController>()) {
        Get.find<BottomNavController>().selectedIndex.value = 1;
      }
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling message notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Call Notification - UPDATED
  static void _handleCallNotification(Map<String, dynamic> data) {
    try {
      final String callerName = data['caller_name'] ?? 'Unknown';
      final String callerAvatar = data['caller_avatar'] ?? '';
      final String callerId = data['caller_id'] ?? '';
      final bool isVideo = data['call_type'] == 'video';
      final String callId = data['call_id'] ?? '';
      final String channelName = data['channel_name'] ?? '';
      final String token = data['token'] ?? '';
      final int uid = int.tryParse(data['uid']?.toString() ?? '0') ?? 0;

      // Navigate to incoming call screen
      Get.to(
        () => CallScreen(
          userName: callerName,
          userAvatar: callerAvatar,
          receiverId: callerId,
          isVideo: isVideo,
          isIncoming: true,
          callId: callId,
          channelName: channelName,
          token: token,
          uid: uid,
        ),
      );
    } catch (e) {
      logError('Error handling call notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Friend Request Notification
  static void _handleFriendRequestNotification(Map<String, dynamic> data) {
    try {
      if (Get.isRegistered<BottomNavController>()) {
        Get.find<BottomNavController>().selectedIndex.value = 2;
      }
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling friend request notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Friend Accepted Notification
  static void _handleFriendAcceptedNotification(Map<String, dynamic> data) {
    try {
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling friend accepted notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Post Interaction (Like/Comment) Notification
  static void _handlePostInteractionNotification(Map<String, dynamic> data) {
    try {
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling post interaction notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Mention Notification
  static void _handleMentionNotification(Map<String, dynamic> data) {
    try {
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling mention notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Follow Notification
  static void _handleFollowNotification(Map<String, dynamic> data) {
    try {
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling follow notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Post Notification
  static void _handlePostNotification(Map<String, dynamic> data) {
    try {
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling post notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle Group Invite Notification
  static void _handleGroupInviteNotification(Map<String, dynamic> data) {
    try {
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling group invite notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  // ✅ Handle General Notification
  static void _handleGeneralNotification(Map<String, dynamic> data) {
    try {
      if (Get.isRegistered<BottomNavController>()) {
        Get.find<BottomNavController>().selectedIndex.value = 3;
      }
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      logError('Error handling general notification: $e');
      Get.offAll(() => const HomeScreen());
    }
  }

  static Future<void> display({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          AppPushNotifications.androidChannelId,
          AppPushNotifications.androidChannelName,
          channelDescription: AppPushNotifications.androidChannelDescription,
          importance: AppPushNotifications.androidChannelImportance,
          priority: AppPushNotifications.androidChannelPriority,
          playSound: true,
          enableVibration: true,
          icon: AppPushNotifications.appIcon,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      logDebug('Notification displayed: $title');
    } catch (e) {
      logError('Error displaying notification: $e');
    }
  }

  // ✅ Display incoming call notification (full screen)
  static Future<void> displayIncomingCall({
    required String callerName,
    required String callType,
    required Map<String, dynamic> callData,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'call_channel',
        'Incoming Calls',
        channelDescription: 'Incoming call notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        fullScreenIntent: true,
        icon: AppPushNotifications.appIcon,
        category: AndroidNotificationCategory.call,
        ongoing: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await notificationsPlugin.show(
        id,
        'Incoming ${callType.capitalize} Call',
        '$callerName is calling...',
        notificationDetails,
        payload: jsonEncode(callData),
      );

      logDebug('Incoming call notification displayed for: $callerName');
    } catch (e) {
      logError('Error displaying incoming call notification: $e');
    }
  }
}
