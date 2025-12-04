// import 'dart:io';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/models/interest_response.dart';
// import 'package:the_friendz_zone/models/verify_otp_response.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import 'package:the_friendz_zone/utils/app_loader.dart';
// import 'package:video_player/video_player.dart';
// import '../../config/app_config.dart';

// class CreatePostController extends GetxController {
//   final RxInt tabIndex = 0.obs; // 0: image, 1: video
//   final RxList<File> images = <File>[].obs;
//   final Rx<File?> video = Rx<File?>(null);

//   final TextEditingController locationController = TextEditingController();
//   Rx<String> contentAgeSuitability = ''.obs;
//   Rx<int> contentAgeSuitabilityId = (-1).obs;

//   final TextEditingController captionController = TextEditingController();

//   // final ageOptions = [
//   //   AppStrings.contentAgeAll,
//   //   AppStrings.contentAge10,
//   //   AppStrings.contentAge13,
//   //   AppStrings.contentAge16,
//   //   AppStrings.contentAge18,
//   // ];

//   final picker = ImagePicker();

//   VideoPlayerController? videoPlayerController;
//   Future<void>? videoPlayerFuture;

//   // age cotent response to show on drop down form which user can select which age content does this post contain
//   RxList<ContentAgeData?> contentAgeResponse = <ContentAgeData>[].obs;

//   @override
//   void onInit() {
//     _getAgeContentList();

//     super.onInit();
//   }

//   Future<void> pickImages() async {
//     final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 75);
//     if (picked != null) {
//       final context = Get.context;
//       if (context != null) {
//         for (final xfile in picked) {
//           final file = File(xfile.path);
//           await precacheImage(FileImage(file), context);
//           images.add(file);
//         }
//       } else {
//         images.addAll(picked.map((e) => File(e.path)));
//       }
//     }
//   }

//   Future<void> pickSingleImage() async {
//     final XFile? picked =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (picked != null) images.add(File(picked.path));
//   }

//   Future<void> pickVideo() async {
//     final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
//     if (picked != null) {
//       video.value = File(picked.path);
//       await initializeVideoPlayer(File(picked.path));
//       update(['video_player']);
//     }
//   }

//   Future<void> initializeVideoPlayer(File file) async {
//     videoPlayerController?.dispose();
//     videoPlayerController = VideoPlayerController.file(file);
//     videoPlayerFuture = videoPlayerController!.initialize();
//     await videoPlayerFuture;
//     videoPlayerController!.setLooping(true);
//     update(['video_player']);
//   }

//   void removeImageAt(int index) {
//     images.removeAt(index);
//   }

//   void removeVideo() {
//     video.value = null;
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//     update(['video_player']);
//   }

//   void clearData() {
//     images.clear();
//     video.value = null;
//     locationController.clear();
//     captionController.clear();
//     contentAgeSuitability.value = '';
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//   }

//   // create post api
// Future<void> createPost(VoidCallback onSuccess , String communityId) async {
//   try {
//     if (locationController.text.trim().isEmpty) {
//       Get.snackbar(
//         AppStrings.error,
//         ErrorMessages.enterLoc,
//         colorText: AppColors.whiteColor,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       );
//       return;
//     }
//     if (captionController.text.trim().isEmpty) {
//       Get.snackbar(
//         AppStrings.error,
//         ErrorMessages.enterCaption,
//         colorText: AppColors.whiteColor,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       );
//       return;
//     }
//     if (contentAgeSuitabilityId.value < 0) {
//       Get.snackbar(
//         AppStrings.error,
//         ErrorMessages.selectAge,
//         colorText: AppColors.whiteColor,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       );
//       return;
//     }

//     AppLoader.show();
//     int userId = StorageHelper().getUserId;

//     // for uplaoding image post only
//     // Note: for image we can upload multiple images in single post
//     // current limit - 10 images

//     if (tabIndex.value == 0) {
//       if (images.value.isEmpty) {
//         AppLoader.hide();

//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.uploadImage,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );

//         return;
//       }
//       List<String> filePaths = [];
//       images.value.map((e) => filePaths.add(e.path)).toList();
//       var result = await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.userId: "$userId",
//             ApiParam.communityId: communityId,
//             ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//             ApiParam.location: locationController.text.trim(),
//             ApiParam.caption: captionController.text.trim(),
//           },
//           endPoint: communityId.isEmpty ? ApiUtils.createPost : ApiUtils.createCommunityPost,
//           fileKey: communityId.isEmpty ? '${ApiParam.image}[]' : 'images[]',
//           filePaths: filePaths);

//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         AppLoader.hide();
//         onSuccess();
//         Get.snackbar(
//           AppStrings.success,
//           AppStrings.postCreateSuccess,
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: AppColors.whiteColor,
//           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//           animationDuration: const Duration(milliseconds: 500),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//       } else {
//         AppLoader.hide();
//         Get.snackbar(
//           ErrorMessages.error,
//           response.message ?? ErrorMessages.invalidEmail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//       }
//     }

//     // for uploading video post only
//     // NOte: we can upload single video at a time
//     else {
//       if (video.value == null) {
//         AppLoader.hide();

//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.uploadImage,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );

//         return;
//       }
//       List<String> filePaths = [];
//       if (video.value != null) {
//         filePaths.add(video.value!.path);
//       }

//       var result = await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.userId: "$userId",
//             ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//             ApiParam.location: locationController.text.trim(),
//             ApiParam.caption: captionController.text.trim(),
//           },
//           endPoint: ApiUtils.createPost,
//           fileKey: ApiParam.video,
//           filePaths: filePaths,
//           multipartFile: {
//             '${ApiParam.image}[]': null,
//           });
//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         AppLoader.hide();
//         onSuccess();

//         Get.snackbar(
//           AppStrings.success,
//           AppStrings.postCreateSuccess,
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: AppColors.whiteColor,
//           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//           animationDuration: const Duration(milliseconds: 500),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//       } else {
//         AppLoader.hide();
//         Get.snackbar(
//           ErrorMessages.error,
//           response.message ?? ErrorMessages.invalidEmail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//       }
//     }
//   } catch (e) {
//     AppLoader.hide();
//     debugPrint('error create post api ${e.toString()}');
//   }
// }

//   Future<void> _getAgeContentList() async {
//     try {
//       var result = await ApiManager.callGet(
//           queryParams: {ApiParam.request: ApiUtils.getAgeContentList});

//       ContentAgeResponse response = ContentAgeResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         contentAgeResponse.value = response.data ?? [];
//         contentAgeResponse.refresh();
//       }
//     } catch (e) {
//       debugPrint('error get age list ${e.toString()}');
//     }
//   }

//   @override
//   void onClose() {
//     // Clean up all data
//     images.clear();
//     video.value = null;
//     locationController.clear();
//     captionController.clear();
//     contentAgeSuitability.value = '';
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//     super.onClose();
//   }
// }
//--------------------- UPDATED CREATE POST CONTROLLER --------------------//
//━━━━━━━━━━━━━━━━ CREATE POST API ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  // Future<void> createPost(VoidCallback onSuccess, String communityId) async {
  //   if (!_validatePost()) return;

  //   AppLoader.show();

  //   try {
  //     List<String> imagePaths = images.map((e) => e.path).toList();
  //     String? videoPath = video.value?.path;

  //     var body = {
  //       ApiParam.userId: StorageHelper().getUserId.toString(),
  //       ApiParam.communityId: communityId,
  //       ApiParam.ageSuitability: contentAgeSuitabilityId.value,
  //       ApiParam.location: locationController.text.trim(),
  //       ApiParam.caption: captionController.text.trim(),
  //     };

  //     // Determine which API to call based on content type
  //     if (tabIndex.value == 0) {
  //       // IMAGES POST
  //       if (imagePaths.isEmpty) {
  //         _toast("Please upload at least one image");
  //         AppLoader.hide();
  //         return;
  //       }

  //       // First try with "images[]"
  //       try {
  //         print("Attempting to create post with images[] key");
  //         var result = await ApiManager.callPostWithFormData(
  //           body: body,
  //           endPoint: ApiUtils.createPost,
  //           fileKey: "images[]",
  //           filePaths: imagePaths,
  //         );

  //         AppLoader.hide();
  //         _handleCreateResponse(result, onSuccess);
  //       } catch (e) {
  //         // If that fails, try with "image[]" (singular)
  //         print("images[] failed, trying image[]: $e");
  //         AppLoader.show();
  //         try {
  //           var result = await ApiManager.callPostWithFormData(
  //             body: body,
  //             endPoint: ApiUtils.createPost,
  //             fileKey: "image[]",
  //             filePaths: imagePaths,
  //           );

  //           AppLoader.hide();
  //           _handleCreateResponse(result, onSuccess);
  //         } catch (e2) {
  //           // If both fail, try with "image" (without brackets)
  //           print("image[] failed, trying image: $e2");
  //           AppLoader.show();
  //           var result = await ApiManager.callPostWithFormData(
  //             body: body,
  //             endPoint: ApiUtils.createPost,
  //             fileKey: "image",
  //             filePaths: imagePaths,
  //           );

  //           AppLoader.hide();
  //           _handleCreateResponse(result, onSuccess);
  //         }
  //       }
  //     } else {
  //       // VIDEO POST
  //       if (videoPath == null) {
  //         _toast("Please upload a video");
  //         AppLoader.hide();
  //         return;
  //       }

  //       var result = await ApiManager.callPostWithFormData(
  //         body: body,
  //         endPoint: ApiUtils.createPost,
  //         fileKey: "video",
  //         filePaths: [videoPath],
  //       );

  //       AppLoader.hide();
  //       _handleCreateResponse(result, onSuccess);
  //     }
  //   } catch (e) {
  //     AppLoader.hide();
  //     print("Create post error: $e");
  //     _toast("Error creating post: $e");
  //   }
  // }

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:video_player/video_player.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/api_helpers/api_manager.dart';
// import 'package:the_friendz_zone/utils/app_loader.dart';
// import 'package:the_friendz_zone/models/verify_otp_response.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import '../../config/app_config.dart';

// class CreatePostController extends GetxController {
//   /// Tabs → 0 = images | 1 = video
//   final RxInt tabIndex = 0.obs;

//   /// Newly picked images
//   final RxList<File> images = <File>[].obs;

//   /// Existing (old) images from server - for edit
//   final RxList<String> imagesFromServer = <String>[].obs;

//   /// Selected video file
//   final Rx<File?> video = Rx<File?>(null);
//   Rx<String?> serverVideoUrl = Rx<String?>(null); // For edit mode

//   VideoPlayerController? videoPlayerController;
//   Future<void>? videoPlayerFuture;

//   final picker = ImagePicker();

//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController captionController = TextEditingController();

//   /// Age dropdown
//   Rx<String> contentAgeSuitability = ''.obs;
//   Rx<int> contentAgeSuitabilityId = 0.obs;

//   /// Backend response of age suitability list
//   RxList<ContentAgeData?> contentAgeResponse = <ContentAgeData>[].obs;

//   //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   @override
//   void onInit() {
//     _getAgeContentList();
//     super.onInit();
//   }

//   //━━━━━━━━━━━━━━━━ IMAGE PICKER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> pickImages() async {
//     final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 75);
//     if (picked != null) {
//       images.addAll(picked.map((e) => File(e.path)));
//     }
//   }

//   void removeImageAt(int index) => images.removeAt(index);

//   /// Remove saved server image when editing
//   void removeServerImage(int index) => imagesFromServer.removeAt(index);

//   //━━━━━━━━━━━━━━━━ VIDEO HANDLING ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> pickVideo() async {
//     final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
//     if (picked != null) {
//       video.value = File(picked.path);
//       serverVideoUrl.value = null; // Clear server video when picking new one
//       await initializeVideoPlayer(video.value!);
//       update(['video_player']);
//     }
//   }

//   Future<void> initializeVideoPlayer(File file) async {
//     videoPlayerController?.dispose();
//     videoPlayerController = VideoPlayerController.file(file);
//     videoPlayerFuture = videoPlayerController!.initialize();
//     await videoPlayerFuture;
//     videoPlayerController!.setLooping(true);
//     update(['video_player']);
//   }

//   Future<void> initializeVideoPlayerFromUrl(String url) async {
//     try {
//       videoPlayerController?.dispose();
//       videoPlayerController = VideoPlayerController.network(url);
//       videoPlayerFuture = videoPlayerController!.initialize();
//       await videoPlayerFuture;
//       videoPlayerController!.setLooping(true);
//       update(['video_player']);
//     } catch (e) {
//       print("Error initializing video from URL: $e");
//     }
//   }

//   void toggleVideoPlayback() {
//     if (videoPlayerController == null) return;
//     if (videoPlayerController!.value.isPlaying) {
//       videoPlayerController!.pause();
//     } else {
//       videoPlayerController!.play();
//     }
//     update(['video_player']);
//   }

//   void removeVideo() {
//     video.value = null;
//     serverVideoUrl.value = null;
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//     update(['video_player']);
//   }

//   //━━━━━━━━━━━━━━━━ AGE LIST GET ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> _getAgeContentList() async {
//     try {
//       var result = await ApiManager.callGet(
//         queryParams: {ApiParam.request: ApiUtils.getAgeContentList},
//       );

//       ContentAgeResponse parsed = ContentAgeResponse.fromJson(result);
//       if (parsed.status == AppStrings.apiSuccess) {
//         contentAgeResponse.value = parsed.data ?? [];
//         contentAgeResponse.refresh();
//       }
//     } catch (e) {
//       debugPrint("Age list error $e");
//     }
//   }

  
//     // create post api
// Future<void> createPost(VoidCallback onSuccess , String communityId) async {
//   try {
//     if (locationController.text.trim().isEmpty) {
//       Get.snackbar(
//         AppStrings.error,
//         ErrorMessages.enterLoc,
//         colorText: AppColors.whiteColor,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       );
//       return;
//     }
//     if (captionController.text.trim().isEmpty) {
//       Get.snackbar(
//         AppStrings.error,
//         ErrorMessages.enterCaption,
//         colorText: AppColors.whiteColor,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       );
//       return;
//     }
//     if (contentAgeSuitabilityId.value < 0) {
//       Get.snackbar(
//         AppStrings.error,
//         ErrorMessages.selectAge,
//         colorText: AppColors.whiteColor,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       );
//       return;
//     }

//     AppLoader.show();
//     int userId = StorageHelper().getUserId;

//     // for uplaoding image post only
//     // Note: for image we can upload multiple images in single post
//     // current limit - 10 images

//     if (tabIndex.value == 0) {
//       if (images.value.isEmpty) {
//         AppLoader.hide();

//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.uploadImage,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );

//         return;
//       }
//       List<String> filePaths = [];
//       images.value.map((e) => filePaths.add(e.path)).toList();
//       var result = await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.userId: "$userId",
//             ApiParam.communityId: communityId,
//             ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//             ApiParam.location: locationController.text.trim(),
//             ApiParam.caption: captionController.text.trim(),
//           },
//           endPoint: communityId.isEmpty ? ApiUtils.createPost : ApiUtils.createCommunityPost,
//           fileKey: communityId.isEmpty ? '${ApiParam.image}[]' : 'images[]',
//           filePaths: filePaths);

//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         AppLoader.hide();
//         onSuccess();
//         Get.snackbar(
//           AppStrings.success,
//           AppStrings.postCreateSuccess,
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: AppColors.whiteColor,
//           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//           animationDuration: const Duration(milliseconds: 500),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//       } else {
//         AppLoader.hide();
//         Get.snackbar(
//           ErrorMessages.error,
//           response.message ?? ErrorMessages.invalidEmail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//       }
//     }

//     // for uploading video post only
//     // NOte: we can upload single video at a time
//     else {
//       if (video.value == null) {
//         AppLoader.hide();

//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.uploadImage,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );

//         return;
//       }
//       List<String> filePaths = [];
//       if (video.value != null) {
//         filePaths.add(video.value!.path);
//       }

//       var result = await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.userId: "$userId",
//             ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//             ApiParam.location: locationController.text.trim(),
//             ApiParam.caption: captionController.text.trim(),
//           },
//           endPoint: ApiUtils.createPost,
//           fileKey: ApiParam.video,
//           filePaths: filePaths,
//           multipartFile: {
//             '${ApiParam.image}[]': null,
//           });
//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         AppLoader.hide();
//         onSuccess();

//         Get.snackbar(
//           AppStrings.success,
//           AppStrings.postCreateSuccess,
//           snackPosition: SnackPosition.BOTTOM,
//           colorText: AppColors.whiteColor,
//           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//           animationDuration: const Duration(milliseconds: 500),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//       } else {
//         AppLoader.hide();
//         Get.snackbar(
//           ErrorMessages.error,
//           response.message ?? ErrorMessages.invalidEmail,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           borderRadius: 8,
//           duration: const Duration(seconds: 2),
//         );
//       }
//     }
//   } catch (e) {
//     AppLoader.hide();
//     debugPrint('error create post api ${e.toString()}');
//   }
// }

//   //━━━━━━━━━━━━━━━━ HANDLE CREATE RESPONSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   void _handleCreateResponse(dynamic result, VoidCallback onSuccess) {
//     try {
//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         onSuccess();
//         Get.snackbar(
//           "Success",
//           "Post created successfully",
//           colorText: Colors.white,
//           backgroundColor: Colors.green.shade600,
//         );
//       } else {
//         _toast(response.message ?? "Failed to create post");
//       }
//     } catch (e) {
//       print("Error parsing create response: $e");
//       _toast("Failed to create post. Please try again.");
//     }
//   }

//   //━━━━━━━━━━━━━━━━ UPDATE POST API ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> updatePost(String postId) async {
//     if (!_validatePost()) return;

//     AppLoader.show();

//     try {
//       List<String> newImagePaths = images.map((e) => e.path).toList();
//       String? newVideoPath = video.value?.path;

//       // Build body
//       Map<String, dynamic> body = {
//         "id": postId,
//         ApiParam.userId: StorageHelper().getUserId.toString(),
//         ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//         ApiParam.location: locationController.text.trim(),
//         ApiParam.caption: captionController.text.trim(),
//       };

//       // Add existing images that should be kept
//       if (imagesFromServer.isNotEmpty) {
//         body["keep_images[]"] = imagesFromServer;
//       }

//       // Handle video - check if we're on video tab
//       if (tabIndex.value == 1) {
//         if (newVideoPath != null) {
//           // User picked new video
//           body['keep_video'] = 'false'; // Replace old video

//           // Make separate call for video update
//           var result = await ApiManager.callPostWithFormData(
//             body: body,
//             endPoint: ApiUtils.updatePost,
//             fileKey: "video",
//             filePaths: [newVideoPath],
//           );

//           AppLoader.hide();
//           _handleUpdateResponse(result);
//           return;
//         } else if (serverVideoUrl.value != null &&
//             serverVideoUrl.value!.isNotEmpty) {
//           // Keep existing video
//           body['keep_video'] = serverVideoUrl.value!;
//         } else {
//           // No video (user removed it)
//           body['keep_video'] = 'false';
//         }
//       }

//       // For images or posts without new video
//       if (newImagePaths.isNotEmpty) {
//         // Try different file key names for update
//         try {
//           // First try with "image[]"
//           var result = await ApiManager.callPostWithFormData(
//             body: body,
//             endPoint: ApiUtils.updatePost,
//             fileKey: "image[]",
//             filePaths: newImagePaths,
//           );

//           AppLoader.hide();
//           _handleUpdateResponse(result);
//         } catch (e) {
//           // If that fails, try with "images[]"
//           print("image[] failed, trying images[]: $e");
//           AppLoader.show();
//           try {
//             var result = await ApiManager.callPostWithFormData(
//               body: body,
//               endPoint: ApiUtils.updatePost,
//               fileKey: "images[]",
//               filePaths: newImagePaths,
//             );

//             AppLoader.hide();
//             _handleUpdateResponse(result);
//           } catch (e2) {
//             // If both fail, try with "image" (without brackets)
//             print("images[] failed, trying image: $e2");
//             AppLoader.show();
//             var result = await ApiManager.callPostWithFormData(
//               body: body,
//               endPoint: ApiUtils.updatePost,
//               fileKey: "image",
//               filePaths: newImagePaths,
//             );

//             AppLoader.hide();
//             _handleUpdateResponse(result);
//           }
//         }
//       } else {
//         // No new images, just update metadata
//         var result = await ApiManager.callPostWithFormData(
//           body: body,
//           endPoint: ApiUtils.updatePost,
//         );

//         AppLoader.hide();
//         _handleUpdateResponse(result);
//       }
//     } catch (e) {
//       AppLoader.hide();
//       print("Update post error: $e");
//       _toast("Error updating post: $e");
//     }
//   }

//   //━━━━━━━━━━━━━━━━ HANDLE UPDATE RESPONSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   void _handleUpdateResponse(dynamic result) {
//     try {
//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         Get.snackbar(
//           "Success",
//           "Post updated successfully",
//           colorText: Colors.white,
//           backgroundColor: Colors.green.shade600,
//         );
//         Get.back(result: true); // Return success to trigger refresh
//       } else {
//         _toast(response.message ?? "Failed to update post");
//       }
//     } catch (e) {
//       print("Error parsing update response: $e");
//       _toast("Failed to update post. Please try again.");
//     }
//   }

//   //━━━━━━━━━━━━━━━━ VALIDATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   bool _validatePost() {
//     // Clear any existing error messages
//     Get.closeCurrentSnackbar();

//     // Check caption
//     if (captionController.text.trim().isEmpty) {
//       _toast("Please write a caption");
//       return false;
//     }

//     // Check age suitability
//     if (contentAgeSuitabilityId.value <= 0) {
//       _toast("Please select content age type");
//       return false;
//     }

//     // Check content based on tab
//     if (tabIndex.value == 0) {
//       // Images tab - check if we have any images
//       if (images.isEmpty && imagesFromServer.isEmpty) {
//         _toast("Please upload at least one image");
//         return false;
//       }
//     } else {
//       // Video tab - check if we have any video
//       if (video.value == null && serverVideoUrl.value == null) {
//         _toast("Please upload a video");
//         return false;
//       }
//     }

//     return true;
//   }

//   //━━━━━━━━━━━━ AGE DROPDOWN SELECTION ━━━━━━━━━━━━//

//   void setAge(String? value) {
//     if (value == null) return;

//     contentAgeSuitability.value = value;

//     final match = contentAgeResponse.value.firstWhere(
//       (e) => e?.ageLabel == value,
//       orElse: () => null,
//     );

//     contentAgeSuitabilityId.value = match?.id ?? 0;
//     debugPrint("Age selected → $value (ID: ${contentAgeSuitabilityId.value})");
//   }

//   //━━━━━━━━━━━━ SET EDIT DATA ━━━━━━━━━━━━//

//   void setEditData(Posts post) async {
//     // Set text fields
//     captionController.text = post.caption ?? "";
//     locationController.text = post.location ?? "";

//     // Set images from server
//     if (post.images != null && post.images!.isNotEmpty) {
//       imagesFromServer.value = post.images!;
//     }

//     // Set video from server
//     if (post.video != null && post.video!.isNotEmpty) {
//       serverVideoUrl.value = post.video!;
//       // If we're on video tab, initialize the player
//       if (tabIndex.value == 1) {
//         await initializeVideoPlayerFromUrl(post.video!);
//       }
//     }

//     // Set age suitability
//     if (post.ageSuitability != null) {
//       contentAgeSuitabilityId.value = int.tryParse(post.ageSuitability!) ?? 0;

//       // Find matching age label
//       final match = contentAgeResponse.value.firstWhere(
//         (e) => e?.id.toString() == post.ageSuitability,
//         orElse: () => null,
//       );

//       if (match != null) {
//         contentAgeSuitability.value = match.ageLabel ?? "";
//       }
//     }
//   }

//   //━━━━━━━━━━━━ RESET WHEN EXIT SCREEN ━━━━━━━━━━━━//

//   void clearData() {
//     images.clear();
//     imagesFromServer.clear();
//     video.value = null;
//     serverVideoUrl.value = null;
//     captionController.clear();
//     locationController.clear();
//     contentAgeSuitability.value = '';
//     contentAgeSuitabilityId.value = 0;
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//     tabIndex.value = 0; // Reset to images tab
//     update(['video_player']);
//   }

//   void _toast(String msg) {
//     Get.snackbar(
//       "Error",
//       msg,
//       colorText: Colors.white,
//       backgroundColor: Colors.red.shade600,
//       margin: EdgeInsets.all(12),
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   //━━━━━━━━━━━━━━━━ CLEAN-UP ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   @override
//   void onClose() {
//     clearData();
//     super.onClose();
//   }
// }

//////////////////////------------------------------------
///
///

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
// import 'package:video_player/video_player.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/api_helpers/api_manager.dart';
// import 'package:the_friendz_zone/utils/app_loader.dart';
// import 'package:the_friendz_zone/models/verify_otp_response.dart';
// import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
// import '../../config/app_config.dart';

// class CreatePostController extends GetxController {
//   /// Tabs → 0 = images | 1 = video
//   final RxInt tabIndex = 0.obs;

//   /// Newly picked images
//   final RxList<File> images = <File>[].obs;

//   /// Existing (old) images from server - for edit
//   final RxList<String> imagesFromServer = <String>[].obs;

//   /// Selected video file
//   final Rx<File?> video = Rx<File?>(null);
//   Rx<String?> serverVideoUrl = Rx<String?>(null); // For edit mode

//   VideoPlayerController? videoPlayerController;
//   Future<void>? videoPlayerFuture;

//   final picker = ImagePicker();

//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController captionController = TextEditingController();

//   /// Age dropdown
//   Rx<String> contentAgeSuitability = ''.obs;
//   Rx<int> contentAgeSuitabilityId = 0.obs;

//   /// Backend response of age suitability list
//   RxList<ContentAgeData?> contentAgeResponse = <ContentAgeData>[].obs;

//   //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   @override
//   void onInit() {
//     _getAgeContentList();
//     super.onInit();
//   }

//   //━━━━━━━━━━━━━━━━ IMAGE PICKER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> pickImages() async {
//     final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 75);
//     if (picked != null) {
//       images.addAll(picked.map((e) => File(e.path)));
//     }
//   }

//   void removeImageAt(int index) => images.removeAt(index);

//   /// Remove saved server image when editing
//   void removeServerImage(int index) => imagesFromServer.removeAt(index);

//   //━━━━━━━━━━━━━━━━ VIDEO HANDLING ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> pickVideo() async {
//     final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
//     if (picked != null) {
//       video.value = File(picked.path);
//       serverVideoUrl.value = null; // Clear server video when picking new one
//       await initializeVideoPlayer(video.value!);
//       update(['video_player']);
//     }
//   }

//   Future<void> initializeVideoPlayer(File file) async {
//     videoPlayerController?.dispose();
//     videoPlayerController = VideoPlayerController.file(file);
//     videoPlayerFuture = videoPlayerController!.initialize();
//     await videoPlayerFuture;
//     videoPlayerController!.setLooping(true);
//     update(['video_player']);
//   }

//   Future<void> initializeVideoPlayerFromUrl(String url) async {
//     try {
//       videoPlayerController?.dispose();
//       videoPlayerController = VideoPlayerController.network(url);
//       videoPlayerFuture = videoPlayerController!.initialize();
//       await videoPlayerFuture;
//       videoPlayerController!.setLooping(true);
//       update(['video_player']);
//     } catch (e) {
//       print("Error initializing video from URL: $e");
//     }
//   }

//   void toggleVideoPlayback() {
//     if (videoPlayerController == null) return;
//     if (videoPlayerController!.value.isPlaying) {
//       videoPlayerController!.pause();
//     } else {
//       videoPlayerController!.play();
//     }
//     update(['video_player']);
//   }

//   void removeVideo() {
//     video.value = null;
//     serverVideoUrl.value = null;
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//     update(['video_player']);
//   }

//   //━━━━━━━━━━━━━━━━ AGE LIST GET ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> _getAgeContentList() async {
//     try {
//       var result = await ApiManager.callGet(
//         queryParams: {ApiParam.request: ApiUtils.getAgeContentList},
//       );

//       ContentAgeResponse parsed = ContentAgeResponse.fromJson(result);
//       if (parsed.status == AppStrings.apiSuccess) {
//         contentAgeResponse.value = parsed.data ?? [];
//         contentAgeResponse.refresh();
//       }
//     } catch (e) {
//       debugPrint("Age list error $e");
//     }
//   }

//   //━━━━━━━━━━━━━━━━ CREATE POST API ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> createPost(VoidCallback onSuccess, String communityId) async {
//     try {
//       if (locationController.text.trim().isEmpty) {
//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.enterLoc,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//         return;
//       }
//       if (captionController.text.trim().isEmpty) {
//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.enterCaption,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//         return;
//       }
//       if (contentAgeSuitabilityId.value < 0) {
//         Get.snackbar(
//           AppStrings.error,
//           ErrorMessages.selectAge,
//           colorText: AppColors.whiteColor,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         );
//         return;
//       }

//       AppLoader.show();
//       int userId = StorageHelper().getUserId;

//       // for uploading image post only
//       if (tabIndex.value == 0) {
//         if (images.value.isEmpty) {
//           AppLoader.hide();
//           Get.snackbar(
//             AppStrings.error,
//             ErrorMessages.uploadImage,
//             colorText: AppColors.whiteColor,
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           );
//           return;
//         }
        
//         List<String> filePaths = [];
//         images.value.map((e) => filePaths.add(e.path)).toList();
        
//         var result = await ApiManager.callPostWithFormData(
//             body: {
//               ApiParam.userId: "$userId",
//               ApiParam.communityId: communityId,
//               ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//               ApiParam.location: locationController.text.trim(),
//               ApiParam.caption: captionController.text.trim(),
//             },
//             endPoint: communityId.isEmpty ? ApiUtils.createPost : ApiUtils.createCommunityPost,
//             fileKey: communityId.isEmpty ? '${ApiParam.image}[]' : 'images[]',
//             filePaths: filePaths);

//         AppLoader.hide();
        
//         VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//         if (response.status == AppStrings.apiSuccess) {
//           Get.snackbar(
//             AppStrings.success,
//             AppStrings.postCreateSuccess,
//             snackPosition: SnackPosition.BOTTOM,
//             colorText: AppColors.whiteColor,
//             backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//             animationDuration: const Duration(milliseconds: 500),
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           );
          
//           // Call success callback after a short delay to ensure snackbar shows
//           await Future.delayed(Duration(milliseconds: 300));
//           onSuccess();
//         } else {
//           Get.snackbar(
//             ErrorMessages.error,
//             response.message ?? ErrorMessages.invalidEmail,
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//             colorText: AppColors.whiteColor,
//             margin: const EdgeInsets.all(15),
//             borderRadius: 8,
//             duration: const Duration(seconds: 2),
//           );
//         }
//       }
//       // for uploading video post only
//       else {
//         if (video.value == null) {
//           AppLoader.hide();
//           Get.snackbar(
//             AppStrings.error,
//             ErrorMessages.uploadImage,
//             colorText: AppColors.whiteColor,
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           );
//           return;
//         }
        
//         List<String> filePaths = [];
//         if (video.value != null) {
//           filePaths.add(video.value!.path);
//         }

//         var result = await ApiManager.callPostWithFormData(
//             body: {
//               ApiParam.userId: "$userId",
//               ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//               ApiParam.location: locationController.text.trim(),
//               ApiParam.caption: captionController.text.trim(),
//             },
//             endPoint: ApiUtils.createPost,
//             fileKey: ApiParam.video,
//             filePaths: filePaths,
//             multipartFile: {
//               '${ApiParam.image}[]': null,
//             });
            
//         AppLoader.hide();
        
//         VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//         if (response.status == AppStrings.apiSuccess) {
//           Get.snackbar(
//             AppStrings.success,
//             AppStrings.postCreateSuccess,
//             snackPosition: SnackPosition.BOTTOM,
//             colorText: AppColors.whiteColor,
//             backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//             animationDuration: const Duration(milliseconds: 500),
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           );
          
//           // Call success callback after a short delay
//           await Future.delayed(Duration(milliseconds: 300));
//           onSuccess();
//         } else {
//           Get.snackbar(
//             ErrorMessages.error,
//             response.message ?? ErrorMessages.invalidEmail,
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//             colorText: AppColors.whiteColor,
//             margin: const EdgeInsets.all(15),
//             borderRadius: 8,
//             duration: const Duration(seconds: 2),
//           );
//         }
//       }
//     } catch (e) {
//       AppLoader.hide();
//       debugPrint('error create post api ${e.toString()}');
//       Get.snackbar(
//         "Error",
//         "Something went wrong. Please try again.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//       );
//     }
//   }

//   //━━━━━━━━━━━━━━━━ UPDATE POST API ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> updatePost(String postId, VoidCallback onSuccess) async {
//     if (!_validatePost()) return;

//     AppLoader.show();

//     try {
//       List<String> newImagePaths = images.map((e) => e.path).toList();
//       String? newVideoPath = video.value?.path;

//       // Build body
//       Map<String, dynamic> body = {
//         "id": postId,
//         ApiParam.userId: StorageHelper().getUserId.toString(),
//         ApiParam.ageSuitability: contentAgeSuitabilityId.value,
//         ApiParam.location: locationController.text.trim(),
//         ApiParam.caption: captionController.text.trim(),
//       };

//       // FIXED: Only add existing images that should be kept (not removed ones)
//       // This ensures removed images are not sent to the backend
//       if (imagesFromServer.isNotEmpty) {
//         // Convert to List<String> explicitly
//         List<String> keepImages = List<String>.from(imagesFromServer);
//         for (int i = 0; i < keepImages.length; i++) {
//           body["keep_images[$i]"] = keepImages[i];
//         }
//       }

//       // Handle video - check if we're on video tab
//       if (tabIndex.value == 1) {
//         if (newVideoPath != null) {
//           // User picked new video - replace old video
//           body['keep_video'] = 'false';

//           var result = await ApiManager.callPostWithFormData(
//             body: body,
//             endPoint: ApiUtils.updatePost,
//             fileKey: "video",
//             filePaths: [newVideoPath],
//           );

//           AppLoader.hide();
//           await _handleUpdateResponse(result, onSuccess);
//           return;
//         } else if (serverVideoUrl.value != null &&
//             serverVideoUrl.value!.isNotEmpty) {
//           // Keep existing video
//           body['keep_video'] = serverVideoUrl.value!;
//         } else {
//           // No video (user removed it)
//           body['keep_video'] = 'false';
//         }
//       }

//       // For images or posts without new video
//       if (newImagePaths.isNotEmpty) {
//         var result = await ApiManager.callPostWithFormData(
//           body: body,
//           endPoint: ApiUtils.updatePost,
//           fileKey: "image[]",
//           filePaths: newImagePaths,
//         );

//         AppLoader.hide();
//         await _handleUpdateResponse(result, onSuccess);
//       } else {
//         // No new images, just update metadata
//         var result = await ApiManager.callPostWithFormData(
//           body: body,
//           endPoint: ApiUtils.updatePost,
//         );

//         AppLoader.hide();
//         await _handleUpdateResponse(result, onSuccess);
//       }
//     } catch (e) {
//       AppLoader.hide();
//       print("Update post error: $e");
//       Get.snackbar(
//         "Error",
//         "Error updating post: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//       );
//     }
//   }

//   //━━━━━━━━━━━━━━━━ HANDLE UPDATE RESPONSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   Future<void> _handleUpdateResponse(dynamic result, VoidCallback onSuccess) async {
//     try {
//       VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
//       if (response.status == AppStrings.apiSuccess) {
//         Get.snackbar(
//           "Success",
//           "Post updated successfully",
//           colorText: Colors.white,
//           backgroundColor: Colors.green.shade600,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(15),
//         );
        
//         // Wait a bit for snackbar to show
//         await Future.delayed(Duration(milliseconds: 300));
        
//         // Call success callback to trigger navigation
//         onSuccess();
//       } else {
//         Get.snackbar(
//           "Error",
//           response.message ?? "Failed to update post",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//         );
//       }
//     } catch (e) {
//       print("Error parsing update response: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to update post. Please try again.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//       );
//     }
//   }

//   //━━━━━━━━━━━━━━━━ VALIDATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   bool _validatePost() {
//     Get.closeCurrentSnackbar();

//     if (captionController.text.trim().isEmpty) {
//       _toast("Please write a caption");
//       return false;
//     }

//     if (contentAgeSuitabilityId.value <= 0) {
//       _toast("Please select content age type");
//       return false;
//     }

//     if (tabIndex.value == 0) {
//       if (images.isEmpty && imagesFromServer.isEmpty) {
//         _toast("Please upload at least one image");
//         return false;
//       }
//     } else {
//       if (video.value == null && 
//           (serverVideoUrl.value == null || serverVideoUrl.value!.isEmpty)) {
//         _toast("Please upload a video");
//         return false;
//       }
//     }

//     return true;
//   }

//   //━━━━━━━━━━━━ AGE DROPDOWN SELECTION ━━━━━━━━━━━━//

//   void setAge(String? value) {
//     if (value == null) return;

//     contentAgeSuitability.value = value;

//     final match = contentAgeResponse.value.firstWhere(
//       (e) => e?.ageLabel == value,
//       orElse: () => null,
//     );

//     contentAgeSuitabilityId.value = match?.id ?? 0;
//     debugPrint("Age selected → $value (ID: ${contentAgeSuitabilityId.value})");
//   }

//   //━━━━━━━━━━━━ SET EDIT DATA ━━━━━━━━━━━━//

//   void setEditData(Posts post) async {
//     captionController.text = post.caption ?? "";
//     locationController.text = post.location ?? "";

//     if (post.images != null && post.images!.isNotEmpty) {
//       imagesFromServer.value = List<String>.from(post.images!);
//     }

//     if (post.video != null && post.video!.isNotEmpty) {
//       serverVideoUrl.value = post.video!;
//       if (tabIndex.value == 1) {
//         await initializeVideoPlayerFromUrl(post.video!);
//       }
//     }

//     if (post.ageSuitability != null) {
//       contentAgeSuitabilityId.value = int.tryParse(post.ageSuitability!) ?? 0;

//       final match = contentAgeResponse.value.firstWhere(
//         (e) => e?.id.toString() == post.ageSuitability,
//         orElse: () => null,
//       );

//       if (match != null) {
//         contentAgeSuitability.value = match.ageLabel ?? "";
//       }
//     }
//   }

//   //━━━━━━━━━━━━ RESET WHEN EXIT SCREEN ━━━━━━━━━━━━//

//   void clearData() {
//     images.clear();
//     imagesFromServer.clear();
//     video.value = null;
//     serverVideoUrl.value = null;
//     captionController.clear();
//     locationController.clear();
//     contentAgeSuitability.value = '';
//     contentAgeSuitabilityId.value = 0;
//     videoPlayerController?.dispose();
//     videoPlayerController = null;
//     videoPlayerFuture = null;
//     tabIndex.value = 0;
//     update(['video_player']);
//   }

//   void _toast(String msg) {
//     Get.snackbar(
//       "Error",
//       msg,
//       colorText: Colors.white,
//       backgroundColor: Colors.red.shade600,
//       margin: EdgeInsets.all(12),
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   //━━━━━━━━━━━━━━━━ CLEAN-UP ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

//   @override
//   void onClose() {
//     clearData();
//     super.onClose();
//   }
// }