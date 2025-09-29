import 'dart:io';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/interest_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';
import 'package:video_player/video_player.dart';
import '../../config/app_config.dart';

class CreatePostController extends GetxController {
  final RxInt tabIndex = 0.obs; // 0: image, 1: video
  final RxList<File> images = <File>[].obs;
  final Rx<File?> video = Rx<File?>(null);

  final TextEditingController locationController = TextEditingController();
  Rx<String> contentAgeSuitability = ''.obs;
  Rx<int> contentAgeSuitabilityId = (-1).obs;

  final TextEditingController captionController = TextEditingController();

  // final ageOptions = [
  //   AppStrings.contentAgeAll,
  //   AppStrings.contentAge10,
  //   AppStrings.contentAge13,
  //   AppStrings.contentAge16,
  //   AppStrings.contentAge18,
  // ];

  final picker = ImagePicker();

  VideoPlayerController? videoPlayerController;
  Future<void>? videoPlayerFuture;

  // age cotent response to show on drop down form which user can select which age content does this post contain
  RxList<ContentAgeData?> contentAgeResponse = <ContentAgeData>[].obs;

  @override
  void onInit() {
    _getAgeContentList();

    super.onInit();
  }

  Future<void> pickImages() async {
    final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 75);
    if (picked != null) {
      final context = Get.context;
      if (context != null) {
        for (final xfile in picked) {
          final file = File(xfile.path);
          await precacheImage(FileImage(file), context);
          images.add(file);
        }
      } else {
        images.addAll(picked.map((e) => File(e.path)));
      }
    }
  }

  Future<void> pickSingleImage() async {
    final XFile? picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) images.add(File(picked.path));
  }

  Future<void> pickVideo() async {
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      video.value = File(picked.path);
      await initializeVideoPlayer(File(picked.path));
      update(['video_player']);
    }
  }

  Future<void> initializeVideoPlayer(File file) async {
    videoPlayerController?.dispose();
    videoPlayerController = VideoPlayerController.file(file);
    videoPlayerFuture = videoPlayerController!.initialize();
    await videoPlayerFuture;
    videoPlayerController!.setLooping(true);
    update(['video_player']);
  }

  void removeImageAt(int index) {
    images.removeAt(index);
  }

  void removeVideo() {
    video.value = null;
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPlayerFuture = null;
    update(['video_player']);
  }

  void clearData() {
    images.clear();
    video.value = null;
    locationController.clear();
    captionController.clear();
    contentAgeSuitability.value = '';
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPlayerFuture = null;
  }

  // create post api
  Future<void> createPost(VoidCallback onSuccess , String communityId) async {
    try {
      if (locationController.text.trim().isEmpty) {
        Get.snackbar(
          AppStrings.error,
          ErrorMessages.enterLoc,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }
      if (captionController.text.trim().isEmpty) {
        Get.snackbar(
          AppStrings.error,
          ErrorMessages.enterCaption,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }
      if (contentAgeSuitabilityId.value < 0) {
        Get.snackbar(
          AppStrings.error,
          ErrorMessages.selectAge,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }

      AppLoader.show();
      int userId = StorageHelper().getUserId;

      // for uplaoding image post only
      // Note: for image we can upload multiple images in single post
      // current limit - 10 images

      if (tabIndex.value == 0) {
        if (images.value.isEmpty) {
          AppLoader.hide();

          Get.snackbar(
            AppStrings.error,
            ErrorMessages.uploadImage,
            colorText: AppColors.whiteColor,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          );

          return;
        }
        List<String> filePaths = [];
        images.value.map((e) => filePaths.add(e.path)).toList();
        var result = await ApiManager.callPostWithFormData(
            body: {
              ApiParam.userId: "$userId",
              ApiParam.communityId: communityId,
              ApiParam.ageSuitability: contentAgeSuitabilityId.value,
              ApiParam.location: locationController.text.trim(),
              ApiParam.caption: captionController.text.trim(),
            },
            endPoint: communityId.isEmpty ? ApiUtils.createPost : ApiUtils.createCommunityPost,
            fileKey: communityId.isEmpty ? '${ApiParam.image}[]' : 'images[]',
            filePaths: filePaths);

        VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
        if (response.status == AppStrings.apiSuccess) {
          AppLoader.hide();
          onSuccess();
          Get.snackbar(
            AppStrings.success,
            AppStrings.postCreateSuccess,
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColors.whiteColor,
            backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
            animationDuration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          );
        } else {
          AppLoader.hide();
          Get.snackbar(
            ErrorMessages.error,
            response.message ?? ErrorMessages.invalidEmail,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
            colorText: AppColors.whiteColor,
            margin: const EdgeInsets.all(15),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
        }
      }

      // for uploading video post only
      // NOte: we can upload single video at a time
      else {
        if (video.value == null) {
          AppLoader.hide();

          Get.snackbar(
            AppStrings.error,
            ErrorMessages.uploadImage,
            colorText: AppColors.whiteColor,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          );

          return;
        }
        List<String> filePaths = [];
        if (video.value != null) {
          filePaths.add(video.value!.path);
        }

        var result = await ApiManager.callPostWithFormData(
            body: {
              ApiParam.userId: "$userId",
              ApiParam.ageSuitability: contentAgeSuitabilityId.value,
              ApiParam.location: locationController.text.trim(),
              ApiParam.caption: captionController.text.trim(),
            },
            endPoint: ApiUtils.createPost,
            fileKey: ApiParam.video,
            filePaths: filePaths,
            multipartFile: {
              '${ApiParam.image}[]': null,
            });
        VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
        if (response.status == AppStrings.apiSuccess) {
          AppLoader.hide();
          onSuccess();

          Get.snackbar(
            AppStrings.success,
            AppStrings.postCreateSuccess,
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColors.whiteColor,
            backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
            animationDuration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          );
        } else {
          AppLoader.hide();
          Get.snackbar(
            ErrorMessages.error,
            response.message ?? ErrorMessages.invalidEmail,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
            colorText: AppColors.whiteColor,
            margin: const EdgeInsets.all(15),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      AppLoader.hide();
      debugPrint('error create post api ${e.toString()}');
    }
  }

  Future<void> _getAgeContentList() async {
    try {
      var result = await ApiManager.callGet(
          queryParams: {ApiParam.request: ApiUtils.getAgeContentList});

      ContentAgeResponse response = ContentAgeResponse.fromJson(result);
      if (response.status == AppStrings.apiSuccess) {
        contentAgeResponse.value = response.data ?? [];
        contentAgeResponse.refresh();
      }
    } catch (e) {
      debugPrint('error get age list ${e.toString()}');
    }
  }

  @override
  void onClose() {
    // Clean up all data
    images.clear();
    video.value = null;
    locationController.clear();
    captionController.clear();
    contentAgeSuitability.value = '';
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPlayerFuture = null;
    super.onClose();
  }
}
