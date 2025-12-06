// // import '../../../config/app_config.dart';
// // import '../audio_call_controller.dart';
// //
// // class AudioCallButtons extends StatelessWidget {
// //   final AudioCallState state;
// //   final VoidCallback onSpeaker;
// //   final VoidCallback onMute;
// //   final VoidCallback onEnd;
// //   final VoidCallback onAccept;
// //   final bool isMuted;
// //   final bool isSpeakerOn;
// //   final bool isVideo;
// //
// //   const AudioCallButtons({
// //     required this.state,
// //     required this.onSpeaker,
// //     required this.onMute,
// //     required this.onEnd,
// //     required this.onAccept,
// //     required this.isMuted,
// //     required this.isSpeakerOn,
// //     required this.isVideo,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (state == AudioCallState.incoming) {
// //       return Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           // Reject Button
// //           GestureDetector(
// //             onTap: onEnd,
// //             child: CircleAvatar(
// //               radius: AppDimens.dimen40,
// //               backgroundColor: AppColors.rejectBgColor,
// //               child: Image.asset(
// //                 AppImages.endCallIcon,
// //                 width: AppDimens.dimen32,
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: AppDimens.dimen40),
// //           // Accept Button
// //           GestureDetector(
// //             onTap: onAccept,
// //             child: CircleAvatar(
// //               radius: AppDimens.dimen40,
// //               backgroundColor: AppColors.greenColor,
// //               child: Image.asset(
// //                 AppImages.acceptCallIcon,
// //                 width: AppDimens.dimen32,
// //               ),
// //             ),
// //           ),
// //         ],
// //       );
// //     }
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         isVideo
// //             ?
// //             // Switch Camera Button
// //             Padding(
// //                 padding: EdgeInsets.only(right: AppDimens.dimen24),
// //                 child: GestureDetector(
// //                   onTap: onSpeaker,
// //                   child: CircleAvatar(
// //                     radius: AppDimens.dimen40,
// //                     backgroundColor: AppColors.callBg,
// //                     child: Image.asset(
// //                       AppImages.recIcon,
// //                       width: AppDimens.dimen40,
// //                     ),
// //                   ),
// //                 ),
// //               )
// //             : SizedBox.shrink(),
// //         // Speaker Button
// //         GestureDetector(
// //           onTap: onSpeaker,
// //           child: CircleAvatar(
// //             radius: AppDimens.dimen40,
// //             backgroundColor: AppColors.callBg,
// //             child: Image.asset(
// //               isSpeakerOn ? AppImages.speakerOnIcon : AppImages.speakerOnIcon,
// //               width: AppDimens.dimen40,
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: AppDimens.dimen24),
// //         // Mute Button
// //         GestureDetector(
// //           onTap: onMute,
// //           child: CircleAvatar(
// //             radius: AppDimens.dimen40,
// //             backgroundColor: AppColors.callBg,
// //             child: Image.asset(
// //               isMuted ? AppImages.micOffIcon : AppImages.micOffIcon,
// //               width: AppDimens.dimen40,
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: AppDimens.dimen24),
// //         // End Call Button
// //         GestureDetector(
// //           onTap: onEnd,
// //           child: CircleAvatar(
// //             radius: AppDimens.dimen40,
// //             backgroundColor: AppColors.rejectBgColor,
// //             child: Image.asset(
// //               AppImages.endCallIcon,
// //               width: AppDimens.dimen55,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../config/app_config.dart';
// import '../audio_call_controller.dart';
//
// class CallActionButtons extends StatelessWidget {
//   final CallController controller;
//   final bool isVideo;
//
//   const CallActionButtons({
//     required this.controller,
//     required this.isVideo,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final state = controller.state.value;
//
//       if (state == CallState.ringing) {
//         return _buildIncomingCallButtons();
//       }
//
//       return _buildActiveCallButtons();
//     });
//   }
//
//   Widget _buildIncomingCallButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // // Reject
//         // _buildActionButton(
//         //   icon: AppImages.endCallIcon,
//         //   backgroundColor: AppColors.rejectBgColor,
//         //   onTap: controller.rejectCall,
//         // ),
//         // SizedBox(width: AppDimens.dimen40),
//         // // Accept
//         // _buildActionButton(
//         //   icon: AppImages.acceptCallIcon,
//         //   backgroundColor: AppColors.greenColor,
//         //   onTap: controller.acceptCall,
//         // ),
//       ],
//     );
//   }
//
//   Widget _buildActiveCallButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Switch Camera (video only)
//         if (isVideo) ...[
//           _buildActionButton(
//             icon: AppImages.recIcon,
//             backgroundColor: AppColors.callBg,
//             onTap: controller.switchCamera,
//           ),
//           SizedBox(width: AppDimens.dimen24),
//         ],
//
//         // Speaker
//         _buildActionButton(
//           icon: controller.isSpeakerOn.value
//               ? AppImages.speakerOnIcon
//               : AppImages.speakerOnIcon,
//           backgroundColor: AppColors.callBg,
//           onTap: controller.toggleSpeaker,
//         ),
//         SizedBox(width: AppDimens.dimen24),
//
//         // Mute
//         _buildActionButton(
//           icon: controller.isMuted.value
//               ? AppImages.micOffIcon
//               : AppImages.micOffIcon,
//           backgroundColor: AppColors.callBg,
//           onTap: controller.toggleMute,
//         ),
//         SizedBox(width: AppDimens.dimen24),
//
//         // End Call
//         _buildActionButton(
//           icon: AppImages.endCallIcon,
//           backgroundColor: AppColors.rejectBgColor,
//           onTap: controller.endCall,
//           size: AppDimens.dimen55,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required String icon,
//     required Color backgroundColor,
//     required VoidCallback onTap,
//     double? size,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: AppDimens.dimen40,
//         backgroundColor: backgroundColor,
//         child: Image.asset(
//           icon,
//           width: size ?? AppDimens.dimen40,
//           height: size ?? AppDimens.dimen40,
//         ),
//       ),
//     );
//   }
// }




//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../config/app_config.dart';
// import '../../../utils/app_enums.dart';
// import '../audio_call_controller.dart';
//
// class CallActionButtons extends StatelessWidget {
//   final CallController controller;
//   final bool isVideo;
//
//   const CallActionButtons({
//     required this.controller,
//     required this.isVideo,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final state = controller.state.value;
//
//       // ✅ Show Accept/Reject for incoming calls
//       if (state == CallState.ringing) {
//         return _buildIncomingCallButtons();
//       }
//
//       // Show regular call controls
//       return _buildActiveCallButtons();
//     });
//   }
//
//   Widget _buildIncomingCallButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Reject
//         _buildActionButton(
//           icon: AppImages.endCallIcon,
//           backgroundColor: AppColors.rejectBgColor,
//           onTap: controller.rejectCall,
//         ),
//         SizedBox(width: AppDimens.dimen40),
//         // Accept
//         _buildActionButton(
//           icon: AppImages.acceptCallIcon,
//           backgroundColor: AppColors.greenColor,
//           onTap: controller.acceptCall,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActiveCallButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Switch Camera (video only)
//         if (isVideo) ...[
//           _buildActionButton(
//             icon: AppImages.recIcon,
//             backgroundColor: AppColors.callBg,
//             onTap: controller.switchCamera,
//           ),
//           SizedBox(width: AppDimens.dimen24),
//         ],
//
//         // Speaker
//         _buildActionButton(
//           icon: controller.isSpeakerOn.value
//               ? AppImages.speakerOnIcon
//               : AppImages.speakerOffIcon,
//           backgroundColor: AppColors.callBg,
//           onTap: controller.toggleSpeaker,
//         ),
//         SizedBox(width: AppDimens.dimen24),
//
//         // Mute
//         _buildActionButton(
//           icon: controller.isMuted.value
//               ? AppImages.micOnIcon
//               : AppImages.micOffIcon,
//           backgroundColor: AppColors.callBg,
//           onTap: controller.toggleMute,
//         ),
//         SizedBox(width: AppDimens.dimen24),
//
//         // End Call
//         _buildActionButton(
//           icon: AppImages.endCallIcon,
//           backgroundColor: AppColors.rejectBgColor,
//           onTap: controller.endCall,
//           size: AppDimens.dimen55,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required String icon,
//     required Color backgroundColor,
//     required VoidCallback onTap,
//     double? size,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: AppDimens.dimen40,
//         backgroundColor: backgroundColor,
//         child: Image.asset(
//           icon,
//           width: size ?? AppDimens.dimen40,
//           height: size ?? AppDimens.dimen40,
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../config/app_config.dart';
// import '../../../utils/app_enums.dart';
// import '../audio_call_controller.dart';
//
// class CallActionButtons extends StatelessWidget {
//   final CallController controller;
//   final bool isVideo;
//
//   const CallActionButtons({
//     required this.controller,
//     required this.isVideo,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final state = controller.state.value;
//
//       if (state == CallState.ringing) {
//         return _buildIncomingCallButtons();
//       }
//
//       return _buildActiveCallButtons();
//     });
//   }
//
//   Widget _buildIncomingCallButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildActionButton(
//           icon: AppImages.endCallIcon,
//           backgroundColor: AppColors.rejectBgColor,
//           onTap: controller.rejectCall,
//         ),
//         SizedBox(width: AppDimens.dimen40),
//         _buildActionButton(
//           icon: AppImages.acceptCallIcon,
//           backgroundColor: AppColors.greenColor,
//           onTap: controller.acceptCall,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActiveCallButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // ✅ Video toggle (only for video calls)
//         if (isVideo) ...[
//           _buildActionButton(
//             icon: controller.isVideoOn.value
//                 ? AppImages.videoOnIcon // Add this icon
//                 : AppImages.videoOffIcon, // Add this icon
//             backgroundColor: AppColors.callBg,
//             onTap: controller.toggleVideo,
//           ),
//           SizedBox(width: AppDimens.dimen24),
//         ],
//
//         // Switch Camera
//         if (isVideo) ...[
//           _buildActionButton(
//             icon: AppImages.recIcon,
//             backgroundColor: AppColors.callBg,
//             onTap: controller.switchCamera,
//           ),
//           SizedBox(width: AppDimens.dimen24),
//         ],
//
//         // Speaker
//         _buildActionButton(
//           icon: controller.isSpeakerOn.value
//               ? AppImages.speakerOnIcon
//               : AppImages.speakerOffIcon,
//           backgroundColor: AppColors.callBg,
//           onTap: controller.toggleSpeaker,
//         ),
//         SizedBox(width: AppDimens.dimen24),
//
//         // Mute
//         _buildActionButton(
//           icon: controller.isMuted.value
//               ? AppImages.micOnIcon
//               : AppImages.micOffIcon,
//           backgroundColor: AppColors.callBg,
//           onTap: controller.toggleMute,
//         ),
//         SizedBox(width: AppDimens.dimen24),
//
//         // End Call
//         _buildActionButton(
//           icon: AppImages.endCallIcon,
//           backgroundColor: AppColors.rejectBgColor,
//           onTap: controller.endCall,
//           size: AppDimens.dimen55,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required String icon,
//     required Color backgroundColor,
//     required VoidCallback onTap,
//     double? size,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: AppDimens.dimen40,
//         backgroundColor: backgroundColor,
//         child: Image.asset(
//           icon,
//           width: size ?? AppDimens.dimen40,
//           height: size ?? AppDimens.dimen40,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../../../utils/app_enums.dart';
import '../audio_call_controller.dart';

class CallActionButtons extends StatelessWidget {
  final CallController controller;
  final bool isVideo;

  const CallActionButtons({
    required this.controller,
    required this.isVideo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      if (state == CallState.ringing) {
        return _buildIncomingCallButtons();
      }

      return _buildActiveCallButtons();
    });
  }

  Widget _buildIncomingCallButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: AppImages.endCallIcon,
          backgroundColor: AppColors.rejectBgColor,
          onTap: controller.rejectCall,
        ),
        SizedBox(width: AppDimens.dimen40),
        _buildActionButton(
          icon: AppImages.acceptCallIcon,
          backgroundColor: AppColors.greenColor,
          onTap: controller.acceptCall,
        ),
      ],
    );
  }

  Widget _buildActiveCallButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: isVideo ? _buildVideoCallButtons() : _buildAudioCallButtons(),
    );
  }

  // ✅ Audio call buttons (4 buttons)
  Widget _buildAudioCallButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Speaker
        _buildActionButton(
          icon: controller.isSpeakerOn.value
              ? AppImages.speakerOnIcon
              : AppImages.speakerOffIcon,
          backgroundColor: AppColors.callBg,
          onTap: controller.toggleSpeaker,
        ),

        // Mute
        _buildActionButton(
          icon: controller.isMuted.value
              ? AppImages.micOnIcon
              : AppImages.micOffIcon,
          backgroundColor: AppColors.callBg,
          onTap: controller.toggleMute,
        ),

        // End Call
        _buildActionButton(
          icon: AppImages.endCallIcon,
          backgroundColor: AppColors.rejectBgColor,
          onTap: controller.endCall,
          size: AppDimens.dimen55,
        ),
      ],
    );
  }

  // ✅ Video call buttons (5 buttons in 2 rows)
  Widget _buildVideoCallButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First row: Video toggle, Camera switch, Speaker
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Video toggle
            _buildActionButton(
              icon: controller.isVideoOn.value
                  ? Icons.videocam
                  : Icons.videocam_off,
              backgroundColor: controller.isVideoOn.value
                  ? AppColors.callBg
                  : AppColors.rejectBgColor,
              onTap: controller.toggleVideo,
              isIcon: true,
            ),
            SizedBox(width: AppDimens.dimen20),

            // Camera switch
            _buildActionButton(
              icon: AppImages.recIcon,
              backgroundColor: AppColors.callBg,
              onTap: controller.switchCamera,
            ),
            SizedBox(width: AppDimens.dimen20),

            // Speaker
            _buildActionButton(
              icon: controller.isSpeakerOn.value
                  ? AppImages.speakerOnIcon
                  : AppImages.speakerOffIcon,
              backgroundColor: AppColors.callBg,
              onTap: controller.toggleSpeaker,
            ),
          ],
        ),

        SizedBox(height: AppDimens.dimen20),

        // Second row: Mute and End Call
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mute
            _buildActionButton(
              icon: controller.isMuted.value
                  ? AppImages.micOnIcon
                  : AppImages.micOffIcon,
              backgroundColor: AppColors.callBg,
              onTap: controller.toggleMute,
            ),
            SizedBox(width: AppDimens.dimen40),

            // End Call (larger)
            _buildActionButton(
              icon: AppImages.endCallIcon,
              backgroundColor: AppColors.rejectBgColor,
              onTap: controller.endCall,
              size: AppDimens.dimen60,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required dynamic icon,
    required Color backgroundColor,
    required VoidCallback onTap,
    double? size,
    bool isIcon = false,
  }) {
    final radius = size != null ? size / 2 : AppDimens.dimen40;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: isIcon
            ? Icon(
          icon as IconData,
          color: AppColors.whiteColor,
          size: size ?? AppDimens.dimen40 * 0.6,
        )
            : Image.asset(
          icon as String,
          width: size ?? AppDimens.dimen40,
          height: size ?? AppDimens.dimen40,
        ),
      ),
    );
  }
}