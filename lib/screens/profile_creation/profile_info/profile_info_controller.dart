import 'dart:io';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../../config/app_config.dart';
import '../invest_and_hobbies/interests_hobbies_screen.dart';

class ProfileInfoController extends GetxController {
  // Profile picture
  final Rx<File?> profileImage = Rx<File?>(null);

  // Controllers for profile info fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // Form validation
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Add listeners for the additional text input fields
    dateOfBirthController.addListener(validateForm);
    bioController.addListener(validateForm);
    usernameController.addListener(validateForm);
  }

  @override
  void onClose() {
    dateOfBirthController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.onClose();
  }

  // Pick image from gallery or camera
  void safePickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        validateForm();
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        "Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}. Please check app permissions.",
        colorText: AppColors.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        animationDuration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      );
    }
  }

  // Calendar dialog: show picker and format result
  Future<void> pickDateOfBirth(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 12, 12, 31),
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Theme(
            data: ThemeData.dark().copyWith(
              dialogBackgroundColor: AppColors.bgColor,
              colorScheme: ColorScheme.dark(
                primary: AppColors.primaryColor,
                surface: AppColors.bgColor,
                onSurface: AppColors.whiteColor,
                onPrimary: AppColors.whiteColor,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      final str = "${picked.day.toString().padLeft(2, '0')} "
          "${_monthName(picked.month)}, ${picked.year}";
      dateOfBirthController.text = str;
    }
  }

  String _monthName(int month) {
    const months = [
      "", // for1-based month
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month];
  }

  // Validate the form based on user type
  void validateForm() {
    final bool hasProfilePicture = profileImage.value != null;
    final bool hasUsername = usernameController.text.trim().isNotEmpty;
    final bool hasDOB = dateOfBirthController.text.trim().isNotEmpty;
    final bool hasBio = bioController.text.trim().isNotEmpty;

    isFormValid.value = hasProfilePicture && hasUsername && hasDOB && hasBio;
  }

  // Continue to next screen
  Future<void> continueToNext() async {
    try {
      if (profileImage.value == null) {
        Get.snackbar(
          AppStrings.error,
          "Please select a profile photo.",
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }
      if (usernameController.text.trim().isEmpty) {
        Get.snackbar(
          AppStrings.error,
          "Please enter your username.",
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }
      if (dateOfBirthController.text.trim().isEmpty) {
        Get.snackbar(
          AppStrings.error,
          ErrorMessages.enterDob,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }
      if (bioController.text.trim().isEmpty) {
        Get.snackbar(
          AppStrings.error,
          ErrorMessages.enterBio,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }

      AppLoader.show();
      VerifyOtpResponse? response = await _registerUser();
      AppLoader.hide();

      if (response != null && response.status == AppStrings.apiSuccess) {
        Get.snackbar(
          AppStrings.success,
          AppStrings.infoSaveSuccess,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        Get.to(() => InterestsHobbiesScreen());
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
    } catch (e) {
      AppLoader.hide();
    }
  }

  // create profile details api
  Future<VerifyOtpResponse?> _registerUser() async {
    try {
      int userId = StorageHelper().getUserId;

      // converting date to correct format which api accept
      // Define the input and output date formats
      DateFormat inputFormat = DateFormat('dd MMM, yyyy');
      DateFormat outputFormat = DateFormat('dd-MM-yyyy');

      // Parse and format
      DateTime parsedDate =
          inputFormat.parse(dateOfBirthController.text.trim());
      String formattedDate = outputFormat.format(parsedDate);

      var result = await ApiManager.callPostWithFormData(
          body: {
            ApiParam.id: '$userId',
            ApiParam.username: usernameController.text.trim(),
            ApiParam.dob: formattedDate,
            ApiParam.bio: bioController.text.trim()
          },
          endPoint: ApiUtils.createProfile,
          fileKey: ApiParam.profile,
          filePaths: [profileImage.value!.path]);

      VerifyOtpResponse registerResponse = VerifyOtpResponse.fromJson(result);
      return registerResponse;
    } catch (e) {
      AppLoader.hide();

      debugPrint('error register api ${e.toString()}');
    }
  }
}
