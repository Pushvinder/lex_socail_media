// widgets/audio_message_widget.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_player_service.dart';
import 'media_cache_service.dart';

/// Widget for displaying and playing audio messages
class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final String messageId;
  final int? duration;
  final bool isSentByMe;
  final VoidCallback? onLongPress;

  const AudioMessageWidget({
    Key? key,
    required this.audioUrl,
    required this.messageId,
    this.duration,
    this.isSentByMe = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayerService _audioService = AudioPlayerService();
  final MediaCacheService _cacheService = MediaCacheService();

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _currentMessageSubscription;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isCached = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _isCached = await _cacheService.isCached(
      widget.audioUrl,
      type: MediaCacheType.audio,
    );

    if (widget.duration != null) {
      _duration = Duration(seconds: widget.duration!);
    }

    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      if (state.messageId == widget.messageId) {
        if (mounted) {
          setState(() {
            _isPlaying = state.isPlaying;
            _isLoading = state.isLoading || state.isBuffering;
          });
        }
      } else if (_isPlaying) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _isLoading = false;
          });
        }
      }
    });

    _positionSubscription = _audioService.positionStream.listen((position) {
      if (_audioService.currentMessageId == widget.messageId && mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (_audioService.currentMessageId == widget.messageId && mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _currentMessageSubscription = _audioService.currentMessageStream.listen((messageId) {
      if (messageId != widget.messageId && mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    if (!_isCached) {
      _audioService.preloadAudio(widget.audioUrl);
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _currentMessageSubscription?.cancel();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      await _audioService.playAudio(
        url: widget.audioUrl,
        messageId: widget.messageId,
      );
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to play audio')),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isSentByMe ? Colors.white : Theme.of(context).primaryColor;
    final secondaryColor = widget.isSentByMe ? Colors.white.withOpacity(0.7) : Colors.grey;

    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.2),
                ),
                child: _isLoading
                    ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
                    : Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: primaryColor,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24,
                    child: CustomPaint(
                      painter: WaveformPainter(
                        progress: progress,
                        activeColor: primaryColor,
                        inactiveColor: secondaryColor.withOpacity(0.3),
                      ),
                      size: const Size(double.infinity, 24),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(color: secondaryColor, fontSize: 11),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(color: secondaryColor, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_isCached)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.download_done_rounded,
                  color: secondaryColor,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  WaveformPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const barWidth = 3.0;
    const barSpacing = 2.0;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();
    final progressBars = (totalBars * progress).floor();

    final heights = List.generate(totalBars, (index) {
      final seed = (index * 7 + 3) % 11;
      return 0.3 + (seed / 11) * 0.7;
    });

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + barSpacing);
      final height = size.height * heights[i];
      final y = (size.height - height) / 2;

      final paint = Paint()
        ..color = i < progressBars ? activeColor : inactiveColor
        ..strokeCap = StrokeCap.round;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, height),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.activeColor != activeColor;
  }
}

class VoiceNoteWidget extends StatelessWidget {
  final String audioUrl;
  final String messageId;
  final int? duration;
  final bool isSentByMe;
  final VoidCallback? onLongPress;

  const VoiceNoteWidget({
    Key? key,
    required this.audioUrl,
    required this.messageId,
    this.duration,
    this.isSentByMe = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.mic_rounded,
          color: isSentByMe ? Colors.white70 : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 4),
        AudioMessageWidget(
          audioUrl: audioUrl,
          messageId: messageId,
          duration: duration,
          isSentByMe: isSentByMe,
          onLongPress: onLongPress,
        ),
      ],
    );
  }
}