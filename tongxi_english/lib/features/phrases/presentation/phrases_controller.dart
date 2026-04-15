import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/phrase_model.dart';
import '../data/phrases_repository.dart';

/// Phrases state class
class PhrasesState {
  final List<PhraseModel> phrases;
  final List<PhraseModel> filteredPhrases;
  final String selectedCategory;
  final bool isLoading;
  final String? error;
  final Map<String, double> categoryProgress;

  const PhrasesState({
    this.phrases = const [],
    this.filteredPhrases = const [],
    this.selectedCategory = 'all',
    this.isLoading = false,
    this.error,
    this.categoryProgress = const {},
  });

  PhrasesState copyWith({
    List<PhraseModel>? phrases,
    List<PhraseModel>? filteredPhrases,
    String? selectedCategory,
    bool? isLoading,
    String? error,
    Map<String, double>? categoryProgress,
  }) {
    return PhrasesState(
      phrases: phrases ?? this.phrases,
      filteredPhrases: filteredPhrases ?? this.filteredPhrases,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categoryProgress: categoryProgress ?? this.categoryProgress,
    );
  }
}

/// Riverpod StateNotifier for phrase state management
class PhrasesController extends StateNotifier<PhrasesState> {
  final PhrasesRepository _repository;

  PhrasesController({PhrasesRepository? repository})
      : _repository = repository ?? PhrasesRepository(),
        super(const PhrasesState()) {
    loadPhrases();
  }

  /// Load all phrases
  Future<void> loadPhrases() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final phrases = await _repository.getAllPhrases();
      state = state.copyWith(
        phrases: phrases,
        filteredPhrases: phrases,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load phrases: $e',
      );
    }
  }

  /// Filter phrases by category
  void filterByCategory(String category) {
    if (category == 'all') {
      state = state.copyWith(
        selectedCategory: category,
        filteredPhrases: state.phrases,
      );
      return;
    }

    final filtered = state.phrases.where((phrase) {
      // Map category keys to phrase indices/ranges
      final categoryRanges = {
        'daily': [0, 7],
        'academic': [8, 15],
        'travel': [16, 23],
        'emotions': [24, 31],
        'collocations': [32, 41],
      };
      
      final range = categoryRanges[category];
      if (range != null) {
        final index = state.phrases.indexOf(phrase);
        return index >= range[0] && index <= range[1];
      }
      return false;
    }).toList();

    state = state.copyWith(
      selectedCategory: category,
      filteredPhrases: filtered,
    );
  }

  /// Search phrases
  void searchPhrases(String query) {
    if (query.isEmpty) {
      filterByCategory(state.selectedCategory);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = state.phrases.where((phrase) {
      return phrase.phrase.toLowerCase().contains(lowerQuery) ||
             phrase.translation.toLowerCase().contains(lowerQuery) ||
             phrase.meaning.toLowerCase().contains(lowerQuery);
    }).toList();

    state = state.copyWith(filteredPhrases: filtered);
  }

  /// Get category names
  Map<String, String> getCategoryNames() {
    return {
      'all': '全部',
      'daily': '日常对话',
      'academic': '学术/校园',
      'travel': '旅行',
      'emotions': '情感表达',
      'collocations': '固定搭配',
    };
  }

  /// Update category progress
  void updateCategoryProgress(String category, double progress) {
    final updatedProgress = Map<String, double>.from(state.categoryProgress);
    updatedProgress[category] = progress;
    state = state.copyWith(categoryProgress: updatedProgress);
  }

  /// Get progress for a category
  double getCategoryProgress(String category) {
    return state.categoryProgress[category] ?? 0.0;
  }
}

/// Phrases controller provider
final phrasesControllerProvider = StateNotifierProvider<PhrasesController, PhrasesState>((ref) {
  return PhrasesController();
});

/// Selected phrase provider for detail view
final selectedPhraseProvider = StateProvider<PhraseModel?>((ref) => null);

/// Current practice session state
class PracticeSessionState {
  final List<PhraseModel> practicePhrases;
  final int currentIndex;
  final int score;
  final int totalQuestions;
  final bool isCompleted;
  final Map<int, bool> answers; // question index -> isCorrect

  const PracticeSessionState({
    this.practicePhrases = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.totalQuestions = 10,
    this.isCompleted = false,
    this.answers = const {},
  });

  PracticeSessionState copyWith({
    List<PhraseModel>? practicePhrases,
    int? currentIndex,
    int? score,
    int? totalQuestions,
    bool? isCompleted,
    Map<int, bool>? answers,
  }) {
    return PracticeSessionState(
      practicePhrases: practicePhrases ?? this.practicePhrases,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
      answers: answers ?? this.answers,
    );
  }

  double get progress => totalQuestions > 0 ? currentIndex / totalQuestions : 0;
  double get accuracy => answers.isNotEmpty 
      ? answers.values.where((v) => v).length / answers.length 
      : 0;
}

/// Practice session controller
class PracticeSessionController extends StateNotifier<PracticeSessionState> {
  final PhrasesRepository _repository;

  PracticeSessionController({PhrasesRepository? repository})
      : _repository = repository ?? PhrasesRepository(),
        super(const PracticeSessionState());

  /// Start a new practice session
  Future<void> startSession({int questionCount = 10, String? category}) async {
    try {
      List<PhraseModel> phrases;
      
      if (category != null && category != 'all') {
        phrases = await _repository.getPhrasesByCategory(category);
      } else {
        phrases = await _repository.getAllPhrases();
      }
      
      // Shuffle and take required number
      phrases = (List<PhraseModel>.from(phrases)..shuffle())
          .take(questionCount)
          .toList();

      state = PracticeSessionState(
        practicePhrases: phrases,
        totalQuestions: phrases.length,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error starting practice session: $e');
      }
    }
  }

  /// Submit answer for current question
  void submitAnswer(bool isCorrect) {
    final updatedAnswers = Map<int, bool>.from(state.answers);
    updatedAnswers[state.currentIndex] = isCorrect;

    final newScore = isCorrect ? state.score + 1 : state.score;
    final newIndex = state.currentIndex + 1;
    final isCompleted = newIndex >= state.totalQuestions;

    state = state.copyWith(
      currentIndex: newIndex,
      score: newScore,
      answers: updatedAnswers,
      isCompleted: isCompleted,
    );
  }

  /// Skip current question
  void skipQuestion() {
    final updatedAnswers = Map<int, bool>.from(state.answers);
    updatedAnswers[state.currentIndex] = false;

    final newIndex = state.currentIndex + 1;
    final isCompleted = newIndex >= state.totalQuestions;

    state = state.copyWith(
      currentIndex: newIndex,
      answers: updatedAnswers,
      isCompleted: isCompleted,
    );
  }

  /// Reset session
  void resetSession() {
    state = const PracticeSessionState();
  }

  /// Get current phrase
  PhraseModel? get currentPhrase {
    if (state.currentIndex < state.practicePhrases.length) {
      return state.practicePhrases[state.currentIndex];
    }
    return null;
  }

  /// Generate fill-in-blank options for current phrase
  Future<List<String>> getFillInBlankOptions() async {
    final current = currentPhrase;
    if (current == null) return [];

    // Get the main word/phrase to blank out
    final phrase = current.phrase;

    // Get distractors from other phrases
    final allPhrases = await _repository.getAllPhrases();
    final distractors = allPhrases
        .where((p) => p.id != current.id)
        .take(3)
        .map((p) => p.phrase)
        .toList();

    final options = [phrase, ...distractors];
    options.shuffle();
    return options;
  }

  /// Generate fill-in-blank options synchronously (for UI)
  List<String> getFillInBlankOptionsSync() {
    final current = currentPhrase;
    if (current == null) return [];

    // Get the main word/phrase to blank out
    final phrase = current.phrase;

    // Use current practice phrases as distractors
    final distractors = state.practicePhrases
        .where((p) => p.id != current.id)
        .take(3)
        .map((p) => p.phrase)
        .toList();

    final options = [phrase, ...distractors];
    options.shuffle();
    return options;
  }

  /// Generate matching pairs for match exercise
  Future<Map<String, String>> getMatchingPairs(int count) async {
    final phrases = await _repository.getRandomPhrases(count);
    return {for (var p in phrases) p.phrase: p.translation};
  }
}

/// Practice session controller provider
final practiceSessionControllerProvider = StateNotifierProvider<PracticeSessionController, PracticeSessionState>((ref) {
  return PracticeSessionController();
});
