import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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

  ChatController({
    this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserProfileUrl,
    this.isGroup = false,
  });

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
    super.onClose();
  }

  Future<void> sendMessage({required String messageText}) async {
    if (messageText.trim().isEmpty) return;

    try {
      if (chatId == null) {
        final newChat = await _createNewChat(otherUserId);
        chatId = newChat.chatId;
        _initChatData();
      }

      final newMessage = Message(
        senderId: currentUserId,
        message: messageText,
        readBy: [],
        isSent: false,
      );

      messages.add(newMessage);
      inputText.value = '';

      await _writeNewMessage(newMessage);

      final index = messages.indexOf(newMessage);
      if (index != -1) {
        messages[index] = newMessage..isSent = true;
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

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
    });
  }

  Future<void> _writeNewMessage(Message message) async {
    final chatRef =
        FirebaseFirestore.instance.collection(FirebaseUtils.chats).doc(chatId);

    final batch = FirebaseFirestore.instance.batch();

    final messageRef = chatRef.collection('messages').doc();
    batch.set(messageRef, message.toMap());

    final chatUpdate = <String, dynamic>{
      'lastMessage': message.message,
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

      for (final msgDoc in allMessagesSnapshot.docs) {
        final msgData = msgDoc.data();
        final readByList = List<String>.from(msgData['readBy'] ?? []);

        if (!readByList.contains(currentUserId)) {
          batch.update(msgDoc.reference, {
            'readBy': FieldValue.arrayUnion([currentUserId]),
          });
        }
      }

      batch.update(chatRef, {'unreadMessages.$currentUserId': 0});

      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<ChatModel> _createNewChat(String otherUserId) async {
    try {
      final participants = [currentUserId, otherUserId]..sort();
      final chatId = participants.join('_');
      final chatRef = FirebaseFirestore.instance
          .collection(FirebaseUtils.chats)
          .doc(chatId);

      // Create participant data maps
      final participantNames = {
        otherUserId: otherUserName,
      };
      final participantProfileUrls = {
        otherUserId: otherUserProfileUrl,
      };

      // Add current user data to the maps
      participantNames[currentUserId] =
          Get.find<HomeController>().userResponse.data?.fullname ?? "";
      participantProfileUrls[currentUserId] =
          Get.find<HomeController>().userResponse.data?.profile ?? "";

      final chatModel = ChatModel(
        chatId: chatRef.id,
        isGroupChat: isGroup,
        participantIds: [currentUserId, otherUserId],
        participantNames: participantNames,
        participantProfileUrls: participantProfileUrls,
        lastMessage: '',
      );

      await chatRef.set(chatModel.toMap());
      return chatModel;
    } catch (e) {
      rethrow;
    }
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
