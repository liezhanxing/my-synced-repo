import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/grammar_model.dart';
import '../data/grammar_repository.dart';

/// Grammar state class
class GrammarState {
  final List<GrammarModel> grammarRules;
  final List<GrammarModel> filteredRules;
  final String selectedGrade;
  final GrammarModel? selectedTopic;
  final bool isLoading;
  final String? error;
  final Map<String, double> topicProgress;

  const GrammarState({
    this.grammarRules = const [],
    this.filteredRules = const [],
    this.selectedGrade = 'all',
    this.selectedTopic,
    this.isLoading = false,
    this.error,
    this.topicProgress = const {},
  });

  GrammarState copyWith({
    List<GrammarModel>? grammarRules,
    List<GrammarModel>? filteredRules,
    String? selectedGrade,
    GrammarModel? selectedTopic,
    bool? isLoading,
    String? error,
    Map<String, double>? topicProgress,
  }) {
    return GrammarState(
      grammarRules: grammarRules ?? this.grammarRules,
      filteredRules: filteredRules ?? this.filteredRules,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      topicProgress: topicProgress ?? this.topicProgress,
    );
  }
}

/// Riverpod StateNotifier for grammar state management
class GrammarController extends StateNotifier<GrammarState> {
  final GrammarRepository _repository;

  GrammarController({GrammarRepository? repository})
      : _repository = repository ?? GrammarRepository(),
        super(const GrammarState()) {
    loadGrammar();
  }

  /// Load all grammar rules
  Future<void> loadGrammar() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final grammar = await _repository.getAllGrammar();
      state = state.copyWith(
        grammarRules: grammar,
        filteredRules: grammar,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load grammar rules: $e',
      );
    }
  }

  /// Filter grammar by grade level
  void filterByGrade(String grade) {
    if (grade == 'all') {
      state = state.copyWith(
        selectedGrade: grade,
        filteredRules: state.grammarRules,
      );
      return;
    }

    final filtered = state.grammarRules.where((rule) {
      final gradeRanges = {
        'grade10': ['grammar_001', 'grammar_006'],
        'grade11': ['grammar_007', 'grammar_010'],
        'grade12': ['grammar_011', 'grammar_015'],
      };
      
      final range = gradeRanges[grade];
      if (range != null) {
        final idNum = int.tryParse(rule.id.split('_')[1]) ?? 0;
        final startNum = int.tryParse(range[0].split('_')[1]) ?? 0;
        final endNum = int.tryParse(range[1].split('_')[1]) ?? 0;
        return idNum >= startNum && idNum <= endNum;
      }
      return false;
    }).toList();

    state = state.copyWith(
      selectedGrade: grade,
      filteredRules: filtered,
    );
  }

  /// Select a topic for detailed view
  void selectTopic(GrammarModel? topic) {
    state = state.copyWith(selectedTopic: topic);
  }

  /// Search grammar rules
  void searchGrammar(String query) {
    if (query.isEmpty) {
      filterByGrade(state.selectedGrade);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = state.grammarRules.where((rule) {
      return rule.title.toLowerCase().contains(lowerQuery) ||
             rule.titleCn.toLowerCase().contains(lowerQuery) ||
             rule.explanation.toLowerCase().contains(lowerQuery) ||
             rule.keyPoints.any((point) => 
                 point.toLowerCase().contains(lowerQuery));
    }).toList();

    state = state.copyWith(filteredRules: filtered);
  }

  /// Get grade names
  Map<String, String> getGradeNames() {
    return {
      'all': '全部',
      'grade10': '高一',
      'grade11': '高二',
      'grade12': '高三',
    };
  }

  /// Get grammar rules by grade
  List<GrammarModel> getGrammarByGrade(String grade) {
    final gradeRules = <GrammarModel>[];
    final gradeRanges = {
      'grade10': [0, 5],
      'grade11': [6, 9],
      'grade12': [10, 14],
    };
    
    final range = gradeRanges[grade];
    if (range != null && state.grammarRules.isNotEmpty) {
      for (var i = range[0]; i <= range[1] && i < state.grammarRules.length; i++) {
        gradeRules.add(state.grammarRules[i]);
      }
    }
    return gradeRules;
  }

  /// Update topic progress
  void updateTopicProgress(String topicId, double progress) {
    final updatedProgress = Map<String, double>.from(state.topicProgress);
    updatedProgress[topicId] = progress;
    state = state.copyWith(topicProgress: updatedProgress);
  }

  /// Get progress for a topic
  double getTopicProgress(String topicId) {
    return state.topicProgress[topicId] ?? 0.0;
  }
}

/// Grammar controller provider
final grammarControllerProvider = StateNotifierProvider<GrammarController, GrammarState>((ref) {
  return GrammarController();
});

/// Selected grammar topic provider
final selectedGrammarTopicProvider = StateProvider<GrammarModel?>((ref) => null);

/// Grammar exercise session state
class GrammarExerciseState {
  final GrammarModel? currentTopic;
  final int currentQuestionIndex;
  final int score;
  final int totalQuestions;
  final bool isCompleted;
  final Map<int, bool> answers;
  final List<GrammarExerciseQuestion> questions;

  const GrammarExerciseState({
    this.currentTopic,
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.totalQuestions = 5,
    this.isCompleted = false,
    this.answers = const {},
    this.questions = const [],
  });

  GrammarExerciseState copyWith({
    GrammarModel? currentTopic,
    int? currentQuestionIndex,
    int? score,
    int? totalQuestions,
    bool? isCompleted,
    Map<int, bool>? answers,
    List<GrammarExerciseQuestion>? questions,
  }) {
    return GrammarExerciseState(
      currentTopic: currentTopic ?? this.currentTopic,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
      answers: answers ?? this.answers,
      questions: questions ?? this.questions,
    );
  }

  double get progress => totalQuestions > 0 ? currentQuestionIndex / totalQuestions : 0;
  double get accuracy => answers.isNotEmpty 
      ? answers.values.where((v) => v).length / answers.length 
      : 0;
  GrammarExerciseQuestion? get currentQuestion => 
      currentQuestionIndex < questions.length ? questions[currentQuestionIndex] : null;
}

/// Grammar exercise question model
class GrammarExerciseQuestion {
  final String id;
  final String type; // 'fill_blank', 'error_correction', 'reordering', 'multiple_choice'
  final String question;
  final String? sentence;
  final List<String>? options;
  final String correctAnswer;
  final String explanation;
  final String? hint;

  const GrammarExerciseQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.sentence,
    this.options,
    required this.correctAnswer,
    required this.explanation,
    this.hint,
  });
}

/// Grammar exercise controller
class GrammarExerciseController extends StateNotifier<GrammarExerciseState> {
  GrammarExerciseController() : super(const GrammarExerciseState());

  /// Start a new exercise session for a topic
  void startExercise(GrammarModel topic) {
    final questions = _generateQuestions(topic);
    state = GrammarExerciseState(
      currentTopic: topic,
      questions: questions,
      totalQuestions: questions.length,
    );
  }

  /// Generate questions based on grammar topic
  List<GrammarExerciseQuestion> _generateQuestions(GrammarModel topic) {
    final questions = <GrammarExerciseQuestion>[];
    
    // Generate fill in the blank questions from examples
    for (var i = 0; i < topic.examples.length && i < 2; i++) {
      final example = topic.examples[i];
      questions.add(GrammarExerciseQuestion(
        id: '${topic.id}_fill_$i',
        type: 'fill_blank',
        question: '选择正确的形式填空：',
        sentence: example.correct,
        options: _generateFillOptions(example.correct, topic),
        correctAnswer: example.correct,
        explanation: example.explanation,
      ));
    }
    
    // Generate error correction from common mistakes
    for (var i = 0; i < topic.commonMistakes.length && i < 2; i++) {
      final mistake = topic.commonMistakes[i];
      final parts = mistake.split('→');
      if (parts.length == 2) {
        final incorrect = parts[0].trim().replaceAll('❌ ', '');
        final correct = parts[1].trim().replaceAll('✅ ', '');
        questions.add(GrammarExerciseQuestion(
          id: '${topic.id}_error_$i',
          type: 'error_correction',
          question: '找出并改正句中的语法错误：',
          sentence: incorrect,
          correctAnswer: correct,
          explanation: '根据${topic.titleCn}的规则，正确形式应该是：$correct',
        ));
      }
    }
    
    // Add a multiple choice question from key points
    if (topic.keyPoints.isNotEmpty) {
      questions.add(GrammarExerciseQuestion(
        id: '${topic.id}_mc_0',
        type: 'multiple_choice',
        question: '关于${topic.titleCn}，以下哪项是正确的？',
        options: [
          topic.keyPoints[0],
          '这是一个干扰选项',
          '这是另一个干扰选项',
          '这是第三个干扰选项',
        ]..shuffle(),
        correctAnswer: topic.keyPoints[0],
        explanation: topic.explanation.substring(0, topic.explanation.length > 100 ? 100 : topic.explanation.length),
      ));
    }
    
    return questions;
  }

  List<String> _generateFillOptions(String correct, GrammarModel topic) {
    // Generate distractors based on the topic
    final distractors = [
      correct.replaceAll('is', 'are').replaceAll('was', 'were'),
      correct.replaceAll('have', 'has').replaceAll('has', 'have'),
      correct.replaceAll('do', 'does').replaceAll('does', 'do'),
    ];
    
    final options = [correct, ...distractors.take(3)];
    options.shuffle();
    return options;
  }

  /// Submit answer for current question
  void submitAnswer(bool isCorrect) {
    final updatedAnswers = Map<int, bool>.from(state.answers);
    updatedAnswers[state.currentQuestionIndex] = isCorrect;

    final newScore = isCorrect ? state.score + 1 : state.score;
    final newIndex = state.currentQuestionIndex + 1;
    final isCompleted = newIndex >= state.totalQuestions;

    state = state.copyWith(
      currentQuestionIndex: newIndex,
      score: newScore,
      answers: updatedAnswers,
      isCompleted: isCompleted,
    );
  }

  /// Skip current question
  void skipQuestion() {
    final updatedAnswers = Map<int, bool>.from(state.answers);
    updatedAnswers[state.currentQuestionIndex] = false;

    final newIndex = state.currentQuestionIndex + 1;
    final isCompleted = newIndex >= state.totalQuestions;

    state = state.copyWith(
      currentQuestionIndex: newIndex,
      answers: updatedAnswers,
      isCompleted: isCompleted,
    );
  }

  /// Reset exercise
  void resetExercise() {
    state = const GrammarExerciseState();
  }

  /// Go to next question
  void nextQuestion() {
    if (state.currentQuestionIndex < state.totalQuestions - 1) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  /// Go to previous question
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }
}

/// Grammar exercise controller provider
final grammarExerciseControllerProvider = StateNotifierProvider<GrammarExerciseController, GrammarExerciseState>((ref) {
  return GrammarExerciseController();
});
