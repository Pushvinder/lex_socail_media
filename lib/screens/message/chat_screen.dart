
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/message/widgets/chat_input_field.dart';
import 'package:the_friendz_zone/screens/user_profile/user_profile_screen.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/app_img.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';

import '../audio_call/audio_call_screen.dart';
import 'chat_controller.dart';
import 'widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final bool isOnline;
  final String? chatId;
  final String otherUserId;
  final bool isGroup;

  const ChatScreen({
    required this.userName,
    required this.userAvatar,
    this.isOnline = true,
    this.chatId,
    required this.otherUserId,
    this.isGroup = false,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController controller;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ChatController(
        chatId: widget.chatId,
        otherUserId: widget.otherUserId,
        otherUserName: widget.userName,
        otherUserProfileUrl: widget.userAvatar,
        isGroup: widget.isGroup,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }

  String _getLastSeenText(DateTime? lastSeen) {
    if (lastSeen == null) return 'Offline';

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return 'Last seen ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Last seen ${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return 'Last seen ${difference.inDays}d ago';
    } else {
      return 'Last seen ${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppDimens.dimen100),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dimen16,
              AppDimens.dimen22,
              AppDimens.dimen16,
              AppDimens.dimen12,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: AppDimens.dimen90,
                    child: Padding(
                      padding: EdgeInsets.only(right: AppDimens.dimen40),
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen14,
                        width: AppDimens.dimen14,
                      ),
                    ),
                  ),
                ),
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
                      imageUrl: widget.userAvatar,
                      fit: BoxFit.cover,
                      width: AppDimens.dimen26,
                      height: AppDimens.dimen26,
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
                SizedBox(width: AppDimens.dimen12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: AppDimens.dimen6),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                                () => UserProfileScreen(
                              userId: widget.otherUserId,
                            ),
                          );
                        },
                        child: Text(
                          widget.userName,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontWeight: FontWeight.w500,
                            fontSize: FontDimen.dimen18,
                            fontFamily: AppFonts.appFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // ✅ Dynamic Online/Offline Status
                      Obx(() {
                        final isOnline = controller.isOtherUserOnline.value;
                        final lastSeen = controller.otherUserLastSeen.value;

                        return Row(
                          children: [
                            Container(
                              width: AppDimens.dimen8,
                              height: AppDimens.dimen8,
                              decoration: BoxDecoration(
                                color: isOnline
                                    ? AppColors.greenColor
                                    : AppColors.rejectBgColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: AppDimens.dimen6),
                            Expanded(
                              child: Text(
                                isOnline
                                    ? AppStrings.online
                                    : _getLastSeenText(lastSeen),
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(0.7),
                                  fontSize: FontDimen.dimen11,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                // Audio Call Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                            () => CallScreen(
                          userName: widget.userName,
                          userAvatar: widget.userAvatar,
                          receiverId: widget.otherUserId,
                          isVideo: false,
                        ),
                      );
                    },
                    child: Image.asset(
                      AppImages.callIcon,
                      height: AppDimens.dimen26,
                      width: AppDimens.dimen26,
                    ),
                  ),
                ),
                // Video Call Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                            () => CallScreen(
                          userName: widget.userName,
                          userAvatar: widget.userAvatar,
                          receiverId: widget.otherUserId,
                          isVideo: true,
                        ),
                      );
                    },
                    child: Image.asset(
                      AppImages.videoIcon,
                      height: AppDimens.dimen26,
                      width: AppDimens.dimen26,
                    ),
                  ),
                ),
                // ✅ Block Button with Dynamic Color
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
                  child: Obx(() {
                    final isBlocked = controller.isUserBlocked.value;

                    return GestureDetector(
                      onTap: () {
                        controller.showBlockConfirmationDialog();
                      },
                      child: Image.asset(
                        AppImages.blockIcon,
                        height: AppDimens.dimen26,
                        width: AppDimens.dimen26,
                        color: isBlocked
                            ? AppColors.redColor
                            : null, // ✅ Red when blocked
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
            child: Container(
              color: AppColors.textColor4,
              height: AppDimens.dimen2,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Obx(
                  () => ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dimen16,
                  vertical: AppDimens.dimen12 + AppDimens.dimen2,
                ),
                reverse: false,
                itemCount: controller.messages.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: AppDimens.dimen16),
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return ChatBubble(
                    message: message,
                    avatarUrl: widget.userAvatar,
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: ChatInputField(
              controller: textController,
              onChanged: (val) => controller.inputText.value = val,
              onSend: () {
                if (textController.text.trim().isNotEmpty) {
                  controller.sendMessage(
                    messageText: textController.text,
                    type: 'text',
                  );
                  textController.clear();
                }
              },
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}