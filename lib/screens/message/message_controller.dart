
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/screens/message/models/chat_model.dart';
import 'package:the_friendz_zone/screens/user_profile/models/user_model.dart';
import 'package:the_friendz_zone/utils/firebase_utils.dart';

import '../user_profile/user_presence_service.dart';

class MessageController extends GetxController {
  RxString currentOpenedChat = "".obs;

  final String currentUserId = StorageHelper().getUserId.toString();
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<ChatModel> filteredChatList = <ChatModel>[].obs;
  Map<String, UserProfileData> chatParticipants = {};

  // ✅ Track online status for each user
  RxMap<String, bool> userOnlineStatus = <String, bool>{}.obs;
  Map<String, StreamSubscription> _onlineStatusSubscriptions = {};

  RxString searchQuery = ''.obs;
  StreamSubscription? _chatSubscription;

  final UserPresenceService _presenceService = UserPresenceService();

  @override
  void onInit() {
    super.onInit();
    _subscribeToChats();
    ever(searchQuery, (_) => _filterChats());
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    _onlineStatusSubscriptions.forEach((key, subscription) {
      subscription.cancel();
    });
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

        // ✅ Subscribe to online status for each participant
        _subscribeToParticipantStatus(chat);
      }
      chatList.value = fetchedChats;
      _filterChats();
    });
  }

  // ✅ Subscribe to participant's online status
  void _subscribeToParticipantStatus(ChatModel chat) {
    for (String uid in chat.participantIds) {
      if (uid != currentUserId && !_onlineStatusSubscriptions.containsKey(uid)) {
        _onlineStatusSubscriptions[uid] = _presenceService
            .getUserOnlineStatus(uid)
            .listen((isOnline) {
          userOnlineStatus[uid] = isOnline;
        });
      }
    }
  }

  Future<void> _fetchChatParticipants(ChatModel chat) async {
    for (String uid in chat.participantIds) {
      if (uid != currentUserId) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection(FirebaseUtils.users)
              .doc(uid)
              .get();

          if (userDoc.exists && userDoc.data() != null) {
            chatParticipants[uid] = UserProfileData.fromJson(userDoc.data()!);
          } else {
            if (chat.participantNames != null &&
                chat.participantNames!.containsKey(uid)) {
              chatParticipants[uid] = UserProfileData(
                id: int.tryParse(uid).toString(),
                fullname: chat.participantNames![uid],
                profile: chat.participantProfileUrls?[uid],
              );
            }
          }
        } catch (e) {
          print('Error fetching participant $uid: $e');
          if (chat.participantNames != null &&
              chat.participantNames!.containsKey(uid)) {
            chatParticipants[uid] = UserProfileData(
              id: int.tryParse(uid).toString(),
              fullname: chat.participantNames![uid],
              profile: chat.participantProfileUrls?[uid],
            );
          }
        }
      }
    }

    chatParticipants = Map.from(chatParticipants);
    update();
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
      final userName = otherUser?.fullname?.toLowerCase() ?? '';
      final lastMessage = chat.lastMessage.toLowerCase();

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

  // ✅ Get online status for a user
  bool isUserOnline(String userId) {
    return userOnlineStatus[userId] ?? false;
  }

  String? getOtherParticipantName(ChatModel chat) {
    final otherUserId = chat.participantIds.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '',
    );

    if (chat.participantNames != null &&
        chat.participantNames!.containsKey(otherUserId)) {
      return chat.participantNames![otherUserId];
    }

    final otherUser = chatParticipants[otherUserId];
    return otherUser?.fullname ?? 'Unknown User';
  }

  String? getOtherParticipantProfileUrl(ChatModel chat) {
    final otherUserId = chat.participantIds.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '',
    );

    if (chat.participantProfileUrls != null &&
        chat.participantProfileUrls!.containsKey(otherUserId)) {
      return chat.participantProfileUrls![otherUserId];
    }

    final otherUser = chatParticipants[otherUserId];
    return otherUser?.profile ?? '';
  }

  String getOtherParticipantId(ChatModel chat) {
    return chat.participantIds.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '',
    );
  }
}