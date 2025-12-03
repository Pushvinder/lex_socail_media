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

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/home/home_controller.dart';
import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
import 'package:the_friendz_zone/screens/message/models/message_model.dart';
import 'package:the_friendz_zone/screens/profile/profile_controller.dart';
import 'package:the_friendz_zone/utils/firebase_utils.dart';

class ChatController extends GetxController {
  String? chatId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserProfileUrl;
  final bool isGroup;

  final String currentUserId = StorageHelper().getUserId.toString();
  RxList<Message> messages = <Message>[].obs;
  StreamSubscription? _messageSubscription;
  RxString inputText = ''.obs;

  final ScrollController scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  RxBool isRecording = false.obs;
  RxString recordingDuration = '00:00'.obs;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  // Audio recording variables
  late final AudioRecorder _audioRecorder;
  String? _recordedAudioPath;
  File? _recordedAudioFile;

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
    if (chatId != null) {
      _initChatData();
    }
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    scrollController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    super.onClose();
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

  // ===================== TEXT MESSAGE =====================
  Future<void> sendMessage({
    required String messageText,
    required String type,
    String? mediaUrl,
    String? fileName,
  }) async {
    if (messageText.trim().isEmpty && mediaUrl == null) return;

    try {
      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final newMessage = Message(
        senderId: currentUserId,
        message: messageText.trim(),
        type: type,
        mediaUrl: mediaUrl,
        fileName: fileName,
        readBy: [],
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
    }
  }

  // ===================== SEND RECORDED AUDIO =====================
  Future<void> sendRecordedAudio() async {
    if (_recordedAudioPath == null || _recordedAudioFile == null) {
      print("No recorded audio to send");
      return;
    }

    try {
      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final url = await _uploadFileToStorage(
        file: _recordedAudioFile!,
        path:
            'chats/$chatId/audio/${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      await sendMessage(
        messageText: 'Audio message',
        type: 'audio',
        mediaUrl: url,
        fileName: 'Audio',
      );

      print("Audio Sent Successfully --> $url");

      // Reset recording state
      _resetRecordingState();
    } catch (e) {
      print("Error sending recorded audio: $e");
    }
  }

  void _resetRecordingState() {
    _recordedAudioPath = null;
    _recordedAudioFile = null;
    recordingDuration.value = '00:00';
  }

  // ===================== VOICE RECORDING =====================
  Future<void> startRecording() async {
    try {
      // Check permissions
      if (!await _audioRecorder.hasPermission()) {
        print("Microphone permission denied");
        return;
      }

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      // Configure audio recording
      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      // Get temp directory for recording
      final tempDir = await getTemporaryDirectory();
      _recordedAudioPath =
          '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording
      await _audioRecorder.start(config, path: _recordedAudioPath!);

      // Start timer
      isRecording.value = true;
      _recordingSeconds = 0;
      _startRecordingTimer();

      print("Recording Started... Path: $_recordedAudioPath");
    } catch (e) {
      print("Recording Error: $e");
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    try {
      _recordingTimer?.cancel();
      isRecording.value = false;

      // Stop recording and get file path
      final String? path = await _audioRecorder.stop();
      if (path == null) {
        print("No audio recorded");
        _resetRecordingState();
        return;
      }

      _recordedAudioFile = File(path);
      print("Recording stopped. File saved at: $path");

      // Keep the recording ready for sending
      // Don't reset the duration so user can see how long they recorded
    } catch (e) {
      print("Stop Recording Error: $e");
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

      final allMessagesSnapshot = await chatRef.collection('messages').get();

      if (allMessagesSnapshot.docs.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();
      bool hasUnread = false;

      for (final msgDoc in allMessagesSnapshot.docs) {
        final msgData = msgDoc.data();
        final senderId = msgData['senderId'];
        final readBy = List<String>.from(msgData['readBy'] ?? []);

        if (senderId != currentUserId && !readBy.contains(currentUserId)) {
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

  // ===================== IMAGE FROM CAMERA =====================
  Future<void> pickImageAndSend() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 80);
      if (pickedFile == null) return;

      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final file = File(pickedFile.path);
      final url = await _uploadFileToStorage(
        file: file,
        path:
            'chats/$chatId/images/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await sendMessage(
        messageText: '',
        type: 'image',
        mediaUrl: url,
        fileName: 'Photo',
      );
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // ===================== FILE PICKER =====================
  Future<void> pickFileAndSend() async {
    try {
      final result = await FilePicker.platform.pickFiles(
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

      final url = await _uploadFileToStorage(
        file: file,
        path:
            'chats/$chatId/files/${DateTime.now().millisecondsSinceEpoch}_$fileName',
      );

      await sendMessage(
        messageText: fileName,
        type: 'file',
        mediaUrl: url,
        fileName: fileName,
      );
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  // ===================== STORAGE UPLOAD =====================
  Future<String> _uploadFileToStorage({
    required File file,
    required String path,
  }) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = await ref.putFile(file);
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  // ===================== CREATE CHAT =====================
  Future<ChatModel> _createNewChat(String otherUserId) async {
    try {
      final participants = [currentUserId, otherUserId]..sort();
      final chatId = participants.join('_');
      final chatRef = FirebaseFirestore.instance
          .collection(FirebaseUtils.chats)
          .doc(chatId);

      // Check if chat already exists
      final existingChat = await chatRef.get();
      if (existingChat.exists) {
        return ChatModel.fromJson(existingChat.data()!);
      }

      final participantNames = {
        otherUserId: otherUserName,
        currentUserId:
            Get.find<HomeController>().userResponse.data?.fullname ?? "",
      };

      final participantProfileUrls = {
        otherUserId: otherUserProfileUrl,
        currentUserId:
            Get.find<HomeController>().userResponse.data?.profile ?? "",
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
      );

      await chatRef.set(chatModel.toMap());
      return chatModel;
    } catch (e) {
      rethrow;
    }
  }

  // Add this method to your ChatController class
  void cancelRecording() {
    // Stop the recording timer
    _recordingTimer?.cancel();

    // Reset all recording states
    isRecording.value = false;
    recordingDuration.value = '00:00';
    _recordingSeconds = 0;
    _recordedAudioPath = null;
    _recordedAudioFile = null;

    print("Recording cancelled");
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
