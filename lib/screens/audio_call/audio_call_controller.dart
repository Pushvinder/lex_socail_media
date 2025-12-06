// //
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import '../../api_helpers/api_manager.dart';
// // import '../../api_helpers/api_param.dart';
// // import '../../api_helpers/api_utils.dart';
// // import '../../config/app_colors.dart';
// // import '../../helpers/storage_helper.dart';
// // import 'call_response_model.dart';
// //
// // enum AudioCallState { incoming, calling, connected }
// //
// // class AudioCallController extends GetxController {
// //   final RxString callerName;
// //   final RxString profileImage;
// //   final String receiverId;
// //   final bool isVideo;
// //
// //   var state = AudioCallState.calling.obs;
// //   var timerString = '00:00'.obs;
// //   var isMuted = false.obs;
// //   var isSpeakerOn = false.obs;
// //   var isCallCreating = false.obs;
// //   var remoteUid = Rxn<int>(); // Remote user ID
// //   var isJoined = false.obs; // Channel join status
// //
// //   Timer? _timer;
// //   int _seconds = 0;
// //
// //   // Call data from API
// //   CallData? callData;
// //   String? currentCallId;
// //
// //   // Agora Engine
// //   RtcEngine? _engine;
// //   bool _isEngineInitialized = false;
// //
// //   // Agora App ID (hardcoded as fallback)
// //   static const String AGORA_APP_ID = "f56586e9820243778c9b0159f2d4ddd2";
// //
// //   AudioCallController({
// //     required String callerName,
// //     required String profileImage,
// //     required this.receiverId,
// //     this.isVideo = false,
// //   })  : callerName = callerName.obs,
// //         profileImage = profileImage.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeCall();
// //   }
// //
// //   // ===================== INITIALIZE CALL FLOW =====================
// //   Future<void> _initializeCall() async {
// //     // Step 1: Request permissions
// //     await _requestPermissions();
// //
// //     // Step 2: Create call via API
// //     await createCall();
// //
// //     // Step 3: Initialize Agora if call was created
// //     if (callData != null) {
// //       await _initializeAgora();
// //     }
// //   }
// //
// //   // ===================== PERMISSION HANDLING =====================
// //   Future<void> _requestPermissions() async {
// //     try {
// //       debugPrint("━━━━━━━━━━━━━━━ REQUESTING PERMISSIONS ━━━━━━━━━━━━━━━");
// //
// //       Map<Permission, PermissionStatus> statuses = await [
// //         Permission.microphone,
// //         if (isVideo) Permission.camera,
// //       ].request();
// //
// //       bool allGranted = statuses.values.every((status) => status.isGranted);
// //
// //       if (!allGranted) {
// //         debugPrint("❌ Permissions not granted");
// //         Get.snackbar(
// //           "Permissions Required",
// //           "Please grant ${isVideo ? 'camera and microphone' : 'microphone'} permissions to continue",
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
// //           colorText: AppColors.whiteColor,
// //           margin: const EdgeInsets.all(15),
// //         );
// //
// //         Future.delayed(Duration(seconds: 2), () {
// //           Get.back();
// //         });
// //         return;
// //       }
// //
// //       debugPrint("✅ All permissions granted");
// //       debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
// //     } catch (e) {
// //       debugPrint("❌ Permission request error: $e");
// //     }
// //   }
// //
// //   // ===================== CREATE CALL API =====================
// //   Future<void> createCall() async {
// //     print('createCall called');
// //
// //     try {
// //       isCallCreating.value = true;
// //
// //       String currentUserId = StorageHelper().getUserId.toString();
// //       String callType = isVideo ? 'video' : 'audio';
// //
// //       print('━━━━━━━━━━━━━━━ CREATE CALL DEBUG ━━━━━━━━━━━━━━━');
// //       print('📞 Caller ID: $currentUserId');
// //       print('👤 Receiver ID: $receiverId');
// //       print('🎬 Call Type: $callType');
// //
// //       Map<String, dynamic> body = {
// //         ApiParam.request: 'create_call',
// //         ApiParam.callerId: currentUserId,
// //         ApiParam.receiverId: receiverId,
// //         ApiParam.callType: callType,
// //       };
// //
// //       print('📋 Create Call Body: $body');
// //
// //       var result = await ApiManager.callPostWithFormData(
// //         body: body,
// //         endPoint: ApiUtils.createCall,
// //       );
// //
// //       isCallCreating.value = false;
// //
// //       print('📥 API Response: $result');
// //
// //       if (result['status'] == 'success') {
// //         final callResponse = CallResponseModel.fromJson(result);
// //
// //         callData = callResponse.data;
// //         currentCallId = callData?.callId.toString();
// //
// //         print('✅ Call Created Successfully');
// //         print('📋 Call ID: ${callData?.callId}');
// //         print('🔗 Channel: ${callData?.channelName}');
// //         print('🎫 Token: ${callData?.token}');
// //         print('🆔 UID: ${callData?.uid}');
// //
// //         Get.snackbar(
// //           "Success",
// //           callResponse.message ?? "Call created successfully",
// //           snackPosition: SnackPosition.TOP,
// //           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.7),
// //           colorText: AppColors.whiteColor,
// //           margin: const EdgeInsets.all(15),
// //           duration: const Duration(seconds: 2),
// //         );
// //       } else {
// //         print("❌ Call creation failed: ${result['message']}");
// //
// //         Get.snackbar(
// //           "Error",
// //           result['message'] ?? "Failed to create call",
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
// //           colorText: AppColors.whiteColor,
// //           margin: const EdgeInsets.all(15),
// //         );
// //
// //         Future.delayed(Duration(seconds: 2), () {
// //           Get.back();
// //         });
// //       }
// //
// //       print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
// //     } catch (e, s) {
// //       isCallCreating.value = false;
// //       print('❌ Create Call Error: $e');
// //       print(s);
// //
// //       Get.snackbar(
// //         "Error",
// //         "Error creating call: $e",
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
// //         colorText: AppColors.whiteColor,
// //         margin: const EdgeInsets.all(15),
// //       );
// //
// //       Future.delayed(Duration(seconds: 2), () {
// //         Get.back();
// //       });
// //     }
// //   }
// //
// //   // ===================== INITIALIZE AGORA =====================
// //   Future<void> _initializeAgora() async {
// //     try {
// //       debugPrint("━━━━━━━━━━━━━━━ INITIALIZING AGORA ━━━━━━━━━━━━━━━");
// //
// //       // Use App ID from response or fallback to hardcoded
// //       final appId = AGORA_APP_ID;
// //
// //       if (appId.isEmpty) {
// //         debugPrint("❌ No App ID available");
// //         return;
// //       }
// //
// //       // Create Agora Engine
// //       _engine = createAgoraRtcEngine();
// //
// //       await _engine!.initialize(RtcEngineContext(
// //         appId: appId,
// //         channelProfile: ChannelProfileType.channelProfileCommunication,
// //       ));
// //
// //       debugPrint("✅ Agora engine initialized with App ID: $appId");
// //
// //       // Register event handlers
// //       _engine!.registerEventHandler(
// //         RtcEngineEventHandler(
// //           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //             debugPrint("✅ Successfully joined channel: ${connection.channelId}");
// //             isJoined.value = true;
// //             // Auto accept call when joined
// //             acceptCall();
// //           },
// //           onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
// //             debugPrint("👤 Remote user joined: $remoteUid");
// //             this.remoteUid.value = remoteUid;
// //           },
// //           onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
// //             debugPrint("👋 Remote user left: $remoteUid");
// //             this.remoteUid.value = null;
// //           },
// //           onLeaveChannel: (RtcConnection connection, RtcStats stats) {
// //             debugPrint("📤 Left channel");
// //             isJoined.value = false;
// //             remoteUid.value = null;
// //           },
// //           onError: (ErrorCodeType err, String msg) {
// //             debugPrint("❌ Agora error: $err - $msg");
// //           },
// //           onConnectionStateChanged: (RtcConnection connection,
// //               ConnectionStateType state,
// //               ConnectionChangedReasonType reason) {
// //             debugPrint("🔗 Connection state changed: $state - $reason");
// //           },
// //         ),
// //       );
// //
// //       // Enable audio by default
// //       await _engine!.enableAudio();
// //
// //       // Enable video if video call
// //       if (isVideo) {
// //         await _engine!.enableVideo();
// //         // Enable local video preview
// //         await _engine!.startPreview();
// //         debugPrint("📹 Video enabled");
// //       } else {
// //         await _engine!.disableVideo();
// //         debugPrint("🔇 Video disabled (audio only)");
// //       }
// //
// //       // Set audio profile for better quality
// //       await _engine!.setAudioProfile(
// //         profile: AudioProfileType.audioProfileDefault,
// //         scenario: AudioScenarioType.audioScenarioChatroom,
// //       );
// //
// //       // Enable speaker by default for video calls
// //       if (isVideo) {
// //         await _engine!.setEnableSpeakerphone(true);
// //         isSpeakerOn.value = true;
// //       }
// //
// //       _isEngineInitialized = true;
// //       debugPrint("✅ Agora engine fully configured");
// //
// //       // Auto join channel
// //       await _joinChannel();
// //
// //       debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
// //     } catch (e) {
// //       debugPrint("❌ Agora initialization error: $e");
// //       Get.snackbar(
// //         "Error",
// //         "Failed to initialize call engine: $e",
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
// //         colorText: AppColors.whiteColor,
// //         margin: const EdgeInsets.all(15),
// //       );
// //     }
// //   }
// //
// //   // ===================== JOIN CHANNEL =====================
// //   Future<void> _joinChannel() async {
// //     try {
// //       if (!_isEngineInitialized || callData == null) {
// //         debugPrint("❌ Cannot join: Engine not initialized or no call data");
// //         return;
// //       }
// //
// //       debugPrint("━━━━━━━━━━━━━━━ JOINING CHANNEL ━━━━━━━━━━━━━━━");
// //       debugPrint("🔗 Channel: ${callData!.channelName}");
// //       debugPrint("🎫 Token: ${callData!.token}");
// //       debugPrint("🆔 UID: ${callData!.uid}");
// //
// //       ChannelMediaOptions options = ChannelMediaOptions(
// //         clientRoleType: ClientRoleType.clientRoleBroadcaster,
// //         channelProfile: ChannelProfileType.channelProfileCommunication,
// //         autoSubscribeAudio: true,
// //         autoSubscribeVideo: isVideo,
// //         publishMicrophoneTrack: true,
// //         publishCameraTrack: isVideo,
// //       );
// //
// //       await _engine!.joinChannel(
// //         token: callData!.token!,
// //         channelId: callData!.channelName!,
// //         uid: callData!.uid!,
// //         options: options,
// //       );
// //
// //       debugPrint("📞 Join channel request sent");
// //       debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
// //     } catch (e) {
// //       debugPrint("❌ Join channel error: $e");
// //       Get.snackbar(
// //         "Error",
// //         "Failed to join call: $e",
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
// //         colorText: AppColors.whiteColor,
// //         margin: const EdgeInsets.all(15),
// //       );
// //     }
// //   }
// //
// //   // ===================== END CALL API =====================
// //   Future<void> _endCall() async {
// //     if (currentCallId == null) {
// //       print("⚠️ No call ID available to end");
// //       return;
// //     }
// //
// //     print('endCall called');
// //     print('Call ID: $currentCallId');
// //
// //     try {
// //       final String currentUserId = StorageHelper().getUserId.toString();
// //
// //       Map<String, dynamic> body = {
// //         ApiParam.request: 'end_call',
// //         ApiParam.userId: currentUserId,
// //         ApiParam.callId: currentCallId,
// //       };
// //
// //       print('End Call Body: $body');
// //
// //       var result = await ApiManager.callPostWithFormData(
// //         body: body,
// //         endPoint: ApiUtils.endCall,
// //       );
// //
// //       print('API Response: $result');
// //
// //       if (result['status'] == 'success') {
// //         print("✅ Call ended successfully");
// //       } else {
// //         print("❌ End call failed: ${result['message']}");
// //       }
// //     } catch (e, s) {
// //       print('❌ End Call Error: $e');
// //       print(s);
// //     }
// //   }
// //
// //   // ===================== CALL ACTIONS =====================
// //   void acceptCall() {
// //     state.value = AudioCallState.connected;
// //     _startTimer();
// //   }
// //
// //   Future<void> endCall() async {
// //     _timer?.cancel();
// //
// //     // Leave Agora channel
// //     await _leaveChannel();
// //
// //     // Call the end call API
// //     await _endCall();
// //
// //     // Navigate back
// //     Get.back();
// //   }
// //
// //   Future<void> toggleMute() async {
// //     try {
// //       isMuted.value = !isMuted.value;
// //       await _engine?.muteLocalAudioStream(isMuted.value);
// //       debugPrint("🔇 Mute toggled: ${isMuted.value}");
// //     } catch (e) {
// //       debugPrint("❌ Toggle mute error: $e");
// //     }
// //   }
// //
// //   Future<void> toggleSpeaker() async {
// //     try {
// //       isSpeakerOn.value = !isSpeakerOn.value;
// //       await _engine?.setEnableSpeakerphone(isSpeakerOn.value);
// //       debugPrint("🔊 Speaker toggled: ${isSpeakerOn.value}");
// //     } catch (e) {
// //       debugPrint("❌ Toggle speaker error: $e");
// //     }
// //   }
// //
// //   Future<void> switchCamera() async {
// //     try {
// //       if (isVideo) {
// //         await _engine?.switchCamera();
// //         debugPrint("📸 Camera switched");
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Switch camera error: $e");
// //     }
// //   }
// //
// //   // ===================== LEAVE CHANNEL =====================
// //   Future<void> _leaveChannel() async {
// //     try {
// //       if (_isEngineInitialized && _engine != null) {
// //         await _engine!.leaveChannel();
// //         debugPrint("📤 Left Agora channel");
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Leave channel error: $e");
// //     }
// //   }
// //
// //   // ===================== TIMER =====================
// //   void _startTimer() {
// //     _timer?.cancel();
// //     _seconds = 0;
// //     _timer = Timer.periodic(Duration(seconds: 1), (_) {
// //       _seconds++;
// //       final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
// //       final seconds = (_seconds % 60).toString().padLeft(2, '0');
// //       timerString.value = "$minutes:$seconds";
// //     });
// //   }
// //
// //   // ===================== CLEANUP =====================
// //   @override
// //   void onClose() {
// //     _timer?.cancel();
// //
// //     // Leave channel and cleanup
// //     _leaveChannel();
// //
// //     // Release Agora engine
// //     if (_isEngineInitialized && _engine != null) {
// //       _engine!.release();
// //       debugPrint("🧹 Agora engine released");
// //     }
// //
// //     // End call API
// //     if (currentCallId != null) {
// //       _endCall();
// //     }
// //
// //     super.onClose();
// //   }
// // }
// //
//
//
// // audio_call_controller.dart
//
// // import 'dart:async';
// // import 'package:flutter/foundation.dart';
// // import 'package:get/get.dart';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import '../../api_helpers/api_manager.dart';
// // import '../../api_helpers/api_param.dart';
// // import '../../api_helpers/api_utils.dart';
// // import '../../config/app_colors.dart';
// // import '../../helpers/storage_helper.dart';
// // import 'call_response_model.dart';
// //
// // enum AudioCallState { incoming, calling, connected }
// //
// // class AudioCallController extends GetxController {
// //   final RxString callerName;
// //   final RxString profileImage;
// //   final String receiverId;
// //   final bool isVideo;
// //   final bool isCaller;
// //
// //   var state = AudioCallState.calling.obs;
// //   var timerString = '00:00'.obs;
// //   var isMuted = false.obs;
// //   var isSpeakerOn = false.obs;
// //   var isCallCreating = false.obs;
// //   var remoteUid = Rxn<int>();
// //   var isJoined = false.obs;
// //
// //   Timer? _timer;
// //   int _seconds = 0;
// //
// //   CallData? callData;
// //   String? currentCallId;
// //
// //   RtcEngine? _engine;
// //   bool _isEngineInitialized = false;
// //
// //   int? localUid;
// //
// //   static const String AGORA_APP_ID = "f56586e9820243778c9b0159f2d4ddd2";
// //
// //   AudioCallController({
// //     required String callerName,
// //     required String profileImage,
// //     required this.receiverId,
// //     this.isVideo = false,
// //     this.isCaller = false,
// //   })  : callerName = callerName.obs,
// //         profileImage = profileImage.obs;
// //
// //   // Public engine getter
// //   RtcEngine get engine {
// //     if (_engine == null) throw Exception("Agora engine not initialized yet");
// //     return _engine!;
// //   }
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeCall();
// //   }
// //
// //   // ===================== INITIALIZE CALL =====================
// //   Future<void> _initializeCall() async {
// //     await _requestPermissions();
// //     await createCall();
// //     if (callData != null) {
// //       await _initializeAgora();
// //     }
// //   }
// //
// //   // ===================== PERMISSIONS =====================
// //   Future<void> _requestPermissions() async {
// //     try {
// //       Map<Permission, PermissionStatus> statuses = await [
// //         Permission.microphone,
// //         if (isVideo) Permission.camera,
// //       ].request();
// //
// //       if (!statuses.values.every((e) => e.isGranted)) {
// //         Get.snackbar(
// //           "Permissions Required",
// //           isVideo ? "Camera & Microphone required" : "Microphone required",
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
// //           colorText: AppColors.whiteColor,
// //         );
// //         return;
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Permission error: $e");
// //     }
// //   }
// //
// //   // ===================== CREATE CALL API =====================
// //   Future<void> createCall() async {
// //     try {
// //       isCallCreating.value = true;
// //
// //       String currentUserId = StorageHelper().getUserId.toString();
// //       Map<String, dynamic> body = {
// //         ApiParam.request: 'create_call',
// //         ApiParam.callerId: currentUserId,
// //         ApiParam.receiverId: receiverId,
// //         ApiParam.callType: isVideo ? 'video' : 'audio',
// //       };
// //
// //       var result = await ApiManager.callPostWithFormData(
// //         body: body,
// //         endPoint: ApiUtils.createCall,
// //       );
// //
// //       isCallCreating.value = false;
// //
// //       if (result != null && result['status'] == 'success') {
// //         final callResponse = CallResponseModel.fromJson(result);
// //         callData = callResponse.data;
// //         currentCallId = callData?.callId?.toString();
// //         localUid = callData?.uid;
// //
// //         state.value = isCaller ? AudioCallState.calling : AudioCallState.incoming;
// //
// //         Get.snackbar(
// //           "Success",
// //           callResponse.message ?? "Call created",
// //           snackPosition: SnackPosition.TOP,
// //           backgroundColor: AppColors.successSnackbarColor.withOpacity(0.8),
// //           colorText: AppColors.whiteColor,
// //         );
// //       } else {
// //         Get.snackbar(
// //           "Error",
// //           result?['message'] ?? "Failed to create call",
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
// //           colorText: AppColors.whiteColor,
// //         );
// //
// //         if (isCaller) Future.delayed(const Duration(seconds: 1), () => Get.back());
// //       }
// //     } catch (e) {
// //       isCallCreating.value = false;
// //       Get.snackbar(
// //         "Error",
// //         "Error creating call: $e",
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
// //         colorText: AppColors.whiteColor,
// //       );
// //       if (isCaller) Get.back();
// //     }
// //   }
// //
// //   // ===================== INITIALIZE AGORA =====================
// //   Future<void> _initializeAgora() async {
// //     try {
// //       _engine = createAgoraRtcEngine();
// //
// //       await _engine!.initialize(
// //         RtcEngineContext(
// //           appId: AGORA_APP_ID,
// //           channelProfile: ChannelProfileType.channelProfileCommunication,
// //         ),
// //       );
// //
// //       _engine!.registerEventHandler(
// //         RtcEngineEventHandler(
// //           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //             isJoined.value = true;
// //             if (state.value == AudioCallState.connected) _startTimer();
// //           },
// //           onUserJoined: (RtcConnection connection, int uid, int elapsed) {
// //             remoteUid.value = uid;
// //           },
// //           onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
// //             remoteUid.value = null;
// //           },
// //           onLeaveChannel: (RtcConnection connection, RtcStats stats) {
// //             isJoined.value = false;
// //             remoteUid.value = null;
// //           },
// //         ),
// //       );
// //
// //       await _engine!.enableAudio();
// //
// //       if (isVideo) {
// //         await _engine!.enableVideo();
// //         await _engine!.startPreview();
// //       } else {
// //         await _engine!.disableVideo();
// //       }
// //
// //       if (isVideo) {
// //         await _engine!.setEnableSpeakerphone(true);
// //         isSpeakerOn.value = true;
// //       }
// //
// //       _isEngineInitialized = true;
// //
// //       // Caller auto-joins
// //       if (isCaller) await _joinChannel();
// //     } catch (e) {
// //       Get.snackbar(
// //         "Error",
// //         "Agora Engine init failed: $e",
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.8),
// //         colorText: AppColors.whiteColor,
// //       );
// //     }
// //   }
// //
// //   // ===================== JOIN CHANNEL =====================
// //   Future<void> _joinChannel() async {
// //     if (!_isEngineInitialized || callData == null) return;
// //
// //     await _engine!.joinChannel(
// //       token: callData!.token!,
// //       channelId: callData!.channelName!,
// //       uid: callData!.uid ?? 0,
// //       options: ChannelMediaOptions(
// //         autoSubscribeAudio: true,
// //         autoSubscribeVideo: isVideo,
// //         publishMicrophoneTrack: true,
// //         publishCameraTrack: isVideo,
// //       ),
// //     );
// //   }
// //
// //   // ===================== ACCEPT CALL =====================
// //   Future<void> acceptCall() async {
// //     state.value = AudioCallState.calling;
// //
// //     if (!_isEngineInitialized) return;
// //
// //     if (!isJoined.value) await _joinChannel();
// //
// //     if (isJoined.value) {
// //       state.value = AudioCallState.connected;
// //       _startTimer();
// //     }
// //   }
// //
// //   // ===================== END CALL =====================
// //   Future<void> endCall() async {
// //     _timer?.cancel();
// //
// //     await _leaveChannel();
// //     await _endCall();
// //
// //     Get.back();
// //   }
// //
// //   Future<void> _endCall() async {
// //     if (currentCallId == null) return;
// //
// //     try {
// //       String userId = StorageHelper().getUserId.toString();
// //
// //       await ApiManager.callPostWithFormData(
// //         body: {
// //           ApiParam.request: 'end_call',
// //           ApiParam.userId: userId,
// //           ApiParam.callId: currentCallId,
// //         },
// //         endPoint: ApiUtils.endCall,
// //       );
// //     } catch (_) {}
// //   }
// //
// //   // ===================== UTILITIES =====================
// //   Future<void> toggleMute() async {
// //     isMuted.value = !isMuted.value;
// //     await _engine?.muteLocalAudioStream(isMuted.value);
// //   }
// //
// //   Future<void> toggleSpeaker() async {
// //     isSpeakerOn.value = !isSpeakerOn.value;
// //     await _engine?.setEnableSpeakerphone(isSpeakerOn.value);
// //   }
// //
// //   Future<void> switchCamera() async {
// //     if (isVideo) await _engine?.switchCamera();
// //   }
// //
// //   Future<void> _leaveChannel() async {
// //     try {
// //       if (_isEngineInitialized && _engine != null && isJoined.value) {
// //         await _engine!.leaveChannel();
// //         isJoined.value = false;
// //       }
// //     } catch (_) {}
// //   }
// //
// //   // ===================== TIMER =====================
// //   void _startTimer() {
// //     _timer?.cancel();
// //     _seconds = 0;
// //
// //     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
// //       _seconds++;
// //       timerString.value =
// //       "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";
// //     });
// //   }
// //
// //   @override
// //   void onClose() {
// //     _cleanup();
// //     super.onClose();
// //   }
// //
// //   void _cleanup() {
// //     _timer?.cancel();
// //     _leaveChannel();
// //     _engine?.release();
// //     if (currentCallId != null) _endCall();
// //   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/api_helpers/api_manager.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/api_helpers/api_utils.dart';
// import 'package:the_friendz_zone/helpers/storage_helper.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import 'call_response_model.dart';
//
// enum CallState { idle, calling, ringing, connected, ended }
//
// class CallController extends GetxController {
//   // Call Information
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   CallController({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     required this.isVideo,
//     this.isIncoming = false,
//   });
//
//   // Observables
//   final state = CallState.idle.obs;
//   final timerString = '00:00'.obs;
//   final isMuted = false.obs;
//   final isSpeakerOn = false.obs;
//   final isLoading = false.obs;
//   final remoteUid = Rxn<int>();
//   final isJoined = false.obs;
//
//   // Private
//   Timer? _timer;
//   int _seconds = 0;
//   CallData? _callData;
//   String? _callId;
//   int? _localUid;
//   final AgoraService _agoraService = AgoraService.instance;
//
//   // Public getters for private fields
//   CallData? get callData => _callData;
//   int? get localUid => _localUid;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCall();
//   }
//
//   // ===================== INITIALIZATION =====================
//
//   Future<void> _initializeCall() async {
//     try {
//       // Request permissions
//       final hasPermission = await _agoraService.requestPermissions(
//         isVideo: isVideo,
//       );
//
//       if (!hasPermission) {
//         _showError("Required permissions not granted");
//         Get.back();
//         return;
//       }
//
//       // Initialize Agora if not already
//       if (!_agoraService.isInitialized) {
//         await _agoraService.initialize();
//       }
//
//       // Setup event handlers
//       _setupEventHandlers();
//
//       // Enable audio/video
//       await _agoraService.enableAudio();
//       if (isVideo) {
//         await _agoraService.enableVideo();
//         await _agoraService.toggleSpeaker(true);
//         isSpeakerOn.value = true;
//       }
//
//       // Create or accept call
//       if (isIncoming) {
//         state.value = CallState.ringing;
//       } else {
//         await _createCall();
//       }
//     } catch (e) {
//       _showError("Failed to initialize call: $e");
//       Get.back();
//     }
//   }
//
//   void _setupEventHandlers() {
//     _agoraService.registerEventHandlers(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           isJoined.value = true;
//           debugPrint("✅ Joined channel successfully");
//
//           if (state.value == CallState.connected) {
//             _startTimer();
//           }
//         },
//         onUserJoined: (RtcConnection connection, int uid, int elapsed) {
//           remoteUid.value = uid;
//           state.value = CallState.connected;
//           _startTimer();
//           debugPrint("✅ Remote user joined: $uid");
//         },
//         onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
//           remoteUid.value = null;
//           debugPrint("🚪 Remote user left: $uid");
//           _endCall();
//         },
//         onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//           isJoined.value = false;
//           remoteUid.value = null;
//           debugPrint("🚪 Left channel");
//         },
//         onError: (ErrorCodeType err, String msg) {
//           debugPrint("❌ Agora Error: $err - $msg");
//         },
//       ),
//     );
//   }
//
//   // ===================== CALL ACTIONS =====================
//
//   Future<void> _createCall() async {
//     try {
//       isLoading.value = true;
//       state.value = CallState.calling;
//
//       String currentUserId = StorageHelper().getUserId.toString();
//       Map<String, dynamic> body = {
//         ApiParam.request: 'create_call',
//         ApiParam.callerId: currentUserId,
//         ApiParam.receiverId: receiverId,
//         ApiParam.callType: isVideo ? 'video' : 'audio',
//       };
//
//       var result = await ApiManager.callPostWithFormData(
//         body: body,
//         endPoint: ApiUtils.createCall,
//       );
//
//       isLoading.value = false;
//
//       if (result != null && result['status'] == 'success') {
//         final callResponse = CallResponseModel.fromJson(result);
//         _callData = callResponse.data;
//         _callId = callResponse.data?.callId?.toString();
//         _localUid = callResponse.data?.uid;
//
//         _showSuccess(callResponse.message ?? "Call created");
//
//         // Join channel automatically for caller
//         await _joinChannel();
//       } else {
//         _showError(result?['message'] ?? "Failed to create call");
//         Get.back();
//       }
//     } catch (e) {
//       isLoading.value = false;
//       _showError("Error creating call: $e");
//       Get.back();
//     }
//   }
//
//   // Future<void> acceptCall() async {
//   //   try {
//   //     if (_callId != null) {
//   //       String userId = StorageHelper().getUserId.toString();
//   //       await ApiManager.callPostWithFormData(
//   //         body: {
//   //           ApiParam.request: 'accept_call',
//   //           ApiParam.userId: userId,
//   //           ApiParam.callId: _callId,
//   //         },
//   //         endPoint: ApiUtils.acceptCall,
//   //       );
//   //     }
//   //
//   //     state.value = CallState.calling;
//   //     await _joinChannel();
//   //   } catch (e) {
//   //     _showError("Failed to accept call: $e");
//   //   }
//   // }
//   //
//   // Future<void> rejectCall() async {
//   //   try {
//   //     if (_callId != null) {
//   //       String userId = StorageHelper().getUserId.toString();
//   //       await ApiManager.callPostWithFormData(
//   //         body: {
//   //           ApiParam.request: 'reject_call',
//   //           ApiParam.userId: userId,
//   //           ApiParam.callId: _callId,
//   //         },
//   //         endPoint: ApiUtils.rejectCall,
//   //       );
//   //     }
//   //     Get.back();
//   //   } catch (e) {
//   //     debugPrint("Error rejecting call: $e");
//   //     Get.back();
//   //   }
//   // }
//
//   Future<void> endCall() async {
//     await _endCall();
//     Get.back();
//   }
//
//   Future<void> _endCall() async {
//     try {
//       _timer?.cancel();
//       state.value = CallState.ended;
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'end_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//           },
//           endPoint: ApiUtils.endCall,
//         );
//       }
//
//       await _agoraService.leaveChannel();
//     } catch (e) {
//       debugPrint("Error ending call: $e");
//     }
//   }
//
//   // ===================== AGORA CHANNEL =====================
//
//   Future<void> _joinChannel() async {
//     if (_callData == null) {
//       _showError("Call data not available");
//       return;
//     }
//
//     try {
//       await _agoraService.joinChannel(
//         token: _callData!.token!,
//         channelName: _callData!.channelName!,
//         uid: _callData!.uid ?? 0,
//         isVideo: isVideo,
//       );
//
//       debugPrint("📞 Joining channel: ${_callData!.channelName}");
//     } catch (e) {
//       _showError("Failed to join channel: $e");
//     }
//   }
//
//   // ===================== CONTROLS =====================
//
//   Future<void> toggleMute() async {
//     isMuted.value = !isMuted.value;
//     await _agoraService.muteLocalAudio(isMuted.value);
//   }
//
//   Future<void> toggleSpeaker() async {
//     isSpeakerOn.value = !isSpeakerOn.value;
//     await _agoraService.toggleSpeaker(isSpeakerOn.value);
//   }
//
//   Future<void> switchCamera() async {
//     if (isVideo) {
//       await _agoraService.switchCamera();
//     }
//   }
//
//   // ===================== TIMER =====================
//
//   void _startTimer() {
//     _timer?.cancel();
//     _seconds = 0;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _seconds++;
//       final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_seconds % 60).toString().padLeft(2, '0');
//       timerString.value = '$minutes:$seconds';
//     });
//   }
//
//   // ===================== UTILITIES =====================
//
//   void _showSuccess(String message) {
//     Get.snackbar(
//       "Success",
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppColors.greenColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   void _showError(String message) {
//     Get.snackbar(
//       "Error",
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: AppColors.redColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:the_friendz_zone/api_helpers/api_manager.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/api_helpers/api_utils.dart';
// import 'package:the_friendz_zone/helpers/storage_helper.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_enums.dart'; // ✅ Import enums
// import 'call_response_model.dart';
//
// class CallController extends GetxController {
//   // Call Information
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   // ✅ Incoming call data
//   final String? incomingCallId;
//   final String? incomingChannelName;
//   final String? incomingToken;
//   final int? incomingUid;
//
//   CallController({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     required this.isVideo,
//     this.isIncoming = false,
//     this.incomingCallId,
//     this.incomingChannelName,
//     this.incomingToken,
//     this.incomingUid,
//   });
//
//   // Observables - ✅ Use enum from app_enums.dart
//   final state = CallState.idle.obs;
//   final timerString = '00:00'.obs;
//   final isMuted = false.obs;
//   final isSpeakerOn = false.obs;
//   final isLoading = false.obs;
//   final remoteUid = Rxn<int>();
//   final isJoined = false.obs;
//
//   // Private
//   Timer? _timer;
//   int _seconds = 0;
//   CallData? _callData;
//   String? _callId;
//   int? _localUid;
//   final AgoraService _agoraService = AgoraService.instance;
//
//   // Public getters for private fields
//   CallData? get callData => _callData;
//   int? get localUid => _localUid;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCall();
//   }
//
//   // ===================== INITIALIZATION =====================
//
//   Future<void> _initializeCall() async {
//     try {
//       // Request permissions
//       final hasPermission = await _agoraService.requestPermissions(
//         isVideo: isVideo,
//       );
//
//       if (!hasPermission) {
//         _showError("Required permissions not granted");
//         Get.back();
//         return;
//       }
//
//       // Initialize Agora if not already
//       if (!_agoraService.isInitialized) {
//         await _agoraService.initialize();
//       }
//
//       // Setup event handlers
//       _setupEventHandlers();
//
//       // Enable audio/video
//       await _agoraService.enableAudio();
//       if (isVideo) {
//         await _agoraService.enableVideo();
//         await _agoraService.toggleSpeaker(true);
//         isSpeakerOn.value = true;
//       }
//
//       // ✅ Handle incoming vs outgoing call
//       if (isIncoming) {
//         // Receiver: Use data from FCM notification
//         _callId = incomingCallId;
//         _callData = CallData(
//           callId: int.tryParse(incomingCallId ?? ''),
//           channelName: incomingChannelName,
//           token: incomingToken,
//           uid: incomingUid,
//         );
//         _localUid = incomingUid;
//         state.value = CallState.ringing;
//
//         debugPrint("📞 Incoming call initialized");
//         debugPrint("Channel: ${_callData?.channelName}");
//         debugPrint("Token: ${_callData?.token}");
//         debugPrint("UID: ${_callData?.uid}");
//       } else {
//         // Caller: Create new call
//         await _createCall();
//       }
//     } catch (e) {
//       _showError("Failed to initialize call: $e");
//       Get.back();
//     }
//   }
//
//   void _setupEventHandlers() {
//     _agoraService.registerEventHandlers(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           isJoined.value = true;
//           debugPrint("✅ Joined channel successfully");
//
//           if (state.value == CallState.connected) {
//             _startTimer();
//           }
//         },
//         onUserJoined: (RtcConnection connection, int uid, int elapsed) {
//           remoteUid.value = uid;
//           state.value = CallState.connected;
//           _startTimer();
//           debugPrint("✅ Remote user joined: $uid");
//         },
//         onUserOffline: (
//           RtcConnection connection,
//           int uid,
//           UserOfflineReasonType reason,
//         ) {
//           remoteUid.value = null;
//           debugPrint("🚪 Remote user left: $uid");
//           _endCall();
//         },
//         onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//           isJoined.value = false;
//           remoteUid.value = null;
//           debugPrint("🚪 Left channel");
//         },
//         onError: (ErrorCodeType err, String msg) {
//           debugPrint("❌ Agora Error: $err - $msg");
//         },
//       ),
//     );
//   }
//
//   // ===================== CALL ACTIONS =====================
//
//   Future<void> _createCall() async {
//     try {
//       isLoading.value = true;
//       state.value = CallState.calling;
//
//       String currentUserId = StorageHelper().getUserId.toString();
//
//       // ✅ Get current user info for notification
//       String currentUserName = userName;
//       String currentUserAvatar = userAvatar;
//
//       Map<String, dynamic> body = {
//         ApiParam.request: 'create_call',
//         ApiParam.callerId: currentUserId,
//         ApiParam.receiverId: receiverId,
//         ApiParam.callType: isVideo ? 'video' : 'audio',
//         'caller_name': currentUserName,
//         'caller_avatar': currentUserAvatar,
//       };
//
//       var result = await ApiManager.callPostWithFormData(
//         body: body,
//         endPoint: ApiUtils.createCall,
//       );
//
//       isLoading.value = false;
//
//       if (result != null && result['status'] == 'success') {
//         final callResponse = CallResponseModel.fromJson(result);
//         _callData = callResponse.data;
//         _callId = callResponse.data?.callId?.toString();
//         _localUid = callResponse.data?.uid;
//
//         _showSuccess(callResponse.message ?? "Call created");
//
//         // ✅ Backend automatically sends FCM notification to receiver
//         debugPrint("📤 FCM notification sent to receiver");
//
//         // Join channel automatically for caller
//         await _joinChannel();
//       } else {
//         _showError(result?['message'] ?? "Failed to create call");
//         Get.back();
//       }
//     } catch (e) {
//       isLoading.value = false;
//       _showError("Error creating call: $e");
//       Get.back();
//     }
//   }
//
//   // ✅ Accept incoming call - UNCOMMENTED
//   Future<void> acceptCall() async {
//     try {
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'accept',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       state.value = CallState.calling;
//       await _joinChannel();
//     } catch (e) {
//       _showError("Failed to accept call: $e");
//     }
//   }
//
//   // ✅ Reject incoming call - UNCOMMENTED
//   Future<void> rejectCall() async {
//     try {
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'reject',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       Get.back();
//     } catch (e) {
//       debugPrint("Error rejecting call: $e");
//       Get.back();
//     }
//   }
//
//   Future<void> endCall() async {
//     await _endCall();
//     Get.back();
//   }
//
//   Future<void> _endCall() async {
//     try {
//       _timer?.cancel();
//       state.value = CallState.ended;
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'end',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       await _agoraService.leaveChannel();
//     } catch (e) {
//       debugPrint("Error ending call: $e");
//     }
//   }
//
//   // ===================== AGORA CHANNEL =====================
//
//   Future<void> _joinChannel() async {
//     if (_callData == null) {
//       _showError("Call data not available");
//       return;
//     }
//
//     try {
//       await _agoraService.joinChannel(
//         token: _callData!.token!,
//         channelName: _callData!.channelName!,
//         uid: _callData!.uid ?? 0,
//         isVideo: isVideo,
//       );
//
//       debugPrint("📞 Joining channel: ${_callData!.channelName}");
//     } catch (e) {
//       _showError("Failed to join channel: $e");
//     }
//   }
//
//   // ===================== CONTROLS =====================
//
//   Future<void> toggleMute() async {
//     isMuted.value = !isMuted.value;
//     await _agoraService.muteLocalAudio(isMuted.value);
//   }
//
//   Future<void> toggleSpeaker() async {
//     isSpeakerOn.value = !isSpeakerOn.value;
//     await _agoraService.toggleSpeaker(isSpeakerOn.value);
//   }
//
//   Future<void> switchCamera() async {
//     if (isVideo) {
//       await _agoraService.switchCamera();
//     }
//   }
//
//   // ===================== TIMER =====================
//
//   void _startTimer() {
//     _timer?.cancel();
//     _seconds = 0;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _seconds++;
//       final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_seconds % 60).toString().padLeft(2, '0');
//       timerString.value = '$minutes:$seconds';
//     });
//   }
//
//   // ===================== UTILITIES =====================
//
//   void _showSuccess(String message) {
//     Get.snackbar(
//       "Success",
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppColors.greenColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   void _showError(String message) {
//     Get.snackbar(
//       "Error",
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: AppColors.redColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }


//  important ----------------------------------
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:audioplayers/audioplayers.dart'; // ✅ Add this
// import 'package:the_friendz_zone/api_helpers/api_manager.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/api_helpers/api_utils.dart';
// import 'package:the_friendz_zone/helpers/storage_helper.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_enums.dart';
// import 'call_response_model.dart';
//
// class CallController extends GetxController {
//   // Call Information
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   // ✅ Incoming call data
//   final String? incomingCallId;
//   final String? incomingChannelName;
//   final String? incomingToken;
//   final int? incomingUid;
//
//   CallController({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     required this.isVideo,
//     this.isIncoming = false,
//     this.incomingCallId,
//     this.incomingChannelName,
//     this.incomingToken,
//     this.incomingUid,
//   });
//
//   // Observables
//   final state = CallState.idle.obs;
//   final timerString = '00:00'.obs;
//   final isMuted = false.obs;
//   final isSpeakerOn = false.obs;
//   final isLoading = false.obs;
//   final remoteUid = Rxn<int>();
//   final isJoined = false.obs;
//
//   // Private
//   Timer? _timer;
//   int _seconds = 0;
//   CallData? _callData;
//   String? _callId;
//   int? _localUid;
//   final AgoraService _agoraService = AgoraService.instance;
//
//   // ✅ Audio player for ringtone
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlayingRingtone = false;
//
//   // Public getters for private fields
//   CallData? get callData => _callData;
//   int? get localUid => _localUid;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCall();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     _stopRingtone(); // ✅ Stop ringtone
//     _audioPlayer.dispose(); // ✅ Dispose player
//     super.onClose();
//   }
//
//   // ===================== INITIALIZATION =====================
//
//   Future<void> _initializeCall() async {
//     try {
//       // Request permissions
//       final hasPermission = await _agoraService.requestPermissions(
//         isVideo: isVideo,
//       );
//
//       if (!hasPermission) {
//         _showError("Required permissions not granted");
//         Get.back();
//         return;
//       }
//
//       // Initialize Agora if not already
//       if (!_agoraService.isInitialized) {
//         await _agoraService.initialize();
//       }
//
//       // Setup event handlers
//       _setupEventHandlers();
//
//       // ✅ Enable audio FIRST
//       await _agoraService.enableAudio();
//
//       // ✅ Enable video BEFORE checking incoming/outgoing
//       if (isVideo) {
//         await _agoraService.enableVideo();
//         await _agoraService.toggleSpeaker(true);
//         isSpeakerOn.value = true;
//         debugPrint("📹 Video enabled and preview started");
//       }
//
//       // ✅ Handle incoming vs outgoing call
//       if (isIncoming) {
//         // Receiver: Use data from FCM notification
//         _callId = incomingCallId;
//         _callData = CallData(
//           callId: int.tryParse(incomingCallId ?? ''),
//           channelName: incomingChannelName,
//           token: incomingToken,
//           uid: incomingUid,
//         );
//         _localUid = incomingUid;
//         state.value = CallState.ringing;
//
//         // ✅ Play ringtone for incoming call
//         await _playRingtone();
//
//         debugPrint("📞 Incoming call initialized");
//         debugPrint("Channel: ${_callData?.channelName}");
//         debugPrint("Token: ${_callData?.token}");
//         debugPrint("UID: ${_callData?.uid}");
//       } else {
//         // Caller: Create new call
//         await _createCall();
//
//         // ✅ Play ringtone for outgoing call
//         await _playRingtone();
//       }
//     } catch (e) {
//       _showError("Failed to initialize call: $e");
//       Get.back();
//     }
//   }
//
//   void _setupEventHandlers() {
//     _agoraService.registerEventHandlers(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           isJoined.value = true;
//           debugPrint("✅ Joined channel successfully");
//
//           if (state.value == CallState.connected) {
//             _startTimer();
//           }
//         },
//         onUserJoined: (RtcConnection connection, int uid, int elapsed) {
//           // ✅ Stop ringtone when remote user joins
//           _stopRingtone();
//
//           remoteUid.value = uid;
//           state.value = CallState.connected;
//           _startTimer();
//           debugPrint("✅ Remote user joined: $uid");
//         },
//         onUserOffline: (
//             RtcConnection connection,
//             int uid,
//             UserOfflineReasonType reason,
//             ) {
//           remoteUid.value = null;
//           debugPrint("🚪 Remote user left: $uid");
//           _endCall();
//         },
//         onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//           isJoined.value = false;
//           remoteUid.value = null;
//           debugPrint("🚪 Left channel");
//         },
//         onError: (ErrorCodeType err, String msg) {
//           debugPrint("❌ Agora Error: $err - $msg");
//         },
//       ),
//     );
//   }
//
//   // ===================== RINGTONE MANAGEMENT =====================
//
//   /// Play ringtone/calling tone
//   Future<void> _playRingtone() async {
//     try {
//       if (_isPlayingRingtone) {
//         debugPrint("⚠️ Ringtone already playing");
//         return;
//       }
//
//       _isPlayingRingtone = true;
//
//       // ✅ Set audio player to loop
//       await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//
//       // ✅ Set volume (0.0 to 1.0)
//       await _audioPlayer.setVolume(0.8);
//
//       // ✅ Play the ringtone from assets
//       await _audioPlayer.play(AssetSource('audios/ringback_tone.mp3'));
//
//       debugPrint("🔔 Playing ringtone: ${isIncoming ? 'Incoming' : 'Outgoing'}");
//     } catch (e) {
//       debugPrint("❌ Error playing ringtone: $e");
//       _isPlayingRingtone = false;
//     }
//   }
//
//   /// Stop ringtone
//   Future<void> _stopRingtone() async {
//     try {
//       if (!_isPlayingRingtone) {
//         return;
//       }
//
//       await _audioPlayer.stop();
//       _isPlayingRingtone = false;
//       debugPrint("🔇 Ringtone stopped");
//     } catch (e) {
//       debugPrint("❌ Error stopping ringtone: $e");
//     }
//   }
//
//   // ===================== CALL ACTIONS =====================
//
//   Future<void> _createCall() async {
//     try {
//       isLoading.value = true;
//       state.value = CallState.calling;
//
//       String currentUserId = StorageHelper().getUserId.toString();
//
//       // ✅ Get current user info for notification
//       String currentUserName = userName;
//       String currentUserAvatar = userAvatar;
//
//       Map<String, dynamic> body = {
//         ApiParam.request: 'create_call',
//         ApiParam.callerId: currentUserId,
//         ApiParam.receiverId: receiverId,
//         ApiParam.callType: isVideo ? 'video' : 'audio',
//         'caller_name': currentUserName,
//         'caller_avatar': currentUserAvatar,
//       };
//
//       var result = await ApiManager.callPostWithFormData(
//         body: body,
//         endPoint: ApiUtils.createCall,
//       );
//
//       isLoading.value = false;
//
//       if (result != null && result['status'] == 'success') {
//         final callResponse = CallResponseModel.fromJson(result);
//         _callData = callResponse.data;
//         _callId = callResponse.data?.callId?.toString();
//         _localUid = callResponse.data?.uid;
//
//         _showSuccess(callResponse.message ?? "Call created");
//
//         // ✅ Backend automatically sends FCM notification to receiver
//         debugPrint("📤 FCM notification sent to receiver");
//
//         // Join channel automatically for caller
//         await _joinChannel();
//       } else {
//         // ✅ Stop ringtone on error
//         await _stopRingtone();
//         _showError(result?['message'] ?? "Failed to create call");
//         Get.back();
//       }
//     } catch (e) {
//       isLoading.value = false;
//       // ✅ Stop ringtone on error
//       await _stopRingtone();
//       _showError("Error creating call: $e");
//       Get.back();
//     }
//   }
//
//   // ✅ Accept incoming call
//   Future<void> acceptCall() async {
//     try {
//       // ✅ Stop ringtone when accepting call
//       await _stopRingtone();
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'accept',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       state.value = CallState.calling;
//       await _joinChannel();
//     } catch (e) {
//       _showError("Failed to accept call: $e");
//     }
//   }
//
//   // ✅ Reject incoming call
//   Future<void> rejectCall() async {
//     try {
//       // ✅ Stop ringtone when rejecting call
//       await _stopRingtone();
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'reject',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       Get.back();
//     } catch (e) {
//       debugPrint("Error rejecting call: $e");
//       Get.back();
//     }
//   }
//
//   Future<void> endCall() async {
//     // ✅ Stop ringtone when ending call
//     await _stopRingtone();
//     await _endCall();
//     Get.back();
//   }
//
//   Future<void> _endCall() async {
//     try {
//       _timer?.cancel();
//       state.value = CallState.ended;
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'end',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       await _agoraService.leaveChannel();
//     } catch (e) {
//       debugPrint("Error ending call: $e");
//     }
//   }
//
//   // ===================== AGORA CHANNEL =====================
//
//   Future<void> _joinChannel() async {
//     if (_callData == null) {
//       _showError("Call data not available");
//       return;
//     }
//
//     try {
//       await _agoraService.joinChannel(
//         token: _callData!.token!,
//         channelName: _callData!.channelName!,
//         uid: _callData!.uid ?? 0,
//         isVideo: isVideo,
//       );
//
//       debugPrint("📞 Joining channel: ${_callData!.channelName}");
//     } catch (e) {
//       _showError("Failed to join channel: $e");
//     }
//   }
//
//   // ===================== CONTROLS =====================
//
//   Future<void> toggleMute() async {
//     isMuted.value = !isMuted.value;
//     await _agoraService.muteLocalAudio(isMuted.value);
//   }
//
//   Future<void> toggleSpeaker() async {
//     isSpeakerOn.value = !isSpeakerOn.value;
//     await _agoraService.toggleSpeaker(isSpeakerOn.value);
//   }
//
//   Future<void> switchCamera() async {
//     if (isVideo) {
//       await _agoraService.switchCamera();
//     }
//   }
//
//   // ===================== TIMER =====================
//
//   void _startTimer() {
//     _timer?.cancel();
//     _seconds = 0;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _seconds++;
//       final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_seconds % 60).toString().padLeft(2, '0');
//       timerString.value = '$minutes:$seconds';
//     });
//   }
//
//   // ===================== UTILITIES =====================
//
//   void _showSuccess(String message) {
//     Get.snackbar(
//       "Success",
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppColors.greenColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   void _showError(String message) {
//     Get.snackbar(
//       "Error",
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: AppColors.redColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 3),
//     );
//   }
// }



// important 2

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:the_friendz_zone/api_helpers/api_manager.dart';
// import 'package:the_friendz_zone/api_helpers/api_param.dart';
// import 'package:the_friendz_zone/api_helpers/api_utils.dart';
// import 'package:the_friendz_zone/helpers/storage_helper.dart';
// import '../../config/app_colors.dart';
// import '../../utils/agora_service.dart';
// import '../../utils/app_enums.dart';
// import 'call_response_model.dart';
//
// class CallController extends GetxController {
//   // Call Information
//   final String userName;
//   final String userAvatar;
//   final String receiverId;
//   final bool isVideo;
//   final bool isIncoming;
//
//   // ✅ Incoming call data
//   final String? incomingCallId;
//   final String? incomingChannelName;
//   final String? incomingToken;
//   final int? incomingUid;
//
//   CallController({
//     required this.userName,
//     required this.userAvatar,
//     required this.receiverId,
//     required this.isVideo,
//     this.isIncoming = false,
//     this.incomingCallId,
//     this.incomingChannelName,
//     this.incomingToken,
//     this.incomingUid,
//   });
//
//   // Observables
//   final state = CallState.idle.obs;
//   final timerString = '00:00'.obs;
//   final isMuted = false.obs;
//   final isSpeakerOn = false.obs;
//   final isLoading = false.obs;
//   final remoteUid = Rxn<int>();
//   final isJoined = false.obs;
//   final showLocalPreview = true.obs; // ✅ Track local preview visibility
//
//   // Private
//   Timer? _timer;
//   int _seconds = 0;
//   CallData? _callData;
//   String? _callId;
//   int? _localUid;
//   final AgoraService _agoraService = AgoraService.instance;
//
//   // ✅ Audio player for ringtone
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlayingRingtone = false;
//
//   // Public getters for private fields
//   CallData? get callData => _callData;
//   int? get localUid => _localUid;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCall();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     _stopRingtone(); // ✅ Stop ringtone
//     _audioPlayer.dispose(); // ✅ Dispose player
//     super.onClose();
//   }
//
//   // ===================== INITIALIZATION =====================
//
//   Future<void> _initializeCall() async {
//     try {
//       debugPrint('📱 Initializing ${isVideo ? 'Video' : 'Audio'} Call');
//       debugPrint('📞 Type: ${isIncoming ? 'Incoming' : 'Outgoing'}');
//       debugPrint('👤 To: $userName ($receiverId)');
//
//       // Request permissions
//       final hasPermission = await _agoraService.requestPermissions(
//         isVideo: isVideo,
//       );
//
//       if (!hasPermission) {
//         _showError("Required permissions not granted");
//         Get.back();
//         return;
//       }
//
//       // Initialize Agora if not already
//       if (!_agoraService.isInitialized) {
//         debugPrint('🔄 Initializing Agora Engine');
//         await _agoraService.initialize();
//       }
//
//       // Setup event handlers
//       _setupEventHandlers();
//
//       // ✅ Enable audio FIRST
//       await _agoraService.enableAudio();
//       debugPrint('🔊 Audio enabled');
//
//       // ✅ Handle incoming vs outgoing call
//       if (isIncoming) {
//         // RECEIVER: Incoming call flow
//         _handleIncomingCall();
//       } else {
//         // CALLER: Outgoing call flow
//         _handleOutgoingCall();
//       }
//     } catch (e, stackTrace) {
//       debugPrint('❌ Initialize Call Error: $e');
//       debugPrint('Stack: $stackTrace');
//       _showError("Failed to initialize call: $e");
//       Get.back();
//     }
//   }
//
//   void _setupEventHandlers() {
//     _agoraService.registerEventHandlers(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           isJoined.value = true;
//           debugPrint("✅ Joined channel successfully: ${connection.channelId}");
//
//           // Start timer when call is connected
//           if (state.value == CallState.connected) {
//             _startTimer();
//           }
//         },
//         onUserJoined: (RtcConnection connection, int uid, int elapsed) {
//           debugPrint("👥 Remote user joined: $uid");
//
//           // ✅ Stop ringtone when remote user joins
//           _stopRingtone();
//
//           remoteUid.value = uid;
//           state.value = CallState.connected;
//           _startTimer();
//
//           // For video calls, hide local preview when showing remote
//           if (isVideo) {
//             showLocalPreview.value = false;
//           }
//         },
//         onUserOffline: (
//             RtcConnection connection,
//             int uid,
//             UserOfflineReasonType reason,
//             ) {
//           debugPrint("👋 Remote user left: $uid (Reason: $reason)");
//           remoteUid.value = null;
//           _endCall();
//         },
//         onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//           debugPrint("🚪 Left channel: ${connection.channelId}");
//           isJoined.value = false;
//           remoteUid.value = null;
//         },
//         onError: (ErrorCodeType err, String msg) {
//           debugPrint("❌ Agora Error: $err - $msg");
//           _showError("Call error: $msg");
//         },
//       ),
//     );
//   }
//
//   Future<void> _handleIncomingCall() async {
//     try {
//       debugPrint('📞 Setting up incoming call...');
//
//       _callId = incomingCallId;
//       _callData = CallData(
//         callId: int.tryParse(incomingCallId ?? ''),
//         channelName: incomingChannelName,
//         token: incomingToken,
//         uid: incomingUid,
//       );
//       _localUid = incomingUid;
//
//       debugPrint('📋 Incoming Call Data:');
//       debugPrint('  Call ID: $_callId');
//       debugPrint('  Channel: ${_callData?.channelName}');
//       debugPrint('  Token: ${_callData?.token?.substring(0, 20)}...');
//       debugPrint('  UID: ${_callData?.uid}');
//
//       state.value = CallState.ringing;
//
//       // ✅ Setup video if it's a video call
//       if (isVideo) {
//         debugPrint('📹 Setting up video for incoming call');
//         await _agoraService.enableVideo(); // This already starts preview
//         showLocalPreview.value = true;
//       }
//
//       // ✅ Play ringtone
//       await _playRingtone();
//
//       debugPrint('✅ Incoming call setup complete');
//
//     } catch (e, stackTrace) {
//       debugPrint('❌ Handle Incoming Call Error: $e');
//       debugPrint('Stack: $stackTrace');
//       _showError("Failed to setup incoming call");
//       Get.back();
//     }
//   }
//
//   Future<void> _handleOutgoingCall() async {
//     try {
//       debugPrint('📞 Creating outgoing call...');
//       state.value = CallState.calling;
//
//       // ✅ Setup video for outgoing video call
//       if (isVideo) {
//         debugPrint('📹 Setting up video for outgoing call');
//         await _agoraService.enableVideo(); // This already starts preview
//         showLocalPreview.value = true;
//       }
//
//       // ✅ Play ringtone immediately
//       await _playRingtone();
//
//       // Create call in backend
//       await _createCall();
//
//     } catch (e, stackTrace) {
//       debugPrint('❌ Handle Outgoing Call Error: $e');
//       debugPrint('Stack: $stackTrace');
//       _showError("Failed to create call");
//       Get.back();
//     }
//   }
//
//   // ===================== RINGTONE MANAGEMENT =====================
//
//   /// Play ringtone/calling tone
//   Future<void> _playRingtone() async {
//     try {
//       if (_isPlayingRingtone) {
//         debugPrint("⚠️ Ringtone already playing");
//         return;
//       }
//
//       _isPlayingRingtone = true;
//
//       // ✅ Set audio player to loop
//       await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//
//       // ✅ Set volume (0.0 to 1.0)
//       await _audioPlayer.setVolume(1.0);
//
//       // ✅ TRY DIFFERENT ASSET PATHS
//       final ringtonePaths = [
//         'audios/ringback_tone.mp3',
//         'audio/ringback_tone.mp3',
//         'assets/audios/ringback_tone.mp3',
//         'assets/audio/ringback_tone.mp3',
//         'ringback_tone.mp3',
//       ];
//
//       bool played = false;
//
//       for (final path in ringtonePaths) {
//         try {
//           debugPrint("🔔 Trying to play ringtone from: $path");
//           await _audioPlayer.play(AssetSource(path));
//           debugPrint("✅ Playing ringtone from: $path");
//           played = true;
//           break;
//         } catch (e) {
//           debugPrint("❌ Failed to play from $path: $e");
//           continue;
//         }
//       }
//
//       if (!played) {
//         // Try to use system sound as fallback
//         try {
//           debugPrint("🔔 Trying to use system sound");
//           await _audioPlayer.play(AssetSource('sounds/ringback_tone.mp3'));
//           played = true;
//         } catch (e) {
//           debugPrint("⚠️ Could not play any ringtone");
//           _isPlayingRingtone = false;
//         }
//       }
//
//     } catch (e, stackTrace) {
//       debugPrint("❌ Error playing ringtone: $e");
//       debugPrint("Stack: $stackTrace");
//       _isPlayingRingtone = false;
//     }
//   }
//
//   /// Stop ringtone
//   Future<void> _stopRingtone() async {
//     try {
//       if (!_isPlayingRingtone) {
//         return;
//       }
//
//       await _audioPlayer.stop();
//       _isPlayingRingtone = false;
//       debugPrint("🔇 Ringtone stopped");
//     } catch (e) {
//       debugPrint("❌ Error stopping ringtone: $e");
//     }
//   }
//
//   // ===================== CALL ACTIONS =====================
//
//   Future<void> _createCall() async {
//     try {
//       isLoading.value = true;
//
//       String currentUserId = StorageHelper().getUserId.toString();
//
//       debugPrint('📤 Creating call via API...');
//       debugPrint('  Caller ID: $currentUserId');
//       debugPrint('  Receiver ID: $receiverId');
//       debugPrint('  Type: ${isVideo ? 'video' : 'audio'}');
//
//       Map<String, dynamic> body = {
//         ApiParam.request: 'create_call',
//         ApiParam.callerId: currentUserId,
//         ApiParam.receiverId: receiverId,
//         ApiParam.callType: isVideo ? 'video' : 'audio',
//         'caller_name': userName,
//         'caller_avatar': userAvatar,
//       };
//
//       var result = await ApiManager.callPostWithFormData(
//         body: body,
//         endPoint: ApiUtils.createCall,
//       );
//
//       isLoading.value = false;
//
//       if (result != null && result['status'] == 'success') {
//         debugPrint('✅ Call created successfully');
//
//         final callResponse = CallResponseModel.fromJson(result);
//         _callData = callResponse.data;
//         _callId = callResponse.data?.callId?.toString();
//         _localUid = callResponse.data?.uid;
//
//         debugPrint('📊 Call Response:');
//         debugPrint('  Call ID: $_callId');
//         debugPrint('  Channel: ${_callData?.channelName}');
//         debugPrint('  Token: ${_callData?.token?.substring(0, 20)}...');
//         debugPrint('  UID: $_localUid');
//
//         _showSuccess(callResponse.message ?? "Call created");
//
//         // Join channel for caller
//         await _joinChannel();
//       } else {
//         // ✅ Stop ringtone on error
//         await _stopRingtone();
//         final errorMsg = result?['message'] ?? "Failed to create call";
//         debugPrint('❌ Call creation failed: $errorMsg');
//         _showError(errorMsg);
//         Get.back();
//       }
//     } catch (e, stackTrace) {
//       isLoading.value = false;
//       // ✅ Stop ringtone on error
//       await _stopRingtone();
//       debugPrint('❌ Create Call Error: $e');
//       debugPrint('Stack: $stackTrace');
//       _showError("Error creating call: $e");
//       Get.back();
//     }
//   }
//
//   // ✅ Accept incoming call
//   Future<void> acceptCall() async {
//     try {
//       debugPrint('✅ Accepting incoming call...');
//
//       // ✅ Stop ringtone when accepting call
//       await _stopRingtone();
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'accept',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       state.value = CallState.calling;
//       await _joinChannel();
//     } catch (e) {
//       debugPrint('❌ Accept Call Error: $e');
//       _showError("Failed to accept call: $e");
//     }
//   }
//
//   // ✅ Reject incoming call
//   Future<void> rejectCall() async {
//     try {
//       debugPrint('❌ Rejecting call...');
//
//       // ✅ Stop ringtone when rejecting call
//       await _stopRingtone();
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'reject',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       // Leave Agora channel if joined
//       if (isJoined.value) {
//         await _agoraService.leaveChannel();
//       }
//
//       Get.back();
//     } catch (e) {
//       debugPrint("Error rejecting call: $e");
//       Get.back();
//     }
//   }
//
//   Future<void> endCall() async {
//     debugPrint('📞 Ending call...');
//     await _stopRingtone();
//     await _endCall();
//     Get.back();
//   }
//
//   Future<void> _endCall() async {
//     try {
//       _timer?.cancel();
//       state.value = CallState.ended;
//
//       if (_callId != null) {
//         String userId = StorageHelper().getUserId.toString();
//
//         await ApiManager.callPostWithFormData(
//           body: {
//             ApiParam.request: 'response_call',
//             ApiParam.userId: userId,
//             ApiParam.callId: _callId,
//             'action': 'end',
//           },
//           endPoint: ApiUtils.responseCall,
//         );
//       }
//
//       await _agoraService.leaveChannel();
//       debugPrint('✅ Call ended successfully');
//     } catch (e) {
//       debugPrint("Error ending call: $e");
//     }
//   }
//
//   // ===================== AGORA CHANNEL =====================
//
//   Future<void> _joinChannel() async {
//     if (_callData == null) {
//       _showError("Call data not available");
//       return;
//     }
//
//     try {
//       debugPrint('📡 Joining channel: ${_callData!.channelName}');
//       debugPrint('  UID: ${_callData!.uid}');
//       debugPrint('  Token: ${_callData!.token?.substring(0, 20)}...');
//
//       await _agoraService.joinChannel(
//         token: _callData!.token!,
//         channelName: _callData!.channelName!,
//         uid: _callData!.uid ?? 0,
//         isVideo: isVideo,
//       );
//
//       debugPrint('✅ Channel join initiated');
//     } catch (e) {
//       debugPrint('❌ Join Channel Error: $e');
//       _showError("Failed to join channel: $e");
//     }
//   }
//
//   // ===================== CONTROLS =====================
//
//   Future<void> toggleMute() async {
//     isMuted.value = !isMuted.value;
//     await _agoraService.muteLocalAudio(isMuted.value);
//     debugPrint(isMuted.value ? '🔇 Muted' : '🔊 Unmuted');
//   }
//
//   Future<void> toggleSpeaker() async {
//     try {
//       isSpeakerOn.value = !isSpeakerOn.value;
//       await _agoraService.toggleSpeaker(isSpeakerOn.value);
//       debugPrint(isSpeakerOn.value ? '🔊 Speaker ON' : '📱 Earpiece');
//     } catch (e) {
//       debugPrint('❌ Toggle Speaker Error: $e');
//       // Handle gracefully - this might fail on some devices
//       isSpeakerOn.value = !isSpeakerOn.value;
//     }
//   }
//
//   Future<void> switchCamera() async {
//     if (isVideo) {
//       await _agoraService.switchCamera();
//       debugPrint('📸 Camera switched');
//     }
//   }
//
//   // ===================== TIMER =====================
//
//   void _startTimer() {
//     _timer?.cancel();
//     _seconds = 0;
//
//     debugPrint('⏱️ Starting call timer');
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _seconds++;
//       final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
//       final seconds = (_seconds % 60).toString().padLeft(2, '0');
//       timerString.value = '$minutes:$seconds';
//     });
//   }
//
//   // ===================== UTILITIES =====================
//
//   void _showSuccess(String message) {
//     Get.snackbar(
//       "Success",
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: AppColors.greenColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   void _showError(String message) {
//     Get.snackbar(
//       "Error",
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: AppColors.redColor.withOpacity(0.8),
//       colorText: AppColors.whiteColor,
//       duration: const Duration(seconds: 3),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:the_friendz_zone/api_helpers/api_manager.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import '../../config/app_colors.dart';
import '../../utils/agora_service.dart';
import '../../utils/app_enums.dart';
import 'call_response_model.dart';

class CallController extends GetxController {
  final String userName;
  final String userAvatar;
  final String receiverId;
  final bool isVideo;
  final bool isIncoming;

  final String? incomingCallId;
  final String? incomingChannelName;
  final String? incomingToken;
  final int? incomingUid;

  CallController({
    required this.userName,
    required this.userAvatar,
    required this.receiverId,
    required this.isVideo,
    this.isIncoming = false,
    this.incomingCallId,
    this.incomingChannelName,
    this.incomingToken,
    this.incomingUid,
  });

  // Observables
  final state = CallState.idle.obs;
  final timerString = '00:00'.obs;
  final isMuted = false.obs;
  final isSpeakerOn = false.obs;
  final isLoading = false.obs;
  final remoteUid = Rxn<int>();
  final isJoined = false.obs;
  final isVideoOn = true.obs; // ✅ Video toggle state

  // Private
  Timer? _timer;
  int _seconds = 0;
  CallData? _callData;
  String? _callId;
  int? _localUid;
  final AgoraService _agoraService = AgoraService.instance;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingRingtone = false;

  CallData? get callData => _callData;
  int? get localUid => _localUid;

  @override
  void onInit() {
    super.onInit();
    _initializeCall();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _stopRingtone();
    _audioPlayer.dispose();
    super.onClose();
  }

  // ===================== INITIALIZATION =====================

  Future<void> _initializeCall() async {
    try {
      debugPrint('📱 Initializing ${isVideo ? 'Video' : 'Audio'} Call');
      debugPrint('📞 Type: ${isIncoming ? 'Incoming' : 'Outgoing'}');
      debugPrint('👤 To: $userName ($receiverId)');

      final hasPermission = await _agoraService.requestPermissions(
        isVideo: isVideo,
      );

      if (!hasPermission) {
        _showError("Required permissions not granted");
        Get.back();
        return;
      }

      if (!_agoraService.isInitialized) {
        await _agoraService.initialize();
      }

      _setupEventHandlers();

      // ✅ Enable audio
      await _agoraService.enableAudio();

      // ✅ Enable video for video calls BEFORE anything else
      if (isVideo) {
        await _agoraService.enableVideo();
        await _agoraService.startPreview();
        isVideoOn.value = true;
      }

      if (isIncoming) {
        _handleIncomingCall();
      } else {
        _handleOutgoingCall();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Initialize Error: $e\n$stackTrace');
      _showError("Failed to initialize: $e");
      Get.back();
    }
  }

  void _setupEventHandlers() {
    _agoraService.registerEventHandlers(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined.value = true;
          debugPrint("✅ Joined channel: ${connection.channelId}");

          if (state.value == CallState.connected) {
            _startTimer();
          }
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("👥 Remote user joined: $uid");

          _stopRingtone();
          remoteUid.value = uid;
          state.value = CallState.connected;
          _startTimer();
        },
        onUserOffline: (connection, uid, reason) {
          debugPrint("👋 Remote user left: $uid");
          remoteUid.value = null;
          _endCall();
        },
        onLeaveChannel: (connection, stats) {
          debugPrint("🚪 Left channel: ${connection.channelId}");
          isJoined.value = false;
          remoteUid.value = null;
        },
        onError: (err, msg) {
          debugPrint("❌ Agora Error: $err - $msg");
        },
      ),
    );
  }

  Future<void> _handleIncomingCall() async {
    try {
      _callId = incomingCallId;
      _callData = CallData(
        callId: int.tryParse(incomingCallId ?? ''),
        channelName: incomingChannelName,
        token: incomingToken,
        uid: incomingUid,
      );
      _localUid = incomingUid;

      state.value = CallState.ringing;
      await _playRingtone();

      debugPrint('✅ Incoming call ready');
    } catch (e) {
      debugPrint('❌ Incoming call error: $e');
      _showError("Failed to setup incoming call");
      Get.back();
    }
  }

  Future<void> _handleOutgoingCall() async {
    try {
      state.value = CallState.calling;
      await _playRingtone();
      await _createCall();
    } catch (e) {
      debugPrint('❌ Outgoing call error: $e');
      _showError("Failed to create call");
      Get.back();
    }
  }

  // ===================== RINGTONE =====================

  /// Play ringtone/calling tone
  Future<void> _playRingtone() async {
    if (_isPlayingRingtone) {
      debugPrint("⚠️ Ringtone already playing");
      return;
    }

    try {
      _isPlayingRingtone = true;

      // Set audio player to loop
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      // Set volume (0.0 to 1.0)
      await _audioPlayer.setVolume(1.0);

      // ✅ Play the ringtone - AssetSource adds "assets/" automatically
      await _audioPlayer.play(AssetSource('Assets/audios/ringback_tone.mp3'));

      debugPrint("🔔 Playing ringtone successfully");
    } catch (e) {
      debugPrint("❌ Error playing ringtone: $e");
      _isPlayingRingtone = false;
    }
  }

  Future<void> _stopRingtone() async {
    if (!_isPlayingRingtone) return;

    try {
      await _audioPlayer.stop();
      _isPlayingRingtone = false;
      debugPrint("🔇 Ringtone stopped");
    } catch (e) {
      debugPrint("❌ Stop ringtone error: $e");
    }
  }

  // ===================== CALL ACTIONS =====================

  Future<void> _createCall() async {
    try {
      isLoading.value = true;
      String currentUserId = StorageHelper().getUserId.toString();

      Map<String, dynamic> body = {
        ApiParam.request: 'create_call',
        ApiParam.callerId: currentUserId,
        ApiParam.receiverId: receiverId,
        ApiParam.callType: isVideo ? 'video' : 'audio',
        'caller_name': userName,
        'caller_avatar': userAvatar,
      };

      var result = await ApiManager.callPostWithFormData(
        body: body,
        endPoint: ApiUtils.createCall,
      );

      isLoading.value = false;

      if (result != null && result['status'] == 'success') {
        final callResponse = CallResponseModel.fromJson(result);
        _callData = callResponse.data;
        _callId = callResponse.data?.callId?.toString();
        _localUid = callResponse.data?.uid;

        _showSuccess(callResponse.message ?? "Call created");
        await _joinChannel();
      } else {
        await _stopRingtone();
        _showError(result?['message'] ?? "Failed to create call");
        Get.back();
      }
    } catch (e) {
      isLoading.value = false;
      await _stopRingtone();
      debugPrint('❌ Create call error: $e');
      _showError("Error: $e");
      Get.back();
    }
  }

  Future<void> acceptCall() async {
    try {
      await _stopRingtone();

      if (_callId != null) {
        String userId = StorageHelper().getUserId.toString();
        await ApiManager.callPostWithFormData(
          body: {
            ApiParam.request: 'response_call',
            ApiParam.userId: userId,
            ApiParam.callId: _callId,
            'action': 'accept',
          },
          endPoint: ApiUtils.responseCall,
        );
      }

      state.value = CallState.calling;
      await _joinChannel();
    } catch (e) {
      debugPrint('❌ Accept error: $e');
      _showError("Failed to accept: $e");
    }
  }

  Future<void> rejectCall() async {
    try {
      await _stopRingtone();

      if (_callId != null) {
        String userId = StorageHelper().getUserId.toString();
        await ApiManager.callPostWithFormData(
          body: {
            ApiParam.request: 'response_call',
            ApiParam.userId: userId,
            ApiParam.callId: _callId,
            'action': 'reject',
          },
          endPoint: ApiUtils.responseCall,
        );
      }

      if (isJoined.value) {
        await _agoraService.leaveChannel();
      }

      Get.back();
    } catch (e) {
      debugPrint("❌ Reject error: $e");
      Get.back();
    }
  }

  Future<void> endCall() async {
    await _stopRingtone();
    await _endCall();
    Get.back();
  }

  Future<void> _endCall() async {
    try {
      _timer?.cancel();
      state.value = CallState.ended;

      if (_callId != null) {
        String userId = StorageHelper().getUserId.toString();
        await ApiManager.callPostWithFormData(
          body: {
            ApiParam.request: 'response_call',
            ApiParam.userId: userId,
            ApiParam.callId: _callId,
            'action': 'end',
          },
          endPoint: ApiUtils.responseCall,
        );
      }

      await _agoraService.leaveChannel();
    } catch (e) {
      debugPrint("❌ End call error: $e");
    }
  }

  // ===================== AGORA CHANNEL =====================

  Future<void> _joinChannel() async {
    if (_callData == null) {
      _showError("Call data not available");
      return;
    }

    try {
      await _agoraService.joinChannel(
        token: _callData!.token!,
        channelName: _callData!.channelName!,
        uid: _callData!.uid ?? 0,
        isVideo: isVideo,
      );

      debugPrint('✅ Joined channel: ${_callData!.channelName}');
    } catch (e) {
      debugPrint('❌ Join error: $e');
      _showError("Failed to join: $e");
    }
  }

  // ===================== CONTROLS =====================

  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    await _agoraService.muteLocalAudio(isMuted.value);
    debugPrint(isMuted.value ? '🔇 Muted' : '🔊 Unmuted');
  }

  Future<void> toggleSpeaker() async {
    isSpeakerOn.value = !isSpeakerOn.value;
    await _agoraService.toggleSpeaker(isSpeakerOn.value);
    debugPrint(isSpeakerOn.value ? '🔊 Speaker' : '📱 Earpiece');
  }

  Future<void> switchCamera() async {
    if (isVideo) {
      await _agoraService.switchCamera();
      debugPrint('📸 Camera switched');
    }
  }

  // ✅ NEW: Toggle video on/off
  Future<void> toggleVideo() async {
    if (!isVideo) return;

    try {
      isVideoOn.value = !isVideoOn.value;

      if (isVideoOn.value) {
        // Turn video ON
        await _agoraService.enableVideo();
        await _agoraService.startPreview();
        await _agoraService.updateVideoPublishing(true);
        debugPrint('📹 Video ON');
      } else {
        // Turn video OFF
        await _agoraService.updateVideoPublishing(false);
        await _agoraService.stopPreview();
        debugPrint('📹 Video OFF');
      }
    } catch (e) {
      debugPrint('❌ Toggle video error: $e');
      isVideoOn.value = !isVideoOn.value; // Revert on error
    }
  }

  // ===================== TIMER =====================

  void _startTimer() {
    _timer?.cancel();
    _seconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_seconds % 60).toString().padLeft(2, '0');
      timerString.value = '$minutes:$seconds';
    });
  }

  // ===================== UTILITIES =====================

  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.greenColor.withOpacity(0.8),
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 2),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.redColor.withOpacity(0.8),
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 3),
    );
  }
}