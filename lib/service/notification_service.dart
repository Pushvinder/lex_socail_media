import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotification({
  required String fcmToken,
  required String title,
  required String body,
  Map<String, String>? data, // Optional additional data
}) async {
  final payload = {
    'token': fcmToken,
    'title': title,
    'body': body,
    'data': data ?? {},
  };

  // Send the request to the Firebase Function
  final response = await http.post(
    Uri.parse("https://sendnotification-jkivkykogq-uc.a.run.app"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(payload),
  );

  // Check the response
  if (response.statusCode == 200) {
    log('Notification sent successfully: ${response.body}');
  } else {
    log('Failed to send notification: ${response.body}');
  }
}

@pragma('vm:entry-point')
void handleNotificationClick(data) async {
  late final value;
  if (data is Map<String, dynamic>) {
    value = data;
  } else {
    value = json.decode(data.payload!);
  }
  String? type = value['type'];
  String? id = value['id'];

  // if (type == "chat") {
  //   Get.findOrPut(MainController()).selectedMenu.value = 3;
  //   MessageController controller;
  //   try {
  //     controller = Get.findOrPut(MessageController());
  //   } catch (e) {
  //     controller = Get.findOrPut(MessageController());
  //   }
  //   if (controller.isLoading.value) {
  //     await controller.isLoading.stream.firstWhere((value) => !value);
  //   }
  //   final index = controller.activeChats.indexWhere(
  //     (element) {
  //       return element.chatModel?.chatId == value['chatId'];
  //     },
  //   );
  //   if (index != -1) {
  //     Get.to(() => ChatScreen(userChat: controller.activeChats[index]));
  //   }
  // }

  // if (type == "post") {
  //   final post = await FeedController().fetchPostById(postId: id!);

  //   if (post != null) {
  //     Get.to(() => SingleFeedCard(post: post));
  //   }
  // }

  // print(type);
  // if (type == "reel") {
  //   final post = await ReelFeedController().fetchReelById(reelId: id!);

  //   if (post != null) {
  //     Get.to(() => SingleReelCard(reel: post));
  //   }
  // }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: handleNotificationClick,
    );
  }

  static Future<void> showNotification(
    int id,
    String title,
    String body, {
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'notifications',
      'Notification',
      channelDescription: 'This channel is used for default notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
