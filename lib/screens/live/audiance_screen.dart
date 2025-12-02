// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class AudienceScreen extends StatefulWidget {
//   final String channelName;
//   final String token;
//
//   const AudienceScreen({super.key, this.channelName = "test", this.token = "007eJxTYFhi19C4YPNhx6pNFQLL9K8EhEjy/JtSc31rUHx3R9ieBd0KDGmmZqYWZqmWFkYGRibG5uYWyZZJBoamlmlGKSYpKSlG/e90MxsCGRkcDj9hZWRgZWBkYGIA8RkYAJmNHi4="});
//
//   @override
//   State<AudienceScreen> createState() => _AudienceScreenState();
// }
//
// class _AudienceScreenState extends State<AudienceScreen> {
//   late final RtcEngine engine;
//   final List<int> users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initEngine();
//   }
//
//   @override
//   void dispose() {
//     engine.leaveChannel();
//     engine.release();
//     super.dispose();
//   }
//
//   Future<void> initEngine() async {
//     await [Permission.microphone, Permission.camera].request();
//
//     engine = createAgoraRtcEngine();
//     await engine.initialize(RtcEngineContext(
//       appId: "f56586e9820243778c9b0159f2d4ddd2",
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//
//     // Enable video
//     await engine.enableVideo();
//
//     // Set as audience
//     await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
//
//     // Event handlers
//     engine.registerEventHandler(RtcEngineEventHandler(
//       onUserJoined: (connection, uid, elapsed) {
//         print("User joined: $uid"); // must appear
//         setState(() {
//           users.add(uid);
//         });
//       },
//       onUserOffline: (connection, uid, reason) {
//         print("User left: $uid");
//         setState(() {
//           users.remove(uid);
//         });
//       },
//       onJoinChannelSuccess: (connection, elapsed) {
//         print("Joined channel successfully!");
//       },
//     ));
//
//     // Join channel
//     await engine.joinChannel(
//       token: widget.token,
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleAudience,
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: users.isEmpty
//           ? const Center(child: Text("Waiting for broadcaster..."))
//           : AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: engine,
//           canvas: VideoCanvas(uid: users.first),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       ),
//     );
//   }
// }
