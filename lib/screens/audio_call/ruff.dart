// import '../../config/app_config.dart';
//
// enum AudioCallState { incoming, calling, connected }
//
// class AudioCallController extends GetxController {
//   final RxString callerName;
//   final RxString profileImage;
//   final bool isVideo;
//   var state = AudioCallState.calling.obs;
//   var timerString = '00:00'.obs;
//   var isMuted = false.obs;
//   var isSpeakerOn = false.obs;
//
//   Timer? _timer;
//   int _seconds = 0;
//
//   AudioCallController({
//     required String callerName,
//     required String profileImage,
//     this.isVideo = false,
//   })  : callerName = callerName.obs,
//         profileImage = profileImage.obs;
//
//   void acceptCall() {
//     state.value = AudioCallState.connected;
//     _startTimer();
//   }
//
//   void endCall() {
//     _timer?.cancel();
//     Get.back();
//   }
//
//   void toggleMute() => isMuted.value = !isMuted.value;
//
//   void toggleSpeaker() => isSpeakerOn.value = !isSpeakerOn.value;
//
//   void _startTimer() {
//     _timer?.cancel();
//     _seconds = 0;
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       _seconds++;
//       final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_seconds % 60).toString().padLeft(2, '0');
//       timerString.value = "$minutes:$seconds";
//     });
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }



// import '../../config/app_config.dart';
// import 'audio_call_controller.dart';
// import 'widgets/audio_call_ripple.dart';
// import 'widgets/audio_call_buttons.dart';
//
// class AudioCallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final bool isVideo;
//
//   AudioCallScreen({
//     required this.userName,
//     required this.userAvatar,
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
//         isVideo: isVideo,
//       ),
//       tag: userName,
//     );
//
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: Obx(
//         () => Stack(
//           children: [
//             // Background Image
//             Positioned.fill(
//               child: Image.asset(
//                 AppImages.callBg,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // Gradient Overlay (only for incoming/calling)
//             if (controller.state.value != AudioCallState.connected)
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.callGradient1.withOpacity(1),
//                         AppColors.callGradient2.withOpacity(1),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//               ),
//             // Background Image with opacity
//             Positioned.fill(
//               child: Image.asset(
//                 AppImages.callBg,
//                 fit: BoxFit.cover,
//                 opacity: const AlwaysStoppedAnimation(0.9),
//               ),
//             ),
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
// }
//
// // Animated content for avatar, subtitle, and name
// class _AnimatedCallContent extends StatefulWidget {
//   final AudioCallController controller;
//   final bool isVideo;
//
//   const _AnimatedCallContent(
//       {required this.controller, required this.isVideo, Key? key})
//       : super(key: key);
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
//         isConnected: widget.controller.state.value == AudioCallState.connected);
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
//           isConnected:
//               widget.controller.state.value == AudioCallState.connected);
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
//     return Column(
//       children: [
//         SizedBox(height: AppDimens.dimen45),
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
//         SizedBox(height: AppDimens.dimen120),
//         // Animated Avatar
//         AnimatedBuilder(
//           animation: _animController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _avatarOffset.value),
//               child: Transform.scale(
//                 scale: _avatarScale.value,
//                 child: Opacity(
//                   opacity: _opacity.value,
//                   child: AudioCallRipple(
//                     imageUrl: controller.profileImage.value,
//                     showRipple:
//                         controller.state.value != AudioCallState.connected,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // Animated Subtitle
//         AnimatedBuilder(
//           animation: _animController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _subtitleOffset.value),
//               child: Opacity(
//                 opacity: _opacity.value,
//                 child: Text(
//                   controller.state.value == AudioCallState.incoming
//                       ? AppStrings.incomingCall
//                       : controller.state.value == AudioCallState.calling
//                           ? AppStrings.connecting
//                           : AppStrings.connected,
//                   style: TextStyle(
//                     color: AppColors.textColor3,
//                     fontSize: FontDimen.dimen16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(height: AppDimens.dimen10),
//         // Animated Name
//         AnimatedBuilder(
//           animation: _animController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _nameOffset.value),
//               child: Opacity(
//                 opacity: _opacity.value,
//                 child: Text(
//                   controller.callerName.value,
//                   style: TextStyle(
//                     color: AppColors.textColor2,
//                     fontSize: FontDimen.dimen24,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: AppFonts.appFont,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(height: AppDimens.dimen32),
//         // Timer (only for connected)
//         Obx(() => controller.state.value == AudioCallState.connected
//             ? Text(
//                 controller.timerString.value,
//                 style: TextStyle(
//                   color: AppColors.textColor2,
//                   fontSize: FontDimen.dimen20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               )
//             : SizedBox.shrink()),
//         Spacer(),
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
//         SizedBox(height: AppDimens.dimen100),
//       ],
//     );
//   }
// }

//
// import '../../config/app_config.dart';
// import 'audio_call_controller.dart';
// import 'widgets/audio_call_ripple.dart';
// import 'widgets/audio_call_buttons.dart';
//
// class AudioCallScreen extends StatelessWidget {
//   final String userName;
//   final String userAvatar;
//   final String receiverId; // Added receiver ID parameter
//   final bool isVideo;
//
//   AudioCallScreen({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId, // Required parameter
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
//         receiverId: receiverId, // Pass receiver ID to controller
//         isVideo: isVideo,
//       ),
//       tag: userName,
//     );
//
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: Obx(
//             () => Stack(
//           children: [
//             // Background Image
//             Positioned.fill(
//               child: Image.asset(
//                 AppImages.callBg,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // Gradient Overlay (only for incoming/calling)
//             if (controller.state.value != AudioCallState.connected)
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.callGradient1.withOpacity(1),
//                         AppColors.callGradient2.withOpacity(1),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//               ),
//             // Background Image with opacity
//             Positioned.fill(
//               child: Image.asset(
//                 AppImages.callBg,
//                 fit: BoxFit.cover,
//                 opacity: const AlwaysStoppedAnimation(0.9),
//               ),
//             ),
//             // Loading indicator while creating call
//             if (controller.isCallCreating.value)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black54,
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(
//                           color: AppColors.primaryColor,
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Connecting...',
//                           style: TextStyle(
//                             color: AppColors.whiteColor,
//                             fontSize: FontDimen.dimen16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
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
// }
//
// // Animated content for avatar, subtitle, and name
// class _AnimatedCallContent extends StatefulWidget {
//   final AudioCallController controller;
//   final bool isVideo;
//
//   const _AnimatedCallContent(
//       {required this.controller, required this.isVideo, Key? key})
//       : super(key: key);
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
//         isConnected: widget.controller.state.value == AudioCallState.connected);
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
//           isConnected:
//           widget.controller.state.value == AudioCallState.connected);
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
//     return Column(
//       children: [
//         SizedBox(height: AppDimens.dimen45),
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
//         SizedBox(height: AppDimens.dimen120),
//         // Animated Avatar
//         AnimatedBuilder(
//           animation: _animController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _avatarOffset.value),
//               child: Transform.scale(
//                 scale: _avatarScale.value,
//                 child: Opacity(
//                   opacity: _opacity.value,
//                   child: AudioCallRipple(
//                     imageUrl: controller.profileImage.value,
//                     showRipple:
//                     controller.state.value != AudioCallState.connected,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // Animated Subtitle
//         AnimatedBuilder(
//           animation: _animController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _subtitleOffset.value),
//               child: Opacity(
//                 opacity: _opacity.value,
//                 child: Text(
//                   controller.state.value == AudioCallState.incoming
//                       ? AppStrings.incomingCall
//                       : controller.state.value == AudioCallState.calling
//                       ? AppStrings.connecting
//                       : AppStrings.connected,
//                   style: TextStyle(
//                     color: AppColors.textColor3,
//                     fontSize: FontDimen.dimen16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(height: AppDimens.dimen10),
//         // Animated Name
//         AnimatedBuilder(
//           animation: _animController,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _nameOffset.value),
//               child: Opacity(
//                 opacity: _opacity.value,
//                 child: Text(
//                   controller.callerName.value,
//                   style: TextStyle(
//                     color: AppColors.textColor2,
//                     fontSize: FontDimen.dimen24,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: AppFonts.appFont,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(height: AppDimens.dimen32),
//         // Timer (only for connected)
//         Obx(() => controller.state.value == AudioCallState.connected
//             ? Text(
//           controller.timerString.value,
//           style: TextStyle(
//             color: AppColors.textColor2,
//             fontSize: FontDimen.dimen20,
//             fontWeight: FontWeight.w600,
//           ),
//         )
//             : SizedBox.shrink()),
//         Spacer(),
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
//         SizedBox(height: AppDimens.dimen100),
//       ],
//     );
//   }
// }
