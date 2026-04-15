import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/tts_service.dart';
import '../../../models/listening_model.dart';
import '../data/listening_repository.dart';

// ==================== Providers ====================

/// Listening repository provider
final listeningRepositoryProvider = Provider<ListeningRepository>((ref) {
  return ListeningRepository();
});

/// All exercises provider
final allExercisesProvider = FutureProvider<List<ListeningModel>>((ref) async {
  final repository = ref.watch(listeningRepositoryProvider);
  return await repository.getAllExercises();
});

/// Exercises by difficulty provider
final exercisesByDifficultyProvider = FutureProvider.family<List<ListeningModel>, int>((ref, difficulty) async {
  final repository = ref.watch(listeningRepositoryProvider);
  return await repository.getExercisesByDifficulty(difficulty);
});

/// Listening statistics provider
final listeningStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(listeningRepositoryProvider);
  return await repository.getStatistics();
});

/// Selected exercise provider
final selectedExerciseProvider = StateProvider<ListeningModel?>((ref) => null);

/// Listening filter provider
final listeningFilterProvider = StateProvider<ListeningFilter>((ref) {
  return const ListeningFilter();
});

/// Filtered exercises provider
final filteredExercisesProvider = Provider<AsyncValue<List<ListeningModel>>>((ref) {
  final allExercisesAsync = ref.watch(allExercisesProvider);
  final filter = ref.watch(listeningFilterProvider);
  
  return allExercisesAsync.when(
    data: (exercises) {
      var filtered = exercises;
      
      // Filter by difficulty
      if (filter.difficulty != null) {
        filtered = filtered.where((e) => e.difficulty == filter.difficulty).toList();
      }
      
      // Filter by category
      if (filter.category != null) {
        filtered = filtered.where((e) => e.category == filter.category).toList();
      }
      
      // Filter by search query
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        filtered = filtered.where((e) {
          return e.title.toLowerCase().contains(query) ||
                 e.transcript.toLowerCase().contains(query) ||
                 e.tags.any((tag) => tag.toLowerCase().contains(query));
        }).toList();
      }
      
      // Sort
      switch (filter.sortBy) {
        case ListeningSortBy.difficultyAsc:
          filtered.sort((a, b) => a.difficulty.compareTo(b.difficulty));
          break;
        case ListeningSortBy.difficultyDesc:
          filtered.sort((a, b) => b.difficulty.compareTo(a.difficulty));
          break;
        case ListeningSortBy.durationAsc:
          filtered.sort((a, b) => a.duration.compareTo(b.duration));
          break;
        case ListeningSortBy.durationDesc:
          filtered.sort((a, b) => b.duration.compareTo(a.duration));
          break;
        case ListeningSortBy.title:
          filtered.sort((a, b) => a.title.compareTo(b.title));
          break;
        case ListeningSortBy.none:
        default:
          break;
      }
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

/// Listening controller provider
final listeningControllerProvider = StateNotifierProvider<ListeningController, ListeningState>((ref) {
  final repository = ref.watch(listeningRepositoryProvider);
  final ttsService = TtsService();
  return ListeningController(repository: repository, ttsService: ttsService);
});

// ==================== Filter Model ====================

class ListeningFilter {
  final int? difficulty;
  final ListeningCategory? category;
  final String? searchQuery;
  final ListeningSortBy sortBy;

  const ListeningFilter({
    this.difficulty,
    this.category,
    this.searchQuery,
    this.sortBy = ListeningSortBy.none,
  });

  ListeningFilter copyWith({
    int? difficulty,
    ListeningCategory? category,
    String? searchQuery,
    ListeningSortBy? sortBy,
    bool clearDifficulty = false,
    bool clearCategory = false,
    bool clearSearch = false,
  }) {
    return ListeningFilter(
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      category: clearCategory ? null : (category ?? this.category),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum ListeningSortBy {
  none,
  difficultyAsc,
  difficultyDesc,
  durationAsc,
  durationDesc,
  title,
}

// ==================== State ====================

class ListeningState {
  final ListeningModel? selectedExercise;
  final bool isLoading;
  final String? error;
  
  // Audio playback state
  final bool isPlaying;
  final bool isPaused;
  final double playbackSpeed;
  final int currentPositionSeconds;
  final int totalDurationSeconds;
  final bool showTranscript;
  
  // Dictation state
  final bool isInDictationMode;
  final int currentDictationSegment;
  final Map<int, String> dictationAnswers; // segmentIndex -> userAnswer
  final Map<int, double> dictationAccuracy; // segmentIndex -> accuracy
  final bool showDictationResults;
  
  // Question state
  final bool isAnsweringQuestions;
  final int currentQuestionIndex;
  final Map<String, int> userAnswers; // questionId -> selectedOption
  final bool showResults;
  
  // Progress
  final bool isSavingProgress;

  const ListeningState({
    this.selectedExercise,
    this.isLoading = false,
    this.error,
    this.isPlaying = false,
    this.isPaused = false,
    this.playbackSpeed = 1.0,
    this.currentPositionSeconds = 0,
    this.totalDurationSeconds = 0,
    this.showTranscript = false,
    this.isInDictationMode = false,
    this.currentDictationSegment = 0,
    this.dictationAnswers = const {},
    this.dictationAccuracy = const {},
    this.showDictationResults = false,
    this.isAnsweringQuestions = false,
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.showResults = false,
    this.isSavingProgress = false,
  });

  ListeningState copyWith({
    ListeningModel? selectedExercise,
    bool? isLoading,
    String? error,
    bool? isPlaying,
    bool? isPaused,
    double? playbackSpeed,
    int? currentPositionSeconds,
    int? totalDurationSeconds,
    bool? showTranscript,
    bool? isInDictationMode,
    int? currentDictationSegment,
    Map<int, String>? dictationAnswers,
    Map<int, double>? dictationAccuracy,
    bool? showDictationResults,
    bool? isAnsweringQuestions,
    int? currentQuestionIndex,
    Map<String, int>? userAnswers,
    bool? showResults,
    bool? isSavingProgress,
    bool clearError = false,
    bool clearSelectedExercise = false,
  }) {
    return ListeningState(
      selectedExercise: clearSelectedExercise ? null : (selectedExercise ?? this.selectedExercise),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      currentPositionSeconds: currentPositionSeconds ?? this.currentPositionSeconds,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      showTranscript: showTranscript ?? this.showTranscript,
      isInDictationMode: isInDictationMode ?? this.isInDictationMode,
      currentDictationSegment: currentDictationSegment ?? this.currentDictationSegment,
      dictationAnswers: dictationAnswers ?? this.dictationAnswers,
      dictationAccuracy: dictationAccuracy ?? this.dictationAccuracy,
      showDictationResults: showDictationResults ?? this.showDictationResults,
      isAnsweringQuestions: isAnsweringQuestions ?? this.isAnsweringQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      showResults: showResults ?? this.showResults,
      isSavingProgress: isSavingProgress ?? this.isSavingProgress,
    );
  }

  // Computed properties
  double get progressPercentage {
    if (totalDurationSeconds == 0) return 0;
    return (currentPositionSeconds / totalDurationSeconds).clamp(0.0, 1.0);
  }

  String get formattedCurrentTime {
    final minutes = currentPositionSeconds ~/ 60;
    final seconds = currentPositionSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedTotalTime {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get correctAnswersCount {
    if (selectedExercise == null) return 0;
    int count = 0;
    for (final question in selectedExercise!.questions) {
      if (userAnswers[question.id] == question.correctAnswer) {
        count++;
      }
    }
    return count;
  }

  double get scorePercentage {
    if (selectedExercise == null || selectedExercise!.questions.isEmpty) return 0;
    return (correctAnswersCount / selectedExercise!.questions.length) * 100;
  }

  bool get isPassing {
    return scorePercentage >= 60;
  }

  bool get allQuestionsAnswered {
    if (selectedExercise == null) return false;
    return userAnswers.length == selectedExercise!.questions.length;
  }

  double get averageDictationAccuracy {
    if (dictationAccuracy.isEmpty) return 0;
    final total = dictationAccuracy.values.reduce((a, b) => a + b);
    return total / dictationAccuracy.length;
  }
}

// ==================== Controller ====================

class ListeningController extends StateNotifier<ListeningState> {
  final ListeningRepository _repository;
  final TtsService _ttsService;
  Timer? _progressTimer;

  ListeningController({
    required ListeningRepository repository,
    required TtsService ttsService,
  })  : _repository = repository,
        _ttsService = ttsService,
        super(const ListeningState());

  @override
  void dispose() {
    _progressTimer?.cancel();
    _ttsService.dispose();
    super.dispose();
  }

  // ==================== Exercise Selection ====================

  void selectExercise(ListeningModel exercise) {
    state = state.copyWith(
      selectedExercise: exercise,
      isPlaying: false,
      isPaused: false,
      currentPositionSeconds: 0,
      totalDurationSeconds: exercise.duration,
      showTranscript: false,
      isInDictationMode: false,
      isAnsweringQuestions: false,
      showResults: false,
      clearError: true,
    );
  }

  void clearSelectedExercise() {
    _stopPlayback();
    state = state.copyWith(
      clearSelectedExercise: true,
      isPlaying: false,
      isPaused: false,
      currentPositionSeconds: 0,
      totalDurationSeconds: 0,
      isInDictationMode: false,
      isAnsweringQuestions: false,
      showResults: false,
    );
  }

  // ==================== Audio Playback ====================

  Future<void> play() async {
    if (state.selectedExercise == null) return;
    
    // Use TTS to simulate audio playback
    await _ttsService.setSpeechRate(_speedToTtsRate(state.playbackSpeed));
    
    // Start progress simulation
    state = state.copyWith(isPlaying: true, isPaused: false);
    _startProgressTimer();
    
    // Speak the transcript (simulating audio)
    await _ttsService.speak(state.selectedExercise!.transcript);
  }

  Future<void> pause() async {
    await _ttsService.pause();
    _progressTimer?.cancel();
    state = state.copyWith(isPlaying: false, isPaused: true);
  }

  Future<void> resume() async {
    state = state.copyWith(isPlaying: true, isPaused: false);
    _startProgressTimer();
    // TTS doesn't support true resume, so we'd need more complex handling
    // For now, we continue the progress timer
  }

  Future<void> stop() async {
    await _ttsService.stop();
    _stopPlayback();
  }

  void _stopPlayback() {
    _progressTimer?.cancel();
    state = state.copyWith(
      isPlaying: false,
      isPaused: false,
      currentPositionSeconds: 0,
    );
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.currentPositionSeconds < state.totalDurationSeconds) {
        state = state.copyWith(
          currentPositionSeconds: state.currentPositionSeconds + 1,
        );
      } else {
        // Playback finished
        _progressTimer?.cancel();
        state = state.copyWith(isPlaying: false, isPaused: false);
      }
    });
  }

  void seekTo(int seconds) {
    final clampedSeconds = seconds.clamp(0, state.totalDurationSeconds);
    state = state.copyWith(currentPositionSeconds: clampedSeconds);
  }

  // ==================== Playback Speed ====================

  void setPlaybackSpeed(double speed) {
    // Valid speeds: 0.5, 0.75, 1.0, 1.25, 1.5
    final validSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5];
    final closestSpeed = validSpeeds.reduce(
      (a, b) => (a - speed).abs() < (b - speed).abs() ? a : b,
    );
    
    state = state.copyWith(playbackSpeed: closestSpeed);
    
    // Update TTS rate if currently playing
    if (state.isPlaying) {
      _ttsService.setSpeechRate(_speedToTtsRate(closestSpeed));
    }
  }

  double _speedToTtsRate(double speed) {
    // TTS rate is 0.0 to 1.0, where 0.5 is normal
    // Map our speeds: 0.5->0.25, 0.75->0.375, 1.0->0.5, 1.25->0.625, 1.5->0.75
    return (speed * 0.5).clamp(0.0, 1.0);
  }

  // ==================== Transcript ====================

  void toggleTranscript() {
    state = state.copyWith(showTranscript: !state.showTranscript);
  }

  void showTranscript() {
    state = state.copyWith(showTranscript: true);
  }

  void hideTranscript() {
    state = state.copyWith(showTranscript: false);
  }

  // ==================== Dictation Mode ====================

  void startDictation() {
    _stopPlayback();
    state = state.copyWith(
      isInDictationMode: true,
      currentDictationSegment: 0,
      dictationAnswers: {},
      dictationAccuracy: {},
      showDictationResults: false,
    );
  }

  void exitDictation() {
    state = state.copyWith(
      isInDictationMode: false,
      currentDictationSegment: 0,
      showDictationResults: false,
    );
  }

  void submitDictationAnswer(String answer) {
    final newAnswers = Map<int, String>.from(state.dictationAnswers);
    newAnswers[state.currentDictationSegment] = answer;
    state = state.copyWith(dictationAnswers: newAnswers);
  }

  void nextDictationSegment() {
    if (state.selectedExercise == null) return;
    
    // Get transcript segments (split by sentences or paragraphs)
    final segments = _getTranscriptSegments(state.selectedExercise!.transcript);
    
    if (state.currentDictationSegment < segments.length - 1) {
      state = state.copyWith(currentDictationSegment: state.currentDictationSegment + 1);
    }
  }

  void previousDictationSegment() {
    if (state.currentDictationSegment > 0) {
      state = state.copyWith(currentDictationSegment: state.currentDictationSegment - 1);
    }
  }

  void calculateDictationAccuracy(int segmentIndex, String correctText) {
    final userAnswer = state.dictationAnswers[segmentIndex] ?? '';
    final accuracy = _calculateTextAccuracy(userAnswer, correctText);
    
    final newAccuracy = Map<int, double>.from(state.dictationAccuracy);
    newAccuracy[segmentIndex] = accuracy;
    
    state = state.copyWith(dictationAccuracy: newAccuracy);
  }

  void finishDictation() {
    state = state.copyWith(showDictationResults: true);
    _saveProgress();
  }

  void restartDictation() {
    state = state.copyWith(
      currentDictationSegment: 0,
      dictationAnswers: {},
      dictationAccuracy: {},
      showDictationResults: false,
    );
  }

  List<String> _getTranscriptSegments(String transcript) {
    // Split transcript into manageable segments (sentences or short paragraphs)
    // For simplicity, split by double newlines or periods followed by space
    final segments = transcript
        .split(RegExp(r'\n\n|\.\s+(?=[A-Z])'))
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    
    return segments.isEmpty ? [transcript] : segments;
  }

  double _calculateTextAccuracy(String userText, String correctText) {
    final userWords = userText.toLowerCase().trim().split(RegExp(r'\s+'));
    final correctWords = correctText.toLowerCase().trim().split(RegExp(r'\s+'));
    
    if (correctWords.isEmpty) return 0;
    
    int correctCount = 0;
    for (int i = 0; i < userWords.length && i < correctWords.length; i++) {
      if (userWords[i] == correctWords[i]) {
        correctCount++;
      }
    }
    
    return (correctCount / correctWords.length) * 100;
  }

  // ==================== Questions ====================

  void startAnsweringQuestions() {
    _stopPlayback();
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
    if (state.selectedExercise == null) return;
    if (state.currentQuestionIndex < state.selectedExercise!.questions.length - 1) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }

  void goToQuestion(int index) {
    if (state.selectedExercise == null) return;
    if (index >= 0 && index < state.selectedExercise!.questions.length) {
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
    if (state.selectedExercise == null) return;
    
    state = state.copyWith(isSavingProgress: true);
    
    try {
      await _repository.saveProgress(
        state.selectedExercise!.id,
        listeningTimeSeconds: state.currentPositionSeconds,
        questionsAnswered: state.userAnswers.length,
        correctAnswers: state.correctAnswersCount,
        isCompleted: state.allQuestionsAnswered,
        playbackSpeed: state.playbackSpeed,
      );
    } catch (e) {
      // Silently handle error
    } finally {
      state = state.copyWith(isSavingProgress: false);
    }
  }

  Future<void> saveListeningProgress() async {
    await _saveProgress();
  }

  // ==================== Utility ====================

  String get difficultyLabel {
    switch (state.selectedExercise?.difficulty) {
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
    switch (state.selectedExercise?.category) {
      case ListeningCategory.dialogue:
        return '对话';
      case ListeningCategory.news:
        return '新闻';
      case ListeningCategory.lecture:
        return '讲座';
      case ListeningCategory.interview:
        return '采访';
      case ListeningCategory.announcement:
        return '公告';
      case ListeningCategory.story:
        return '故事';
      case ListeningCategory.conversation:
        return '交谈';
      default:
        return '';
    }
  }

  List<String> get dictationSegments {
    if (state.selectedExercise == null) return [];
    return _getTranscriptSegments(state.selectedExercise!.transcript);
  }
}

// ==================== Extension Methods ====================

extension ListeningCategoryExtension on ListeningCategory {
  String get label {
    switch (this) {
      case ListeningCategory.dialogue:
        return '对话';
      case ListeningCategory.news:
        return '新闻';
      case ListeningCategory.lecture:
        return '讲座';
      case ListeningCategory.interview:
        return '采访';
      case ListeningCategory.announcement:
        return '公告';
      case ListeningCategory.story:
        return '故事';
      case ListeningCategory.conversation:
        return '交谈';
    }
  }

  String get icon {
    switch (this) {
      case ListeningCategory.dialogue:
        return '💬';
      case ListeningCategory.news:
        return '📰';
      case ListeningCategory.lecture:
        return '🎓';
      case ListeningCategory.interview:
        return '🎙️';
      case ListeningCategory.announcement:
        return '📢';
      case ListeningCategory.story:
        return '📖';
      case ListeningCategory.conversation:
        return '🗣️';
    }
  }
}
