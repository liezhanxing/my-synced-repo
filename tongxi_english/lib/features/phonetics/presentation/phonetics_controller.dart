import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/phonetic_model.dart';
import '../data/phonetics_repository.dart';
import '../domain/phonetics_practice_models.dart';

final phoneticsRepositoryProvider = Provider<PhoneticsRepository>((ref) {
  return PhoneticsRepository();
});

final phoneticsControllerProvider =
    StateNotifierProvider<PhoneticsController, PhoneticsState>((ref) {
  final repository = ref.watch(phoneticsRepositoryProvider);
  return PhoneticsController(repository);
});

class PhoneticsState {
  final bool isLoading;
  final String? error;
  final PhoneticsSection section;
  final List<PhoneticModel> vowels;
  final List<PhoneticModel> consonants;
  final Map<String, List<PhoneticModel>> vowelGroups;
  final Map<String, List<PhoneticModel>> consonantGroups;
  final PhoneticModel? selectedItem;
  final List<PhoneticsExercise> exercises;
  final int currentExerciseIndex;
  final int score;
  final int answeredCount;
  final bool lastAnswerCorrect;
  final bool practiceCompleted;
  final bool answerSubmitted;
  final String? selectedOptionId;

  const PhoneticsState({
    this.isLoading = false,
    this.error,
    this.section = PhoneticsSection.vowels,
    this.vowels = const [],
    this.consonants = const [],
    this.vowelGroups = const {},
    this.consonantGroups = const {},
    this.selectedItem,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.score = 0,
    this.answeredCount = 0,
    this.lastAnswerCorrect = true,
    this.practiceCompleted = false,
    this.answerSubmitted = false,
    this.selectedOptionId,
  });

  PhoneticsState copyWith({
    bool? isLoading,
    String? error,
    PhoneticsSection? section,
    List<PhoneticModel>? vowels,
    List<PhoneticModel>? consonants,
    Map<String, List<PhoneticModel>>? vowelGroups,
    Map<String, List<PhoneticModel>>? consonantGroups,
    PhoneticModel? selectedItem,
    bool clearSelectedItem = false,
    List<PhoneticsExercise>? exercises,
    int? currentExerciseIndex,
    int? score,
    int? answeredCount,
    bool? lastAnswerCorrect,
    bool? practiceCompleted,
    bool? answerSubmitted,
    String? selectedOptionId,
    bool clearSelectedOptionId = false,
  }) {
    return PhoneticsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      section: section ?? this.section,
      vowels: vowels ?? this.vowels,
      consonants: consonants ?? this.consonants,
      vowelGroups: vowelGroups ?? this.vowelGroups,
      consonantGroups: consonantGroups ?? this.consonantGroups,
      selectedItem: clearSelectedItem ? null : (selectedItem ?? this.selectedItem),
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      score: score ?? this.score,
      answeredCount: answeredCount ?? this.answeredCount,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
      practiceCompleted: practiceCompleted ?? this.practiceCompleted,
      answerSubmitted: answerSubmitted ?? this.answerSubmitted,
      selectedOptionId: clearSelectedOptionId
          ? null
          : (selectedOptionId ?? this.selectedOptionId),
    );
  }

  double get progress {
    if (exercises.isEmpty) return 0;
    return answeredCount / exercises.length;
  }

  PhoneticsExercise? get currentExercise {
    if (currentExerciseIndex < 0 || currentExerciseIndex >= exercises.length) {
      return null;
    }
    return exercises[currentExerciseIndex];
  }

  double get accuracy {
    if (answeredCount == 0) return 0;
    return score / answeredCount;
  }
}

class PhoneticsController extends StateNotifier<PhoneticsState> {
  PhoneticsController(this._repository) : super(const PhoneticsState()) {
    load();
  }

  final PhoneticsRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vowels = await _repository.getVowels();
      final consonants = await _repository.getConsonants();
      final vowelGroups = await _repository.getVowelGroups();
      final consonantGroups = await _repository.getConsonantGroups();
      final exercises = await _repository.getPracticeExercises();
      state = state.copyWith(
        isLoading: false,
        vowels: vowels,
        consonants: consonants,
        vowelGroups: vowelGroups,
        consonantGroups: consonantGroups,
        exercises: exercises,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载发音内容失败：$e');
    }
  }

  void switchSection(PhoneticsSection section) {
    state = state.copyWith(section: section);
  }

  void selectItem(PhoneticModel item) {
    state = state.copyWith(selectedItem: item);
  }

  void clearSelection() {
    state = state.copyWith(clearSelectedItem: true);
  }

  void chooseOption(String optionId) {
    if (state.answerSubmitted) return;
    state = state.copyWith(selectedOptionId: optionId);
  }

  bool submitCurrentAnswer() {
    final exercise = state.currentExercise;
    final selected = state.selectedOptionId;
    if (exercise == null || selected == null || state.answerSubmitted) {
      return false;
    }

    final isCorrect = selected == exercise.correctAnswerId;
    state = state.copyWith(
      score: state.score + (isCorrect ? 1 : 0),
      answeredCount: state.answeredCount + 1,
      lastAnswerCorrect: isCorrect,
      practiceCompleted: state.currentExerciseIndex >= state.exercises.length - 1,
      answerSubmitted: true,
    );
    return isCorrect;
  }

  void nextExercise() {
    if (!state.answerSubmitted && !state.practiceCompleted) {
      return;
    }
    if (state.currentExerciseIndex >= state.exercises.length - 1) {
      state = state.copyWith(
        practiceCompleted: true,
        answerSubmitted: false,
        clearSelectedOptionId: true,
      );
      return;
    }
    state = state.copyWith(
      currentExerciseIndex: state.currentExerciseIndex + 1,
      answerSubmitted: false,
      clearSelectedOptionId: true,
    );
  }

  void restartPractice() {
    state = state.copyWith(
      currentExerciseIndex: 0,
      score: 0,
      answeredCount: 0,
      practiceCompleted: false,
      answerSubmitted: false,
      clearSelectedOptionId: true,
      lastAnswerCorrect: true,
    );
  }
}
