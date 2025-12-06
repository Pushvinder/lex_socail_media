import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import 'call_response_model.dart';

/// Service for handling call-related API requests
class CallApiService {
  /// Create a new call
  static Future<CallResponseModel?> createCall({
    required String receiverId,
    required String callType, // 'audio' or 'video'
  }) async {
    try {
      String currentUserId = StorageHelper().getUserId.toString();

      Map<String, dynamic> body = {
        ApiParam.request: 'create_call',
        ApiParam.callerId: currentUserId,
        ApiParam.receiverId: receiverId,
        ApiParam.callType: callType,
      };

      var result = await ApiManager.callPostWithFormData(
        body: body,
        endPoint: ApiUtils.createCall,
      );

      if (result != null && result['status'] == 'success') {
        return CallResponseModel.fromJson(result);
      }

      return null;
    } catch (e) {
      print('❌ Error creating call: $e');
      return null;
    }
  }

  /// End an ongoing call
  static Future<bool> endCall(String callId) async {
    try {
      String userId = StorageHelper().getUserId.toString();

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.request: 'end_call',
          ApiParam.userId: userId,
          ApiParam.callId: callId,
        },
        endPoint: ApiUtils.endCall,
      );

      return result != null && result['status'] == 'success';
    } catch (e) {
      print('❌ Error ending call: $e');
      return false;
    }
  }

  /// Accept an incoming call
  static Future<bool> acceptCall(String callId) async {
    try {
      String userId = StorageHelper().getUserId.toString();

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.request: 'response_call',
          ApiParam.userId: userId,
          ApiParam.callId: callId,
          'action': 'accept',
        },
        endPoint: ApiUtils.responseCall, // ✅ Single endpoint
      );

      return result != null && result['status'] == 'success';
    } catch (e) {
      print('❌ Error accepting call: $e');
      return false;
    }
  }
}
