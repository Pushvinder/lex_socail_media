// import 'package:get/get.dart';
// import 'package:flutter/foundation.dart';
// import 'package:the_friendz_zone/screens/child_dashboard/models/modelschild_dashboard_model.dart';
// import '../../api_helpers/api_manager.dart';
// import '../../api_helpers/api_param.dart';
// import '../../api_helpers/api_utils.dart';
// import '../../config/app_config.dart';

// class ChildDashboardController extends GetxController {
//   final int parentId;
//   final int childId;

//   ChildDashboardController({
//     required this.parentId,
//     required this.childId,
//   });

//   final RxInt selectedTab = 0.obs;
//   final RxBool isLoading = true.obs;

//   final Rx<ChildDashboardModel> child = ChildDashboardModel(
//     username: '',
//     fullName: '',
//     age: 0,
//     avatarUrl: '',
//     bio: '',
//     interests: [],
//     postsCount: 0,
//     connectionsCount: 0,
//     recentActivities: [],
//     postVisibility: AppStrings.connectionsOnly,
//     contentAgeRestriction: AppStrings.age18plus,
//   ).obs;

//   // THE ONLY OBSERVABLE for UI
//   final RxString selectedPostVisibility = AppStrings.connectionsOnly.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchChildDashboard();
//   }

//   void setTab(int i) => selectedTab.value = i;

//   void selectPostVisibility(String v) {
//     selectedPostVisibility.value = v;
//     child.update((c) {
//       if (c != null) c.postVisibility = v;
//     });
//   }

//   // Initialize when entering the settings screen
//   void syncSelectedPostVisibilityWithModel() {
//     selectedPostVisibility.value = child.value.postVisibility;
//   }

//   /// Fetch child dashboard data from API
//   /// Fetch child dashboard data from API
// Future<void> _fetchChildDashboard() async {
//   try {
//     isLoading.value = true;

//     var result = await ApiManager.callPostWithFormData(
//       body: {
//         ApiParam.parentId: '$parentId',
//         ApiParam.childId: '$childId',
//         ApiParam.request: 'view_child_dashboard',
//       },
//       endPoint: ApiUtils.viewChildDashboard,
//     );

//     if (kDebugMode) {
//       print('Child Dashboard API Response: $result');
//     }

//     // Parse the response based on your API structure
//     if (result['status'] == 'success') {
//       var data = result['data'];

//       // The data is inside 'children' array, get the first child
//       if (data['children'] != null && (data['children'] as List).isNotEmpty) {
//         var childData = (data['children'] as List).first;

//         // Parse recent activities
//         List<ActivityItem> activities = [];
//         if (childData['recent_activities'] != null) {
//           activities = (childData['recent_activities'] as List)
//               .map((activity) => _parseActivityItem(activity))
//               .toList();
//         }

//         // Parse interests - combine interests and hobbies
//         List<String> interests = [];

//         // Add interests
//         if (childData['interests'] != null) {
//           if (childData['interests'] is String) {
//             interests.addAll(
//               (childData['interests'] as String)
//                   .split(',')
//                   .map((e) => e.trim())
//                   .where((e) => e.isNotEmpty)
//             );
//           } else if (childData['interests'] is List) {
//             interests.addAll(
//               (childData['interests'] as List)
//                   .map((e) => e.toString().trim())
//                   .where((e) => e.isNotEmpty)
//             );
//           }
//         }

//         // Add hobbies
//         if (childData['hobbies'] != null) {
//           if (childData['hobbies'] is String) {
//             interests.addAll(
//               (childData['hobbies'] as String)
//                   .split(',')
//                   .map((e) => e.trim())
//                   .where((e) => e.isNotEmpty)
//             );
//           } else if (childData['hobbies'] is List) {
//             interests.addAll(
//               (childData['hobbies'] as List)
//                   .map((e) => e.toString().trim())
//                   .where((e) => e.isNotEmpty)
//             );
//           }
//         }

//         // Add communities
//         if (childData['communities'] != null) {
//           if (childData['communities'] is String) {
//             interests.addAll(
//               (childData['communities'] as String)
//                   .split(',')
//                   .map((e) => e.trim())
//                   .where((e) => e.isNotEmpty)
//             );
//           } else if (childData['communities'] is List) {
//             interests.addAll(
//               (childData['communities'] as List)
//                   .map((e) => e.toString().trim())
//                   .where((e) => e.isNotEmpty)
//             );
//           }
//         }

//         // Create bio from interests, hobbies, and communities
//         String bio = interests.join(', ');

//         // Update child data
//         child.value = ChildDashboardModel(
//           username: childData['username'] ?? '',
//           fullName: childData['fullname'] ?? '',
//           age: int.tryParse(childData['age']?.toString() ?? '0') ?? 0,
//           avatarUrl: childData['profile'] ?? '',
//           bio: bio,
//           interests: interests,
//           postsCount: int.tryParse(childData['post_count']?.toString() ?? '0') ?? 0,
//           connectionsCount: int.tryParse(childData['connection_count']?.toString() ?? '0') ?? 0,
//           recentActivities: activities,
//           postVisibility: childData['post_visibility'] ?? AppStrings.connectionsOnly,
//           contentAgeRestriction: childData['content_age_restriction'] ?? AppStrings.age18plus,
//         );

//         // Sync post visibility
//         selectedPostVisibility.value = child.value.postVisibility;

//         if (kDebugMode) {
//           print('Child data loaded successfully:');
//           print('Username: ${child.value.username}');
//           print('Full Name: ${child.value.fullName}');
//           print('Age: ${child.value.age}');
//           print('Posts: ${child.value.postsCount}');
//           print('Connections: ${child.value.connectionsCount}');
//           print('Interests: ${child.value.interests}');
//         }
//       } else {
//         if (kDebugMode) {
//           print('No children data found in response');
//         }
//         _showError('No dashboard data available');
//       }
//     } else {
//       if (kDebugMode) {
//         print('Failed to load child dashboard: ${result['status']}');
//       }
//       _showError('Failed to load dashboard data');
//     }

//     isLoading.value = false;
//   } catch (e, s) {
//     isLoading.value = false;
//     if (kDebugMode) {
//       print('Error fetching child dashboard: $e');
//       print('Stack trace: $s');
//     }
//     _showError('Failed to load dashboard. Please try again.');
//   }
// }

//   /// Parse activity item from API response
//   ActivityItem _parseActivityItem(Map<String, dynamic> activity) {
//     String type = activity['type'] ?? '';
//     Map<String, dynamic> data = activity['data'] ?? {};

//     ActivityType activityType;
//     switch (type.toLowerCase()) {
//       case 'post_liked':
//         activityType = ActivityType.postLiked;
//         break;
//       case 'comment':
//         activityType = ActivityType.comment;
//         break;
//       case 'chat':
//         activityType = ActivityType.chat;
//         break;
//       case 'request':
//         activityType = ActivityType.request;
//         break;
//       default:
//         activityType = ActivityType.postLiked;
//     }

//     return ActivityItem(
//       type: activityType,
//       data: data,
//     );
//   }

//   /// Show error message
//   void _showError(String message) {
//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: AppColors.errorSnackbarColor,
//       colorText: AppColors.whiteColor,
//       duration: Duration(seconds: 3),
//     );
//   }

//   /// Refresh dashboard data
//   Future<void> refreshDashboard() async {
//     await _fetchChildDashboard();
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:the_friendz_zone/screens/child_dashboard/models/modelschild_dashboard_model.dart';
import '../../api_helpers/api_manager.dart';
import '../../api_helpers/api_param.dart';
import '../../api_helpers/api_utils.dart';
import '../../config/app_config.dart';

class ChildDashboardController extends GetxController {
  final int parentId;
  final int childId;

  ChildDashboardController({
    required this.parentId,
    required this.childId,
  });

  final RxInt selectedTab = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingActivities = false.obs;

  final Rx<ChildDashboardModel> child = ChildDashboardModel(
    username: '',
    fullName: '',
    age: 0,
    avatarUrl: '',
    bio: '',
    interests: [],
    postsCount: 0,
    connectionsCount: 0,
    recentActivities: [],
    postVisibility: AppStrings.connectionsOnly,
    contentAgeRestriction: AppStrings.age18plus,
  ).obs;

  // THE ONLY OBSERVABLE for UI
  final RxString selectedPostVisibility = AppStrings.connectionsOnly.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchChildDashboard();
  }

  void setTab(int i) {
    selectedTab.value = i;

    // Fetch recent activities when switching to Recent Activities tab
    if (i == 0 && child.value.recentActivities.isEmpty) {
      _fetchRecentActivities();
    }
  }

  void selectPostVisibility(String v) {
    selectedPostVisibility.value = v;
    child.update((c) {
      if (c != null) c.postVisibility = v;
    });
  }

  // Initialize when entering the settings screen
  void syncSelectedPostVisibilityWithModel() {
    selectedPostVisibility.value = child.value.postVisibility;
  }

  /// Fetch child dashboard data from API
  Future<void> _fetchChildDashboard() async {
    try {
      isLoading.value = true;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.parentId: '$parentId',
          ApiParam.childId: '$childId',
          ApiParam.request: 'view_child_dashboard',
        },
        endPoint: ApiUtils.viewChildDashboard,
      );

      if (kDebugMode) {
        print('Child Dashboard API Response: $result');
      }

      // Parse the response based on your API structure
      if (result['status'] == 'success') {
        var data = result['data'];

        // The data is inside 'children' array, get the first child
        if (data['children'] != null && (data['children'] as List).isNotEmpty) {
          var childData = (data['children'] as List).first;

          // Parse interests - combine interests and hobbies
          List<String> interests = [];

          // Add interests
          if (childData['interests'] != null) {
            if (childData['interests'] is String) {
              interests.addAll((childData['interests'] as String)
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty));
            } else if (childData['interests'] is List) {
              interests.addAll((childData['interests'] as List)
                  .map((e) => e.toString().trim())
                  .where((e) => e.isNotEmpty));
            }
          }

          // Add hobbies
          if (childData['hobbies'] != null) {
            if (childData['hobbies'] is String) {
              interests.addAll((childData['hobbies'] as String)
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty));
            } else if (childData['hobbies'] is List) {
              interests.addAll((childData['hobbies'] as List)
                  .map((e) => e.toString().trim())
                  .where((e) => e.isNotEmpty));
            }
          }

          // Add communities
          if (childData['communities'] != null) {
            if (childData['communities'] is String) {
              interests.addAll((childData['communities'] as String)
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty));
            } else if (childData['communities'] is List) {
              interests.addAll((childData['communities'] as List)
                  .map((e) => e.toString().trim())
                  .where((e) => e.isNotEmpty));
            }
          }

          // Create bio from interests, hobbies, and communities
          String bio = interests.join(', ');

          // Update child data
          child.value = ChildDashboardModel(
            username: childData['username'] ?? '',
            fullName: childData['fullname'] ?? '',
            age: int.tryParse(childData['age']?.toString() ?? '0') ?? 0,
            avatarUrl: childData['profile'] ?? '',
            bio: bio,
            interests: interests,
            postsCount:
                int.tryParse(childData['post_count']?.toString() ?? '0') ?? 0,
            connectionsCount: int.tryParse(
                    childData['connection_count']?.toString() ?? '0') ??
                0,
            recentActivities: [], // Will be loaded separately
            postVisibility:
                childData['post_visibility'] ?? AppStrings.connectionsOnly,
            contentAgeRestriction:
                childData['content_age_restriction'] ?? AppStrings.age18plus,
          );

          // Sync post visibility
          selectedPostVisibility.value = child.value.postVisibility;

          if (kDebugMode) {
            print('Child data loaded successfully:');
            print('Username: ${child.value.username}');
            print('Full Name: ${child.value.fullName}');
            print('Age: ${child.value.age}');
            print('Posts: ${child.value.postsCount}');
            print('Connections: ${child.value.connectionsCount}');
            print('Interests: ${child.value.interests}');
          }

          // Fetch recent activities after dashboard data is loaded
          _fetchRecentActivities();
        } else {
          if (kDebugMode) {
            print('No children data found in response');
          }
          _showError('No dashboard data available');
        }
      } else {
        if (kDebugMode) {
          print('Failed to load child dashboard: ${result['status']}');
        }
        _showError('Failed to load dashboard data');
      }

      isLoading.value = false;
    } catch (e, s) {
      isLoading.value = false;
      if (kDebugMode) {
        print('Error fetching child dashboard: $e');
        print('Stack trace: $s');
      }
      _showError('Failed to load dashboard. Please try again.');
    }
  }

  /// Fetch recent activities from API
  Future<void> _fetchRecentActivities() async {
    try {
      isLoadingActivities.value = true;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.parentId: '$parentId',
          ApiParam.childId: '$childId',
          ApiParam.request: 'recent_connection_request',
        },
        endPoint: ApiUtils.recentConnectionRequest,
      );

      if (kDebugMode) {
        print('Recent Activities API Response: $result');
      }

      if (result['status'] == 'success') {
        List<ActivityItem> activities = [];

        // Parse connection requests
        if (result['recent_requests'] != null) {
          for (var request in result['recent_requests'] as List) {
            activities.add(ActivityItem(
              type: ActivityType.request,
              data: {
                'avatar': request['sender_profile_picture'] ?? '',
                'name': request['sender_username'] ?? '',
                'time': _formatTime(request['created_at'] ?? ''),
                'date': _formatDate(request['created_at'] ?? ''),
                'status': request['status'] ?? 'pending',
              },
            ));
          }
        }

        // Parse post likes
        if (result['recent_PostLikes'] != null) {
          for (var like in result['recent_PostLikes'] as List) {
            activities.add(ActivityItem(
              type: ActivityType.postLiked,
              data: {
                'userAvatar': like['user_profile'] ?? '',
                'userName': like['username'] ?? '',
                'userHandle': '@${like['username'] ?? ''}',
                'postText': like['caption'] ?? '',
                'postImage': like['postImages'] ?? '',
                'likes': 0, // You can calculate this if available
              },
            ));
          }
        }

        // Parse comments
        if (result['recent_Comments'] != null) {
          for (var comment in result['recent_Comments'] as List) {
            activities.add(ActivityItem(
              type: ActivityType.comment,
              data: {
                'postSnippet': comment['caption'] ?? '',
                'comment': comment['comment'] ?? '',
                'time': _formatTime(comment['created_at'] ?? ''),
                'date': _formatDate(comment['created_at'] ?? ''),
              },
            ));
          }
        }

        // Update child with activities
        child.update((c) {
          if (c != null) {
            c.recentActivities = activities;
          }
        });

        if (kDebugMode) {
          print('Loaded ${activities.length} recent activities');
        }
      } else {
        if (kDebugMode) {
          print('Failed to load recent activities: ${result['status']}');
        }
      }

      isLoadingActivities.value = false;
    } catch (e, s) {
      isLoadingActivities.value = false;
      if (kDebugMode) {
        print('Error fetching recent activities: $e');
        print('Stack trace: $s');
      }
    }
  }

  /// Format time from datetime string
  String _formatTime(String datetime) {
    try {
      DateTime dt = DateTime.parse(datetime);
      int hour = dt.hour;
      String period = hour >= 12 ? 'pm' : 'am';
      hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${hour}:${dt.minute.toString().padLeft(2, '0')}$period';
    } catch (e) {
      return '';
    }
  }

  /// Format date from datetime string
  String _formatDate(String datetime) {
    try {
      DateTime dt = DateTime.parse(datetime);
      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (e) {
      return '';
    }
  }

  /// Parse activity item from API response (kept for backward compatibility)
  ActivityItem _parseActivityItem(Map<String, dynamic> activity) {
    String type = activity['type'] ?? '';
    Map<String, dynamic> data = activity['data'] ?? {};

    ActivityType activityType;
    switch (type.toLowerCase()) {
      case 'post_liked':
        activityType = ActivityType.postLiked;
        break;
      case 'comment':
        activityType = ActivityType.comment;
        break;
      case 'chat':
        activityType = ActivityType.chat;
        break;
      case 'request':
        activityType = ActivityType.request;
        break;
      default:
        activityType = ActivityType.postLiked;
    }

    return ActivityItem(
      type: activityType,
      data: data,
    );
  }

  /// Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.errorSnackbarColor,
      colorText: AppColors.whiteColor,
      duration: Duration(seconds: 3),
    );
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await _fetchChildDashboard();
  }

  /// Refresh recent activities only
  Future<void> refreshActivities() async {
    await _fetchRecentActivities();
  }
}
