// import 'dart:async';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/foundation.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// /// Global Agora Service for managing RTC Engine
// class AgoraService {
//   static AgoraService? _instance;
//   static AgoraService get instance => _instance ??= AgoraService._();
//
//   AgoraService._();
//
//   RtcEngine? _engine;
//   bool _isInitialized = false;
//
//   static const String APP_ID = "f56586e9820243778c9b0159f2d4ddd2";
//
//   RtcEngine get engine {
//     if (_engine == null) {
//       throw Exception("Agora engine not initialized. Call initialize() first.");
//     }
//     return _engine!;
//   }
//
//   bool get isInitialized => _isInitialized;
//
//   /// Initialize Agora Engine
//   Future<void> initialize() async {
//     if (_isInitialized) {
//       debugPrint("✅ Agora already initialized");
//       return;
//     }
//
//     try {
//       _engine = createAgoraRtcEngine();
//
//       await _engine!.initialize(
//         RtcEngineContext(
//           appId: APP_ID,
//           channelProfile: ChannelProfileType.channelProfileCommunication,
//         ),
//       );
//
//       _isInitialized = true;
//       debugPrint("✅ Agora Engine Initialized");
//     } catch (e) {
//       debugPrint("❌ Agora initialization error: $e");
//       rethrow;
//     }
//   }
//
//   /// Request microphone and camera permissions
//   Future<bool> requestPermissions({required bool isVideo}) async {
//     try {
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.microphone,
//         if (isVideo) Permission.camera,
//       ].request();
//
//       bool allGranted = statuses.values.every((status) => status.isGranted);
//
//       if (!allGranted) {
//         debugPrint("❌ Permissions not granted: $statuses");
//       }
//
//       return allGranted;
//     } catch (e) {
//       debugPrint("❌ Permission request error: $e");
//       return false;
//     }
//   }
//
//   /// Enable audio
//   Future<void> enableAudio() async {
//     await _engine?.enableAudio();
//   }
//
//   /// Disable audio
//   Future<void> disableAudio() async {
//     await _engine?.disableAudio();
//   }
//
//   /// Enable video
//   Future<void> enableVideo() async {
//     await _engine?.enableVideo();
//     await _engine?.startPreview();
//   }
//
//   /// Disable video
//   Future<void> disableVideo() async {
//     await _engine?.stopPreview();
//     await _engine?.disableVideo();
//   }
//
//   /// Join a channel
//   Future<void> joinChannel({
//     required String token,
//     required String channelName,
//     required int uid,
//     required bool isVideo,
//   }) async {
//     if (!_isInitialized) {
//       throw Exception("Agora not initialized");
//     }
//
//     await _engine!.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: uid,
//       options: ChannelMediaOptions(
//         autoSubscribeAudio: true,
//         autoSubscribeVideo: isVideo,
//         publishMicrophoneTrack: true,
//         publishCameraTrack: isVideo,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       ),
//     );
//
//     debugPrint("✅ Joined channel: $channelName with UID: $uid");
//   }
//
//   /// Leave a channel
//   Future<void> leaveChannel() async {
//     await _engine?.leaveChannel();
//     debugPrint("🚪 Left channel");
//   }
//
//   /// Toggle microphone mute
//   Future<void> muteLocalAudio(bool mute) async {
//     await _engine?.muteLocalAudioStream(mute);
//   }
//
//   /// Toggle speaker
//   Future<void> toggleSpeaker(bool enable) async {
//     await _engine?.setEnableSpeakerphone(enable);
//   }
//
//   /// Switch camera (front/back)
//   Future<void> switchCamera() async {
//     await _engine?.switchCamera();
//   }
//
//   /// Register event handlers
//   void registerEventHandlers(RtcEngineEventHandler handler) {
//     _engine?.registerEventHandler(handler);
//   }
//
//   /// Unregister event handlers
//   void unregisterEventHandler(RtcEngineEventHandler handler) {
//     _engine?.unregisterEventHandler(handler);
//   }
//
//   /// Release engine resources
//   Future<void> dispose() async {
//     await _engine?.leaveChannel();
//     await _engine?.release();
//     _engine = null;
//     _isInitialized = false;
//     debugPrint("🗑️ Agora Engine Released");
//   }
// }

import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Enhanced Agora Service with video lifecycle management
class AgoraService {
  static AgoraService? _instance;
  static AgoraService get instance => _instance ??= AgoraService._();

  AgoraService._();

  RtcEngine? _engine;
  bool _isInitialized = false;
  bool _isVideoEnabled = false;
  bool _isPreviewing = false;

  // Video state management
  StreamController<bool> _videoStateController = StreamController<bool>.broadcast();
  Stream<bool> get videoStateStream => _videoStateController.stream;

  static const String APP_ID = "f56586e9820243778c9b0159f2d4ddd2";

  RtcEngine get engine {
    if (_engine == null) {
      throw Exception("Agora engine not initialized. Call initialize() first.");
    }
    return _engine!;
  }

  bool get isInitialized => _isInitialized;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isPreviewing => _isPreviewing;

  /// Initialize Agora Engine
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint("✅ Agora already initialized");
      return;
    }

    try {
      _engine = createAgoraRtcEngine();

      await _engine!.initialize(
        RtcEngineContext(
          appId: APP_ID,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Enable video module by default for better performance
      await _engine!.enableVideo();

      _isInitialized = true;
      debugPrint("✅ Agora Engine Initialized with video module enabled");
    } catch (e) {
      debugPrint("❌ Agora initialization error: $e");
      rethrow;
    }
  }

  /// Request microphone and camera permissions
  Future<bool> requestPermissions({required bool isVideo}) async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        if (isVideo) Permission.camera,
      ].request();

      bool allGranted = statuses.values.every((status) => status.isGranted);

      if (!allGranted) {
        debugPrint("❌ Permissions not granted: $statuses");
      }

      return allGranted;
    } catch (e) {
      debugPrint("❌ Permission request error: $e");
      return false;
    }
  }

  /// Enable audio
  Future<void> enableAudio() async {
    await _engine?.enableAudio();
    debugPrint("🔊 Audio enabled");
  }

  /// Disable audio
  Future<void> disableAudio() async {
    await _engine?.disableAudio();
    debugPrint("🔇 Audio disabled");
  }

  /// Enable video and start preview
  Future<void> enableVideo() async {
    if (!_isVideoEnabled) {
      await _engine?.enableVideo();
      _isVideoEnabled = true;
      debugPrint("📹 Video enabled");
    }
  }

  /// Start video preview
  Future<void> startPreview() async {
    if (!_isPreviewing) {
      await _engine?.startPreview();
      _isPreviewing = true;
      _videoStateController.add(true);
      debugPrint("📹 Video preview started");
    }
  }

  /// Stop video preview but keep video module enabled
  Future<void> stopPreview() async {
    if (_isPreviewing) {
      await _engine?.stopPreview();
      _isPreviewing = false;
      _videoStateController.add(false);
      debugPrint("📹 Video preview stopped");
    }
  }

  /// Disable video completely
  Future<void> disableVideo() async {
    if (_isPreviewing) {
      await stopPreview();
    }
    await _engine?.disableVideo();
    _isVideoEnabled = false;
    debugPrint("📹 Video disabled");
  }

  /// Toggle video on/off (for UI button)
  Future<void> toggleVideo() async {
    if (_isPreviewing) {
      await stopPreview();
    } else {
      await startPreview();
    }
  }

  /// Join a channel with proper video state
  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    required bool isVideo,
  }) async {
    if (!_isInitialized) {
      throw Exception("Agora not initialized");
    }

    // Ensure video is enabled for video calls before joining
    if (isVideo && !_isVideoEnabled) {
      await enableVideo();
    }

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: isVideo,
        publishMicrophoneTrack: true,
        publishCameraTrack: isVideo && _isPreviewing, // Only publish if previewing
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    debugPrint("✅ Joined channel: $channelName with UID: $uid");
  }

  /// Update video publishing state (for toggling video during call)
  Future<void> updateVideoPublishing(bool enable) async {
    if (_engine != null) {
      await _engine!.muteLocalVideoStream(!enable);
      debugPrint(enable ? "📹 Started publishing video" : "📹 Stopped publishing video");
    }
  }

  /// Leave a channel
  Future<void> leaveChannel() async {
    // Stop preview before leaving to avoid camera issues
    if (_isPreviewing) {
      await stopPreview();
    }

    await _engine?.leaveChannel();
    debugPrint("🚪 Left channel");
  }

  /// Toggle microphone mute
  Future<void> muteLocalAudio(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
    debugPrint(mute ? "🔇 Audio muted" : "🔊 Audio unmuted");
  }

  /// Toggle speaker
  Future<void> toggleSpeaker(bool enable) async {
    try {
      await _engine?.setEnableSpeakerphone(enable);
      debugPrint(enable ? "🔊 Speaker ON" : "📱 Earpiece");
    } catch (e) {
      debugPrint("⚠️ Speaker toggle may not be supported: $e");
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_isPreviewing) {
      await _engine?.switchCamera();
      debugPrint("📸 Camera switched");
    }
  }

  /// Setup local video view
  Future<void> setupLocalVideo(VideoCanvas canvas) async {
    await _engine?.setupLocalVideo(canvas);
  }

  /// Setup remote video view
  Future<void> setupRemoteVideo(VideoCanvas canvas) async {
    await _engine?.setupRemoteVideo(canvas);
  }

  /// Register event handlers
  void registerEventHandlers(RtcEngineEventHandler handler) {
    _engine?.registerEventHandler(handler);
  }

  /// Unregister event handlers
  void unregisterEventHandler(RtcEngineEventHandler handler) {
    _engine?.unregisterEventHandler(handler);
  }

  /// Release engine resources
  Future<void> dispose() async {
    await leaveChannel();
    await _engine?.release();
    _engine = null;
    _isInitialized = false;
    _isVideoEnabled = false;
    _isPreviewing = false;
    await _videoStateController.close();
    debugPrint("🗑️ Agora Engine Released");
  }
}