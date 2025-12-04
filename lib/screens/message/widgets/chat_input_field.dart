//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/message/chat_controller.dart';
// import 'package:the_friendz_zone/utils/app_dimen.dart';
// import 'package:the_friendz_zone/utils/app_fonts.dart';
// import 'package:the_friendz_zone/utils/app_img.dart';
// import 'package:the_friendz_zone/utils/app_strings.dart';
//
// class ChatInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final VoidCallback onSend;
//   final ValueChanged<String> onChanged;
//
//   const ChatInputField({
//     required this.controller,
//     required this.onSend,
//     required this.onChanged,
//     super.key,
//   });
//
//   @override
//   State<ChatInputField> createState() => _ChatInputFieldState();
// }
//
// class _ChatInputFieldState extends State<ChatInputField> {
//   // Show attachment options
//   void _showAttachmentOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.cardBgColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: AppColors.greyColor.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Send Attachment',
//               style: GoogleFonts.inter(
//                 color: AppColors.textColor3,
//                 fontSize: FontDimen.dimen16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Options Grid
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Camera
//                 _AttachmentOption(
//                   icon: Icons.camera_alt,
//                   label: 'Camera',
//                   color: Colors.pink,
//                   onTap: () {
//                     Navigator.pop(context);
//                     Get.find<ChatController>().pickImageFromCamera();
//                   },
//                 ),
//
//                 // Gallery
//                 _AttachmentOption(
//                   icon: Icons.photo_library,
//                   label: 'Gallery',
//                   color: Colors.purple,
//                   onTap: () {
//                     Navigator.pop(context);
//                     Get.find<ChatController>().pickImageFromGallery();
//                   },
//                 ),
//
//                 // Files
//                 _AttachmentOption(
//                   icon: Icons.insert_drive_file,
//                   label: 'Files',
//                   color: Colors.blue,
//                   onTap: () {
//                     Navigator.pop(context);
//                     Get.find<ChatController>().pickFileAndSend();
//                   },
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
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
//           child: GetX<ChatController>(
//             builder: (chatController) {
//               final isRecording = chatController.isRecording.value;
//               final isRecordingCompleted =
//                   chatController.recordingDuration.value != '00:00' &&
//                       !isRecording;
//               final hasText = widget.controller.text.trim().isNotEmpty ||
//                   chatController.inputText.value.trim().isNotEmpty;
//               final isUploading = chatController.isUploading.value;
//
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Upload Progress Bar
//                   if (isUploading)
//                     Padding(
//                       padding: EdgeInsets.only(bottom: AppDimens.dimen8),
//                       child: Column(
//                         children: [
//                           LinearProgressIndicator(
//                             value: chatController.uploadProgress.value,
//                             backgroundColor: AppColors.greyColor.withOpacity(0.2),
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               AppColors.primaryColor,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Uploading... ${(chatController.uploadProgress.value * 100).toStringAsFixed(0)}%',
//                             style: TextStyle(
//                               color: AppColors.textColor3.withOpacity(0.7),
//                               fontSize: FontDimen.dimen11,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   // Input Field Row
//                   Row(
//                     children: [
//                       // TextField with all icons inside
//                       Expanded(
//                         child: Container(
//                           height: AppDimens.dimen80,
//                           decoration: BoxDecoration(
//                             color: AppColors.cardBgColor,
//                             borderRadius:
//                             BorderRadius.circular(AppDimens.dimen16),
//                             border: Border.all(
//                               color: AppColors.textColor4.withOpacity(0.13),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               // Left side buttons
//                               if (isRecordingCompleted) ...[
//                                 // Cancel button for recorded audio
//                                 GestureDetector(
//                                   onTap: () {
//                                     chatController.cancelRecording();
//                                     widget.controller.clear();
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                       left: AppDimens.dimen12,
//                                       right: AppDimens.dimen8,
//                                     ),
//                                     child: Container(
//                                       width: AppDimens.dimen24,
//                                       height: AppDimens.dimen24,
//                                       decoration: BoxDecoration(
//                                         color: Colors.red.withOpacity(0.2),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Icon(
//                                           Icons.close,
//                                           color: Colors.red,
//                                           size: AppDimens.dimen16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ] else if (!isRecording && !isUploading) ...[
//                                 // Plus icon (Show attachment options)
//                                 GestureDetector(
//                                   onTap: () => _showAttachmentOptions(context),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                       left: AppDimens.dimen12,
//                                       right: AppDimens.dimen8,
//                                     ),
//                                     child: Image.asset(
//                                       AppImages.plusBlueIcon,
//                                       height: AppDimens.dimen24,
//                                       width: AppDimens.dimen24,
//                                     ),
//                                   ),
//                                 ),
//                               ] else if (isRecording) ...[
//                                 // Recording indicator (red circle)
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                     left: AppDimens.dimen12,
//                                     right: AppDimens.dimen8,
//                                   ),
//                                   child: Container(
//                                     width: AppDimens.dimen24,
//                                     height: AppDimens.dimen24,
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Container(
//                                         width: AppDimens.dimen10,
//                                         height: AppDimens.dimen10,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//
//                               // TextField or Recording display
//                               Expanded(
//                                 child: isRecording || isRecordingCompleted
//                                     ? Center(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.mic,
//                                         color: Colors.red,
//                                         size: AppDimens.dimen20,
//                                       ),
//                                       SizedBox(width: AppDimens.dimen8),
//                                       Text(
//                                         chatController
//                                             .recordingDuration.value,
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontFamily: AppFonts.appFont,
//                                           fontSize: FontDimen.dimen16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       if (isRecording) ...[
//                                         SizedBox(width: AppDimens.dimen8),
//                                         Text(
//                                           'Recording...',
//                                           style: TextStyle(
//                                             color: Colors.red,
//                                             fontFamily: AppFonts.appFont,
//                                             fontSize: FontDimen.dimen12,
//                                           ),
//                                         ),
//                                       ] else if (isRecordingCompleted) ...[
//                                         SizedBox(width: AppDimens.dimen8),
//                                         Text(
//                                           'Ready to send',
//                                           style: TextStyle(
//                                             color: AppColors.greenColor,
//                                             fontFamily: AppFonts.appFont,
//                                             fontSize: FontDimen.dimen12,
//                                           ),
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 )
//                                     : TextField(
//                                   controller: widget.controller,
//                                   enabled: !isUploading,
//                                   style: TextStyle(
//                                     color: AppColors.whiteColor
//                                         .withOpacity(1),
//                                     fontFamily:
//                                     GoogleFonts.inter().fontFamily,
//                                     fontSize: FontDimen.dimen12,
//                                   ),
//                                   onChanged: (value) {
//                                     chatController.inputText.value = value;
//                                     widget.onChanged(value);
//                                   },
//                                   decoration: InputDecoration(
//                                     hintText: isUploading
//                                         ? 'Uploading...'
//                                         : AppStrings.chatInputHint,
//                                     hintStyle: TextStyle(
//                                       color: AppColors.textColor3
//                                           .withOpacity(0.7),
//                                       fontFamily:
//                                       GoogleFonts.inter().fontFamily,
//                                       fontSize: FontDimen.dimen12,
//                                     ),
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 0,
//                                       vertical: AppDimens.dimen15,
//                                     ),
//                                     isDense: true,
//                                   ),
//                                 ),
//                               ),
//
//                               // Mic/Stop button
//                               if (!isUploading)
//                                 GestureDetector(
//                                   onTap: () async {
//                                     if (!isRecording) {
//                                       await chatController.startRecording();
//                                     } else {
//                                       await chatController.stopRecording();
//                                     }
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: AppDimens.dimen8),
//                                     child: Container(
//                                       width: AppDimens.dimen26,
//                                       height: AppDimens.dimen26,
//                                       decoration: BoxDecoration(
//                                         color: isRecording
//                                             ? Colors.red
//                                             : AppColors.textColor4,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Icon(
//                                           isRecording ? Icons.stop : Icons.mic,
//                                           color: Colors.white,
//                                           size: AppDimens.dimen16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                               SizedBox(width: AppDimens.dimen12),
//
//                               // Camera icon (only show when not recording/completed/uploading)
//                               if (!isRecording &&
//                                   !isRecordingCompleted &&
//                                   !isUploading) ...[
//                                 GestureDetector(
//                                   onTap: () async {
//                                     await chatController.pickImageFromCamera();
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         right: AppDimens.dimen8),
//                                     child: Image.asset(
//                                       AppImages.cameraBlueIcon,
//                                       height: AppDimens.dimen26,
//                                       width: AppDimens.dimen26,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: AppDimens.dimen6),
//                               ],
//
//                               // Send button
//                               GestureDetector(
//                                 onTap: () {
//                                   if (isUploading) return;
//
//                                   final currentText =
//                                   widget.controller.text.trim();
//                                   if (isRecordingCompleted) {
//                                     // Send the recorded audio
//                                     chatController.sendRecordedAudio();
//                                   } else if (currentText.isNotEmpty &&
//                                       !isRecording) {
//                                     // Send text message
//                                     widget.onSend();
//                                   }
//                                 },
//                                 child: Container(
//                                   width: 55,
//                                   height: 55,
//                                   decoration: BoxDecoration(
//                                     color: (hasText && !isRecording) ||
//                                         isRecordingCompleted
//                                         ? AppColors.textColor4
//                                         : AppColors.textColor4.withOpacity(0.3),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.only(top: 3),
//                                       child: Image.asset(
//                                         AppImages.sendFilledIcon,
//                                         height: AppDimens.dimen35 - 2,
//                                         width: AppDimens.dimen35 - 2,
//                                         color: (hasText && !isRecording) ||
//                                             isRecordingCompleted
//                                             ? Colors.white
//                                             : Colors.white.withOpacity(0.5),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: AppDimens.dimen8),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Attachment Option Widget
// class _AttachmentOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;
//
//   const _AttachmentOption({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 30,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             label,
//             style: GoogleFonts.inter(
//               color: AppColors.textColor3,
//               fontSize: FontDimen.dimen12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
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
  // Show attachment options (Gallery & Files only)
  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Send Attachment',
              style: GoogleFonts.inter(
                color: AppColors.textColor3,
                fontSize: FontDimen.dimen16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),

            // Options Grid (Gallery & Files only)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery
                _AttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    Get.find<ChatController>().pickImageFromGallery();
                  },
                ),

                // Files
                _AttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Files',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    Get.find<ChatController>().pickFileAndSend();
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: GetX<ChatController>(
            builder: (chatController) {
              final isRecording = chatController.isRecording.value;
              final isRecordingCompleted =
                  chatController.recordingDuration.value != '00:00' &&
                      !isRecording;
              final hasText = widget.controller.text.trim().isNotEmpty ||
                  chatController.inputText.value.trim().isNotEmpty;
              final isUploading = chatController.isUploading.value;

              // ✅ Check block status
              final isBlocked = chatController.isUserBlocked.value;
              final isBlockedByOther = chatController.isBlockedByOther.value;
              final canSendMessage = !isBlocked && !isBlockedByOther;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Show blocked message if user is blocked
                  if (isBlocked || isBlockedByOther)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppDimens.dimen8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block,
                              color: AppColors.redColor,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              isBlocked
                                  ? 'You blocked this user'
                                  : 'You are blocked by this user',
                              style: GoogleFonts.inter(
                                color: AppColors.redColor,
                                fontSize: FontDimen.dimen12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Upload Progress Bar
                  if (isUploading)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppDimens.dimen8),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: chatController.uploadProgress.value,
                            backgroundColor:
                            AppColors.greyColor.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Uploading... ${(chatController.uploadProgress.value * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: AppColors.textColor3.withOpacity(0.7),
                              fontSize: FontDimen.dimen11,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Input Field Row
                  Row(
                    children: [
                      // TextField with all icons inside
                      Expanded(
                        child: Container(
                          height: AppDimens.dimen80,
                          decoration: BoxDecoration(
                            color: canSendMessage
                                ? AppColors.cardBgColor
                                : AppColors.cardBgColor.withOpacity(0.5),
                            borderRadius:
                            BorderRadius.circular(AppDimens.dimen16),
                            border: Border.all(
                              color: AppColors.textColor4.withOpacity(0.13),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Left side buttons
                              if (isRecordingCompleted) ...[
                                // Cancel button for recorded audio
                                GestureDetector(
                                  onTap: () {
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
                              ] else if (!isRecording &&
                                  !isUploading &&
                                  canSendMessage) ...[
                                // Plus icon (Show attachment options)
                                GestureDetector(
                                  onTap: () => _showAttachmentOptions(context),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mic,
                                        color: Colors.red,
                                        size: AppDimens.dimen20,
                                      ),
                                      SizedBox(width: AppDimens.dimen8),
                                      Text(
                                        chatController
                                            .recordingDuration.value,
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
                                  enabled:
                                  !isUploading && canSendMessage,
                                  style: TextStyle(
                                    color: AppColors.whiteColor
                                        .withOpacity(1),
                                    fontFamily:
                                    GoogleFonts.inter().fontFamily,
                                    fontSize: FontDimen.dimen12,
                                  ),
                                  onChanged: (value) {
                                    chatController.inputText.value =
                                        value;
                                    widget.onChanged(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: !canSendMessage
                                        ? 'Cannot send messages'
                                        : isUploading
                                        ? 'Uploading...'
                                        : AppStrings.chatInputHint,
                                    hintStyle: TextStyle(
                                      color: AppColors.textColor3
                                          .withOpacity(0.7),
                                      fontFamily:
                                      GoogleFonts.inter().fontFamily,
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
                              if (!isUploading && canSendMessage)
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
                                        color: isRecording
                                            ? Colors.red
                                            : AppColors.textColor4,
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

                              // Camera icon (always visible when not recording/completed/uploading)
                              if (!isRecording &&
                                  !isRecordingCompleted &&
                                  !isUploading &&
                                  canSendMessage) ...[
                                GestureDetector(
                                  onTap: () async {
                                    await chatController
                                        .captureImageFromCamera();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: AppDimens.dimen8),
                                    child: Image.asset(
                                      AppImages.cameraBlueIcon,
                                      height: AppDimens.dimen26,
                                      width: AppDimens.dimen26,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppDimens.dimen6),
                              ],

                              // Send button
                              GestureDetector(
                                onTap: () {
                                  if (isUploading || !canSendMessage) return;

                                  final currentText =
                                  widget.controller.text.trim();
                                  if (isRecordingCompleted) {
                                    // Send the recorded audio
                                    chatController.sendRecordedAudio();
                                  } else if (currentText.isNotEmpty &&
                                      !isRecording) {
                                    // Send text message
                                    widget.onSend();
                                  }
                                },
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: (hasText && !isRecording) ||
                                        isRecordingCompleted
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
                                        color: (hasText && !isRecording) ||
                                            isRecordingCompleted
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
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// Attachment Option Widget
class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textColor3,
              fontSize: FontDimen.dimen12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}