import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../api_helpers/api_param.dart';
import '../../../config/app_config.dart';
import '../../../helpers/storage_helper.dart';
import 'callHistory_model.dart';

class CallHistoryController extends GetxController {
  final String currentUserId = StorageHelper().getUserId.toString();

  RxList<CallHistoryModel> callHistoryList = <CallHistoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCallHistory();
  }
  Future<void> fetchCallHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      debugPrint('Fetching call history for user: $currentUserId');

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.request: 'get_call_history',
          ApiParam.userId: currentUserId,
        },
        endPoint: ApiUtils.getCallHistory,
      );

      final callHistoryResponse = CallHistoryResponse.fromJson(result);

      if (callHistoryResponse.status == 'success') {
        callHistoryList.value = callHistoryResponse.data;
        debugPrint('Call history loaded: ${callHistoryList.length} calls');
      } else {
        errorMessage.value = 'Failed to load call history';
        debugPrint('Call history error: ${callHistoryResponse.status}');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      debugPrint('Error fetching call history: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh call history
  Future<void> refreshCallHistory() async {
    await fetchCallHistory();
  }

  // Format date for display
  String formatCallDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final callDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (callDate == today) {
        return 'Today, ${_formatTime(dateTime)}';
      } else if (callDate == today.subtract(const Duration(days: 1))) {
        return 'Yesterday, ${_formatTime(dateTime)}';
      } else {
        return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${_formatTime(dateTime)}';
      }
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // Format duration
  String formatDuration(String durationInSeconds) {
    try {
      final seconds = int.parse(durationInSeconds);
      if (seconds < 60) {
        return '${seconds}s';
      } else if (seconds < 3600) {
        final minutes = seconds ~/ 60;
        final remainingSeconds = seconds % 60;
        return '${minutes}m ${remainingSeconds}s';
      } else {
        final hours = seconds ~/ 3600;
        final minutes = (seconds % 3600) ~/ 60;
        return '${hours}h ${minutes}m';
      }
    } catch (e) {
      return durationInSeconds;
    }
  }
}