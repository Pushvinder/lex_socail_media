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



//
// // controllers/chat_controller.dart
//
// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:the_friendz_zone/screens/message/widgets/audio_player_service.dart';
// import 'package:uuid/uuid.dart';
//
// import 'widgets/background_preload_service.dart';
// import 'widgets/file_upload_service.dart';
// import 'widgets/media_cache_service.dart';
// import 'models/message_model.dart';
//
// class ChatController extends GetxController {
//   // Constructor parameters
//   final String chatId;
//   final String otherUserId;
//   final String otherUserName;
//   final String? otherUserAvatar;
//   final bool isGroup;
//
//   ChatController({
//     required this.chatId,
//     required this.otherUserId,
//     required this.otherUserName,
//     this.otherUserAvatar,
//     this.isGroup = false,
//   });
//
//   // Services
//   final MediaCacheService _cacheService = MediaCacheService();
//   final BackgroundPreloadService _preloadService = BackgroundPreloadService();
//   final FileUploadService _uploadService = FileUploadService();
//   final AudioPlayerService _audioService = AudioPlayerService();
//
//   // Current user info (should be replaced with actual user data)
//   final String currentUserId = 'CURRENT_USER_ID'; // StorageHelper().getUserId.toString();
//   final String currentUserName = 'CURRENT_USER_NAME';
//   final String? currentUserAvatar = null;
//
//   // Message list
//   RxList<MessageModel> messages = <MessageModel>[].obs;
//
//   // Pagination
//   static const int pageSize = 20;
//   DocumentSnapshot? _lastDocument;
//   RxBool hasMoreMessages = true.obs;
//   RxBool isLoadingMore = false.obs;
//   RxBool isInitialLoading = true.obs;
//
//   // Scroll controller
//   late ScrollController scrollController;
//
//   // Text controller
//   final TextEditingController textController = TextEditingController();
//
//   // Reply state
//   Rx<MessageModel?> replyToMessage = Rx<MessageModel?>(null);
//
//   // Typing indicator
//   RxBool isOtherUserTyping = false.obs;
//   Timer? _typingTimer;
//
//   // Stream subscriptions
//   StreamSubscription? _messagesSubscription;
//   StreamSubscription? _typingSubscription;
//
//   // Visibility tracking for lazy loading
//   final Set<String> _visibleMessageIds = {};
//
//   // Upload progress
//   RxMap<String, double> uploadProgress = <String, double>{}.obs;
//
//   // Sending messages queue
//   final List<MessageModel> _pendingMessages = [];
//
//   @override
//   void onInit() {
//     super.onInit();
//     scrollController = ScrollController();
//     scrollController.addListener(_onScroll);
//
//     _initializeChat();
//   }
//
//   @override
//   void onClose() {
//     _messagesSubscription?.cancel();
//     _typingSubscription?.cancel();
//     _typingTimer?.cancel();
//     scrollController.dispose();
//     textController.dispose();
//
//     // Stop background preloading when leaving chat
//     _preloadService.stopPreloading();
//
//     // Mark messages as seen before leaving
//     _markMessagesAsSeen();
//
//     super.onClose();
//   }
//
//   /// Initialize the chat
//   Future<void> _initializeChat() async {
//     await _cacheService.initialize();
//     await _audioService.initialize();
//
//     // Set this chat as active for preloading
//     _preloadService.setActiveChatId(chatId);
//
//     // Load initial messages
//     await _loadInitialMessages();
//
//     // Subscribe to new messages
//     _subscribeToMessages();
//
//     // Subscribe to typing indicator
//     _subscribeToTyping();
//
//     // Mark messages as delivered/seen
//     _markMessagesAsDelivered();
//     _markMessagesAsSeen();
//
//     isInitialLoading.value = false;
//   }
//
//   /// Load initial messages (most recent 20)
//   Future<void> _loadInitialMessages() async {
//     try {
//       final query = FirebaseFirestore.instance
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .orderBy('timestamp', descending: true)
//           .limit(pageSize);
//
//       final snapshot = await query.get();
//
//       if (snapshot.docs.isNotEmpty) {
//         _lastDocument = snapshot.docs.last;
//
//         final loadedMessages = snapshot.docs
//             .map((doc) => MessageModel.fromJson(doc.data()))
//             .toList();
//
//         // Reverse to show oldest first
//         messages.value = loadedMessages.reversed.toList();
//
//         // Queue media for background preloading
//         _preloadService.queueForPreload(messages, chatId);
//
//         hasMoreMessages.value = snapshot.docs.length >= pageSize;
//       } else {
//         hasMoreMessages.value = false;
//       }
//     } catch (e) {
//       debugPrint('Error loading messages: $e');
//     }
//   }
//
//   /// Load more messages when scrolling up
//   Future<void> loadMoreMessages() async {
//     if (isLoadingMore.value || !hasMoreMessages.value || _lastDocument == null) {
//       return;
//     }
//
//     isLoadingMore.value = true;
//
//     try {
//       final query = FirebaseFirestore.instance
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .orderBy('timestamp', descending: true)
//           .startAfterDocument(_lastDocument!)
//           .limit(pageSize);
//
//       final snapshot = await query.get();
//
//       if (snapshot.docs.isNotEmpty) {
//         _lastDocument = snapshot.docs.last;
//
//         final olderMessages = snapshot.docs
//             .map((doc) => MessageModel.fromJson(doc.data()))
//             .toList()
//             .reversed
//             .toList();
//
//         // Prepend older messages
//         messages.insertAll(0, olderMessages);
//
//         // Queue for background preloading
//         _preloadService.queueForPreload(olderMessages, chatId);
//
//         hasMoreMessages.value = snapshot.docs.length >= pageSize;
//       } else {
//         hasMoreMessages.value = false;
//       }
//     } catch (e) {
//       debugPrint('Error loading more messages: $e');
//     } finally {
//       isLoadingMore.value = false;
//     }
//   }
//
//   /// Subscribe to new messages in real-time
//   void _subscribeToMessages() {
//     _messagesSubscription = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((snapshot) {
//       for (var change in snapshot.docChanges) {
//         if (change.type == DocumentChangeType.added) {
//           final newMessage = MessageModel.fromJson(change.doc.data()!);
//
//           // Check if message already exists
//           final exists = messages.any((m) => m.messageId == newMessage.messageId);
//           if (!exists) {
//             messages.add(newMessage);
//
//             // Scroll to bottom for new messages
//             _scrollToBottom();
//
//             // Mark as seen if from other user
//             if (newMessage.senderId != currentUserId) {
//               _markMessageAsSeen(newMessage.messageId);
//             }
//
//             // Queue for preloading if media
//             if (newMessage.isMediaMessage) {
//               _preloadService.queueSingleUrl(
//                 newMessage.content,
//                 type: _getCacheType(newMessage.type),
//                 priority: PreloadPriority.high,
//               );
//             }
//           }
//         } else if (change.type == DocumentChangeType.modified) {
//           // Update existing message (for status updates)
//           final updatedMessage = MessageModel.fromJson(change.doc.data()!);
//           final index = messages.indexWhere(
//                 (m) => m.messageId == updatedMessage.messageId,
//           );
//           if (index != -1) {
//             messages[index] = updatedMessage;
//           }
//         }
//       }
//     });
//   }
//
//   /// Subscribe to typing indicator
//   void _subscribeToTyping() {
//     _typingSubscription = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('typing')
//         .doc(otherUserId)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.exists) {
//         final data = snapshot.data();
//         isOtherUserTyping.value = data?['isTyping'] ?? false;
//       }
//     });
//   }
//
//   /// Handle scroll events for pagination
//   void _onScroll() {
//     // Load more when reaching top
//     if (scrollController.position.pixels <= 100) {
//       loadMoreMessages();
//     }
//   }
//
//   /// Scroll to bottom
//   void _scrollToBottom() {
//     if (scrollController.hasClients) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       });
//     }
//   }
//
//   // ============ SENDING MESSAGES ============
//
//   /// Send text message
//   Future<void> sendTextMessage(String text) async {
//     if (text.trim().isEmpty) return;
//
//     final messageId = const Uuid().v4();
//     final message = MessageModel(
//       messageId: messageId,
//       chatId: chatId,
//       senderId: currentUserId,
//       senderName: currentUserName,
//       senderAvatar: currentUserAvatar,
//       type: MessageType.text,
//       content: text.trim(),
//       status: MessageStatus.sending,
//       timestamp: DateTime.now(),
//       replyToMessageId: replyToMessage.value?.messageId,
//       replyToMessage: replyToMessage.value != null
//           ? {
//         'messageId': replyToMessage.value!.messageId,
//         'content': replyToMessage.value!.content,
//         'type': replyToMessage.value!.type.name,
//         'senderName': replyToMessage.value!.senderName,
//       }
//           : null,
//     );
//
//     // Clear reply
//     replyToMessage.value = null;
//
//     // Add to UI immediately (optimistic update)
//     messages.add(message);
//     _scrollToBottom();
//     textController.clear();
//
//     // Send to Firebase
//     await _sendMessageToFirebase(message);
//   }
//
//   /// Send media message (image, video, audio, document)
//   Future<void> sendMediaMessage({
//     required File file,
//     required MessageType type,
//     String? fileName,
//     int? duration,
//     int? width,
//     int? height,
//   }) async {
//     final messageId = const Uuid().v4();
//
//     // Create pending message with local file path
//     final message = MessageModel(
//       messageId: messageId,
//       chatId: chatId,
//       senderId: currentUserId,
//       senderName: currentUserName,
//       senderAvatar: currentUserAvatar,
//       type: type,
//       content: '', // Will be updated with URL after upload
//       fileName: fileName ?? file.path.split('/').last,
//       fileExtension: file.path.split('.').last,
//       fileSize: await file.length(),
//       mediaDuration: duration,
//       mediaWidth: width,
//       mediaHeight: height,
//       status: MessageStatus.sending,
//       timestamp: DateTime.now(),
//       localFilePath: file.path,
//       replyToMessageId: replyToMessage.value?.messageId,
//       replyToMessage: replyToMessage.value != null
//           ? {
//         'messageId': replyToMessage.value!.messageId,
//         'content': replyToMessage.value!.content,
//         'type': replyToMessage.value!.type.name,
//         'senderName': replyToMessage.value!.senderName,
//       }
//           : null,
//     );
//
//     // Clear reply
//     replyToMessage.value = null;
//
//     // Add to UI immediately
//     messages.add(message);
//     _scrollToBottom();
//
//     // Upload file
//     uploadProgress[messageId] = 0.0;
//
//     try {
//       final uploadResult = await _uploadService.uploadFile(
//         file: file,
//         userId: currentUserId,
//         onProgress: (progress) {
//           uploadProgress[messageId] = progress;
//         },
//       );
//
//       if (uploadResult != null && uploadResult.status && uploadResult.files.isNotEmpty) {
//         final uploadedFile = uploadResult.files.first;
//
//         // Update message with URL
//         final updatedMessage = message.copyWith(
//           content: uploadedFile.url,
//           status: MessageStatus.sent,
//         );
//
//         // Update in list
//         final index = messages.indexWhere((m) => m.messageId == messageId);
//         if (index != -1) {
//           messages[index] = updatedMessage;
//         }
//
//         // Send to Firebase
//         await _sendMessageToFirebase(updatedMessage);
//
//         // Cache the file
//         await _cacheService.saveToCache(
//           uploadedFile.url,
//           await file.readAsBytes(),
//           type: _getCacheType(type),
//         );
//       } else {
//         // Upload failed
//         _updateMessageStatus(messageId, MessageStatus.failed);
//       }
//     } catch (e) {
//       debugPrint('Error sending media: $e');
//       _updateMessageStatus(messageId, MessageStatus.failed);
//     } finally {
//       uploadProgress.remove(messageId);
//     }
//   }
//
//   /// Send message to Firebase
//   Future<void> _sendMessageToFirebase(MessageModel message) async {
//     try {
//       // Save message
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .doc(message.messageId)
//           .set(message.toJson());
//
//       // Update chat metadata
//       await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
//         'lastMessage': message.type == MessageType.text
//             ? message.content
//             : _getMediaTypeLabel(message.type),
//         'lastMessageTime': FieldValue.serverTimestamp(),
//         'lastMessageSenderId': currentUserId,
//       });
//
//       // Update status to sent
//       _updateMessageStatus(message.messageId, MessageStatus.sent);
//     } catch (e) {
//       debugPrint('Error sending to Firebase: $e');
//       _updateMessageStatus(message.messageId, MessageStatus.failed);
//     }
//   }
//
//   /// Update message status
//   void _updateMessageStatus(String messageId, MessageStatus status) {
//     final index = messages.indexWhere((m) => m.messageId == messageId);
//     if (index != -1) {
//       messages[index] = messages[index].copyWith(status: status);
//     }
//   }
//
//   /// Retry failed message
//   Future<void> retryMessage(MessageModel message) async {
//     if (message.status != MessageStatus.failed) return;
//
//     _updateMessageStatus(message.messageId, MessageStatus.sending);
//
//     if (message.isMediaMessage && message.localFilePath != null) {
//       // Re-upload media
//       final file = File(message.localFilePath!);
//       if (await file.exists()) {
//         await sendMediaMessage(
//           file: file,
//           type: message.type,
//           fileName: message.fileName,
//           duration: message.mediaDuration,
//           width: message.mediaWidth,
//           height: message.mediaHeight,
//         );
//       } else {
//         _updateMessageStatus(message.messageId, MessageStatus.failed);
//       }
//     } else {
//       // Re-send text
//       await _sendMessageToFirebase(message);
//     }
//   }
//
//   // ============ MESSAGE STATUS ============
//
//   /// Mark messages as delivered
//   Future<void> _markMessagesAsDelivered() async {
//     try {
//       final batch = FirebaseFirestore.instance.batch();
//
//       for (final message in messages) {
//         if (message.senderId != currentUserId &&
//             !message.deliveredTo.contains(currentUserId)) {
//           final ref = FirebaseFirestore.instance
//               .collection('chats')
//               .doc(chatId)
//               .collection('messages')
//               .doc(message.messageId);
//
//           batch.update(ref, {
//             'deliveredTo': FieldValue.arrayUnion([currentUserId]),
//             'status': MessageStatus.delivered.name,
//           });
//         }
//       }
//
//       await batch.commit();
//     } catch (e) {
//       debugPrint('Error marking as delivered: $e');
//     }
//   }
//
//   /// Mark messages as seen
//   Future<void> _markMessagesAsSeen() async {
//     try {
//       final batch = FirebaseFirestore.instance.batch();
//
//       for (final message in messages) {
//         if (message.senderId != currentUserId &&
//             !message.seenBy.contains(currentUserId)) {
//           final ref = FirebaseFirestore.instance
//               .collection('chats')
//               .doc(chatId)
//               .collection('messages')
//               .doc(message.messageId);
//
//           batch.update(ref, {
//             'seenBy': FieldValue.arrayUnion([currentUserId]),
//             'status': MessageStatus.seen.name,
//           });
//         }
//       }
//
//       await batch.commit();
//     } catch (e) {
//       debugPrint('Error marking as seen: $e');
//     }
//   }
//
//   /// Mark single message as seen
//   Future<void> _markMessageAsSeen(String messageId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .doc(messageId)
//           .update({
//         'seenBy': FieldValue.arrayUnion([currentUserId]),
//         'status': MessageStatus.seen.name,
//       });
//     } catch (e) {
//       debugPrint('Error marking as seen: $e');
//     }
//   }
//
//   // ============ TYPING INDICATOR ============
//
//   /// Set typing status
//   void setTyping(bool isTyping) {
//     _typingTimer?.cancel();
//
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('typing')
//         .doc(currentUserId)
//         .set({
//       'isTyping': isTyping,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     // Auto-clear typing after 5 seconds
//     if (isTyping) {
//       _typingTimer = Timer(const Duration(seconds: 5), () {
//         setTyping(false);
//       });
//     }
//   }
//
//   // ============ VISIBILITY TRACKING ============
//
//   /// Called when a message becomes visible
//   void onMessageVisible(String messageId, MessageModel message) {
//     if (_visibleMessageIds.contains(messageId)) return;
//     _visibleMessageIds.add(messageId);
//
//     // Lazy load media when visible
//     if (message.isMediaMessage) {
//       _preloadService.queueSingleUrl(
//         message.content,
//         type: _getCacheType(message.type),
//         priority: PreloadPriority.high,
//       );
//
//       // Also load thumbnail for videos
//       if (message.isVideo && message.thumbnailUrl != null) {
//         _preloadService.queueSingleUrl(
//           message.thumbnailUrl!,
//           type: MediaCacheType.thumbnail,
//           priority: PreloadPriority.high,
//         );
//       }
//     }
//   }
//
//   /// Called when a message becomes invisible
//   void onMessageInvisible(String messageId) {
//     _visibleMessageIds.remove(messageId);
//   }
//
//   // ============ HELPERS ============
//
//   MediaCacheType _getCacheType(MessageType type) {
//     switch (type) {
//       case MessageType.image:
//         return MediaCacheType.image;
//       case MessageType.video:
//         return MediaCacheType.video;
//       case MessageType.audio:
//       case MessageType.voiceNote:
//         return MediaCacheType.audio;
//       case MessageType.document:
//         return MediaCacheType.document;
//       default:
//         return MediaCacheType.image;
//     }
//   }
//
//   String _getMediaTypeLabel(MessageType type) {
//     switch (type) {
//       case MessageType.image:
//         return '📷 Image';
//       case MessageType.video:
//         return '🎬 Video';
//       case MessageType.audio:
//         return '🎵 Audio';
//       case MessageType.voiceNote:
//         return '🎤 Voice message';
//       case MessageType.document:
//         return '📄 Document';
//       default:
//         return '';
//     }
//   }
//
//   /// Set reply to message
//   void setReplyTo(MessageModel message) {
//     replyToMessage.value = message;
//   }
//
//   /// Clear reply
//   void clearReply() {
//     replyToMessage.value = null;
//   }
//
//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(chatId)
//           .collection('messages')
//           .doc(messageId)
//           .update({'isDeleted': true});
//
//       final index = messages.indexWhere((m) => m.messageId == messageId);
//       if (index != -1) {
//         messages[index] = messages[index].copyWith(isDeleted: true);
//       }
//     } catch (e) {
//       debugPrint('Error deleting message: $e');
//     }
//   }
// }




import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/home/home_controller.dart';
import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
import 'package:the_friendz_zone/screens/message/models/message_model.dart';
import 'package:the_friendz_zone/screens/message/widgets/file_upload_service.dart';
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
  // Future<void> sendRecordedAudio() async {
  //   if (_recordedAudioPath == null || _recordedAudioFile == null) {
  //     print("No recorded audio to send");
  //     return;
  //   }
  //
  //   try {
  //     // ✅ Check if file exists
  //     if (!await _recordedAudioFile!.exists()) {
  //       print("Audio file does not exist at path: ${_recordedAudioFile!.path}");
  //       Get.snackbar(
  //         'Error',
  //         'Audio file not found',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: AppColors.redColor.withOpacity(0.8),
  //         colorText: AppColors.whiteColor,
  //       );
  //       _resetRecordingState();
  //       return;
  //     }
  //
  //     if (chatId == null) {
  //       final newChat = await _createNewChat(otherUserId);
  //       chatId = newChat.chatId;
  //       _initChatData();
  //     }
  //
  //     isUploading.value = true;
  //     uploadProgress.value = 0.0;
  //
  //     // ✅ Upload with progress tracking
  //     final url = await _uploadFileToStorageWithProgress(
  //       file: _recordedAudioFile!,
  //       path: 'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
  //     );
  //
  //     await sendMessage(
  //       messageText: 'Audio message',
  //       type: 'audio',
  //       mediaUrl: url,
  //       fileName: 'Audio',
  //     );
  //
  //     print("✅ Audio Sent Successfully --> $url");
  //     _resetRecordingState();
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //   } catch (e) {
  //     print("❌ Error sending recorded audio: $e");
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //     Get.snackbar(
  //       'Error',
  //       'Failed to send audio',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.redColor.withOpacity(0.8),
  //       colorText: AppColors.whiteColor,
  //     );
  //     _resetRecordingState();
  //   }
  // }
  Future<void> sendRecordedAudio() async {
    if (_recordedAudioFile == null) return;

    try {
      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      isUploading.value = true;

      // Upload audio to server
      final url = await _uploadFileToServer(_recordedAudioFile!);

      await sendMessage(
        messageText: 'Audio message',
        type: 'audio',
        mediaUrl: url,
        fileName: "Audio",
      );

      _resetRecordingState();
      isUploading.value = false;
    } catch (e) {
      print("❌ Audio upload error: $e");
      isUploading.value = false;
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
  // Future<void> pickImageFromGallery() async {
  //   try {
  //     final pickedFile = await _imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 80,
  //     );
  //
  //     if (pickedFile == null) return;
  //
  //     if (chatId == null) {
  //       final newChat = await _createNewChat(otherUserId);
  //       chatId = newChat.chatId;
  //       _initChatData();
  //     }
  //
  //     final file = File(pickedFile.path);
  //
  //     isUploading.value = true;
  //     uploadProgress.value = 0.0;
  //
  //     final url = await _uploadFileToStorageWithProgress(
  //       file: file,
  //       path: 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
  //     );
  //
  //     await sendMessage(
  //       messageText: '',
  //       type: 'image',
  //       mediaUrl: url,
  //       fileName: 'Photo',
  //     );
  //
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //   } catch (e) {
  //     print('❌ Error picking image from gallery: $e');
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //     Get.snackbar(
  //       'Error',
  //       'Failed to send image',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.redColor.withOpacity(0.8),
  //       colorText: AppColors.whiteColor,
  //     );
  //   }
  // }
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

      // UPLOAD TO SERVER
      final url = await _uploadFileToServer(file);

      await sendMessage(
        messageText: '',
        type: 'image',
        mediaUrl: url,
        fileName: "Image",
      );

      isUploading.value = false;
    } catch (e) {
      print('❌ Image upload error: $e');
      isUploading.value = false;
    }
  }


  // ===================== CAMERA - CAPTURE & SEND =====================

  /// Capture image from camera and send
  // Future<void> captureImageFromCamera() async {
  //   try {
  //     final pickedFile = await _imagePicker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 80,
  //     );
  //
  //     if (pickedFile == null) return;
  //
  //     if (chatId == null) {
  //       final newChat = await _createNewChat(otherUserId);
  //       chatId = newChat.chatId;
  //       _initChatData();
  //     }
  //
  //     final file = File(pickedFile.path);
  //
  //     isUploading.value = true;
  //     uploadProgress.value = 0.0;
  //
  //     final url = await _uploadFileToStorageWithProgress(
  //       file: file,
  //       path: 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
  //     );
  //
  //     await sendMessage(
  //       messageText: '',
  //       type: 'image',
  //       mediaUrl: url,
  //       fileName: 'Photo',
  //     );
  //
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //   } catch (e) {
  //     print('❌ Error capturing image from camera: $e');
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //     Get.snackbar(
  //       'Error',
  //       'Failed to send image',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.redColor.withOpacity(0.8),
  //       colorText: AppColors.whiteColor,
  //     );
  //   }
  // }
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

      // Upload to server
      final url = await _uploadFileToServer(file);

      await sendMessage(
        messageText: '',
        type: 'image',
        mediaUrl: url,
        fileName: "Camera Image",
      );

      isUploading.value = false;
    } catch (e) {
      print('❌ Camera upload error: $e');
      isUploading.value = false;
    }
  }


  // ===================== FILE PICKER - ALL FILES =====================

  /// Pick any file from device
  // Future<void> pickFileAndSend() async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.any,
  //       allowMultiple: false,
  //     );
  //
  //     if (result == null || result.files.single.path == null) return;
  //
  //     if (chatId == null) {
  //       final newChat = await _createNewChat(otherUserId);
  //       chatId = newChat.chatId;
  //       _initChatData();
  //     }
  //
  //     final file = File(result.files.single.path!);
  //     final fileName = result.files.single.name;
  //     final fileExtension = fileName.split('.').last.toLowerCase();
  //
  //     isUploading.value = true;
  //     uploadProgress.value = 0.0;
  //
  //     // Determine file type
  //     String messageType = 'file';
  //     String storagePath;
  //
  //     // Check if it's an image
  //     if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(fileExtension)) {
  //       messageType = 'image';
  //       storagePath = 'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}_$fileName';
  //     }
  //     // Check if it's a video
  //     else if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'].contains(fileExtension)) {
  //       messageType = 'video';
  //       storagePath = 'chats/$chatId/videos/${DateTime.now().millisecondsSinceEpoch}_$fileName';
  //     }
  //     // Check if it's audio
  //     else if (['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'].contains(fileExtension)) {
  //       messageType = 'audio';
  //       storagePath = 'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}_$fileName';
  //     }
  //     // Other files
  //     else {
  //       storagePath = 'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName';
  //     }
  //
  //     final url = await _uploadFileToStorageWithProgress(
  //       file: file,
  //       path: storagePath,
  //     );
  //
  //     await sendMessage(
  //       messageText: messageType == 'file' ? fileName : '',
  //       type: messageType,
  //       mediaUrl: url,
  //       fileName: fileName,
  //     );
  //
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //   } catch (e) {
  //     print('❌ Error picking file: $e');
  //     isUploading.value = false;
  //     uploadProgress.value = 0.0;
  //     Get.snackbar(
  //       'Error',
  //       'Failed to send file',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.redColor.withOpacity(0.8),
  //       colorText: AppColors.whiteColor,
  //     );
  //   }
  // }
  Future<void> pickFileAndSend() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result == null || result.files.single.path == null) return;

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      isUploading.value = true;

      // Upload to server
      final url = await _uploadFileToServer(file);

      final type = FileUploadService.getFileTypeCategory(fileName);

      await sendMessage(
        messageText: type == 'document' ? fileName : '',
        type: type,
        mediaUrl: url,
        fileName: fileName,
      );

      isUploading.value = false;
    } catch (e) {
      print('❌ File upload error: $e');
      isUploading.value = false;
    }
  }


  // ===================== STORAGE UPLOAD WITH PROGRESS =====================

  // /// Upload file to Firebase Storage with progress tracking
  // Future<String> _uploadFileToStorageWithProgress({
  //   required File file,
  //   required String path,
  // }) async {
  //   try {
  //     print('📤 Starting upload to: $path');
  //     print('📁 File path: ${file.path}');
  //     print('📊 File size: ${await file.length()} bytes');
  //
  //     // ✅ Verify file exists before upload
  //     if (!await file.exists()) {
  //       throw Exception('File does not exist at path: ${file.path}');
  //     }
  //
  //     final storageRef = FirebaseStorage.instance.ref();
  //     final fileRef = storageRef.child(path);
  //
  //     // ✅ Use putFile instead of put
  //     final uploadTask = fileRef.putFile(file);
  //
  //     // Listen to upload progress
  //     uploadTask.snapshotEvents.listen(
  //           (TaskSnapshot snapshot) {
  //         final progress = snapshot.bytesTransferred / snapshot.totalBytes;
  //         uploadProgress.value = progress;
  //         print('📈 Upload Progress: ${(progress * 100).toStringAsFixed(2)}%');
  //       },
  //       onError: (error) {
  //         print('❌ Upload stream error: $error');
  //       },
  //     );
  //
  //     // Wait for upload to complete
  //     final taskSnapshot = await uploadTask.whenComplete(() => null);
  //
  //     // Get download URL
  //     final url = await taskSnapshot.ref.getDownloadURL();
  //
  //     print('✅ File uploaded successfully: $url');
  //     return url;
  //   } catch (e, stackTrace) {
  //     print('❌ Error uploading file: $e');
  //     print('Stack trace: $stackTrace');
  //     rethrow;
  //   }
  // }

  // ===================== SERVER UPLOAD (INSTEAD OF FIREBASE STORAGE) =====================

  Future<String> _uploadFileToServer(File file) async {
    try {
      final response = await FileUploadService().uploadSingleFile(file);

      if (response == null || response.files.isEmpty) {
        throw Exception("Upload failed: empty response");
      }

      final uploaded = response.files.first;

      print("✅ Server Upload Success → ${uploaded.url}");
      return uploaded.url;
    } catch (e) {
      print("❌ Server Upload Error: $e");
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
