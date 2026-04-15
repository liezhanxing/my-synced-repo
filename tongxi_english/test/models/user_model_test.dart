import 'package:flutter_test/flutter_test.dart';
import 'package:tongxi_english/features/auth/domain/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson/toJson roundtrip preserves all data', () {
      final original = UserModel(
        uid: 'user_123',
        email: 'test@example.com',
        displayName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        level: 5,
        xp: 450,
        streak: 7,
        longestStreak: 14,
        createdAt: DateTime(2024, 1, 1),
        lastLoginAt: DateTime(2024, 1, 15),
        dailyGoal: 100,
        totalStudyMinutes: 300,
        wordsLearned: 150,
        phrasesLearned: 50,
        preferences: const UserPreferences(
          notificationsEnabled: true,
          soundEnabled: false,
          musicEnabled: true,
          ttsSpeed: 0.7,
          language: 'zh-CN',
          darkModeEnabled: true,
          showRomanization: false,
          autoPlayAudio: false,
        ),
      );

      final json = original.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.uid, original.uid);
      expect(restored.email, original.email);
      expect(restored.displayName, original.displayName);
      expect(restored.avatarUrl, original.avatarUrl);
      expect(restored.level, original.level);
      expect(restored.xp, original.xp);
      expect(restored.streak, original.streak);
      expect(restored.longestStreak, original.longestStreak);
      expect(restored.createdAt, original.createdAt);
      expect(restored.lastLoginAt, original.lastLoginAt);
      expect(restored.dailyGoal, original.dailyGoal);
      expect(restored.totalStudyMinutes, original.totalStudyMinutes);
      expect(restored.wordsLearned, original.wordsLearned);
      expect(restored.phrasesLearned, original.phrasesLearned);
      expect(restored.preferences.notificationsEnabled,
          original.preferences.notificationsEnabled);
      expect(restored.preferences.soundEnabled,
          original.preferences.soundEnabled);
      expect(restored.preferences.musicEnabled,
          original.preferences.musicEnabled);
      expect(restored.preferences.ttsSpeed, original.preferences.ttsSpeed);
      expect(restored.preferences.language, original.preferences.language);
      expect(restored.preferences.darkModeEnabled,
          original.preferences.darkModeEnabled);
      expect(restored.preferences.showRomanization,
          original.preferences.showRomanization);
      expect(restored.preferences.autoPlayAudio,
          original.preferences.autoPlayAudio);
    });

    test('fromJson handles missing optional fields with defaults', () {
      final json = {
        'uid': 'user_456',
        'email': 'new@example.com',
        'display_name': 'New User',
        'created_at': '2024-01-10T00:00:00.000',
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, 'user_456');
      expect(user.email, 'new@example.com');
      expect(user.displayName, 'New User');
      expect(user.avatarUrl, isNull);
      expect(user.level, 1); // default
      expect(user.xp, 0); // default
      expect(user.streak, 0); // default
      expect(user.longestStreak, 0); // default
      expect(user.lastLoginAt, isNull);
      expect(user.dailyGoal, 50); // default
      expect(user.totalStudyMinutes, 0); // default
      expect(user.wordsLearned, 0); // default
      expect(user.phrasesLearned, 0); // default
      expect(user.preferences, const UserPreferences()); // default
    });

    test('fromJson handles all fields present', () {
      final json = {
        'uid': 'user_789',
        'email': 'full@example.com',
        'display_name': 'Full User',
        'avatar_url': 'https://example.com/full.jpg',
        'level': 10,
        'xp': 950,
        'streak': 30,
        'longest_streak': 45,
        'created_at': '2024-01-01T00:00:00.000',
        'last_login_at': '2024-01-20T12:00:00.000',
        'daily_goal': 200,
        'total_study_minutes': 1000,
        'words_learned': 500,
        'phrases_learned': 200,
        'preferences': {
          'notifications_enabled': false,
          'sound_enabled': true,
          'music_enabled': false,
          'tts_speed': 0.3,
          'language': 'en-US',
          'dark_mode_enabled': false,
          'show_romanization': true,
          'auto_play_audio': true,
        },
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, 'user_789');
      expect(user.level, 10);
      expect(user.xp, 950);
      expect(user.streak, 30);
      expect(user.longestStreak, 45);
      expect(user.lastLoginAt, DateTime(2024, 1, 20, 12));
      expect(user.dailyGoal, 200);
      expect(user.totalStudyMinutes, 1000);
      expect(user.wordsLearned, 500);
      expect(user.phrasesLearned, 200);
      expect(user.preferences.notificationsEnabled, false);
      expect(user.preferences.language, 'en-US');
    });

    test('empty factory creates user with empty values', () {
      final user = UserModel.empty();

      expect(user.uid, '');
      expect(user.email, '');
      expect(user.displayName, '');
      expect(user.level, 1);
      expect(user.xp, 0);
    });

    test('copyWith updates specified fields only', () {
      final original = UserModel(
        uid: 'user_001',
        email: 'original@example.com',
        displayName: 'Original',
        createdAt: DateTime(2024, 1, 1),
        level: 1,
        xp: 0,
      );

      final updated = original.copyWith(
        displayName: 'Updated',
        level: 2,
      );

      expect(updated.uid, original.uid); // unchanged
      expect(updated.email, original.email); // unchanged
      expect(updated.displayName, 'Updated'); // changed
      expect(updated.level, 2); // changed
      expect(updated.xp, original.xp); // unchanged
    });

    test('xpForNextLevel calculates correctly', () {
      final user = UserModel(
        uid: 'user_002',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 5,
        xp: 0,
      );

      expect(user.xpForNextLevel, 500); // level * 100
    });

    test('levelProgress calculates correctly', () {
      final user = UserModel(
        uid: 'user_003',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 3,
        xp: 250, // Between level 3 (needs 300) and level 2 (had 200)
      );

      // Level 2 required 200 XP, Level 3 requires 300 XP
      // Current: 250 XP, so progress = (250 - 200) / (300 - 200) = 0.5
      expect(user.levelProgress, 0.5);
    });

    test('levelProgress is clamped to 1.0', () {
      final user = UserModel(
        uid: 'user_004',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 2,
        xp: 500, // Way more than needed for level 2
      );

      expect(user.levelProgress, lessThanOrEqualTo(1.0));
    });

    test('canLevelUp returns true when XP is sufficient', () {
      final user = UserModel(
        uid: 'user_005',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 2,
        xp: 200, // Exactly enough for level 2
      );

      expect(user.canLevelUp, isTrue);
    });

    test('canLevelUp returns false when XP is insufficient', () {
      final user = UserModel(
        uid: 'user_006',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 3,
        xp: 200, // Not enough for level 3 (needs 300)
      );

      expect(user.canLevelUp, isFalse);
    });

    test('addXp increases XP correctly', () {
      final user = UserModel(
        uid: 'user_007',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 1,
        xp: 50,
      );

      final updated = user.addXp(30);

      expect(updated.xp, 80);
      expect(updated.level, 1); // Not enough to level up
    });

    test('addXp handles level up', () {
      final user = UserModel(
        uid: 'user_008',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 1,
        xp: 80,
      );

      final updated = user.addXp(30); // 110 XP, enough for level 2

      expect(updated.xp, 110);
      expect(updated.level, 2);
    });

    test('addXp handles multiple level ups', () {
      final user = UserModel(
        uid: 'user_009',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        level: 1,
        xp: 50,
      );

      final updated = user.addXp(300); // 350 XP, enough for level 3 and 4

      expect(updated.xp, 350);
      expect(updated.level, greaterThanOrEqualTo(3));
    });

    test('updateStreak increments streak when studied today', () {
      final user = UserModel(
        uid: 'user_010',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        streak: 5,
        longestStreak: 10,
      );

      final updated = user.updateStreak(true);

      expect(updated.streak, 6);
      expect(updated.longestStreak, 10); // Unchanged
    });

    test('updateStreak updates longest streak when appropriate', () {
      final user = UserModel(
        uid: 'user_011',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        streak: 10,
        longestStreak: 10,
      );

      final updated = user.updateStreak(true);

      expect(updated.streak, 11);
      expect(updated.longestStreak, 11); // Updated
    });

    test('updateStreak resets streak when not studied', () {
      final user = UserModel(
        uid: 'user_012',
        email: 'test@example.com',
        displayName: 'Test',
        createdAt: DateTime.now(),
        streak: 5,
        longestStreak: 10,
      );

      final updated = user.updateStreak(false);

      expect(updated.streak, 0);
      expect(updated.longestStreak, 10); // Unchanged
    });

    test('props includes all fields for equality', () {
      final user1 = UserModel(
        uid: 'user_same',
        email: 'same@example.com',
        displayName: 'Same',
        createdAt: DateTime(2024, 1, 1),
      );

      final user2 = UserModel(
        uid: 'user_same',
        email: 'same@example.com',
        displayName: 'Same',
        createdAt: DateTime(2024, 1, 1),
      );

      final user3 = UserModel(
        uid: 'user_different',
        email: 'different@example.com',
        displayName: 'Different',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(user1, user2);
      expect(user1 == user3, isFalse);
    });
  });

  group('UserPreferences', () {
    test('fromJson/toJson roundtrip preserves all data', () {
      final original = UserPreferences(
        notificationsEnabled: false,
        soundEnabled: false,
        musicEnabled: true,
        ttsSpeed: 0.8,
        language: 'en-US',
        darkModeEnabled: true,
        showRomanization: false,
        autoPlayAudio: false,
      );

      final json = original.toJson();
      final restored = UserPreferences.fromJson(json);

      expect(restored.notificationsEnabled, original.notificationsEnabled);
      expect(restored.soundEnabled, original.soundEnabled);
      expect(restored.musicEnabled, original.musicEnabled);
      expect(restored.ttsSpeed, original.ttsSpeed);
      expect(restored.language, original.language);
      expect(restored.darkModeEnabled, original.darkModeEnabled);
      expect(restored.showRomanization, original.showRomanization);
      expect(restored.autoPlayAudio, original.autoPlayAudio);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final prefs = UserPreferences.fromJson(json);

      expect(prefs.notificationsEnabled, true); // default
      expect(prefs.soundEnabled, true); // default
      expect(prefs.musicEnabled, false); // default
      expect(prefs.ttsSpeed, 0.5); // default
      expect(prefs.language, 'zh-CN'); // default
      expect(prefs.darkModeEnabled, false); // default
      expect(prefs.showRomanization, true); // default
      expect(prefs.autoPlayAudio, true); // default
    });

    test('fromJson handles all fields present', () {
      final json = {
        'notifications_enabled': false,
        'sound_enabled': false,
        'music_enabled': true,
        'tts_speed': 0.3,
        'language': 'en-US',
        'dark_mode_enabled': true,
        'show_romanization': false,
        'auto_play_audio': false,
      };

      final prefs = UserPreferences.fromJson(json);

      expect(prefs.notificationsEnabled, false);
      expect(prefs.soundEnabled, false);
      expect(prefs.musicEnabled, true);
      expect(prefs.ttsSpeed, 0.3);
      expect(prefs.language, 'en-US');
      expect(prefs.darkModeEnabled, true);
      expect(prefs.showRomanization, false);
      expect(prefs.autoPlayAudio, false);
    });

    test('copyWith updates specified fields only', () {
      const original = UserPreferences(
        notificationsEnabled: true,
        soundEnabled: true,
        ttsSpeed: 0.5,
      );

      final updated = original.copyWith(
        soundEnabled: false,
        ttsSpeed: 0.7,
      );

      expect(updated.notificationsEnabled, original.notificationsEnabled); // unchanged
      expect(updated.soundEnabled, false); // changed
      expect(updated.ttsSpeed, 0.7); // changed
      expect(updated.language, original.language); // unchanged
    });

    test('props includes all fields for equality', () {
      const prefs1 = UserPreferences(
        notificationsEnabled: true,
        soundEnabled: false,
      );

      const prefs2 = UserPreferences(
        notificationsEnabled: true,
        soundEnabled: false,
      );

      const prefs3 = UserPreferences(
        notificationsEnabled: false,
        soundEnabled: true,
      );

      expect(prefs1, prefs2);
      expect(prefs1 == prefs3, isFalse);
    });

    test('default constructor uses correct defaults', () {
      const prefs = UserPreferences();

      expect(prefs.notificationsEnabled, true);
      expect(prefs.soundEnabled, true);
      expect(prefs.musicEnabled, false);
      expect(prefs.ttsSpeed, 0.5);
      expect(prefs.language, 'zh-CN');
      expect(prefs.darkModeEnabled, false);
      expect(prefs.showRomanization, true);
      expect(prefs.autoPlayAudio, true);
    });
  });
}
