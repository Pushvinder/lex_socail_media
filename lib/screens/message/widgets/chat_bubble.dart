import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/message/chat_controller.dart';
import 'package:the_friendz_zone/screens/message/models/message_model.dart';
import 'package:the_friendz_zone/screens/message/widgets/video_player_screen.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';

import 'full_screen_image_viewer.dart';


class ChatBubble extends StatefulWidget {
  final Message message;
  final String avatarUrl;

  const ChatBubble({
    required this.message,
    required this.avatarUrl,
    super.key,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    if (widget.message.type == 'audio') {
      _setupAudioPlayer();
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  Future<void> _playAudio() async {
    if (widget.message.mediaUrl == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.message.mediaUrl!));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMe =
        widget.message.senderId == Get.find<ChatController>().currentUserId;

    // Handle audio messages
    if (widget.message.type == 'audio') {
      return _buildAudioBubble(isMe);
    }

    // Handle text, image, and file messages (your existing code)
    return _buildTextBubble(isMe);
  }

  Widget _buildAudioBubble(bool isMe) {
    final bubbleColor = isMe ? AppColors.textColor4 : AppColors.chatBubbleOther;
    final textColor = isMe ? AppColors.chatTextMe : AppColors.whiteColor;

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

    // Audio bubble content
    Widget audioContent = Container(
      width: 200,
      padding: EdgeInsets.all(AppDimens.dimen12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Play button and progress bar
          GestureDetector(
            onTap: _playAudio,
            child: Row(
              children: [
                Container(
                  width: AppDimens.dimen30,
                  height: AppDimens.dimen30,
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: textColor,
                      size: AppDimens.dimen16,
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.dimen8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 4),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 0),
                          activeTrackColor: textColor,
                          inactiveTrackColor: textColor.withOpacity(0.3),
                          thumbColor: textColor,
                        ),
                        child: Slider(
                          value: _position.inSeconds.toDouble(),
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                      SizedBox(height: AppDimens.dimen4),
                      // Duration text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: FontDimen.dimen10,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: FontDimen.dimen10,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Audio message text
          if (widget.message.message.isNotEmpty) ...[
            SizedBox(height: AppDimens.dimen8),
            Text(
              widget.message.message,
              style: TextStyle(
                color: textColor,
                fontSize: FontDimen.dimen12,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ],
        ],
      ),
    );

    Widget bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: bubbleRadius,
      ),
      child: audioContent,
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
                    imageUrl: widget.avatarUrl,
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
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                    widget.message.timestamp != null
                        ? _formatMessageTime(widget.message.timestamp!.toDate())
                        : ' ',
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
                    imageUrl: widget.avatarUrl,
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

  Widget _buildTextBubble(bool isMe) {
    final bubbleColor = isMe ? AppColors.textColor4 : AppColors.chatBubbleOther;
    final textColor = isMe ? AppColors.chatTextMe : AppColors.whiteColor;

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

    Widget bubbleContent;

    if (widget.message.type == 'image') {
      bubbleContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => FullScreenImageViewer(
                    images: [widget.message.mediaUrl!], // <-- NEW
                    initialIndex: 0, // <-- NEW
                    heroTag: widget.message.mediaUrl, // Optional hero tag
                  ));
            },
            child: Hero(
              tag: widget.message.mediaUrl ?? "",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.dimen8),
                child: CachedNetworkImage(
                  imageUrl: widget.message.mediaUrl ?? '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 100,
                    height: 100,
                    color: AppColors.greyShadeColor,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 100,
                    height: 100,
                    color: AppColors.greyShadeColor,
                    child: Icon(Icons.broken_image, color: AppColors.greyColor),
                  ),
                ),
              ),
            ),
          ),
          if (widget.message.message.isNotEmpty) ...[
            SizedBox(height: AppDimens.dimen8),
            Text(
              widget.message.message,
              style: TextStyle(
                color: textColor,
                fontSize: FontDimen.dimen12,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ],
        ],
      );
    } else if (widget.message.type == 'video') {
      // Video thumbnail preview
      bubbleContent = GestureDetector(
        onTap: () {
          Get.to(() => VideoPlayerScreen(videoUrl: widget.message.mediaUrl!));
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dimen10),
              child: CachedNetworkImage(
                imageUrl: widget.message.mediaUrl ?? '',
                width: 160,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 160,
                  height: 120,
                  color: AppColors.greyShadeColor,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 160,
                  height: 120,
                  color: AppColors.greyShadeColor,
                  child: Icon(Icons.videocam_off, color: Colors.white),
                ),
              ),
            ),

            // Play Icon Overlay
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 30),
                ),
              ),
            )
          ],
        ),
      );
    } else if (widget.message.type == 'file') {
      // File message
      bubbleContent = Row(
        children: [
          Icon(
            Icons.insert_drive_file,
            color: textColor,
            size: AppDimens.dimen20,
          ),
          SizedBox(width: AppDimens.dimen8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.fileName ?? 'File',
                  style: TextStyle(
                    color: textColor,
                    fontSize: FontDimen.dimen12,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.message.message.isNotEmpty) ...[
                  SizedBox(height: AppDimens.dimen4),
                  Text(
                    widget.message.message,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: FontDimen.dimen11,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    } else {
      // Text message
      bubbleContent = Text(
        widget.message.message,
        style: TextStyle(
          color: textColor,
          fontSize: FontDimen.dimen13,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    Widget bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dimen16,
        vertical: AppDimens.dimen14 - 0.2,
      ),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: bubbleRadius,
      ),
      child: bubbleContent,
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
                    imageUrl: widget.avatarUrl,
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
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                    widget.message.timestamp != null
                        ? _formatMessageTime(widget.message.timestamp!.toDate())
                        : ' ',
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
                    imageUrl: widget.avatarUrl,
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

  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (messageDate == yesterday) {
      return 'Yesterday ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isMe;

  _BubbleTailPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isMe) {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
