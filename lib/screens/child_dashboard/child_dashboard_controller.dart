import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:the_friendz_zone/screens/child_dashboard/models/modelschild_dashboard_model.dart';
import '../../api_helpers/api_manager.dart';
import '../../api_helpers/api_param.dart';
import '../../api_helpers/api_utils.dart';
import '../../config/app_config.dart';
import '../create_post/model/age_content_response.dart';

class ChildDashboardController extends GetxController {
  final int parentId;
  final int childId;

  ChildDashboardController({
    required this.parentId,
    required this.childId,
  });

  // Tabs, loading states, dropdown lists
  final RxInt selectedTab = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingActivities = false.obs;
  RxList<ContentAgeData?> contentAgeResponse = <ContentAgeData?>[].obs;

  // Child model observable
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
    contentAgeRestriction: 'All',
  ).obs;

  // UI binders
  final RxString selectedPostVisibility = AppStrings.connectionsOnly.obs;
  final RxString selectedContentAgeRestriction = 'All'.obs;
  final RxInt selectedAgeGroupId = 1.obs; // ID for "All"

  @override
  void onInit() {
    super.onInit();
    _getAgeContentList(); // load age list
    _fetchChildDashboard(); // load dashboard
  }

  /* ---------------------------- TABS ---------------------------- */

  void setTab(int i) {
    selectedTab.value = i;

    if (i == 0 && child.value.recentActivities.isEmpty) {
      _fetchRecentActivities();
    }
  }

  /* ---------------------- POST VISIBILITY ----------------------- */

  void selectPostVisibility(String v) {
    selectedPostVisibility.value = v;
    child.update((c) {
      if (c != null) c.postVisibility = v;
    });
  }

  /* ------------------ AGE RESTRICTION SELECT -------------------- */

  void selectContentAgeRestriction(int ageGroupId, String ageLabel) {
    if (kDebugMode) {
      print('--- AGE SELECTED ---');
      print('ID: $ageGroupId');
      print('Label: $ageLabel');
    }

    selectedAgeGroupId.value = ageGroupId;
    selectedContentAgeRestriction.value = ageLabel;

    child.update((c) {
      if (c != null) c.contentAgeRestriction = ageLabel;
    });
  }

  /* ------------------------- SYNC UI ---------------------------- */

  void syncSelectedPostVisibilityWithModel() {
    selectedPostVisibility.value = child.value.postVisibility;
    selectedContentAgeRestriction.value = child.value.contentAgeRestriction;
  }
  // /// Update content age restriction via API
  // Future<void> _updateContentAgeRestriction(int ageGroupId) async {
  //   try {
  //     var result = await ApiManager.callPostWithFormData(
  //       body: {
  //         ApiParam.parentId: '$parentId',
  //         ApiParam.childId: '$childId',
  //         ApiParam.request: 'update_age_restriction',
  //         'age_group_id': '$ageGroupId',
  //       },
  //       endPoint: ApiUtils.updateAgeRestriction, // Use your actual endpoint
  //     );
  //
  //     if (kDebugMode) {
  //       print('Update Age Restriction API Response: $result');
  //     }
  //
  //     if (result['status'] == 'success') {
  //       Get.snackbar(
  //         'Success',
  //         'Content age restriction updated successfully',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: AppColors.successSnackbarColor,
  //         colorText: AppColors.whiteColor,
  //         duration: Duration(seconds: 2),
  //       );
  //     } else {
  //       _showError('Failed to update content age restriction');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error updating content age restriction: $e');
  //     }
  //     _showError('Failed to update. Please try again.');
  //   }
  // }

  /* --------------------- GET AGE CONTENT LIST ------------------ */

  Future<void> _getAgeContentList() async {
    try {
      var result = await ApiManager.callGet(
        queryParams: {ApiParam.request: ApiUtils.getAgeContentList},
      );

      if (kDebugMode) {
        print('=== AGE LIST RESPONSE ===');
        print(result);
      }

      ContentAgeResponse parsed = ContentAgeResponse.fromJson(result);

      if (parsed.status == AppStrings.apiSuccess) {
        contentAgeResponse.value = parsed.data ?? [];
        contentAgeResponse.refresh();

        if (kDebugMode) {
          print('Loaded Age Options: ${contentAgeResponse.length}');
        }

        // Correct the selected ID if label is "All"
        if (selectedContentAgeRestriction.value == 'All') {
          var allOption = contentAgeResponse.firstWhere(
            (age) => age?.ageLabel == 'All',
            orElse: () => ContentAgeData(id: 1, ageLabel: 'All'),
          );

          selectedAgeGroupId.value = allOption?.id ?? 1;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Age list error: $e');
    }
  }

  /* ------------------- FETCH CHILD DASHBOARD -------------------- */

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
        print('=== CHILD DASHBOARD RESPONSE ===');
        print(result);
      }

      if (result['status'] == 'success') {
        var data = result['data'];

        if (data['children'] != null && (data['children'] as List).isNotEmpty) {
          var childData = (data['children'] as List).first;

          List<String> interests = [];

          /* ---- Merge interests, hobbies, communities ---- */
          for (String key in ['interests', 'hobbies', 'communities']) {
            var value = childData[key];
            if (value != null) {
              if (value is String) {
                interests.addAll(value.split(',').map((e) => e.trim()));
              } else if (value is List) {
                interests.addAll(value.map((e) => e.toString().trim()));
              }
            }
          }

          String bio = interests.join(', ');

          /* --------- Age Restriction Handling ---------- */

          String? ageGroupLabel = childData['age_group_label'];
          int? ageGroupId = childData['age_group_id'];

          if (ageGroupLabel == null || ageGroupLabel.isEmpty) {
            ageGroupLabel = 'All';

            var allOption = contentAgeResponse.firstWhere(
              (age) => age?.ageLabel == 'All',
              orElse: () => ContentAgeData(id: 1, ageLabel: 'All'),
            );

            ageGroupId = allOption?.id;
          }

          // If ID missing but label present
          if (ageGroupId == null) {
            var matchingOption = contentAgeResponse.firstWhere(
              (age) => age?.ageLabel == ageGroupLabel,
              orElse: () => ContentAgeData(id: 1, ageLabel: ageGroupLabel),
            );

            ageGroupId = matchingOption?.id;
          }

          /* ----------- UPDATE CHILD MODEL ----------- */

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
            recentActivities: [],
            postVisibility:
                childData['post_visibility'] ?? AppStrings.connectionsOnly,
            contentAgeRestriction: ageGroupLabel,
          );

          selectedPostVisibility.value = child.value.postVisibility;
          selectedContentAgeRestriction.value = ageGroupLabel ?? 'All';
          selectedAgeGroupId.value = ageGroupId ?? 1;

          _fetchRecentActivities();
        } else {
          _showError('No dashboard data available');
        }
      } else {
        _showError('Failed to load dashboard data');
      }

      isLoading.value = false;
    } catch (e, s) {
      isLoading.value = false;
      if (kDebugMode) print('Dashboard error: $e\n$s');
      _showError('Failed to load dashboard. Please try again.');
    }
  }

  /* ------------------- RECENT ACTIVITIES ------------------------ */

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

      if (kDebugMode) print('Activities Response: $result');

      if (result['status'] == 'success') {
        List<ActivityItem> activities = [];

        /* ---- Connection requests ---- */
        if (result['recent_requests'] != null) {
          for (var request in result['recent_requests']) {
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

        /* ---- Post Likes ---- */
        if (result['recent_PostLikes'] != null) {
          for (var like in result['recent_PostLikes']) {
            activities.add(ActivityItem(
              type: ActivityType.postLiked,
              data: {
                'userAvatar': like['user_profile'] ?? '',
                'userName': like['username'] ?? '',
                'userHandle': '@${like['username'] ?? ''}',
                'postText': like['caption'] ?? '',
                'postImage': like['postImages'] ?? '',
              },
            ));
          }
        }

        /* ---- Comments ---- */
        if (result['recent_Comments'] != null) {
          for (var comment in result['recent_Comments']) {
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

        child.update((c) {
          if (c != null) c.recentActivities = activities;
        });
      }

      isLoadingActivities.value = false;
    } catch (e, s) {
      isLoadingActivities.value = false;
      if (kDebugMode) print('Activities error: $e\n$s');
    }
  }

  /* -------------------------- HELPERS -------------------------- */

  String _formatTime(String datetime) {
    try {
      DateTime dt = DateTime.parse(datetime);
      int hour = dt.hour;
      String period = hour >= 12 ? 'pm' : 'am';
      hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${hour}:${dt.minute.toString().padLeft(2, '0')}$period';
    } catch (_) {
      return '';
    }
  }

  String _formatDate(String datetime) {
    try {
      DateTime dt = DateTime.parse(datetime);
      const months = [
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
    } catch (_) {
      return '';
    }
  }

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

  Future<void> refreshDashboard() async => _fetchChildDashboard();
  Future<void> refreshActivities() async => _fetchRecentActivities();
}
