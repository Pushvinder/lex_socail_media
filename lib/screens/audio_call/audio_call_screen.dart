//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../config/app_colors.dart';
// import '../../utils/app_dimen.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_img.dart';
// import '../../utils/app_strings.dart';
// import 'audio_call_controller.dart';
// import 'widgets/audio_call_ripple.dart';
// import 'widgets/audio_call_buttons.dart';
//
// class AudioCallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//
//   AudioCallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     this.isVideo = false,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final AudioCallController controller = Get.put(
//       AudioCallController(
//         callerName: userName,
//         profileImage: userAvatar,
//         receiverId: receiverId,
//         isVideo: isVideo,
//       ),
//       tag: userName + receiverId,
//     );
//
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: Obx(
//             () => Stack(
//           children: [
//             // Video Views (for video calls)
//             if (isVideo) _buildVideoViews(controller),
//
//             // Background for audio calls or connecting state
//             if (!isVideo || controller.state.value != AudioCallState.connected)
//               _buildAudioBackground(),
//
//             // Loading indicator while creating call
//             if (controller.isCallCreating.value)
//               _buildLoadingIndicator(),
//
//             // Main Content
//             SafeArea(
//               child: _AnimatedCallContent(
//                 controller: controller,
//                 isVideo: isVideo,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ===================== VIDEO VIEWS =====================
//   Widget _buildVideoViews(AudioCallController controller) {
//     return Obx(() {
//       if (controller.state.value == AudioCallState.connected &&
//           controller.remoteUid.value != null) {
//         // Show remote video (full screen)
//         return Stack(
//           children: [
//             // Remote video (full screen)
//             Positioned.fill(
//               child: AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: controller._engine!,
//                   canvas: VideoCanvas(uid: controller.remoteUid.value),
//                   connection: RtcConnection(
//                     channelId: controller.callData?.channelName ?? '',
//                   ),
//                 ),
//               ),
//             ),
//             // Local video (small preview in corner)
//             Positioned(
//               top: 50,
//               right: 16,
//               child: Container(
//                 width: 120,
//                 height: 160,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: AgoraVideoView(
//                     controller: VideoViewController(
//                       rtcEngine: controller._engine!,
//                       canvas: const VideoCanvas(uid: 0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       } else {
//         // Show local preview only (waiting for remote user)
//         return Positioned.fill(
//           child: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: controller._engine!,
//               canvas: const VideoCanvas(uid: 0),
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   // ===================== AUDIO BACKGROUND =====================
//   Widget _buildAudioBackground() {
//     return Stack(
//       children: [
//         // Background Image
//         Positioned.fill(
//           child: Image.asset(
//             AppImages.callBg,
//             fit: BoxFit.cover,
//           ),
//         ),
//         // Gradient Overlay
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.callGradient1.withOpacity(1),
//                   AppColors.callGradient2.withOpacity(1),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//         ),
//         // Background Image with opacity
//         Positioned.fill(
//           child: Image.asset(
//             AppImages.callBg,
//             fit: BoxFit.cover,
//             opacity: const AlwaysStoppedAnimation(0.9),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ===================== LOADING INDICATOR =====================
//   Widget _buildLoadingIndicator() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black54,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(
//                 color: AppColors.primaryColor,
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Connecting...',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: FontDimen.dimen16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ===================== ANIMATED CONTENT =====================
// class _AnimatedCallContent extends StatefulWidget {
//   final AudioCallController controller;
//   final bool isVideo;
//
//   const _AnimatedCallContent({
//     required this.controller,
//     required this.isVideo,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<_AnimatedCallContent> createState() => _AnimatedCallContentState();
// }
//
// class _AnimatedCallContentState extends State<_AnimatedCallContent>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _avatarOffset;
//   late Animation<double> _avatarScale;
//   late Animation<double> _opacity;
//   late Animation<double> _nameOffset;
//   late Animation<double> _subtitleOffset;
//
//   AudioCallState? _lastState;
//
//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 650),
//     );
//
//     _setupAnimations(
//       isConnected: widget.controller.state.value == AudioCallState.connected,
//     );
//
//     widget.controller.state.listen((state) {
//       if (_lastState != state) {
//         if (state == AudioCallState.connected) {
//           _animController.forward();
//         } else {
//           _animController.reverse();
//         }
//         _lastState = state;
//       }
//     });
//   }
//
//   void _setupAnimations({required bool isConnected}) {
//     _avatarOffset = Tween<double>(begin: 0, end: 90).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: Curves.easeInOutCubic,
//         reverseCurve: Curves.elasticOut,
//       ),
//     );
//     _avatarScale = Tween<double>(begin: 1.0, end: 0.78).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: Curves.easeInOutCubic,
//         reverseCurve: Curves.elasticOut,
//       ),
//     );
//     _opacity = Tween<double>(begin: 1.0, end: 0.95).animate(_animController);
//
//     _nameOffset = Tween<double>(begin: 0, end: 60).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: Curves.easeInOutCubic,
//         reverseCurve: Curves.elasticOut,
//       ),
//     );
//     _subtitleOffset = Tween<double>(begin: 0, end: 60).animate(
//       CurvedAnimation(
//         parent: _animController,
//         curve: Curves.easeInOutCubic,
//         reverseCurve: Curves.elasticOut,
//       ),
//     );
//
//     if (isConnected) {
//       _animController.value = 1.0;
//     } else {
//       _animController.value = 0.0;
//     }
//   }
//
//   @override
//   void didUpdateWidget(covariant _AnimatedCallContent oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.controller.state.value != oldWidget.controller.state.value) {
//       _setupAnimations(
//         isConnected: widget.controller.state.value == AudioCallState.connected,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = widget.controller;
//
//     // Hide avatar and text for video calls when connected
//     final showAvatar = !widget.isVideo ||
//         controller.state.value != AudioCallState.connected;
//
//     return Column(
//       children: [
//         SizedBox(height: AppDimens.dimen45),
//
//         // Title
//         Text(
//           widget.isVideo ? AppStrings.videoCall : AppStrings.audioCall,
//           style: TextStyle(
//             color: AppColors.whiteColor,
//             fontFamily: GoogleFonts.inter().fontFamily,
//             fontSize: FontDimen.dimen18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//
//         if (showAvatar) ...[
//           SizedBox(height: AppDimens.dimen120),
//
//           // Animated Avatar
//           AnimatedBuilder(
//             animation: _animController,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _avatarOffset.value),
//                 child: Transform.scale(
//                   scale: _avatarScale.value,
//                   child: Opacity(
//                     opacity: _opacity.value,
//                     child: AudioCallRipple(
//                       imageUrl: controller.profileImage.value,
//                       showRipple: controller.state.value != AudioCallState.connected,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           // Animated Subtitle
//           AnimatedBuilder(
//             animation: _animController,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _subtitleOffset.value),
//                 child: Opacity(
//                   opacity: _opacity.value,
//                   child: Text(
//                     controller.state.value == AudioCallState.incoming
//                         ? AppStrings.incomingCall
//                         : controller.state.value == AudioCallState.calling
//                         ? AppStrings.connecting
//                         : AppStrings.connected,
//                     style: TextStyle(
//                       color: AppColors.textColor3,
//                       fontSize: FontDimen.dimen16,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           SizedBox(height: AppDimens.dimen10),
//
//           // Animated Name
//           AnimatedBuilder(
//             animation: _animController,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _nameOffset.value),
//                 child: Opacity(
//                   opacity: _opacity.value,
//                   child: Text(
//                     controller.callerName.value,
//                     style: TextStyle(
//                       color: AppColors.textColor2,
//                       fontSize: FontDimen.dimen24,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: AppFonts.appFont,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           SizedBox(height: AppDimens.dimen32),
//         ] else ...[
//           // For video calls when connected, show name at top
//           SizedBox(height: AppDimens.dimen20),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               controller.callerName.value,
//               style: TextStyle(
//                 color: AppColors.whiteColor,
//                 fontSize: FontDimen.dimen18,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//           ),
//         ],
//
//         // Timer (only for connected)
//         Obx(() => controller.state.value == AudioCallState.connected
//             ? Container(
//           margin: EdgeInsets.only(top: 10),
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.4),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             controller.timerString.value,
//             style: TextStyle(
//               color: AppColors.whiteColor,
//               fontSize: FontDimen.dimen18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         )
//             : SizedBox.shrink()),
//
//         Spacer(),
//
//         // Buttons
//         AudioCallButtons(
//           state: controller.state.value,
//           onSpeaker: controller.toggleSpeaker,
//           onMute: controller.toggleMute,
//           onEnd: controller.endCall,
//           onAccept: controller.acceptCall,
//           isMuted: controller.isMuted.value,
//           isSpeakerOn: controller.isSpeakerOn.value,
//           isVideo: widget.isVideo,
//         ),
//
//         SizedBox(height: AppDimens.dimen100),
//       ],
//     );
//   }
// }

// audio_call_screen.dart


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../config/app_colors.dart';
import '../../utils/app_dimen.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_img.dart';
import '../../utils/app_strings.dart';
import 'audio_call_controller.dart';
import 'widgets/audio_call_ripple.dart';
import 'widgets/audio_call_buttons.dart';

class AudioCallScreen extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String receiverId;
  final bool isVideo;
  final bool isCaller;

  AudioCallScreen({
    required this.userName,
    required this.userAvatar,
    required this.receiverId,
    this.isVideo = false,
    this.isCaller = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCallController controller = Get.put(
      AudioCallController(
        callerName: userName,
        profileImage: userAvatar,
        receiverId: receiverId,
        isVideo: isVideo,
        isCaller: isCaller,
      ),
      tag: userName + receiverId,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Obx(
            () => Stack(
          children: [
            // Video Views (for video calls)
            if (isVideo) _buildVideoViews(controller),

            // Background for audio calls or connecting state
            if (!isVideo || controller.state.value != AudioCallState.connected)
              _buildAudioBackground(),

            // Loading indicator while creating call
            if (controller.isCallCreating.value) _buildLoadingIndicator(),

            // Main Content
            SafeArea(
              child: _AnimatedCallContent(
                controller: controller,
                isVideo: isVideo,
                isCaller: isCaller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== VIDEO VIEWS =====================
  Widget _buildVideoViews(AudioCallController controller) {
    return Obx(() {
      // If connected and remote available -> show remote fullscreen + local small preview
      if (controller.state.value == AudioCallState.connected &&
          controller.remoteUid.value != null) {
        return Stack(
          children: [
            // Remote video (full screen)
            Positioned.fill(
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine,
                  canvas: VideoCanvas(uid: controller.remoteUid.value),
                  connection: RtcConnection(
                    channelId: controller.callData?.channelName ?? '',
                  ),
                ),
              ),
            ),
            // Local video (small preview in corner)
            Positioned(
              top: 50,
              right: 16,
              child: Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: controller.engine,
                      canvas: VideoCanvas(uid: controller.localUid ?? 0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        // Show local preview only (waiting for remote user or before join)
        return Positioned.fill(
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.engine,
              canvas: VideoCanvas(uid: controller.localUid ?? 0),
            ),
          ),
        );
      }
    });
  }

  // ===================== AUDIO BACKGROUND =====================
  Widget _buildAudioBackground() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            AppImages.callBg,
            fit: BoxFit.cover,
          ),
        ),
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.callGradient1.withOpacity(1),
                  AppColors.callGradient2.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        // Background Image with opacity
        Positioned.fill(
          child: Image.asset(
            AppImages.callBg,
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.9),
          ),
        ),
      ],
    );
  }

  // ===================== LOADING INDICATOR =====================
  Widget _buildLoadingIndicator() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Connecting...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== ANIMATED CONTENT =====================
class _AnimatedCallContent extends StatefulWidget {
  final AudioCallController controller;
  final bool isVideo;
  final bool isCaller;

  const _AnimatedCallContent({
    required this.controller,
    required this.isVideo,
    required this.isCaller,
    Key? key,
  }) : super(key: key);

  @override
  State<_AnimatedCallContent> createState() => _AnimatedCallContentState();
}

class _AnimatedCallContentState extends State<_AnimatedCallContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _avatarOffset;
  late Animation<double> _avatarScale;
  late Animation<double> _opacity;
  late Animation<double> _nameOffset;
  late Animation<double> _subtitleOffset;

  AudioCallState? _lastState;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _setupAnimations(
      isConnected: widget.controller.state.value == AudioCallState.connected,
    );

    widget.controller.state.listen((state) {
      if (_lastState != state) {
        if (state == AudioCallState.connected) {
          _animController.forward();
        } else {
          _animController.reverse();
        }
        _lastState = state;
      }
    });
  }

  void _setupAnimations({required bool isConnected}) {
    _avatarOffset = Tween<double>(begin: 0, end: 90).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
    _avatarScale = Tween<double>(begin: 1.0, end: 0.78).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.95).animate(_animController);

    _nameOffset = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
    _subtitleOffset = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );

    if (isConnected) {
      _animController.value = 1.0;
    } else {
      _animController.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedCallContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.state.value != oldWidget.controller.state.value) {
      _setupAnimations(
        isConnected: widget.controller.state.value == AudioCallState.connected,
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    // Hide avatar and text for video calls when connected
    final showAvatar = !widget.isVideo ||
        controller.state.value != AudioCallState.connected;

    return Column(
      children: [
        const SizedBox(height: 45),

        // Title
        Text(
          widget.isVideo ? AppStrings.videoCall : AppStrings.audioCall,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        if (showAvatar) ...[
          const SizedBox(height: 120),

          // Animated Avatar
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _avatarOffset.value),
                child: Transform.scale(
                  scale: _avatarScale.value,
                  child: Opacity(
                    opacity: _opacity.value,
                    child: AudioCallRipple(
                      imageUrl: controller.profileImage.value,
                      showRipple: controller.state.value != AudioCallState.connected,
                    ),
                  ),
                ),
              );
            },
          ),

          // Animated Subtitle
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _subtitleOffset.value),
                child: Opacity(
                  opacity: _opacity.value,
                  child: Text(
                    controller.state.value == AudioCallState.incoming
                        ? AppStrings.incomingCall
                        : controller.state.value == AudioCallState.calling
                        ? AppStrings.connecting
                        : AppStrings.connected,
                    style: TextStyle(
                      color: AppColors.textColor3,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          // Animated Name
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _nameOffset.value),
                child: Opacity(
                  opacity: _opacity.value,
                  child: Text(
                    controller.callerName.value,
                    style: TextStyle(
                      color: AppColors.textColor2,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
        ] else ...[
          // For video calls when connected, show name at top
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              controller.callerName.value,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.appFont,
              ),
            ),
          ),
        ],

        // Timer (only for connected)
        Obx(() => controller.state.value == AudioCallState.connected
            ? Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            controller.timerString.value,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            : const SizedBox.shrink()),

        const Spacer(),

        // Buttons
        AudioCallButtons(
          state: controller.state.value,
          onSpeaker: controller.toggleSpeaker,
          onMute: controller.toggleMute,
          onEnd: controller.endCall,
          onAccept: controller.acceptCall,
          isMuted: controller.isMuted.value,
          isSpeakerOn: controller.isSpeakerOn.value,
          isVideo: widget.isVideo,
          // isCaller: widget.isCaller,
        ),

        const SizedBox(height: 100),
      ],
    );
  }
}
