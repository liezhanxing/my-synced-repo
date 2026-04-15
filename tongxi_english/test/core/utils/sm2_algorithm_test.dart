import 'package:flutter_test/flutter_test.dart';
import 'package:tongxi_english/core/utils/sm2_algorithm.dart';

void main() {
  group('Sm2Algorithm', () {
    group('calculate', () {
      test('initial review with quality 0 (complete blackout)', () {
        final result = Sm2Algorithm.calculate(
          quality: 0,
          previousInterval: 0,
          previousEaseFactor: Sm2Algorithm.defaultEaseFactor,
          previousRepetitions: 0,
        );

        expect(result.nextInterval, 1);
        expect(result.nextRepetitions, 0);
        expect(result.nextEaseFactor, lessThan(Sm2Algorithm.defaultEaseFactor));
        expect(result.nextReviewDate.isAfter(DateTime.now()), isTrue);
      });

      test('initial review with quality 3 (correct with difficulty)', () {
        final result = Sm2Algorithm.calculate(
          quality: 3,
          previousInterval: 0,
          previousEaseFactor: Sm2Algorithm.defaultEaseFactor,
          previousRepetitions: 0,
        );

        expect(result.nextInterval, 1);
        expect(result.nextRepetitions, 1);
        expect(result.nextEaseFactor, lessThan(Sm2Algorithm.defaultEaseFactor));
      });

      test('initial review with quality 5 (perfect response)', () {
        final result = Sm2Algorithm.calculate(
          quality: 5,
          previousInterval: 0,
          previousEaseFactor: Sm2Algorithm.defaultEaseFactor,
          previousRepetitions: 0,
        );

        expect(result.nextInterval, 1);
        expect(result.nextRepetitions, 1);
        expect(result.nextEaseFactor, greaterThan(Sm2Algorithm.defaultEaseFactor));
      });

      test('second repetition with quality 5', () {
        final result = Sm2Algorithm.calculate(
          quality: 5,
          previousInterval: 1,
          previousEaseFactor: 2.6,
          previousRepetitions: 1,
        );

        expect(result.nextInterval, 6);
        expect(result.nextRepetitions, 2);
      });

      test('third repetition with quality 5', () {
        final result = Sm2Algorithm.calculate(
          quality: 5,
          previousInterval: 6,
          previousEaseFactor: 2.7,
          previousRepetitions: 2,
        );

        expect(result.nextInterval, (6 * 2.7).round());
        expect(result.nextRepetitions, 3);
      });

      test('interval progression over multiple reviews', () {
        var interval = 0;
        var easeFactor = Sm2Algorithm.defaultEaseFactor;
        var repetitions = 0;

        // First review - quality 4
        var result = Sm2Algorithm.calculate(
          quality: 4,
          previousInterval: interval,
          previousEaseFactor: easeFactor,
          previousRepetitions: repetitions,
        );
        expect(result.nextInterval, 1);
        expect(result.nextRepetitions, 1);
        interval = result.nextInterval;
        easeFactor = result.nextEaseFactor;
        repetitions = result.nextRepetitions;

        // Second review - quality 5
        result = Sm2Algorithm.calculate(
          quality: 5,
          previousInterval: interval,
          previousEaseFactor: easeFactor,
          previousRepetitions: repetitions,
        );
        expect(result.nextInterval, 6);
        expect(result.nextRepetitions, 2);
        interval = result.nextInterval;
        easeFactor = result.nextEaseFactor;
        repetitions = result.nextRepetitions;

        // Third review - quality 5
        result = Sm2Algorithm.calculate(
          quality: 5,
          previousInterval: interval,
          previousEaseFactor: easeFactor,
          previousRepetitions: repetitions,
        );
        expect(result.nextRepetitions, 3);
        expect(result.nextInterval, greaterThan(6));
      });

      test('reset on quality < 3', () {
        // Start with some progress
        var result = Sm2Algorithm.calculate(
          quality: 5,
          previousInterval: 30,
          previousEaseFactor: 2.5,
          previousRepetitions: 5,
        );

        expect(result.nextRepetitions, 0);
        expect(result.nextInterval, 1);
      });

      test('ease factor bounds - minimum 1.3', () {
        // Apply multiple low quality ratings
        var easeFactor = Sm2Algorithm.defaultEaseFactor;

        for (var i = 0; i < 20; i++) {
          final result = Sm2Algorithm.calculate(
            quality: 0,
            previousInterval: 1,
            previousEaseFactor: easeFactor,
            previousRepetitions: 1,
          );
          easeFactor = result.nextEaseFactor;
        }

        expect(easeFactor, greaterThanOrEqualTo(Sm2Algorithm.minEaseFactor));
        expect(easeFactor, Sm2Algorithm.minEaseFactor);
      });

      test('quality ratings from 0-5 all work', () {
        for (var quality = 0; quality <= 5; quality++) {
          final result = Sm2Algorithm.calculate(
            quality: quality,
            previousInterval: 1,
            previousEaseFactor: Sm2Algorithm.defaultEaseFactor,
            previousRepetitions: 1,
          );

          expect(result.nextInterval, isPositive);
          expect(result.nextEaseFactor, isPositive);
        }
      });

      test('quality outside 0-5 is clamped', () {
        // Test quality above 5
        var result = Sm2Algorithm.calculate(
          quality: 10,
          previousInterval: 1,
          previousEaseFactor: Sm2Algorithm.defaultEaseFactor,
          previousRepetitions: 1,
        );
        expect(result.nextRepetitions, 2); // Should be treated as quality 5

        // Test quality below 0
        result = Sm2Algorithm.calculate(
          quality: -5,
          previousInterval: 1,
          previousEaseFactor: Sm2Algorithm.defaultEaseFactor,
          previousRepetitions: 1,
        );
        expect(result.nextRepetitions, 0); // Should be treated as quality 0
      });
    });

    group('getRecommendedAction', () {
      test('returns correct action for quality 0-2', () {
        expect(Sm2Algorithm.getRecommendedAction(0), '需要重新学习');
        expect(Sm2Algorithm.getRecommendedAction(1), '需要重新学习');
        expect(Sm2Algorithm.getRecommendedAction(2), '需要重新学习');
      });

      test('returns correct action for quality 3', () {
        expect(Sm2Algorithm.getRecommendedAction(3), '困难 - 需要更多复习');
      });

      test('returns correct action for quality 4', () {
        expect(Sm2Algorithm.getRecommendedAction(4), '良好 - 正常进度');
      });

      test('returns correct action for quality 5', () {
        expect(Sm2Algorithm.getRecommendedAction(5), '完美 - 可以延长间隔');
      });

      test('returns unknown for invalid quality', () {
        expect(Sm2Algorithm.getRecommendedAction(10), '未知');
      });
    });

    group('getQualityDescription', () {
      test('returns correct descriptions for all qualities', () {
        expect(Sm2Algorithm.getQualityDescription(0), '完全忘记');
        expect(Sm2Algorithm.getQualityDescription(1), '记错了，但记得正确答案');
        expect(Sm2Algorithm.getQualityDescription(2), '记错了，但很容易想起正确答案');
        expect(Sm2Algorithm.getQualityDescription(3), '正确，但回忆很困难');
        expect(Sm2Algorithm.getQualityDescription(4), '正确，稍有犹豫');
        expect(Sm2Algorithm.getQualityDescription(5), '完美回答');
      });

      test('returns unknown for invalid quality', () {
        expect(Sm2Algorithm.getQualityDescription(-1), '未知');
      });
    });

    group('calculateMasteryLevel', () {
      test('returns 0 for new item', () {
        final mastery = Sm2Algorithm.calculateMasteryLevel(
          Sm2Algorithm.minEaseFactor,
          0,
        );
        expect(mastery, 0.0);
      });

      test('returns higher value for more repetitions', () {
        final mastery5 = Sm2Algorithm.calculateMasteryLevel(2.5, 5);
        final mastery10 = Sm2Algorithm.calculateMasteryLevel(2.5, 10);
        expect(mastery10, greaterThan(mastery5));
      });

      test('returns higher value for higher ease factor', () {
        final masteryLow = Sm2Algorithm.calculateMasteryLevel(1.5, 5);
        final masteryHigh = Sm2Algorithm.calculateMasteryLevel(3.0, 5);
        expect(masteryHigh, greaterThan(masteryLow));
      });

      test('mastery is capped at 1.0', () {
        final mastery = Sm2Algorithm.calculateMasteryLevel(5.0, 100);
        expect(mastery, lessThanOrEqualTo(1.0));
      });
    });

    group('isDueForReview', () {
      test('returns true for past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        expect(Sm2Algorithm.isDueForReview(pastDate), isTrue);
      });

      test('returns true for today', () {
        final today = DateTime.now();
        expect(Sm2Algorithm.isDueForReview(today), isTrue);
      });

      test('returns false for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        expect(Sm2Algorithm.isDueForReview(futureDate), isFalse);
      });
    });

    group('getDaysUntilReview', () {
      test('returns positive for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 5));
        expect(Sm2Algorithm.getDaysUntilReview(futureDate), 5);
      });

      test('returns negative for past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 3));
        expect(Sm2Algorithm.getDaysUntilReview(pastDate), -3);
      });
    });

    group('getOverdueDays', () {
      test('returns 0 for future date', () {
        final futureDate = DateTime.now().add(const Duration(days: 5));
        expect(Sm2Algorithm.getOverdueDays(futureDate), 0);
      });

      test('returns positive for past date', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 3));
        expect(Sm2Algorithm.getOverdueDays(pastDate), 3);
      });
    });
  });

  group('Sm2Result', () {
    test('toJson converts correctly', () {
      final result = Sm2Result(
        nextInterval: 5,
        nextEaseFactor: 2.5,
        nextRepetitions: 3,
        nextReviewDate: DateTime(2024, 1, 15),
      );

      final json = result.toJson();
      expect(json['nextInterval'], 5);
      expect(json['nextEaseFactor'], 2.5);
      expect(json['nextRepetitions'], 3);
      expect(json['nextReviewDate'], '2024-01-15T00:00:00.000');
    });

    test('fromJson converts correctly', () {
      final json = {
        'nextInterval': 5,
        'nextEaseFactor': 2.5,
        'nextRepetitions': 3,
        'nextReviewDate': '2024-01-15T00:00:00.000',
      };

      final result = Sm2Result.fromJson(json);
      expect(result.nextInterval, 5);
      expect(result.nextEaseFactor, 2.5);
      expect(result.nextRepetitions, 3);
      expect(result.nextReviewDate, DateTime(2024, 1, 15));
    });

    test('toString returns formatted string', () {
      final result = Sm2Result(
        nextInterval: 5,
        nextEaseFactor: 2.5,
        nextRepetitions: 3,
        nextReviewDate: DateTime(2024, 1, 15),
      );

      expect(result.toString(), contains('interval: 5 days'));
      expect(result.toString(), contains('ease: 2.50'));
      expect(result.toString(), contains('reps: 3'));
    });
  });

  group('StudySessionStats', () {
    test('accuracy calculates correctly', () {
      final stats = StudySessionStats(
        totalItems: 10,
        newItems: 5,
        reviewItems: 5,
        correctAnswers: 8,
        incorrectAnswers: 2,
        totalXpEarned: 100,
        studyDuration: const Duration(minutes: 10),
      );

      expect(stats.accuracy, 80.0);
    });

    test('accuracy returns 0 for empty session', () {
      final stats = StudySessionStats(
        totalItems: 0,
        newItems: 0,
        reviewItems: 0,
        correctAnswers: 0,
        incorrectAnswers: 0,
        totalXpEarned: 0,
        studyDuration: Duration.zero,
      );

      expect(stats.accuracy, 0.0);
    });

    test('averageTimePerItem calculates correctly', () {
      final stats = StudySessionStats(
        totalItems: 10,
        newItems: 5,
        reviewItems: 5,
        correctAnswers: 8,
        incorrectAnswers: 2,
        totalXpEarned: 100,
        studyDuration: const Duration(minutes: 10),
      );

      expect(stats.averageTimePerItem, const Duration(minutes: 1));
    });

    test('toJson converts correctly', () {
      final stats = StudySessionStats(
        totalItems: 10,
        newItems: 5,
        reviewItems: 5,
        correctAnswers: 8,
        incorrectAnswers: 2,
        totalXpEarned: 100,
        studyDuration: const Duration(minutes: 10),
      );

      final json = stats.toJson();
      expect(json['totalItems'], 10);
      expect(json['correctAnswers'], 8);
      expect(json['studyDurationMs'], 600000);
    });
  });
}
