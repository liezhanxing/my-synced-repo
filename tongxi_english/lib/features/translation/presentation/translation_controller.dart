import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/translation_local_data.dart';
import '../data/translation_repository.dart';

/// Translation filter state
class TranslationFilter {
  final TranslationDirection? direction;
  final TranslationDifficulty? difficulty;

  const TranslationFilter({
    this.direction,
    this.difficulty,
  });

  TranslationFilter copyWith({
    TranslationDirection? direction,
    TranslationDifficulty? difficulty,
  }) {
    return TranslationFilter(
      direction: direction ?? this.direction,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

/// Translation exercise state
class TranslationExerciseState {
  final TranslationExercise? currentExercise;
  final String userAnswer;
  final bool isSubmitted;
  final double? score;
  final bool isLoading;
  final String? error;
  final DateTime? sessionStart;

  TranslationExerciseState({
    this.currentExercise,
    this.userAnswer = '',
    this.isSubmitted = false,
    this.score,
    this.isLoading = false,
    this.error,
    this.sessionStart,
  });

  TranslationExerciseState copyWith({
    TranslationExercise? currentExercise,
    String? userAnswer,
    bool? isSubmitted,
    double? score,
    bool? isLoading,
    String? error,
    DateTime? sessionStart,
  }) {
    return TranslationExerciseState(
      currentExercise: currentExercise ?? this.currentExercise,
      userAnswer: userAnswer ?? this.userAnswer,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      score: score ?? this.score,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessionStart: sessionStart ?? this.sessionStart,
    );
  }
}

/// Translation session statistics
class TranslationSessionStats {
  final int exercisesCompleted;
  final double totalScore;
  final int exercisesAttempted;
  final DateTime sessionStart;

  const TranslationSessionStats({
    this.exercisesCompleted = 0,
    this.totalScore = 0,
    this.exercisesAttempted = 0,
    required this.sessionStart,
  });

  double get averageScore {
    if (exercisesAttempted == 0) return 0;
    return totalScore / exercisesAttempted;
  }

  TranslationSessionStats copyWith({
    int? exercisesCompleted,
    double? totalScore,
    int? exercisesAttempted,
    DateTime? sessionStart,
  }) {
    return TranslationSessionStats(
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      totalScore: totalScore ?? this.totalScore,
      exercisesAttempted: exercisesAttempted ?? this.exercisesAttempted,
      sessionStart: sessionStart ?? this.sessionStart,
    );
  }
}

/// Main translation state
class TranslationState {
  final List<TranslationExercise> exercises;
  final TranslationFilter filter;
  final TranslationExerciseState exerciseState;
  final TranslationSessionStats sessionStats;
  final TranslationExercise? dailyChallenge;
  final bool isLoading;
  final String? error;

  TranslationState({
    this.exercises = const [],
    this.filter = const TranslationFilter(),
    TranslationExerciseState? exerciseState,
    TranslationSessionStats? sessionStats,
    this.dailyChallenge,
    this.isLoading = false,
    this.error,
  })  : exerciseState = exerciseState ?? TranslationExerciseState(sessionStart: DateTime.now()),
        sessionStats = sessionStats ?? TranslationSessionStats(sessionStart: DateTime.now());

  TranslationState copyWith({
    List<TranslationExercise>? exercises,
    TranslationFilter? filter,
    TranslationExerciseState? exerciseState,
    TranslationSessionStats? sessionStats,
    TranslationExercise? dailyChallenge,
    bool? isLoading,
    String? error,
  }) {
    return TranslationState(
      exercises: exercises ?? this.exercises,
      filter: filter ?? this.filter,
      exerciseState: exerciseState ?? this.exerciseState,
      sessionStats: sessionStats ?? this.sessionStats,
      dailyChallenge: dailyChallenge ?? this.dailyChallenge,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get filtered exercises
  List<TranslationExercise> get filteredExercises {
    return exercises.where((e) {
      if (filter.direction != null && e.direction != filter.direction) {
        return false;
      }
      if (filter.difficulty != null && e.difficulty != filter.difficulty) {
        return false;
      }
      return true;
    }).toList();
  }
}

/// Translation repository provider
final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  // Note: In a real app, you'd inject SharedPreferences here
  return TranslationRepository();
});

/// Translation controller provider
final translationControllerProvider =
    StateNotifierProvider<TranslationController, TranslationState>((ref) {
  final repository = ref.watch(translationRepositoryProvider);
  return TranslationController(repository);
});

/// Translation controller
class TranslationController extends StateNotifier<TranslationState> {
  final TranslationRepository _repository;

  TranslationController(this._repository) : super(TranslationState()) {
    _init();
  }

  Future<void> _init() async {
    await loadExercises();
    await loadDailyChallenge();
  }

  /// Load all exercises
  Future<void> loadExercises() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final exercises = await _repository.getAllExercises();
      state = state.copyWith(
        exercises: exercises,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载练习失败: $e',
      );
    }
  }

  /// Load daily challenge
  Future<void> loadDailyChallenge() async {
    try {
      final challenge = await _repository.getDailyChallenge();
      state = state.copyWith(dailyChallenge: challenge);
    } catch (e) {
      // Silently fail for daily challenge
    }
  }

  /// Set direction filter
  void setDirectionFilter(TranslationDirection? direction) {
    state = state.copyWith(
      filter: state.filter.copyWith(direction: direction),
    );
  }

  /// Set difficulty filter
  void setDifficultyFilter(TranslationDifficulty? difficulty) {
    state = state.copyWith(
      filter: state.filter.copyWith(difficulty: difficulty),
    );
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(filter: const TranslationFilter());
  }

  /// Start a new exercise
  void startExercise(TranslationExercise exercise) {
    state = state.copyWith(
      exerciseState: TranslationExerciseState(
        currentExercise: exercise,
        sessionStart: state.exerciseState.sessionStart,
      ),
    );
  }

  /// Update user answer
  void updateUserAnswer(String answer) {
    state = state.copyWith(
      exerciseState: state.exerciseState.copyWith(userAnswer: answer),
    );
  }

  /// Submit answer and calculate score
  Future<void> submitAnswer() async {
    final exercise = state.exerciseState.currentExercise;
    if (exercise == null) return;

    final userAnswer = state.exerciseState.userAnswer;
    if (userAnswer.trim().isEmpty) return;

    state = state.copyWith(
      exerciseState: state.exerciseState.copyWith(isLoading: true),
    );

    try {
      final score = _calculateScore(
        userAnswer: userAnswer,
        modelAnswer: exercise.targetText,
        alternatives: exercise.alternativeAnswers,
      );

      // Cache the result
      await _repository.cacheExerciseResult(
        exerciseId: exercise.id,
        userAnswer: userAnswer,
        score: score,
        completedAt: DateTime.now(),
      );

      // Update session stats
      final newStats = state.sessionStats.copyWith(
        exercisesAttempted: state.sessionStats.exercisesAttempted + 1,
        totalScore: state.sessionStats.totalScore + score,
        exercisesCompleted: score >= 70
            ? state.sessionStats.exercisesCompleted + 1
            : state.sessionStats.exercisesCompleted,
      );

      state = state.copyWith(
        exerciseState: state.exerciseState.copyWith(
          isLoading: false,
          isSubmitted: true,
          score: score,
        ),
        sessionStats: newStats,
      );
    } catch (e) {
      state = state.copyWith(
        exerciseState: state.exerciseState.copyWith(
          isLoading: false,
          error: '提交失败: $e',
        ),
      );
    }
  }

  /// Calculate score based on keyword matching
  /// 
  /// Score breakdown:
  /// - 90-100: Excellent (most key elements matched)
  /// - 70-89: Good (majority matched)
  /// - 50-69: Keep Practicing (some matched)
  /// - <50: Try Again (few matched)
  double _calculateScore({
    required String userAnswer,
    required String modelAnswer,
    required List<String> alternatives,
  }) {
    final normalizedUser = _normalizeText(userAnswer);
    final normalizedModel = _normalizeText(modelAnswer);

    // Extract key phrases/words from model answer
    final keyElements = _extractKeyElements(normalizedModel);

    if (keyElements.isEmpty) return 0;

    // Count matches
    int matches = 0;
    for (final element in keyElements) {
      if (normalizedUser.contains(element)) {
        matches++;
      }
    }

    // Check alternative answers
    double bestAlternativeScore = 0;
    for (final alt in alternatives) {
      final normalizedAlt = _normalizeText(alt);
      final altElements = _extractKeyElements(normalizedAlt);
      int altMatches = 0;
      for (final element in altElements) {
        if (normalizedUser.contains(element)) {
          altMatches++;
        }
      }
      final altScore = altElements.isEmpty ? 0.0 : altMatches / altElements.length;
      if (altScore > bestAlternativeScore) {
        bestAlternativeScore = altScore.toDouble();
      }
    }

    // Calculate base score
    double baseScore = matches / keyElements.length;

    // Use the better score between model and alternatives
    double finalScore = baseScore > bestAlternativeScore 
        ? baseScore 
        : bestAlternativeScore;

    // Apply some leniency - if user got at least 60% of key elements,
    // boost their score slightly
    if (finalScore >= 0.6 && finalScore < 0.9) {
      finalScore = (finalScore * 1.1).clamp(0.0, 0.89);
    }

    return (finalScore * 100).clamp(0.0, 100.0);
  }

  /// Normalize text for comparison
  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u4e00-\u9fff]'), '') // Keep Chinese chars
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Extract key elements from answer
  /// 
  /// For English: Extract content words (nouns, verbs, adjectives, adverbs)
  /// For Chinese: Extract key phrases and words
  List<String> _extractKeyElements(String text) {
    final elements = <String>[];

    // Split by spaces for both EN and CN mixed content
    final words = text.split(' ').where((w) => w.isNotEmpty).toList();

    // Common stop words to filter out (English)
    final stopWords = {
      'a', 'an', 'the', 'is', 'are', 'was', 'were', 'be', 'been',
      'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will',
      'would', 'could', 'should', 'may', 'might', 'must', 'shall',
      'can', 'need', 'dare', 'ought', 'used', 'to', 'of', 'in',
      'for', 'on', 'with', 'at', 'by', 'from', 'as', 'into',
      'through', 'during', 'before', 'after', 'above', 'below',
      'between', 'under', 'and', 'but', 'or', 'yet', 'so', 'if',
      'because', 'although', 'though', 'while', 'where', 'when',
      'that', 'which', 'who', 'whom', 'whose', 'what', 'i', 'you',
      'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us',
      'them', 'my', 'your', 'his', 'her', 'its', 'our', 'their',
      'this', 'that', 'these', 'those', '的', '了', '在', '是',
      '我', '你', '他', '她', '它', '我们', '你们', '他们',
    };

    for (final word in words) {
      // Keep Chinese characters and phrases
      if (RegExp(r'[\u4e00-\u9fff]').hasMatch(word)) {
        elements.add(word);
      } else if (word.length > 2 && !stopWords.contains(word)) {
        // For English, keep longer words that aren't stop words
        elements.add(word);
      } else if (word.length > 4) {
        // Always keep longer words
        elements.add(word);
      }
    }

    return elements;
  }

  /// Get feedback message based on score
  String getFeedbackMessage(double score) {
    if (score >= 90) {
      return '太棒了！翻译非常准确！';
    } else if (score >= 70) {
      return '很好！基本掌握了要点。';
    } else if (score >= 50) {
      return '继续练习，你会越来越好的！';
    } else {
      return '再试一次，注意关键词汇和语法结构。';
    }
  }

  /// Get mascot expression based on score
  String getMascotExpression(double score) {
    if (score >= 90) {
      return 'celebrating';
    } else if (score >= 70) {
      return 'happy';
    } else if (score >= 50) {
      return 'thinking';
    } else {
      return 'sad';
    }
  }

  /// Get next exercise
  TranslationExercise? getNextExercise() {
    final currentId = state.exerciseState.currentExercise?.id;
    final filtered = state.filteredExercises;

    if (filtered.isEmpty) return null;

    if (currentId == null) return filtered.first;

    final currentIndex = filtered.indexWhere((e) => e.id == currentId);
    if (currentIndex < 0 || currentIndex >= filtered.length - 1) {
      return filtered.first; // Loop back to start
    }

    return filtered[currentIndex + 1];
  }

  /// Go to next exercise
  void goToNextExercise() {
    final next = getNextExercise();
    if (next != null) {
      startExercise(next);
    }
  }

  /// Try again with current exercise
  void tryAgain() {
    final exercise = state.exerciseState.currentExercise;
    if (exercise != null) {
      state = state.copyWith(
        exerciseState: TranslationExerciseState(
          currentExercise: exercise,
          sessionStart: state.exerciseState.sessionStart,
        ),
      );
    }
  }

  /// Reset session
  void resetSession() {
    state = TranslationState(
      exercises: state.exercises,
      dailyChallenge: state.dailyChallenge,
    );
  }

  /// Get score color
  String getScoreLevel(double score) {
    if (score >= 90) return 'excellent';
    if (score >= 70) return 'good';
    if (score >= 50) return 'average';
    return 'poor';
  }
}

/// Provider for current exercise
final currentExerciseProvider = Provider<TranslationExercise?>((ref) {
  return ref.watch(translationControllerProvider).exerciseState.currentExercise;
});

/// Provider for filtered exercises
final filteredExercisesProvider = Provider<List<TranslationExercise>>((ref) {
  return ref.watch(translationControllerProvider).filteredExercises;
});

/// Provider for session stats
final sessionStatsProvider = Provider<TranslationSessionStats>((ref) {
  return ref.watch(translationControllerProvider).sessionStats;
});
