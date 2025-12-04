import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/community/community_controller.dart';
import 'package:the_friendz_zone/screens/community_invite_users/community_invite_screen.dart';

import '../../config/app_config.dart';
import '../create_community/create_community_screen.dart';
import 'models/community_profile_model.dart';

class CommunityProfileController extends GetxController {
   // CommunityProfileModel? community;

  var membersList = <JoinedUser>[].obs;
  var loaderId = ''.obs;
  late CommunityProfileModel communityProfileModel;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> removeMember(String memberId, String communityId) async {
    try {
      loaderId.value = memberId;
      update();
      int userId = StorageHelper().getUserId;
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.communityId: communityId,
        ApiParam.removeId: memberId,
      }, endPoint: ApiUtils.removeCommunityUser);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(
          result);

      if (response.status == "true") {
        membersList.value.removeWhere((t)=> t.id.toString() == memberId);
        loaderId.value = '';
            Get.find<CommunityController>().onInit();
        update();
      }
    } catch (e, s) {
      loaderId.value =  '';
      membersList.refresh();
      debugPrint('ERROR join COMMUNITY ${e.toString()} ,  $s');
      update();
    }
  }


  void inviteMembers() {
    Get.to(CommunityInviteScreen());
  }

  void leaveGroup() {
    // leave group logic
    AppDialogs.showConfirmationDialog(
      title: AppStrings.dialogLeaveGroupTitle,
      description: AppStrings.dialogLeaveGroupDescription,
      iconAsset: AppImages.groupIcon,
      iconBgColor: AppColors.redColor.withOpacity(0.13),
      iconColor: AppColors.redColor,
      confirmButtonText: AppStrings.leaveGroup,
      confirmButtonColor: AppColors.redColor,
      onConfirm: () {
        // logic to leave
        Get.back();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.cardBehindBg,
            content: Text(
              AppStrings.leftCommunitySnackbar,
              style: TextStyle(
                color: AppColors.redColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteCommunity(String communityId) {
    AppDialogs.showConfirmationDialog(
      title: AppStrings.deleteCommunity,
      description:
      AppStrings.dialogDeleteCommunityMessage,
      iconAsset: AppImages.deleteIcon,
      iconBgColor: AppColors.redColor
          .withOpacity(0.13),
      iconColor: AppColors.redColor,
      confirmButtonText:
      AppStrings.deleteCommunity,
      confirmButtonColor: AppColors.redColor,
      onConfirm: () async {
        deleteCommunityApi(communityId);
      }
    );
  }

  void editCommunity(CommunityProfileModel communityProfileModel) {
    Get.to(() => CreateCommunityScreen(),arguments: communityProfileModel)
        ?.then((value) async {
       if(value == "updated"){
         fetchCommunityDetails(communityProfileModel.data.communityId);
         Get.find<CommunityController>().onInit();
       }
    });
  }

  initializedData(CommunityProfileModel communityProfileModel) {
    this.communityProfileModel = communityProfileModel;
    membersList.value = communityProfileModel.data.joinedUsers;
  }

  Future<void> deleteCommunityApi(String communityId) async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.communityId: communityId,
      }, endPoint: ApiUtils.deleteCommunity);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(
          result);

      if (response.status == "true") {
        Get.back();
        Get.find<CommunityController>().onInit();

      }
    } catch (e, s) {
      debugPrint('ERROR join COMMUNITY ${e.toString()} ,  $s');
    }
  }


  Future<void> fetchCommunityDetails(String? communityId) async {
    try {
      int userId = StorageHelper().getUserId;
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
        ApiParam.communityId: communityId,
      }, endPoint: ApiUtils.getCommunityDetails);

      CommunityProfileModel response = CommunityProfileModel.fromJson(result);

      if (response.status == AppStrings.apiSuccess && response.data != null) {
       communityProfileModel = response;
        update();
      }
    } catch (e, s) {
      debugPrint('ERROR MY COMMUNITY ${e.toString()} ,  $s');
    }

  }
}
