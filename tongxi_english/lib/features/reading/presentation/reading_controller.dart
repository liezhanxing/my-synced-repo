import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/reading_model.dart';
import '../data/reading_repository.dart';

// ==================== Providers ====================

/// Reading repository provider
final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepository();
});

/// All passages provider
final allPassagesProvider = FutureProvider<List<ReadingModel>>((ref) async {
  final repository = ref.watch(readingRepositoryProvider);
  return await repository.getAllPassages();
});

/// Passages by difficulty provider
final passagesByDifficultyProvider = FutureProvider.family<List<ReadingModel>, int>((ref, difficulty) async {
  final repository = ref.watch(readingRepositoryProvider);
  return await repository.getPassagesByDifficulty(difficulty);
});

/// Reading statistics provider
final readingStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(readingRepositoryProvider);
  return await repository.getStatistics();
});

/// Selected passage provider
final selectedPassageProvider = StateProvider<ReadingModel?>((ref) => null);

/// Reading filter provider
final readingFilterProvider = StateProvider<ReadingFilter>((ref) {
  return const ReadingFilter();
});

/// Filtered passages provider
final filteredPassagesProvider = Provider<AsyncValue<List<ReadingModel>>>((ref) {
  final allPassagesAsync = ref.watch(allPassagesProvider);
  final filter = ref.watch(readingFilterProvider);
  
  return allPassagesAsync.when(
    data: (passages) {
      var filtered = passages;
      
      // Filter by difficulty
      if (filter.difficulty != null) {
        filtered = filtered.where((p) => p.difficulty == filter.difficulty).toList();
      }
      
      // Filter by category
      if (filter.category != null) {
        filtered = filtered.where((p) => p.category == filter.category).toList();
      }
      
      // Filter by search query
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        filtered = filtered.where((p) {
          return p.title.toLowerCase().contains(query) ||
                 p.content.toLowerCase().contains(query) ||
                 p.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();
      }
      
      // Sort
      switch (filter.sortBy) {
        case ReadingSortBy.difficultyAsc:
          filtered.sort((a, b) => a.difficulty.compareTo(b.difficulty));
          break;
        case ReadingSortBy.difficultyDesc:
          filtered.sort((a, b) => b.difficulty.compareTo(a.difficulty));
          break;
        case ReadingSortBy.wordCountAsc:
          filtered.sort((a, b) => a.wordCount.compareTo(b.wordCount));
          break;
        case ReadingSortBy.wordCountDesc:
          filtered.sort((a, b) => b.wordCount.compareTo(a.wordCount));
          break;
        case ReadingSortBy.title:
          filtered.sort((a, b) => a.title.compareTo(b.title));
          break;
        case ReadingSortBy.none:
        default:
          break;
      }
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

/// Reading controller provider
final readingControllerProvider = StateNotifierProvider<ReadingController, ReadingState>((ref) {
  final repository = ref.watch(readingRepositoryProvider);
  return ReadingController(repository: repository);
});

// ==================== Filter Model ====================

class ReadingFilter {
  final int? difficulty;
  final ReadingCategory? category;
  final String? searchQuery;
  final ReadingSortBy sortBy;

  const ReadingFilter({
    this.difficulty,
    this.category,
    this.searchQuery,
    this.sortBy = ReadingSortBy.none,
  });

  ReadingFilter copyWith({
    int? difficulty,
    ReadingCategory? category,
    String? searchQuery,
    ReadingSortBy? sortBy,
    bool clearDifficulty = false,
    bool clearCategory = false,
    bool clearSearch = false,
  }) {
    return ReadingFilter(
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      category: clearCategory ? null : (category ?? this.category),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum ReadingSortBy {
  none,
  difficultyAsc,
  difficultyDesc,
  wordCountAsc,
  wordCountDesc,
  title,
}

// ==================== State ====================

class ReadingState {
  final ReadingModel? selectedPassage;
  final bool isLoading;
  final String? error;
  
  // Reading session state
  final bool isReading;
  final int readingTimeSeconds;
  final double fontScale;
  final Set<String> highlightedWords;
  
  // Question state
  final bool isAnsweringQuestions;
  final int currentQuestionIndex;
  final Map<String, int> userAnswers; // questionId -> selectedOption
  final bool showResults;
  
  // Progress
  final bool isSavingProgress;

  const ReadingState({
    this.selectedPassage,
    this.isLoading = false,
    this.error,
    this.isReading = false,
    this.readingTimeSeconds = 0,
    this.fontScale = 1.0,
    this.highlightedWords = const {},
    this.isAnsweringQuestions = false,
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.showResults = false,
    this.isSavingProgress = false,
  });

  ReadingState copyWith({
    ReadingModel? selectedPassage,
    bool? isLoading,
    String? error,
    bool? isReading,
    int? readingTimeSeconds,
    double? fontScale,
    Set<String>? highlightedWords,
    bool? isAnsweringQuestions,
    int? currentQuestionIndex,
    Map<String, int>? userAnswers,
    bool? showResults,
    bool? isSavingProgress,
    bool clearError = false,
    bool clearSelectedPassage = false,
  }) {
    return ReadingState(
      selectedPassage: clearSelectedPassage ? null : (selectedPassage ?? this.selectedPassage),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isReading: isReading ?? this.isReading,
      readingTimeSeconds: readingTimeSeconds ?? this.readingTimeSeconds,
      fontScale: fontScale ?? this.fontScale,
      highlightedWords: highlightedWords ?? this.highlightedWords,
      isAnsweringQuestions: isAnsweringQuestions ?? this.isAnsweringQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      showResults: showResults ?? this.showResults,
      isSavingProgress: isSavingProgress ?? this.isSavingProgress,
    );
  }

  // Computed properties
  int get correctAnswersCount {
    if (selectedPassage == null) return 0;
    int count = 0;
    for (final question in selectedPassage!.questions) {
      if (userAnswers[question.id] == question.correctAnswer) {
        count++;
      }
    }
    return count;
  }

  double get scorePercentage {
    if (selectedPassage == null || selectedPassage!.questions.isEmpty) return 0;
    return (correctAnswersCount / selectedPassage!.questions.length) * 100;
  }

  bool get isPassing {
    return scorePercentage >= 60;
  }

  bool get allQuestionsAnswered {
    if (selectedPassage == null) return false;
    return userAnswers.length == selectedPassage!.questions.length;
  }
}

// ==================== Controller ====================

class ReadingController extends StateNotifier<ReadingState> {
  final ReadingRepository _repository;
  Timer? _readingTimer;

  ReadingController({required ReadingRepository repository})
      : _repository = repository,
        super(const ReadingState());

  @override
  void dispose() {
    _readingTimer?.cancel();
    super.dispose();
  }

  // ==================== Passage Selection ====================

  void selectPassage(ReadingModel passage) {
    state = state.copyWith(
      selectedPassage: passage,
      isReading: false,
      readingTimeSeconds: 0,
      isAnsweringQuestions: false,
      currentQuestionIndex: 0,
      userAnswers: {},
      showResults: false,
      clearError: true,
    );
  }

  void clearSelectedPassage() {
    _stopTimer();
    state = state.copyWith(
      clearSelectedPassage: true,
      isReading: false,
      readingTimeSeconds: 0,
      isAnsweringQuestions: false,
      showResults: false,
    );
  }

  // ==================== Reading Session ====================

  void startReading() {
    state = state.copyWith(isReading: true);
    _startTimer();
  }

  void pauseReading() {
    _stopTimer();
    state = state.copyWith(isReading: false);
  }

  void resumeReading() {
    state = state.copyWith(isReading: true);
    _startTimer();
  }

  void _startTimer() {
    _readingTimer?.cancel();
    _readingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(readingTimeSeconds: state.readingTimeSeconds + 1);
    });
  }

  void _stopTimer() {
    _readingTimer?.cancel();
    _readingTimer = null;
  }

  // ==================== Font Scale ====================

  void setFontScale(double scale) {
    // Clamp between 0.8 (small) and 1.5 (large)
    final clampedScale = scale.clamp(0.8, 1.5);
    state = state.copyWith(fontScale: clampedScale);
  }

  void increaseFontSize() {
    setFontScale(state.fontScale + 0.1);
  }

  void decreaseFontSize() {
    setFontScale(state.fontScale - 0.1);
  }

  // ==================== Vocabulary ====================

  void toggleWordHighlight(String word) {
    final newSet = Set<String>.from(state.highlightedWords);
    if (newSet.contains(word)) {
      newSet.remove(word);
    } else {
      newSet.add(word);
    }
    state = state.copyWith(highlightedWords: newSet);
  }

  // ==================== Questions ====================

  void startAnsweringQuestions() {
    _stopTimer();
    state = state.copyWith(
      isAnsweringQuestions: true,
      currentQuestionIndex: 0,
      userAnswers: {},
      showResults: false,
    );
  }

  void answerQuestion(String questionId, int selectedOption) {
    final newAnswers = Map<String, int>.from(state.userAnswers);
    newAnswers[questionId] = selectedOption;
    state = state.copyWith(userAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state.selectedPassage == null) return;
    if (state.currentQuestionIndex < state.selectedPassage!.questions.length - 1) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }

  void goToQuestion(int index) {
    if (state.selectedPassage == null) return;
    if (index >= 0 && index < state.selectedPassage!.questions.length) {
      state = state.copyWith(currentQuestionIndex: index);
    }
  }

  void submitAnswers() {
    state = state.copyWith(showResults: true);
    _saveProgress();
  }

  void restartQuestions() {
    state = state.copyWith(
      currentQuestionIndex: 0,
      userAnswers: {},
      showResults: false,
    );
  }

  // ==================== Progress ====================

  Future<void> _saveProgress() async {
    if (state.selectedPassage == null) return;
    
    state = state.copyWith(isSavingProgress: true);
    
    try {
      await _repository.saveProgress(
        state.selectedPassage!.id,
        timeSpentSeconds: state.readingTimeSeconds,
        questionsAnswered: state.userAnswers.length,
        correctAnswers: state.correctAnswersCount,
        isCompleted: state.allQuestionsAnswered,
      );
    } catch (e) {
      // Silently handle error - progress saving is not critical
    } finally {
      state = state.copyWith(isSavingProgress: false);
    }
  }

  Future<void> saveReadingProgress() async {
    await _saveProgress();
  }

  // ==================== Utility ====================

  String get formattedReadingTime {
    final minutes = state.readingTimeSeconds ~/ 60;
    final seconds = state.readingTimeSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get difficultyLabel {
    switch (state.selectedPassage?.difficulty) {
      case 1:
        return '高一';
      case 2:
        return '高二';
      case 3:
        return '高三';
      default:
        return '';
    }
  }

  String get categoryLabel {
    switch (state.selectedPassage?.category) {
      case ReadingCategory.news:
        return '新闻';
      case ReadingCategory.story:
        return '故事';
      case ReadingCategory.academic:
        return '学术';
      case ReadingCategory.biography:
        return '传记';
      case ReadingCategory.science:
        return '科学';
      case ReadingCategory.history:
        return '历史';
      case ReadingCategory.culture:
        return '文化';
      default:
        return '';
    }
  }
}

// ==================== Extension Methods ====================

extension ReadingCategoryExtension on ReadingCategory {
  String get label {
    switch (this) {
      case ReadingCategory.news:
        return '新闻';
      case ReadingCategory.story:
        return '故事';
      case ReadingCategory.academic:
        return '学术';
      case ReadingCategory.biography:
        return '传记';
      case ReadingCategory.science:
        return '科学';
      case ReadingCategory.history:
        return '历史';
      case ReadingCategory.culture:
        return '文化';
    }
  }

  String get icon {
    switch (this) {
      case ReadingCategory.news:
        return '📰';
      case ReadingCategory.story:
        return '📚';
      case ReadingCategory.academic:
        return '🎓';
      case ReadingCategory.biography:
        return '👤';
      case ReadingCategory.science:
        return '🔬';
      case ReadingCategory.history:
        return '🏛️';
      case ReadingCategory.culture:
        return '🎭';
    }
  }
}

extension QuestionTypeExtension on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.multipleChoice:
        return '选择题';
      case QuestionType.trueFalse:
        return '判断题';
      case QuestionType.fillInBlank:
        return '填空题';
    }
  }
}
