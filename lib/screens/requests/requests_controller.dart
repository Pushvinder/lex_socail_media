import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/home/home_controller.dart';
import 'package:the_friendz_zone/screens/requests/models/linked_acccount_list_response.dart';
import 'package:the_friendz_zone/screens/requests/models/pending_community_request_response.dart';
import 'package:the_friendz_zone/screens/requests/models/pending_user_request_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../config/app_config.dart';
import 'models/requests_model.dart';

class RequestsController extends GetxController {
  final RxInt selectedTab = 0.obs;

  RxList<UserRequestData> connection = <UserRequestData>[].obs;

  RxList<CommunityRequestData> community = <CommunityRequestData>[].obs;

  RxList<Children> link = <Children>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit

    _getPendingCommunityRequest();
    _getPendingLinkAccountRequest();
    _getPendingRequestList();
    super.onInit();
  }

  // pending connection request api
  Future<PendingUserRequestResponse?> _getPendingRequestList() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      AppLoader.show();
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.userId: '$userId',
        },
        endPoint: ApiUtils.pendingUserRequest,
      );

      PendingUserRequestResponse pendingUserRequestResponse = PendingUserRequestResponse.fromJson(result);
      if (pendingUserRequestResponse.status == AppStrings.apiSuccess) {
        connection.value = pendingUserRequestResponse.data ?? [];
        connection.refresh();
      }
      AppLoader.hide();
      Get.findOrPut(HomeController()).requests = connection;
      return pendingUserRequestResponse;
    } catch (e) {
      AppLoader.hide();

      debugPrint('error register api ${e.toString()}');
      return null;
    }
  }

  // pending community request api
  Future<void> _getPendingCommunityRequest() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.userId: '$userId',
        },
        endPoint: ApiUtils.pendingCommunityRequest,
      );

      PendingCommunityRequestResponse pendingCommunityRequestResponse =
          PendingCommunityRequestResponse.fromJson(result);
      if (pendingCommunityRequestResponse.status == AppStrings.apiSuccess) {
        community.value = pendingCommunityRequestResponse.data ?? [];
        community.refresh();
      }
    } catch (e) {
      AppLoader.hide();

      debugPrint('error register api ${e.toString()}');
      return null;
    }
  }

  // pending linked account request api
  Future<LinkAccountListResponse?> _getPendingLinkAccountRequest() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.userId: '$userId',
        },
        endPoint: ApiUtils.linkAccountLIst,
      );

      LinkAccountListResponse linkAccountListResponse =
          LinkAccountListResponse.fromJson(result);

      if (linkAccountListResponse.status == AppStrings.apiSuccess) {
        link.value = linkAccountListResponse.data?.children ?? [];
        link.refresh();
      }
      return linkAccountListResponse;
    } catch (e) {
      AppLoader.hide();

      debugPrint('error register api ${e.toString()}');
      return null;
    }
  }

  // accept  request click action
  void acceptUserRequest(String userId, RequestType type, int index) async {
    try {
      AppLoader.show();

      VerifyOtpResponse? response =
          await _respondUserRequest(AppStrings.connectAccept, userId);
      _removeUser(type, index);
      // if (response != null && response.status == AppStrings.apiSuccess) {
      //   _removeUser(type, index);
      // }
      AppLoader.hide();
    } catch (e) {
      AppLoader.hide();
    }
  }

  // decline  request click actoin
  void declineUserRequest(String userId, RequestType type, int index) async {
    try {
      AppLoader.show();

      VerifyOtpResponse? response = await _respondUserRequest('declined', userId);

      if (response != null && response.status == AppStrings.apiSuccess) {
        _removeUser(type, index);
      }
      AppLoader.hide();
    } catch (e) {
      AppLoader.hide();
    }
  }

  // accept community  request click action
  void acceptCommunityRequest(
      String senderId, String communityId, RequestType type, int index) async {
    try {
      AppLoader.show();

      VerifyOtpResponse? response = await _respondCommunityRequest(
          AppStrings.joinAcceptedStatus, senderId, communityId);

      if (response != null && response.status == AppStrings.apiSuccess) {
        _removeUser(type, index);
      }
      AppLoader.hide();
    } catch (e) {
      AppLoader.hide();
    }
  }

  // decline community request click actoin
  void declineCommunityRequest(
      String senderId, String communityId, RequestType type, int index) async {
    try {
      AppLoader.show();

      VerifyOtpResponse? response = await _respondCommunityRequest(
          AppStrings.joinRejectedStatus, senderId, communityId);

      if (response != null && response.status == AppStrings.apiSuccess) {
        _removeUser(type, index);
      }
      AppLoader.hide();
    } catch (e) {
      AppLoader.hide();
    }
  }

  // remove pending request user from the list for which the user has taken an action
  void _removeUser(RequestType type, int index) {
    if (type == RequestType.connection) {
      if (connection.value.length > index) {
        connection.value.removeAt(index);
        connection.refresh();
      }
    } else if (type == RequestType.link) {
      if (link.value.length > index) {
        link.value.removeAt(index);
        link.refresh();
      }
    } else {
      if (community.value.length > index) {
        community.value.removeAt(index);
        community.refresh();
      }
    }
  }

  // respond to the connection request
  /// receiverid is the id of the other user we are responding to
  /// action : action we are taking connect or reject
  Future<VerifyOtpResponse?> _respondUserRequest(
      String action, String receiverId) async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.requestId: receiverId,
        ApiParam.action: action,
      }, endPoint: ApiUtils.respondRequest);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      debugPrint('getting error in home conenction list api ${e.toString()}');
      AppLoader.hide();

      return null;
    }
  }

  // respond to the connection request
  /// @param [senderId] is the id of the other user we are responding to
  /// @param [action] whether user accepted or rejected the request
  Future<VerifyOtpResponse?> _respondCommunityRequest(
      String action, String senderId, String communityId) async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.senderId: senderId,
        ApiParam.status: action,
        ApiParam.communityId: communityId
      }, endPoint: ApiUtils.respondCommunityRequuest);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      debugPrint('getting error in home conenction list api ${e.toString()}');
      return null;
    }
  }
}
