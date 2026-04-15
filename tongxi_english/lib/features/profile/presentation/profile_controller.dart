import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/user_progress_model.dart';

/// Achievement model
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double? progress; // 0.0 to 1.0 for locked achievements

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.category,
    required this.rarity,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    AchievementCategory? category,
    AchievementRarity? rarity,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }
}

enum AchievementCategory {
  learning,
  streak,
  challenge,
  social,
}

enum AchievementRarity {
  common, // Bronze
  rare, // Silver
  epic, // Gold
  legendary, // Platinum
}

/// Module progress data
class ModuleProgress {
  final ContentType contentType;
  final String name;
  final String iconName;
  final double completionPercentage;
  final int itemsCompleted;
  final int totalItems;
  final Color color;

  const ModuleProgress({
    required this.contentType,
    required this.name,
    required this.iconName,
    required this.completionPercentage,
    required this.itemsCompleted,
    required this.totalItems,
    required this.color,
  });
}

/// Study activity record
class StudyActivity {
  final String id;
  final String title;
  final String description;
  final ContentType contentType;
  final DateTime timestamp;
  final int xpEarned;
  final int durationMinutes;

  const StudyActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    required this.timestamp,
    required this.xpEarned,
    required this.durationMinutes,
  });
}

/// User settings
class UserSettings {
  final String displayName;
  final String email;
  final int dailyGoalMinutes;
  final bool notificationsEnabled;
  final bool reviewRemindersEnabled;
  final TimeOfDay? reviewReminderTime;
  final double fontScale;
  final double ttsSpeed;
  final bool autoPlayAudio;

  const UserSettings({
    required this.displayName,
    required this.email,
    this.dailyGoalMinutes = 30,
    this.notificationsEnabled = true,
    this.reviewRemindersEnabled = true,
    this.reviewReminderTime,
    this.fontScale = 1.0,
    this.ttsSpeed = 0.5,
    this.autoPlayAudio = true,
  });

  UserSettings copyWith({
    String? displayName,
    String? email,
    int? dailyGoalMinutes,
    bool? notificationsEnabled,
    bool? reviewRemindersEnabled,
    TimeOfDay? reviewReminderTime,
    double? fontScale,
    double? ttsSpeed,
    bool? autoPlayAudio,
  }) {
    return UserSettings(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reviewRemindersEnabled:
          reviewRemindersEnabled ?? this.reviewRemindersEnabled,
      reviewReminderTime: reviewReminderTime ?? this.reviewReminderTime,
      fontScale: fontScale ?? this.fontScale,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      autoPlayAudio: autoPlayAudio ?? this.autoPlayAudio,
    );
  }
}

/// Profile state
class ProfileState {
  final bool isLoading;
  final String? error;

  // User stats
  final int level;
  final int xp;
  final int streak;
  final int longestStreak;
  final int totalWordsLearned;
  final int totalStudyMinutes;
  final double averageQuizScore;

  // Progress data
  final List<ModuleProgress> moduleProgress;
  final List<int> weeklyStudyMinutes; // Last 7 days
  final List<StudyActivity> recentActivities;

  // Achievements
  final List<Achievement> achievements;

  // Settings
  final UserSettings settings;

  const ProfileState({
    this.isLoading = false,
    this.error,
    this.level = 1,
    this.xp = 0,
    this.streak = 0,
    this.longestStreak = 0,
    this.totalWordsLearned = 0,
    this.totalStudyMinutes = 0,
    this.averageQuizScore = 0,
    this.moduleProgress = const [],
    this.weeklyStudyMinutes = const [],
    this.recentActivities = const [],
    this.achievements = const [],
    this.settings = const UserSettings(
      displayName: '',
      email: '',
    ),
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    int? level,
    int? xp,
    int? streak,
    int? longestStreak,
    int? totalWordsLearned,
    int? totalStudyMinutes,
    double? averageQuizScore,
    List<ModuleProgress>? moduleProgress,
    List<int>? weeklyStudyMinutes,
    List<StudyActivity>? recentActivities,
    List<Achievement>? achievements,
    UserSettings? settings,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      averageQuizScore: averageQuizScore ?? this.averageQuizScore,
      moduleProgress: moduleProgress ?? this.moduleProgress,
      weeklyStudyMinutes: weeklyStudyMinutes ?? this.weeklyStudyMinutes,
      recentActivities: recentActivities ?? this.recentActivities,
      achievements: achievements ?? this.achievements,
      settings: settings ?? this.settings,
    );
  }

  /// Get unlocked achievements count
  int get unlockedAchievementsCount {
    return achievements.where((a) => a.isUnlocked).length;
  }

  /// Get achievements by category
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return achievements.where((a) => a.category == category).toList();
  }

  /// Get overall progress percentage
  double get overallProgress {
    if (moduleProgress.isEmpty) return 0;
    final total = moduleProgress.fold<double>(
      0,
      (sum, m) => sum + m.completionPercentage,
    );
    return total / moduleProgress.length;
  }

  /// Get XP for next level
  int get xpForNextLevel {
    return level * 100;
  }

  /// Get level progress (0.0 to 1.0)
  double get levelProgress {
    final previousLevelXp = (level - 1) * 100;
    final currentLevelXp = xp - previousLevelXp;
    final needed = xpForNextLevel - previousLevelXp;
    return (currentLevelXp / needed).clamp(0.0, 1.0);
  }
}

/// Profile controller provider
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController();
});

/// Profile controller
class ProfileController extends StateNotifier<ProfileState> {
  ProfileController() : super(const ProfileState()) {
    _loadMockData();
  }

  void _loadMockData() {
    // Mock user stats
    const mockLevel = 5;
    const mockXp = 2350;
    const mockStreak = 12;
    const mockLongestStreak = 15;
    const mockWordsLearned = 487;
    const mockStudyMinutes = 1280;
    const mockAvgScore = 78.5;

    // Mock module progress
    final mockModuleProgress = [
      const ModuleProgress(
        contentType: ContentType.phonetic,
        name: '发音',
        iconName: 'record_voice_over',
        completionPercentage: 25,
        itemsCompleted: 12,
        totalItems: 48,
        color: Color(0xFF00BCD4),
      ),
      const ModuleProgress(
        contentType: ContentType.word,
        name: '词汇',
        iconName: 'menu_book',
        completionPercentage: 45,
        itemsCompleted: 487,
        totalItems: 1080,
        color: Color(0xFF9B59B6),
      ),
      const ModuleProgress(
        contentType: ContentType.phrase,
        name: '短语',
        iconName: 'chat_bubble',
        completionPercentage: 30,
        itemsCompleted: 156,
        totalItems: 520,
        color: Color(0xFFE91E63),
      ),
      const ModuleProgress(
        contentType: ContentType.grammar,
        name: '语法',
        iconName: 'psychology',
        completionPercentage: 35,
        itemsCompleted: 42,
        totalItems: 120,
        color: Color(0xFFFF9800),
      ),
      const ModuleProgress(
        contentType: ContentType.reading,
        name: '阅读',
        iconName: 'article',
        completionPercentage: 20,
        itemsCompleted: 18,
        totalItems: 90,
        color: Color(0xFF8BC34A),
      ),
      const ModuleProgress(
        contentType: ContentType.listening,
        name: '听力',
        iconName: 'headphones',
        completionPercentage: 15,
        itemsCompleted: 12,
        totalItems: 80,
        color: Color(0xFFF1C40F),
      ),
      const ModuleProgress(
        contentType: ContentType.translation,
        name: '翻译',
        iconName: 'translate',
        completionPercentage: 10,
        itemsCompleted: 6,
        totalItems: 60,
        color: Color(0xFF3498DB),
      ),
    ];

    // Mock weekly study data (last 7 days)
    final mockWeeklyStudyMinutes = [45, 60, 30, 90, 45, 120, 30];

    // Mock recent activities
    final mockActivities = [
      StudyActivity(
        id: '1',
        title: '完成词汇学习',
        description: '学习了20个新单词',
        contentType: ContentType.word,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        xpEarned: 40,
        durationMinutes: 20,
      ),
      StudyActivity(
        id: '2',
        title: '完成翻译练习',
        description: '完成了5道翻译题',
        contentType: ContentType.translation,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        xpEarned: 25,
        durationMinutes: 15,
      ),
      StudyActivity(
        id: '3',
        title: '完成听力训练',
        description: '完成了一篇听力材料',
        contentType: ContentType.listening,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        xpEarned: 30,
        durationMinutes: 25,
      ),
      StudyActivity(
        id: '4',
        title: '完成语法练习',
        description: '学习了定语从句',
        contentType: ContentType.grammar,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        xpEarned: 35,
        durationMinutes: 30,
      ),
      StudyActivity(
        id: '5',
        title: '完成阅读练习',
        description: '阅读了一篇高考真题',
        contentType: ContentType.reading,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        xpEarned: 45,
        durationMinutes: 35,
      ),
      StudyActivity(
        id: '6',
        title: '完成短语学习',
        description: '学习了15个常用短语',
        contentType: ContentType.phrase,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        xpEarned: 30,
        durationMinutes: 20,
      ),
    ];

    // Mock achievements
    final mockAchievements = [
      // Learning achievements
      const Achievement(
        id: 'first_word',
        title: '初学者',
        description: '学习第一个单词',
        iconName: 'school',
        category: AchievementCategory.learning,
        rarity: AchievementRarity.common,
        isUnlocked: true,
        unlockedAt: null,
      ),
      const Achievement(
        id: 'words_100',
        title: '词汇达人',
        description: '学习100个单词',
        iconName: 'menu_book',
        category: AchievementCategory.learning,
        rarity: AchievementRarity.rare,
        isUnlocked: true,
        unlockedAt: null,
      ),
      const Achievement(
        id: 'words_500',
        title: '词汇大师',
        description: '学习500个单词',
        iconName: 'auto_stories',
        category: AchievementCategory.learning,
        rarity: AchievementRarity.epic,
        isUnlocked: false,
        progress: 0.97,
      ),
      const Achievement(
        id: 'grammar_master',
        title: '语法专家',
        description: '完成所有语法课程',
        iconName: 'psychology',
        category: AchievementCategory.learning,
        rarity: AchievementRarity.legendary,
        isUnlocked: false,
        progress: 0.35,
      ),

      // Streak achievements
      const Achievement(
        id: 'streak_3',
        title: '坚持者',
        description: '连续学习3天',
        iconName: 'local_fire_department',
        category: AchievementCategory.streak,
        rarity: AchievementRarity.common,
        isUnlocked: true,
        unlockedAt: null,
      ),
      const Achievement(
        id: 'streak_7',
        title: '习惯养成',
        description: '连续学习7天',
        iconName: 'whatshot',
        category: AchievementCategory.streak,
        rarity: AchievementRarity.rare,
        isUnlocked: true,
        unlockedAt: null,
      ),
      const Achievement(
        id: 'streak_30',
        title: '学习狂魔',
        description: '连续学习30天',
        iconName: 'emoji_events',
        category: AchievementCategory.streak,
        rarity: AchievementRarity.epic,
        isUnlocked: false,
        progress: 0.4,
      ),

      // Challenge achievements
      const Achievement(
        id: 'perfect_quiz',
        title: '完美测验',
        description: '一次测验全对',
        iconName: 'stars',
        category: AchievementCategory.challenge,
        rarity: AchievementRarity.rare,
        isUnlocked: true,
        unlockedAt: null,
      ),
      const Achievement(
        id: 'speed_reader',
        title: '速读高手',
        description: '5分钟内完成一篇阅读',
        iconName: 'speed',
        category: AchievementCategory.challenge,
        rarity: AchievementRarity.epic,
        isUnlocked: false,
        progress: 0.6,
      ),
      const Achievement(
        id: 'dictation_pro',
        title: '听写达人',
        description: '听写练习连续10次满分',
        iconName: 'hearing',
        category: AchievementCategory.challenge,
        rarity: AchievementRarity.legendary,
        isUnlocked: false,
        progress: 0.3,
      ),

      // Social achievements
      const Achievement(
        id: 'first_share',
        title: '分享达人',
        description: '首次分享学习成果',
        iconName: 'share',
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        isUnlocked: true,
        unlockedAt: null,
      ),
    ];

    // Mock settings
    final mockSettings = UserSettings(
      displayName: '童希学习者',
      email: 'learner@tongxi.com',
      dailyGoalMinutes: 30,
      notificationsEnabled: true,
      reviewRemindersEnabled: true,
      reviewReminderTime: const TimeOfDay(hour: 20, minute: 0),
      fontScale: 1.0,
      ttsSpeed: 0.6,
      autoPlayAudio: true,
    );

    state = ProfileState(
      level: mockLevel,
      xp: mockXp,
      streak: mockStreak,
      longestStreak: mockLongestStreak,
      totalWordsLearned: mockWordsLearned,
      totalStudyMinutes: mockStudyMinutes,
      averageQuizScore: mockAvgScore,
      moduleProgress: mockModuleProgress,
      weeklyStudyMinutes: mockWeeklyStudyMinutes,
      recentActivities: mockActivities,
      achievements: mockAchievements,
      settings: mockSettings,
    );
  }

  /// Update display name
  void updateDisplayName(String name) {
    state = state.copyWith(
      settings: state.settings.copyWith(displayName: name),
    );
  }

  /// Update daily goal
  void updateDailyGoal(int minutes) {
    state = state.copyWith(
      settings: state.settings.copyWith(dailyGoalMinutes: minutes),
    );
  }

  /// Update notification settings
  void updateNotifications(bool enabled) {
    state = state.copyWith(
      settings: state.settings.copyWith(notificationsEnabled: enabled),
    );
  }

  /// Update review reminder settings
  void updateReviewReminders(bool enabled) {
    state = state.copyWith(
      settings: state.settings.copyWith(reviewRemindersEnabled: enabled),
    );
  }

  /// Update review reminder time
  void updateReviewReminderTime(TimeOfDay time) {
    state = state.copyWith(
      settings: state.settings.copyWith(reviewReminderTime: time),
    );
  }

  /// Update font scale
  void updateFontScale(double scale) {
    state = state.copyWith(
      settings: state.settings.copyWith(fontScale: scale),
    );
  }

  /// Update TTS speed
  void updateTtsSpeed(double speed) {
    state = state.copyWith(
      settings: state.settings.copyWith(ttsSpeed: speed),
    );
  }

  /// Update auto play audio
  void updateAutoPlayAudio(bool enabled) {
    state = state.copyWith(
      settings: state.settings.copyWith(autoPlayAudio: enabled),
    );
  }

  /// Refresh data (mock)
  Future<void> refreshData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    _loadMockData();
    state = state.copyWith(isLoading: false);
  }
}


