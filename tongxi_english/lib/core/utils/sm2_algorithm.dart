import 'dart:math';

/// SM-2 Spaced Repetition Algorithm Implementation
/// 
/// The SM-2 algorithm is used to calculate optimal review intervals
/// for flashcard-based learning. It adjusts intervals based on
/// the quality of the user's response.
/// 
/// Quality ratings:
/// 0 - Complete blackout
/// 1 - Incorrect response, correct one remembered
/// 2 - Incorrect response, easy to recall correct one
/// 3 - Correct response, recalled with serious difficulty
/// 4 - Correct response, after a hesitation
/// 5 - Perfect response
class Sm2Algorithm {
  Sm2Algorithm._();

  /// Minimum ease factor
  static const double minEaseFactor = 1.3;

  /// Default ease factor for new items
  static const double defaultEaseFactor = 2.5;

  /// Calculate the next review data based on SM-2 algorithm
  /// 
  /// Parameters:
  /// - [quality]: Response quality (0-5)
  /// - [previousInterval]: Previous interval in days (default: 0)
  /// - [previousEaseFactor]: Previous ease factor (default: 2.5)
  /// - [previousRepetitions]: Number of previous successful repetitions (default: 0)
  /// 
  /// Returns a [Sm2Result] containing:
  /// - nextInterval: Days until next review
  /// - nextEaseFactor: Updated ease factor
  /// - nextRepetitions: Updated repetition count
  /// - nextReviewDate: Calculated next review date
  static Sm2Result calculate({
    required int quality,
    int previousInterval = 0,
    double previousEaseFactor = defaultEaseFactor,
    int previousRepetitions = 0,
  }) {
    // Validate quality
    final validQuality = quality.clamp(0, 5);
    
    int nextInterval;
    double nextEaseFactor;
    int nextRepetitions;
    DateTime nextReviewDate;

    // If quality is less than 3, start repetitions from beginning
    if (validQuality < 3) {
      nextRepetitions = 0;
      nextInterval = 1;
    } else {
      nextRepetitions = previousRepetitions + 1;
      
      if (nextRepetitions == 1) {
        nextInterval = 1;
      } else if (nextRepetitions == 2) {
        nextInterval = 6;
      } else {
        nextInterval = (previousInterval * previousEaseFactor).round();
      }
    }

    // Calculate new ease factor
    nextEaseFactor = _calculateNewEaseFactor(
      previousEaseFactor,
      validQuality,
    );

    // Calculate next review date
    nextReviewDate = DateTime.now().add(Duration(days: nextInterval));

    return Sm2Result(
      nextInterval: nextInterval,
      nextEaseFactor: nextEaseFactor,
      nextRepetitions: nextRepetitions,
      nextReviewDate: nextReviewDate,
    );
  }

  /// Calculate new ease factor
  static double _calculateNewEaseFactor(
    double oldEaseFactor,
    int quality,
  ) {
    double newEaseFactor = oldEaseFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    
    // Ensure ease factor doesn't drop below minimum
    return max(newEaseFactor, minEaseFactor);
  }

  /// Get recommended action based on quality
  static String getRecommendedAction(int quality) {
    switch (quality) {
      case 0:
      case 1:
      case 2:
        return '需要重新学习';
      case 3:
        return '困难 - 需要更多复习';
      case 4:
        return '良好 - 正常进度';
      case 5:
        return '完美 - 可以延长间隔';
      default:
        return '未知';
    }
  }

  /// Get quality description
  static String getQualityDescription(int quality) {
    switch (quality) {
      case 0:
        return '完全忘记';
      case 1:
        return '记错了，但记得正确答案';
      case 2:
        return '记错了，但很容易想起正确答案';
      case 3:
        return '正确，但回忆很困难';
      case 4:
        return '正确，稍有犹豫';
      case 5:
        return '完美回答';
      default:
        return '未知';
    }
  }

  /// Calculate mastery level based on ease factor and repetitions
  static double calculateMasteryLevel(double easeFactor, int repetitions) {
    // Base mastery from repetitions (max 50%)
    double repetitionMastery = (repetitions / 10).clamp(0.0, 0.5);
    
    // Additional mastery from ease factor (max 50%)
    double easeMastery = ((easeFactor - minEaseFactor) / 2.0).clamp(0.0, 0.5);
    
    return repetitionMastery + easeMastery;
  }

  /// Determine if item is due for review
  static bool isDueForReview(DateTime nextReviewDate) {
    return DateTime.now().isAfter(nextReviewDate) ||
           _isSameDay(DateTime.now(), nextReviewDate);
  }

  /// Check if two dates are the same day
  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get days until next review
  static int getDaysUntilReview(DateTime nextReviewDate) {
    final now = DateTime.now();
    final difference = nextReviewDate.difference(now);
    return difference.inDays;
  }

  /// Get overdue days
  static int getOverdueDays(DateTime nextReviewDate) {
    final daysUntil = getDaysUntilReview(nextReviewDate);
    return daysUntil < 0 ? -daysUntil : 0;
  }
}

/// Result of SM-2 calculation
class Sm2Result {
  /// Days until next review
  final int nextInterval;
  
  /// Updated ease factor
  final double nextEaseFactor;
  
  /// Updated repetition count
  final int nextRepetitions;
  
  /// Calculated next review date
  final DateTime nextReviewDate;

  const Sm2Result({
    required this.nextInterval,
    required this.nextEaseFactor,
    required this.nextRepetitions,
    required this.nextReviewDate,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'nextInterval': nextInterval,
      'nextEaseFactor': nextEaseFactor,
      'nextRepetitions': nextRepetitions,
      'nextReviewDate': nextReviewDate.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Sm2Result.fromJson(Map<String, dynamic> json) {
    return Sm2Result(
      nextInterval: json['nextInterval'] as int,
      nextEaseFactor: json['nextEaseFactor'] as double,
      nextRepetitions: json['nextRepetitions'] as int,
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
    );
  }

  @override
  String toString() {
    return 'Sm2Result(interval: $nextInterval days, '
           'ease: ${nextEaseFactor.toStringAsFixed(2)}, '
           'reps: $nextRepetitions, '
           'next: ${nextReviewDate.toIso8601String()})';
  }
}

/// Study session statistics
class StudySessionStats {
  final int totalItems;
  final int newItems;
  final int reviewItems;
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalXpEarned;
  final Duration studyDuration;

  const StudySessionStats({
    required this.totalItems,
    required this.newItems,
    required this.reviewItems,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalXpEarned,
    required this.studyDuration,
  });

  /// Calculate accuracy percentage
  double get accuracy {
    if (totalItems == 0) return 0.0;
    return (correctAnswers / totalItems) * 100;
  }

  /// Calculate average time per item
  Duration get averageTimePerItem {
    if (totalItems == 0) return Duration.zero;
    return Duration(
      milliseconds: studyDuration.inMilliseconds ~/ totalItems,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'newItems': newItems,
      'reviewItems': reviewItems,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'totalXpEarned': totalXpEarned,
      'studyDurationMs': studyDuration.inMilliseconds,
    };
  }
}
