import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/interest_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';
import '../community_preferences/community_preferences_screen.dart';

class InterestsHobbiesController extends GetxController {
  static const maxSelections = 5;

  RxList<InterestResponseData> interestsList = <InterestResponseData>[].obs;

  RxList<InterestResponseData> hobbiesList = <InterestResponseData>[].obs;

  RxList<InterestResponseData> communitiesList = <InterestResponseData>[].obs;

  // storing the selected options
  final RxList<InterestResponseData> selectedInterests =
      <InterestResponseData>[].obs;
  final RxList<InterestResponseData> selectedHobbies =
      <InterestResponseData>[].obs;

  bool get canProceed =>
      selectedInterests.isNotEmpty && selectedHobbies.isNotEmpty;

  @override
  void onInit() {
    Future.wait([_getInterest(), _getHobbies() , _getCommunities()]);
    super.onInit();
  }

  void toggleInterest(InterestResponseData value) {
    if (selectedInterests.contains(value)) {
      selectedInterests.remove(value);
    } else if (selectedInterests.length < maxSelections) {
      selectedInterests.add(value);
    }
  }

  void toggleHobby(InterestResponseData value) {
    if (selectedHobbies.contains(value)) {
      selectedHobbies.remove(value);
    } else if (selectedHobbies.length < maxSelections) {
      selectedHobbies.add(value);
    }
  }

  Future<void> onNext() async {
    if (selectedInterests.isEmpty) {
      Get.snackbar(
        AppStrings.error,
        "Please select at least one interest.",
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
    if (selectedHobbies.isEmpty) {
      Get.snackbar(
        AppStrings.error,
        "Please select at least one hobby.",
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }

    AppLoader.show();
    var response = await Future.wait([_updateInterest(), _updateHobbies()]);
    AppLoader.hide();

    if (!(response.any((e) => e == null)) &&
        !(response.any((e) => e?.status != AppStrings.apiSuccess))) {
      Get.snackbar(
        AppStrings.success,
        "Selections saved successfully",
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );

      debugPrint('Selected Interests: $selectedInterests');
      debugPrint('Selected Hobbies: $selectedHobbies');

      Get.to(() => const CommunityPreferencesScreen());
    } else {
      Get.snackbar(
        AppStrings.error,
        response
                .where((e) => e?.status != AppStrings.apiSuccess)
                .first
                ?.message ??
            ErrorMessages.somethingWrong,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
  }

  Future<void> _getInterest() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.getInterest);

      InterestResponse response = InterestResponse.fromJson(result);

      if (response != null && response.data != null) {
        interestsList.value = response.data ?? [];
        interestsList.refresh();
      }
    } catch (e) {}
  }

  Future<void> _getHobbies() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.getHobbies);

      InterestResponse response = InterestResponse.fromJson(result);

      if (response != null && response.data != null) {
        hobbiesList.value = response.data ?? [];
        hobbiesList.refresh();
      }
    } catch (e) {}
  }


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



  Future<VerifyOtpResponse?> _updateInterest() async {
    try {
      int userId = StorageHelper().getUserId;

      // creating a temp list of selected interest ids
      List<int> ids = [];
      selectedInterests.map((e) => ids.add(e.id ?? 0)).toList();

      var result = await ApiManager.callPostWithFormData(
          body: {ApiParam.userId: '$userId', ApiParam.interestId: ids},
          endPoint: ApiUtils.updateInterest);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      AppLoader.hide();
    }
  }

  Future<VerifyOtpResponse?> _updateHobbies() async {
    try {
      int userId = StorageHelper().getUserId;

      // creating a temp list of selected hobbbies ids
      List<int> ids = [];
      selectedHobbies.map((e) => ids.add(e.id ?? 0)).toList();
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.hobbiesId: ids,
      }, endPoint: ApiUtils.updateHobbies);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      AppLoader.hide();
    }
  }
}
