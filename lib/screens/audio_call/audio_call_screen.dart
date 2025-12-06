// //
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../../config/app_colors.dart';
// // import '../../utils/app_dimen.dart';
// // import '../../utils/app_fonts.dart';
// // import '../../utils/app_img.dart';
// // import '../../utils/app_strings.dart';
// // import 'audio_call_controller.dart';
// // import 'widgets/audio_call_ripple.dart';
// // import 'widgets/audio_call_buttons.dart';
// //
// // class AudioCallScreen extends StatelessWidget {
// //   final String userName;
// //   final String userAvatar;
// //   final String receiverId;
// //   final bool isVideo;
// //
// //   AudioCallScreen({
// //     required this.userName,
// //     required this.userAvatar,
// //     required this.receiverId,
// //     this.isVideo = false,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final AudioCallController controller = Get.put(
// //       AudioCallController(
// //         callerName: userName,
// //         profileImage: userAvatar,
// //         receiverId: receiverId,
// //         isVideo: isVideo,
// //       ),
// //       tag: userName + receiverId,
// //     );
// //
// //     return Scaffold(
// //       backgroundColor: AppColors.scaffoldBackgroundColor,
// //       body: Obx(
// //             () => Stack(
// //           children: [
// //             // Video Views (for video calls)
// //             if (isVideo) _buildVideoViews(controller),
// //
// //             // Background for audio calls or connecting state
// //             if (!isVideo || controller.state.value != AudioCallState.connected)
// //               _buildAudioBackground(),
// //
// //             // Loading indicator while creating call
// //             if (controller.isCallCreating.value)
// //               _buildLoadingIndicator(),
// //
// //             // Main Content
// //             SafeArea(
// //               child: _AnimatedCallContent(
// //                 controller: controller,
// //                 isVideo: isVideo,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ===================== VIDEO VIEWS =====================
// //   Widget _buildVideoViews(AudioCallController controller) {
// //     return Obx(() {
// //       if (controller.state.value == AudioCallState.connected &&
// //           controller.remoteUid.value != null) {
// //         // Show remote video (full screen)
// //         return Stack(
// //           children: [
// //             // Remote video (full screen)
// //             Positioned.fill(
// //               child: AgoraVideoView(
// //                 controller: VideoViewController.remote(
// //                   rtcEngine: controller._engine!,
// //                   canvas: VideoCanvas(uid: controller.remoteUid.value),
// //                   connection: RtcConnection(
// //                     channelId: controller.callData?.channelName ?? '',
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             // Local video (small preview in corner)
// //             Positioned(
// //               top: 50,
// //               right: 16,
// //               child: Container(
// //                 width: 120,
// //                 height: 160,
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.white, width: 2),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: AgoraVideoView(
// //                     controller: VideoViewController(
// //                       rtcEngine: controller._engine!,
// //                       canvas: const VideoCanvas(uid: 0),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         );
// //       } else {
// //         // Show local preview only (waiting for remote user)
// //         return Positioned.fill(
// //           child: AgoraVideoView(
// //             controller: VideoViewController(
// //               rtcEngine: controller._engine!,
// //               canvas: const VideoCanvas(uid: 0),
// //             ),
// //           ),
// //         );
// //       }
// //     });
// //   }
// //
// //   // ===================== AUDIO BACKGROUND =====================
// //   Widget _buildAudioBackground() {
// //     return Stack(
// //       children: [
// //         // Background Image
// //         Positioned.fill(
// //           child: Image.asset(
// //             AppImages.callBg,
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         // Gradient Overlay
// //         Positioned.fill(
// //           child: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   AppColors.callGradient1.withOpacity(1),
// //                   AppColors.callGradient2.withOpacity(1),
// //                 ],
// //                 begin: Alignment.topCenter,
// //                 end: Alignment.bottomCenter,
// //               ),
// //             ),
// //           ),
// //         ),
// //         // Background Image with opacity
// //         Positioned.fill(
// //           child: Image.asset(
// //             AppImages.callBg,
// //             fit: BoxFit.cover,
// //             opacity: const AlwaysStoppedAnimation(0.9),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   // ===================== LOADING INDICATOR =====================
// //   Widget _buildLoadingIndicator() {
// //     return Positioned.fill(
// //       child: Container(
// //         color: Colors.black54,
// //         child: Center(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               CircularProgressIndicator(
// //                 color: AppColors.primaryColor,
// //               ),
// //               SizedBox(height: 16),
// //               Text(
// //                 'Connecting...',
// //                 style: TextStyle(
// //                   color: AppColors.whiteColor,
// //                   fontSize: FontDimen.dimen16,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ===================== ANIMATED CONTENT =====================
// // class _AnimatedCallContent extends StatefulWidget {
// //   final AudioCallController controller;
// //   final bool isVideo;
// //
// //   const _AnimatedCallContent({
// //     required this.controller,
// //     required this.isVideo,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   State<_AnimatedCallContent> createState() => _AnimatedCallContentState();
// // }
// //
// // class _AnimatedCallContentState extends State<_AnimatedCallContent>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animController;
// //   late Animation<double> _avatarOffset;
// //   late Animation<double> _avatarScale;
// //   late Animation<double> _opacity;
// //   late Animation<double> _nameOffset;
// //   late Animation<double> _subtitleOffset;
// //
// //   AudioCallState? _lastState;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 650),
// //     );
// //
// //     _setupAnimations(
// //       isConnected: widget.controller.state.value == AudioCallState.connected,
// //     );
// //
// //     widget.controller.state.listen((state) {
// //       if (_lastState != state) {
// //         if (state == AudioCallState.connected) {
// //           _animController.forward();
// //         } else {
// //           _animController.reverse();
// //         }
// //         _lastState = state;
// //       }
// //     });
// //   }
// //
// //   void _setupAnimations({required bool isConnected}) {
// //     _avatarOffset = Tween<double>(begin: 0, end: 90).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //     _avatarScale = Tween<double>(begin: 1.0, end: 0.78).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //     _opacity = Tween<double>(begin: 1.0, end: 0.95).animate(_animController);
// //
// //     _nameOffset = Tween<double>(begin: 0, end: 60).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //     _subtitleOffset = Tween<double>(begin: 0, end: 60).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //
// //     if (isConnected) {
// //       _animController.value = 1.0;
// //     } else {
// //       _animController.value = 0.0;
// //     }
// //   }
// //
// //   @override
// //   void didUpdateWidget(covariant _AnimatedCallContent oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.controller.state.value != oldWidget.controller.state.value) {
// //       _setupAnimations(
// //         isConnected: widget.controller.state.value == AudioCallState.connected,
// //       );
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = widget.controller;
// //
// //     // Hide avatar and text for video calls when connected
// //     final showAvatar = !widget.isVideo ||
// //         controller.state.value != AudioCallState.connected;
// //
// //     return Column(
// //       children: [
// //         SizedBox(height: AppDimens.dimen45),
// //
// //         // Title
// //         Text(
// //           widget.isVideo ? AppStrings.videoCall : AppStrings.audioCall,
// //           style: TextStyle(
// //             color: AppColors.whiteColor,
// //             fontFamily: GoogleFonts.inter().fontFamily,
// //             fontSize: FontDimen.dimen18,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //
// //         if (showAvatar) ...[
// //           SizedBox(height: AppDimens.dimen120),
// //
// //           // Animated Avatar
// //           AnimatedBuilder(
// //             animation: _animController,
// //             builder: (context, child) {
// //               return Transform.translate(
// //                 offset: Offset(0, _avatarOffset.value),
// //                 child: Transform.scale(
// //                   scale: _avatarScale.value,
// //                   child: Opacity(
// //                     opacity: _opacity.value,
// //                     child: AudioCallRipple(
// //                       imageUrl: controller.profileImage.value,
// //                       showRipple: controller.state.value != AudioCallState.connected,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           // Animated Subtitle
// //           AnimatedBuilder(
// //             animation: _animController,
// //             builder: (context, child) {
// //               return Transform.translate(
// //                 offset: Offset(0, _subtitleOffset.value),
// //                 child: Opacity(
// //                   opacity: _opacity.value,
// //                   child: Text(
// //                     controller.state.value == AudioCallState.incoming
// //                         ? AppStrings.incomingCall
// //                         : controller.state.value == AudioCallState.calling
// //                         ? AppStrings.connecting
// //                         : AppStrings.connected,
// //                     style: TextStyle(
// //                       color: AppColors.textColor3,
// //                       fontSize: FontDimen.dimen16,
// //                       fontWeight: FontWeight.w400,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           SizedBox(height: AppDimens.dimen10),
// //
// //           // Animated Name
// //           AnimatedBuilder(
// //             animation: _animController,
// //             builder: (context, child) {
// //               return Transform.translate(
// //                 offset: Offset(0, _nameOffset.value),
// //                 child: Opacity(
// //                   opacity: _opacity.value,
// //                   child: Text(
// //                     controller.callerName.value,
// //                     style: TextStyle(
// //                       color: AppColors.textColor2,
// //                       fontSize: FontDimen.dimen24,
// //                       fontWeight: FontWeight.bold,
// //                       fontFamily: AppFonts.appFont,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           SizedBox(height: AppDimens.dimen32),
// //         ] else ...[
// //           // For video calls when connected, show name at top
// //           SizedBox(height: AppDimens.dimen20),
// //           Container(
// //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //             decoration: BoxDecoration(
// //               color: Colors.black.withOpacity(0.5),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: Text(
// //               controller.callerName.value,
// //               style: TextStyle(
// //                 color: AppColors.whiteColor,
// //                 fontSize: FontDimen.dimen18,
// //                 fontWeight: FontWeight.w600,
// //                 fontFamily: AppFonts.appFont,
// //               ),
// //             ),
// //           ),
// //         ],
// //
// //         // Timer (only for connected)
// //         Obx(() => controller.state.value == AudioCallState.connected
// //             ? Container(
// //           margin: EdgeInsets.only(top: 10),
// //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //           decoration: BoxDecoration(
// //             color: Colors.black.withOpacity(0.4),
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           child: Text(
// //             controller.timerString.value,
// //             style: TextStyle(
// //               color: AppColors.whiteColor,
// //               fontSize: FontDimen.dimen18,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //         )
// //             : SizedBox.shrink()),
// //
// //         Spacer(),
// //
// //         // Buttons
// //         AudioCallButtons(
// //           state: controller.state.value,
// //           onSpeaker: controller.toggleSpeaker,
// //           onMute: controller.toggleMute,
// //           onEnd: controller.endCall,
// //           onAccept: controller.acceptCall,
// //           isMuted: controller.isMuted.value,
// //           isSpeakerOn: controller.isSpeakerOn.value,
// //           isVideo: widget.isVideo,
// //         ),
// //
// //         SizedBox(height: AppDimens.dimen100),
// //       ],
// //     );
// //   }
// // }
//
// // audio_call_screen.dart
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import '../../config/app_colors.dart';
// // import '../../utils/app_dimen.dart';
// // import '../../utils/app_fonts.dart';
// // import '../../utils/app_img.dart';
// // import '../../utils/app_strings.dart';
// // import 'audio_call_controller.dart';
// // import 'widgets/audio_call_ripple.dart';
// // import 'widgets/audio_call_buttons.dart';
// //
// // class AudioCallScreen extends StatelessWidget {
// //   final String userName;
// //   final String userAvatar;
// //   final String receiverId;
// //   final bool isVideo;
// //   final bool isCaller;
// //
// //   AudioCallScreen({
// //     required this.userName,
// //     required this.userAvatar,
// //     required this.receiverId,
// //     this.isVideo = false,
// //     this.isCaller = false,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final AudioCallController controller = Get.put(
// //       AudioCallController(
// //         callerName: userName,
// //         profileImage: userAvatar,
// //         receiverId: receiverId,
// //         isVideo: isVideo,
// //         isCaller: isCaller,
// //       ),
// //       tag: userName + receiverId,
// //     );
// //
// //     return Scaffold(
// //       backgroundColor: AppColors.scaffoldBackgroundColor,
// //       body: Obx(
// //             () => Stack(
// //           children: [
// //             // Video Views (for video calls)
// //             if (isVideo) _buildVideoViews(controller),
// //
// //             // Background for audio calls or connecting state
// //             if (!isVideo || controller.state.value != AudioCallState.connected)
// //               _buildAudioBackground(),
// //
// //             // Loading indicator while creating call
// //             if (controller.isCallCreating.value) _buildLoadingIndicator(),
// //
// //             // Main Content
// //             SafeArea(
// //               child: _AnimatedCallContent(
// //                 controller: controller,
// //                 isVideo: isVideo,
// //                 isCaller: isCaller,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ===================== VIDEO VIEWS =====================
// //   Widget _buildVideoViews(AudioCallController controller) {
// //     return Obx(() {
// //       // If connected and remote available -> show remote fullscreen + local small preview
// //       if (controller.state.value == AudioCallState.connected &&
// //           controller.remoteUid.value != null) {
// //         return Stack(
// //           children: [
// //             // Remote video (full screen)
// //             Positioned.fill(
// //               child: AgoraVideoView(
// //                 controller: VideoViewController.remote(
// //                   rtcEngine: controller.engine,
// //                   canvas: VideoCanvas(uid: controller.remoteUid.value),
// //                   connection: RtcConnection(
// //                     channelId: controller.callData?.channelName ?? '',
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             // Local video (small preview in corner)
// //             Positioned(
// //               top: 50,
// //               right: 16,
// //               child: Container(
// //                 width: 120,
// //                 height: 160,
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.white, width: 2),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: AgoraVideoView(
// //                     controller: VideoViewController(
// //                       rtcEngine: controller.engine,
// //                       canvas: VideoCanvas(uid: controller.localUid ?? 0),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         );
// //       } else {
// //         // Show local preview only (waiting for remote user or before join)
// //         return Positioned.fill(
// //           child: AgoraVideoView(
// //             controller: VideoViewController(
// //               rtcEngine: controller.engine,
// //               canvas: VideoCanvas(uid: controller.localUid ?? 0),
// //             ),
// //           ),
// //         );
// //       }
// //     });
// //   }
// //
// //   // ===================== AUDIO BACKGROUND =====================
// //   Widget _buildAudioBackground() {
// //     return Stack(
// //       children: [
// //         // Background Image
// //         Positioned.fill(
// //           child: Image.asset(
// //             AppImages.callBg,
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         // Gradient Overlay
// //         Positioned.fill(
// //           child: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   AppColors.callGradient1.withOpacity(1),
// //                   AppColors.callGradient2.withOpacity(1),
// //                 ],
// //                 begin: Alignment.topCenter,
// //                 end: Alignment.bottomCenter,
// //               ),
// //             ),
// //           ),
// //         ),
// //         // Background Image with opacity
// //         Positioned.fill(
// //           child: Image.asset(
// //             AppImages.callBg,
// //             fit: BoxFit.cover,
// //             opacity: const AlwaysStoppedAnimation(0.9),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   // ===================== LOADING INDICATOR =====================
// //   Widget _buildLoadingIndicator() {
// //     return Positioned.fill(
// //       child: Container(
// //         color: Colors.black54,
// //         child: Center(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               CircularProgressIndicator(
// //                 color: AppColors.primaryColor,
// //               ),
// //               const SizedBox(height: 16),
// //               const Text(
// //                 'Connecting...',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 16,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ===================== ANIMATED CONTENT =====================
// // class _AnimatedCallContent extends StatefulWidget {
// //   final AudioCallController controller;
// //   final bool isVideo;
// //   final bool isCaller;
// //
// //   const _AnimatedCallContent({
// //     required this.controller,
// //     required this.isVideo,
// //     required this.isCaller,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   State<_AnimatedCallContent> createState() => _AnimatedCallContentState();
// // }
// //
// // class _AnimatedCallContentState extends State<_AnimatedCallContent>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animController;
// //   late Animation<double> _avatarOffset;
// //   late Animation<double> _avatarScale;
// //   late Animation<double> _opacity;
// //   late Animation<double> _nameOffset;
// //   late Animation<double> _subtitleOffset;
// //
// //   AudioCallState? _lastState;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 650),
// //     );
// //
// //     _setupAnimations(
// //       isConnected: widget.controller.state.value == AudioCallState.connected,
// //     );
// //
// //     widget.controller.state.listen((state) {
// //       if (_lastState != state) {
// //         if (state == AudioCallState.connected) {
// //           _animController.forward();
// //         } else {
// //           _animController.reverse();
// //         }
// //         _lastState = state;
// //       }
// //     });
// //   }
// //
// //   void _setupAnimations({required bool isConnected}) {
// //     _avatarOffset = Tween<double>(begin: 0, end: 90).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //     _avatarScale = Tween<double>(begin: 1.0, end: 0.78).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //     _opacity = Tween<double>(begin: 1.0, end: 0.95).animate(_animController);
// //
// //     _nameOffset = Tween<double>(begin: 0, end: 60).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //     _subtitleOffset = Tween<double>(begin: 0, end: 60).animate(
// //       CurvedAnimation(
// //         parent: _animController,
// //         curve: Curves.easeInOutCubic,
// //         reverseCurve: Curves.elasticOut,
// //       ),
// //     );
// //
// //     if (isConnected) {
// //       _animController.value = 1.0;
// //     } else {
// //       _animController.value = 0.0;
// //     }
// //   }
// //
// //   @override
// //   void didUpdateWidget(covariant _AnimatedCallContent oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.controller.state.value != oldWidget.controller.state.value) {
// //       _setupAnimations(
// //         isConnected: widget.controller.state.value == AudioCallState.connected,
// //       );
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = widget.controller;
// //
// //     // Hide avatar and text for video calls when connected
// //     final showAvatar = !widget.isVideo ||
// //         controller.state.value != AudioCallState.connected;
// //
// //     return Column(
// //       children: [
// //         const SizedBox(height: 45),
// //
// //         // Title
// //         Text(
// //           widget.isVideo ? AppStrings.videoCall : AppStrings.audioCall,
// //           style: TextStyle(
// //             color: AppColors.whiteColor,
// //             fontFamily: GoogleFonts.inter().fontFamily,
// //             fontSize: 18,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //
// //         if (showAvatar) ...[
// //           const SizedBox(height: 120),
// //
// //           // Animated Avatar
// //           AnimatedBuilder(
// //             animation: _animController,
// //             builder: (context, child) {
// //               return Transform.translate(
// //                 offset: Offset(0, _avatarOffset.value),
// //                 child: Transform.scale(
// //                   scale: _avatarScale.value,
// //                   child: Opacity(
// //                     opacity: _opacity.value,
// //                     child: AudioCallRipple(
// //                       imageUrl: controller.profileImage.value,
// //                       showRipple: controller.state.value != AudioCallState.connected,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           // Animated Subtitle
// //           AnimatedBuilder(
// //             animation: _animController,
// //             builder: (context, child) {
// //               return Transform.translate(
// //                 offset: Offset(0, _subtitleOffset.value),
// //                 child: Opacity(
// //                   opacity: _opacity.value,
// //                   child: Text(
// //                     controller.state.value == AudioCallState.incoming
// //                         ? AppStrings.incomingCall
// //                         : controller.state.value == AudioCallState.calling
// //                         ? AppStrings.connecting
// //                         : AppStrings.connected,
// //                     style: TextStyle(
// //                       color: AppColors.textColor3,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w400,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           const SizedBox(height: 10),
// //
// //           // Animated Name
// //           AnimatedBuilder(
// //             animation: _animController,
// //             builder: (context, child) {
// //               return Transform.translate(
// //                 offset: Offset(0, _nameOffset.value),
// //                 child: Opacity(
// //                   opacity: _opacity.value,
// //                   child: Text(
// //                     controller.callerName.value,
// //                     style: TextStyle(
// //                       color: AppColors.textColor2,
// //                       fontSize: 24,
// //                       fontWeight: FontWeight.bold,
// //                       fontFamily: AppFonts.appFont,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           const SizedBox(height: 32),
// //         ] else ...[
// //           // For video calls when connected, show name at top
// //           const SizedBox(height: 20),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //             decoration: BoxDecoration(
// //               color: Colors.black.withOpacity(0.5),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: Text(
// //               controller.callerName.value,
// //               style: TextStyle(
// //                 color: AppColors.whiteColor,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //                 fontFamily: AppFonts.appFont,
// //               ),
// //             ),
// //           ),
// //         ],
// //
// //         // Timer (only for connected)
// //         Obx(() => controller.state.value == AudioCallState.connected
// //             ? Container(
// //           margin: const EdgeInsets.only(top: 10),
// //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //           decoration: BoxDecoration(
// //             color: Colors.black.withOpacity(0.4),
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           child: Text(
// //             controller.timerString.value,
// //             style: TextStyle(
// //               color: AppColors.whiteColor,
// //               fontSize: 18,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //         )
// //             : const SizedBox.shrink()),
// //
// //         const Spacer(),
// //
// //         // Buttons
// //         AudioCallButtons(
// //           state: controller.state.value,
// //           onSpeaker: controller.toggleSpeaker,
// //           onMute: controller.toggleMute,
// //           onEnd: controller.endCall,
// //           onAccept: controller.acceptCall,
// //           isMuted: controller.isMuted.value,
// //           isSpeakerOn: controller.isSpeakerOn.value,
// //           isVideo: widget.isVideo,
// //           // isCaller: widget.isCaller,
// //         ),
// //
// //         const SizedBox(height: 100),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_buttons.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_ripple.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_dimen.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_img.dart';
// import '../../utils/app_strings.dart';
// import 'audio_call_controller.dart';
//
// class CallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   const CallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     this.isVideo = false,
//     this.isIncoming = false,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       CallController(
//         userName: userName,
//         userAvatar: userAvatar,
//         receiverId: receiverId,
//         isVideo: isVideo,
//         isIncoming: isIncoming,
//       ),
//       tag: '$userName-$receiverId',
//     );
//
//     return WillPopScope(
//       onWillPop: () async {
//         controller.endCall();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: Obx(() => Stack(
//           children: [
//             // Video views for video calls
//             if (isVideo) _buildVideoViews(controller),
//
//             // Background for audio calls
//             if (!isVideo || controller.state.value != CallState.connected)
//               _buildBackground(),
//
//             // Loading indicator
//             if (controller.isLoading.value) _buildLoadingIndicator(),
//
//             // Main content
//             SafeArea(
//               child: _buildContent(controller),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildVideoViews(CallController controller) {
//     return Obx(() {
//       final isConnected = controller.state.value == CallState.connected;
//       final hasRemote = controller.remoteUid.value != null;
//       final agoraService = AgoraService.instance;
//
//       if (isConnected && hasRemote) {
//         // Show remote video fullscreen with local preview
//         return Stack(
//           children: [
//             // Remote video
//             Positioned.fill(
//               child: AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: agoraService.engine,
//                   canvas: VideoCanvas(uid: controller.remoteUid.value),
//                   connection: RtcConnection(
//                     channelId: controller.callData?.channelName ?? '',
//                   ),
//                 ),
//               ),
//             ),
//             // Local preview
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
//                       rtcEngine: agoraService.engine,
//                       canvas: VideoCanvas(uid: controller.localUid ?? 0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       } else {
//         // Show local preview only
//         return Positioned.fill(
//           child: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: agoraService.engine,
//               canvas: VideoCanvas(uid: controller.localUid ?? 0),
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   Widget _buildBackground() {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset(
//             AppImages.callBg,
//             fit: BoxFit.cover,
//           ),
//         ),
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
//       ],
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black54,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: AppColors.primaryColor),
//               const SizedBox(height: 16),
//               Text(
//                 'Connecting...',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(CallController controller) {
//     return Obx(() {
//       final state = controller.state.value;
//       final isConnected = state == CallState.connected;
//       final showAvatar = !isVideo || !isConnected;
//
//       return Column(
//         children: [
//           const SizedBox(height: 45),
//
//           // Title
//           Text(
//             isVideo ? AppStrings.videoCall : AppStrings.audioCall,
//             style: TextStyle(
//               color: AppColors.whiteColor,
//               fontFamily: GoogleFonts.inter().fontFamily,
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//
//           if (showAvatar) ...[
//             const SizedBox(height: 120),
//
//             // Avatar with ripple
//             CallAvatarRipple(
//               imageUrl: userAvatar,
//               showRipple: !isConnected,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Call status
//             Text(
//               _getStatusText(state),
//               style: TextStyle(
//                 color: AppColors.textColor3,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // User name
//             Text(
//               userName,
//               style: TextStyle(
//                 color: AppColors.textColor2,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//           ] else ...[
//             // For video calls when connected
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 userName,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: AppFonts.appFont,
//                 ),
//               ),
//             ),
//           ],
//
//           // Timer
//           if (isConnected)
//             Container(
//               margin: const EdgeInsets.only(top: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 controller.timerString.value,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//           const Spacer(),
//
//           // Action buttons
//           CallActionButtons(
//             controller: controller,
//             isVideo: isVideo,
//           ),
//
//           const SizedBox(height: 100),
//         ],
//       );
//     });
//   }
//
//   String _getStatusText(CallState state) {
//     switch (state) {
//       case CallState.ringing:
//         return AppStrings.incomingCall;
//       case CallState.calling:
//         return AppStrings.connecting;
//       case CallState.connected:
//         return AppStrings.connected;
//       default:
//         return '';
//     }
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_buttons.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_ripple.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_dimen.dart';
// import '../../utils/app_enums.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_img.dart';
// import '../../utils/app_strings.dart';
// import 'audio_call_controller.dart';
//
// class CallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   // ✅ Incoming call data
//   final String? callId;
//   final String? channelName;
//   final String? token;
//   final int? uid;
//
//   const CallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     this.isVideo = false,
//     this.isIncoming = false,
//     this.callId,
//     this.channelName,
//     this.token,
//     this.uid,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       CallController(
//         userName: userName,
//         userAvatar: userAvatar,
//         receiverId: receiverId,
//         isVideo: isVideo,
//         isIncoming: isIncoming,
//         incomingCallId: callId,
//         incomingChannelName: channelName,
//         incomingToken: token,
//         incomingUid: uid,
//       ),
//       tag: '$userName-$receiverId-${DateTime.now().millisecondsSinceEpoch}',
//     );
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (isIncoming && controller.state.value == CallState.ringing) {
//           // controller.rejectCall();
//         } else {
//           controller.endCall();
//         }
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: Obx(() => Stack(
//           children: [
//             // Video views for video calls
//             if (isVideo) _buildVideoViews(controller),
//
//             // Background for audio calls
//             if (!isVideo || controller.state.value != CallState.connected)
//               _buildBackground(),
//
//             // Loading indicator
//             if (controller.isLoading.value) _buildLoadingIndicator(),
//
//             // Main content
//             SafeArea(
//               child: _buildContent(controller),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildVideoViews(CallController controller) {
//     return Obx(() {
//       final isConnected = controller.state.value == CallState.connected;
//       final hasRemote = controller.remoteUid.value != null;
//       final agoraService = AgoraService.instance;
//
//       if (isConnected && hasRemote) {
//         return Stack(
//           children: [
//             // Remote video
//             Positioned.fill(
//               child: AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: agoraService.engine,
//                   canvas: VideoCanvas(uid: controller.remoteUid.value),
//                   connection: RtcConnection(
//                     channelId: controller.callData?.channelName ?? '',
//                   ),
//                 ),
//               ),
//             ),
//             // Local preview
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
//                       rtcEngine: agoraService.engine,
//                       canvas: VideoCanvas(uid: controller.localUid ?? 0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       } else {
//         return Positioned.fill(
//           child: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: agoraService.engine,
//               canvas: VideoCanvas(uid: controller.localUid ?? 0),
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   Widget _buildBackground() {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset(
//             AppImages.callBg,
//             fit: BoxFit.cover,
//           ),
//         ),
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
//       ],
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black54,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: AppColors.primaryColor),
//               const SizedBox(height: 16),
//               Text(
//                 'Connecting...',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(CallController controller) {
//     return Obx(() {
//       final state = controller.state.value;
//       final isConnected = state == CallState.connected;
//       final showAvatar = !isVideo || !isConnected;
//
//       return Column(
//         children: [
//           const SizedBox(height: 45),
//
//           // Title
//           Text(
//             isVideo ? AppStrings.videoCall : AppStrings.audioCall,
//             style: TextStyle(
//               color: AppColors.whiteColor,
//               fontFamily: GoogleFonts.inter().fontFamily,
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//
//           if (showAvatar) ...[
//             const SizedBox(height: 120),
//
//             // Avatar with ripple
//             CallAvatarRipple(
//               imageUrl: userAvatar,
//               showRipple: !isConnected,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Call status
//             Text(
//               _getStatusText(state),
//               style: TextStyle(
//                 color: AppColors.textColor3,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // User name
//             Text(
//               userName,
//               style: TextStyle(
//                 color: AppColors.textColor2,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//           ] else ...[
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 userName,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: AppFonts.appFont,
//                 ),
//               ),
//             ),
//           ],
//
//           // Timer
//           if (isConnected)
//             Container(
//               margin: const EdgeInsets.only(top: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 controller.timerString.value,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//           const Spacer(),
//
//           // Action buttons
//           CallActionButtons(
//             controller: controller,
//             isVideo: isVideo,
//           ),
//
//           const SizedBox(height: 100),
//         ],
//       );
//     });
//   }
//
//   String _getStatusText(CallState state) {
//     switch (state) {
//       case CallState.ringing:
//         return AppStrings.incomingCall;
//       case CallState.calling:
//         return AppStrings.connecting;
//       case CallState.connected:
//         return AppStrings.connected;
//       default:
//         return '';
//     }
//   }
// }


//--- important

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_buttons.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_ripple.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_dimen.dart';
// import '../../utils/app_enums.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_img.dart';
// import '../../utils/app_strings.dart';
// import 'audio_call_controller.dart';
//
// class CallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   // ✅ Incoming call data
//   final String? callId;
//   final String? channelName;
//   final String? token;
//   final int? uid;
//
//   const CallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     this.isVideo = false,
//     this.isIncoming = false,
//     this.callId,
//     this.channelName,
//     this.token,
//     this.uid,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       CallController(
//         userName: userName,
//         userAvatar: userAvatar,
//         receiverId: receiverId,
//         isVideo: isVideo,
//         isIncoming: isIncoming,
//         incomingCallId: callId,
//         incomingChannelName: channelName,
//         incomingToken: token,
//         incomingUid: uid,
//       ),
//       tag: '$userName-$receiverId-${DateTime.now().millisecondsSinceEpoch}',
//     );
//
//     return WillPopScope(
//       onWillPop: () async {
//         // ✅ Handle back button properly
//         if (isIncoming && controller.state.value == CallState.ringing) {
//           controller.rejectCall(); // Reject incoming call
//         } else {
//           controller.endCall(); // End ongoing call
//         }
//         return false; // Prevent default back behavior
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: Obx(() => Stack(
//           children: [
//             // Video views for video calls
//             if (isVideo) _buildVideoViews(controller),
//
//             // Background for audio calls
//             if (!isVideo || controller.state.value != CallState.connected)
//               _buildBackground(),
//
//             // Loading indicator
//             if (controller.isLoading.value) _buildLoadingIndicator(),
//
//             // Main content
//             SafeArea(
//               child: _buildContent(controller),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildVideoViews(CallController controller) {
//     return Obx(() {
//       final isConnected = controller.state.value == CallState.connected;
//       final hasRemote = controller.remoteUid.value != null;
//       final agoraService = AgoraService.instance;
//
//       if (isConnected && hasRemote) {
//         return Stack(
//           children: [
//             // Remote video
//             Positioned.fill(
//               child: AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: agoraService.engine,
//                   canvas: VideoCanvas(uid: controller.remoteUid.value),
//                   connection: RtcConnection(
//                     channelId: controller.callData?.channelName ?? '',
//                   ),
//                 ),
//               ),
//             ),
//             // Local preview
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
//                       rtcEngine: agoraService.engine,
//                       canvas: VideoCanvas(uid: controller.localUid ?? 0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       } else {
//         return Positioned.fill(
//           child: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: agoraService.engine,
//               canvas: VideoCanvas(uid: controller.localUid ?? 0),
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   Widget _buildBackground() {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset(
//             AppImages.callBg,
//             fit: BoxFit.cover,
//           ),
//         ),
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
//       ],
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black54,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: AppColors.primaryColor),
//               const SizedBox(height: 16),
//               Text(
//                 'Connecting...',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(CallController controller) {
//     return Obx(() {
//       final state = controller.state.value;
//       final isConnected = state == CallState.connected;
//       final showAvatar = !isVideo || !isConnected;
//
//       return Column(
//         children: [
//           const SizedBox(height: 45),
//
//           // Title
//           Text(
//             isVideo ? AppStrings.videoCall : AppStrings.audioCall,
//             style: TextStyle(
//               color: AppColors.whiteColor,
//               fontFamily: GoogleFonts.inter().fontFamily,
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//
//           if (showAvatar) ...[
//             const SizedBox(height: 120),
//
//             // Avatar with ripple
//             CallAvatarRipple(
//               imageUrl: userAvatar,
//               showRipple: !isConnected,
//             ),
//
//             const SizedBox(height: 20),
//
//             // Call status
//             Text(
//               _getStatusText(state),
//               style: TextStyle(
//                 color: AppColors.textColor3,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // User name
//             Text(
//               userName,
//               style: TextStyle(
//                 color: AppColors.textColor2,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//           ] else ...[
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 userName,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: AppFonts.appFont,
//                 ),
//               ),
//             ),
//           ],
//
//           // Timer
//           if (isConnected)
//             Container(
//               margin: const EdgeInsets.only(top: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 controller.timerString.value,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//           const Spacer(),
//
//           // Action buttons
//           CallActionButtons(
//             controller: controller,
//             isVideo: isVideo,
//           ),
//
//           const SizedBox(height: 100),
//         ],
//       );
//     });
//   }
//
//   String _getStatusText(CallState state) {
//     switch (state) {
//       case CallState.ringing:
//         return AppStrings.incomingCall;
//       case CallState.calling:
//         return AppStrings.connecting;
//       case CallState.connected:
//         return AppStrings.connected;
//       default:
//         return '';
//     }
//   }
// }



//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_buttons.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_ripple.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_dimen.dart';
// import '../../utils/app_enums.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_img.dart';
// import '../../utils/app_strings.dart';
// import 'audio_call_controller.dart';
//
// class CallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   // ✅ Incoming call data
//   final String? callId;
//   final String? channelName;
//   final String? token;
//   final int? uid;
//
//   const CallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     this.isVideo = false,
//     this.isIncoming = false,
//     this.callId,
//     this.channelName,
//     this.token,
//     this.uid,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       CallController(
//         userName: userName,
//         userAvatar: userAvatar,
//         receiverId: receiverId,
//         isVideo: isVideo,
//         isIncoming: isIncoming,
//         incomingCallId: callId,
//         incomingChannelName: channelName,
//         incomingToken: token,
//         incomingUid: uid,
//       ),
//       tag: '$userName-$receiverId-${DateTime.now().millisecondsSinceEpoch}',
//     );
//
//     return WillPopScope(
//       onWillPop: () async {
//         // ✅ Handle back button properly
//         if (isIncoming && controller.state.value == CallState.ringing) {
//           controller.rejectCall(); // Reject incoming call
//         } else {
//           controller.endCall(); // End ongoing call
//         }
//         return false; // Prevent default back behavior
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBackgroundColor,
//         body: Obx(() => Stack(
//           children: [
//             // Video views for video calls
//             if (isVideo) _buildVideoViews(controller),
//
//             // Background for audio calls or ringing state
//             if (!isVideo || controller.state.value != CallState.connected)
//               _buildBackground(),
//
//             // Loading indicator
//             if (controller.isLoading.value) _buildLoadingIndicator(),
//
//             // Main content
//             SafeArea(
//               child: _buildContent(controller),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildVideoViews(CallController controller) {
//     return Obx(() {
//       final isConnected = controller.state.value == CallState.connected;
//       final hasRemote = controller.remoteUid.value != null;
//       final showLocalPreview = controller.showLocalPreview.value;
//       final agoraService = AgoraService.instance;
//
//       // During ringing/calling: Show local preview only
//       if (!isConnected) {
//         return Positioned.fill(
//           child: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: agoraService.engine,
//               canvas: VideoCanvas(uid: controller.localUid ?? 0),
//             ),
//           ),
//         );
//       }
//
//       // When connected with remote user: Show both views
//       if (isConnected && hasRemote) {
//         return Stack(
//           children: [
//             // Remote video (full screen)
//             Positioned.fill(
//               child: AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: agoraService.engine,
//                   canvas: VideoCanvas(uid: controller.remoteUid.value),
//                   connection: RtcConnection(
//                     channelId: controller.callData?.channelName ?? '',
//                   ),
//                 ),
//               ),
//             ),
//             // Local preview (small overlay)
//             if (showLocalPreview)
//               Positioned(
//                 top: 60,
//                 right: 16,
//                 child: Container(
//                   width: 100,
//                   height: 140,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       )
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: AgoraVideoView(
//                       controller: VideoViewController(
//                         rtcEngine: agoraService.engine,
//                         canvas: VideoCanvas(uid: controller.localUid ?? 0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         );
//       }
//
//       // Default: Show local preview
//       return Positioned.fill(
//         child: AgoraVideoView(
//           controller: VideoViewController(
//             rtcEngine: agoraService.engine,
//             canvas: VideoCanvas(uid: controller.localUid ?? 0),
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.callGradient1.withOpacity(0.9),
//             AppColors.callGradient2.withOpacity(0.9),
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: isVideo
//           ? Container(
//         color: Colors.black.withOpacity(0.3),
//         child: Image.asset(
//           AppImages.callBg,
//           fit: BoxFit.cover,
//           opacity: const AlwaysStoppedAnimation(0.5),
//         ),
//       )
//           : Image.asset(
//         AppImages.callBg,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black.withOpacity(0.7),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: AppColors.primaryColor),
//               const SizedBox(height: 16),
//               Text(
//                 'Connecting...',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(CallController controller) {
//     return Obx(() {
//       final state = controller.state.value;
//       final isConnected = state == CallState.connected;
//       final isVideoCall = isVideo;
//       final showUserInfo = !isVideoCall || !isConnected || state == CallState.ringing;
//
//       return Column(
//         children: [
//           const SizedBox(height: 45),
//
//           // Title
//           Text(
//             isVideo ? AppStrings.videoCall : AppStrings.audioCall,
//             style: TextStyle(
//               color: AppColors.whiteColor,
//               fontFamily: GoogleFonts.inter().fontFamily,
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//
//           if (showUserInfo) ...[
//             const SizedBox(height: 120),
//
//             // Avatar with ripple (only for audio or ringing video)
//             if (!isVideoCall || state == CallState.ringing)
//               CallAvatarRipple(
//                 imageUrl: userAvatar,
//                 showRipple: !isConnected,
//               ),
//
//             const SizedBox(height: 20),
//
//             // Call status
//             Text(
//               _getStatusText(state),
//               style: TextStyle(
//                 color: AppColors.textColor3,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // User name
//             Text(
//               userName,
//               style: TextStyle(
//                 color: AppColors.textColor2,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//           ] else if (isVideoCall && isConnected) ...[
//             const SizedBox(height: 20),
//             // User name overlay for video calls
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 userName,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: AppFonts.appFont,
//                 ),
//               ),
//             ),
//           ],
//
//           // Timer for connected calls
//           if (isConnected)
//             Container(
//               margin: const EdgeInsets.only(top: 20),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 controller.timerString.value,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//           const Spacer(),
//
//           // Action buttons
//           CallActionButtons(
//             controller: controller,
//             isVideo: isVideo,
//           ),
//
//           const SizedBox(height: 100),
//         ],
//       );
//     });
//   }
//
//   String _getStatusText(CallState state) {
//     switch (state) {
//       case CallState.ringing:
//         return isIncoming ? AppStrings.incomingCall : AppStrings.calling;
//       case CallState.calling:
//         return AppStrings.connecting;
//       case CallState.connected:
//         return AppStrings.connected;
//       default:
//         return '';
//     }
//   }
// }



// important 2

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_buttons.dart';
// import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_ripple.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_dimen.dart';
// import '../../utils/app_enums.dart';
// import '../../utils/app_fonts.dart';
// import '../../utils/app_img.dart';
// import '../../utils/app_strings.dart';
// import 'audio_call_controller.dart';
//
// class CallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   final String? callId;
//   final String? channelName;
//   final String? token;
//   final int? uid;
//
//   const CallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     this.isVideo = false,
//     this.isIncoming = false,
//     this.callId,
//     this.channelName,
//     this.token,
//     this.uid,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       CallController(
//         userName: userName,
//         userAvatar: userAvatar,
//         receiverId: receiverId,
//         isVideo: isVideo,
//         isIncoming: isIncoming,
//         incomingCallId: callId,
//         incomingChannelName: channelName,
//         incomingToken: token,
//         incomingUid: uid,
//       ),
//       tag: '$userName-$receiverId-${DateTime.now().millisecondsSinceEpoch}',
//     );
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (isIncoming && controller.state.value == CallState.ringing) {
//           controller.rejectCall();
//         } else {
//           controller.endCall();
//         }
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Obx(() => Stack(
//           children: [
//             // Video views
//             if (isVideo) _buildVideoViews(controller),
//
//             // Semi-transparent overlay for better text visibility
//             if (isVideo) Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.3),
//                     Colors.black.withOpacity(0.6),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//
//             // Background for audio calls
//             if (!isVideo) _buildBackground(),
//
//             // Main content
//             SafeArea(
//               child: _buildContent(controller),
//             ),
//
//             // Loading indicator
//             if (controller.isLoading.value) _buildLoadingIndicator(),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildVideoViews(CallController controller) {
//     final agoraService = AgoraService.instance;
//
//     return Obx(() {
//       final isConnected = controller.state.value == CallState.connected;
//       final hasRemote = controller.remoteUid.value != null;
//       final showLocal = controller.showLocalPreview.value;
//
//       return Stack(
//         children: [
//           // Remote video (full screen when available)
//           if (isConnected && hasRemote)
//             Positioned.fill(
//               child: AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: agoraService.engine,
//                   canvas: VideoCanvas(uid: controller.remoteUid.value),
//                   connection: RtcConnection(
//                     channelId: controller.callData?.channelName ?? '',
//                   ),
//                 ),
//               ),
//             ),
//
//           // Local preview (small overlay when in video call)
//           if (showLocal && (isConnected || controller.state.value == CallState.calling))
//             Positioned(
//               top: 50,
//               right: 16,
//               child: Container(
//                 width: 100,
//                 height: 140,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.5),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     )
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: AgoraVideoView(
//                     controller: VideoViewController(
//                       rtcEngine: agoraService.engine,
//                       canvas: VideoCanvas(uid: controller.localUid ?? 0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//           // Default background when no video
//           if (!isConnected || !hasRemote)
//             Container(
//               color: Colors.black,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 60,
//                       backgroundImage: NetworkImage(userAvatar),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       userName,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       _getStatusText(controller.state.value),
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildBackground() {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Image.asset(
//             AppImages.callBg,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.callGradient1.withOpacity(0.9),
//                   AppColors.callGradient2.withOpacity(0.9),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black.withOpacity(0.7),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: AppColors.primaryColor),
//               const SizedBox(height: 16),
//               Text(
//                 'Connecting...',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(CallController controller) {
//     return Obx(() {
//       final state = controller.state.value;
//       final isConnected = state == CallState.connected;
//       final isVideoCall = isVideo;
//
//       // Show user info during ringing or for audio calls
//       final showUserInfo = !isVideoCall || !isConnected || state == CallState.ringing;
//
//       return Column(
//         children: [
//           const SizedBox(height: 20),
//
//           // Title (hidden when video is showing)
//           if (showUserInfo || !isVideoCall)
//             Text(
//               isVideo ? AppStrings.videoCall : AppStrings.audioCall,
//               style: TextStyle(
//                 color: AppColors.whiteColor,
//                 fontFamily: GoogleFonts.inter().fontFamily,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//
//           if (showUserInfo) ...[
//             const SizedBox(height: 80),
//
//             // Avatar with ripple for audio calls or ringing
//             if (!isVideoCall || state == CallState.ringing)
//               CallAvatarRipple(
//                 imageUrl: userAvatar,
//                 showRipple: !isConnected,
//               ),
//
//             const SizedBox(height: 20),
//
//             // Call status
//             Text(
//               _getStatusText(state),
//               style: TextStyle(
//                 color: AppColors.textColor3,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // User name
//             Text(
//               userName,
//               style: TextStyle(
//                 color: AppColors.textColor2,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: AppFonts.appFont,
//               ),
//             ),
//           ] else if (isVideoCall && isConnected) ...[
//             // User info overlay for video calls
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 userName,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//
//           // Timer for connected calls
//           if (isConnected)
//             Container(
//               margin: const EdgeInsets.only(top: 20),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 controller.timerString.value,
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//           const Spacer(),
//
//           // Action buttons
//           CallActionButtons(
//             controller: controller,
//             isVideo: isVideo,
//           ),
//
//           const SizedBox(height: 80),
//         ],
//       );
//     });
//   }
//
//   String _getStatusText(CallState state) {
//     switch (state) {
//       case CallState.ringing:
//         return isIncoming ? AppStrings.incomingCall : AppStrings.calling;
//       case CallState.calling:
//         return AppStrings.connecting;
//       case CallState.connected:
//         return AppStrings.connected;
//       default:
//         return '';
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_buttons.dart';
import 'package:the_friendz_zone/screens/audio_call/widgets/audio_call_ripple.dart';
import '../../config/app_colors.dart';
import '../../utils/agora_service.dart';
import '../../utils/app_enums.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_img.dart';
import '../../utils/app_strings.dart';
import 'audio_call_controller.dart';

class CallScreen extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String receiverId;
  final bool isVideo;
  final bool isIncoming;

  final String? callId;
  final String? channelName;
  final String? token;
  final int? uid;

  const CallScreen({
    required this.userName,
    required this.userAvatar,
    required this.receiverId,
    this.isVideo = false,
    this.isIncoming = false,
    this.callId,
    this.channelName,
    this.token,
    this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CallController(
        userName: userName,
        userAvatar: userAvatar,
        receiverId: receiverId,
        isVideo: isVideo,
        isIncoming: isIncoming,
        incomingCallId: callId,
        incomingChannelName: channelName,
        incomingToken: token,
        incomingUid: uid,
      ),
      tag: '$userName-$receiverId-${DateTime.now().millisecondsSinceEpoch}',
    );

    return WillPopScope(
      onWillPop: () async {
        if (isIncoming && controller.state.value == CallState.ringing) {
          controller.rejectCall();
        } else {
          controller.endCall();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() => Stack(
          children: [
            // Video views
            if (isVideo) _buildVideoViews(controller),

            // Background for audio
            if (!isVideo) _buildBackground(),

            // Gradient overlay
            if (isVideo)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

            // Content
            SafeArea(child: _buildContent(controller)),

            // Loading
            if (controller.isLoading.value) _buildLoadingIndicator(),
          ],
        )),
      ),
    );
  }

  Widget _buildVideoViews(CallController controller) {
    final agoraService = AgoraService.instance;

    return Obx(() {
      final hasRemote = controller.remoteUid.value != null;
      final isVideoOn = controller.isVideoOn.value;

      return Stack(
        children: [
          // ✅ Remote video (FULL SCREEN when available)
          if (hasRemote)
            Positioned.fill(
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: agoraService.engine,
                  canvas: VideoCanvas(
                    uid: controller.remoteUid.value!,
                    renderMode: RenderModeType.renderModeHidden,
                  ),
                  connection: RtcConnection(
                    channelId: controller.callData?.channelName ?? '',
                  ),
                ),
              ),
            ),

          // ✅ Local preview (Corner when remote exists OR full screen when waiting)
          if (isVideoOn)
            Positioned(
              top: hasRemote ? 60 : 0,
              right: hasRemote ? 16 : 0,
              left: hasRemote ? null : 0,
              bottom: hasRemote ? null : 0,
              width: hasRemote ? 100 : null,
              height: hasRemote ? 140 : null,
              child: Container(
                decoration: hasRemote
                    ? BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                    )
                  ],
                )
                    : null,
                child: ClipRRect(
                  borderRadius: hasRemote ? BorderRadius.circular(10) : BorderRadius.zero,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agoraService.engine,
                      canvas: VideoCanvas(
                        uid: 0,
                        renderMode: RenderModeType.renderModeHidden,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ✅ Show avatar when video is OFF
          if (!isVideoOn && !hasRemote)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userAvatar),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppImages.callBg, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.callGradient1.withOpacity(0.9),
                  AppColors.callGradient2.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget _buildContent(CallController controller) {
    return Obx(() {
      final state = controller.state.value;
      final isConnected = state == CallState.connected;

      return Column(
        children: [
          const SizedBox(height: 20),

          // Title
          Text(
            isVideo ? AppStrings.videoCall : AppStrings.audioCall,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (!isVideo || !isConnected) ...[
            const SizedBox(height: 80),

            // Avatar for audio calls
            if (!isVideo)
              CallAvatarRipple(
                imageUrl: userAvatar,
                showRipple: !isConnected,
              ),

            const SizedBox(height: 20),

            // Status
            Text(
              _getStatusText(state),
              style: TextStyle(
                color: AppColors.textColor3,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            // Name
            Text(
              userName,
              style: TextStyle(
                color: AppColors.textColor2,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.appFont,
              ),
            ),
          ] else ...[
            // Name overlay for video
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                userName,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          // Timer
          if (isConnected)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
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
            ),

          const Spacer(),

          // Action buttons
          CallActionButtons(
            controller: controller,
            isVideo: isVideo,
          ),

          const SizedBox(height: 80),
        ],
      );
    });
  }

  String _getStatusText(CallState state) {
    switch (state) {
      case CallState.ringing:
        return isIncoming ? AppStrings.incomingCall : AppStrings.calling;
      case CallState.calling:
        return AppStrings.connecting;
      case CallState.connected:
        return AppStrings.connected;
      default:
        return '';
    }
  }
}