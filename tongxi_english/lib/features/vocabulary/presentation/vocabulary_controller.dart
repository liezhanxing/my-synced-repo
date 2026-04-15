import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/word_model.dart';
import '../data/vocabulary_local_data.dart';
import '../data/vocabulary_repository.dart';
import '../domain/review_state.dart';
import '../domain/vocabulary_models.dart';

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository();
});

final vocabularyControllerProvider =
    StateNotifierProvider<VocabularyController, VocabularyState>((ref) {
  final repository = ref.watch(vocabularyRepositoryProvider);
  return VocabularyController(repository);
});

class VocabularyState {
  final bool isLoading;
  final String? error;
  final VocabularyTab tab;
  final List<WordModel> allWords;
  final Map<String, List<WordModel>> groupedWords;
  final String selectedUnit;
  final int flashcardIndex;
  final bool flashcardFlipped;
  final List<VocabularyQuizQuestion> quizQuestions;
  final int quizIndex;
  final int quizScore;
  final bool quizCompleted;
  final String spellingAnswer;
  final Map<String, ReviewState> reviewStates;
  final List<WordModel> dueWords;
  final int reviewIndex;
  final bool reviewFlipped;

  const VocabularyState({
    this.isLoading = false,
    this.error,
    this.tab = VocabularyTab.list,
    this.allWords = const [],
    this.groupedWords = const {},
    this.selectedUnit = '全部',
    this.flashcardIndex = 0,
    this.flashcardFlipped = false,
    this.quizQuestions = const [],
    this.quizIndex = 0,
    this.quizScore = 0,
    this.quizCompleted = false,
    this.spellingAnswer = '',
    this.reviewStates = const {},
    this.dueWords = const [],
    this.reviewIndex = 0,
    this.reviewFlipped = false,
  });

  VocabularyState copyWith({
    bool? isLoading,
    String? error,
    VocabularyTab? tab,
    List<WordModel>? allWords,
    Map<String, List<WordModel>>? groupedWords,
    String? selectedUnit,
    int? flashcardIndex,
    bool? flashcardFlipped,
    List<VocabularyQuizQuestion>? quizQuestions,
    int? quizIndex,
    int? quizScore,
    bool? quizCompleted,
    String? spellingAnswer,
    Map<String, ReviewState>? reviewStates,
    List<WordModel>? dueWords,
    int? reviewIndex,
    bool? reviewFlipped,
  }) {
    return VocabularyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      tab: tab ?? this.tab,
      allWords: allWords ?? this.allWords,
      groupedWords: groupedWords ?? this.groupedWords,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      flashcardIndex: flashcardIndex ?? this.flashcardIndex,
      flashcardFlipped: flashcardFlipped ?? this.flashcardFlipped,
      quizQuestions: quizQuestions ?? this.quizQuestions,
      quizIndex: quizIndex ?? this.quizIndex,
      quizScore: quizScore ?? this.quizScore,
      quizCompleted: quizCompleted ?? this.quizCompleted,
      spellingAnswer: spellingAnswer ?? this.spellingAnswer,
      reviewStates: reviewStates ?? this.reviewStates,
      dueWords: dueWords ?? this.dueWords,
      reviewIndex: reviewIndex ?? this.reviewIndex,
      reviewFlipped: reviewFlipped ?? this.reviewFlipped,
    );
  }

  List<WordModel> get filteredWords {
    if (selectedUnit == '全部') return allWords;
    return groupedWords[selectedUnit] ?? const [];
  }

  WordModel? get currentFlashcard {
    final words = filteredWords;
    if (words.isEmpty || flashcardIndex >= words.length) return null;
    return words[flashcardIndex];
  }

  VocabularyQuizQuestion? get currentQuestion {
    if (quizQuestions.isEmpty || quizIndex >= quizQuestions.length) return null;
    return quizQuestions[quizIndex];
  }

  WordModel? get currentReviewWord {
    if (dueWords.isEmpty || reviewIndex >= dueWords.length) return null;
    return dueWords[reviewIndex];
  }
}

class VocabularyController extends StateNotifier<VocabularyState> {
  VocabularyController(this._repository) : super(const VocabularyState()) {
    load();
  }

  final VocabularyRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final words = await _repository.getAllWords();
      final grouped = await _repository.getGroupedWords();
      final quiz = await _repository.buildQuizQuestions();
      final reviewStates = await _repository.getReviewStates();
      final dueWords = await _repository.getDueWords();
      state = state.copyWith(
        isLoading: false,
        allWords: words,
        groupedWords: {'全部': words, ...grouped},
        quizQuestions: quiz,
        reviewStates: reviewStates,
        dueWords: dueWords,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载词汇失败：$e');
    }
  }

  void switchTab(VocabularyTab tab) {
    state = state.copyWith(tab: tab);
  }

  void selectUnit(String unit) {
    state = state.copyWith(selectedUnit: unit, flashcardIndex: 0, flashcardFlipped: false);
  }

  void flipFlashcard() {
    state = state.copyWith(flashcardFlipped: !state.flashcardFlipped);
  }

  Future<void> rateFlashcard(bool knowIt) async {
    final word = state.currentFlashcard;
    if (word == null) return;
    await _repository.updateReviewState(word.id, knowIt ? 4 : 2);
    final dueWords = await _repository.getDueWords();
    final reviewStates = await _repository.getReviewStates();
    final nextIndex = state.flashcardIndex + 1;
    state = state.copyWith(
      flashcardIndex: nextIndex >= state.filteredWords.length ? 0 : nextIndex,
      flashcardFlipped: false,
      dueWords: dueWords,
      reviewStates: reviewStates,
    );
  }

  void updateSpellingAnswer(String value) {
    state = state.copyWith(spellingAnswer: value);
  }

  Future<bool> submitQuizAnswer(String answer) async {
    final question = state.currentQuestion;
    if (question == null) return false;
    final normalized = answer.trim().toLowerCase();
    final isCorrect = normalized == question.correctAnswer.trim().toLowerCase();
    final relatedWord = state.allWords.firstWhere((word) => word.id == question.relatedWordId);
    await _repository.updateReviewState(relatedWord.id, isCorrect ? 5 : 2);
    state = state.copyWith(
      quizScore: state.quizScore + (isCorrect ? 1 : 0),
      quizIndex: state.quizIndex + 1,
      quizCompleted: state.quizIndex + 1 >= state.quizQuestions.length,
      spellingAnswer: '',
      reviewStates: await _repository.getReviewStates(),
      dueWords: await _repository.getDueWords(),
    );
    return isCorrect;
  }

  Future<void> restartQuiz() async {
    final quiz = await _repository.buildQuizQuestions();
    state = state.copyWith(
      quizQuestions: quiz,
      quizIndex: 0,
      quizScore: 0,
      quizCompleted: false,
      spellingAnswer: '',
    );
  }

  void flipReviewCard() {
    state = state.copyWith(reviewFlipped: !state.reviewFlipped);
  }

  Future<void> rateReviewWord(bool knowIt) async {
    final word = state.currentReviewWord;
    if (word == null) return;
    await _repository.updateReviewState(word.id, knowIt ? 5 : 2);
    final dueWords = await _repository.getDueWords();
    final reviewStates = await _repository.getReviewStates();
    final nextIndex = state.reviewIndex + 1;
    state = state.copyWith(
      dueWords: dueWords,
      reviewStates: reviewStates,
      reviewIndex: nextIndex >= dueWords.length ? 0 : nextIndex,
      reviewFlipped: false,
    );
  }

  List<String> get unitOptions => ['全部', ...VocabularyLocalData.units];
}
