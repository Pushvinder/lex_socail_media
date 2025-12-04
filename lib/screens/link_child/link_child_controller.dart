import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import 'package:the_friendz_zone/models/search_user_model.dart';
import 'models/account_user_model.dart';

class LinkChildAccountController extends GetxController {
  RxList<Friend> allUsers = <Friend>[].obs;
  RxList<Friend> filteredUsers = <Friend>[].obs;
  RxString search = "".obs;

  RxBool isLoadingFriendsList = true.obs;
  RxBool isSearching = false.obs;

  Timer? _debounce;

  @override
  void onInit() {
    _getFriendsList();
    super.onInit();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onSearch(String value) {
    search.value = value;

    // Cancel previous debounce timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.trim().isEmpty) {
      // Show friends list when search is empty
      filteredUsers.value = List.from(allUsers);
      isSearching.value = false;
    } else {
      // Debounce search API call
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _searchUsers(value);
      });
    }
  }

  void toggleSelect(int index) {
    final user = filteredUsers[index];
    user.isSelected = !(user.isSelected ?? false);
    filteredUsers.refresh();

    // Update in allUsers if exists
    int allUsersIndex = allUsers.indexWhere((e) => e.id == user.id);
    if (allUsersIndex != -1) {
      allUsers[allUsersIndex].isSelected = user.isSelected;
      allUsers.refresh();
    }
  }

  void sendLinkRequest() async {
    final selectedUsers =
        filteredUsers.where((u) => u.isSelected ?? false).toList();

    if (selectedUsers.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor,
        colorText: AppColors.whiteColor,
      );
      return;
    }

    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
        barrierDismissible: false,
      );

      List<Map<String, dynamic>> results = [];

      for (var user in selectedUsers) {
        try {
          var response = await _linkChildAccount(user.id!);
          results.add({
            'user': user,
            'success': response['status'] == 'success',
            'message': response['results'][user.id] ?? 'Request sent'
          });
        } catch (e) {
          results.add({
            'user': user,
            'success': false,
            'message': 'Failed to send request'
          });
        }
      }

      Get.back(); // Close loading dialog

      // Show results dialog
      _showLinkRequestResultsDialog(results);

      // Reset selections
      for (var user in filteredUsers) {
        user.isSelected = false;
      }
      for (var user in allUsers) {
        user.isSelected = false;
      }
      filteredUsers.refresh();
      allUsers.refresh();
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to send link request',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor,
        colorText: AppColors.whiteColor,
      );
      debugPrint('Error sending link request: $e');
    }
  }

  void _showLinkRequestResultsDialog(List<Map<String, dynamic>> results) {
    // For single user, show specific dialog
    if (results.length == 1) {
      _showSingleUserResultDialog(results.first);
    } else {
      // For multiple users, show summary dialog
      _showMultipleUsersResultDialog(results);
    }
  }

  void _showSingleUserResultDialog(Map<String, dynamic> result) {
    Friend user = result['user'];
    String message = result['message'];
    bool isSuccess = result['success'];

    // Determine title based on message
    String title = message.contains('already exists')
        ? 'Link Request Already Exists'
        : 'Link Request Sent';

    String subMessage =
        'Once your child accepts the request, you\'ll gain parental control over their account.';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Two Profile Image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  'Assets/Images/two_profile.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image not found
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.people,
                        size: 60,
                        color: AppColors.primaryColor,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Title with single line and white text
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 16),

              // User Name with green check circle at end
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.username ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  subMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Go To Dashboard Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Go To Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showMultipleUsersResultDialog(List<Map<String, dynamic>> results) {
    int successCount = results.where((r) => r['success'] == true).length;
    int totalCount = results.length;

    String title = successCount == totalCount
        ? 'Requests Sent Successfully'
        : '${successCount}/${totalCount} Requests Sent';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Two Profile Image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  'Assets/Images/two_profile.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.people,
                        size: 60,
                        color: AppColors.primaryColor,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Title with gradient background
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColorShade,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // User Results List with green check circles
              Container(
                height: results.length <= 3 ? null : 200,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: results.length <= 3
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  itemCount: results.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    var result = results[index];
                    Friend user = result['user'];

                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.username ?? 'Unknown User',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  result['success'] ? Colors.green : Colors.red,
                            ),
                            child: Icon(
                              result['success'] ? Icons.check : Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Message for all
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Once your children accept the request, you\'ll gain parental control over their accounts.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Go To Dashboard Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    // Navigate to dashboard if needed
                    // Get.offAllNamed('/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Go To Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Get friends list to show on link account
  Future<void> _getFriendsList() async {
    try {
      isLoadingFriendsList.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.friendList);

      AccountUserModelResponse response =
          AccountUserModelResponse.fromJson(result);
      if (response.data != null) {
        List<Friend> friends = response.data?.friends ?? [];

        // Remove duplicates based on user ID
        final Map<String, Friend> uniqueFriends = {};
        for (var friend in friends) {
          if (friend.id != null && !uniqueFriends.containsKey(friend.id)) {
            uniqueFriends[friend.id!] = friend;
          }
        }

        allUsers.value = uniqueFriends.values.toList();
        filteredUsers.value = List.from(allUsers);
      }
      isLoadingFriendsList.value = false;
    } catch (e, s) {
      isLoadingFriendsList.value = false;
      debugPrint('Error fetching friends list ${e.toString()}, $s');
    }
  }

  /// Search users based on query
  /// Search users based on query
  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) return;

    try {
      isSearching.value = true;
      isLoadingFriendsList.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
        ApiParam.search: query.trim(),
      }, endPoint: ApiUtils.searchUser);

      debugPrint('Search API Response: $result');

      SearchUserModel searchResponse = SearchUserModel.fromJson(result);

      if (searchResponse.data != null && searchResponse.data!.isNotEmpty) {
        // Convert search results to Friend model
        List<Friend> searchResults = searchResponse.data!.map((searchUser) {
          // Check if user was already selected
          bool wasSelected = false;
          var existingUser = allUsers.firstWhereOrNull(
            (u) => u.id == searchUser.id,
          );
          if (existingUser != null) {
            wasSelected = existingUser.isSelected ?? false;
          }

          return Friend(
            id: searchUser.id,
            username: searchUser.username,
            profile: searchUser.profile,
            isSelected: wasSelected,
          );
        }).toList();

        // Remove duplicates based on user ID
        final Map<String, Friend> uniqueUsers = {};
        for (var user in searchResults) {
          if (user.id != null) {
            uniqueUsers[user.id!] = user;
          }
        }

        filteredUsers.value = uniqueUsers.values.toList();
      } else {
        filteredUsers.clear();
      }

      isLoadingFriendsList.value = false;
      isSearching.value = true;
    } catch (e, s) {
      isLoadingFriendsList.value = false;
      isSearching.value = false;
      debugPrint('Error searching users ${e.toString()}, $s');
    }
  }

  /// Send link child request
  /// @param [childId] id of the user whose account current user wants to link as child
  Future<Map<String, dynamic>> _linkChildAccount(String childId) async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.parentId: '$userId',
        ApiParam.linkChildId: childId,
      }, endPoint: ApiUtils.sendLinkRequest);

      debugPrint('Link child account response: $result');

      // Parse the response
      Map<String, dynamic> response = result is Map<String, dynamic>
          ? result
          : Map<String, dynamic>.from(result);

      return response;
    } catch (e, s) {
      debugPrint('Error linking child account ${e.toString()}, $s');
      rethrow;
    }
  }
}
