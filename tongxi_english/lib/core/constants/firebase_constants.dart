/// Firebase collection names and storage paths
/// 
/// Centralized constants for Firestore collections and Firebase Storage paths
/// to ensure consistency across the app.
class FirebaseConstants {
  FirebaseConstants._();

  // ==================== Firestore Collections ====================
  
  /// Users collection
  static const String usersCollection = 'users';
  
  /// User progress collection
  static const String userProgressCollection = 'user_progress';
  
  /// Study sessions collection
  static const String studySessionsCollection = 'study_sessions';
  
  // ==================== Content Collections ====================
  
  /// Phonetics collection
  static const String phoneticsCollection = 'phonetics';
  
  /// Vocabulary/Words collection
  static const String wordsCollection = 'words';
  
  /// Phrases collection
  static const String phrasesCollection = 'phrases';
  
  /// Grammar collection
  static const String grammarCollection = 'grammar';
  
  /// Grammar rules collection
  static const String grammarRulesCollection = 'grammar_rules';
  
  /// Grammar exercises collection
  static const String grammarExercisesCollection = 'grammar_exercises';
  
  /// Reading passages collection
  static const String readingCollection = 'reading_passages';
  
  /// Listening materials collection
  static const String listeningCollection = 'listening_materials';
  
  /// Translation exercises collection
  static const String translationCollection = 'translation_exercises';
  
  // ==================== Gamification Collections ====================
  
  /// Achievements collection
  static const String achievementsCollection = 'achievements';
  
  /// User achievements collection
  static const String userAchievementsCollection = 'user_achievements';
  
  /// Leaderboards collection
  static const String leaderboardsCollection = 'leaderboards';
  
  /// Daily challenges collection
  static const String dailyChallengesCollection = 'daily_challenges';
  
  // ==================== Social Collections ====================
  
  /// Friendships collection
  static const String friendshipsCollection = 'friendships';
  
  /// Classrooms collection
  static const String classroomsCollection = 'classrooms';
  
  /// Class members collection
  static const String classMembersCollection = 'class_members';
  
  /// Messages collection
  static const String messagesCollection = 'messages';
  
  // ==================== Storage Paths ====================
  
  /// User avatars storage path
  static const String userAvatarsPath = 'avatars';
  
  /// Audio files storage path
  static const String audioFilesPath = 'audio';
  
  /// Word audio pronunciation path
  static const String wordAudioPath = 'audio/words';
  
  /// Phonetic audio path
  static const String phoneticAudioPath = 'audio/phonetics';
  
  /// Listening audio path
  static const String listeningAudioPath = 'audio/listening';
  
  /// User recordings path
  static const String userRecordingsPath = 'recordings';
  
  /// Images storage path
  static const String imagesPath = 'images';
  
  /// Word images path
  static const String wordImagesPath = 'images/words';
  
  /// Mascot/Character images path
  static const String mascotImagesPath = 'images/mascots';
  
  /// Achievement badges path
  static const String badgeImagesPath = 'images/badges';
  
  /// Reading passage images path
  static const String readingImagesPath = 'images/reading';
  
  // ==================== Remote Config Keys ====================
  
  /// Feature flags
  static const String featureVocabularyKey = 'feature_vocabulary_enabled';
  static const String featureGrammarKey = 'feature_grammar_enabled';
  static const String featureSocialKey = 'feature_social_enabled';
  static const String featureClassroomKey = 'feature_classroom_enabled';
  
  /// Content config
  static const String dailyWordLimitKey = 'daily_word_limit';
  static const String dailyXpGoalKey = 'daily_xp_goal';
  static const String reviewIntervalKey = 'review_interval_days';
  
  /// App config
  static const String minAppVersionKey = 'min_app_version';
  static const String latestAppVersionKey = 'latest_app_version';
  static const String maintenanceModeKey = 'maintenance_mode';
  
  // ==================== Document Fields ====================
  
  /// Common timestamp fields
  static const String createdAtField = 'created_at';
  static const String updatedAtField = 'updated_at';
  static const String completedAtField = 'completed_at';
  
  /// User fields
  static const String userIdField = 'uid';
  static const String userEmailField = 'email';
  static const String userDisplayNameField = 'display_name';
  static const String userAvatarUrlField = 'avatar_url';
  static const String userLevelField = 'level';
  static const String userXpField = 'xp';
  static const String userStreakField = 'streak';
  
  /// Progress fields
  static const String progressMasteryField = 'mastery_level';
  static const String progressReviewCountField = 'review_count';
  static const String progressNextReviewField = 'next_review_date';
  static const String progressEaseFactorField = 'ease_factor';
  static const String progressIntervalField = 'interval_days';
}

/// Firestore query limits for pagination
class QueryLimits {
  QueryLimits._();
  
  /// Default page size for lists
  static const int defaultPageSize = 20;
  
  /// Small page size for quick loads
  static const int smallPageSize = 10;
  
  /// Large page size for search results
  static const int largePageSize = 50;
  
  /// Maximum items to cache locally
  static const int maxCacheSize = 100;
}
