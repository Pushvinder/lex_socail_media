// //
// // import 'dart:async';
// // import 'dart:io';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:record/record.dart';
// //
// // import 'package:the_friendz_zone/config/app_config.dart';
// // import 'package:the_friendz_zone/screens/home/home_controller.dart';
// // import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
// // import 'package:the_friendz_zone/screens/message/models/message_model.dart';
// // import 'package:the_friendz_zone/screens/profile/profile_controller.dart';
// // import 'package:the_friendz_zone/utils/firebase_utils.dart';
// //
// // class ChatController extends GetxController {
// //   String? chatId;
// //   final String otherUserId;
// //   final String otherUserName;
// //   final String otherUserProfileUrl;
// //   final bool isGroup;
// //
// //   final String currentUserId = StorageHelper().getUserId.toString();
// //   RxList<Message> messages = <Message>[].obs;
// //   StreamSubscription? _messageSubscription;
// //   RxString inputText = ''.obs;
// //
// //   final ScrollController scrollController = ScrollController();
// //   final ImagePicker _imagePicker = ImagePicker();
// //   RxBool isRecording = false.obs;
// //   RxString recordingDuration = '00:00'.obs;
// //   Timer? _recordingTimer;
// //   int _recordingSeconds = 0;
// //
// //   // Audio recording variables
// //   late final AudioRecorder _audioRecorder;
// //   String? _recordedAudioPath;
// //   File? _recordedAudioFile;
// //
// //   ChatController({
// //     this.chatId,
// //     required this.otherUserId,
// //     required this.otherUserName,
// //     required this.otherUserProfileUrl,
// //     this.isGroup = false,
// //   }) {
// //     _audioRecorder = AudioRecorder();
// //   }
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     if (chatId != null) {
// //       _initChatData();
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     _messageSubscription?.cancel();
// //     scrollController.dispose();
// //     _recordingTimer?.cancel();
// //     _audioRecorder.dispose();
// //     super.onClose();
// //   }
// //
// //   void scrollToBottom({bool animate = true}) {
// //     if (!scrollController.hasClients) return;
// //     final position = scrollController.position.maxScrollExtent;
// //     if (animate) {
// //       scrollController.animateTo(
// //         position,
// //         duration: const Duration(milliseconds: 250),
// //         curve: Curves.easeOut,
// //       );
// //     } else {
// //       scrollController.jumpTo(position);
// //     }
// //   }
// //
// //   // ===================== TEXT MESSAGE =====================
// //   Future<void> sendMessage({
// //     required String messageText,
// //     required String type,
// //     String? mediaUrl,
// //     String? fileName,
// //   }) async {
// //     if (messageText.trim().isEmpty && mediaUrl == null) return;
// //
// //     try {
// //       if (chatId == null) {
// //         final newChat = await _createNewChat(otherUserId);
// //         chatId = newChat.chatId;
// //         _initChatData();
// //       }
// //
// //       final newMessage = Message(
// //         senderId: currentUserId,
// //         message: messageText.trim(),
// //         type: type,
// //         mediaUrl: mediaUrl,
// //         fileName: fileName,
// //         readBy: [],
// //         isSent: false,
// //         timestamp: Timestamp.now(),
// //         isMedia: mediaUrl != null,
// //       );
// //
// //       messages.add(newMessage);
// //       inputText.value = '';
// //
// //       await _writeNewMessage(newMessage);
// //
// //       final index = messages.indexOf(newMessage);
// //       if (index != -1) {
// //         messages[index] = newMessage.copyWith(isSent: true);
// //       }
// //
// //       scrollToBottom();
// //     } catch (e) {
// //       print('Error sending message: $e');
// //     }
// //   }
// //
// //   // ===================== SEND RECORDED AUDIO =====================
// //   Future<void> sendRecordedAudio() async {
// //     if (_recordedAudioPath == null || _recordedAudioFile == null) {
// //       print("No recorded audio to send");
// //       return;
// //     }
// //
// //     try {
// //       if (chatId == null) {
// //         final newChat = await _createNewChat(otherUserId);
// //         chatId = newChat.chatId;
// //         _initChatData();
// //       }
// //
// //       final url = await _uploadFileToStorage(
// //         file: _recordedAudioFile!,
// //         path:
// //             'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
// //       );
// //
// //       await sendMessage(
// //         messageText: 'Audio message',
// //         type: 'audio',
// //         mediaUrl: url,
// //         fileName: 'Audio',
// //       );
// //
// //       print("Audio Sent Successfully --> $url");
// //
// //       // Reset recording state
// //       _resetRecordingState();
// //     } catch (e) {
// //       print("Error sending recorded audio: $e");
// //     }
// //   }
// //
// //   void _resetRecordingState() {
// //     _recordedAudioPath = null;
// //     _recordedAudioFile = null;
// //     recordingDuration.value = '00:00';
// //   }
// //
// //   // ===================== VOICE RECORDING =====================
// //   Future<void> startRecording() async {
// //     try {
// //       // Check permissions
// //       if (!await _audioRecorder.hasPermission()) {
// //         print("Microphone permission denied");
// //         return;
// //       }
// //
// //       if (chatId == null) {
// //         final newChat = await _createNewChat(otherUserId);
// //         chatId = newChat.chatId;
// //         _initChatData();
// //       }
// //
// //       // Configure audio recording
// //       const config = RecordConfig(
// //         encoder: AudioEncoder.aacLc,
// //         bitRate: 128000,
// //         sampleRate: 44100,
// //       );
// //
// //       // Get temp directory for recording
// //       final tempDir = await getTemporaryDirectory();
// //       _recordedAudioPath =
// //           '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
// //
// //       // Start recording
// //       await _audioRecorder.start(config, path: _recordedAudioPath!);
// //
// //       // Start timer
// //       isRecording.value = true;
// //       _recordingSeconds = 0;
// //       _startRecordingTimer();
// //
// //       print("Recording Started... Path: $_recordedAudioPath");
// //     } catch (e) {
// //       print("Recording Error: $e");
// //       isRecording.value = false;
// //     }
// //   }
// //
// //   Future<void> stopRecording() async {
// //     try {
// //       _recordingTimer?.cancel();
// //       isRecording.value = false;
// //
// //       // Stop recording and get file path
// //       final String? path = await _audioRecorder.stop();
// //       if (path == null) {
// //         print("No audio recorded");
// //         _resetRecordingState();
// //         return;
// //       }
// //
// //       _recordedAudioFile = File(path);
// //       print("Recording stopped. File saved at: $path");
// //
// //       // Keep the recording ready for sending
// //       // Don't reset the duration so user can see how long they recorded
// //     } catch (e) {
// //       print("Stop Recording Error: $e");
// //       _resetRecordingState();
// //     }
// //   }
// //
// //   void _startRecordingTimer() {
// //     _recordingTimer?.cancel();
// //     _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
// //       _recordingSeconds++;
// //       final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
// //       final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
// //       recordingDuration.value = '$minutes:$seconds';
// //     });
// //   }
// //
// //   // ===================== INIT / LISTENER =====================
// //   Future<void> _initChatData() async {
// //     _subscribeToMessages();
// //   }
// //
// //   void _subscribeToMessages() {
// //     if (chatId == null) return;
// //
// //     _messageSubscription?.cancel();
// //
// //     _messageSubscription = FirebaseFirestore.instance
// //         .collection(FirebaseUtils.chats)
// //         .doc(chatId!)
// //         .collection('messages')
// //         .orderBy('timestamp', descending: false)
// //         .snapshots()
// //         .listen((snapshot) async {
// //       final newMessages = snapshot.docs.map((doc) {
// //         return Message.fromMap(doc.data(), doc.id);
// //       }).toList();
// //
// //       messages.value = newMessages;
// //       await _markMessagesAsRead(chatId!);
// //
// //       Future.delayed(const Duration(milliseconds: 100), () {
// //         scrollToBottom();
// //       });
// //     });
// //   }
// //
// //   // ===================== FIRESTORE WRITE =====================
// //   Future<void> _writeNewMessage(Message message) async {
// //     final chatRef =
// //         FirebaseFirestore.instance.collection(FirebaseUtils.chats).doc(chatId);
// //
// //     final batch = FirebaseFirestore.instance.batch();
// //
// //     final messageRef = chatRef.collection('messages').doc();
// //     batch.set(messageRef, message.toMap());
// //
// //     String lastMessageText = '';
// //     if (message.message.isNotEmpty) {
// //       lastMessageText = message.message;
// //     } else if (message.type == 'image') {
// //       lastMessageText = '📷 Photo';
// //     } else if (message.type == 'file') {
// //       lastMessageText = '📎 ${message.fileName ?? 'File'}';
// //     } else if (message.type == 'audio') {
// //       lastMessageText = '🎤 Audio';
// //     }
// //
// //     final chatUpdate = <String, dynamic>{
// //       'lastMessage': lastMessageText,
// //       'lastMessageTime': FieldValue.serverTimestamp(),
// //     };
// //
// //     if (!isGroup) {
// //       chatUpdate['unreadMessages.$otherUserId'] = FieldValue.increment(1);
// //     }
// //
// //     batch.update(chatRef, chatUpdate);
// //
// //     await batch.commit();
// //   }
// //
// //   Future<void> _markMessagesAsRead(String chatId) async {
// //     try {
// //       final chatRef = FirebaseFirestore.instance
// //           .collection(FirebaseUtils.chats)
// //           .doc(chatId);
// //
// //       final allMessagesSnapshot = await chatRef.collection('messages').get();
// //
// //       if (allMessagesSnapshot.docs.isEmpty) return;
// //
// //       final batch = FirebaseFirestore.instance.batch();
// //       bool hasUnread = false;
// //
// //       for (final msgDoc in allMessagesSnapshot.docs) {
// //         final msgData = msgDoc.data();
// //         final senderId = msgData['senderId'];
// //         final readBy = List<String>.from(msgData['readBy'] ?? []);
// //
// //         if (senderId != currentUserId && !readBy.contains(currentUserId)) {
// //           batch.update(msgDoc.reference, {
// //             'readBy': FieldValue.arrayUnion([currentUserId]),
// //           });
// //           hasUnread = true;
// //         }
// //       }
// //
// //       if (hasUnread) {
// //         batch.update(chatRef, {'unreadMessages.$currentUserId': 0});
// //       }
// //
// //       await batch.commit();
// //     } catch (e) {
// //       print('Error marking messages as read: $e');
// //     }
// //   }
// //
// //   // ===================== IMAGE FROM CAMERA =====================
// //   Future<void> pickImageAndSend() async {
// //     try {
// //       final pickedFile = await _imagePicker.pickImage(
// //           source: ImageSource.camera, imageQuality: 80);
// //       if (pickedFile == null) return;
// //
// //       if (chatId == null) {
// //         final newChat = await _createNewChat(otherUserId);
// //         chatId = newChat.chatId;
// //         _initChatData();
// //       }
// //
// //       final file = File(pickedFile.path);
// //       final url = await _uploadFileToStorage(
// //         file: file,
// //         path:
// //             'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
// //       );
// //
// //       await sendMessage(
// //         messageText: '',
// //         type: 'image',
// //         mediaUrl: url,
// //         fileName: 'Photo',
// //       );
// //     } catch (e) {
// //       print('Error picking image: $e');
// //     }
// //   }
// //
// //   // ===================== FILE PICKER =====================
// //   Future<void> pickFileAndSend() async {
// //     try {
// //       final result = await FilePicker.platform.pickFiles(
// //         allowMultiple: false,
// //       );
// //       if (result == null || result.files.single.path == null) return;
// //
// //       if (chatId == null) {
// //         final newChat = await _createNewChat(otherUserId);
// //         chatId = newChat.chatId;
// //         _initChatData();
// //       }
// //
// //       final file = File(result.files.single.path!);
// //       final fileName = result.files.single.name;
// //
// //       final url = await _uploadFileToStorage(
// //         file: file,
// //         path:
// //             'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName',
// //       );
// //
// //       await sendMessage(
// //         messageText: fileName,
// //         type: 'file',
// //         mediaUrl: url,
// //         fileName: fileName,
// //       );
// //     } catch (e) {
// //       print('Error picking file: $e');
// //     }
// //   }
// //
// //   // ===================== STORAGE UPLOAD =====================
// //   Future<String> _uploadFileToStorage({
// //     required File file,
// //     required String path,
// //   }) async {
// //     final ref = FirebaseStorage.instance.ref().child(path);
// //     final uploadTask = await ref.putFile(file);
// //     final url = await uploadTask.ref.getDownloadURL();
// //     return url;
// //   }
// //
// //   // ===================== CREATE CHAT =====================
// //   Future<ChatModel> _createNewChat(String otherUserId) async {
// //     try {
// //       final participants = [currentUserId, otherUserId]..sort();
// //       final chatId = participants.join('_');
// //       final chatRef = FirebaseFirestore.instance
// //           .collection(FirebaseUtils.chats)
// //           .doc(chatId);
// //
// //       // Check if chat already exists
// //       final existingChat = await chatRef.get();
// //       if (existingChat.exists) {
// //         return ChatModel.fromJson(existingChat.data()!);
// //       }
// //
// //       // ✅ Store both users' data in Firebase users collection
// //       await _storeUserDataInFirebase(
// //         otherUserId,
// //         otherUserName,
// //         otherUserProfileUrl,
// //       );
// //
// //       // Also store current user data
// //       final currentUserName = Get.find<HomeController>().userResponse.data?.fullname ?? "";
// //       final currentUserProfile = Get.find<HomeController>().userResponse.data?.profile ?? "";
// //       await _storeUserDataInFirebase(
// //         currentUserId,
// //         currentUserName,
// //         currentUserProfile,
// //       );
// //
// //       final participantNames = {
// //         otherUserId: otherUserName,
// //         currentUserId: currentUserName,
// //       };
// //
// //       final participantProfileUrls = {
// //         otherUserId: otherUserProfileUrl,
// //         currentUserId: currentUserProfile,
// //       };
// //
// //       final chatModel = ChatModel(
// //         chatId: chatId,
// //         isGroupChat: isGroup,
// //         participantIds: [currentUserId, otherUserId],
// //         participantNames: participantNames,
// //         participantProfileUrls: participantProfileUrls,
// //         lastMessage: '',
// //         lastMessageTime: Timestamp.now(),
// //         unreadMessages: {
// //           currentUserId: 0,
// //           otherUserId: 0,
// //         },
// //       );
// //
// //       await chatRef.set(chatModel.toMap());
// //       return chatModel;
// //     } catch (e) {
// //       print('Error creating new chat: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Add this method to your ChatController class
// //   void cancelRecording() {
// //     // Stop the recording timer
// //     _recordingTimer?.cancel();
// //
// //     // Reset all recording states
// //     isRecording.value = false;
// //     recordingDuration.value = '00:00';
// //     _recordingSeconds = 0;
// //     _recordedAudioPath = null;
// //     _recordedAudioFile = null;
// //
// //     print("Recording cancelled");
// //   }
// //
// //   Future<void> _storeUserDataInFirebase(
// //       String userId, String userName, String profileUrl) async {
// //     try {
// //       await FirebaseFirestore.instance
// //           .collection(FirebaseUtils.users)
// //           .doc(userId)
// //           .set({
// //         'id': userId,
// //         'fullname': userName,
// //         'profile': profileUrl,
// //         'createdAt': FieldValue.serverTimestamp(),
// //       }, SetOptions(merge: true));
// //     } catch (e) {
// //       print('Error storing user data in Firebase: $e');
// //     }
// //   }
// // }
// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
//
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/home/home_controller.dart';
// import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
// import 'package:the_friendz_zone/screens/message/models/message_model.dart';
// import 'package:the_friendz_zone/utils/firebase_utils.dart';
//
// class ChatController extends GetxController {
//   String? chatId;
//   final String otherUserId;
//   final String otherUserName;
//   final String otherUserProfileUrl;
//   final bool isGroup;
//
//   final String currentUserId = StorageHelper().getUserId.toString();
//   RxList<Message> messages = <Message>[].obs;
//   StreamSubscription? _messageSubscription;
//   RxString inputText = ''.obs;
//
//   final ScrollController scrollController = ScrollController();
//   final ImagePicker _imagePicker = ImagePicker();
//   RxBool isRecording = false.obs;
//   RxString recordingDuration = '00:00'.obs;
//   Timer? _recordingTimer;
//   int _recordingSeconds = 0;
//
//   // Audio recording variables
//   late final AudioRecorder _audioRecorder;
//   String? _recordedAudioPath;
//   File? _recordedAudioFile;
//
//   ChatController({
//     this.chatId,
//     required this.otherUserId,
//     required this.otherUserName,
//     required this.otherUserProfileUrl,
//     this.isGroup = false,
//   }) {
//     _audioRecorder = AudioRecorder();
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     if (chatId != null) {
//       _initChatData();
//       // ✅ Mark messages as read when chat opens
//       Future.delayed(Duration(milliseconds: 500), () {
//         _markMessagesAsRead(chatId!);
//       });
//     }
//   }
//
//   @override
//   void onClose() {
//     _messageSubscription?.cancel();
//     scrollController.dispose();
//     _recordingTimer?.cancel();
//     _audioRecorder.dispose();
//     super.onClose();
//   }
//
//   void scrollToBottom({bool animate = true}) {
//     if (!scrollController.hasClients) return;
//     final position = scrollController.position.maxScrollExtent;
//     if (animate) {
//       scrollController.animateTo(
//         position,
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//       );
//     } else {
//       scrollController.jumpTo(position);
//     }
//   }
//
//   // ===================== TEXT MESSAGE =====================
//   Future<void> sendMessage({
//     required String messageText,
//     required String type,
//     String? mediaUrl,
//     String? fileName,
//   }) async {
//     if (messageText.trim().isEmpty && mediaUrl == null) return;
//
//     try {
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final newMessage = Message(
//         senderId: currentUserId,
//         message: messageText.trim(),
//         type: type,
//         mediaUrl: mediaUrl,
//         fileName: fileName,
//         readBy: [currentUserId], // ✅ Mark as read by sender
//         isSent: false,
//         timestamp: Timestamp.now(),
//         isMedia: mediaUrl != null,
//       );
//
//       messages.add(newMessage);
//       inputText.value = '';
//
//       await _writeNewMessage(newMessage);
//
//       final index = messages.indexOf(newMessage);
//       if (index != -1) {
//         messages[index] = newMessage.copyWith(isSent: true);
//       }
//
//       scrollToBottom();
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
//
//   // ===================== SEND RECORDED AUDIO =====================
//   Future<void> sendRecordedAudio() async {
//     if (_recordedAudioPath == null || _recordedAudioFile == null) {
//       print("No recorded audio to send");
//       return;
//     }
//
//     try {
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final url = await _uploadFileToStorage(
//         file: _recordedAudioFile!,
//         path:
//         'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
//       );
//
//       await sendMessage(
//         messageText: 'Audio message',
//         type: 'audio',
//         mediaUrl: url,
//         fileName: 'Audio',
//       );
//
//       print("Audio Sent Successfully --> $url");
//       _resetRecordingState();
//     } catch (e) {
//       print("Error sending recorded audio: $e");
//     }
//   }
//
//   void _resetRecordingState() {
//     _recordedAudioPath = null;
//     _recordedAudioFile = null;
//     recordingDuration.value = '00:00';
//   }
//
//   // ===================== VOICE RECORDING =====================
//   Future<void> startRecording() async {
//     try {
//       if (!await _audioRecorder.hasPermission()) {
//         print("Microphone permission denied");
//         return;
//       }
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       const config = RecordConfig(
//         encoder: AudioEncoder.aacLc,
//         bitRate: 128000,
//         sampleRate: 44100,
//       );
//
//       final tempDir = await getTemporaryDirectory();
//       _recordedAudioPath =
//       '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//       await _audioRecorder.start(config, path: _recordedAudioPath!);
//
//       isRecording.value = true;
//       _recordingSeconds = 0;
//       _startRecordingTimer();
//
//       print("Recording Started... Path: $_recordedAudioPath");
//     } catch (e) {
//       print("Recording Error: $e");
//       isRecording.value = false;
//     }
//   }
//
//   Future<void> stopRecording() async {
//     try {
//       _recordingTimer?.cancel();
//       isRecording.value = false;
//
//       final String? path = await _audioRecorder.stop();
//       if (path == null) {
//         print("No audio recorded");
//         _resetRecordingState();
//         return;
//       }
//
//       _recordedAudioFile = File(path);
//       print("Recording stopped. File saved at: $path");
//     } catch (e) {
//       print("Stop Recording Error: $e");
//       _resetRecordingState();
//     }
//   }
//
//   void _startRecordingTimer() {
//     _recordingTimer?.cancel();
//     _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _recordingSeconds++;
//       final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
//       recordingDuration.value = '$minutes:$seconds';
//     });
//   }
//
//   // ===================== INIT / LISTENER =====================
//   Future<void> _initChatData() async {
//     _subscribeToMessages();
//   }
//
//   void _subscribeToMessages() {
//     if (chatId == null) return;
//
//     _messageSubscription?.cancel();
//
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
//
//       messages.value = newMessages;
//
//       // ✅ Automatically mark messages as read when viewing
//       await _markMessagesAsRead(chatId!);
//
//       Future.delayed(const Duration(milliseconds: 100), () {
//         scrollToBottom();
//       });
//     });
//   }
//
//   // ===================== FIRESTORE WRITE =====================
//   Future<void> _writeNewMessage(Message message) async {
//     final chatRef =
//     FirebaseFirestore.instance.collection(FirebaseUtils.chats).doc(chatId);
//
//     final batch = FirebaseFirestore.instance.batch();
//
//     final messageRef = chatRef.collection('messages').doc();
//     batch.set(messageRef, message.toMap());
//
//     String lastMessageText = '';
//     if (message.message.isNotEmpty) {
//       lastMessageText = message.message;
//     } else if (message.type == 'image') {
//       lastMessageText = '📷 Photo';
//     } else if (message.type == 'file') {
//       lastMessageText = '📎 ${message.fileName ?? 'File'}';
//     } else if (message.type == 'audio') {
//       lastMessageText = '🎤 Audio';
//     }
//
//     final chatUpdate = <String, dynamic>{
//       'lastMessage': lastMessageText,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     };
//
//     // ✅ Only increment unread count for OTHER user (receiver)
//     if (!isGroup) {
//       chatUpdate['unreadMessages.$otherUserId'] = FieldValue.increment(1);
//     }
//
//     batch.update(chatRef, chatUpdate);
//
//     await batch.commit();
//   }
//
//   Future<void> _markMessagesAsRead(String chatId) async {
//     try {
//       final chatRef = FirebaseFirestore.instance
//           .collection(FirebaseUtils.chats)
//           .doc(chatId);
//
//       // Get unread messages
//       final allMessagesSnapshot = await chatRef
//           .collection('messages')
//           .where('senderId', isNotEqualTo: currentUserId)
//           .get();
//
//       if (allMessagesSnapshot.docs.isEmpty) return;
//
//       final batch = FirebaseFirestore.instance.batch();
//       bool hasUnread = false;
//
//       for (final msgDoc in allMessagesSnapshot.docs) {
//         final msgData = msgDoc.data();
//         final readBy = List<String>.from(msgData['readBy'] ?? []);
//
//         if (!readBy.contains(currentUserId)) {
//           batch.update(msgDoc.reference, {
//             'readBy': FieldValue.arrayUnion([currentUserId]),
//           });
//           hasUnread = true;
//         }
//       }
//
//       // ✅ Reset unread count to 0 for current user
//       if (hasUnread) {
//         batch.update(chatRef, {'unreadMessages.$currentUserId': 0});
//       }
//
//       await batch.commit();
//       print('✅ Messages marked as read for user: $currentUserId');
//     } catch (e) {
//       print('Error marking messages as read: $e');
//     }
//   }
//
//   // ===================== IMAGE FROM CAMERA =====================
//   Future<void> pickImageAndSend() async {
//     try {
//       final pickedFile = await _imagePicker.pickImage(
//           source: ImageSource.camera, imageQuality: 80);
//       if (pickedFile == null) return;
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final file = File(pickedFile.path);
//       final url = await _uploadFileToStorage(
//         file: file,
//         path:
//         'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );
//
//       await sendMessage(
//         messageText: '',
//         type: 'image',
//         mediaUrl: url,
//         fileName: 'Photo',
//       );
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
//
//   // ===================== FILE PICKER =====================
//   Future<void> pickFileAndSend() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//       );
//       if (result == null || result.files.single.path == null) return;
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final file = File(result.files.single.path!);
//       final fileName = result.files.single.name;
//
//       final url = await _uploadFileToStorage(
//         file: file,
//         path:
//         'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName',
//       );
//
//       await sendMessage(
//         messageText: fileName,
//         type: 'file',
//         mediaUrl: url,
//         fileName: fileName,
//       );
//     } catch (e) {
//       print('Error picking file: $e');
//     }
//   }
//
//   // ===================== STORAGE UPLOAD =====================
//   Future<String> _uploadFileToStorage({
//     required File file,
//     required String path,
//   }) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     final uploadTask = await ref.putFile(file);
//     final url = await uploadTask.ref.getDownloadURL();
//     return url;
//   }
//
//   // ===================== CREATE CHAT =====================
//   Future<ChatModel> _createNewChat(String otherUserId) async {
//     try {
//       final participants = [currentUserId, otherUserId]..sort();
//       final chatId = participants.join('_');
//       final chatRef = FirebaseFirestore.instance
//           .collection(FirebaseUtils.chats)
//           .doc(chatId);
//
//       // Check if chat already exists
//       final existingChat = await chatRef.get();
//       if (existingChat.exists) {
//         return ChatModel.fromJson(existingChat.data()!);
//       }
//
//       // ✅ Store both users' data in Firebase users collection
//       await _storeUserDataInFirebase(
//         otherUserId,
//         otherUserName,
//         otherUserProfileUrl,
//       );
//
//       // Also store current user data
//       final currentUserName =
//           Get.find<HomeController>().userResponse.data?.fullname ?? "";
//       final currentUserProfile =
//           Get.find<HomeController>().userResponse.data?.profile ?? "";
//       await _storeUserDataInFirebase(
//         currentUserId,
//         currentUserName,
//         currentUserProfile,
//       );
//
//       final participantNames = {
//         otherUserId: otherUserName,
//         currentUserId: currentUserName,
//       };
//
//       final participantProfileUrls = {
//         otherUserId: otherUserProfileUrl,
//         currentUserId: currentUserProfile,
//       };
//
//       final chatModel = ChatModel(
//         chatId: chatId,
//         isGroupChat: isGroup,
//         participantIds: [currentUserId, otherUserId],
//         participantNames: participantNames,
//         participantProfileUrls: participantProfileUrls,
//         lastMessage: '',
//         lastMessageTime: Timestamp.now(),
//         unreadMessages: {
//           currentUserId: 0,
//           otherUserId: 0,
//         },
//       );
//
//       await chatRef.set(chatModel.toMap());
//       return chatModel;
//     } catch (e) {
//       print('Error creating new chat: $e');
//       rethrow;
//     }
//   }
//
//   void cancelRecording() {
//     _recordingTimer?.cancel();
//     isRecording.value = false;
//     recordingDuration.value = '00:00';
//     _recordingSeconds = 0;
//     _recordedAudioPath = null;
//     _recordedAudioFile = null;
//     print("Recording cancelled");
//   }
//
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
// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
//
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/home/home_controller.dart';
// import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
// import 'package:the_friendz_zone/screens/message/models/message_model.dart';
// import 'package:the_friendz_zone/utils/firebase_utils.dart';
//
// import '../user_profile/user_presence_service.dart';
//
// class ChatController extends GetxController {
//   String? chatId;
//   final String otherUserId;
//   final String otherUserName;
//   final String otherUserProfileUrl;
//   final bool isGroup;
//
//   final String currentUserId = StorageHelper().getUserId.toString();
//   RxList<Message> messages = <Message>[].obs;
//   StreamSubscription? _messageSubscription;
//   StreamSubscription? _onlineStatusSubscription;
//   RxString inputText = ''.obs;
//
//   // ✅ Online status tracking
//   RxBool isOtherUserOnline = false.obs;
//   Rx<DateTime?> otherUserLastSeen = Rx<DateTime?>(null);
//
//   final ScrollController scrollController = ScrollController();
//   final ImagePicker _imagePicker = ImagePicker();
//   RxBool isRecording = false.obs;
//   RxString recordingDuration = '00:00'.obs;
//   Timer? _recordingTimer;
//   int _recordingSeconds = 0;
//
//   late final AudioRecorder _audioRecorder;
//   String? _recordedAudioPath;
//   File? _recordedAudioFile;
//
//   final UserPresenceService _presenceService = UserPresenceService();
//
//   ChatController({
//     this.chatId,
//     required this.otherUserId,
//     required this.otherUserName,
//     required this.otherUserProfileUrl,
//     this.isGroup = false,
//   }) {
//     _audioRecorder = AudioRecorder();
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // ✅ Start listening to other user's online status
//     _listenToOtherUserStatus();
//
//     if (chatId != null) {
//       _initChatData();
//       Future.delayed(Duration(milliseconds: 500), () {
//         _markMessagesAsRead(chatId!);
//       });
//     }
//   }
//
//   @override
//   void onClose() {
//     _messageSubscription?.cancel();
//     _onlineStatusSubscription?.cancel();
//     scrollController.dispose();
//     _recordingTimer?.cancel();
//     _audioRecorder.dispose();
//     super.onClose();
//   }
//
//   // ✅ Listen to other user's online status
//   void _listenToOtherUserStatus() {
//     _onlineStatusSubscription = _presenceService
//         .getUserOnlineStatus(otherUserId)
//         .listen((isOnline) {
//       isOtherUserOnline.value = isOnline;
//
//       // If offline, get last seen
//       if (!isOnline) {
//         _presenceService.getUserLastSeen(otherUserId).listen((lastSeen) {
//           otherUserLastSeen.value = lastSeen;
//         });
//       }
//     });
//   }
//
//   void scrollToBottom({bool animate = true}) {
//     if (!scrollController.hasClients) return;
//     final position = scrollController.position.maxScrollExtent;
//     if (animate) {
//       scrollController.animateTo(
//         position,
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//       );
//     } else {
//       scrollController.jumpTo(position);
//     }
//   }
//
//   // ===================== TEXT MESSAGE =====================
//   Future<void> sendMessage({
//     required String messageText,
//     required String type,
//     String? mediaUrl,
//     String? fileName,
//   }) async {
//     if (messageText.trim().isEmpty && mediaUrl == null) return;
//
//     try {
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final newMessage = Message(
//         senderId: currentUserId,
//         message: messageText.trim(),
//         type: type,
//         mediaUrl: mediaUrl,
//         fileName: fileName,
//         readBy: [currentUserId],
//         isSent: false,
//         timestamp: Timestamp.now(),
//         isMedia: mediaUrl != null,
//       );
//
//       messages.add(newMessage);
//       inputText.value = '';
//
//       await _writeNewMessage(newMessage);
//
//       final index = messages.indexOf(newMessage);
//       if (index != -1) {
//         messages[index] = newMessage.copyWith(isSent: true);
//       }
//
//       scrollToBottom();
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
//
//   // ===================== SEND RECORDED AUDIO =====================
//   Future<void> sendRecordedAudio() async {
//     if (_recordedAudioPath == null || _recordedAudioFile == null) {
//       print("No recorded audio to send");
//       return;
//     }
//
//     try {
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final url = await _uploadFileToStorage(
//         file: _recordedAudioFile!,
//         path:
//         'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
//       );
//
//       await sendMessage(
//         messageText: 'Audio message',
//         type: 'audio',
//         mediaUrl: url,
//         fileName: 'Audio',
//       );
//
//       print("Audio Sent Successfully --> $url");
//       _resetRecordingState();
//     } catch (e) {
//       print("Error sending recorded audio: $e");
//     }
//   }
//
//   void _resetRecordingState() {
//     _recordedAudioPath = null;
//     _recordedAudioFile = null;
//     recordingDuration.value = '00:00';
//   }
//
//   // ===================== VOICE RECORDING =====================
//   Future<void> startRecording() async {
//     try {
//       if (!await _audioRecorder.hasPermission()) {
//         print("Microphone permission denied");
//         return;
//       }
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       const config = RecordConfig(
//         encoder: AudioEncoder.aacLc,
//         bitRate: 128000,
//         sampleRate: 44100,
//       );
//
//       final tempDir = await getTemporaryDirectory();
//       _recordedAudioPath =
//       '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//       await _audioRecorder.start(config, path: _recordedAudioPath!);
//
//       isRecording.value = true;
//       _recordingSeconds = 0;
//       _startRecordingTimer();
//
//       print("Recording Started... Path: $_recordedAudioPath");
//     } catch (e) {
//       print("Recording Error: $e");
//       isRecording.value = false;
//     }
//   }
//
//   Future<void> stopRecording() async {
//     try {
//       _recordingTimer?.cancel();
//       isRecording.value = false;
//
//       final String? path = await _audioRecorder.stop();
//       if (path == null) {
//         print("No audio recorded");
//         _resetRecordingState();
//         return;
//       }
//
//       _recordedAudioFile = File(path);
//       print("Recording stopped. File saved at: $path");
//     } catch (e) {
//       print("Stop Recording Error: $e");
//       _resetRecordingState();
//     }
//   }
//
//   void _startRecordingTimer() {
//     _recordingTimer?.cancel();
//     _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _recordingSeconds++;
//       final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
//       recordingDuration.value = '$minutes:$seconds';
//     });
//   }
//
//   // ===================== INIT / LISTENER =====================
//   Future<void> _initChatData() async {
//     _subscribeToMessages();
//   }
//
//   void _subscribeToMessages() {
//     if (chatId == null) return;
//
//     _messageSubscription?.cancel();
//
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
//
//       messages.value = newMessages;
//
//       await _markMessagesAsRead(chatId!);
//
//       Future.delayed(const Duration(milliseconds: 100), () {
//         scrollToBottom();
//       });
//     });
//   }
//
//   // ===================== FIRESTORE WRITE =====================
//   Future<void> _writeNewMessage(Message message) async {
//     final chatRef =
//     FirebaseFirestore.instance.collection(FirebaseUtils.chats).doc(chatId);
//
//     final batch = FirebaseFirestore.instance.batch();
//
//     final messageRef = chatRef.collection('messages').doc();
//     batch.set(messageRef, message.toMap());
//
//     String lastMessageText = '';
//     if (message.message.isNotEmpty) {
//       lastMessageText = message.message;
//     } else if (message.type == 'image') {
//       lastMessageText = '📷 Photo';
//     } else if (message.type == 'file') {
//       lastMessageText = '📎 ${message.fileName ?? 'File'}';
//     } else if (message.type == 'audio') {
//       lastMessageText = '🎤 Audio';
//     }
//
//     final chatUpdate = <String, dynamic>{
//       'lastMessage': lastMessageText,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     };
//
//     if (!isGroup) {
//       chatUpdate['unreadMessages.$otherUserId'] = FieldValue.increment(1);
//     }
//
//     batch.update(chatRef, chatUpdate);
//
//     await batch.commit();
//   }
//
//   Future<void> _markMessagesAsRead(String chatId) async {
//     try {
//       final chatRef = FirebaseFirestore.instance
//           .collection(FirebaseUtils.chats)
//           .doc(chatId);
//
//       final allMessagesSnapshot = await chatRef
//           .collection('messages')
//           .where('senderId', isNotEqualTo: currentUserId)
//           .get();
//
//       if (allMessagesSnapshot.docs.isEmpty) return;
//
//       final batch = FirebaseFirestore.instance.batch();
//       bool hasUnread = false;
//
//       for (final msgDoc in allMessagesSnapshot.docs) {
//         final msgData = msgDoc.data();
//         final readBy = List<String>.from(msgData['readBy'] ?? []);
//
//         if (!readBy.contains(currentUserId)) {
//           batch.update(msgDoc.reference, {
//             'readBy': FieldValue.arrayUnion([currentUserId]),
//           });
//           hasUnread = true;
//         }
//       }
//
//       if (hasUnread) {
//         batch.update(chatRef, {'unreadMessages.$currentUserId': 0});
//       }
//
//       await batch.commit();
//       print('✅ Messages marked as read for user: $currentUserId');
//     } catch (e) {
//       print('Error marking messages as read: $e');
//     }
//   }
//
//   // ===================== IMAGE FROM CAMERA =====================
//   Future<void> pickImageAndSend() async {
//     try {
//       final pickedFile = await _imagePicker.pickImage(
//           source: ImageSource.camera, imageQuality: 80);
//       if (pickedFile == null) return;
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final file = File(pickedFile.path);
//       final url = await _uploadFileToStorage(
//         file: file,
//         path:
//         'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );
//
//       await sendMessage(
//         messageText: '',
//         type: 'image',
//         mediaUrl: url,
//         fileName: 'Photo',
//       );
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
//
//   // ===================== FILE PICKER =====================
//   Future<void> pickFileAndSend() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//       );
//       if (result == null || result.files.single.path == null) return;
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final file = File(result.files.single.path!);
//       final fileName = result.files.single.name;
//
//       final url = await _uploadFileToStorage(
//         file: file,
//         path:
//         'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName',
//       );
//
//       await sendMessage(
//         messageText: fileName,
//         type: 'file',
//         mediaUrl: url,
//         fileName: fileName,
//       );
//     } catch (e) {
//       print('Error picking file: $e');
//     }
//   }
//
//   // ===================== STORAGE UPLOAD =====================
//   Future<String> _uploadFileToStorage({
//     required File file,
//     required String path,
//   }) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     final uploadTask = await ref.putFile(file);
//     final url = await uploadTask.ref.getDownloadURL();
//     return url;
//   }
//
//   // ===================== CREATE CHAT =====================
//   Future<ChatModel> _createNewChat(String otherUserId) async {
//     try {
//       final participants = [currentUserId, otherUserId]..sort();
//       final chatId = participants.join('_');
//       final chatRef = FirebaseFirestore.instance
//           .collection(FirebaseUtils.chats)
//           .doc(chatId);
//
//       final existingChat = await chatRef.get();
//       if (existingChat.exists) {
//         return ChatModel.fromJson(existingChat.data()!);
//       }
//
//       await _storeUserDataInFirebase(
//         otherUserId,
//         otherUserName,
//         otherUserProfileUrl,
//       );
//
//       final currentUserName =
//           Get.find<HomeController>().userResponse.data?.fullname ?? "";
//       final currentUserProfile =
//           Get.find<HomeController>().userResponse.data?.profile ?? "";
//       await _storeUserDataInFirebase(
//         currentUserId,
//         currentUserName,
//         currentUserProfile,
//       );
//
//       final participantNames = {
//         otherUserId: otherUserName,
//         currentUserId: currentUserName,
//       };
//
//       final participantProfileUrls = {
//         otherUserId: otherUserProfileUrl,
//         currentUserId: currentUserProfile,
//       };
//
//       final chatModel = ChatModel(
//         chatId: chatId,
//         isGroupChat: isGroup,
//         participantIds: [currentUserId, otherUserId],
//         participantNames: participantNames,
//         participantProfileUrls: participantProfileUrls,
//         lastMessage: '',
//         lastMessageTime: Timestamp.now(),
//         unreadMessages: {
//           currentUserId: 0,
//           otherUserId: 0,
//         },
//       );
//
//       await chatRef.set(chatModel.toMap());
//       return chatModel;
//     } catch (e) {
//       print('Error creating new chat: $e');
//       rethrow;
//     }
//   }
//
//   void cancelRecording() {
//     _recordingTimer?.cancel();
//     isRecording.value = false;
//     recordingDuration.value = '00:00';
//     _recordingSeconds = 0;
//     _recordedAudioPath = null;
//     _recordedAudioFile = null;
//     print("Recording cancelled");
//   }
//
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


// // import 'dart:async';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:get/get.dart';
// // import 'package:the_friendz_zone/config/app_config.dart';
// // import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
// // import 'package:the_friendz_zone/screens/user_profile/models/user_model.dart';
// // import 'package:the_friendz_zone/utils/firebase_utils.dart';
// // import 'models/message_model.dart';
// //
// // class MessageController extends GetxController {
// //   RxString currentOpenedChat = "".obs; //current open chat id
// //
// //   final String currentUserId = StorageHelper().getUserId.toString() ?? '';
// //   RxList<ChatModel> chatList = <ChatModel>[].obs;
// //   RxList<ChatModel> filteredChatList = <ChatModel>[].obs;
// //   Map<String, UserProfileData> chatParticipants = {};
// //
// //   RxString searchQuery = ''.obs;
// //   StreamSubscription? _chatSubscription;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _subscribeToChats();
// //     ever(searchQuery, (_) => _filterChats());
// //   }
// //
// //   @override
// //   void onClose() {
// //     _chatSubscription?.cancel();
// //     super.onClose();
// //   }
// //
// //   List<ChatModel> get filteredMessages {
// //     return filteredChatList;
// //   }
// //
// //   Future<void> _subscribeToChats() async {
// //     _chatSubscription = FirebaseFirestore.instance
// //         .collection(FirebaseUtils.chats)
// //         .where('participantIds', arrayContains: currentUserId)
// //         .orderBy('lastMessageTime', descending: true)
// //         .snapshots()
// //         .listen((snapshot) async {
// //       final List<ChatModel> fetchedChats = [];
// //       for (var doc in snapshot.docs) {
// //         final chat = ChatModel.fromJson(doc.data());
// //         fetchedChats.add(chat);
// //         await _fetchChatParticipants(chat);
// //       }
// //       chatList.value = fetchedChats;
// //       _filterChats(); // Apply filter after fetching chats
// //     });
// //   }
// //
// //   // Future<void> _fetchChatParticipants(ChatModel chat) async {
// //   //   for (String uid in chat.participantIds) {
// //   //     if (uid != currentUserId && !chatParticipants.containsKey(uid)) {
// //   //       final userDoc = await FirebaseFirestore.instance
// //   //           .collection(FirebaseUtils.users)
// //   //           .doc(uid)
// //   //           .get();
// //   //       if (userDoc.exists && userDoc.data() != null) {
// //   //         chatParticipants[uid] = UserProfileData.fromJson(userDoc.data()!);
// //   //       }
// //   //     }
// //   //   }
// //   // }
// //   Future<void> _fetchChatParticipants(ChatModel chat) async {
// //     for (String uid in chat.participantIds) {
// //       if (uid != currentUserId) {
// //         try {
// //           final userDoc = await FirebaseFirestore.instance
// //               .collection(FirebaseUtils.users)
// //               .doc(uid)
// //               .get();
// //
// //           if (userDoc.exists && userDoc.data() != null) {
// //             chatParticipants[uid] = UserProfileData.fromJson(userDoc.data()!);
// //           } else {
// //             // ✅ Fallback to stored participant data in chat
// //             if (chat.participantNames != null &&
// //                 chat.participantNames!.containsKey(uid)) {
// //               chatParticipants[uid] = UserProfileData(
// //                 id: int.tryParse(uid).toString(),
// //                 fullname: chat.participantNames![uid],
// //                 profile: chat.participantProfileUrls?[uid],
// //               );
// //             }
// //           }
// //         } catch (e) {
// //           print('Error fetching participant $uid: $e');
// //           // Use fallback data from chat
// //           if (chat.participantNames != null) {
// //             chatParticipants[uid] = UserProfileData(
// //               id: int.tryParse(uid).toString(),
// //               fullname: chat.participantNames![uid],
// //               profile: chat.participantProfileUrls?[uid],
// //             );
// //           }
// //         }
// //       }
// //     }
// //
// //     // Force UI refresh
// //     chatParticipants = Map.from(chatParticipants);
// //     update();
// //   }
// //
// //
// //   void _filterChats() {
// //     if (searchQuery.value.isEmpty) {
// //       filteredChatList.value = chatList;
// //       return;
// //     }
// //     final query = searchQuery.value.toLowerCase();
// //     filteredChatList.value = chatList.where((chat) {
// //       final otherUserId = chat.participantIds.firstWhere(
// //         (id) => id != currentUserId,
// //         orElse: () => '',
// //       );
// //       final otherUser = chatParticipants[otherUserId];
// //       final userName = otherUser?.fullName?.toLowerCase() ?? '';
// //       final lastMessage = chat.lastMessage?.toLowerCase() ?? '';
// //
// //       return userName.contains(query) || lastMessage.contains(query);
// //     }).toList();
// //   }
// //
// //   UserProfileData? getOtherParticipant(ChatModel chat) {
// //     final otherUserId = chat.participantIds.firstWhere(
// //       (id) => id != currentUserId,
// //       orElse: () => '',
// //     );
// //     return chatParticipants[otherUserId];
// //   }
// //
// //   Future<String?> fetchUserName(String userId) async {
// //     try {
// //       final userDoc = await FirebaseFirestore.instance
// //           .collection(FirebaseUtils.users)
// //           .doc(userId)
// //           .get();
// //
// //       if (userDoc.exists && userDoc.data() != null) {
// //         final userData = UserProfileData.fromJson(userDoc.data()!);
// //         return userData.fullname ?? 'Unknown User';
// //       }
// //     } catch (e) {
// //       print('Error fetching user name: $e');
// //     }
// //     return 'Unknown User';
// //   }
// //
// //   Future<String?> fetchUserProfileUrl(String userId) async {
// //     try {
// //       final userDoc = await FirebaseFirestore.instance
// //           .collection(FirebaseUtils.users)
// //           .doc(userId)
// //           .get();
// //
// //       if (userDoc.exists && userDoc.data() != null) {
// //         final userData = UserProfileData.fromJson(userDoc.data()!);
// //         return userData.profile ?? '';
// //       }
// //     } catch (e) {
// //       print('Error fetching user profile URL: $e');
// //     }
// //     return '';
// //   }
// //
// //   String? getOtherParticipantName(ChatModel chat) {
// //     final otherUserId = chat.participantIds.firstWhere(
// //       (id) => id != currentUserId,
// //       orElse: () => '',
// //     );
// //
// //     // First try to get from stored participantNames
// //     if (chat.participantNames != null &&
// //         chat.participantNames!.containsKey(otherUserId)) {
// //       return chat.participantNames![otherUserId];
// //     }
// //
// //     // Fallback to fetched participant data
// //     final otherUser = chatParticipants[otherUserId];
// //     return otherUser?.fullname ?? 'Unknown User';
// //   }
// //
// //   String? getOtherParticipantProfileUrl(ChatModel chat) {
// //     final otherUserId = chat.participantIds.firstWhere(
// //       (id) => id != currentUserId,
// //       orElse: () => '',
// //     );
// //
// //     // First try to get from stored participantProfileUrls
// //     if (chat.participantProfileUrls != null &&
// //         chat.participantProfileUrls!.containsKey(otherUserId)) {
// //       return chat.participantProfileUrls![otherUserId];
// //     }
// //
// //     // Fallback to fetched participant data
// //     final otherUser = chatParticipants[otherUserId];
// //     return otherUser?.profile ?? '';
// //   }
// // }
//
// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/config/app_config.dart';
// import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
// import 'package:the_friendz_zone/screens/user_profile/models/user_model.dart';
// import 'package:the_friendz_zone/utils/firebase_utils.dart';
//
// class MessageController extends GetxController {
//   RxString currentOpenedChat = "".obs;
//
//   final String currentUserId = StorageHelper().getUserId.toString();
//   RxList<ChatModel> chatList = <ChatModel>[].obs;
//   RxList<ChatModel> filteredChatList = <ChatModel>[].obs;
//   Map<String, UserProfileData> chatParticipants = {};
//
//   RxString searchQuery = ''.obs;
//   StreamSubscription? _chatSubscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _subscribeToChats();
//     ever(searchQuery, (_) => _filterChats());
//   }
//
//   @override
//   void onClose() {
//     _chatSubscription?.cancel();
//     super.onClose();
//   }
//
//   List<ChatModel> get filteredMessages {
//     return filteredChatList;
//   }
//
//   Future<void> _subscribeToChats() async {
//     _chatSubscription = FirebaseFirestore.instance
//         .collection(FirebaseUtils.chats)
//         .where('participantIds', arrayContains: currentUserId)
//         .orderBy('lastMessageTime', descending: true)
//         .snapshots()
//         .listen((snapshot) async {
//       final List<ChatModel> fetchedChats = [];
//       for (var doc in snapshot.docs) {
//         final chat = ChatModel.fromJson(doc.data());
//         fetchedChats.add(chat);
//         await _fetchChatParticipants(chat);
//       }
//       chatList.value = fetchedChats;
//       _filterChats();
//     });
//   }
//
//   Future<void> _fetchChatParticipants(ChatModel chat) async {
//     for (String uid in chat.participantIds) {
//       if (uid != currentUserId) {
//         try {
//           final userDoc = await FirebaseFirestore.instance
//               .collection(FirebaseUtils.users)
//               .doc(uid)
//               .get();
//
//           if (userDoc.exists && userDoc.data() != null) {
//             chatParticipants[uid] = UserProfileData.fromJson(userDoc.data()!);
//           } else {
//             // ✅ Fallback to stored participant data in chat
//             if (chat.participantNames != null &&
//                 chat.participantNames!.containsKey(uid)) {
//               chatParticipants[uid] = UserProfileData(
//                 id: int.tryParse(uid).toString(),
//                 fullname: chat.participantNames![uid],
//                 profile: chat.participantProfileUrls?[uid],
//               );
//             }
//           }
//         } catch (e) {
//           print('Error fetching participant $uid: $e');
//           // Use fallback data from chat
//           if (chat.participantNames != null &&
//               chat.participantNames!.containsKey(uid)) {
//             chatParticipants[uid] = UserProfileData(
//               id: int.tryParse(uid).toString(),
//               fullname: chat.participantNames![uid],
//               profile: chat.participantProfileUrls?[uid],
//             );
//           }
//         }
//       }
//     }
//
//     // Force UI refresh
//     chatParticipants = Map.from(chatParticipants);
//     update();
//   }
//
//   void _filterChats() {
//     if (searchQuery.value.isEmpty) {
//       filteredChatList.value = chatList;
//       return;
//     }
//     final query = searchQuery.value.toLowerCase();
//     filteredChatList.value = chatList.where((chat) {
//       final otherUserId = chat.participantIds.firstWhere(
//             (id) => id != currentUserId,
//         orElse: () => '',
//       );
//       final otherUser = chatParticipants[otherUserId];
//       final userName = otherUser?.fullname?.toLowerCase() ?? '';
//       final lastMessage = chat.lastMessage.toLowerCase();
//
//       return userName.contains(query) || lastMessage.contains(query);
//     }).toList();
//   }
//
//   UserProfileData? getOtherParticipant(ChatModel chat) {
//     final otherUserId = chat.participantIds.firstWhere(
//           (id) => id != currentUserId,
//       orElse: () => '',
//     );
//     return chatParticipants[otherUserId];
//   }
//
//   String? getOtherParticipantName(ChatModel chat) {
//     final otherUserId = chat.participantIds.firstWhere(
//           (id) => id != currentUserId,
//       orElse: () => '',
//     );
//
//     // First try to get from stored participantNames
//     if (chat.participantNames != null &&
//         chat.participantNames!.containsKey(otherUserId)) {
//       return chat.participantNames![otherUserId];
//     }
//
//     // Fallback to fetched participant data
//     final otherUser = chatParticipants[otherUserId];
//     return otherUser?.fullname ?? 'Unknown User';
//   }
//
//   String? getOtherParticipantProfileUrl(ChatModel chat) {
//     final otherUserId = chat.participantIds.firstWhere(
//           (id) => id != currentUserId,
//       orElse: () => '',
//     );
//
//     // First try to get from stored participantProfileUrls
//     if (chat.participantProfileUrls != null &&
//         chat.participantProfileUrls!.containsKey(otherUserId)) {
//       return chat.participantProfileUrls![otherUserId];
//     }
//
//     // Fallback to fetched participant data
//     final otherUser = chatParticipants[otherUserId];
//     return otherUser?.profile ?? '';
//   }
// }
