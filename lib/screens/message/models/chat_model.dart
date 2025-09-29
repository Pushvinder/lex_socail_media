import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String chatId;
  bool isGroupChat;
  String? groupName;
  String? groupIcon;
  String? creatorId;
  List<String> participantIds;
  Timestamp? lastMessageTime;
  String lastMessage;
  Map<String, int>? unreadMessages;
  Map<String, bool>? blocked;

  ChatModel({
    required this.chatId,
    required this.isGroupChat,
    this.groupName,
    this.groupIcon,
    this.creatorId,
    required this.participantIds,
    this.lastMessageTime,
    required this.lastMessage,
    this.unreadMessages,
    this.blocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'isGroupChat': isGroupChat,
      'groupName': groupName,
      'groupIcon': groupIcon,
      'creatorId': creatorId,
      'participantIds': participantIds,
      'lastMessageTime': lastMessageTime ?? FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'unreadMessages': unreadMessages,
      'blocked': blocked,
    };
  }

  Map<String, dynamic> toGroupMap() {
    return {
      'chatId': chatId,
      'isGroupChat': isGroupChat,
      'groupName': groupName,
      'groupIcon': groupIcon,
      'creatorId': creatorId,
      'participantIds': participantIds,
      'lastMessageTime': lastMessageTime ?? FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'blocked': blocked,
    };
  }

  static ChatModel fromJson(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'],
      isGroupChat: map['isGroupChat'],
      groupName: map['groupName'],
      groupIcon: map['groupIcon'],
      creatorId: map['creatorId'],
      participantIds: List<String>.from(map['participantIds']),
      lastMessageTime:
      map['lastMessageTime'] ,
      lastMessage: map['lastMessage'] ?? "",
      unreadMessages: Map<String, int>.from(map['unreadMessages'] ?? {}),
      blocked: Map<String, bool>.from(map['blocked'] ?? {}),
    );
  }
}

class UserChatModel {
  String? name;
  String? uId;
  String? profile;
  String? phoneNumber;
  ChatModel? chatModel;

  UserChatModel({
    this.name,
    this.uId,
    this.profile,
    this.phoneNumber,
    this.chatModel,
  });

  static UserChatModel fromJson(Map<String, dynamic> map) {
    return UserChatModel(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      uId: map['uId'],
      profile: map['profile'],
      chatModel: map['chatModel'] != null
          ? ChatModel.fromJson(
              map['chatModel'],
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uId": uId,
      "profile": profile,
      "phoneNumber": phoneNumber,
      "chatModel": chatModel?.toMap(),
    };
  }

  UserChatModel copyWith(UserChatModel userChatModel) {
    return UserChatModel(
      name: userChatModel.name,
      phoneNumber: userChatModel.phoneNumber,
      uId: userChatModel.uId,
      profile: userChatModel.profile,
      chatModel: userChatModel.chatModel,
    );
  }
}
