// import '../../../config/app_config.dart';

// class ChatInputField extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onSend;
//   final ValueChanged<String> onChanged;

//   const ChatInputField({
//     required this.controller,
//     required this.onSend,
//     required this.onChanged,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Top border above the entire input area
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
//           child: Container(
//             color: AppColors.textColor4,
//             height: 1,
//             width: double.infinity,
//           ),
//         ),
//         // Input row
//         Container(
//           color: AppColors.scaffoldBackgroundColor,
//           padding: EdgeInsets.only(
//             left: AppDimens.dimen16,
//             right: AppDimens.dimen16,
//             top: AppDimens.dimen10,
//             bottom: AppDimens.dimen20,
//           ),
//           child: Row(
//             children: [
//               // TextField with all icons inside
//               Expanded(
//                 child: Container(
//                   height: AppDimens.dimen80,
//                   decoration: BoxDecoration(
//                     color: AppColors.cardBgColor,
//                     borderRadius: BorderRadius.circular(AppDimens.dimen16),
//                     border: Border.all(
//                       color: AppColors.textColor4.withOpacity(0.13),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       // Plus icon
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: AppDimens.dimen12,
//                           right: AppDimens.dimen8,
//                         ),
//                         child: Image.asset(
//                           AppImages.plusBlueIcon,
//                           height: AppDimens.dimen24,
//                           width: AppDimens.dimen24,
//                         ),
//                       ),
//                       // TextField
//                       Expanded(
//                         child: TextField(
//                           controller: controller,
//                           style: TextStyle(
//                             color: AppColors.whiteColor.withOpacity(1),
//                             fontFamily: GoogleFonts.inter().fontFamily,
//                             fontSize: FontDimen.dimen12,
//                           ),
//                           onChanged: onChanged,
//                           decoration: InputDecoration(
//                             hintText: AppStrings.chatInputHint,
//                             hintStyle: TextStyle(
//                               color: AppColors.textColor3.withOpacity(0.7),
//                               fontFamily: GoogleFonts.inter().fontFamily,
//                               fontSize: FontDimen.dimen12,
//                             ),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 0,
//                               vertical: AppDimens.dimen15,
//                             ),
//                             isDense: true,
//                           ),
//                         ),
//                       ),
//                       // Mic icon
//                       Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                         child: Image.asset(
//                           AppImages.micBlueIcon,
//                           height: AppDimens.dimen26,
//                           width: AppDimens.dimen26,
//                         ),
//                       ),
//                       SizedBox(width: AppDimens.dimen12),
//                       // Camera icon
//                       Padding(
//                         padding: EdgeInsets.only(right: AppDimens.dimen8),
//                         child: Image.asset(
//                           AppImages.cameraBlueIcon,
//                           height: AppDimens.dimen26,
//                           width: AppDimens.dimen26,
//                         ),
//                       ),
//                       SizedBox(width: AppDimens.dimen6),
//                       GestureDetector(
//                         onTap: onSend,
//                         child: Container(
//                           width: 55,
//                           height: 55,
//                           decoration: BoxDecoration(
//                             color: AppColors.textColor4,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 3),
//                               child: Image.asset(
//                                 AppImages.sendFilledIcon,
//                                 height: AppDimens.dimen35 - 2,
//                                 width: AppDimens.dimen35 - 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: AppDimens.dimen8),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/message/chat_controller.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/app_img.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;

  const ChatInputField({
    required this.controller,
    required this.onSend,
    required this.onChanged,
    super.key,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top border above the entire input area
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
          child: Container(
            color: AppColors.textColor4,
            height: 1,
            width: double.infinity,
          ),
        ),
        // Input row
        Container(
          color: AppColors.scaffoldBackgroundColor,
          padding: EdgeInsets.only(
            left: AppDimens.dimen16,
            right: AppDimens.dimen16,
            top: AppDimens.dimen10,
            bottom: AppDimens.dimen20,
          ),
          child: Obx(() {
            final isRecording = chatController.isRecording.value;
            final isRecordingCompleted = chatController.recordingDuration.value != '00:00' && !isRecording;
            final hasText = widget.controller.text.trim().isNotEmpty;

            return Row(
              children: [
                // TextField with all icons inside
                Expanded(
                  child: Container(
                    height: AppDimens.dimen80,
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(AppDimens.dimen16),
                      border: Border.all(
                        color: AppColors.textColor4.withOpacity(0.13),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left side buttons (Cancel when recording completed, Plus otherwise)
                        if (isRecordingCompleted) ...[
                          // Cancel button for recorded audio
                          GestureDetector(
                            onTap: () {
                              // Cancel the recording
                              chatController.cancelRecording();
                              widget.controller.clear();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: AppDimens.dimen12,
                                right: AppDimens.dimen8,
                              ),
                              child: Container(
                                width: AppDimens.dimen24,
                                height: AppDimens.dimen24,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: AppDimens.dimen16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else if (!isRecording) ...[
                          // Plus icon (File picker) - only show when not recording
                          GestureDetector(
                            onTap: () async {
                              await chatController.pickFileAndSend();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: AppDimens.dimen12,
                                right: AppDimens.dimen8,
                              ),
                              child: Image.asset(
                                AppImages.plusBlueIcon,
                                height: AppDimens.dimen24,
                                width: AppDimens.dimen24,
                              ),
                            ),
                          ),
                        ] else if (isRecording) ...[
                          // Recording indicator (red circle)
                          Padding(
                            padding: EdgeInsets.only(
                              left: AppDimens.dimen12,
                              right: AppDimens.dimen8,
                            ),
                            child: Container(
                              width: AppDimens.dimen24,
                              height: AppDimens.dimen24,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: AppDimens.dimen10,
                                  height: AppDimens.dimen10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        
                        // TextField or Recording display
                        Expanded(
                          child: isRecording || isRecordingCompleted
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        color: Colors.red,
                                        size: AppDimens.dimen20,
                                      ),
                                      SizedBox(width: AppDimens.dimen8),
                                      Text(
                                        chatController.recordingDuration.value,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: AppFonts.appFont,
                                          fontSize: FontDimen.dimen16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (isRecording) ...[
                                        SizedBox(width: AppDimens.dimen8),
                                        Text(
                                          'Recording...',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: AppFonts.appFont,
                                            fontSize: FontDimen.dimen12,
                                          ),
                                        ),
                                      ] else if (isRecordingCompleted) ...[
                                        SizedBox(width: AppDimens.dimen8),
                                        Text(
                                          'Ready to send',
                                          style: TextStyle(
                                            color: AppColors.greenColor,
                                            fontFamily: AppFonts.appFont,
                                            fontSize: FontDimen.dimen12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                )
                              : TextField(
                                  controller: widget.controller,
                                  style: TextStyle(
                                    color: AppColors.whiteColor.withOpacity(1),
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontSize: FontDimen.dimen12,
                                  ),
                                  onChanged: widget.onChanged,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.chatInputHint,
                                    hintStyle: TextStyle(
                                      color: AppColors.textColor3.withOpacity(0.7),
                                      fontFamily: GoogleFonts.inter().fontFamily,
                                      fontSize: FontDimen.dimen12,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: AppDimens.dimen15,
                                    ),
                                    isDense: true,
                                  ),
                                ),
                        ),
                        
                        // Mic/Stop button
                        GestureDetector(
                          onTap: () async {
                            if (!isRecording) {
                              await chatController.startRecording();
                            } else {
                              await chatController.stopRecording();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.dimen8),
                            child: Container(
                              width: AppDimens.dimen26,
                              height: AppDimens.dimen26,
                              decoration: BoxDecoration(
                                color: isRecording ? Colors.red : AppColors.textColor4,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  isRecording ? Icons.stop : Icons.mic,
                                  color: Colors.white,
                                  size: AppDimens.dimen16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: AppDimens.dimen12),
                        
                        // Camera icon (only show when not recording and not recording completed)
                        if (!isRecording && !isRecordingCompleted) ...[
                          GestureDetector(
                            onTap: () async {
                              await chatController.pickImageAndSend();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: AppDimens.dimen8),
                              child: Image.asset(
                                AppImages.cameraBlueIcon,
                                height: AppDimens.dimen26,
                                width: AppDimens.dimen26,
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimens.dimen6),
                        ],
                        
                        // ALWAYS SHOW SEND BUTTON (disabled when empty)
                        GestureDetector(
                          onTap: () {
                            if (isRecordingCompleted) {
                              // Send the recorded audio
                              chatController.sendRecordedAudio();
                            } else if (hasText && !isRecording) {
                              // Send text message
                              widget.onSend();
                            }
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: (hasText && !isRecording) || isRecordingCompleted
                                  ? AppColors.textColor4
                                  : AppColors.textColor4.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Image.asset(
                                  AppImages.sendFilledIcon,
                                  height: AppDimens.dimen35 - 2,
                                  width: AppDimens.dimen35 - 2,
                                  color: (hasText && !isRecording) || isRecordingCompleted
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimens.dimen8),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}