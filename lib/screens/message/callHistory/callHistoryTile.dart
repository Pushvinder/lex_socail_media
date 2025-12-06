import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_config.dart' hide AppColors;
import '../../../utils/app_dimen.dart';
import '../../audio_call/audio_call_screen.dart';
import 'callHistory_model.dart';

class CallHistoryTile extends StatelessWidget {
  final CallHistoryModel call;
  final String currentUserId;
  final VoidCallback onTap;

  const CallHistoryTile({
    Key? key,
    required this.call,
    required this.currentUserId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participantName = call.getOtherParticipantName(currentUserId);
    final participantProfile = call.getOtherParticipantProfile(currentUserId);
    final isOutgoing = call.isCaller(currentUserId);
    final isAnswered = call.isAnswered;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.textColor3.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left side - Profile image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: participantProfile.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: participantProfile,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.cardBgColor,
                    child: Center(
                      child: Text(
                        participantName.isNotEmpty
                            ? participantName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.cardBgColor,
                    child: Center(
                      child: Text(
                        participantName.isNotEmpty
                            ? participantName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                    : Container(
                  color: AppColors.cardBgColor,
                  child: Center(
                    child: Text(
                      participantName.isNotEmpty
                          ? participantName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: FontDimen.dimen18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Middle - Name, call status icon, and date/time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    participantName,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: FontDimen.dimen16,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.appFont,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Call status icon + Date and Time
                  Row(
                    children: [
                      // Call status icon (answered/missed with direction)
                      Icon(
                        isOutgoing ? Icons.call_made : Icons.call_received,
                        size: 16,
                        color: isAnswered ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      // Date and Time
                      Expanded(
                        child: Text(
                          _formatDateTime(call.startedAt),
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontSize: FontDimen.dimen13,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right side - Call type icon (video/audio)
            GestureDetector(
              onTap: () {
                Get.to(
                      () => CallScreen(
                    userName: participantName,
                    userAvatar: participantProfile,
                    receiverId: call.getOtherParticipantId(currentUserId),
                    isVideo: call.isVideoCall,
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: call.isVideoCall
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : AppColors.primaryColorShade.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  call.isVideoCall ? Icons.videocam : Icons.call,
                  color: call.isVideoCall
                      ? AppColors.primaryColor
                      : AppColors.primaryColorShade,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final callDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final time = '$hour:$minute $period';

      if (callDate == today) {
        return 'Today, $time';
      } else if (callDate == today.subtract(const Duration(days: 1))) {
        return 'Yesterday, $time';
      } else {
        return '${_getMonthName(dateTime.month)} ${dateTime.day}, $time';
      }
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}