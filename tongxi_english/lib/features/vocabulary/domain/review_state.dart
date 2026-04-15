class ReviewState {
  final String wordId;
  final int interval;
  final double easeFactor;
  final int repetitions;
  final DateTime nextReviewDate;
  final int lastQuality;

  const ReviewState({
    required this.wordId,
    required this.interval,
    required this.easeFactor,
    required this.repetitions,
    required this.nextReviewDate,
    required this.lastQuality,
  });

  factory ReviewState.initial(String wordId) {
    return ReviewState(
      wordId: wordId,
      interval: 0,
      easeFactor: 2.5,
      repetitions: 0,
      nextReviewDate: DateTime.now(),
      lastQuality: 0,
    );
  }

  ReviewState copyWith({
    String? wordId,
    int? interval,
    double? easeFactor,
    int? repetitions,
    DateTime? nextReviewDate,
    int? lastQuality,
  }) {
    return ReviewState(
      wordId: wordId ?? this.wordId,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastQuality: lastQuality ?? this.lastQuality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordId': wordId,
      'interval': interval,
      'easeFactor': easeFactor,
      'repetitions': repetitions,
      'nextReviewDate': nextReviewDate.toIso8601String(),
      'lastQuality': lastQuality,
    };
  }

  factory ReviewState.fromJson(Map<String, dynamic> json) {
    return ReviewState(
      wordId: json['wordId'] as String,
      interval: json['interval'] as int? ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      repetitions: json['repetitions'] as int? ?? 0,
      nextReviewDate: DateTime.tryParse(json['nextReviewDate'] as String? ?? '') ?? DateTime.now(),
      lastQuality: json['lastQuality'] as int? ?? 0,
    );
  }
}
