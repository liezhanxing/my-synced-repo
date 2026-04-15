import 'package:equatable/equatable.dart';

/// User progress model for tracking learning progress
/// 
/// Contains progress data for words, phrases, and other content
class UserProgressModel extends Equatable {
  /// Unique ID (user ID + content ID)
  final String id;
  
  /// User ID
  final String userId;
  
  /// Content ID (word ID, phrase ID, etc.)
  final String contentId;
  
  /// Content type (word, phrase, grammar, etc.)
  final ContentType contentType;
  
  /// Mastery level (0-5)
  final int masteryLevel;
  
  /// Number of times reviewed
  final int reviewCount;
  
  /// Number of correct answers
  final int correctCount;
  
  /// Number of incorrect answers
  final int incorrectCount;
  
  /// Next review date (for spaced repetition)
  final DateTime? nextReviewDate;
  
  /// Ease factor (SM-2 algorithm)
  final double easeFactor;
  
  /// Interval in days (SM-2 algorithm)
  final int intervalDays;
  
  /// Repetition count (SM-2 algorithm)
  final int repetitions;
  
  /// First learned date
  final DateTime? firstLearnedAt;
  
  /// Last reviewed date
  final DateTime? lastReviewedAt;
  
  /// Is in favorites/bookmarks
  final bool isFavorite;
  
  /// Custom notes
  final String? notes;

  const UserProgressModel({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.contentType,
    this.masteryLevel = 0,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.nextReviewDate,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.repetitions = 0,
    this.firstLearnedAt,
    this.lastReviewedAt,
    this.isFavorite = false,
    this.notes,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      contentId: json['content_id'] as String,
      contentType: ContentType.values.firstWhere(
        (t) => t.name == json['content_type'],
        orElse: () => ContentType.word,
      ),
      masteryLevel: json['mastery_level'] as int? ?? 0,
      reviewCount: json['review_count'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? 0,
      incorrectCount: json['incorrect_count'] as int? ?? 0,
      nextReviewDate: json['next_review_date'] != null
          ? DateTime.parse(json['next_review_date'] as String)
          : null,
      easeFactor: (json['ease_factor'] as num?)?.toDouble() ?? 2.5,
      intervalDays: json['interval_days'] as int? ?? 0,
      repetitions: json['repetitions'] as int? ?? 0,
      firstLearnedAt: json['first_learned_at'] != null
          ? DateTime.parse(json['first_learned_at'] as String)
          : null,
      lastReviewedAt: json['last_reviewed_at'] != null
          ? DateTime.parse(json['last_reviewed_at'] as String)
          : null,
      isFavorite: json['is_favorite'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content_id': contentId,
      'content_type': contentType.name,
      'mastery_level': masteryLevel,
      'review_count': reviewCount,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'next_review_date': nextReviewDate?.toIso8601String(),
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'repetitions': repetitions,
      'first_learned_at': firstLearnedAt?.toIso8601String(),
      'last_reviewed_at': lastReviewedAt?.toIso8601String(),
      'is_favorite': isFavorite,
      'notes': notes,
    };
  }

  /// Calculate accuracy percentage
  double get accuracy {
    final total = correctCount + incorrectCount;
    if (total == 0) return 0.0;
    return (correctCount / total) * 100;
  }

  /// Check if item is due for review
  bool get isDueForReview {
    if (nextReviewDate == null) return true;
    return DateTime.now().isAfter(nextReviewDate!) ||
           _isSameDay(DateTime.now(), nextReviewDate!);
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Create a copy with updated fields
  UserProgressModel copyWith({
    String? id,
    String? userId,
    String? contentId,
    ContentType? contentType,
    int? masteryLevel,
    int? reviewCount,
    int? correctCount,
    int? incorrectCount,
    DateTime? nextReviewDate,
    double? easeFactor,
    int? intervalDays,
    int? repetitions,
    DateTime? firstLearnedAt,
    DateTime? lastReviewedAt,
    bool? isFavorite,
    String? notes,
  }) {
    return UserProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      firstLearnedAt: firstLearnedAt ?? this.firstLearnedAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        contentId,
        contentType,
        masteryLevel,
        reviewCount,
        correctCount,
        incorrectCount,
        nextReviewDate,
        easeFactor,
        intervalDays,
        repetitions,
        firstLearnedAt,
        lastReviewedAt,
        isFavorite,
        notes,
      ];
}

/// Content type enum
enum ContentType {
  word,
  phrase,
  grammar,
  reading,
  listening,
  translation,
  phonetic,
}

/// Study session model
class StudySessionModel extends Equatable {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int xpEarned;
  final int itemsStudied;
  final int correctAnswers;
  final int incorrectAnswers;
  final ContentType contentType;

  const StudySessionModel({
    required this.id,
    required this.userId,
    required this.startedAt,
    this.endedAt,
    this.xpEarned = 0,
    this.itemsStudied = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    required this.contentType,
  });

  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    return StudySessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      xpEarned: json['xp_earned'] as int? ?? 0,
      itemsStudied: json['items_studied'] as int? ?? 0,
      correctAnswers: json['correct_answers'] as int? ?? 0,
      incorrectAnswers: json['incorrect_answers'] as int? ?? 0,
      contentType: ContentType.values.firstWhere(
        (t) => t.name == json['content_type'],
        orElse: () => ContentType.word,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'xp_earned': xpEarned,
      'items_studied': itemsStudied,
      'correct_answers': correctAnswers,
      'incorrect_answers': incorrectAnswers,
      'content_type': contentType.name,
    };
  }

  /// Calculate accuracy
  double get accuracy {
    final total = correctAnswers + incorrectAnswers;
    if (total == 0) return 0.0;
    return (correctAnswers / total) * 100;
  }

  /// Get session duration
  Duration? get duration {
    if (endedAt == null) return null;
    return endedAt!.difference(startedAt);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        startedAt,
        endedAt,
        xpEarned,
        itemsStudied,
        correctAnswers,
        incorrectAnswers,
        contentType,
      ];
}
