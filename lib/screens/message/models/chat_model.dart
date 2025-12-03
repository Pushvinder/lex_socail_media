// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatModel {
//   String chatId;
//   bool isGroupChat;
//   String? groupName;
//   String? groupIcon;
//   String? creatorId;
//   List<String> participantIds;
//   Map<String, String>?
//       participantNames; // Store id: name mapping for both users
//   Map<String, String>?
//       participantProfileUrls; // Store id: profileUrl mapping for both users
//   Timestamp? lastMessageTime;
//   String lastMessage;
//   Map<String, int>? unreadMessages;
//   Map<String, bool>? blocked;

//   ChatModel({
//     required this.chatId,
//     required this.isGroupChat,
//     this.groupName,
//     this.groupIcon,
//     this.creatorId,
//     required this.participantIds,
//     this.participantNames,
//     this.participantProfileUrls,
//     this.lastMessageTime,
//     required this.lastMessage,
//     this.unreadMessages,
//     this.blocked,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'chatId': chatId,
//       'isGroupChat': isGroupChat,
//       'groupName': groupName,
//       'groupIcon': groupIcon,
//       'creatorId': creatorId,
//       'participantIds': participantIds,
//       'participantNames': participantNames,
//       'participantProfileUrls': participantProfileUrls,
//       'lastMessageTime': lastMessageTime ?? FieldValue.serverTimestamp(),
//       'lastMessage': lastMessage,
//       'unreadMessages': unreadMessages,
//       'blocked': blocked,
//     };
//   }

//   Map<String, dynamic> toGroupMap() {
//     return {
//       'chatId': chatId,
//       'isGroupChat': isGroupChat,
//       'groupName': groupName,
//       'groupIcon': groupIcon,
//       'creatorId': creatorId,
//       'participantIds': participantIds,
//       'participantNames': participantNames,
//       'participantProfileUrls': participantProfileUrls,
//       'lastMessageTime': lastMessageTime ?? FieldValue.serverTimestamp(),
//       'lastMessage': lastMessage,
//       'blocked': blocked,
//     };
//   }

//   static ChatModel fromJson(Map<String, dynamic> map) {
//     return ChatModel(
//       chatId: map['chatId'],
//       isGroupChat: map['isGroupChat'],
//       groupName: map['groupName'],
//       groupIcon: map['groupIcon'],
//       creatorId: map['creatorId'],
//       participantIds: List<String>.from(map['participantIds']),
//       participantNames: map['participantNames'] != null
//           ? Map<String, String>.from(map['participantNames'])
//           : null,
//       participantProfileUrls: map['participantProfileUrls'] != null
//           ? Map<String, String>.from(map['participantProfileUrls'])
//           : null,
//       lastMessageTime: map['lastMessageTime'],
//       lastMessage: map['lastMessage'] ?? "",
//       unreadMessages: Map<String, int>.from(map['unreadMessages'] ?? {}),
//       blocked: Map<String, bool>.from(map['blocked'] ?? {}),
//     );
//   }
// }

// class UserChatModel {
//   String? name;
//   String? uId;
//   String? profile;
//   String? phoneNumber;
//   ChatModel? chatModel;

//   UserChatModel({
//     this.name,
//     this.uId,
//     this.profile,
//     this.phoneNumber,
//     this.chatModel,
//   });

//   static UserChatModel fromJson(Map<String, dynamic> map) {
//     return UserChatModel(
//       name: map['name'],
//       phoneNumber: map['phoneNumber'],
//       uId: map['uId'],
//       profile: map['profile'],
//       chatModel: map['chatModel'] != null
//           ? ChatModel.fromJson(
//               map['chatModel'],
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "name": name,
//       "uId": uId,
//       "profile": profile,
//       "phoneNumber": phoneNumber,
//       "chatModel": chatModel?.toMap(),
//     };
//   }

//   UserChatModel copyWith(UserChatModel userChatModel) {
//     return UserChatModel(
//       name: userChatModel.name,
//       phoneNumber: userChatModel.phoneNumber,
//       uId: userChatModel.uId,
//       profile: userChatModel.profile,
//       chatModel: userChatModel.chatModel,
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String chatId;
  bool isGroupChat;
  String? groupName;
  String? groupIcon;
  String? creatorId;
  List<String> participantIds;
  Map<String, String>?
      participantNames; // Store id: name mapping for both users
  Map<String, String>?
      participantProfileUrls; // Store id: profileUrl mapping for both users
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
    this.participantNames,
    this.participantProfileUrls,
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
      'participantNames': participantNames,
      'participantProfileUrls': participantProfileUrls,
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
      'participantNames': participantNames,
      'participantProfileUrls': participantProfileUrls,
      'lastMessageTime': lastMessageTime ?? FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'blocked': blocked,
    };
  }

  static ChatModel fromJson(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      isGroupChat: map['isGroupChat'] ?? false,
      groupName: map['groupName'],
      groupIcon: map['groupIcon'],
      creatorId: map['creatorId'],
      participantIds: List<String>.from(map['participantIds'] ?? []),
      participantNames: map['participantNames'] != null
          ? Map<String, String>.from(map['participantNames'])
          : null,
      participantProfileUrls: map['participantProfileUrls'] != null
          ? Map<String, String>.from(map['participantProfileUrls'])
          : null,
      lastMessageTime: map['lastMessageTime'],
      lastMessage: map['lastMessage'] ?? "",
      unreadMessages: map['unreadMessages'] != null
          ? Map<String, int>.from(map['unreadMessages'])
          : null,
      blocked: map['blocked'] != null
          ? Map<String, bool>.from(map['blocked'])
          : null,
    );
  }

  // Add fromMap method to match ChatController usage
  static ChatModel fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      chatId: id,
      isGroupChat: map['isGroupChat'] ?? false,
      groupName: map['groupName'],
      groupIcon: map['groupIcon'],
      creatorId: map['creatorId'],
      participantIds: List<String>.from(map['participantIds'] ?? []),
      participantNames: map['participantNames'] != null
          ? Map<String, String>.from(map['participantNames'])
          : null,
      participantProfileUrls: map['participantProfileUrls'] != null
          ? Map<String, String>.from(map['participantProfileUrls'])
          : null,
      lastMessageTime: map['lastMessageTime'],
      lastMessage: map['lastMessage'] ?? "",
      unreadMessages: map['unreadMessages'] != null
          ? Map<String, int>.from(map['unreadMessages'])
          : null,
      blocked: map['blocked'] != null
          ? Map<String, bool>.from(map['blocked'])
          : null,
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
          ? ChatModel.fromJson(map['chatModel'])
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