import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/community/community_controller.dart';

import '../../config/app_config.dart';
import '../create_community/create_community_screen.dart';
import 'models/community_profile_model.dart';

class CommunityProfileController extends GetxController {
   // CommunityProfileModel? community;

  @override
  void onInit() {
    super.onInit();
  }

  void removeMember(String memberId) {
    // community.members.removeWhere((m) => m.id == memberId);
    update();
  }

  void inviteMembers() {
    // invite logic
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
    );
  }

  void editCommunity(CommunityProfileModel communityProfileModel) {
    Get.to(() => CreateCommunityScreen(),arguments: communityProfileModel)
        ?.then((_) async {

    });
  }

}
