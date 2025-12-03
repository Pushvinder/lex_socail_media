import 'package:get/get.dart';
import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:the_friendz_zone/screens/link_child/link_child_screen.dart';
import 'package:the_friendz_zone/screens/parental_control/models/child_account_model.dart';
import 'package:the_friendz_zone/screens/parental_control/models/linked_children_response.dart';

import '../child_dashboard/child_dashboard_screen.dart';

class ParentalControlController extends GetxController {
  final RxList<ChildAccountModel> childAccounts = <ChildAccountModel>[].obs;
  RxBool isLoadingLinkedChildList = true.obs;

  @override
  void onInit() {
    super.onInit();
    _getLinkedChildrenList();
  }

  // Method to handle tapping "View Dashboard" for a specific child
  void viewChildDashboard(ChildAccountModel child) {
    // Store the selected child ID if needed
    // StorageHelper().setSelectedChildId(child.id);

    // Navigate to child dashboard with child data
    Get.to(() => ChildDashboardScreen(
          parentId: StorageHelper().getUserId,
          childId: int.parse(child.id),
        ));
  }

  // Method to handle tapping "Link Child Account"
  void linkChildAccount() {
    Get.to(() => LinkChildAccountScreen());
  }

  // Get the list of linked children
  Future<void> _getLinkedChildrenList() async {
    try {
      isLoadingLinkedChildList.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.parentId: '$userId',
          ApiParam.request: 'get_list_linked_children',
        },
        endPoint: ApiUtils.getListLinkedChildren,
      );

      if (kDebugMode) {
        print('API Response: $result');
      }

      // Parse the response
      LinkedChildrenResponse response = LinkedChildrenResponse.fromJson(result);

      if (response.status == "success") {
        // Convert ChildData to ChildAccountModel
        List<ChildAccountModel> children = response.data.children
            .map((childData) => ChildAccountModel.fromChildData(childData))
            .toList();

        childAccounts.value = children;

        if (kDebugMode) {
          print('Loaded ${children.length} children');
        }
      } else {
        if (kDebugMode) {
          print('Failed to load children list: ${response.status}');
        }
        // Show empty state or error
        childAccounts.clear();
      }

      isLoadingLinkedChildList.value = false;
    } catch (e, s) {
      isLoadingLinkedChildList.value = false;
      childAccounts.clear();

      if (kDebugMode) {
        print('Error loading children list: $e');
        print('Stack trace: $s');
      }

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to load children. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Refresh method for pull-to-refresh
  Future<void> refreshChildrenList() async {
    await _getLinkedChildrenList();
  }
}
