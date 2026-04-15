import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

/// Local storage service using Hive
/// 
/// Provides persistent storage for user data, progress, and app settings
/// with a simple key-value interface.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Hive boxes
  late Box _userBox;
  late Box _progressBox;
  late Box _settingsBox;

  bool _isInitialized = false;

  /// Initialize storage service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _userBox = Hive.box('userBox');
      _progressBox = Hive.box('progressBox');
      _settingsBox = Hive.box('settingsBox');

      _isInitialized = true;

      if (kDebugMode) {
        print('StorageService initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('StorageService initialization error: $e');
      }
      rethrow;
    }
  }

  // ==================== User Data ====================

  /// Save user data
  Future<void> setUserData(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  /// Get user data
  T? getUserData<T>(String key) {
    return _userBox.get(key) as T?;
  }

  /// Delete user data
  Future<void> deleteUserData(String key) async {
    await _userBox.delete(key);
  }

  /// Clear all user data
  Future<void> clearUserData() async {
    await _userBox.clear();
  }

  /// Save user ID
  Future<void> setUserId(String userId) async {
    await setUserData('userId', userId);
  }

  /// Get user ID
  String? getUserId() {
    return getUserData<String>('userId');
  }

  /// Save auth token
  Future<void> setAuthToken(String token) async {
    await setUserData('authToken', token);
  }

  /// Get auth token
  String? getAuthToken() {
    return getUserData<String>('authToken');
  }

  /// Save user email
  Future<void> setUserEmail(String email) async {
    await setUserData('email', email);
  }

  /// Get user email
  String? getUserEmail() {
    return getUserData<String>('email');
  }

  /// Save user display name
  Future<void> setUserDisplayName(String name) async {
    await setUserData('displayName', name);
  }

  /// Get user display name
  String? getUserDisplayName() {
    return getUserData<String>('displayName');
  }

  /// Save user avatar URL
  Future<void> setUserAvatar(String url) async {
    await setUserData('avatarUrl', url);
  }

  /// Get user avatar URL
  String? getUserAvatar() {
    return getUserData<String>('avatarUrl');
  }

  // ==================== Progress Data ====================

  /// Save progress data
  Future<void> setProgressData(String key, dynamic value) async {
    await _progressBox.put(key, value);
  }

  /// Get progress data
  T? getProgressData<T>(String key) {
    return _progressBox.get(key) as T?;
  }

  /// Delete progress data
  Future<void> deleteProgressData(String key) async {
    await _progressBox.delete(key);
  }

  /// Clear all progress data
  Future<void> clearProgressData() async {
    await _progressBox.clear();
  }

  /// Save word progress
  Future<void> setWordProgress(String wordId, Map<String, dynamic> progress) async {
    await _progressBox.put('word_$wordId', progress);
  }

  /// Get word progress
  Map<String, dynamic>? getWordProgress(String wordId) {
    return getProgressData<Map<String, dynamic>>('word_$wordId');
  }

  /// Save daily streak
  Future<void> setDailyStreak(int streak) async {
    await setProgressData('dailyStreak', streak);
    await setProgressData('lastStudyDate', DateTime.now().toIso8601String());
  }

  /// Get daily streak
  int getDailyStreak() {
    return getProgressData<int>('dailyStreak') ?? 0;
  }

  /// Get last study date
  DateTime? getLastStudyDate() {
    final dateStr = getProgressData<String>('lastStudyDate');
    if (dateStr != null) {
      return DateTime.tryParse(dateStr);
    }
    return null;
  }

  /// Save XP points
  Future<void> setXpPoints(int xp) async {
    await setProgressData('xpPoints', xp);
  }

  /// Get XP points
  int getXpPoints() {
    return getProgressData<int>('xpPoints') ?? 0;
  }

  /// Add XP points
  Future<void> addXpPoints(int xp) async {
    final currentXp = getXpPoints();
    await setXpPoints(currentXp + xp);
  }

  /// Save user level
  Future<void> setUserLevel(int level) async {
    await setProgressData('userLevel', level);
  }

  /// Get user level
  int getUserLevel() {
    return getProgressData<int>('userLevel') ?? 1;
  }

  /// Save completed lessons
  Future<void> setCompletedLessons(List<String> lessonIds) async {
    await setProgressData('completedLessons', lessonIds);
  }

  /// Get completed lessons
  List<String> getCompletedLessons() {
    final list = getProgressData<List>('completedLessons');
    return list?.cast<String>() ?? [];
  }

  /// Add completed lesson
  Future<void> addCompletedLesson(String lessonId) async {
    final lessons = getCompletedLessons();
    if (!lessons.contains(lessonId)) {
      lessons.add(lessonId);
      await setCompletedLessons(lessons);
    }
  }

  // ==================== Settings ====================

  /// Save setting
  Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Get setting
  T? getSetting<T>(String key) {
    return _settingsBox.get(key) as T?;
  }

  /// Delete setting
  Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  /// Clear all settings
  Future<void> clearSettings() async {
    await _settingsBox.clear();
  }

  /// Set dark mode
  Future<void> setDarkMode(bool enabled) async {
    await setSetting('darkMode', enabled);
  }

  /// Get dark mode
  bool getDarkMode() {
    return getSetting<bool>('darkMode') ?? false;
  }

  /// Set notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    await setSetting('notificationsEnabled', enabled);
  }

  /// Get notifications enabled
  bool getNotificationsEnabled() {
    return getSetting<bool>('notificationsEnabled') ?? true;
  }

  /// Set sound enabled
  Future<void> setSoundEnabled(bool enabled) async {
    await setSetting('soundEnabled', enabled);
  }

  /// Get sound enabled
  bool getSoundEnabled() {
    return getSetting<bool>('soundEnabled') ?? true;
  }

  /// Set TTS speed
  Future<void> setTtsSpeed(double speed) async {
    await setSetting('ttsSpeed', speed);
  }

  /// Get TTS speed
  double getTtsSpeed() {
    return getSetting<double>('ttsSpeed') ?? 0.5;
  }

  /// Set daily goal
  Future<void> setDailyGoal(int goal) async {
    await setSetting('dailyGoal', goal);
  }

  /// Get daily goal
  int getDailyGoal() {
    return getSetting<int>('dailyGoal') ?? 50;
  }

  /// Set selected language
  Future<void> setLanguage(String languageCode) async {
    await setSetting('language', languageCode);
  }

  /// Get selected language
  String getLanguage() {
    return getSetting<String>('language') ?? 'zh-CN';
  }

  // ==================== Cache Management ====================

  /// Clear all data
  Future<void> clearAll() async {
    await _userBox.clear();
    await _progressBox.clear();
    await _settingsBox.clear();
  }

  /// Get storage statistics
  Map<String, int> getStorageStats() {
    return {
      'userBox': _userBox.length,
      'progressBox': _progressBox.length,
      'settingsBox': _settingsBox.length,
    };
  }

  /// Compact boxes to free up space
  Future<void> compact() async {
    await _userBox.compact();
    await _progressBox.compact();
    await _settingsBox.compact();
  }
}
