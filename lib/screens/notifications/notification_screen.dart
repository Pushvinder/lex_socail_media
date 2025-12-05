import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../config/app_config.dart';
import 'notification_controller.dart';
import 'notification_modelClass.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      debugPrint('⬅️ Back button pressed');
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Notification',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Balance the back button
                ],
              ),
            ),

            // Notifications List with Obx for reactive updates
            Expanded(
              child: Obx(() {
                debugPrint(
                    '🔄 Building notification list. Loading: ${controller.isLoading.value}, Items: ${controller.notificationList.length}');

                // Loading state
                if (controller.isLoading.value &&
                    controller.notificationList.isEmpty) {
                  debugPrint('⏳ Showing loading indicator');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading notifications...',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontSize: 14,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Error state
                if (controller.errorMessage.value.isNotEmpty &&
                    controller.notificationList.isEmpty) {
                  debugPrint(
                      '❌ Showing error: ${controller.errorMessage.value}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.textColor3.withOpacity(0.5),
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: AppColors.textColor3.withOpacity(0.7),
                              fontSize: 14,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            debugPrint('🔄 Retry button pressed');
                            controller.refreshNotifications();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state
                if (controller.notificationList.isEmpty) {
                  debugPrint('📭 Showing empty state');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          color: AppColors.textColor3.withOpacity(0.5),
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your notifications will appear here',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.5),
                            fontSize: 13,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group notifications by date
                final groupedNotifications = _groupNotificationsByDate(
                    controller.notificationList);

                // Notifications list with date headers
                debugPrint(
                    '📋 Showing ${controller.notificationList.length} notifications');
                return RefreshIndicator(
                  onRefresh: controller.refreshNotifications,
                  color: AppColors.primaryColor,
                  backgroundColor: AppColors.cardBgColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _calculateTotalItems(groupedNotifications),
                    itemBuilder: (context, index) {
                      return _buildListItem(context, groupedNotifications, index);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Group notifications by date
  Map<String, List<NotificationModel>> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    Map<String, List<NotificationModel>> grouped = {};

    for (var notification in notifications) {
      try {
        final date = DateTime.parse(notification.createdAt);
        final dateKey = DateFormat('MMMM d, yyyy').format(date);

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(notification);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }

    return grouped;
  }

  // Calculate total items (headers + notifications)
  int _calculateTotalItems(Map<String, List<NotificationModel>> grouped) {
    int total = 0;
    grouped.forEach((date, notifications) {
      total += 1; // Date header
      total += notifications.length; // Notifications
    });
    return total;
  }

  // Build list item (header or notification)
  Widget _buildListItem(BuildContext context,
      Map<String, List<NotificationModel>> grouped, int index) {
    int currentIndex = 0;

    for (var entry in grouped.entries) {
      // Date header
      if (currentIndex == index) {
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12, left: 4),
          child: Text(
            entry.key,
            style: TextStyle(
              color: AppColors.textColor3.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        );
      }
      currentIndex++;

      // Notifications under this date
      for (var notification in entry.value) {
        if (currentIndex == index) {
          return NotificationTile(
            notification: notification,
            onTap: () {
              debugPrint('👆 Notification tapped: ${notification.id}');
            },
            onAccept: () {
              debugPrint('✅ Accept tapped: ${notification.id}');
              // Handle accept logic
            },
            onDecline: () {
              debugPrint('❌ Decline tapped: ${notification.id}');
              // Handle decline logic
            },
          );
        }
        currentIndex++;
      }
    }

    return const SizedBox.shrink();
  }
}

// Notification Tile Widget matching Figma design
class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
    this.onAccept,
    this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isConnectionRequest = notification.type == 'follow' ||
        notification.type == 'connection_request';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF23283A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: notification.profileImage != null &&
                    notification.profileImage!.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: notification.profileImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Text(
                        notification.fullname?.isNotEmpty == true
                            ? notification.fullname![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Text(
                        notification.fullname?.isNotEmpty == true
                            ? notification.fullname![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Text(
                      notification.fullname?.isNotEmpty == true
                          ? notification.fullname![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and action with time
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: notification.fullname ?? 'Unknown',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                        TextSpan(
                          text: ' ${_getActionText(notification.type)} ',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                        TextSpan(
                          text: _formatTime(notification.createdAt),
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Accept/Decline buttons for connection requests
                  if (isConnectionRequest && onAccept != null && onDecline != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          // Decline button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onDecline,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A3A3A), // Dark red
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Decline',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.appFont,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Accept button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onAccept,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3A5A4A), // Dark green
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.appFont,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getActionText(String type) {
    switch (type.toLowerCase()) {
      case 'post':
        return 'uploaded a new post';
      case 'post_comment':
        return 'commented on your post';
      case 'post_like':
        return 'liked your post';
      case 'follow':
      case 'connection_request':
        return 'sent you connection request';
      case 'message':
        return 'sent you a message';
      default:
        return 'interacted with you';
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} mins ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else {
        return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
      }
    } catch (e) {
      debugPrint('⚠️ Error formatting time: $e');
      return dateTimeStr;
    }
  }
}