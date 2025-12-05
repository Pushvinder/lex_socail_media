import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppPushNotifications {
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String appIcon = "@mipmap/ic_launcher";
  static const String androidChannelId = 'lex_social_media';
  static const String androidChannelName = 'Lex Social Media';
  static const String androidChannelDescription =
      'Channel for Lex Social Media notifications';
  static const String notificationTopic = 'lex_social_media_topic'; // Changed from 'test'
  static const Importance androidChannelImportance = Importance.max;
  static const Priority androidChannelPriority = Priority.max;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    androidChannelId,
    androidChannelName,
    description: androidChannelDescription,
    importance: androidChannelImportance,
  );
}