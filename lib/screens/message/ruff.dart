// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/utils/app_dimen.dart';
// import 'package:the_friendz_zone/utils/app_fonts.dart';
// import 'package:the_friendz_zone/utils/app_img.dart';
// import 'package:the_friendz_zone/utils/app_strings.dart';
// import '../audio_call/audio_call_screen.dart';
// import 'chat_controller.dart';
// import 'widgets/chat_bubble.dart';
// import 'widgets/chat_input_field.dart';

// class ChatScreen extends StatefulWidget {
//   final String userName;
//   final String userAvatar;
//   final bool isOnline;
//   final String? chatId;
//   final String otherUserId;
//   final bool isGroup;

//   const ChatScreen({
//     required this.userName,
//     required this.userAvatar,
//     this.isOnline = true,
//     this.chatId,
//     required this.otherUserId,
//     this.isGroup = false,
//     super.key,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late final ChatController controller;
//   final TextEditingController textController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(
//       ChatController(
//         chatId: widget.chatId,
//         otherUserId: widget.otherUserId,
//         otherUserName: widget.userName,
//         otherUserProfileUrl: widget.userAvatar,
//         isGroup: widget.isGroup,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(AppDimens.dimen100),
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//               AppDimens.dimen16,
//               AppDimens.dimen22,
//               AppDimens.dimen16,
//               AppDimens.dimen12,
//             ),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: SizedBox(
//                     width: AppDimens.dimen90,
//                     child: Padding(
//                       padding: EdgeInsets.only(right: AppDimens.dimen40),
//                       child: Image.asset(
//                         AppImages.backArrow,
//                         height: AppDimens.dimen14,
//                         width: AppDimens.dimen14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: AppColors.textColor4.withOpacity(1),
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: CachedNetworkImage(
//                       imageUrl: widget.userAvatar,
//                       fit: BoxFit.cover,
//                       width: AppDimens.dimen26,
//                       height: AppDimens.dimen26,
//                       fadeInDuration: const Duration(milliseconds: 400),
//                       placeholder: (context, url) =>
//                           Container(color: AppColors.greyShadeColor),
//                       errorWidget: (context, url, error) => Container(
//                         color: AppColors.greyShadeColor,
//                         child: Icon(
//                           Icons.person,
//                           color: AppColors.greyColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: AppDimens.dimen12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: AppDimens.dimen6),
//                       Text(
//                         widget.userName,
//                         style: TextStyle(
//                           color: AppColors.textColor3.withOpacity(1),
//                           fontWeight: FontWeight.w500,
//                           fontSize: FontDimen.dimen18,
//                           fontFamily: AppFonts.appFont,
//                           height: 0.9,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       MediaQuery.removePadding(
//                         context: context,
//                         removeTop: true,
//                         child: Row(
//                           children: [
//                             Container(
//                               width: AppDimens.dimen8,
//                               height: AppDimens.dimen8,
//                               decoration: BoxDecoration(
//                                 color: widget.isOnline
//                                     ? AppColors.greenColor
//                                     : AppColors.rejectBgColor,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             SizedBox(width: AppDimens.dimen6),
//                             Text(
//                               widget.isOnline
//                                   ? AppStrings.online
//                                   : AppStrings.offline,
//                               style: TextStyle(
//                                 color: AppColors.whiteColor.withOpacity(0.7),
//                                 fontSize: FontDimen.dimen11,
//                                 fontFamily: GoogleFonts.inter().fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.to(
//                         () => AudioCallScreen(
//                           userName: widget.userName,
//                           userAvatar: widget.userAvatar,
//                           isVideo: false,
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.callIcon,
//                       height: AppDimens.dimen26,
//                       width: AppDimens.dimen26,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.to(
//                         () => AudioCallScreen(
//                           userName: widget.userName,
//                           userAvatar: widget.userAvatar,
//                           isVideo: true,
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.videoIcon,
//                       height: AppDimens.dimen26,
//                       width: AppDimens.dimen26,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: Image.asset(
//                     AppImages.blockIcon,
//                     height: AppDimens.dimen26,
//                     width: AppDimens.dimen26,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
//             child: Container(
//               color: AppColors.textColor4,
//               height: AppDimens.dimen2,
//               width: double.infinity,
//             ),
//           ),
//           Expanded(
//             child: Obx(
//               () => ListView.separated(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppDimens.dimen16,
//                   vertical: AppDimens.dimen12 + AppDimens.dimen2,
//                 ),
//                 reverse: false,
//                 itemCount: controller.messages.length,
//                 separatorBuilder: (_, __) =>
//                     SizedBox(height: AppDimens.dimen16),
//                 itemBuilder: (context, index) {
//                   final message = controller.messages[index];
//                   return ChatBubble(
//                     message: message,
//                     avatarUrl: widget.userAvatar,
//                   );
//                 },
//               ),
//             ),
//           ),
//           SafeArea(
//             top: false,
//             child: ChatInputField(
//               controller: textController,
//               onChanged: (val) => controller.inputText.value = val,
//               onSend: () {
//                 controller.sendMessage(messageText: textController.text);
//                 textController.clear();
//               },
//             ),
//           ),
//         ],
//       ),
//       resizeToAvoidBottomInset: true,
//     );
//   }
// }


//



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/message/widgets/chat_input_field.dart';
// import 'package:the_friendz_zone/screens/user_profile/user_profile_screen.dart';
// import 'package:the_friendz_zone/utils/app_dimen.dart';
// import 'package:the_friendz_zone/utils/app_fonts.dart';
// import 'package:the_friendz_zone/utils/app_img.dart';
// import 'package:the_friendz_zone/utils/app_strings.dart';
//
// import '../audio_call/audio_call_screen.dart';
// import 'chat_controller.dart';
// import 'widgets/chat_bubble.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String userName;
//   final String userAvatar;
//   final bool isOnline;
//   final String? chatId;
//   final String otherUserId;
//   final bool isGroup;
//
//   const ChatScreen({
//     required this.userName,
//     required this.userAvatar,
//     this.isOnline = true,
//     this.chatId,
//     required this.otherUserId,
//     this.isGroup = false,
//     super.key,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late final ChatController controller;
//   final TextEditingController textController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(
//       ChatController(
//         chatId: widget.chatId,
//         otherUserId: widget.otherUserId,
//         otherUserName: widget.userName,
//         otherUserProfileUrl: widget.userAvatar,
//         isGroup: widget.isGroup,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(AppDimens.dimen100),
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//               AppDimens.dimen16,
//               AppDimens.dimen22,
//               AppDimens.dimen16,
//               AppDimens.dimen12,
//             ),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: SizedBox(
//                     width: AppDimens.dimen90,
//                     child: Padding(
//                       padding: EdgeInsets.only(right: AppDimens.dimen40),
//                       child: Image.asset(
//                         AppImages.backArrow,
//                         height: AppDimens.dimen14,
//                         width: AppDimens.dimen14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: AppColors.textColor4.withOpacity(1),
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: CachedNetworkImage(
//                       imageUrl: widget.userAvatar,
//                       fit: BoxFit.cover,
//                       width: AppDimens.dimen26,
//                       height: AppDimens.dimen26,
//                       fadeInDuration: const Duration(milliseconds: 400),
//                       placeholder: (context, url) =>
//                           Container(color: AppColors.greyShadeColor),
//                       errorWidget: (context, url, error) => Container(
//                         color: AppColors.greyShadeColor,
//                         child: Icon(
//                           Icons.person,
//                           color: AppColors.greyColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: AppDimens.dimen12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: AppDimens.dimen6),
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(
//                             () => UserProfileScreen(
//                               userId: widget.otherUserId,
//                             ),
//                           );
//                         },
//                         child: Text(
//                           widget.userName,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontWeight: FontWeight.w500,
//                             fontSize: FontDimen.dimen18,
//                             fontFamily: AppFonts.appFont,
//                             height: 0.9,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       MediaQuery.removePadding(
//                         context: context,
//                         removeTop: true,
//                         child: Row(
//                           children: [
//                             Container(
//                               width: AppDimens.dimen8,
//                               height: AppDimens.dimen8,
//                               decoration: BoxDecoration(
//                                 color: widget.isOnline
//                                     ? AppColors.greenColor
//                                     : AppColors.rejectBgColor,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             SizedBox(width: AppDimens.dimen6),
//                             Text(
//                               widget.isOnline
//                                   ? AppStrings.online
//                                   : AppStrings.offline,
//                               style: TextStyle(
//                                 color: AppColors.whiteColor.withOpacity(0.7),
//                                 fontSize: FontDimen.dimen11,
//                                 fontFamily: GoogleFonts.inter().fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.to(
//                         () => AudioCallScreen(
//                           userName: widget.userName,
//                           userAvatar: widget.userAvatar,
//                           isVideo: false,
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.callIcon,
//                       height: AppDimens.dimen26,
//                       width: AppDimens.dimen26,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.to(
//                         () => AudioCallScreen(
//                           userName: widget.userName,
//                           userAvatar: widget.userAvatar,
//                           isVideo: true,
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.videoIcon,
//                       height: AppDimens.dimen26,
//                       width: AppDimens.dimen26,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: Image.asset(
//                     AppImages.blockIcon,
//                     height: AppDimens.dimen26,
//                     width: AppDimens.dimen26,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
//             child: Container(
//               color: AppColors.textColor4,
//               height: AppDimens.dimen2,
//               width: double.infinity,
//             ),
//           ),
//           Expanded(
//             child: Obx(
//               () => ListView.separated(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppDimens.dimen16,
//                   vertical: AppDimens.dimen12 + AppDimens.dimen2,
//                 ),
//                 reverse: false,
//                 itemCount: controller.messages.length,
//                 separatorBuilder: (_, __) =>
//                     SizedBox(height: AppDimens.dimen16),
//                 itemBuilder: (context, index) {
//                   final message = controller.messages[index];
//                   return ChatBubble(
//                     message: message,
//                     avatarUrl: widget.userAvatar,
//                   );
//                 },
//               ),
//             ),
//           ),
//           SafeArea(
//             top: false,
//             child: ChatInputField(
//               controller: textController,
//               onChanged: (val) => controller.inputText.value = val,
//               onSend: () {
//                 if (textController.text.trim().isNotEmpty) {
//                   controller.sendMessage(
//                     messageText: textController.text,
//                     type: 'text', // Added required type parameter
//                   );
//                   textController.clear();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       resizeToAvoidBottomInset: true,
//     );
//   }
// }


//----------------

// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/home/home_controller.dart';
// import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
// import 'package:the_friendz_zone/screens/message/models/message_model.dart';
// import 'package:the_friendz_zone/screens/profile/profile_controller.dart';
// import 'package:the_friendz_zone/utils/firebase_utils.dart';

// class ChatController extends GetxController {
//   String? chatId;
//   final String otherUserId;
//   final String otherUserName;
//   final String otherUserProfileUrl;
//   final bool isGroup;

//   final String currentUserId = StorageHelper().getUserId.toString();
//   RxList<Message> messages = <Message>[].obs;
//   StreamSubscription? _messageSubscription;
//   RxString inputText = ''.obs;

//   ChatController({
//     this.chatId,
//     required this.otherUserId,
//     required this.otherUserName,
//     required this.otherUserProfileUrl,
//     this.isGroup = false,
//   });

//   @override
//   void onInit() {
//     super.onInit();
//     if (chatId != null) {
//       _initChatData();
//     }
//   }

//   @override
//   void onClose() {
//     _messageSubscription?.cancel();
//     super.onClose();
//   }

//   Future<void> sendMessage({required String messageText}) async {
//     if (messageText.trim().isEmpty) return;

//     try {
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }

//       final newMessage = Message(
//         senderId: currentUserId,
//         message: messageText,
//         readBy: [],
//         isSent: false,
//       );

//       messages.add(newMessage);
//       inputText.value = '';

//       await _writeNewMessage(newMessage);

//       final index = messages.indexOf(newMessage);
//       if (index != -1) {
//         messages[index] = newMessage..isSent = true;
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   Future<void> _initChatData() async {
//     _subscribeToMessages();
//   }

//   void _subscribeToMessages() {
//     if (chatId == null) return;

//     _messageSubscription?.cancel();

//     _messageSubscription = FirebaseFirestore.instance
//         .collection(FirebaseUtils.chats)
//         .doc(chatId!)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .listen((snapshot) async {
//       final newMessages = snapshot.docs.map((doc) {
//         return Message.fromMap(doc.data(), doc.id);
//       }).toList();

//       messages.value = newMessages;
//       await _markMessagesAsRead(chatId!);
//     });
//   }

//   Future<void> _writeNewMessage(Message message) async {
//     final chatRef =
//         FirebaseFirestore.instance.collection(FirebaseUtils.chats).doc(chatId);

//     final batch = FirebaseFirestore.instance.batch();

//     final messageRef = chatRef.collection('messages').doc();
//     batch.set(messageRef, message.toMap());

//     final chatUpdate = <String, dynamic>{
//       'lastMessage': message.message,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     };

//     if (!isGroup) {
//       chatUpdate['unreadMessages.$otherUserId'] = FieldValue.increment(1);
//     }

//     batch.update(chatRef, chatUpdate);

//     await batch.commit();
//   }

//   Future<void> _markMessagesAsRead(String chatId) async {
//     try {
//       final chatRef = FirebaseFirestore.instance
//           .collection(FirebaseUtils.chats)
//           .doc(chatId);

//       final allMessagesSnapshot = await chatRef
//           .collection('messages')
//           .where('senderId', isNotEqualTo: currentUserId)
//           .get();

//       if (allMessagesSnapshot.docs.isEmpty) return;

//       final batch = FirebaseFirestore.instance.batch();

//       for (final msgDoc in allMessagesSnapshot.docs) {
//         final msgData = msgDoc.data();
//         final readByList = List<String>.from(msgData['readBy'] ?? []);

//         if (!readByList.contains(currentUserId)) {
//           batch.update(msgDoc.reference, {
//             'readBy': FieldValue.arrayUnion([currentUserId]),
//           });
//         }
//       }

//       batch.update(chatRef, {'unreadMessages.$currentUserId': 0});

//       await batch.commit();
//     } catch (e) {
//       print('Error marking messages as read: $e');
//     }
//   }

//   Future<ChatModel> _createNewChat(String otherUserId) async {
//     try {
//       final participants = [currentUserId, otherUserId]..sort();
//       final chatId = participants.join('_');
//       final chatRef = FirebaseFirestore.instance
//           .collection(FirebaseUtils.chats)
//           .doc(chatId);

//       // Create participant data maps
//       final participantNames = {
//         otherUserId: otherUserName,
//       };
//       final participantProfileUrls = {
//         otherUserId: otherUserProfileUrl,
//       };

//       // Add current user data to the maps
//       participantNames[currentUserId] =
//           Get.find<HomeController>().userResponse.data?.fullname ?? "";
//       participantProfileUrls[currentUserId] =
//           Get.find<HomeController>().userResponse.data?.profile ?? "";

//       final chatModel = ChatModel(
//         chatId: chatRef.id,
//         isGroupChat: isGroup,
//         participantIds: [currentUserId, otherUserId],
//         participantNames: participantNames,
//         participantProfileUrls: participantProfileUrls,
//         lastMessage: '',
//       );

//       await chatRef.set(chatModel.toMap());
//       return chatModel;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _storeUserDataInFirebase(
//       String userId, String userName, String profileUrl) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection(FirebaseUtils.users)
//           .doc(userId)
//           .set({
//         'id': userId,
//         'fullname': userName,
//         'profile': profileUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     } catch (e) {
//       print('Error storing user data in Firebase: $e');
//     }
//   }
// }
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/message/widgets/chat_input_field.dart';
// import 'package:the_friendz_zone/screens/user_profile/user_profile_screen.dart';
// import 'package:the_friendz_zone/utils/app_dimen.dart';
// import 'package:the_friendz_zone/utils/app_fonts.dart';
// import 'package:the_friendz_zone/utils/app_img.dart';
// import 'package:the_friendz_zone/utils/app_strings.dart';
//
// import '../audio_call/audio_call_screen.dart';
// import 'chat_controller.dart';
// import 'widgets/chat_bubble.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String userName;
//   final String userAvatar;
//   final bool isOnline;
//   final String? chatId;
//   final String otherUserId;
//   final bool isGroup;
//
//   const ChatScreen({
//     required this.userName,
//     required this.userAvatar,
//     this.isOnline = true,
//     this.chatId,
//     required this.otherUserId,
//     this.isGroup = false,
//     super.key,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late final ChatController controller;
//   final TextEditingController textController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(
//       ChatController(
//         chatId: widget.chatId,
//         otherUserId: widget.otherUserId,
//         otherUserName: widget.userName,
//         otherUserProfileUrl: widget.userAvatar,
//         isGroup: widget.isGroup,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(AppDimens.dimen100),
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//               AppDimens.dimen16,
//               AppDimens.dimen22,
//               AppDimens.dimen16,
//               AppDimens.dimen12,
//             ),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: SizedBox(
//                     width: AppDimens.dimen90,
//                     child: Padding(
//                       padding: EdgeInsets.only(right: AppDimens.dimen40),
//                       child: Image.asset(
//                         AppImages.backArrow,
//                         height: AppDimens.dimen14,
//                         width: AppDimens.dimen14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: AppColors.textColor4.withOpacity(1),
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: CachedNetworkImage(
//                       imageUrl: widget.userAvatar,
//                       fit: BoxFit.cover,
//                       width: AppDimens.dimen26,
//                       height: AppDimens.dimen26,
//                       fadeInDuration: const Duration(milliseconds: 400),
//                       placeholder: (context, url) =>
//                           Container(color: AppColors.greyShadeColor),
//                       errorWidget: (context, url, error) => Container(
//                         color: AppColors.greyShadeColor,
//                         child: Icon(
//                           Icons.person,
//                           color: AppColors.greyColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: AppDimens.dimen12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(height: AppDimens.dimen6),
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(
//                                 () => UserProfileScreen(
//                               userId: widget.otherUserId,
//                             ),
//                           );
//                         },
//                         child: Text(
//                           widget.userName,
//                           style: TextStyle(
//                             color: AppColors.textColor3.withOpacity(1),
//                             fontWeight: FontWeight.w500,
//                             fontSize: FontDimen.dimen18,
//                             fontFamily: AppFonts.appFont,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       MediaQuery.removePadding(
//                         context: context,
//                         removeTop: true,
//                         child: Row(
//                           children: [
//                             Container(
//                               width: AppDimens.dimen8,
//                               height: AppDimens.dimen8,
//                               decoration: BoxDecoration(
//                                 color: widget.isOnline
//                                     ? AppColors.greenColor
//                                     : AppColors.rejectBgColor,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             SizedBox(width: AppDimens.dimen6),
//                             Text(
//                               widget.isOnline
//                                   ? AppStrings.online
//                                   : AppStrings.offline,
//                               style: TextStyle(
//                                 color: AppColors.whiteColor.withOpacity(0.7),
//                                 fontSize: FontDimen.dimen11,
//                                 fontFamily: GoogleFonts.inter().fontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Audio Call Button
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.to(
//                             () => AudioCallScreen(
//                           userName: widget.userName,
//                           userAvatar: widget.userAvatar,
//                           receiverId: widget.otherUserId, // Pass receiver ID
//                           isVideo: false,
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.callIcon,
//                       height: AppDimens.dimen26,
//                       width: AppDimens.dimen26,
//                     ),
//                   ),
//                 ),
//                 // Video Call Button
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.to(
//                             () => AudioCallScreen(
//                           userName: widget.userName,
//                           userAvatar: widget.userAvatar,
//                           receiverId: widget.otherUserId, // Pass receiver ID
//                           isVideo: true,
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.videoIcon,
//                       height: AppDimens.dimen26,
//                       width: AppDimens.dimen26,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
//                   child: Image.asset(
//                     AppImages.blockIcon,
//                     height: AppDimens.dimen26,
//                     width: AppDimens.dimen26,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
//             child: Container(
//               color: AppColors.textColor4,
//               height: AppDimens.dimen2,
//               width: double.infinity,
//             ),
//           ),
//           Expanded(
//             child: Obx(
//                   () => ListView.separated(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppDimens.dimen16,
//                   vertical: AppDimens.dimen12 + AppDimens.dimen2,
//                 ),
//                 reverse: false,
//                 itemCount: controller.messages.length,
//                 separatorBuilder: (_, __) =>
//                     SizedBox(height: AppDimens.dimen16),
//                 itemBuilder: (context, index) {
//                   final message = controller.messages[index];
//                   return ChatBubble(
//                     message: message,
//                     avatarUrl: widget.userAvatar,
//                   );
//                 },
//               ),
//             ),
//           ),
//           SafeArea(
//             top: false,
//             child: ChatInputField(
//               controller: textController,
//               onChanged: (val) => controller.inputText.value = val,
//               onSend: () {
//                 if (textController.text.trim().isNotEmpty) {
//                   controller.sendMessage(
//                     messageText: textController.text,
//                     type: 'text',
//                   );
//                   textController.clear();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       resizeToAvoidBottomInset: true,
//     );
//   }
// }
