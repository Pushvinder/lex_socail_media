
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
import 'package:video_player/video_player.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../config/app_config.dart';

class CreatePostController extends GetxController {
  /// Tabs → 0 = images | 1 = video
  final RxInt tabIndex = 0.obs;

  /// Newly picked images
  final RxList<File> images = <File>[].obs;

  /// Existing (old) images from server - for edit
  final RxList<String> imagesFromServer = <String>[].obs;

  /// Selected video file
  final Rx<File?> video = Rx<File?>(null);
  Rx<String?> serverVideoUrl = Rx<String?>(null); // For edit mode

  VideoPlayerController? videoPlayerController;
  Future<void>? videoPlayerFuture;

  final picker = ImagePicker();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  /// Age dropdown
  Rx<String> contentAgeSuitability = ''.obs;
  Rx<int> contentAgeSuitabilityId = 0.obs;

  /// Backend response of age suitability list
  RxList<ContentAgeData?> contentAgeResponse = <ContentAgeData>[].obs;

  //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  @override
  void onInit() {
    _getAgeContentList();
    super.onInit();
  }

  //━━━━━━━━━━━━━━━━ IMAGE PICKER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<void> pickImages() async {
    final List<XFile>? picked = await picker.pickMultiImage(imageQuality: 75);
    if (picked != null) {
      images.addAll(picked.map((e) => File(e.path)));
    }
  }

  void removeImageAt(int index) => images.removeAt(index);

  /// Remove saved server image when editing
  void removeServerImage(int index) => imagesFromServer.removeAt(index);

  //━━━━━━━━━━━━━━━━ VIDEO HANDLING ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<void> pickVideo() async {
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      video.value = File(picked.path);
      serverVideoUrl.value = null; // Clear server video when picking new one
      await initializeVideoPlayer(video.value!);
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

  Future<void> initializeVideoPlayerFromUrl(String url) async {
    try {
      videoPlayerController?.dispose();
      videoPlayerController = VideoPlayerController.network(url);
      videoPlayerFuture = videoPlayerController!.initialize();
      await videoPlayerFuture;
      videoPlayerController!.setLooping(true);
      update(['video_player']);
    } catch (e) {
      debugPrint("Error initializing video from URL: $e");
    }
  }

  void toggleVideoPlayback() {
    if (videoPlayerController == null) return;
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
    update(['video_player']);
  }

  void removeVideo() {
    video.value = null;
    serverVideoUrl.value = null;
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPlayerFuture = null;
    update(['video_player']);
  }

  //━━━━━━━━━━━━━━━━ AGE LIST GET ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<void> _getAgeContentList() async {
    try {
      var result = await ApiManager.callGet(
        queryParams: {ApiParam.request: ApiUtils.getAgeContentList},
      );

      ContentAgeResponse parsed = ContentAgeResponse.fromJson(result);
      if (parsed.status == AppStrings.apiSuccess) {
        contentAgeResponse.value = parsed.data ?? [];
        contentAgeResponse.refresh();
      }
    } catch (e) {
      debugPrint("Age list error $e");
    }
  }

  //━━━━━━━━━━━━━━━━ DOWNLOAD IMAGE HELPER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<File?> downloadImageToTemp(String imageUrl) async {
    try {
      debugPrint("📥 Downloading: $imageUrl");
      
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = imageUrl.split('/').last;
        final tempFile = File('${tempDir.path}/$fileName');
        
        await tempFile.writeAsBytes(response.bodyBytes);
        debugPrint("✅ Downloaded to: ${tempFile.path}");
        return tempFile;
      } else {
        debugPrint("❌ Failed to download: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error downloading image: $e");
      return null;
    }
  }

  Future<File?> downloadVideoToTemp(String videoUrl) async {
    try {
      debugPrint("📥 Downloading video: $videoUrl");
      
      final response = await http.get(Uri.parse(videoUrl));
      
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = videoUrl.split('/').last;
        final tempFile = File('${tempDir.path}/$fileName');
        
        await tempFile.writeAsBytes(response.bodyBytes);
        debugPrint("✅ Video downloaded to: ${tempFile.path}");
        return tempFile;
      } else {
        debugPrint("❌ Failed to download video: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error downloading video: $e");
      return null;
    }
  }

  //━━━━━━━━━━━━━━━━ CREATE POST API ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<void> createPost(VoidCallback onSuccess, String communityId) async {
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

      // for uploading image post only
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

        AppLoader.hide();
        
        VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
        if (response.status == AppStrings.apiSuccess) {
          // Clear data BEFORE showing snackbar
          clearData();
          
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
          
          // Short delay then navigate
          await Future.delayed(Duration(milliseconds: 300));
          onSuccess();
        } else {
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
            
        AppLoader.hide();
        
        VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
        if (response.status == AppStrings.apiSuccess) {
          // Clear data BEFORE showing snackbar
          clearData();
          
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
          
          // Short delay then navigate
          await Future.delayed(Duration(milliseconds: 300));
          onSuccess();
        } else {
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
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        colorText: AppColors.whiteColor,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  //━━━━━━━━━━━━━━━━ UPDATE POST API ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<void> updatePost(String postId, VoidCallback onSuccess) async {
    // ✅ VALIDATE FIRST - BEFORE showing loader
    if (!_validatePost()) {
      return; // Stop here if validation fails
    }

    AppLoader.show();

    try {
      debugPrint("━━━━━━━━━━━━━━━ UPDATE POST DEBUG ━━━━━━━━━━━━━━━");
      debugPrint("📦 Post ID: $postId");
      debugPrint("📊 Tab Index: ${tabIndex.value} (0=Images, 1=Video)");

      Map<String, dynamic> body = {
        "id": postId,
        ApiParam.userId: StorageHelper().getUserId.toString(),
        ApiParam.ageSuitability: contentAgeSuitabilityId.value,
        ApiParam.location: locationController.text.trim(),
        ApiParam.caption: captionController.text.trim(),
      };

      // ═══════════════ IMAGE TAB ═══════════════
      if (tabIndex.value == 0) {
        debugPrint("🖼️  IMAGE UPDATE MODE");
        debugPrint("📌 Existing server images: ${imagesFromServer.length}");
        debugPrint("🆕 New picked images: ${images.length}");

        // STEP 1: Download all server images to temp files
        List<File> allImageFiles = [];
        
        if (imagesFromServer.isNotEmpty) {
          debugPrint("📥 Downloading ${imagesFromServer.length} server images...");
          for (String imageUrl in imagesFromServer) {
            File? tempFile = await downloadImageToTemp(imageUrl);
            if (tempFile != null) {
              allImageFiles.add(tempFile);
            }
          }
          debugPrint("✅ Downloaded ${allImageFiles.length} server images");
        }

        // STEP 2: Add all newly picked images
        allImageFiles.addAll(images);
        debugPrint("📤 Total images to upload: ${allImageFiles.length}");

        // STEP 3: Upload ALL images as image[]
        List<String> allImagePaths = allImageFiles.map((f) => f.path).toList();
        
        debugPrint("📋 Sending ${allImagePaths.length} images to server");
        
        var result = await ApiManager.callPostWithFormData(
          body: body,
          endPoint: ApiUtils.updatePost,
          fileKey: '${ApiParam.image}[]',
          filePaths: allImagePaths,
        );

        AppLoader.hide();
        await _handleUpdateResponse(result, onSuccess);
      }
      // ═══════════════ VIDEO TAB ═══════════════
      else {
        debugPrint("🎬 VIDEO UPDATE MODE");
        
        File? videoFile;
        
        // Check if user picked a NEW video
        if (video.value != null) {
          debugPrint("✅ Using newly picked video");
          videoFile = video.value!;
        }
        // Check if we should keep the EXISTING video
        else if (serverVideoUrl.value != null && serverVideoUrl.value!.isNotEmpty) {
          debugPrint("📥 Downloading existing server video...");
          videoFile = await downloadVideoToTemp(serverVideoUrl.value!);
          if (videoFile != null) {
            debugPrint("✅ Downloaded server video");
          }
        }

        debugPrint("📤 Uploading video to server");
        
        var result = await ApiManager.callPostWithFormData(
          body: body,
          endPoint: ApiUtils.updatePost,
          fileKey: ApiParam.video,
          filePaths: [videoFile!.path],
        );

        AppLoader.hide();
        await _handleUpdateResponse(result, onSuccess);
      }

      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    } catch (e) {
      AppLoader.hide();
      debugPrint("❌ Update post error: $e");
      Get.snackbar(
        "Error",
        "Error updating post: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        colorText: AppColors.whiteColor,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  //━━━━━━━━━━━━━━━━ HANDLE UPDATE RESPONSE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  Future<void> _handleUpdateResponse(dynamic result, VoidCallback onSuccess) async {
    try {
      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
      if (response.status == AppStrings.apiSuccess) {
        Get.snackbar(
          "Success",
          "Post updated successfully",
          colorText: Colors.white,
          backgroundColor: Colors.green.shade600,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 2),
        );
        
        await Future.delayed(Duration(milliseconds: 400));
        clearData();
        onSuccess();
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Failed to update post",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          colorText: AppColors.whiteColor,
          margin: const EdgeInsets.all(15),
        );
      }
    } catch (e) {
      debugPrint("❌ Error parsing update response: $e");
      Get.snackbar(
        "Error",
        "Failed to update post. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
        colorText: AppColors.whiteColor,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  //━━━━━━━━━━━━━━━━ VALIDATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  bool _validatePost() {
    Get.closeCurrentSnackbar();

    if (captionController.text.trim().isEmpty) {
      _toast("Please write a caption");
      return false;
    }

    if (contentAgeSuitabilityId.value <= 0) {
      _toast("Please select content age type");
      return false;
    }

    // Check if at least ONE media exists (image OR video)
    bool hasImages = images.isNotEmpty || imagesFromServer.isNotEmpty;
    bool hasVideo = video.value != null || 
                    (serverVideoUrl.value != null && serverVideoUrl.value!.isNotEmpty);
    
    if (!hasImages && !hasVideo) {
      _toast("Please upload at least one image or video");
      return false;
    }

    return true;
  }

  //━━━━━━━━━━━━ AGE DROPDOWN SELECTION ━━━━━━━━━━━━//

  void setAge(String? value) {
    if (value == null) return;

    contentAgeSuitability.value = value;

    try {
      final match = contentAgeResponse.value.firstWhere(
        (e) => e?.ageLabel == value,
      );
      contentAgeSuitabilityId.value = match?.id ?? 0;
      debugPrint("Age selected → $value (ID: ${contentAgeSuitabilityId.value})");
    } catch (e) {
      debugPrint("⚠️ Age not found in list: $value");
      contentAgeSuitabilityId.value = 0;
    }
  }

  //━━━━━━━━━━━━ SET EDIT DATA WITH AUTO AGE SELECTION ━━━━━━━━━━━━//

  Future<void> setEditDataWithAge(Posts post) async {
    captionController.text = post.caption ?? "";
    locationController.text = post.location ?? "";

    if (post.images != null && post.images!.isNotEmpty) {
      imagesFromServer.value = List<String>.from(post.images!);
      tabIndex.value = 0; // Switch to images tab
    }

    if (post.video != null && post.video!.isNotEmpty) {
      serverVideoUrl.value = post.video!;
      tabIndex.value = 1; // Switch to video tab
      await initializeVideoPlayerFromUrl(post.video!);
    }

    // AUTO-SELECT age suitability
    if (post.ageSuitability != null && post.ageSuitability!.isNotEmpty) {
      int attempts = 0;
      while (contentAgeResponse.isEmpty && attempts < 20) {
        await Future.delayed(Duration(milliseconds: 100));
        attempts++;
      }

      if (contentAgeResponse.isNotEmpty) {
        try {
          ContentAgeData? matchedAge = contentAgeResponse.firstWhere(
            (e) => e?.id.toString() == post.ageSuitability,
          );

          if (matchedAge != null) {
            contentAgeSuitabilityId.value = matchedAge.id ?? 0;
            contentAgeSuitability.value = matchedAge.ageLabel ?? "";
            debugPrint("✅ Auto-selected age: ${matchedAge.ageLabel} (ID: ${matchedAge.id})");
          }
        } catch (e) {
          // No match found, try parsing as int
          debugPrint("⚠️ Age not found in list: ${post.ageSuitability}");
          int? ageId = int.tryParse(post.ageSuitability!);
          if (ageId != null) {
            contentAgeSuitabilityId.value = ageId;
            debugPrint("⚠️ Age ID set but label not found: $ageId");
          }
        }
      } else {
        debugPrint("⚠️ Age response not loaded yet");
      }
    }
  }

  //━━━━━━━━━━━━ RESET WHEN EXIT SCREEN ━━━━━━━━━━━━//

  void clearData() {
    images.clear();
    imagesFromServer.clear();
    video.value = null;
    serverVideoUrl.value = null;
    captionController.clear();
    locationController.clear();
    contentAgeSuitability.value = '';
    contentAgeSuitabilityId.value = 0;
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPlayerFuture = null;
    tabIndex.value = 0;
    update(['video_player']);
  }

  void _toast(String msg) {
    Get.snackbar(
      "Error",
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade600,
      margin: EdgeInsets.all(12),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //━━━━━━━━━━━━━━━━ CLEAN-UP ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━//

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}