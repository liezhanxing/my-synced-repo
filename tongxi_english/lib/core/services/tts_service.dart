import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

/// Text-to-Speech service for pronunciation practice
/// 
/// Wraps flutter_tts to provide a consistent interface for speaking
/// English words, phrases, and sentences with configurable speed and voice.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  // State
  bool _isInitialized = false;
  bool _isSpeaking = false;
  double _speechRate = 0.5; // 0.0 to 1.0
  double _volume = 1.0; // 0.0 to 1.0
  double _pitch = 1.0; // 0.5 to 2.0
  String _language = 'en-US';

  /// Initialize TTS
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set default configurations
      await _flutterTts.setLanguage(_language);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setVolume(_volume);
      await _flutterTts.setPitch(_pitch);

      // Set completion handler
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      // Set error handler
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        if (kDebugMode) {
          print('TTS Error: $msg');
        }
      });

      // Set start handler
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _isInitialized = true;

      if (kDebugMode) {
        print('TtsService initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('TtsService initialization error: $e');
      }
    }
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();
    if (text.isEmpty) return;

    try {
      // Stop any current speech
      await stop();

      // Speak the text
      await _flutterTts.speak(text);
    } catch (e) {
      if (kDebugMode) {
        print('TTS speak error: $e');
      }
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (e) {
      if (kDebugMode) {
        print('TTS stop error: $e');
      }
    }
  }

  /// Pause speaking (if supported)
  Future<void> pause() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.pause();
    } catch (e) {
      if (kDebugMode) {
        print('TTS pause error: $e');
      }
    }
  }

  /// Set speech rate (speed)
  /// 
  /// [rate] should be between 0.0 (slowest) and 1.0 (fastest)
  /// Default is 0.5 (normal speed)
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.0, 1.0);
    if (!_isInitialized) await initialize();
    await _flutterTts.setSpeechRate(_speechRate);
  }

  /// Set volume
  /// 
  /// [volume] should be between 0.0 and 1.0
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    if (!_isInitialized) await initialize();
    await _flutterTts.setVolume(_volume);
  }

  /// Set pitch
  /// 
  /// [pitch] should be between 0.5 and 2.0
  /// 1.0 is normal pitch
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    if (!_isInitialized) await initialize();
    await _flutterTts.setPitch(_pitch);
  }

  /// Set language
  /// 
  /// Common codes: 'en-US', 'en-GB', 'zh-CN'
  Future<void> setLanguage(String languageCode) async {
    _language = languageCode;
    if (!_isInitialized) await initialize();
    await _flutterTts.setLanguage(languageCode);
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    if (!_isInitialized) await initialize();
    return await _flutterTts.getLanguages;
  }

  /// Get available voices
  Future<List<dynamic>> getVoices() async {
    if (!_isInitialized) await initialize();
    return await _flutterTts.getVoices;
  }

  /// Check if TTS is speaking
  bool get isSpeaking => _isSpeaking;

  /// Get current speech rate
  double get speechRate => _speechRate;

  /// Get current volume
  double get volume => _volume;

  /// Get current pitch
  double get pitch => _pitch;

  /// Get current language
  String get language => _language;

  /// Speak slowly (for learning)
  Future<void> speakSlowly(String text) async {
    final originalRate = _speechRate;
    await setSpeechRate(0.3);
    await speak(text);
    // Restore original rate after speaking
    await Future.delayed(const Duration(milliseconds: 500));
    await setSpeechRate(originalRate);
  }

  /// Speak at normal speed
  Future<void> speakNormally(String text) async {
    await setSpeechRate(0.5);
    await speak(text);
  }

  /// Speak quickly
  Future<void> speakQuickly(String text) async {
    await setSpeechRate(0.7);
    await speak(text);
  }

  /// Speak a word with emphasis (slower, clearer)
  Future<void> speakWord(String word) async {
    await setSpeechRate(0.3);
    await setPitch(1.0);
    await speak(word);
  }

  /// Dispose TTS
  Future<void> dispose() async {
    await _flutterTts.stop();
    _isInitialized = false;
  }
}
