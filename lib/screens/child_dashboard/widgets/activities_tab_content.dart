// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../config/app_config.dart';
// import '../../message/message_controller.dart';
// import '../child_dashboard_controller.dart';
// import '../models/modelschild_dashboard_model.dart';
// import 'activity_cards.dart';
//
// class ActivitiesTabContent extends StatelessWidget {
//   final List<ActivityItem> activities;
//   final ChildDashboardController controller;
//
//   const ActivitiesTabContent({
//     required this.activities,
//     required this.controller,
//     Key? key,
//   }) : super(key: key);
//
//   // Get real chat data from Firebase for specific child
//   ActivityItem? _getRealChatActivityForChild() {
//     try {
//       // Check if MessageController is registered before trying to get it
//       if (!Get.isRegistered<MessageController>()) {
//         print('MessageController not registered, initializing...');
//         Get.put(MessageController());
//       }
//
//       // Try to get MessageController
//       final messageController = Get.find<MessageController>();
//
//       // Get child user ID from controller
//       final childUserId = controller.childId.toString();
//
//       if (childUserId.isEmpty) {
//         print('No child ID found');
//         return null;
//       }
//
//       print('Looking for chats with child ID: $childUserId');
//
//       // Find the most recent chat that includes the child
//       if (messageController.chatList.isNotEmpty) {
//         for (var chat in messageController.chatList) {
//           // Check if this chat includes the child
//           if (chat.participantIds.contains(childUserId)) {
//             print('Found chat with child: ${chat.chatId}');
//
//             final otherUser = messageController.getOtherParticipant(chat);
//
//             // Format the timestamp
//             String formattedTime = '';
//             String formattedDate = '';
//
//             if (chat.lastMessageTime != null) {
//               // Convert Timestamp to DateTime
//               final DateTime messageTime = chat.lastMessageTime!.toDate();
//
//               // Convert to UTC and then to local time
//               final DateTime messageTimeLocal = messageTime.toUtc().toLocal();
//               final DateTime nowLocal = DateTime.now().toLocal();
//
//               // Format time in 12-hour format
//               formattedTime = DateFormat('hh:mm a').format(messageTimeLocal);
//
//               // Format date
//               if (messageTimeLocal.year == nowLocal.year &&
//                   messageTimeLocal.month == nowLocal.month &&
//                   messageTimeLocal.day == nowLocal.day) {
//                 formattedDate = 'Today';
//               } else if (messageTimeLocal.year == nowLocal.year &&
//                   messageTimeLocal.month == nowLocal.month &&
//                   messageTimeLocal.day == nowLocal.day - 1) {
//                 formattedDate = 'Yesterday';
//               } else {
//                 formattedDate = DateFormat('MMM dd, yyyy').format(messageTimeLocal);
//               }
//             }
//
//             return ActivityItem(
//               type: ActivityType.chat,
//               data: {
//                 'avatar': otherUser?.profile ?? '',
//                 'name': otherUser?.fullname ?? 'Unknown User',
//                 'lastMessage': chat.lastMessage,
//                 'time': formattedTime,
//                 'date': formattedDate,
//               },
//             );
//           }
//         }
//
//         print('No chat found for child ID: $childUserId');
//       } else {
//         print('No chats available in MessageController');
//       }
//     } catch (e) {
//       print('Error getting chat data: $e');
//     }
//
//     // Return null if no chat data available
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Show loading indicator while fetching activities
//       if (controller.isLoadingActivities.value) {
//         return Center(
//           child: CircularProgressIndicator(
//             color: AppColors.primaryColor,
//           ),
//         );
//       }
//
//       // Get activities by type
//       ActivityItem? postLiked = activities.firstWhereOrNull(
//             (a) => a.type == ActivityType.postLiked,
//       );
//       ActivityItem? comment = activities.firstWhereOrNull(
//             (a) => a.type == ActivityType.comment,
//       );
//
//       // Get real chat data from Firebase for this specific child
//       ActivityItem? chat = _getRealChatActivityForChild();
//
//       ActivityItem? request = activities.firstWhereOrNull(
//             (a) => a.type == ActivityType.request,
//       );
//
//       // Create ordered list with only non-null items
//       // This ensures available items are shown in order without gaps
//       List<ActivityItem> displayActivities = [
//         if (postLiked != null) postLiked,
//         if (comment != null) comment,
//         if (chat != null) chat,
//         if (request != null) request,
//       ];
//
//       // Show empty state if no activities at all
//       if (displayActivities.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.history,
//                 size: 64,
//                 color: AppColors.textColor4,
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'No recent activities',
//                 style: TextStyle(
//                   color: AppColors.textColor3,
//                   fontSize: FontDimen.dimen16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       // Build rows of 2 items each
//       List<Widget> rows = [];
//       for (int i = 0; i < displayActivities.length; i += 2) {
//         List<Widget> rowChildren = [];
//
//         // First item in row
//         rowChildren.add(
//           Expanded(
//             child: _buildActivityCard(displayActivities[i]),
//           ),
//         );
//
//         // Second item in row (if exists)
//         if (i + 1 < displayActivities.length) {
//           rowChildren.add(SizedBox(width: AppDimens.dimen14));
//           rowChildren.add(
//             Expanded(
//               child: _buildActivityCard(displayActivities[i + 1]),
//             ),
//           );
//         } else {
//           // Add empty space if odd number of items
//           rowChildren.add(SizedBox(width: AppDimens.dimen14));
//           rowChildren.add(Expanded(child: SizedBox()));
//         }
//
//         rows.add(
//           IntrinsicHeight(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: rowChildren,
//             ),
//           ),
//         );
//
//         // Add spacing between rows
//         if (i + 2 < displayActivities.length) {
//           rows.add(SizedBox(height: AppDimens.dimen14));
//         }
//       }
//
//       // Show activities in custom layout with RefreshIndicator
//       return RefreshIndicator(
//         onRefresh: () => controller.refreshActivities(),
//         color: AppColors.primaryColor,
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           padding: EdgeInsets.symmetric(
//             horizontal: AppDimens.dimen16,
//             vertical: AppDimens.dimen10,
//           ),
//           child: Column(
//             children: rows,
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildActivityCard(ActivityItem activity) {
//     switch (activity.type) {
//       case ActivityType.postLiked:
//         return ActivityCard_PostLiked(data: activity.data);
//       case ActivityType.comment:
//         return ActivityCard_Comment(data: activity.data);
//       case ActivityType.chat:
//         return ActivityCard_Chat(data: activity.data);
//       case ActivityType.request:
//         return ActivityCard_Request(data: activity.data);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/app_config.dart';
import '../../message/message_controller.dart';
import '../../message/models/chat_model.dart';
import '../child_dashboard_controller.dart';
import '../models/modelschild_dashboard_model.dart';
import 'activity_cards.dart';

class ActivitiesTabContent extends StatelessWidget {
  final List<ActivityItem> activities;
  final ChildDashboardController controller;

  const ActivitiesTabContent({
    required this.activities,
    required this.controller,
    Key? key,
  }) : super(key: key);

  // // Get the actual Firebase user ID for the child by username
  // Future<String?> _getChildFirebaseUserId() async {
  //   try {
  //     final username = controller.child.value.username;
  //
  //     if (username.isEmpty) {
  //       print('No username found for child');
  //       return null;
  //     }
  //
  //     print('Looking up Firebase user ID for username: $username');
  //
  //     // Query Firestore to find user with this username
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('username', isEqualTo: username)
  //         .limit(1)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       final userId = querySnapshot.docs.first.id;
  //       print('Found Firebase user ID: $userId for username: $username');
  //       return userId;
  //     } else {
  //       print('No Firebase user found for username: $username');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting Firebase user ID: $e');
  //     return null;
  //   }
  // }
  //
  // // Get real chat data from Firebase for specific child
  // Future<ActivityItem?> _getRealChatActivityForChild() async {
  //   try {
  //     // Check if MessageController is registered before trying to get it
  //     if (!Get.isRegistered<MessageController>()) {
  //       print('MessageController not registered, initializing...');
  //       Get.put(MessageController());
  //     }
  //
  //     // Try to get MessageController
  //     final messageController = Get.find<MessageController>();
  //
  //     // Get the actual Firebase user ID for the child
  //     final childFirebaseUserId = await _getChildFirebaseUserId();
  //
  //     if (childFirebaseUserId == null || childFirebaseUserId.isEmpty) {
  //       print('Could not find Firebase user ID for child');
  //       return null;
  //     }
  //
  //     print('=== SEARCHING FOR CHILD CHAT ===');
  //     print('Child Firebase User ID: $childFirebaseUserId');
  //     print('Total chats available: ${messageController.chatList.length}');
  //
  //     // Find the most recent chat that includes the child
  //     if (messageController.chatList.isNotEmpty) {
  //       for (var chat in messageController.chatList) {
  //         print('Checking chat: ${chat.chatId}');
  //         print('Participants: ${chat.participantIds}');
  //
  //         // Check if this chat includes the child (comparing strings)
  //         if (chat.participantIds.contains(childFirebaseUserId)) {
  //           print('✅ Found matching chat for child $childFirebaseUserId');
  //           print('Chat ID: ${chat.chatId}');
  //           print('Last Message: ${chat.lastMessage}');
  //
  //           // Get the other participant (not the child)
  //           String? otherUserId;
  //           for (var id in chat.participantIds) {
  //             if (id != childFirebaseUserId) {
  //               otherUserId = id;
  //               break;
  //             }
  //           }
  //
  //           // Get other user info from participantNames and participantProfileUrls
  //           String otherUserName = 'Unknown User';
  //           String otherUserAvatar = '';
  //
  //           if (otherUserId != null) {
  //             // Try to get from participantNames map
  //             if (chat.participantNames != null &&
  //                 chat.participantNames!.containsKey(otherUserId)) {
  //               otherUserName = chat.participantNames![otherUserId] ?? 'Unknown User';
  //             }
  //
  //             // Try to get from participantProfileUrls map
  //             if (chat.participantProfileUrls != null &&
  //                 chat.participantProfileUrls!.containsKey(otherUserId)) {
  //               otherUserAvatar = chat.participantProfileUrls![otherUserId] ?? '';
  //             }
  //
  //             // Fallback to MessageController's method
  //             final otherUser = messageController.getOtherParticipant(chat);
  //             if (otherUser != null) {
  //               otherUserName = otherUser.fullname ?? otherUserName;
  //               otherUserAvatar = otherUser.profile ?? otherUserAvatar;
  //             }
  //           }
  //
  //           print('Other User: $otherUserName');
  //
  //           // Format the timestamp
  //           String formattedTime = '';
  //           String formattedDate = '';
  //
  //           if (chat.lastMessageTime != null) {
  //             try {
  //               // Convert Timestamp to DateTime
  //               final DateTime messageTime = chat.lastMessageTime!.toDate();
  //
  //               // Convert to UTC and then to local time
  //               final DateTime messageTimeLocal = messageTime.toUtc().toLocal();
  //               final DateTime nowLocal = DateTime.now().toLocal();
  //
  //               // Format time in 12-hour format
  //               formattedTime = DateFormat('hh:mm a').format(messageTimeLocal);
  //
  //               // Format date
  //               if (messageTimeLocal.year == nowLocal.year &&
  //                   messageTimeLocal.month == nowLocal.month &&
  //                   messageTimeLocal.day == nowLocal.day) {
  //                 formattedDate = 'Today';
  //               } else if (messageTimeLocal.year == nowLocal.year &&
  //                   messageTimeLocal.month == nowLocal.month &&
  //                   messageTimeLocal.day == nowLocal.day - 1) {
  //                 formattedDate = 'Yesterday';
  //               } else {
  //                 formattedDate = DateFormat('MMM dd, yyyy').format(messageTimeLocal);
  //               }
  //
  //               print('Formatted Time: $formattedTime');
  //               print('Formatted Date: $formattedDate');
  //             } catch (e) {
  //               print('Error formatting timestamp: $e');
  //             }
  //           }
  //
  //           return ActivityItem(
  //             type: ActivityType.chat,
  //             data: {
  //               'avatar': otherUserAvatar,
  //               'name': otherUserName,
  //               'lastMessage': chat.lastMessage,
  //               'time': formattedTime,
  //               'date': formattedDate,
  //             },
  //           );
  //         }
  //       }
  //
  //       print('❌ No chat found for child Firebase user ID: $childFirebaseUserId');
  //     } else {
  //       print('❌ No chats available in MessageController');
  //     }
  //   } catch (e, stackTrace) {
  //     print('❌ Error getting chat data: $e');
  //     print('Stack trace: $stackTrace');
  //   }
  //
  //   // Return null if no chat data available
  //   return null;
  // }
  Future<String?> _getChildFirebaseUserId() async {
    try {
      // Child ID comes directly from API → Use it as Firebase UID
      final childId = controller.childId.toString();

      print("🔍 Using childId as Firebase userId: $childId");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(childId)
          .get();

      if (userDoc.exists) {
        print("✅ Firebase user found for childId: $childId");
        return childId;
      } else {
        print("❌ No Firebase user document found for childId: $childId");
        return null;
      }

    } catch (e) {
      print("🔥 Error fetching Firebase UID: $e");
      return null;
    }
  }
  Future<ActivityItem?> _getRealChatActivityForChild() async {
    try {
      // Ensure MessageController exists
      if (!Get.isRegistered<MessageController>()) {
        print("ℹ️ MessageController not registered → creating instance");
        Get.put(MessageController());
      }

      final messageController = Get.find<MessageController>();

      // 1️⃣ Get Firebase userId = childId
      final childFirebaseUserId = await _getChildFirebaseUserId();
      if (childFirebaseUserId == null) {
        print("❌ Could not resolve Firebase childId");
        return null;
      }

      print("🔍 Searching chats where chatId contains: $childFirebaseUserId");

      // 2️⃣ Collect matching chats
      List<ChatModel> matchingChats = [];
      for (var chat in messageController.chatList) {
        if (chat.chatId.contains(childFirebaseUserId)) {
          matchingChats.add(chat);
        }
      }

      if (matchingChats.isEmpty) {
        print("❌ No chats found containing childId: $childFirebaseUserId");
        return null;
      }

      print("📌 Matching chats count: ${matchingChats.length}");

      // 3️⃣ Sort by latest message time
      matchingChats.sort((a, b) =>
          (b.lastMessageTime ?? Timestamp(0, 0))
              .compareTo(a.lastMessageTime ?? Timestamp(0, 0)));

      final latestChat = matchingChats.first;

      print("✅ Latest chat: ${latestChat.chatId}");
      print("💬 Last message: ${latestChat.lastMessage}");

      // 4️⃣ Find opposite user (optional)
      String otherUserId = latestChat.participantIds.firstWhere(
              (id) => id != childFirebaseUserId,
          orElse: () => "");

      String otherUserName =
          latestChat.participantNames?[otherUserId] ?? "Unknown";
      String otherUserAvatar =
          latestChat.participantProfileUrls?[otherUserId] ?? "";

      // 5️⃣ Format timestamp
      String formattedTime = "";
      String formattedDate = "";

      if (latestChat.lastMessageTime != null) {
        final dt = latestChat.lastMessageTime!.toDate();
        final now = DateTime.now();

        formattedTime = DateFormat('hh:mm a').format(dt);

        if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
          formattedDate = "Today";
        } else if (dt.year == now.year &&
            dt.month == now.month &&
            dt.day == now.day - 1) {
          formattedDate = "Yesterday";
        } else {
          formattedDate = DateFormat('MMM dd, yyyy').format(dt);
        }
      }

      // 6️⃣ Return as Activity Item
      return ActivityItem(
        type: ActivityType.chat,
        data: {
          "avatar": otherUserAvatar,
          "name": otherUserName,
          "lastMessage": latestChat.lastMessage,
          "time": formattedTime,
          "date": formattedDate,
        },
      );

    } catch (e, s) {
      print("🔥 Error fetching chat: $e");
      print(s);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while fetching activities
      if (controller.isLoadingActivities.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        );
      }

      // Get activities by type
      ActivityItem? postLiked = activities.firstWhereOrNull(
            (a) => a.type == ActivityType.postLiked,
      );
      ActivityItem? comment = activities.firstWhereOrNull(
            (a) => a.type == ActivityType.comment,
      );

      ActivityItem? request = activities.firstWhereOrNull(
            (a) => a.type == ActivityType.request,
      );

      // Build the list without chat first, then add it asynchronously
      return FutureBuilder<ActivityItem?>(
        future: _getRealChatActivityForChild(),
        builder: (context, snapshot) {
          ActivityItem? chat = snapshot.data;

          // Create ordered list with only non-null items
          List<ActivityItem> displayActivities = [
            if (postLiked != null) postLiked,
            if (comment != null) comment,
            if (chat != null) chat,
            if (request != null) request,
          ];

          // Show empty state if no activities at all and loading is complete
          if (displayActivities.isEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textColor4,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No recent activities',
                    style: TextStyle(
                      color: AppColors.textColor3,
                      fontSize: FontDimen.dimen16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show loading while fetching chat data
          if (snapshot.connectionState == ConnectionState.waiting &&
              displayActivities.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          // Build rows of 2 items each
          List<Widget> rows = [];
          for (int i = 0; i < displayActivities.length; i += 2) {
            List<Widget> rowChildren = [];

            // First item in row
            rowChildren.add(
              Expanded(
                child: _buildActivityCard(displayActivities[i]),
              ),
            );

            // Second item in row (if exists)
            if (i + 1 < displayActivities.length) {
              rowChildren.add(SizedBox(width: AppDimens.dimen14));
              rowChildren.add(
                Expanded(
                  child: _buildActivityCard(displayActivities[i + 1]),
                ),
              );
            } else {
              // Add empty space if odd number of items
              rowChildren.add(SizedBox(width: AppDimens.dimen14));
              rowChildren.add(Expanded(child: SizedBox()));
            }

            rows.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: rowChildren,
                ),
              ),
            );

            // Add spacing between rows
            if (i + 2 < displayActivities.length) {
              rows.add(SizedBox(height: AppDimens.dimen14));
            }
          }

          // Show activities in custom layout with RefreshIndicator
          return RefreshIndicator(
            onRefresh: () => controller.refreshActivities(),
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dimen16,
                vertical: AppDimens.dimen10,
              ),
              child: Column(
                children: rows,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildActivityCard(ActivityItem activity) {
    switch (activity.type) {
      case ActivityType.postLiked:
        return ActivityCard_PostLiked(data: activity.data);
      case ActivityType.comment:
        return ActivityCard_Comment(data: activity.data);
      case ActivityType.chat:
        return ActivityCard_Chat(data: activity.data);
      case ActivityType.request:
        return ActivityCard_Request(data: activity.data);
    }
  }
}