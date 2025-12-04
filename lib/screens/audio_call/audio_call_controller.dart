//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../api_helpers/api_manager.dart';
// import '../../api_helpers/api_param.dart';
// import '../../api_helpers/api_utils.dart';
// import '../../config/app_colors.dart';
// import '../../helpers/storage_helper.dart';
// import 'call_response_model.dart';
//
// enum AudioCallState { incoming, calling, connected }
//
// class AudioCallController extends GetxController {
//   final RxString callerName;
//   final RxString profileImage;
//   final String receiverId;
//   final bool isVideo;
//
//   var state = AudioCallState.calling.obs;
//   var timerString = '00:00'.obs;
//   var isMuted = false.obs;
//   var isSpeakerOn = false.obs;
//   var isCallCreating = false.obs;
//   var remoteUid = Rxn<int>(); // Remote user ID
//   var isJoined = false.obs; // Channel join status
//
//   Timer? _timer;
//   int _seconds = 0;
//
//   // Call data from API
//   CallData? callData;
//   String? currentCallId;
//
//   // Agora Engine
//   RtcEngine? _engine;
//   bool _isEngineInitialized = false;
//
//   // Agora App ID (hardcoded as fallback)
//   static const String AGORA_APP_ID = "f56586e9820243778c9b0159f2d4ddd2";
//
//   AudioCallController({
//     required String callerName,
//     required String profileImage,
//     required this.receiverId,
//     this.isVideo = false,
//   })  : callerName = callerName.obs,
//         profileImage = profileImage.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCall();
//   }
//
//   // ===================== INITIALIZE CALL FLOW =====================
//   Future<void> _initializeCall() async {
//     // Step 1: Request permissions
//     await _requestPermissions();
//
//     // Step 2: Create call via API
//     await createCall();
//
//     // Step 3: Initialize Agora if call was created
//     if (callData != null) {
//       await _initializeAgora();
//     }
//   }
//
//   // ===================== PERMISSION HANDLING =====================
//   Future<void> _requestPermissions() async {
//     try {
//       debugPrint("━━━━━━━━━━━━━━━ REQUESTING PERMISSIONS ━━━━━━━━━━━━━━━");
//
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.microphone,
//         if (isVideo) Permission.camera,
//       ].request();
//
//       bool allGranted = statuses.values.every((status) => status.isGranted);
//
//       if (!allGranted) {
//         debugPrint("❌ Permissions not granted");
//         Get.snackbar(
//           "Permissions Required",
//           "Please grant ${isVideo ? 'camera and microphone' : 'microphone'} permissions to continue",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//         );
//
//         Future.delayed(Duration(seconds: 2), () {
//           Get.back();
//         });
//         return;
//       }
//
//       debugPrint("✅ All permissions granted");
//       debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
//     } catch (e) {
//       debugPrint("❌ Permission request error: $e");
//     }
//   }
//
//   // ===================== CREATE CALL API =====================
//   Future<void> createCall() async {
//     print('createCall called');
//
//     try {
//       isCallCreating.value = true;
//
//       String currentUserId = StorageHelper().getUserId.toString();
//       String callType = isVideo ? 'video' : 'audio';
//
//       print('━━━━━━━━━━━━━━━ CREATE CALL DEBUG ━━━━━━━━━━━━━━━');
//       print('📞 Caller ID: $currentUserId');
//       print('👤 Receiver ID: $receiverId');
//       print('🎬 Call Type: $callType');
//
//       Map<String, dynamic> body = {
//         ApiParam.request: 'create_call',
//         ApiParam.callerId: currentUserId,
//         ApiParam.receiverId: receiverId,
//         ApiParam.callType: callType,
//       };
//
//       print('📋 Create Call Body: $body');
//
//       var result = await ApiManager.callPostWithFormData(
//         body: body,
//         endPoint: ApiUtils.createCall,
//       );
//
//       isCallCreating.value = false;
//
//       print('📥 API Response: $result');
//
//       if (result['status'] == 'success') {
//         final callResponse = CallResponseModel.fromJson(result);
//
//         callData = callResponse.data;
//         currentCallId = callData?.callId.toString();
//
//         print('✅ Call Created Successfully');
//         print('📋 Call ID: ${callData?.callId}');
//         print('🔗 Channel: ${callData?.channelName}');
//         print('🎫 Token: ${callData?.token}');
//         print('🆔 UID: ${callData?.uid}');
//
//         Get.snackbar(
//           "Success",
//           callResponse.message ?? "Call created successfully",
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//           duration: const Duration(seconds: 2),
//         );
//       } else {
//         print("❌ Call creation failed: ${result['message']}");
//
//         Get.snackbar(
//           "Error",
//           result['message'] ?? "Failed to create call",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//           colorText: AppColors.whiteColor,
//           margin: const EdgeInsets.all(15),
//         );
//
//         Future.delayed(Duration(seconds: 2), () {
//           Get.back();
//         });
//       }
//
//       print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//     } catch (e, s) {
//       isCallCreating.value = false;
//       print('❌ Create Call Error: $e');
//       print(s);
//
//       Get.snackbar(
//         "Error",
//         "Error creating call: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//       );
//
//       Future.delayed(Duration(seconds: 2), () {
//         Get.back();
//       });
//     }
//   }
//
//   // ===================== INITIALIZE AGORA =====================
//   Future<void> _initializeAgora() async {
//     try {
//       debugPrint("━━━━━━━━━━━━━━━ INITIALIZING AGORA ━━━━━━━━━━━━━━━");
//
//       // Use App ID from response or fallback to hardcoded
//       final appId = AGORA_APP_ID;
//
//       if (appId.isEmpty) {
//         debugPrint("❌ No App ID available");
//         return;
//       }
//
//       // Create Agora Engine
//       _engine = createAgoraRtcEngine();
//
//       await _engine!.initialize(RtcEngineContext(
//         appId: appId,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ));
//
//       debugPrint("✅ Agora engine initialized with App ID: $appId");
//
//       // Register event handlers
//       _engine!.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint("✅ Successfully joined channel: ${connection.channelId}");
//             isJoined.value = true;
//             // Auto accept call when joined
//             acceptCall();
//           },
//           onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//             debugPrint("👤 Remote user joined: $remoteUid");
//             this.remoteUid.value = remoteUid;
//           },
//           onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//             debugPrint("👋 Remote user left: $remoteUid");
//             this.remoteUid.value = null;
//           },
//           onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//             debugPrint("📤 Left channel");
//             isJoined.value = false;
//             remoteUid.value = null;
//           },
//           onError: (ErrorCodeType err, String msg) {
//             debugPrint("❌ Agora error: $err - $msg");
//           },
//           onConnectionStateChanged: (RtcConnection connection,
//               ConnectionStateType state,
//               ConnectionChangedReasonType reason) {
//             debugPrint("🔗 Connection state changed: $state - $reason");
//           },
//         ),
//       );
//
//       // Enable audio by default
//       await _engine!.enableAudio();
//
//       // Enable video if video call
//       if (isVideo) {
//         await _engine!.enableVideo();
//         // Enable local video preview
//         await _engine!.startPreview();
//         debugPrint("📹 Video enabled");
//       } else {
//         await _engine!.disableVideo();
//         debugPrint("🔇 Video disabled (audio only)");
//       }
//
//       // Set audio profile for better quality
//       await _engine!.setAudioProfile(
//         profile: AudioProfileType.audioProfileDefault,
//         scenario: AudioScenarioType.audioScenarioChatroom,
//       );
//
//       // Enable speaker by default for video calls
//       if (isVideo) {
//         await _engine!.setEnableSpeakerphone(true);
//         isSpeakerOn.value = true;
//       }
//
//       _isEngineInitialized = true;
//       debugPrint("✅ Agora engine fully configured");
//
//       // Auto join channel
//       await _joinChannel();
//
//       debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
//     } catch (e) {
//       debugPrint("❌ Agora initialization error: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to initialize call engine: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//       );
//     }
//   }
//
//   // ===================== JOIN CHANNEL =====================
//   Future<void> _joinChannel() async {
//     try {
//       if (!_isEngineInitialized || callData == null) {
//         debugPrint("❌ Cannot join: Engine not initialized or no call data");
//         return;
//       }
//
//       debugPrint("━━━━━━━━━━━━━━━ JOINING CHANNEL ━━━━━━━━━━━━━━━");
//       debugPrint("🔗 Channel: ${callData!.channelName}");
//       debugPrint("🎫 Token: ${callData!.token}");
//       debugPrint("🆔 UID: ${callData!.uid}");
//
//       ChannelMediaOptions options = ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: isVideo,
//         publishMicrophoneTrack: true,
//         publishCameraTrack: isVideo,
//       );
//
//       await _engine!.joinChannel(
//         token: callData!.token!,
//         channelId: callData!.channelName!,
//         uid: callData!.uid!,
//         options: options,
//       );
//
//       debugPrint("📞 Join channel request sent");
//       debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
//     } catch (e) {
//       debugPrint("❌ Join channel error: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to join call: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
//         colorText: AppColors.whiteColor,
//         margin: const EdgeInsets.all(15),
//       );
//     }
//   }
//
//   // ===================== END CALL API =====================
//   Future<void> _endCall() async {
//     if (currentCallId == null) {
//       print("⚠️ No call ID available to end");
//       return;
//     }
//
//     print('endCall called');
//     print('Call ID: $currentCallId');
//
//     try {
//       final String currentUserId = StorageHelper().getUserId.toString();
//
//       Map<String, dynamic> body = {
//         ApiParam.request: 'end_call',
//         ApiParam.userId: currentUserId,
//         ApiParam.callId: currentCallId,
//       };
//
//       print('End Call Body: $body');
//
//       var result = await ApiManager.callPostWithFormData(
//         body: body,
//         endPoint: ApiUtils.endCall,
//       );
//
//       print('API Response: $result');
//
//       if (result['status'] == 'success') {
//         print("✅ Call ended successfully");
//       } else {
//         print("❌ End call failed: ${result['message']}");
//       }
//     } catch (e, s) {
//       print('❌ End Call Error: $e');
//       print(s);
//     }
//   }
//
//   // ===================== CALL ACTIONS =====================
//   void acceptCall() {
//     state.value = AudioCallState.connected;
//     _startTimer();
//   }
//
//   Future<void> endCall() async {
//     _timer?.cancel();
//
//     // Leave Agora channel
//     await _leaveChannel();
//
//     // Call the end call API
//     await _endCall();
//
//     // Navigate back
//     Get.back();
//   }
//
//   Future<void> toggleMute() async {
//     try {
//       isMuted.value = !isMuted.value;
//       await _engine?.muteLocalAudioStream(isMuted.value);
//       debugPrint("🔇 Mute toggled: ${isMuted.value}");
//     } catch (e) {
//       debugPrint("❌ Toggle mute error: $e");
//     }
//   }
//
//   Future<void> toggleSpeaker() async {
//     try {
//       isSpeakerOn.value = !isSpeakerOn.value;
//       await _engine?.setEnableSpeakerphone(isSpeakerOn.value);
//       debugPrint("🔊 Speaker toggled: ${isSpeakerOn.value}");
//     } catch (e) {
//       debugPrint("❌ Toggle speaker error: $e");
//     }
//   }
//
//   Future<void> switchCamera() async {
//     try {
//       if (isVideo) {
//         await _engine?.switchCamera();
//         debugPrint("📸 Camera switched");
//       }
//     } catch (e) {
//       debugPrint("❌ Switch camera error: $e");
//     }
//   }
//
//   // ===================== LEAVE CHANNEL =====================
//   Future<void> _leaveChannel() async {
//     try {
//       if (_isEngineInitialized && _engine != null) {
//         await _engine!.leaveChannel();
//         debugPrint("📤 Left Agora channel");
//       }
//     } catch (e) {
//       debugPrint("❌ Leave channel error: $e");
//     }
//   }
//
//   // ===================== TIMER =====================
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
//   // ===================== CLEANUP =====================
//   @override
//   void onClose() {
//     _timer?.cancel();
//
//     // Leave channel and cleanup
//     _leaveChannel();
//
//     // Release Agora engine
//     if (_isEngineInitialized && _engine != null) {
//       _engine!.release();
//       debugPrint("🧹 Agora engine released");
//     }
//
//     // End call API
//     if (currentCallId != null) {
//       _endCall();
//     }
//
//     super.onClose();
//   }
// }
//


// audio_call_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../api_helpers/api_manager.dart';
import '../../api_helpers/api_param.dart';
import '../../api_helpers/api_utils.dart';
import '../../config/app_colors.dart';
import '../../helpers/storage_helper.dart';
import 'call_response_model.dart';

enum AudioCallState { incoming, calling, connected }

class AudioCallController extends GetxController {
  final RxString callerName;
  final RxString profileImage;
  final String receiverId;
  final bool isVideo;
  final bool isCaller;

  var state = AudioCallState.calling.obs;
  var timerString = '00:00'.obs;
  var isMuted = false.obs;
  var isSpeakerOn = false.obs;
  var isCallCreating = false.obs;
  var remoteUid = Rxn<int>();
  var isJoined = false.obs;

  Timer? _timer;
  int _seconds = 0;

  CallData? callData;
  String? currentCallId;

  RtcEngine? _engine;
  bool _isEngineInitialized = false;

  int? localUid;

  static const String AGORA_APP_ID = "f56586e9820243778c9b0159f2d4ddd2";

  AudioCallController({
    required String callerName,
    required String profileImage,
    required this.receiverId,
    this.isVideo = false,
    this.isCaller = false,
  })  : callerName = callerName.obs,
        profileImage = profileImage.obs;

  // Public engine getter
  RtcEngine get engine {
    if (_engine == null) throw Exception("Agora engine not initialized yet");
    return _engine!;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeCall();
  }

  // ===================== INITIALIZE CALL =====================
  Future<void> _initializeCall() async {
    await _requestPermissions();
    await createCall();
    if (callData != null) {
      await _initializeAgora();
    }
  }

  // ===================== PERMISSIONS =====================
  Future<void> _requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        if (isVideo) Permission.camera,
      ].request();

      if (!statuses.values.every((e) => e.isGranted)) {
        Get.snackbar(
          "Permissions Required",
          isVideo ? "Camera & Microphone required" : "Microphone required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
          colorText: AppColors.whiteColor,
        );
        return;
      }
    } catch (e) {
      debugPrint("❌ Permission error: $e");
    }
  }

  // ===================== CREATE CALL API =====================
  Future<void> createCall() async {
    try {
      isCallCreating.value = true;

      String currentUserId = StorageHelper().getUserId.toString();
      Map<String, dynamic> body = {
        ApiParam.request: 'create_call',
        ApiParam.callerId: currentUserId,
        ApiParam.receiverId: receiverId,
        ApiParam.callType: isVideo ? 'video' : 'audio',
      };

      var result = await ApiManager.callPostWithFormData(
        body: body,
        endPoint: ApiUtils.createCall,
      );

      isCallCreating.value = false;

      if (result != null && result['status'] == 'success') {
        final callResponse = CallResponseModel.fromJson(result);
        callData = callResponse.data;
        currentCallId = callData?.callId?.toString();
        localUid = callData?.uid;

        state.value = isCaller ? AudioCallState.calling : AudioCallState.incoming;

        Get.snackbar(
          "Success",
          callResponse.message ?? "Call created",
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.successSnackbarColor.withOpacity(0.8),
          colorText: AppColors.whiteColor,
        );
      } else {
        Get.snackbar(
          "Error",
          result?['message'] ?? "Failed to create call",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
          colorText: AppColors.whiteColor,
        );

        if (isCaller) Future.delayed(const Duration(seconds: 1), () => Get.back());
      }
    } catch (e) {
      isCallCreating.value = false;
      Get.snackbar(
        "Error",
        "Error creating call: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
      if (isCaller) Get.back();
    }
  }

  // ===================== INITIALIZE AGORA =====================
  Future<void> _initializeAgora() async {
    try {
      _engine = createAgoraRtcEngine();

      await _engine!.initialize(
        RtcEngineContext(
          appId: AGORA_APP_ID,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            if (state.value == AudioCallState.connected) _startTimer();
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            remoteUid.value = uid;
          },
          onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
            remoteUid.value = null;
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            isJoined.value = false;
            remoteUid.value = null;
          },
        ),
      );

      await _engine!.enableAudio();

      if (isVideo) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      } else {
        await _engine!.disableVideo();
      }

      if (isVideo) {
        await _engine!.setEnableSpeakerphone(true);
        isSpeakerOn.value = true;
      }

      _isEngineInitialized = true;

      // Caller auto-joins
      if (isCaller) await _joinChannel();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Agora Engine init failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
        colorText: AppColors.whiteColor,
      );
    }
  }

  // ===================== JOIN CHANNEL =====================
  Future<void> _joinChannel() async {
    if (!_isEngineInitialized || callData == null) return;

    await _engine!.joinChannel(
      token: callData!.token!,
      channelId: callData!.channelName!,
      uid: callData!.uid ?? 0,
      options: ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: isVideo,
        publishMicrophoneTrack: true,
        publishCameraTrack: isVideo,
      ),
    );
  }

  // ===================== ACCEPT CALL =====================
  Future<void> acceptCall() async {
    state.value = AudioCallState.calling;

    if (!_isEngineInitialized) return;

    if (!isJoined.value) await _joinChannel();

    if (isJoined.value) {
      state.value = AudioCallState.connected;
      _startTimer();
    }
  }

  // ===================== END CALL =====================
  Future<void> endCall() async {
    _timer?.cancel();

    await _leaveChannel();
    await _endCall();

    Get.back();
  }

  Future<void> _endCall() async {
    if (currentCallId == null) return;

    try {
      String userId = StorageHelper().getUserId.toString();

      await ApiManager.callPostWithFormData(
        body: {
          ApiParam.request: 'end_call',
          ApiParam.userId: userId,
          ApiParam.callId: currentCallId,
        },
        endPoint: ApiUtils.endCall,
      );
    } catch (_) {}
  }

  // ===================== UTILITIES =====================
  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    await _engine?.muteLocalAudioStream(isMuted.value);
  }

  Future<void> toggleSpeaker() async {
    isSpeakerOn.value = !isSpeakerOn.value;
    await _engine?.setEnableSpeakerphone(isSpeakerOn.value);
  }

  Future<void> switchCamera() async {
    if (isVideo) await _engine?.switchCamera();
  }

  Future<void> _leaveChannel() async {
    try {
      if (_isEngineInitialized && _engine != null && isJoined.value) {
        await _engine!.leaveChannel();
        isJoined.value = false;
      }
    } catch (_) {}
  }

  // ===================== TIMER =====================
  void _startTimer() {
    _timer?.cancel();
    _seconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      timerString.value =
      "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";
    });
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }

  void _cleanup() {
    _timer?.cancel();
    _leaveChannel();
    _engine?.release();
    if (currentCallId != null) _endCall();
  }
}
