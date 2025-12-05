import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'notification_modelClass.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('✅ NotificationController initialized');
    getNotificationList();
  }

  Future<void> getNotificationList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      debugPrint('📡 Starting to fetch notifications...');

      int userId = StorageHelper().getUserId;
      debugPrint('👤 User ID: $userId');

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.userId: '$userId',
        },
        endPoint: ApiUtils.getNotification,
      );

      debugPrint('📥 API Response received: $result');

      NotificationResponse response = NotificationResponse.fromJson(result);
      debugPrint('📊 Response status: ${response.status}');

      if (response.status == 'success') {
        notificationList.value = response.data ?? [];
        debugPrint('✅ Notifications loaded: ${notificationList.length} items');

        // Print each notification for debugging
        for (var i = 0; i < notificationList.length; i++) {
          debugPrint('📬 Notification $i:');
          debugPrint('   - ID: ${notificationList[i].id}');
          debugPrint('   - Title: ${notificationList[i].title}');
          debugPrint('   - Message: ${notificationList[i].message}');
          debugPrint('   - Type: ${notificationList[i].type}');
          debugPrint('   - From: ${notificationList[i].fullname ?? "Unknown"}');
          debugPrint('   - Read: ${notificationList[i].isRead}');
          debugPrint('   - Created: ${notificationList[i].createdAt}');
        }
      } else {
        errorMessage.value = 'Failed to load notifications';
        debugPrint('❌ API Error: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      debugPrint('❌ Exception in getNotificationList: ${e.toString()}');
      debugPrint('📍 Stack trace: ${StackTrace.current}');
    } finally {
      isLoading.value = false;
      debugPrint('🏁 Loading completed. isLoading: ${isLoading.value}');
      debugPrint('📊 Total notifications: ${notificationList.length}');
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    debugPrint('🔄 Refreshing notifications...');
    await getNotificationList();
  }

  // // Mark notification as read (Uncomment when API is ready)
  // Future<void> markAsRead(String notificationId) async {
  //   try {
  //     debugPrint('✓ Marking notification as read: $notificationId');
  //
  //     int userId = StorageHelper().getUserId;
  //
  //     var result = await ApiManager.callPostWithFormData(
  //       body: {
  //         ApiParam.userId: '$userId',
  //         'notification_id': notificationId,
  //       },
  //       endPoint: ApiUtils.markNotificationRead,
  //     );
  //
  //     debugPrint('✅ Mark as read response: $result');
  //
  //     // Update local state
  //     final index = notificationList.indexWhere((n) => n.id == notificationId);
  //     if (index != -1) {
  //       notificationList[index] = notificationList[index].copyWith(isRead: true);
  //       notificationList.refresh();
  //       debugPrint('✅ Local state updated for notification $notificationId');
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Error marking notification as read: ${e.toString()}');
  //   }
  // }
  //
  // // Delete notification (Uncomment when API is ready)
  // Future<void> deleteNotification(String notificationId) async {
  //   try {
  //     debugPrint('🗑️ Deleting notification: $notificationId');
  //
  //     int userId = StorageHelper().getUserId;
  //
  //     var result = await ApiManager.callPostWithFormData(
  //       body: {
  //         ApiParam.userId: '$userId',
  //         'notification_id': notificationId,
  //       },
  //       endPoint: ApiUtils.deleteNotification,
  //     );
  //
  //     debugPrint('✅ Delete response: $result');
  //
  //     // Remove from local list
  //     notificationList.removeWhere((n) => n.id == notificationId);
  //     debugPrint('✅ Notification removed from list. Remaining: ${notificationList.length}');
  //   } catch (e) {
  //     debugPrint('❌ Error deleting notification: ${e.toString()}');
  //   }
  // }
}