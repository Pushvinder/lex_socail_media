// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/screens/profile/models/user_post_list_response.dart';
// import 'package:the_friendz_zone/screens/profile/models/user_response.dart';
// import 'package:the_friendz_zone/models/verify_otp_response.dart';
// import 'package:the_friendz_zone/utils/app_loader.dart';
// import 'package:the_friendz_zone/utils/firebase_utils.dart';
// import 'package:video_player/video_player.dart';
// import '../../config/app_config.dart';

// class ProfileController extends GetxController {
//   Rx<UserResponse> user = UserResponse().obs;

//   RxBool isPhotosTab = true.obs;
//   RxList<VideoPlayerController?> videoControllers = <VideoPlayerController?>[].obs;
//   RxList<bool> isVideoInitialized = <bool>[].obs;
//   RxList<bool> isVideoError = <bool>[].obs;

//   RxList<PostImages> imagePostList = <PostImages>[].obs;
//   RxList<PostVideos> videoPostList = <PostVideos>[].obs;


//   @override
//   void onReady() {
//     super.onReady();
//   }

//   @override
//   void onInit() {
//     debugPrint('on init called');
//     getProfileDetails();
//     _getPostDetails();

//     // TODO: implement onInit
//     super.onInit();
//   }

//   void _initVideoControllers() {
//     disposeVideoControllers();
//     int videoCount = videoPostList.value.length;
//     videoControllers.value =
//         List<VideoPlayerController?>.filled(videoCount, null,growable: true);
//     isVideoInitialized.value = List<bool>.filled(videoCount, false,growable: true);
//     isVideoError.value = List<bool>.filled(videoCount, false,growable: true);

//     for (int i = 0; i < videoCount; i++) {
//       final videoUrl = videoPostList.value[i].video ?? "";
//       Uri? uri = Uri.tryParse(videoUrl);

//       if (uri != null &&
//           uri.isAbsolute &&
//           (uri.scheme == 'http' || uri.scheme == 'https')) {
//         final controller = VideoPlayerController.networkUrl(uri);
//         videoControllers[i] = controller;
//         controller.initialize().then((_) {
//           isVideoInitialized[i] = true;
//           isVideoError[i] = false;
//           controller.setLooping(true);
//           controller.pause();
//           update();
//         }).catchError((error, stackTrace) {
//           isVideoInitialized[i] = false;
//           isVideoError[i] = true;
//           update();
//         });
//       } else {
//         isVideoError[i] = true;
//       }
//     }
//   }

//   // profile details api
//   Future<void> getProfileDetails() async {
//     try {
//       debugPrint('on init details called');
//       int userId = StorageHelper().getUserId;
//       var result = await ApiManager.callPostWithFormData(
//           body: {ApiParam.id: "$userId"}, endPoint: ApiUtils.getProfileDetail);
//       UserResponse userResponse = UserResponse.fromJson(result);
//       if (userResponse.data != null) {
//         user.value = userResponse;
//         user.refresh();
//         update();
//       }
//     } catch (e) {
//       AppLoader.hide();
//       debugPrint('error user details api ${e.toString()}');
//     }
//   }

//   // post details list api
//   Future<void> _getPostDetails() async {
//     try {
//       int userId = StorageHelper().getUserId;
//       var result = await ApiManager.callPostWithFormData(
//           body: {ApiParam.id: "$userId"}, endPoint: ApiUtils.getAllPostDetails);

//       UserPostListResponse response = UserPostListResponse.fromJson(result);
//       if (response.status ?? false) {
//         imagePostList.value = response.data?.postImages?? [];
//         videoPostList.value = response.data?.postVideos ?? [];
//         imagePostList.refresh();
//         videoPostList.refresh();
//         if(videoPostList.isNotEmpty) {
// _initVideoControllers();

//         }
//       }
//     } catch (e) {
//       AppLoader.hide();
//       debugPrint('error get post list api ${e.toString()}');
//     }
//   }

//   void disposeVideoControllers() {
//     for (var c in videoControllers) {
//       c?.dispose();
//     }
//     videoControllers.clear();
//     isVideoInitialized.clear();
//     isVideoError.clear();
//   }

//   int calculateAge(String dobString) {
//     // Parse the string to a DateTime
//     DateTime dob = DateFormat("dd-MM-yyyy").parse(dobString);
//     DateTime today = DateTime.now();

//     int age = today.year - dob.year;

//     // Check if birthday has occurred yet this year
//     if (today.month < dob.month ||
//         (today.month == dob.month && today.day < dob.day)) {
//       age--;
//     }

//     return age;
//   }

//   // // ---------------------------------------------------------------------------
//   // // PROFILE DATA & FOLLOW/UNFOLLOW
//   // // ---------------------------------------------------------------------------

//   // /// Fetch user document from Firestore once (no real-time subscription).
//   // Future<void> getProfileData(String uId) async {

//   //   Future.delayed(Duration.zero, () {
//   //     update();
//   //   });
//   //   try {
//   //     final userDoc = await FirebaseFirestore.instance
//   //         .collection(FirebaseUtils.users)
//   //         .doc(uId)
//   //         .get();

//   //     if (userDoc.exists && userDoc.data() != null) {
//   //       userData = UserModel.fromJson(userDoc.data()!);
//   //       if (isMyProfile) {
//   //         StatusService.initializePresence(userData!.uId!);
//   //         StorageHelper().notificationsEnabled =
//   //             userData?.isNotificationEnabled ?? false;
//   //       }
//   //     }
//   //   } catch (e) {
//   //     AppDialogs.errorSnackBar(AppStrings.errorMsg.tr);
//   //     rethrow;
//   //   } finally {
//   //     isLoading = false;
//   //     update();
//   //   }
//   // }

// }


import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/screens/profile/models/user_post_list_response.dart';
import 'package:the_friendz_zone/screens/profile/models/user_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';
import 'package:video_player/video_player.dart';
import '../../config/app_config.dart';

class ProfileController extends GetxController {

  Rx<UserResponse> user = UserResponse().obs;

  RxBool isLoading = true.obs; // << used for displaying loader
  RxBool isPhotosTab = true.obs;

  RxList<PostImages> imagePostList = <PostImages>[].obs;
  RxList<PostVideos> videoPostList = <PostVideos>[].obs;

  RxList<VideoPlayerController?> videoControllers = <VideoPlayerController?>[].obs;
  RxList<bool> isVideoInitialized = <bool>[].obs;
  RxList<bool> isVideoError = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProfileDetails();
    _getPostDetails();
  }

  /// ======================= PROFILE API =======================
  Future<void> getProfileDetails() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(
        body: {ApiParam.id: "$userId"},
        endPoint: ApiUtils.getProfileDetail,
      );

      UserResponse res = UserResponse.fromJson(result);

      if (res.data != null) {
        user.value = res;
      }

    } catch (e) {
      debugPrint("⚠ Profile API Error: $e");
    } finally {
      isLoading.value = false; // loader will stop
    }
  }

  /// ======================= POSTS API =======================
  Future<void> _getPostDetails() async {
    try {
      int userId = StorageHelper().getUserId;

      var response = await ApiManager.callPostWithFormData(
        body: {ApiParam.id: "$userId"},
        endPoint: ApiUtils.getAllPostDetails,
      );

      var res = UserPostListResponse.fromJson(response);

      if (res.status == true) {
        imagePostList.value = res.data?.postImages ?? [];
        videoPostList.value = res.data?.postVideos ?? [];

        if (videoPostList.isNotEmpty) _initVideoControllers();
      }
    } catch (e) {
      debugPrint("⚠ Post List Error: $e");
    }
  }

  /// ================== VIDEO CONTROLLERS ==================
  void _initVideoControllers() {
    disposeVideoControllers();

    int count = videoPostList.length;
    videoControllers.value = List.generate(count, (_) => null);
    isVideoInitialized.value = List.generate(count, (_) => false);
    isVideoError.value = List.generate(count, (_) => false);

    for (int i = 0; i < count; i++) {
      String url = videoPostList[i].video ?? "";
      Uri? uri = Uri.tryParse(url);

      if (uri != null && uri.isAbsolute) {
        final controller = VideoPlayerController.networkUrl(uri);
        videoControllers[i] = controller;

        controller.initialize().then((_) {
          isVideoInitialized[i] = true;
          controller.setLooping(true);
        }).catchError((_) => isVideoError[i] = true);

      } else {
        isVideoError[i] = true;
      }
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

  /// ================== AGE CALCULATOR ==================
  int calculateAge(String dobString) {
    DateTime dob = DateFormat("dd-MM-yyyy").parse(dobString);
    DateTime now = DateTime.now();
    int age = now.year - dob.year;

    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}
