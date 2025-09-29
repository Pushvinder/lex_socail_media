import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/user_profile/models/user_model.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';
import 'package:video_player/video_player.dart';

class UserProfileController extends GetxController {
  var isPhotosTab = true.obs;
  void setTab(bool showPhotos) => isPhotosTab.value = showPhotos;

  RxBool isLoading = true.obs;

  RxList<VideoPlayerController?> videoControllers =
      <VideoPlayerController?>[].obs;
  RxList<bool> isVideoInitialized = <bool>[].obs;
  RxList<bool> isVideoError = <bool>[].obs;

  RxList<PostImages> imagePostList = <PostImages>[].obs;
  RxList<PostVideos> videoPostList = <PostVideos>[].obs;

  UserProfile user = UserProfile();

  void _initVideoControllers() {
    disposeVideoControllers();
    int videoCount = videoPostList.value.length;
    videoControllers.value =
        List<VideoPlayerController?>.filled(videoCount, null, growable: true);
    isVideoInitialized.value =
        List<bool>.filled(videoCount, false, growable: true);
    isVideoError.value = List<bool>.filled(videoCount, false, growable: true);

    for (int i = 0; i < videoCount; i++) {
      final videoUrl = videoPostList.value[i].video ?? "";
      Uri? uri = Uri.tryParse(videoUrl);

      if (uri != null &&
          uri.isAbsolute &&
          (uri.scheme == 'http' || uri.scheme == 'https')) {
        final controller = VideoPlayerController.networkUrl(uri);
        videoControllers[i] = controller;
        controller.initialize().then((_) {
          isVideoInitialized[i] = true;
          isVideoError[i] = false;
          controller.setLooping(true);
          controller.pause();
          update();
        }).catchError((error, stackTrace) {
          isVideoInitialized[i] = false;
          isVideoError[i] = true;
          update();
        });
      } else {
        isVideoError[i] = true;
      }
    }
  }

  // Other user profile response
  Future<void> getUserProfileDetail(String targetUserId) async {
    try {
      isLoading.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
        ApiParam.targetUserId: targetUserId,
      }, endPoint: ApiUtils.userProfileDetails);

      UserProfile response = UserProfile.fromJson(result);

      if (response.status == AppStrings.apiSuccess) {
        user = response;
        imagePostList.value = response.data?.postImages ?? [];
        videoPostList.value = response.data?.postVideos ?? [];
        imagePostList.refresh();
        videoPostList.refresh();
        if (videoPostList.isNotEmpty) {
          _initVideoControllers();
        }
        isLoading.value = false;
      }
    } catch (e, s) {
      debugPrint("error other usr profile ${e.toString()}, --- $s");
      isLoading.value = false;
    }
  }

  int calculateAge(String dobString) {
    // Parse the string to a DateTime
    DateTime dob = DateFormat("dd-MM-yyyy").parse(dobString);
    DateTime today = DateTime.now();

    int age = today.year - dob.year;

    // Check if birthday has occurred yet this year
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age;
  }

  // send request
  Future<void> sendConnectionRequest(String receiverId) async {
    try {
      int userId = StorageHelper().getUserId;

      await _sendRequest(userId.toString(), receiverId);
    } catch (e) {}
  }

  /// send conncetion request to other user
  /// @param [receiverId] is the id of the other user we are sending request to
  /// @param [senderId] is the id of the current user
  Future<VerifyOtpResponse?> _sendRequest(
      String senderId, String receiverId) async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.receiverId: receiverId,
        ApiParam.senderId: senderId,
        ApiParam.status: true,
      }, endPoint: ApiUtils.sendRequest);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      debugPrint('getting error in home conenction list api ${e.toString()}');
      return null;
    }
  }

  void disposeVideoControllers() {
    for (var c in videoControllers) {
      c?.dispose();
    }
    videoControllers.clear();
    isVideoInitialized.clear();
    isVideoError.clear();
  }
}
