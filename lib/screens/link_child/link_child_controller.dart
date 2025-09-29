import 'package:get/get.dart';
import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';

import 'models/account_user_model.dart';

class LinkChildAccountController extends GetxController {
  RxList<Friend> allUsers = <Friend>[].obs;
  RxList<Friend> filteredUsers = <Friend>[].obs;
  RxString search = "".obs;

  RxBool isLoadingFriendsList = true.obs;

  @override
  void onInit() {
    _getFriendsList();
    super.onInit();
  }

  void onSearch(String value) {
    search.value = value;
    filteredUsers.value = value.trim().isEmpty
        ? List.from(allUsers)
        : allUsers
            .where(
                (u) => u.username!.toLowerCase().contains(value.toLowerCase()))
            .toList();
  }

  void toggleSelect(int index) {
    final user = filteredUsers[index];
    user.isSelected = !(user.isSelected ?? false);
    filteredUsers.refresh();
    allUsers[allUsers.indexWhere((e) => e.id == user.id)].isSelected =
        user.isSelected;
    allUsers.refresh();
  }

  void sendLinkRequest() {
    final selectedIds =
        allUsers.where((u) => u.isSelected ?? false).map((u) => u.id).toList();
    // send logic here
  }

  // list of friends
  /// friends list to show on link accoun
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
        allUsers.value = response.data?.friends ?? [];
        filteredUsers.value = List.from(allUsers);
      }
      isLoadingFriendsList.value = false;
    } catch (e, s) {
      isLoadingFriendsList.value = false;

      debugPrint('error fetching friends list ${e.toString()} ,  $s');
    }
  }


   /// send link child request
   /// @param [childId] id of the user whose account current user want to link as child 
  Future<void> _linkChildAccount(String childId) async {
    try {
      isLoadingFriendsList.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.parentId: '$userId',
        ApiParam.childId: '$userId',

      }, endPoint: ApiUtils.friendList);

      AccountUserModelResponse response =
          AccountUserModelResponse.fromJson(result);
      if (response.data != null) {
        allUsers.value = response.data?.friends ?? [];
        filteredUsers.value = List.from(allUsers);
      }
      isLoadingFriendsList.value = false;
    } catch (e, s) {
      isLoadingFriendsList.value = false;

      debugPrint('error fetching friends list ${e.toString()} ,  $s');
    }
  }
}
