import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_helpers/api_manager.dart';
import '../../api_helpers/api_param.dart';
import '../../api_helpers/api_utils.dart';
import '../../config/app_config.dart';

class PostVisibilityController extends GetxController {
  // The observable currently selected value.
  final RxString selected = ''.obs;
  final RxBool isLoading = false.obs;
  final int? parentId;
  final int? childId;

  PostVisibilityController({
    this.parentId,
    this.childId,
  });

  // Call this once screen open for initial value.
  void setInitial(String value) {
    selected.value = value;
  }

  // Update post visibility via API (only if IDs are provided)
  Future<void> updatePostVisibility(String visibility) async {
    // If parentId or childId is null, just update local state
    if (parentId == null || childId == null) {
      selected.value = visibility;
      if (Get.context != null) {
        Get.back(result: visibility);
      }
      return;
    }

    try {
      isLoading.value = true;

      // Call API to update post visibility
      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.request: 'child_post_visibility_update',
          ApiParam.parentId: '$parentId',
          ApiParam.childId: '$childId',
          'post_visibility': visibility.toLowerCase(),
        },
        endPoint: ApiUtils.childPostVisibiltyUpdate,
      );

      isLoading.value = false;

      if (result['status'] == 'success') {
        // Update the selected value immediately
        selected.value = visibility;
        
        // Navigate back and pass the updated value
        Get.back(result: visibility);
        
        // Show success message after navigation
        Future.delayed(Duration(milliseconds: 300), () {
          Get.snackbar(
            'Success',
            result['message'] ?? 'Post visibility updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.successSnackbarColor,
            colorText: AppColors.whiteColor,
            duration: Duration(seconds: 2),
          );
        });
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to update post visibility',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor,
          colorText: AppColors.whiteColor,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to update post visibility',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor,
        colorText: AppColors.whiteColor,
        duration: Duration(seconds: 3),
      );
      print('Error updating post visibility: $e');
    }
  }
}