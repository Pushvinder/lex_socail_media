import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_friendz_zone/config/app_colors.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';
import '../../user_profile/models/user_model.dart';
import '../models/chat_model.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final ChatModel chat;
  final UserProfileData? otherUser;
  final bool highlighted;

  const MessageTile({
    super.key,
    required this.chat,
    this.otherUser,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.textColor4.withOpacity(0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textColor4.withOpacity(1),
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: otherUser?.photoUrl ?? "",
                fit: BoxFit.cover,
                width: 46,
                height: 46,
                fadeInDuration: const Duration(milliseconds: 400),
                placeholder: (context, url) =>
                    Container(color: AppColors.greyShadeColor),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.greyShadeColor,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  otherUser?.fullName ?? 'Unknown User',
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(1),
                    fontWeight: FontWeight.w600,
                    fontSize: FontDimen.dimen14,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chat.lastMessage ?? ' ',
                  style: TextStyle(
                    color: highlighted
                        ? AppColors.textColor3.withOpacity(0.7)
                        : AppColors.textColor3.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: FontDimen.dimen11,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Trailing (unread + time)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 6),
              if ((chat.unreadMessages?[otherUser?.uId] ?? 0) > 0)
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '${chat.unreadMessages![otherUser!.uId]}',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: FontDimen.dimen13,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                chat.lastMessageTime != null
                    ? DateFormat('h:mm a')
                        .format(chat.lastMessageTime!.toDate())
                    : ' ',
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(0.2),
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: FontDimen.dimen11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
