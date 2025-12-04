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
// // // import 'package:cached_network_image/cached_network_image.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:the_friendz_zone/config/app_colors.dart';
// // // import 'package:the_friendz_zone/utils/app_dimen.dart';
// // // import 'package:the_friendz_zone/utils/app_fonts.dart';
// // // import 'package:the_friendz_zone/utils/app_strings.dart';
// // // import '../../user_profile/models/user_model.dart';
// // // import '../models/chat_model.dart';
// // // import 'package:intl/intl.dart';
// // //
// // // class MessageTile extends StatelessWidget {
// // //   final ChatModel chat;
// // //   final UserProfileData? otherUser;
// // //   final bool highlighted;
// // //
// // //   const MessageTile({
// // //     super.key,
// // //     required this.chat,
// // //     this.otherUser,
// // //     this.highlighted = false,
// // //   });
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
// // //       decoration: BoxDecoration(
// // //         color: highlighted
// // //             ? AppColors.textColor4.withOpacity(0.5)
// // //             : Colors.transparent,
// // //         borderRadius: BorderRadius.circular(8),
// // //       ),
// // //       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 0),
// // //       child: Row(
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         children: [
// // //           // Avatar
// // //           Container(
// // //             decoration: BoxDecoration(
// // //               shape: BoxShape.circle,
// // //               border: Border.all(
// // //                 color: AppColors.textColor4.withOpacity(1),
// // //                 width: 3,
// // //               ),
// // //             ),
// // //             child: ClipRRect(
// // //               borderRadius: BorderRadius.circular(100),
// // //               child: CachedNetworkImage(
// // //                 imageUrl: otherUser?.photoUrl ?? "",
// // //                 fit: BoxFit.cover,
// // //                 width: 46,
// // //                 height: 46,
// // //                 fadeInDuration: const Duration(milliseconds: 400),
// // //                 placeholder: (context, url) =>
// // //                     Container(color: AppColors.greyShadeColor),
// // //                 errorWidget: (context, url, error) => Container(
// // //                   color: AppColors.greyShadeColor,
// // //                   child: Icon(
// // //                     Icons.person,
// // //                     color: AppColors.greyColor,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(width: 12),
// // //           // Name and message
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Text(
// // //                   otherUser?.fullName ?? 'Unknown User',
// // //                   style: TextStyle(
// // //                     color: AppColors.textColor3.withOpacity(1),
// // //                     fontWeight: FontWeight.w600,
// // //                     fontSize: FontDimen.dimen14,
// // //                     fontFamily: GoogleFonts.inter().fontFamily,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Text(
// // //                   chat.lastMessage ?? ' ',
// // //                   style: TextStyle(
// // //                     color: highlighted
// // //                         ? AppColors.textColor3.withOpacity(0.7)
// // //                         : AppColors.textColor3.withOpacity(0.5),
// // //                     fontWeight: FontWeight.w600,
// // //                     fontSize: FontDimen.dimen11,
// // //                     fontFamily: GoogleFonts.inter().fontFamily,
// // //                   ),
// // //                   maxLines: 1,
// // //                   overflow: TextOverflow.ellipsis,
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           const SizedBox(width: 10),
// // //           // Trailing (unread + time)
// // //           Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             crossAxisAlignment: CrossAxisAlignment.end,
// // //             children: [
// // //               const SizedBox(height: 6),
// // //               if ((chat.unreadMessages?[otherUser?.uId] ?? 0) > 0)
// // //                 Container(
// // //                   height: 18,
// // //                   width: 18,
// // //                   decoration: BoxDecoration(
// // //                     color: AppColors.primaryColor,
// // //                     borderRadius: BorderRadius.circular(100),
// // //                   ),
// // //                   child: Center(
// // //                     child: Text(
// // //                       '${chat.unreadMessages![otherUser!.uId]}',
// // //                       style: TextStyle(
// // //                         color: AppColors.whiteColor,
// // //                         fontWeight: FontWeight.w600,
// // //                         fontFamily: GoogleFonts.inter().fontFamily,
// // //                         fontSize: FontDimen.dimen13,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               const SizedBox(height: 6),
// // //               Text(
// // //                 chat.lastMessageTime != null
// // //                     ? DateFormat('h:mm a')
// // //                         .format(chat.lastMessageTime!.toDate())
// // //                     : ' ',
// // //                 style: TextStyle(
// // //                   color: AppColors.textColor3.withOpacity(0.2),
// // //                   fontWeight: FontWeight.w600,
// // //                   fontFamily: GoogleFonts.inter().fontFamily,
// // //                   fontSize: FontDimen.dimen11,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // // widgets/message_tile.dart
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../../../config/app_config.dart';
// // import '../../../utils/app_colors.dart';
// // import '../../../utils/app_dimen.dart';
// // import '../../user_profile/models/user_model.dart';
// // import '../models/chat_model.dart';
// //
// // class MessageTile extends StatelessWidget {
// //   final ChatModel chat;
// //   final UserProfileData? otherUser;
// //   final bool highlighted;
// //
// //   const MessageTile({
// //     Key? key,
// //     required this.chat,
// //     this.otherUser,
// //     this.highlighted = false,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final currentUserId = StorageHelper().getUserId.toString();
// //     final unreadCount = chat.unreadMessages?[currentUserId] ?? 0;
// //
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: highlighted
// //             ? AppColors.cardBgColor.withOpacity(0.5)
// //             : AppColors.cardBgColor.withOpacity(0.3),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         children: [
// //           // Profile Image
// //           Stack(
// //             children: [
// //               Container(
// //                 width: 50,
// //                 height: 50,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   border: Border.all(
// //                     color: AppColors.textColor4.withOpacity(0.3),
// //                     width: 2,
// //                   ),
// //                 ),
// //                 child: ClipOval(
// //                   child: CachedNetworkImage(
// //                     imageUrl: otherUser?.profile ?? '',
// //                     fit: BoxFit.cover,
// //                     placeholder: (context, url) => Container(
// //                       color: AppColors.greyShadeColor,
// //                     ),
// //                     errorWidget: (context, url, error) => Container(
// //                       color: AppColors.greyShadeColor,
// //                       child: Icon(
// //                         Icons.person,
// //                         color: AppColors.greyColor,
// //                         size: 30,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               // Online indicator (optional)
// //               if (otherUser != null)
// //                 Positioned(
// //                   right: 0,
// //                   bottom: 0,
// //                   child: Container(
// //                     width: 12,
// //                     height: 12,
// //                     decoration: BoxDecoration(
// //                       color: AppColors.greenColor,
// //                       shape: BoxShape.circle,
// //                       border: Border.all(
// //                         color: AppColors.scaffoldBackgroundColor,
// //                         width: 2,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           const SizedBox(width: 12),
// //
// //           // Message Info
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     // User Name
// //                     Expanded(
// //                       child: Text(
// //                         otherUser?.fullname ?? 'Unknown User',
// //                         style: GoogleFonts.inter(
// //                           color: AppColors.textColor3,
// //                           fontSize: FontDimen.dimen15,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                     // Time
// //                     Text(
// //                       _formatTime(chat.lastMessageTime),
// //                       style: GoogleFonts.inter(
// //                         color: AppColors.textColor3.withOpacity(0.5),
// //                         fontSize: FontDimen.dimen11,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 4),
// //
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     // Last Message
// //                     Expanded(
// //                       child: Text(
// //                         chat.lastMessage ?? '',
// //                         style: GoogleFonts.inter(
// //                           color: unreadCount > 0
// //                               ? AppColors.textColor3.withOpacity(0.9)
// //                               : AppColors.textColor3.withOpacity(0.6),
// //                           fontSize: FontDimen.dimen13,
// //                           fontWeight: unreadCount > 0
// //                               ? FontWeight.w500
// //                               : FontWeight.w400,
// //                         ),
// //                         overflow: TextOverflow.ellipsis,
// //                         maxLines: 1,
// //                       ),
// //                     ),
// //
// //                     // ✅ Unread Count Badge
// //                     if (unreadCount > 0)
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 8,
// //                           vertical: 4,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           gradient: LinearGradient(
// //                             colors: [
// //                               AppColors.primaryColor,
// //                               AppColors.primaryColorShade,
// //                             ],
// //                             begin: Alignment.topLeft,
// //                             end: Alignment.bottomRight,
// //                           ),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: Text(
// //                           unreadCount > 99 ? '99+' : unreadCount.toString(),
// //                           style: GoogleFonts.inter(
// //                             color: AppColors.whiteColor,
// //                             fontSize: FontDimen.dimen11,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   String _formatTime(dynamic timestamp) {
// //     if (timestamp == null) return '';
// //
// //     DateTime dateTime;
// //     if (timestamp is Timestamp) {
// //       dateTime = timestamp.toDate();
// //     } else {
// //       return '';
// //     }
// //
// //     final now = DateTime.now();
// //     final difference = now.difference(dateTime);
// //
// //     if (difference.inMinutes < 1) {
// //       return 'Just now';
// //     } else if (difference.inHours < 1) {
// //       return '${difference.inMinutes}m ago';
// //     } else if (difference.inHours < 24) {
// //       return '${difference.inHours}h ago';
// //     } else if (difference.inDays < 7) {
// //       return '${difference.inDays}d ago';
// //     } else {
// //       return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
// //     }
// //   }
// // }
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../config/app_config.dart';
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_dimen.dart';
// import '../../user_profile/models/user_model.dart';
// import '../models/chat_model.dart';
//
// class MessageTile extends StatelessWidget {
//   final ChatModel chat;
//   final UserProfileData? otherUser;
//   final bool highlighted;
//
//   const MessageTile({
//     Key? key,
//     required this.chat,
//     this.otherUser,
//     this.highlighted = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = StorageHelper().getUserId.toString();
//     final unreadCount = chat.unreadMessages?[currentUserId] ?? 0;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: highlighted
//             ? AppColors.cardBgColor.withOpacity(0.5)
//             : AppColors.cardBgColor.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           // Profile Image
//           Stack(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: AppColors.textColor4.withOpacity(0.3),
//                     width: 2,
//                   ),
//                 ),
//                 child: ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: otherUser?.profile ?? '',
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Container(
//                       color: AppColors.greyShadeColor,
//                     ),
//                     errorWidget: (context, url, error) => Container(
//                       color: AppColors.greyShadeColor,
//                       child: Icon(
//                         Icons.person,
//                         color: AppColors.greyColor,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               // Online indicator
//               if (otherUser != null)
//                 Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: AppColors.greenColor,
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: AppColors.scaffoldBackgroundColor,
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(width: 12),
//
//           // Message Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // User Name
//                     Expanded(
//                       child: Text(
//                         otherUser?.fullname ?? 'Unknown User',
//                         style: GoogleFonts.inter(
//                           color: AppColors.textColor3,
//                           fontSize: FontDimen.dimen15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     // Time
//                     Text(
//                       _formatTime(chat.lastMessageTime),
//                       style: GoogleFonts.inter(
//                         color: AppColors.textColor3.withOpacity(0.5),
//                         fontSize: FontDimen.dimen11,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Last Message
//                     Expanded(
//                       child: Text(
//                         chat.lastMessage,
//                         style: GoogleFonts.inter(
//                           color: unreadCount > 0
//                               ? AppColors.textColor3.withOpacity(0.9)
//                               : AppColors.textColor3.withOpacity(0.6),
//                           fontSize: FontDimen.dimen13,
//                           fontWeight: unreadCount > 0
//                               ? FontWeight.w500
//                               : FontWeight.w400,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ),
//
//                     // ✅ Unread Count Badge
//                     if (unreadCount > 0)
//                       Container(
//                         margin: const EdgeInsets.only(left: 8),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         constraints: BoxConstraints(
//                           minWidth: 22,
//                         ),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               AppColors.primaryColor,
//                               AppColors.primaryColorShade,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           unreadCount > 99 ? '99+' : unreadCount.toString(),
//                           style: GoogleFonts.inter(
//                             color: AppColors.whiteColor,
//                             fontSize: FontDimen.dimen11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatTime(dynamic timestamp) {
//     if (timestamp == null) return '';
//
//     DateTime dateTime;
//     if (timestamp is Timestamp) {
//       dateTime = timestamp.toDate();
//     } else {
//       return '';
//     }
//
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//
//     if (difference.inMinutes < 1) {
//       return 'Just now';
//     } else if (difference.inHours < 1) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays}d ago';
//     } else {
//       return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//     }
//   }
// }


//-----------


//
//
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
//   @override
//   Widget build(BuildContext context) {
//     final ChatController chatController = Get.find<ChatController>();
//
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
//           child: Obx(() {
//             final isRecording = chatController.isRecording.value;
//             final isRecordingCompleted = chatController.recordingDuration.value != '00:00' && !isRecording;
//             final hasText = widget.controller.text.trim().isNotEmpty;
//
//             return Row(
//               children: [
//                 // TextField with all icons inside
//                 Expanded(
//                   child: Container(
//                     height: AppDimens.dimen80,
//                     decoration: BoxDecoration(
//                       color: AppColors.cardBgColor,
//                       borderRadius: BorderRadius.circular(AppDimens.dimen16),
//                       border: Border.all(
//                         color: AppColors.textColor4.withOpacity(0.13),
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         // Left side buttons (Cancel when recording completed, Plus otherwise)
//                         if (isRecordingCompleted) ...[
//                           // Cancel button for recorded audio
//                           GestureDetector(
//                             onTap: () {
//                               // Cancel the recording
//                               chatController.cancelRecording();
//                               widget.controller.clear();
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: AppDimens.dimen12,
//                                 right: AppDimens.dimen8,
//                               ),
//                               child: Container(
//                                 width: AppDimens.dimen24,
//                                 height: AppDimens.dimen24,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.2),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Icon(
//                                     Icons.close,
//                                     color: Colors.red,
//                                     size: AppDimens.dimen16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ] else if (!isRecording) ...[
//                           // Plus icon (File picker) - only show when not recording
//                           GestureDetector(
//                             onTap: () async {
//                               await chatController.pickFileAndSend();
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: AppDimens.dimen12,
//                                 right: AppDimens.dimen8,
//                               ),
//                               child: Image.asset(
//                                 AppImages.plusBlueIcon,
//                                 height: AppDimens.dimen24,
//                                 width: AppDimens.dimen24,
//                               ),
//                             ),
//                           ),
//                         ] else if (isRecording) ...[
//                           // Recording indicator (red circle)
//                           Padding(
//                             padding: EdgeInsets.only(
//                               left: AppDimens.dimen12,
//                               right: AppDimens.dimen8,
//                             ),
//                             child: Container(
//                               width: AppDimens.dimen24,
//                               height: AppDimens.dimen24,
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Container(
//                                   width: AppDimens.dimen10,
//                                   height: AppDimens.dimen10,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//
//                         // TextField or Recording display
//                         Expanded(
//                           child: isRecording || isRecordingCompleted
//                               ? Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.mic,
//                                         color: Colors.red,
//                                         size: AppDimens.dimen20,
//                                       ),
//                                       SizedBox(width: AppDimens.dimen8),
//                                       Text(
//                                         chatController.recordingDuration.value,
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
//                               : TextField(
//                                   controller: widget.controller,
//                                   style: TextStyle(
//                                     color: AppColors.whiteColor.withOpacity(1),
//                                     fontFamily: GoogleFonts.inter().fontFamily,
//                                     fontSize: FontDimen.dimen12,
//                                   ),
//                                   onChanged: widget.onChanged,
//                                   decoration: InputDecoration(
//                                     hintText: AppStrings.chatInputHint,
//                                     hintStyle: TextStyle(
//                                       color: AppColors.textColor3.withOpacity(0.7),
//                                       fontFamily: GoogleFonts.inter().fontFamily,
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
//                         ),
//
//                         // Mic/Stop button
//                         GestureDetector(
//                           onTap: () async {
//                             if (!isRecording) {
//                               await chatController.startRecording();
//                             } else {
//                               await chatController.stopRecording();
//                             }
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: AppDimens.dimen8),
//                             child: Container(
//                               width: AppDimens.dimen26,
//                               height: AppDimens.dimen26,
//                               decoration: BoxDecoration(
//                                 color: isRecording ? Colors.red : AppColors.textColor4,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   isRecording ? Icons.stop : Icons.mic,
//                                   color: Colors.white,
//                                   size: AppDimens.dimen16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(width: AppDimens.dimen12),
//
//                         // Camera icon (only show when not recording and not recording completed)
//                         if (!isRecording && !isRecordingCompleted) ...[
//                           GestureDetector(
//                             onTap: () async {
//                               await chatController.pickImageAndSend();
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(right: AppDimens.dimen8),
//                               child: Image.asset(
//                                 AppImages.cameraBlueIcon,
//                                 height: AppDimens.dimen26,
//                                 width: AppDimens.dimen26,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: AppDimens.dimen6),
//                         ],
//
//                         // ALWAYS SHOW SEND BUTTON (disabled when empty)
//                         GestureDetector(
//                           onTap: () {
//                             if (isRecordingCompleted) {
//                               // Send the recorded audio
//                               chatController.sendRecordedAudio();
//                             } else if (hasText && !isRecording) {
//                               // Send text message
//                               widget.onSend();
//                             }
//                           },
//                           child: Container(
//                             width: 55,
//                             height: 55,
//                             decoration: BoxDecoration(
//                               color: (hasText && !isRecording) || isRecordingCompleted
//                                   ? AppColors.textColor4
//                                   : AppColors.textColor4.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: EdgeInsets.only(top: 3),
//                                 child: Image.asset(
//                                   AppImages.sendFilledIcon,
//                                   height: AppDimens.dimen35 - 2,
//                                   width: AppDimens.dimen35 - 2,
//                                   color: (hasText && !isRecording) || isRecordingCompleted
//                                       ? Colors.white
//                                       : Colors.white.withOpacity(0.5),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: AppDimens.dimen8),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
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
//               final isRecordingCompleted = chatController.recordingDuration.value != '00:00' && !isRecording;
//               final hasText = widget.controller.text.trim().isNotEmpty || chatController.inputText.value.trim().isNotEmpty;
//
//               return Row(
//                 children: [
//                   // TextField with all icons inside
//                   Expanded(
//                     child: Container(
//                       height: AppDimens.dimen80,
//                       decoration: BoxDecoration(
//                         color: AppColors.cardBgColor,
//                         borderRadius: BorderRadius.circular(AppDimens.dimen16),
//                         border: Border.all(
//                           color: AppColors.textColor4.withOpacity(0.13),
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           // Left side buttons (Cancel when recording completed, Plus otherwise)
//                           if (isRecordingCompleted) ...[
//                             // Cancel button for recorded audio
//                             GestureDetector(
//                               onTap: () {
//                                 // Cancel the recording
//                                 chatController.cancelRecording();
//                                 widget.controller.clear();
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   left: AppDimens.dimen12,
//                                   right: AppDimens.dimen8,
//                                 ),
//                                 child: Container(
//                                   width: AppDimens.dimen24,
//                                   height: AppDimens.dimen24,
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.withOpacity(0.2),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.close,
//                                       color: Colors.red,
//                                       size: AppDimens.dimen16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ] else if (!isRecording) ...[
//                             // Plus icon (File picker) - only show when not recording
//                             GestureDetector(
//                               onTap: () async {
//                                 await chatController.pickFileAndSend();
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   left: AppDimens.dimen12,
//                                   right: AppDimens.dimen8,
//                                 ),
//                                 child: Image.asset(
//                                   AppImages.plusBlueIcon,
//                                   height: AppDimens.dimen24,
//                                   width: AppDimens.dimen24,
//                                 ),
//                               ),
//                             ),
//                           ] else if (isRecording) ...[
//                             // Recording indicator (red circle)
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 left: AppDimens.dimen12,
//                                 right: AppDimens.dimen8,
//                               ),
//                               child: Container(
//                                 width: AppDimens.dimen24,
//                                 height: AppDimens.dimen24,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Container(
//                                     width: AppDimens.dimen10,
//                                     height: AppDimens.dimen10,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//
//                           // TextField or Recording display
//                           Expanded(
//                             child: isRecording || isRecordingCompleted
//                                 ? Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.mic,
//                                     color: Colors.red,
//                                     size: AppDimens.dimen20,
//                                   ),
//                                   SizedBox(width: AppDimens.dimen8),
//                                   Text(
//                                     chatController.recordingDuration.value,
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                       fontFamily: AppFonts.appFont,
//                                       fontSize: FontDimen.dimen16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   if (isRecording) ...[
//                                     SizedBox(width: AppDimens.dimen8),
//                                     Text(
//                                       'Recording...',
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                         fontFamily: AppFonts.appFont,
//                                         fontSize: FontDimen.dimen12,
//                                       ),
//                                     ),
//                                   ] else if (isRecordingCompleted) ...[
//                                     SizedBox(width: AppDimens.dimen8),
//                                     Text(
//                                       'Ready to send',
//                                       style: TextStyle(
//                                         color: AppColors.greenColor,
//                                         fontFamily: AppFonts.appFont,
//                                         fontSize: FontDimen.dimen12,
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             )
//                                 : TextField(
//                               controller: widget.controller,
//                               style: TextStyle(
//                                 color: AppColors.whiteColor.withOpacity(1),
//                                 fontFamily: GoogleFonts.inter().fontFamily,
//                                 fontSize: FontDimen.dimen12,
//                               ),
//                               onChanged: (value) {
//                                 // Update controller and trigger rebuild
//                                 chatController.inputText.value = value;
//                                 widget.onChanged(value);
//                               },
//                               decoration: InputDecoration(
//                                 hintText: AppStrings.chatInputHint,
//                                 hintStyle: TextStyle(
//                                   color: AppColors.textColor3.withOpacity(0.7),
//                                   fontFamily: GoogleFonts.inter().fontFamily,
//                                   fontSize: FontDimen.dimen12,
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 0,
//                                   vertical: AppDimens.dimen15,
//                                 ),
//                                 isDense: true,
//                               ),
//                             ),
//                           ),
//
//                           // Mic/Stop button
//                           GestureDetector(
//                             onTap: () async {
//                               if (!isRecording) {
//                                 await chatController.startRecording();
//                               } else {
//                                 await chatController.stopRecording();
//                               }
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: AppDimens.dimen8),
//                               child: Container(
//                                 width: AppDimens.dimen26,
//                                 height: AppDimens.dimen26,
//                                 decoration: BoxDecoration(
//                                   color: isRecording ? Colors.red : AppColors.textColor4,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: Icon(
//                                     isRecording ? Icons.stop : Icons.mic,
//                                     color: Colors.white,
//                                     size: AppDimens.dimen16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           SizedBox(width: AppDimens.dimen12),
//
//                           // Camera icon (only show when not recording and not recording completed)
//                           if (!isRecording && !isRecordingCompleted) ...[
//                             GestureDetector(
//                               onTap: () async {
//                                 await chatController.pickImageAndSend();
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.only(right: AppDimens.dimen8),
//                                 child: Image.asset(
//                                   AppImages.cameraBlueIcon,
//                                   height: AppDimens.dimen26,
//                                   width: AppDimens.dimen26,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: AppDimens.dimen6),
//                           ],
//
//                           // Send button
//                           GestureDetector(
//                             onTap: () {
//                               final currentText = widget.controller.text.trim();
//                               if (isRecordingCompleted) {
//                                 // Send the recorded audio
//                                 chatController.sendRecordedAudio();
//                               } else if (currentText.isNotEmpty && !isRecording) {
//                                 // Send text message
//                                 widget.onSend();
//                               }
//                             },
//                             child: Container(
//                               width: 55,
//                               height: 55,
//                               decoration: BoxDecoration(
//                                 color: (hasText && !isRecording) || isRecordingCompleted
//                                     ? AppColors.textColor4
//                                     : AppColors.textColor4.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.only(top: 3),
//                                   child: Image.asset(
//                                     AppImages.sendFilledIcon,
//                                     height: AppDimens.dimen35 - 2,
//                                     width: AppDimens.dimen35 - 2,
//                                     color: (hasText && !isRecording) || isRecordingCompleted
//                                         ? Colors.white
//                                         : Colors.white.withOpacity(0.5),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: AppDimens.dimen8),
//                         ],
//                       ),
//                     ),
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


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:the_friendz_zone/config/app_colors.dart';
// import 'package:the_friendz_zone/utils/app_dimen.dart';
// import 'package:the_friendz_zone/utils/app_fonts.dart';
// import '../../../helpers/storage_helper.dart';
// import '../models/message_model.dart';

// class ChatBubble extends StatelessWidget {
//   final Message message;
//   final String avatarUrl;

//   const ChatBubble({
//     required this.message,
//     required this.avatarUrl,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isMe = message.senderId == StorageHelper().getUserId.toString();

//     final bubbleColor = isMe ? AppColors.chatBubbleOther : AppColors.textColor4;
//     final textColor = AppColors.chatTextMe;

//     BorderRadius bubbleRadius = isMe
//         ? BorderRadius.only(
//             topLeft: Radius.circular(AppDimens.dimen16),
//             topRight: Radius.circular(AppDimens.dimen16),
//             bottomLeft: Radius.circular(AppDimens.dimen16),
//             bottomRight: Radius.circular(AppDimens.dimen4),
//           )
//         : BorderRadius.only(
//             topLeft: Radius.circular(AppDimens.dimen16),
//             topRight: Radius.circular(AppDimens.dimen16),
//             bottomLeft: Radius.circular(AppDimens.dimen4),
//             bottomRight: Radius.circular(AppDimens.dimen16),
//           );

//     Widget bubbleTail() {
//       return RotatedBox(
//         quarterTurns: isMe ? 3 : 1,
//         child: CustomPaint(
//           painter: _BubbleTailPainter(
//             color: bubbleColor,
//             isMe: isMe,
//           ),
//           size: Size(AppDimens.dimen14, AppDimens.dimen14),
//         ),
//       );
//     }

//     Widget bubbleWithTail(Widget bubble) {
//       return Stack(
//         clipBehavior: Clip.none,
//         children: [
//           bubble,
//           Positioned(
//             bottom: 0,
//             right: isMe ? -AppDimens.dimen5 : null,
//             left: isMe ? null : -AppDimens.dimen5,
//             child: bubbleTail(),
//           ),
//         ],
//       );
//     }

//     Widget bubble = Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppDimens.dimen16,
//         vertical: AppDimens.dimen14 - 0.2,
//       ),
//       decoration: BoxDecoration(
//         color: bubbleColor,
//         borderRadius: bubbleRadius,
//       ),
//       child: Text(
//         message.message,
//         style: TextStyle(
//           color: textColor,
//           fontSize: FontDimen.dimen13,
//           fontFamily: GoogleFonts.inter().fontFamily,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );

//     final timeStyle = TextStyle(
//       color: AppColors.textColor3.withOpacity(0.3),
//       fontSize: FontDimen.dimen11,
//       fontFamily: GoogleFonts.inter().fontFamily,
//     );

//     return Padding(
//       padding: EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 15),
//       child: Row(
//         mainAxisAlignment:
//             isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isMe)
//             Padding(
//               padding: EdgeInsets.only(
//                 right: AppDimens.dimen18,
//                 top: 4,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: CachedNetworkImage(
//                     imageUrl: avatarUrl,
//                     fit: BoxFit.cover,
//                     width: 33,
//                     height: 33,
//                     fadeInDuration: const Duration(milliseconds: 400),
//                     placeholder: (context, url) =>
//                         Container(color: AppColors.greyShadeColor),
//                     errorWidget: (context, url, error) => Container(
//                       color: AppColors.greyShadeColor,
//                       child: Icon(
//                         Icons.person,
//                         color: AppColors.greyColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           Flexible(
//             child: Column(
//               crossAxisAlignment:
//                   isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: [
//                 ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.55,
//                   ),
//                   child: bubbleWithTail(bubble),
//                 ),
//                 SizedBox(height: AppDimens.dimen4),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: isMe ? 0 : AppDimens.dimen2,
//                     right: isMe ? AppDimens.dimen2 : 0,
//                   ),
//                   child: Text(
//                     message.timestamp?.toDate().toLocal().toIso8601String() ??
//                         ' ',
//                     style: timeStyle,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isMe)
//             Padding(
//               padding: EdgeInsets.only(
//                 left: AppDimens.dimen18,
//                 top: 4,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: CachedNetworkImage(
//                     imageUrl: avatarUrl,
//                     fit: BoxFit.cover,
//                     width: 33,
//                     height: 33,
//                     fadeInDuration: const Duration(milliseconds: 400),
//                     placeholder: (context, url) =>
//                         Container(color: AppColors.greyShadeColor),
//                     errorWidget: (context, url, error) => Container(
//                       color: AppColors.greyShadeColor,
//                       child: Icon(
//                         Icons.person,
//                         color: AppColors.greyColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Custom painter for bubble tail
// class _BubbleTailPainter extends CustomPainter {
//   final Color color;
//   final bool isMe;

//   _BubbleTailPainter({required this.color, required this.isMe});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color;
//     final path = Path();
//     if (isMe) {
//       path.moveTo(0, 0);
//       path.lineTo(size.width, size.height / 2);
//       path.lineTo(0, size.height);
//     } else {
//       path.moveTo(size.width, 0);
//       path.lineTo(0, size.height / 2);
//       path.lineTo(size.width, size.height);
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_BubbleTailPainter oldDelegate) =>
//       oldDelegate.color != color || oldDelegate.isMe != isMe;
// }

