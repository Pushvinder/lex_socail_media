import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/interest_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/profile/profile_screen.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';
import '../../home/home_screen.dart';
import '../../profile/models/user_response.dart';
import '../../subscription/subscription_screen.dart';

class EditCommunityPreferencesController extends GetxController {
  static const maxSelections = 5;

  RxList<InterestResponseData> communitiesList = <InterestResponseData>[].obs;

  final RxList<InterestResponseData> selectedCommunities =
      <InterestResponseData>[].obs;

  bool get canProceed => selectedCommunities.isNotEmpty;
  Rx<UserResponse> user = UserResponse().obs;

  @override
  void onInit() {
    _getProfileDetails();
    _getCommunities();
    super.onInit();
  }

  // profile details api
  Future<void> _getProfileDetails() async {
    try {
      debugPrint('on init details called');
      int userId = StorageHelper().getUserId;
      var result = await ApiManager.callPostWithFormData(
          body: {ApiParam.id: "$userId"}, endPoint: ApiUtils.getProfileDetail);
      UserResponse userResponse = UserResponse.fromJson(result);
      if (userResponse.data != null) {
        user.value = userResponse;
        user.refresh();
        update();
        setUserData();
      }
    } catch (e) {
      AppLoader.hide();
      debugPrint('error user details api ${e.toString()}');
    }
  }

  void setUserData(){
    if(user.value.data != null){
      if(communitiesList.isNotEmpty){
        user.value.data?.interests?.forEach((element){
          var interestItem =  communitiesList.firstWhere((data)=> data.name?.trim() == element.name?.trim());
          if(interestItem != null){
            selectedCommunities.add(interestItem);
            selectedCommunities.refresh();
          }
        });
      }
    }
    refresh();
    update();
  }

  void toggleCommunity(InterestResponseData value) {
    if (selectedCommunities.contains(value)) {
      selectedCommunities.remove(value);
    } else if (selectedCommunities.length < maxSelections) {
      selectedCommunities.add(value);
    }
  }

  Future<void> onDone() async {
    if (selectedCommunities.isEmpty) {
      Get.snackbar(
        AppStrings.error,
        "Please select at least one community.",
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }

    AppLoader.show();
    var response = await _updateCommunitiesSelection();
    AppLoader.hide();

    if (response != null && response.status == AppStrings.apiSuccess) {
      Get.snackbar(
        AppStrings.success,
        AppStrings.communityPrefernceSuccess,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );

      Get.to(() => ProfileScreen());
    } else {
      Get.snackbar(
        AppStrings.error,
        response?.message ?? ErrorMessages.somethingWrong,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
  }

  // get the list of communities api to show for selection
  Future<void> _getCommunities() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.getCommunities);

      InterestResponse response = InterestResponse.fromJson(result);

      if (response != null && response.data != null) {
        communitiesList.value = response.data ?? [];
        communitiesList.refresh();
      }
    } catch (e) {}
  }

  // update user communities preference api
  Future<VerifyOtpResponse?> _updateCommunitiesSelection() async {
    try {
      int userId = StorageHelper().getUserId;
      // creating a temp list of selected hobbbies ids
      List<int> ids = [];
      selectedCommunities.map((e) => ids.add(e.id ?? 0)).toList();
      ids = ids.toSet().toList(); // Remove duplicates from ids
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.communityId: ids,
      }, endPoint: ApiUtils.updateCommunities);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      AppLoader.hide();
    }
  }
}
