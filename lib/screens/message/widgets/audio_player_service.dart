// services/audio_player_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'media_cache_service.dart';

/// Singleton service for managing audio playback across the app
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();
  final MediaCacheService _cacheService = MediaCacheService();

  String? _currentUrl;
  String? _currentMessageId;

  final _playerStateController = StreamController<AudioPlayerState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _currentMessageController = StreamController<String?>.broadcast();

  Stream<AudioPlayerState> get playerStateStream =>
      _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<String?> get currentMessageStream => _currentMessageController.stream;

  String? get currentMessageId => _currentMessageId;

  /// Check if audio is currently playing using playerState
  bool get isPlaying => _player.playerState.playing;

  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _player.playerStateStream.listen((state) {
      _playerStateController.add(AudioPlayerState(
        isPlaying: state.playing,
        processingState: state.processingState,
        messageId: _currentMessageId,
      ));
    });

    _player.positionStream.listen((position) {
      _positionController.add(position);
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        _durationController.add(duration);
      }
    });

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _currentMessageId = null;
        _currentUrl = null;
        _currentMessageController.add(null);
      }
    });

    _isInitialized = true;
  }

  Future<void> playAudio({
    required String url,
    required String messageId,
    Duration? startPosition,
  }) async {
    await initialize();

    try {
      // If same audio, toggle play/pause using playerState.playing
      if (_currentUrl == url && _currentMessageId == messageId) {
        if (_player.playerState.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
        return;
      }

      await _player.stop();

      _currentUrl = url;
      _currentMessageId = messageId;
      _currentMessageController.add(messageId);

      final cachedPath = await _cacheService.getCachedFilePath(
        url,
        type: MediaCacheType.audio,
      );

      if (cachedPath != null) {
        await _player.setFilePath(cachedPath);
        debugPrint('Playing audio from cache');
      } else {
        final file = await _cacheService.getFile(
          url,
          type: MediaCacheType.audio,
        );

        if (file != null) {
          await _player.setFilePath(file.path);
          debugPrint('Playing audio after download');
        } else {
          await _player.setUrl(url);
          debugPrint('Streaming audio');
        }
      }

      if (startPosition != null) {
        await _player.seek(startPosition);
      }

      await _player.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _currentUrl = null;
      _currentMessageId = null;
      _currentMessageController.add(null);
      rethrow;
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentUrl = null;
    _currentMessageId = null;
    _currentMessageController.add(null);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  bool isMessagePlaying(String messageId) {
    return _currentMessageId == messageId && _player.playerState.playing;
  }

  bool isCurrentMessage(String messageId) {
    return _currentMessageId == messageId;
  }

  Future<void> preloadAudio(String url) async {
    _cacheService.getFile(
      url,
      type: MediaCacheType.audio,
      lowPriority: true,
    );
  }

  void dispose() {
    _player.dispose();
    _playerStateController.close();
    _positionController.close();
    _durationController.close();
    _currentMessageController.close();
  }
}

class AudioPlayerState {
  final bool isPlaying;
  final ProcessingState processingState;
  final String? messageId;

  AudioPlayerState({
    required this.isPlaying,
    required this.processingState,
    this.messageId,
  });

  bool get isLoading => processingState == ProcessingState.loading;
  bool get isBuffering => processingState == ProcessingState.buffering;
  bool get isCompleted => processingState == ProcessingState.completed;
  bool get isIdle => processingState == ProcessingState.idle;
}
