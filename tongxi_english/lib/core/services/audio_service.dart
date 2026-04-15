import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Audio service for managing audio playback throughout the app
/// 
/// Wraps the audioplayers package to provide a consistent interface
/// for playing pronunciation audio, sound effects, and background music.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Audio players for different purposes
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  // State
  bool _isInitialized = false;
  double _masterVolume = 1.0;
  double _sfxVolume = 1.0;
  double _bgmVolume = 0.5;
  bool _isMuted = false;

  /// Initialize the audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure audio players
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
      await _sfxPlayer.setReleaseMode(ReleaseMode.release);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      // Set initial volumes
      await _updateVolumes();

      _isInitialized = true;

      if (kDebugMode) {
        print('AudioService initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AudioService initialization error: $e');
      }
    }
  }

  /// Dispose all audio players
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _sfxPlayer.dispose();
    await _bgmPlayer.dispose();
    _isInitialized = false;
  }

  /// Play audio from URL (network)
  Future<void> playFromUrl(String url) async {
    if (!_isInitialized) await initialize();
    if (_isMuted) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing audio from URL: $e');
      }
    }
  }

  /// Play audio from local file path
  Future<void> playFromFile(String filePath) async {
    if (!_isInitialized) await initialize();
    if (_isMuted) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(filePath));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing audio from file: $e');
      }
    }
  }

  /// Play audio from asset
  Future<void> playFromAsset(String assetPath) async {
    if (!_isInitialized) await initialize();
    if (_isMuted) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing audio from asset: $e');
      }
    }
  }

  /// Play sound effect
  Future<void> playSoundEffect(String assetPath) async {
    if (!_isInitialized) await initialize();
    if (_isMuted) return;

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound effect: $e');
      }
    }
  }

  /// Play correct answer sound
  Future<void> playCorrectSound() async {
    await playSoundEffect('audio/sfx/correct.mp3');
  }

  /// Play wrong answer sound
  Future<void> playWrongSound() async {
    await playSoundEffect('audio/sfx/wrong.mp3');
  }

  /// Play button click sound
  Future<void> playButtonClickSound() async {
    await playSoundEffect('audio/sfx/click.mp3');
  }

  /// Play achievement unlock sound
  Future<void> playAchievementSound() async {
    await playSoundEffect('audio/sfx/achievement.mp3');
  }

  /// Play level up sound
  Future<void> playLevelUpSound() async {
    await playSoundEffect('audio/sfx/level_up.mp3');
  }

  /// Start background music
  Future<void> playBackgroundMusic(String assetPath) async {
    if (!_isInitialized) await initialize();
    if (_isMuted) return;

    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.play(AssetSource(assetPath));
      await _bgmPlayer.setVolume(_bgmVolume);
    } catch (e) {
      if (kDebugMode) {
        print('Error playing background music: $e');
      }
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.stop();
  }

  /// Pause background music
  Future<void> pauseBackgroundMusic() async {
    await _bgmPlayer.pause();
  }

  /// Resume background music
  Future<void> resumeBackgroundMusic() async {
    if (!_isMuted) {
      await _bgmPlayer.resume();
    }
  }

  /// Stop all audio
  Future<void> stopAll() async {
    await _audioPlayer.stop();
    await _sfxPlayer.stop();
    await _bgmPlayer.stop();
  }

  /// Pause all audio
  Future<void> pauseAll() async {
    await _audioPlayer.pause();
    await _sfxPlayer.pause();
    await _bgmPlayer.pause();
  }

  /// Set master volume (0.0 to 1.0)
  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
    await _updateVolumes();
  }

  /// Set SFX volume (0.0 to 1.0)
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume * _masterVolume);
  }

  /// Set BGM volume (0.0 to 1.0)
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    await _bgmPlayer.setVolume(_bgmVolume * _masterVolume);
  }

  /// Mute all audio
  Future<void> mute() async {
    _isMuted = true;
    await _audioPlayer.setVolume(0);
    await _sfxPlayer.setVolume(0);
    await _bgmPlayer.setVolume(0);
  }

  /// Unmute all audio
  Future<void> unmute() async {
    _isMuted = false;
    await _updateVolumes();
  }

  /// Toggle mute state
  Future<void> toggleMute() async {
    if (_isMuted) {
      await unmute();
    } else {
      await mute();
    }
  }

  /// Get current mute state
  bool get isMuted => _isMuted;

  /// Get master volume
  double get masterVolume => _masterVolume;

  /// Get SFX volume
  double get sfxVolume => _sfxVolume;

  /// Get BGM volume
  double get bgmVolume => _bgmVolume;

  /// Update all volumes based on master volume
  Future<void> _updateVolumes() async {
    if (_isMuted) return;

    await _audioPlayer.setVolume(_masterVolume);
    await _sfxPlayer.setVolume(_sfxVolume * _masterVolume);
    await _bgmPlayer.setVolume(_bgmVolume * _masterVolume);
  }

  /// Stream of audio player state
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  /// Stream of audio position
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;

  /// Stream of audio duration
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;

  /// Get current position
  Future<Duration?> getCurrentPosition() async {
    return await _audioPlayer.getCurrentPosition();
  }

  /// Get current duration
  Future<Duration?> getDuration() async {
    return await _audioPlayer.getDuration();
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
}
