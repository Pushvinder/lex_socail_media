// services/voice_recorder_service.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for recording voice messages
class VoiceRecorderService {
  static final VoiceRecorderService _instance = VoiceRecorderService._internal();
  factory VoiceRecorderService() => _instance;
  VoiceRecorderService._internal();

  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;
  Timer? _durationTimer;

  final _isRecordingController = StreamController<bool>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _amplitudeController = StreamController<double>.broadcast();

  Stream<bool> get isRecordingStream => _isRecordingController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  bool get isRecording => _isRecording;

  Duration get recordingDuration {
    if (_recordingStartTime == null) return Duration.zero;
    return DateTime.now().difference(_recordingStartTime!);
  }

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> startRecording() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        debugPrint('Microphone permission denied');
        return false;
      }

      if (_isRecording) {
        await stopRecording();
      }

      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${appDir.path}/voice_$timestamp.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );

      _isRecording = true;
      _recordingStartTime = DateTime.now();
      _isRecordingController.add(true);

      // Start duration timer
      _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_isRecording) {
          _durationController.add(recordingDuration);
          _updateAmplitude();
        }
      });

      return true;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _isRecording = false;
      _isRecordingController.add(false);
      return false;
    }
  }

  Future<void> _updateAmplitude() async {
    try {
      final amplitude = await _recorder.getAmplitude();
      // Normalize amplitude to 0-1 range
      final normalized = ((amplitude.current + 60) / 60).clamp(0.0, 1.0);
      _amplitudeController.add(normalized);
    } catch (e) {
      // Ignore amplitude errors
    }
  }

  Future<RecordingResult?> stopRecording() async {
    try {
      if (!_isRecording) return null;

      _durationTimer?.cancel();
      _durationTimer = null;

      final path = await _recorder.stop();
      final duration = recordingDuration;

      _isRecording = false;
      _recordingStartTime = null;
      _isRecordingController.add(false);

      if (path != null && await File(path).exists()) {
        final file = File(path);
        final fileSize = await file.length();

        return RecordingResult(
          path: path,
          duration: duration,
          fileSize: fileSize,
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _isRecording = false;
      _isRecordingController.add(false);
      return null;
    }
  }

  Future<void> cancelRecording() async {
    try {
      _durationTimer?.cancel();
      _durationTimer = null;

      if (_isRecording) {
        await _recorder.stop();
      }

      // Delete the file if it exists
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _isRecording = false;
      _recordingStartTime = null;
      _currentRecordingPath = null;
      _isRecordingController.add(false);
    } catch (e) {
      debugPrint('Error canceling recording: $e');
    }
  }

  void dispose() {
    _durationTimer?.cancel();
    _recorder.dispose();
    _isRecordingController.close();
    _durationController.close();
    _amplitudeController.close();
  }
}

class RecordingResult {
  final String path;
  final Duration duration;
  final int fileSize;

  RecordingResult({
    required this.path,
    required this.duration,
    required this.fileSize,
  });

  int get durationInSeconds => duration.inSeconds;
}