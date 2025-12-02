import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class BroadcastPage extends StatefulWidget {
  final String channelName;
  final String userName;
  final bool isBroadcaster;

  const BroadcastPage(
      {Key? key, this.channelName = '', this.userName= '', this.isBroadcaster = true})
      : super(key: key);

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  late RtcEngine _engine;
  bool muted = false;

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    if ("f56586e9820243778c9b0159f2d4ddd2".isEmpty) {
      setState(() {
        _infoStrings.add('APP_ID missing.');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    await _engine.joinChannel(
      token: "",
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    if(widget.isBroadcaster) {
      await _engine.joinChannel(
        token: "007eJxTYFhi19C4YPNhx6pNFQLL9K8EhEjy/JtSc31rUHx3R9ieBd0KDGmmZqYWZqmWFkYGRibG5uYWyZZJBoamlmlGKSYpKSlG/e90MxsCGRkcDj9hZWRgZWBkYGIA8RkYAJmNHi4=",
        channelId: widget.channelName,
        uid: 0,
        options: ChannelMediaOptions(
          clientRoleType: widget.isBroadcaster
              ? ClientRoleType.clientRoleBroadcaster
              : ClientRoleType.clientRoleAudience,
          publishCameraTrack: widget.isBroadcaster,
          publishMicrophoneTrack: widget.isBroadcaster,
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
        ),
      );
    }else{
     await _engine.leaveChannel();
      await _engine.joinChannel(
        token: "007eJxTYFhi19C4YPNhx6pNFQLL9K8EhEjy/JtSc31rUHx3R9ieBd0KDGmmZqYWZqmWFkYGRibG5uYWyZZJBoamlmlGKSYpKSlG/e90MxsCGRkcDj9hZWRgZWBkYGIA8RkYAJmNHi4=",
        channelId: widget.channelName,
        uid: 111,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
    }
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      RtcEngineContext(
        appId: "f56586e9820243778c9b0159f2d4ddd2",
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.enableVideo();

    // await _engine.setClientRole(
    //   role: widget.isBroadcaster
    //       ? ClientRoleType.clientRoleBroadcaster
    //       : ClientRoleType.clientRoleAudience,
    // );
  }

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType code, message) {
          setState(() {
            _infoStrings.add('onError: $code');
          });
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _infoStrings.add(
                'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}');
          });
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          setState(() {
            _infoStrings.add('userJoined: $uid');
            _users.add(uid);
          });
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          setState(() {
            _infoStrings.add('userOffline: $uid');
            _users.remove(uid);
          });
        },
      ),
    );
  }

  List<Widget> _getRenderViews() {
    final List<Widget> list = [];
    if (widget.isBroadcaster) {
      list.add(
        AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas:  VideoCanvas(
              uid: widget.isBroadcaster ? 0 : 111,
            ),
          ),
        ),
      );
    }

    _users.forEach((int uid) {
      list.add(
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              connection: RtcConnection(channelId: widget.channelName),
              canvas: VideoCanvas(
                uid: uid,
                renderMode: RenderModeType.renderModeFit,
              ),
            ),
          )
      );
    });

    return list;
  }

  Widget _videoView(view) => Expanded(child: Container(child: view));

  Widget _expandedVideoRow(List<Widget> views) =>
      Expanded(child: Row(children: views.map(_videoView).toList()));

  Widget _viewRows() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Column(children: [_videoView(views[0])]);
      case 2:
        return Column(children: [
          _expandedVideoRow([views[0]]),
          _expandedVideoRow([views[1]])
        ]);
      case 3:
        return Column(children: [
          _expandedVideoRow(views.sublist(0, 2)),
          _expandedVideoRow(views.sublist(2, 3))
        ]);
      case 4:
        return Column(children: [
          _expandedVideoRow(views.sublist(0, 2)),
          _expandedVideoRow(views.sublist(2, 4))
        ]);
      default:
        return Container();
    }
  }

  void _onCallEnd(BuildContext context) => Navigator.pop(context);

  void _onToggleMute() {
    setState(() => muted = !muted);
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() => _engine.switchCamera();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child:  _engine == null
            ? const Center(child: CircularProgressIndicator()) // wait until engine initializes
            : Stack(
          children: <Widget>[
            _viewRows(),
            widget.isBroadcaster
                ? Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: _onToggleMute,
                          child: Icon(muted ? Icons.mic_off : Icons.mic),
                          shape: CircleBorder(),
                          fillColor: Colors.white,
                        ),
                        RawMaterialButton(
                          onPressed: () => _onCallEnd(context),
                          child: Icon(Icons.call_end, color: Colors.white),
                          shape: CircleBorder(),
                          fillColor: Colors.red,
                        ),
                        RawMaterialButton(
                          onPressed: _onSwitchCamera,
                          child: Icon(Icons.switch_camera),
                          shape: CircleBorder(),
                          fillColor: Colors.white,
                        ),
                      ],
                    ),
                  )
                : Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: const Icon(Icons.call_end, color: Colors.white),
                  fillColor: Colors.red,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
