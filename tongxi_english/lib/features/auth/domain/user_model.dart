import 'package:equatable/equatable.dart';

/// User model representing a 童希英语 user
/// 
/// Contains user profile information, learning statistics, and preferences.
class UserModel extends Equatable {
  /// Unique user ID
  final String uid;
  
  /// User email address
  final String email;
  
  /// Display name
  final String displayName;
  
  /// Avatar URL
  final String? avatarUrl;
  
  /// User level
  final int level;
  
  /// Experience points
  final int xp;
  
  /// Current streak (consecutive days)
  final int streak;
  
  /// Longest streak achieved
  final int longestStreak;
  
  /// Account creation timestamp
  final DateTime createdAt;
  
  /// Last login timestamp
  final DateTime? lastLoginAt;
  
  /// Daily XP goal
  final int dailyGoal;
  
  /// Total study time in minutes
  final int totalStudyMinutes;
  
  /// Number of words learned
  final int wordsLearned;
  
  /// Number of phrases learned
  final int phrasesLearned;
  
  /// User preferences
  final UserPreferences preferences;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.level = 1,
    this.xp = 0,
    this.streak = 0,
    this.longestStreak = 0,
    required this.createdAt,
    this.lastLoginAt,
    this.dailyGoal = 50,
    this.totalStudyMinutes = 0,
    this.wordsLearned = 0,
    this.phrasesLearned = 0,
    this.preferences = const UserPreferences(),
  });

  /// Create empty user (for initialization)
  factory UserModel.empty() {
    return UserModel(
      uid: '',
      email: '',
      displayName: '',
      createdAt: DateTime.now(),
    );
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      dailyGoal: json['daily_goal'] as int? ?? 50,
      totalStudyMinutes: json['total_study_minutes'] as int? ?? 0,
      wordsLearned: json['words_learned'] as int? ?? 0,
      phrasesLearned: json['phrases_learned'] as int? ?? 0,
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : const UserPreferences(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'level': level,
      'xp': xp,
      'streak': streak,
      'longest_streak': longestStreak,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'daily_goal': dailyGoal,
      'total_study_minutes': totalStudyMinutes,
      'words_learned': wordsLearned,
      'phrases_learned': phrasesLearned,
      'preferences': preferences.toJson(),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? avatarUrl,
    int? level,
    int? xp,
    int? streak,
    int? longestStreak,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? dailyGoal,
    int? totalStudyMinutes,
    int? wordsLearned,
    int? phrasesLearned,
    UserPreferences? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      phrasesLearned: phrasesLearned ?? this.phrasesLearned,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Calculate XP needed for next level
  int get xpForNextLevel {
    // Simple formula: level * 100 XP needed
    return level * 100;
  }

  /// Calculate progress to next level (0.0 to 1.0)
  double get levelProgress {
    final previousLevelXp = (level - 1) * 100;
    final currentLevelXp = xp - previousLevelXp;
    final needed = xpForNextLevel - previousLevelXp;
    return (currentLevelXp / needed).clamp(0.0, 1.0);
  }

  /// Check if user can level up
  bool get canLevelUp {
    return xp >= xpForNextLevel;
  }

  /// Add XP and return updated user (may level up)
  UserModel addXp(int amount) {
    var newXp = xp + amount;
    var newLevel = level;
    
    // Level up logic
    while (newXp >= newLevel * 100) {
      newLevel++;
    }
    
    return copyWith(xp: newXp, level: newLevel);
  }

  /// Update streak
  UserModel updateStreak(bool studiedToday) {
    if (studiedToday) {
      final newStreak = streak + 1;
      return copyWith(
        streak: newStreak,
        longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      );
    } else {
      return copyWith(streak: 0);
    }
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        avatarUrl,
        level,
        xp,
        streak,
        longestStreak,
        createdAt,
        lastLoginAt,
        dailyGoal,
        totalStudyMinutes,
        wordsLearned,
        phrasesLearned,
        preferences,
      ];
}

/// User preferences model
class UserPreferences extends Equatable {
  /// Enable notifications
  final bool notificationsEnabled;
  
  /// Enable sound effects
  final bool soundEnabled;
  
  /// Enable background music
  final bool musicEnabled;
  
  /// TTS speed (0.0 to 1.0)
  final double ttsSpeed;
  
  /// App language
  final String language;
  
  /// Dark mode enabled
  final bool darkModeEnabled;
  
  /// Show romanization
  final bool showRomanization;
  
  /// Auto-play audio
  final bool autoPlayAudio;

  const UserPreferences({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.musicEnabled = false,
    this.ttsSpeed = 0.5,
    this.language = 'zh-CN',
    this.darkModeEnabled = false,
    this.showRomanization = true,
    this.autoPlayAudio = true,
  });

  /// Create from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      musicEnabled: json['music_enabled'] as bool? ?? false,
      ttsSpeed: (json['tts_speed'] as num?)?.toDouble() ?? 0.5,
      language: json['language'] as String? ?? 'zh-CN',
      darkModeEnabled: json['dark_mode_enabled'] as bool? ?? false,
      showRomanization: json['show_romanization'] as bool? ?? true,
      autoPlayAudio: json['auto_play_audio'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'sound_enabled': soundEnabled,
      'music_enabled': musicEnabled,
      'tts_speed': ttsSpeed,
      'language': language,
      'dark_mode_enabled': darkModeEnabled,
      'show_romanization': showRomanization,
      'auto_play_audio': autoPlayAudio,
    };
  }

  /// Create a copy with updated fields
  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? musicEnabled,
    double? ttsSpeed,
    String? language,
    bool? darkModeEnabled,
    bool? showRomanization,
    bool? autoPlayAudio,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      language: language ?? this.language,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      showRomanization: showRomanization ?? this.showRomanization,
      autoPlayAudio: autoPlayAudio ?? this.autoPlayAudio,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        soundEnabled,
        musicEnabled,
        ttsSpeed,
        language,
        darkModeEnabled,
        showRomanization,
        autoPlayAudio,
      ];
}
