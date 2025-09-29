import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
import 'package:the_friendz_zone/screens/user_profile/models/user_model.dart';
import 'package:the_friendz_zone/utils/firebase_utils.dart';
import 'models/message_model.dart';

class MessageController extends GetxController {
  RxString currentOpenedChat = "".obs; //current open chat id

  final String currentUserId = StorageHelper().getUserId.toString() ?? '';
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<ChatModel> filteredChatList = <ChatModel>[].obs;
  Map<String, UserProfileData> chatParticipants = {};

  RxString searchQuery = ''.obs;
  StreamSubscription? _chatSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToChats();
    ever(searchQuery, (_) => _filterChats());
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }

  List<ChatModel> get filteredMessages {
    return filteredChatList;
  }

  Future<void> _subscribeToChats() async {
    _chatSubscription = FirebaseFirestore.instance
        .collection(FirebaseUtils.chats)
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final List<ChatModel> fetchedChats = [];
      for (var doc in snapshot.docs) {
        final chat = ChatModel.fromJson(doc.data());
        fetchedChats.add(chat);
        await _fetchChatParticipants(chat);
      }
      chatList.value = fetchedChats;
      _filterChats(); // Apply filter after fetching chats
    });
  }

  Future<void> _fetchChatParticipants(ChatModel chat) async {
    for (String uid in chat.participantIds) {
      if (uid != currentUserId && !chatParticipants.containsKey(uid)) {
        final userDoc = await FirebaseFirestore.instance
            .collection(FirebaseUtils.users)
            .doc(uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          chatParticipants[uid] = UserProfileData.fromJson(userDoc.data()!);
        }
      }
    }
  }

  void _filterChats() {
    if (searchQuery.value.isEmpty) {
      filteredChatList.value = chatList;
      return;
    }
    final query = searchQuery.value.toLowerCase();
    filteredChatList.value = chatList.where((chat) {
      final otherUserId = chat.participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );
      final otherUser = chatParticipants[otherUserId];
      final userName = otherUser?.fullName?.toLowerCase() ?? '';
      final lastMessage = chat.lastMessage?.toLowerCase() ?? '';

      return userName.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  UserProfileData? getOtherParticipant(ChatModel chat) {
    final otherUserId = chat.participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    return chatParticipants[otherUserId];
  }
}
