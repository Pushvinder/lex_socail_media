
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_config.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dimen.dart';
import '../../user_profile/models/user_model.dart';
import '../models/chat_model.dart';
import '../message_controller.dart';

class MessageTile extends StatelessWidget {
  final ChatModel chat;
  final UserProfileData? otherUser;
  final bool highlighted;

  const MessageTile({
    Key? key,
    required this.chat,
    this.otherUser,
    this.highlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = StorageHelper().getUserId.toString();
    final unreadCount = chat.unreadMessages?[currentUserId] ?? 0;
    final messageController = Get.find<MessageController>();
    final otherUserId = messageController.getOtherParticipantId(chat);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.cardBgColor.withOpacity(0.5)
            : AppColors.cardBgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Profile Image with Online Indicator
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textColor4.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: otherUser?.profile ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.greyShadeColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.greyShadeColor,
                      child: Icon(
                        Icons.person,
                        color: AppColors.greyColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              // ✅ Online Indicator with real-time status
              if (otherUser != null)
                Obx(() {
                  final isOnline = messageController.isUserOnline(otherUserId);
                  return Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.greenColor
                            : AppColors.greyColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
          const SizedBox(width: 12),

          // Message Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Name
                    Expanded(
                      child: Text(
                        otherUser?.fullname ?? 'Unknown User',
                        style: GoogleFonts.inter(
                          color: AppColors.textColor3,
                          fontSize: FontDimen.dimen15,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Time
                    Text(
                      _formatTime(chat.lastMessageTime),
                      style: GoogleFonts.inter(
                        color: AppColors.textColor3.withOpacity(0.5),
                        fontSize: FontDimen.dimen11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Last Message
                    Expanded(
                      child: Text(
                        chat.lastMessage,
                        style: GoogleFonts.inter(
                          color: unreadCount > 0
                              ? AppColors.textColor3.withOpacity(0.9)
                              : AppColors.textColor3.withOpacity(0.6),
                          fontSize: FontDimen.dimen13,
                          fontWeight: unreadCount > 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    // Unread Count Badge
                    if (unreadCount > 0)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 22,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColorShade,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: GoogleFonts.inter(
                            color: AppColors.whiteColor,
                            fontSize: FontDimen.dimen11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}