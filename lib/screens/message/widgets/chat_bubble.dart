import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_friendz_zone/config/app_colors.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import '../../../helpers/storage_helper.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String avatarUrl;

  const ChatBubble({
    required this.message,
    required this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == StorageHelper().getUserId.toString();

    final bubbleColor = isMe ? AppColors.chatBubbleOther : AppColors.textColor4;
    final textColor = AppColors.chatTextMe;

    BorderRadius bubbleRadius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(AppDimens.dimen16),
            topRight: Radius.circular(AppDimens.dimen16),
            bottomLeft: Radius.circular(AppDimens.dimen16),
            bottomRight: Radius.circular(AppDimens.dimen4),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(AppDimens.dimen16),
            topRight: Radius.circular(AppDimens.dimen16),
            bottomLeft: Radius.circular(AppDimens.dimen4),
            bottomRight: Radius.circular(AppDimens.dimen16),
          );

    Widget bubbleTail() {
      return RotatedBox(
        quarterTurns: isMe ? 3 : 1,
        child: CustomPaint(
          painter: _BubbleTailPainter(
            color: bubbleColor,
            isMe: isMe,
          ),
          size: Size(AppDimens.dimen14, AppDimens.dimen14),
        ),
      );
    }

    Widget bubbleWithTail(Widget bubble) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          bubble,
          Positioned(
            bottom: 0,
            right: isMe ? -AppDimens.dimen5 : null,
            left: isMe ? null : -AppDimens.dimen5,
            child: bubbleTail(),
          ),
        ],
      );
    }

    Widget bubble = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dimen16,
        vertical: AppDimens.dimen14 - 0.2,
      ),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: bubbleRadius,
      ),
      child: Text(
        message.message,
        style: TextStyle(
          color: textColor,
          fontSize: FontDimen.dimen13,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final timeStyle = TextStyle(
      color: AppColors.textColor3.withOpacity(0.3),
      fontSize: FontDimen.dimen11,
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    return Padding(
      padding: EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 15),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(
                right: AppDimens.dimen18,
                top: 4,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    width: 33,
                    height: 33,
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
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.55,
                  ),
                  child: bubbleWithTail(bubble),
                ),
                SizedBox(height: AppDimens.dimen4),
                Padding(
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : AppDimens.dimen2,
                    right: isMe ? AppDimens.dimen2 : 0,
                  ),
                  child: Text(
                    message.timestamp?.toDate().toLocal().toIso8601String() ??
                        ' ',
                    style: timeStyle,
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            Padding(
              padding: EdgeInsets.only(
                left: AppDimens.dimen18,
                top: 4,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    width: 33,
                    height: 33,
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
            ),
        ],
      ),
    );
  }
}

// Custom painter for bubble tail
class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isMe;

  _BubbleTailPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BubbleTailPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isMe != isMe;
}
