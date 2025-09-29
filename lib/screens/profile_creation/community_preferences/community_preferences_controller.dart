import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/interest_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';
import '../../subscription/subscription_screen.dart';

class CommunityPreferencesController extends GetxController {
  static const maxSelections = 5;

  RxList<InterestResponseData> communitiesList = <InterestResponseData>[].obs;

  final RxList<InterestResponseData> selectedCommunities =
      <InterestResponseData>[].obs;

  bool get canProceed => selectedCommunities.isNotEmpty;

  @override
  void onInit() {
    _getCommunities();
    super.onInit();
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

      Get.to(() => SubscriptionScreen());
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
