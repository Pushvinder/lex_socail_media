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
//   // ✅ Upload progress tracking
//   RxDouble uploadProgress = 0.0.obs;
//   RxBool isUploading = false.obs;
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
//       Get.snackbar(
//         'Error',
//         'Failed to send message',
//         snackPosition: SnackPosition.BOTTOM,
//       );
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
//       // ✅ Check if file exists
//       if (!await _recordedAudioFile!.exists()) {
//         print("Audio file does not exist at path: ${_recordedAudioFile!.path}");
//         Get.snackbar(
//           'Error',
//           'Audio file not found',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         _resetRecordingState();
//         return;
//       }
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       isUploading.value = true;
//       uploadProgress.value = 0.0;
//
//       // ✅ Upload with progress tracking
//       final url = await _uploadFileToStorageWithProgress(
//         file: _recordedAudioFile!,
//         path: 'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
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
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//     } catch (e) {
//       print("Error sending recorded audio: $e");
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       Get.snackbar(
//         'Error',
//         'Failed to send audio: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       _resetRecordingState();
//     }
//   }
//
//   void _resetRecordingState() {
//     _recordedAudioPath = null;
//     _recordedAudioFile = null;
//     recordingDuration.value = '00:00';
//     _recordingSeconds = 0;
//   }
//
//   // ===================== VOICE RECORDING =====================
//   Future<void> startRecording() async {
//     try {
//       if (!await _audioRecorder.hasPermission()) {
//         print("Microphone permission denied");
//         Get.snackbar(
//           'Permission Required',
//           'Microphone permission is required to record audio',
//           snackPosition: SnackPosition.BOTTOM,
//         );
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
//       Get.snackbar(
//         'Error',
//         'Failed to start recording',
//         snackPosition: SnackPosition.BOTTOM,
//       );
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
//       // ✅ Verify file exists
//       _recordedAudioFile = File(path);
//       if (await _recordedAudioFile!.exists()) {
//         final fileSize = await _recordedAudioFile!.length();
//         print("Recording stopped. File saved at: $path (Size: $fileSize bytes)");
//       } else {
//         print("Error: File does not exist at path: $path");
//         _resetRecordingState();
//       }
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
//   // ===================== IMAGE PICKER - CAMERA & GALLERY =====================
//
//   /// Pick image from camera
//   Future<void> pickImageFromCamera() async {
//     try {
//       final pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//
//       if (pickedFile == null) return;
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final file = File(pickedFile.path);
//
//       isUploading.value = true;
//       uploadProgress.value = 0.0;
//
//       final url = await _uploadFileToStorageWithProgress(
//         file: file,
//         path: 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );
//
//       await sendMessage(
//         messageText: '',
//         type: 'image',
//         mediaUrl: url,
//         fileName: 'Photo',
//       );
//
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//     } catch (e) {
//       print('Error picking image from camera: $e');
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       Get.snackbar(
//         'Error',
//         'Failed to send image',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   /// Pick image from gallery
//   Future<void> pickImageFromGallery() async {
//     try {
//       final pickedFile = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
//
//       if (pickedFile == null) return;
//
//       if (chatId == null) {
//         final newChat = await _createNewChat(otherUserId);
//         chatId = newChat.chatId;
//         _initChatData();
//       }
//
//       final file = File(pickedFile.path);
//
//       isUploading.value = true;
//       uploadProgress.value = 0.0;
//
//       final url = await _uploadFileToStorageWithProgress(
//         file: file,
//         path: 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );
//
//       await sendMessage(
//         messageText: '',
//         type: 'image',
//         mediaUrl: url,
//         fileName: 'Photo',
//       );
//
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//     } catch (e) {
//       print('Error picking image from gallery: $e');
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       Get.snackbar(
//         'Error',
//         'Failed to send image',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   // ===================== FILE PICKER - ALL FILES =====================
//
//   /// Pick any file from device
//   Future<void> pickFileAndSend() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.any,
//         allowMultiple: false,
//       );
//
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
//       final fileExtension = fileName.split('.').last.toLowerCase();
//
//       isUploading.value = true;
//       uploadProgress.value = 0.0;
//
//       // Determine file type
//       String messageType = 'file';
//       String storagePath;
//
//       // Check if it's an image
//       if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(fileExtension)) {
//         messageType = 'image';
//         storagePath = 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}_$fileName';
//       }
//       // Check if it's a video
//       else if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'].contains(fileExtension)) {
//         messageType = 'video';
//         storagePath = 'chats/$chatId/videos/${DateTime.now().millisecondsSinceEpoch}_$fileName';
//       }
//       // Check if it's audio
//       else if (['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'].contains(fileExtension)) {
//         messageType = 'audio';
//         storagePath = 'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}_$fileName';
//       }
//       // Other files
//       else {
//         storagePath = 'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName';
//       }
//
//       final url = await _uploadFileToStorageWithProgress(
//         file: file,
//         path: storagePath,
//       );
//
//       await sendMessage(
//         messageText: messageType == 'file' ? fileName : '',
//         type: messageType,
//         mediaUrl: url,
//         fileName: fileName,
//       );
//
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//     } catch (e) {
//       print('Error picking file: $e');
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//       Get.snackbar(
//         'Error',
//         'Failed to send file',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   // ===================== STORAGE UPLOAD WITH PROGRESS =====================
//
//   /// Upload file to Firebase Storage with progress tracking
//   Future<String> _uploadFileToStorageWithProgress({
//     required File file,
//     required String path,
//   }) async {
//     try {
//       final ref = FirebaseStorage.instance.ref().child(path);
//       final uploadTask = ref.putFile(file);
//
//       // Listen to upload progress
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
//         print('Upload Progress: ${(uploadProgress.value * 100).toStringAsFixed(2)}%');
//       });
//
//       // Wait for upload to complete
//       final taskSnapshot = await uploadTask;
//       final url = await taskSnapshot.ref.getDownloadURL();
//
//       print('✅ File uploaded successfully: $url');
//       return url;
//     } catch (e) {
//       print('Error uploading file: $e');
//       rethrow;
//     }
//   }
//
//   // ===================== BACKWARD COMPATIBILITY =====================
//
//   /// Legacy method for backward compatibility
//   @Deprecated('Use pickImageFromCamera instead')
//   Future<void> pickImageAndSend() async {
//     await pickImageFromCamera();
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

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/home/home_controller.dart';
import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
import 'package:the_friendz_zone/screens/message/models/message_model.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/firebase_utils.dart';

import '../user_profile/user_presence_service.dart';

class ChatController extends GetxController {
  String? chatId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserProfileUrl;
  final bool isGroup;

  final String currentUserId = StorageHelper().getUserId.toString();
  RxList<Message> messages = <Message>[].obs;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _onlineStatusSubscription;
  RxString inputText = ''.obs;

  // ✅ Online status tracking
  RxBool isOtherUserOnline = false.obs;
  Rx<DateTime?> otherUserLastSeen = Rx<DateTime?>(null);

  // ✅ Block status tracking
  RxBool isUserBlocked = false.obs;
  RxBool isBlockedByOther = false.obs;

  final ScrollController scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  RxBool isRecording = false.obs;
  RxString recordingDuration = '00:00'.obs;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  // ✅ Upload progress tracking
  RxDouble uploadProgress = 0.0.obs;
  RxBool isUploading = false.obs;

  late final AudioRecorder _audioRecorder;
  String? _recordedAudioPath;
  File? _recordedAudioFile;

  final UserPresenceService _presenceService = UserPresenceService();

  ChatController({
    this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserProfileUrl,
    this.isGroup = false,
  }) {
    _audioRecorder = AudioRecorder();
  }

  @override
  void onInit() {
    super.onInit();
    _listenToOtherUserStatus();

    if (chatId != null) {
      _initChatData();
      checkBlockStatus(); // ✅ Check block status on init
      Future.delayed(Duration(milliseconds: 500), () {
        _markMessagesAsRead(chatId!);
      });
    }
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    _onlineStatusSubscription?.cancel();
    scrollController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    super.onClose();
  }

  void _listenToOtherUserStatus() {
    _onlineStatusSubscription = _presenceService
        .getUserOnlineStatus(otherUserId)
        .listen((isOnline) {
      isOtherUserOnline.value = isOnline;

      if (!isOnline) {
        _presenceService.getUserLastSeen(otherUserId).listen((lastSeen) {
          otherUserLastSeen.value = lastSeen;
        });
      }
    });
  }

  void scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;
    final position = scrollController.position.maxScrollExtent;
    if (animate) {
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(position);
    }
  }

  // ===================== BLOCK/UNBLOCK FUNCTIONALITY =====================

  /// Check block status from Firestore
  Future<void> checkBlockStatus() async {
    if (chatId == null) return;

    try {
      final chatDoc = await FirebaseFirestore.instance
          .collection(FirebaseUtils.chats)
          .doc(chatId)
          .get();

      if (chatDoc.exists) {
        final data = chatDoc.data();
        final blockedMap = data?['blocked'] as Map<String, dynamic>?;

        if (blockedMap != null) {
          // Check if current user blocked the other user
          isUserBlocked.value = blockedMap[otherUserId] == true;

          // Check if current user is blocked by the other user
          isBlockedByOther.value = blockedMap[currentUserId] == true;
        }
      }
    } catch (e) {
      print('❌ Error checking block status: $e');
    }
  }

  /// Block or unblock user
  Future<void> toggleBlockUser() async {
    if (chatId == null) return;

    try {
      final chatRef = FirebaseFirestore.instance
          .collection(FirebaseUtils.chats)
          .doc(chatId);

      // Toggle block status
      final newBlockStatus = !isUserBlocked.value;

      await chatRef.update({
        'blocked.$otherUserId': newBlockStatus,
      });

      isUserBlocked.value = newBlockStatus;

      Get.snackbar(
        newBlockStatus ? 'User Blocked' : 'User Unblocked',
        newBlockStatus
            ? 'You have blocked this user'
            : 'You have unblocked this user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: newBlockStatus
            ? AppColors.redColor.withOpacity(0.8)
            : AppColors.greenColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
        duration: Duration(seconds: 2),
      );

      print(newBlockStatus
          ? '🚫 User blocked: $otherUserId'
          : '✅ User unblocked: $otherUserId');
    } catch (e) {
      print('❌ Error toggling block status: $e');
      Get.snackbar(
        'Error',
        'Failed to update block status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  /// Show block confirmation dialog
  void showBlockConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          isUserBlocked.value ? 'Unblock User?' : 'Block User?',
          style: GoogleFonts.inter(
            color: AppColors.textColor3,
            fontSize: FontDimen.dimen18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          isUserBlocked.value
              ? 'Do you want to unblock $otherUserName? They will be able to send you messages again.'
              : 'Do you want to block $otherUserName? They will not be able to send you messages.',
          style: GoogleFonts.inter(
            color: AppColors.textColor3.withOpacity(0.8),
            fontSize: FontDimen.dimen14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.textColor3,
                fontSize: FontDimen.dimen14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              toggleBlockUser();
            },
            child: Text(
              isUserBlocked.value ? 'Unblock' : 'Block',
              style: GoogleFonts.inter(
                color: isUserBlocked.value
                    ? AppColors.greenColor
                    : AppColors.redColor,
                fontSize: FontDimen.dimen14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== TEXT MESSAGE =====================
  Future<void> sendMessage({
    required String messageText,
    required String type,
    String? mediaUrl,
    String? fileName,
  }) async {
    if (messageText.trim().isEmpty && mediaUrl == null) return;

    // ✅ Check if current user is blocked by the other user
    if (isBlockedByOther.value) {
      Get.snackbar(
        'Cannot Send Message',
        'You are blocked by this user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
      return;
    }

    // ✅ Check if current user has blocked the other user
    if (isUserBlocked.value) {
      Get.snackbar(
        'Cannot Send Message',
        'You have blocked this user. Unblock to send messages.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
      return;
    }

    try {
      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
        await checkBlockStatus(); // ✅ Check block status for new chats
      }

      final newMessage = Message(
        senderId: currentUserId,
        message: messageText.trim(),
        type: type,
        mediaUrl: mediaUrl,
        fileName: fileName,
        readBy: [currentUserId],
        isSent: false,
        timestamp: Timestamp.now(),
        isMedia: mediaUrl != null,
      );

      messages.add(newMessage);
      inputText.value = '';

      await _writeNewMessage(newMessage);

      final index = messages.indexOf(newMessage);
      if (index != -1) {
        messages[index] = newMessage.copyWith(isSent: true);
      }

      scrollToBottom();
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  // ===================== SEND RECORDED AUDIO =====================
  Future<void> sendRecordedAudio() async {
    if (_recordedAudioPath == null || _recordedAudioFile == null) {
      print("No recorded audio to send");
      return;
    }

    try {
      // ✅ Check if file exists
      if (!await _recordedAudioFile!.exists()) {
        print("Audio file does not exist at path: ${_recordedAudioFile!.path}");
        Get.snackbar(
          'Error',
          'Audio file not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor.withOpacity(0.8),
          colorText: AppColors.whiteColor,
        );
        _resetRecordingState();
        return;
      }

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      isUploading.value = true;
      uploadProgress.value = 0.0;

      // ✅ Upload with progress tracking
      final url = await _uploadFileToStorageWithProgress(
        file: _recordedAudioFile!,
        path: 'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      await sendMessage(
        messageText: 'Audio message',
        type: 'audio',
        mediaUrl: url,
        fileName: 'Audio',
      );

      print("✅ Audio Sent Successfully --> $url");
      _resetRecordingState();
      isUploading.value = false;
      uploadProgress.value = 0.0;
    } catch (e) {
      print("❌ Error sending recorded audio: $e");
      isUploading.value = false;
      uploadProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to send audio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
      _resetRecordingState();
    }
  }

  void _resetRecordingState() {
    _recordedAudioPath = null;
    _recordedAudioFile = null;
    recordingDuration.value = '00:00';
    _recordingSeconds = 0;
  }

  // ===================== VOICE RECORDING =====================
  Future<void> startRecording() async {
    try {
      if (!await _audioRecorder.hasPermission()) {
        print("Microphone permission denied");
        Get.snackbar(
          'Permission Required',
          'Microphone permission is required to record audio',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor.withOpacity(0.8),
          colorText: AppColors.whiteColor,
        );
        return;
      }

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      final tempDir = await getTemporaryDirectory();
      _recordedAudioPath =
      '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(config, path: _recordedAudioPath!);

      isRecording.value = true;
      _recordingSeconds = 0;
      _startRecordingTimer();

      print("🎤 Recording Started... Path: $_recordedAudioPath");
    } catch (e) {
      print("❌ Recording Error: $e");
      isRecording.value = false;
      Get.snackbar(
        'Error',
        'Failed to start recording',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  Future<void> stopRecording() async {
    try {
      _recordingTimer?.cancel();
      isRecording.value = false;

      final String? path = await _audioRecorder.stop();
      if (path == null) {
        print("No audio recorded");
        _resetRecordingState();
        return;
      }

      // ✅ Verify file exists
      _recordedAudioFile = File(path);
      if (await _recordedAudioFile!.exists()) {
        final fileSize = await _recordedAudioFile!.length();
        print("✅ Recording stopped. File saved at: $path (Size: $fileSize bytes)");
      } else {
        print("❌ Error: File does not exist at path: $path");
        _resetRecordingState();
      }
    } catch (e) {
      print("❌ Stop Recording Error: $e");
      _resetRecordingState();
    }
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _recordingSeconds++;
      final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
      recordingDuration.value = '$minutes:$seconds';
    });
  }

  // ===================== INIT / LISTENER =====================
  Future<void> _initChatData() async {
    _subscribeToMessages();
  }

  void _subscribeToMessages() {
    if (chatId == null) return;

    _messageSubscription?.cancel();

    _messageSubscription = FirebaseFirestore.instance
        .collection(FirebaseUtils.chats)
        .doc(chatId!)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) async {
      final newMessages = snapshot.docs.map((doc) {
        return Message.fromMap(doc.data(), doc.id);
      }).toList();

      messages.value = newMessages;

      await _markMessagesAsRead(chatId!);

      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToBottom();
      });
    });
  }

  // ===================== FIRESTORE WRITE =====================
  Future<void> _writeNewMessage(Message message) async {
    final chatRef =
    FirebaseFirestore.instance.collection(FirebaseUtils.chats).doc(chatId);

    final batch = FirebaseFirestore.instance.batch();

    final messageRef = chatRef.collection('messages').doc();
    batch.set(messageRef, message.toMap());

    String lastMessageText = '';
    if (message.message.isNotEmpty) {
      lastMessageText = message.message;
    } else if (message.type == 'image') {
      lastMessageText = '📷 Photo';
    } else if (message.type == 'file') {
      lastMessageText = '📎 ${message.fileName ?? 'File'}';
    } else if (message.type == 'audio') {
      lastMessageText = '🎤 Audio';
    }

    final chatUpdate = <String, dynamic>{
      'lastMessage': lastMessageText,
      'lastMessageTime': FieldValue.serverTimestamp(),
    };

    if (!isGroup) {
      chatUpdate['unreadMessages.$otherUserId'] = FieldValue.increment(1);
    }

    batch.update(chatRef, chatUpdate);

    await batch.commit();
  }

  Future<void> _markMessagesAsRead(String chatId) async {
    try {
      final chatRef = FirebaseFirestore.instance
          .collection(FirebaseUtils.chats)
          .doc(chatId);

      final allMessagesSnapshot = await chatRef
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .get();

      if (allMessagesSnapshot.docs.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();
      bool hasUnread = false;

      for (final msgDoc in allMessagesSnapshot.docs) {
        final msgData = msgDoc.data();
        final readBy = List<String>.from(msgData['readBy'] ?? []);

        if (!readBy.contains(currentUserId)) {
          batch.update(msgDoc.reference, {
            'readBy': FieldValue.arrayUnion([currentUserId]),
          });
          hasUnread = true;
        }
      }

      if (hasUnread) {
        batch.update(chatRef, {'unreadMessages.$currentUserId': 0});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // ===================== IMAGE PICKER - GALLERY ONLY =====================

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final file = File(pickedFile.path);

      isUploading.value = true;
      uploadProgress.value = 0.0;

      final url = await _uploadFileToStorageWithProgress(
        file: file,
        path: 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await sendMessage(
        messageText: '',
        type: 'image',
        mediaUrl: url,
        fileName: 'Photo',
      );

      isUploading.value = false;
      uploadProgress.value = 0.0;
    } catch (e) {
      print('❌ Error picking image from gallery: $e');
      isUploading.value = false;
      uploadProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to send image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  // ===================== CAMERA - CAPTURE & SEND =====================

  /// Capture image from camera and send
  Future<void> captureImageFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final file = File(pickedFile.path);

      isUploading.value = true;
      uploadProgress.value = 0.0;

      final url = await _uploadFileToStorageWithProgress(
        file: file,
        path: 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await sendMessage(
        messageText: '',
        type: 'image',
        mediaUrl: url,
        fileName: 'Photo',
      );

      isUploading.value = false;
      uploadProgress.value = 0.0;
    } catch (e) {
      print('❌ Error capturing image from camera: $e');
      isUploading.value = false;
      uploadProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to send image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  // ===================== FILE PICKER - ALL FILES =====================

  /// Pick any file from device
  Future<void> pickFileAndSend() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) return;

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final fileExtension = fileName.split('.').last.toLowerCase();

      isUploading.value = true;
      uploadProgress.value = 0.0;

      // Determine file type
      String messageType = 'file';
      String storagePath;

      // Check if it's an image
      if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(fileExtension)) {
        messageType = 'image';
        storagePath = 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      }
      // Check if it's a video
      else if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'].contains(fileExtension)) {
        messageType = 'video';
        storagePath = 'chats/$chatId/videos/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      }
      // Check if it's audio
      else if (['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'].contains(fileExtension)) {
        messageType = 'audio';
        storagePath = 'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      }
      // Other files
      else {
        storagePath = 'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      }

      final url = await _uploadFileToStorageWithProgress(
        file: file,
        path: storagePath,
      );

      await sendMessage(
        messageText: messageType == 'file' ? fileName : '',
        type: messageType,
        mediaUrl: url,
        fileName: fileName,
      );

      isUploading.value = false;
      uploadProgress.value = 0.0;
    } catch (e) {
      print('❌ Error picking file: $e');
      isUploading.value = false;
      uploadProgress.value = 0.0;
      Get.snackbar(
        'Error',
        'Failed to send file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  // ===================== STORAGE UPLOAD WITH PROGRESS =====================

  /// Upload file to Firebase Storage with progress tracking
  Future<String> _uploadFileToStorageWithProgress({
    required File file,
    required String path,
  }) async {
    try {
      print('📤 Starting upload to: $path');
      print('📁 File path: ${file.path}');
      print('📊 File size: ${await file.length()} bytes');

      // ✅ Verify file exists before upload
      if (!await file.exists()) {
        throw Exception('File does not exist at path: ${file.path}');
      }

      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child(path);

      // ✅ Use putFile instead of put
      final uploadTask = fileRef.putFile(file);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          uploadProgress.value = progress;
          print('📈 Upload Progress: ${(progress * 100).toStringAsFixed(2)}%');
        },
        onError: (error) {
          print('❌ Upload stream error: $error');
        },
      );

      // Wait for upload to complete
      final taskSnapshot = await uploadTask.whenComplete(() => null);

      // Get download URL
      final url = await taskSnapshot.ref.getDownloadURL();

      print('✅ File uploaded successfully: $url');
      return url;
    } catch (e, stackTrace) {
      print('❌ Error uploading file: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // ===================== CREATE CHAT =====================
  Future<ChatModel> _createNewChat(String otherUserId) async {
    try {
      final participants = [currentUserId, otherUserId]..sort();
      final chatId = participants.join('_');

      final chatRef = FirebaseFirestore.instance
          .collection(FirebaseUtils.chats)
          .doc(chatId);

      final existingChat = await chatRef.get();
      if (existingChat.exists) {
        return ChatModel.fromJson(existingChat.data()!);
      }

      await _storeUserDataInFirebase(
        otherUserId,
        otherUserName,
        otherUserProfileUrl,
      );

      final currentUserName =
          Get.find<HomeController>().userResponse.data?.fullname ?? "";
      final currentUserProfile =
          Get.find<HomeController>().userResponse.data?.profile ?? "";
      await _storeUserDataInFirebase(
        currentUserId,
        currentUserName,
        currentUserProfile,
      );

      final participantNames = {
        otherUserId: otherUserName,
        currentUserId: currentUserName,
      };

      final participantProfileUrls = {
        otherUserId: otherUserProfileUrl,
        currentUserId: currentUserProfile,
      };

      final chatModel = ChatModel(
        chatId: chatId,
        isGroupChat: isGroup,
        participantIds: [currentUserId, otherUserId],
        participantNames: participantNames,
        participantProfileUrls: participantProfileUrls,
        lastMessage: '',
        lastMessageTime: Timestamp.now(),
        unreadMessages: {
          currentUserId: 0,
          otherUserId: 0,
        },
        blocked: {}, // ✅ Initialize blocked map as empty
      );

      await chatRef.set(chatModel.toMap());
      return chatModel;
    } catch (e) {
      print('❌ Error creating new chat: $e');
      rethrow;
    }
  }

  void cancelRecording() {
    _recordingTimer?.cancel();
    isRecording.value = false;
    recordingDuration.value = '00:00';
    _recordingSeconds = 0;
    _recordedAudioPath = null;
    _recordedAudioFile = null;
    print("🚫 Recording cancelled");
  }

  Future<void> _storeUserDataInFirebase(
      String userId, String userName, String profileUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseUtils.users)
          .doc(userId)
          .set({
        'id': userId,
        'fullname': userName,
        'profile': profileUrl,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error storing user data in Firebase: $e');
    }
  }
}
