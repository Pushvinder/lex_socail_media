import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/interest_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';
import '../../../config/app_config.dart';
import '../community_profile/models/community_profile_model.dart';

class CreateCommunityController extends GetxController {
  var communityImage = ''.obs;
  var isUpdate = false.obs;
  var communityId = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();

  final RxList<InterestResponseData> selectedCategories =
      <InterestResponseData>[].obs;
  final RxBool isFormValid = false.obs;

  RxList<InterestResponseData> categoriesList = <InterestResponseData>[].obs;

  // final List<String> categories = [
  //   "Photography",
  //   "Crafting & DIY",
  //   "Singing",
  //   "Literature & Writing",
  //   "Health & Fitness",
  //   "Sports",
  //   "Food & Drinks",
  //   "Crafts & DIY",
  //   "Movies & TV Shows",
  //   "Science",
  //   "Travel",
  // ];

  @override
  void onInit() {
    _getCategories();
    super.onInit();
    nameController.addListener(validateForm);
    descriptionController.addListener(validateForm);
    rulesController.addListener(validateForm);
    selectedCategories.listen((_) => validateForm());
    communityImage.listen((_) => validateForm());
    prefilledData();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    rulesController.dispose();
    super.onClose();
  }

  void pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );
      if (image != null) {
        communityImage.value = image.path;
      }
    } catch (_) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.communityImageError,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
      );
    }
  }

  void pickImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.secondaryColor.withOpacity(0.5),
      builder: (ctx) {
        return GestureDetector(
          onTap: () {},
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.8),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    "Select community photo",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: FontDimen.dimen18,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBottomOption(
                    ctx,
                    Icons.camera_alt_rounded,
                    "Take a photo",
                        () {
                      Navigator.pop(ctx);
                      pickImage(ImageSource.camera);
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
                  _buildBottomOption(
                    ctx,
                    Icons.photo_library_rounded,
                    "Choose from gallery",
                        () {
                      Navigator.pop(ctx);
                      pickImage(ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: AppDimens.dimen20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          AppStrings.cancel,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: FontDimen.dimen14,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts
                                .inter()
                                .fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomOption(BuildContext context, IconData icon, String title,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dimen20, vertical: AppDimens.dimen16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: FontDimen.dimen14,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts
                    .inter()
                    .fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Single-select (like radio) or allow multi-select as in InterestsHobbies
  void toggleCategory(InterestResponseData value) {
    if (selectedCategories.contains(value)) {
      selectedCategories.remove(value);
    } else {
      selectedCategories.add(value);
    }
  }

  /// Validation logic similar to profile_info_controller.dart
  void validateForm() async {
    final bool hasImage = communityImage.value != null;
    final bool hasName = nameController.text
        .trim()
        .isNotEmpty;
    final bool hasCategory = selectedCategories.isNotEmpty;
    final bool hasDescription = descriptionController.text
        .trim()
        .isNotEmpty;
    final bool hasRules = rulesController.text
        .trim()
        .isNotEmpty;

    isFormValid.value =
        hasImage && hasName && hasCategory && hasDescription && hasRules;
  }

  /// Continue to create community, show error for each missing field
  Future<void> createCommunity() async {
    if (communityImage.value == null) {
      Get.snackbar(
        AppStrings.error,
        ErrorMessages.communityPhoto,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
    if (nameController.text
        .trim()
        .isEmpty) {
      Get.snackbar(
        AppStrings.error,
        ErrorMessages.communityName,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
    if (selectedCategories.isEmpty) {
      Get.snackbar(
        AppStrings.error,
        ErrorMessages.selectCategory,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
    if (descriptionController.text
        .trim()
        .isEmpty) {
      Get.snackbar(
        AppStrings.error,
        ErrorMessages.communityDescription,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }
    if (rulesController.text
        .trim()
        .isEmpty) {
      Get.snackbar(
        AppStrings.error,
        ErrorMessages.communityRules,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
      return;
    }

    AppLoader.show();
    var response = await _createCommunity();

    if (response != null && response.status == AppStrings.apiSuccess) {
      AppLoader.hide();
      Get.back(result: 'updated');
      Get.snackbar(
        AppStrings.success,
       isUpdate.value ? AppStrings.communitUpdatedSuccess:  AppStrings.communitCreateSuccess,
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
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

  Future<VerifyOtpResponse?> _createCommunity() async {
    try {
      int userId = StorageHelper().getUserId;
      // creating a temp list of selected interest ids
      List<int> ids = [];
      selectedCategories.map((e) => ids.add(e.id ?? 0)).toList();

      var request = {
        ApiParam.userId: '$userId',
        ApiParam.nameCommunity: nameController.text.trim(),
        ApiParam.communityDescription: descriptionController.text.trim(),
        ApiParam.communityRules: rulesController.text.trim(),
        "${ApiParam.categoryId}[]": ids,
      };

      if(isUpdate.value){
        request[ApiParam.communityId] = communityId;
      }

      var result = await ApiManager.callPostWithFormData(
          body: request,
          endPoint: isUpdate.value ? ApiUtils.updaetCommunity : ApiUtils.createCommunity,
          fileKey: ApiParam.image,
          filePaths: [communityImage.value.contains('http') ? '' : communityImage.value ?? '']);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
      AppLoader.hide();

      return response;
    } catch (e) {
      AppLoader.hide();
      return null;
    }
  }

  Future<void> _getCategories() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.getCommunities);

      InterestResponse response = InterestResponse.fromJson(result);

      if (response != null && response.data != null) {
        categoriesList.value = response.data ?? [];
        categoriesList.refresh();
        if (Get.arguments != null) {
          updateCategoris();
        }
      }
    } catch (e) {}
  }

  void prefilledData() {
    if (Get.arguments != null) {
      isUpdate.value = true;
      communityId = Get.arguments.data.communityId;
      CommunityProfileModel communityProfileModel = Get.arguments;
      communityImage.value = communityProfileModel.data.communityProfile;
      nameController.text = communityProfileModel.data.communityName;
      descriptionController.text =
          communityProfileModel.data.communityDescription;
      rulesController.text = communityProfileModel.data.communityRules;
    }
  }

  void updateCategoris() {
    CommunityProfileModel communityProfileModel = Get.arguments;
    for (var item in communityProfileModel.data.communitiesList) {
      for (var item2 in categoriesList) {
        if (item.communityId == item2.id) {
          selectedCategories.add(item2);
        }
      }
    }
  }
}

