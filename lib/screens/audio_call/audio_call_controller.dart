import '../../config/app_config.dart';

enum AudioCallState { incoming, calling, connected }

class AudioCallController extends GetxController {
  final RxString callerName;
  final RxString profileImage;
  final bool isVideo;
  var state = AudioCallState.calling.obs;
  var timerString = '00:00'.obs;
  var isMuted = false.obs;
  var isSpeakerOn = false.obs;

  Timer? _timer;
  int _seconds = 0;

  AudioCallController({
    required String callerName,
    required String profileImage,
    this.isVideo = false,
  })  : callerName = callerName.obs,
        profileImage = profileImage.obs;

  void acceptCall() {
    state.value = AudioCallState.connected;
    _startTimer();
  }

  void endCall() {
    _timer?.cancel();
    Get.back();
  }

  void toggleMute() => isMuted.value = !isMuted.value;

  void toggleSpeaker() => isSpeakerOn.value = !isSpeakerOn.value;

  void _startTimer() {
    _timer?.cancel();
    _seconds = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _seconds++;
      final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_seconds % 60).toString().padLeft(2, '0');
      timerString.value = "$minutes:$seconds";
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
