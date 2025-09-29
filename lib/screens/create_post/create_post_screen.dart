import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/screens/create_post/model/age_content_response.dart';
import 'package:video_player/video_player.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../../widgets/full_screen_image_viewer.dart';
import '../home/home_screen.dart';
import 'create_post_controller.dart';
import 'widgets/create_post_tab_button.dart';

class CreatePostScreen extends StatelessWidget {
  final String comingFromScreen;
  final String communityId;

  CreatePostScreen({
    Key? key,
    required this.comingFromScreen,
    required this.communityId,
  }) : super(key: key);

  final CreatePostController controller = Get.put(CreatePostController());

  @override
  Widget build(BuildContext context) {
    final BottomNavController navController = Get.find<BottomNavController>();

    return PopScope(
      canPop: comingFromScreen != 'community_feed' ? false : true,
      onPopInvoked: (didPop) {
        controller.clearData();

        if (comingFromScreen != 'community_feed') {
          navController.changeTabIndex(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top AppBar
              Padding(
                padding: const EdgeInsets.only(
                  top: 14,
                  left: 8,
                  right: 8,
                  bottom: 6,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.clearData();

                        if (comingFromScreen == 'community_feed') {
                          Get.back();
                        } else {
                          navController.changeTabIndex(0);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          AppImages.backArrow,
                          height: 11,
                          width: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.createNewPostTitle,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontSize: FontDimen.dimen20,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 19),
                  ],
                ),
              ),
              SizedBox(height: 3),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tabs
                      SizedBox(
                        height: 32,
                        child: Obx(
                          () => Row(
                            children: [
                              Expanded(
                                child: CreatePostTabButton(
                                  label: AppStrings.addImagesTab,
                                  selected: controller.tabIndex.value == 0,
                                  onTap: () => controller.tabIndex.value = 0,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: CreatePostTabButton(
                                  label: AppStrings.addVideoTab,
                                  selected: controller.tabIndex.value == 1,
                                  onTap: () => controller.tabIndex.value = 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // IMAGE/VIDEO Picker Area with dotted border!
                      Obx(() => IndexedStack(
                            index: controller.tabIndex.value,
                            children: [
                              // Images Tab
                              DottedBorder(
                                color: AppColors.bgColor.withOpacity(1),
                                strokeWidth: 2,
                                borderType: BorderType.RRect,
                                dashPattern: const [3, 3],
                                radius: const Radius.circular(15),
                                child: Container(
                                  width: double.infinity,
                                  height: 185,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: controller.images.isEmpty
                                      ? GestureDetector(
                                          onTap: controller.pickImages,
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.cardBgColor,
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              child: Image.asset(
                                                AppImages.profilePicIcon,
                                                height: 40,
                                                width: 40,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          key: const PageStorageKey(
                                            'images_list',
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.images.length,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                          separatorBuilder: (_, __) =>
                                              SizedBox(width: 10),
                                          itemBuilder: (ctx, i) => Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          FullScreenImageViewer(
                                                        images: controller
                                                            .images
                                                            .map((f) => f.path)
                                                            .toList(),
                                                        initialIndex: i,
                                                        heroTag: controller
                                                            .images[i].path,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Hero(
                                                  tag:
                                                      controller.images[i].path,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: Image.file(
                                                      controller.images[i],
                                                      key: ValueKey(controller
                                                          .images[i].path),
                                                      width: 150,
                                                      fit: BoxFit.cover,
                                                      gaplessPlayback: true,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                right: 2,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .removeImageAt(i),
                                                  child: CircleAvatar(
                                                    radius: 11,
                                                    backgroundColor:
                                                        Colors.black45,
                                                    child: Icon(Icons.close,
                                                        color: Colors.white,
                                                        size: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              // Video Tab
                              DottedBorder(
                                color: AppColors.bgColor.withOpacity(1),
                                strokeWidth: 2,
                                borderType: BorderType.RRect,
                                dashPattern: const [3, 3],
                                radius: const Radius.circular(15),
                                child: Container(
                                  width: double.infinity,
                                  height: 185,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: controller.video.value == null
                                      ? GestureDetector(
                                          onTap: controller.pickVideo,
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.cardBgColor,
                                              ),
                                              padding: const EdgeInsets.all(14),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.1),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(9.0),
                                                  child: Image.asset(
                                                    AppImages.videoIcon,
                                                    height: 24,
                                                    width: 24,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : GetBuilder<CreatePostController>(
                                          id: 'video_player',
                                          builder: (ctrl) {
                                            if (ctrl.videoPlayerFuture ==
                                                null) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            return FutureBuilder(
                                              future: ctrl.videoPlayerFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState !=
                                                    ConnectionState.done) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                                final controller =
                                                    ctrl.videoPlayerController!;
                                                final size =
                                                    controller.value.size;
                                                if (size.width == 0 ||
                                                    size.height == 0) {
                                                  return Center(
                                                      child: Text(
                                                          'Loading video...'));
                                                }
                                                final isLandscape =
                                                    size.width > size.height;
                                                return Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 185,
                                                        child: isLandscape
                                                            ? LayoutBuilder(
                                                                builder: (context,
                                                                    constraints) {
                                                                  final containerWidth =
                                                                      constraints
                                                                          .maxWidth;
                                                                  final aspectRatio =
                                                                      size.width /
                                                                          size.height;
                                                                  final videoHeight =
                                                                      containerWidth /
                                                                          aspectRatio;
                                                                  return OverflowBox(
                                                                    maxWidth:
                                                                        containerWidth,
                                                                    maxHeight:
                                                                        double
                                                                            .infinity,
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          containerWidth,
                                                                      height:
                                                                          videoHeight,
                                                                      child: VideoPlayer(
                                                                          controller),
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : Center(
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SizedBox(
                                                                    width: size
                                                                        .width,
                                                                    height: size
                                                                        .height,
                                                                    child: VideoPlayer(
                                                                        controller),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    // Play/Pause overlay
                                                    Positioned.fill(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (ctrl
                                                                .videoPlayerController!
                                                                .value
                                                                .isPlaying) {
                                                              ctrl.videoPlayerController!
                                                                  .pause();
                                                            } else {
                                                              ctrl.videoPlayerController!
                                                                  .play();
                                                            }
                                                            ctrl.update([
                                                              'video_player'
                                                            ]);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black54,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            width: 48,
                                                            height: 48,
                                                            child: Icon(
                                                              ctrl
                                                                      .videoPlayerController!
                                                                      .value
                                                                      .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow_rounded,
                                                              color: AppColors
                                                                  .whiteColor,
                                                              size: 32,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Close button
                                                    Positioned(
                                                      top: 2,
                                                      right: 2,
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            ctrl.removeVideo(),
                                                        child: CircleAvatar(
                                                          radius: 11,
                                                          backgroundColor:
                                                              Colors.black45,
                                                          child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 14),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 6),

                      // Add Images/Video Button
                      Obx(() {
                        if (controller.tabIndex.value == 0) {
                          // Images tab
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: controller.pickImages,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        AppImages.addMore,
                                        height: 22,
                                        width: 22,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        AppStrings.addMoreImages,
                                        style: TextStyle(
                                          color: AppColors.whiteColor
                                              .withOpacity(0.5),
                                          fontSize: FontDimen.dimen11,
                                          fontFamily:
                                              GoogleFonts.inter().fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Video tab
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: controller.pickVideo,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.video_call,
                                        color: AppColors.primaryColor,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        AppStrings.addVideo,
                                        style: TextStyle(
                                          color: AppColors.whiteColor
                                              .withOpacity(0.5),
                                          fontSize: FontDimen.dimen11,
                                          fontFamily:
                                              GoogleFonts.inter().fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                      const SizedBox(height: 11),

                      // Tag Location
                      Text(
                        AppStrings.tagLocation,
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontSize: FontDimen.dimen13,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 7),
                      _buildTextInput(
                        controller: controller.locationController,
                        hintText: AppStrings.addLocationHint,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 19),

                      // Age Suitability Dropdown
                      Text(
                        AppStrings.setContentAgeSuitability,
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontSize: FontDimen.dimen13,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: AppColors.textColor3.withOpacity(0.17),
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: SizedBox(
                          height: 52,
                          child: StreamBuilder(
                              stream: controller.contentAgeResponse.stream,
                              builder: (context, snapshot) {
                                if (controller
                                    .contentAgeResponse.value.isEmpty) {
                                  return Container();
                                }

                                List<String> options = [];
                                controller.contentAgeResponse.value
                                    .map((e) => options.add(e?.ageLabel ?? ''))
                                    .toList();
                                return Obx(
                                  () => DropdownButton<String>(
                                      value: controller.contentAgeSuitability
                                              .value.isNotEmpty
                                          ? controller
                                              .contentAgeSuitability.value
                                          : null,
                                      isExpanded: true,
                                      underline: SizedBox.shrink(),
                                      icon: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 9,
                                          top: 8,
                                        ),
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Image.asset(
                                            AppImages.backArrow,
                                            height: 11,
                                            width: 11,
                                          ),
                                        ),
                                      ),
                                      dropdownColor: AppColors.cardBgColor,
                                      style: TextStyle(
                                        color: AppColors.textColor3
                                            .withOpacity(0.67),
                                        fontFamily: AppFonts.appFont,
                                        fontSize: FontDimen.dimen13,
                                      ),
                                      items: options
                                          .map(
                                            (e) => DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                  color: AppColors.textColor3
                                                      .withOpacity(1),
                                                  fontSize: FontDimen.dimen13,
                                                  fontFamily:
                                                      GoogleFonts.inter()
                                                          .fontFamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        controller.contentAgeSuitability.value =
                                            val ?? AppStrings.contentAge16;

                                        if (val != null) {
                                          ContentAgeData? data = controller
                                              .contentAgeResponse.value
                                              .firstWhere(
                                                  (e) => e!.ageLabel == val);

                                          if (data != null) {
                                            controller.contentAgeSuitabilityId
                                                .value = data.id ?? 0;
                                            debugPrint(
                                                'content age suit ${controller.contentAgeSuitabilityId.value}');
                                          }
                                        }
                                      }),
                                );
                              }),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Caption
                      Text(
                        AppStrings.caption,
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontSize: FontDimen.dimen13,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextInput(
                        controller: controller.captionController,
                        hintText: AppStrings.addCaptionHint,
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        maxLength: 300,
                        showCharCount: true,
                      ),
                      const SizedBox(height: 33),
                    ],
                  ),
                ),
              ),

              // Create Post Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColorShade,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // on success function used for navigation to bottom tab or back depending upon from where it is coming from
                        controller.createPost(() {
                          controller.clearData();

                          if (comingFromScreen == 'community_feed') {
                            Get.back();
                          } else {
                            navController.changeTabIndex(0);
                          }
                        } , communityId.toString());
                        // validation and upload logic here!
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.createPostBtn,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.92),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines,
    int? maxLength,
    bool showCharCount = false,
    Widget? suffixIcon,
    bool readOnly = false,
    Function()? onTap,
    void Function(String)? onChanged,
  }) {
    return Stack(
      children: [
        Center(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(
              color: AppColors.textColor3.withOpacity(1),
              fontSize: FontDimen.dimen14,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textColor2.withOpacity(0.3),
                fontSize: FontDimen.dimen13,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
              contentPadding: showCharCount && maxLength != null
                  ? const EdgeInsets.fromLTRB(16, 16, 16, 36)
                  : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.textColor3.withOpacity(0.17),
                  width: 1.1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.1,
                ),
              ),
              suffixIcon: suffixIcon,
              counterText: "",
            ),
          ),
        ),
        if (showCharCount && maxLength != null)
          Positioned(
            right: 18,
            bottom: 12,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return Text(
                  '${value.text.characters.length}/$maxLength',
                  style: TextStyle(
                    color: AppColors.textColor2.withOpacity(0.5),
                    fontSize: FontDimen.dimen12,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
