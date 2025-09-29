import '../../../config/app_config.dart';
import '../audio_call_controller.dart';

class AudioCallButtons extends StatelessWidget {
  final AudioCallState state;
  final VoidCallback onSpeaker;
  final VoidCallback onMute;
  final VoidCallback onEnd;
  final VoidCallback onAccept;
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isVideo;

  const AudioCallButtons({
    required this.state,
    required this.onSpeaker,
    required this.onMute,
    required this.onEnd,
    required this.onAccept,
    required this.isMuted,
    required this.isSpeakerOn,
    required this.isVideo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == AudioCallState.incoming) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reject Button
          GestureDetector(
            onTap: onEnd,
            child: CircleAvatar(
              radius: AppDimens.dimen40,
              backgroundColor: AppColors.rejectBgColor,
              child: Image.asset(
                AppImages.endCallIcon,
                width: AppDimens.dimen32,
              ),
            ),
          ),
          SizedBox(width: AppDimens.dimen40),
          // Accept Button
          GestureDetector(
            onTap: onAccept,
            child: CircleAvatar(
              radius: AppDimens.dimen40,
              backgroundColor: AppColors.greenColor,
              child: Image.asset(
                AppImages.acceptCallIcon,
                width: AppDimens.dimen32,
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isVideo
            ?
            // Switch Camera Button
            Padding(
                padding: EdgeInsets.only(right: AppDimens.dimen24),
                child: GestureDetector(
                  onTap: onSpeaker,
                  child: CircleAvatar(
                    radius: AppDimens.dimen40,
                    backgroundColor: AppColors.callBg,
                    child: Image.asset(
                      AppImages.recIcon,
                      width: AppDimens.dimen40,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
        // Speaker Button
        GestureDetector(
          onTap: onSpeaker,
          child: CircleAvatar(
            radius: AppDimens.dimen40,
            backgroundColor: AppColors.callBg,
            child: Image.asset(
              isSpeakerOn ? AppImages.speakerOnIcon : AppImages.speakerOnIcon,
              width: AppDimens.dimen40,
            ),
          ),
        ),
        SizedBox(width: AppDimens.dimen24),
        // Mute Button
        GestureDetector(
          onTap: onMute,
          child: CircleAvatar(
            radius: AppDimens.dimen40,
            backgroundColor: AppColors.callBg,
            child: Image.asset(
              isMuted ? AppImages.micOffIcon : AppImages.micOffIcon,
              width: AppDimens.dimen40,
            ),
          ),
        ),
        SizedBox(width: AppDimens.dimen24),
        // End Call Button
        GestureDetector(
          onTap: onEnd,
          child: CircleAvatar(
            radius: AppDimens.dimen40,
            backgroundColor: AppColors.rejectBgColor,
            child: Image.asset(
              AppImages.endCallIcon,
              width: AppDimens.dimen55,
            ),
          ),
        ),
      ],
    );
  }
}
