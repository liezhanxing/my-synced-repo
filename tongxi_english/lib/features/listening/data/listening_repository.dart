import '../../../models/listening_model.dart';
import '../../../core/services/storage_service.dart';
import 'listening_local_data.dart';

/// Repository for listening exercises
/// 
/// Handles data operations for listening comprehension materials,
/// including fetching from local data and caching.
class ListeningRepository {
  final StorageService _storageService;
  
  // Cache keys
  static const String _exercisesCacheKey = 'cached_listening_exercises';
  static const String _userProgressKey = 'listening_progress';
  static const String _completedExercisesKey = 'completed_listening_exercises';
  static const String _dictationProgressKey = 'dictation_progress';
  
  ListeningRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Get all listening exercises
  /// 
  /// Returns local data. In production, this would fetch from Firestore
  /// and fall back to local data when offline.
  Future<List<ListeningModel>> getAllExercises() async {
    try {
      // In production: Check cache first, then Firestore
      // For now, return local data
      final exercises = ListeningLocalData.getAllExercises();
      
      // Cache the exercises locally
      await _cacheExercises(exercises);
      
      return exercises;
    } catch (e) {
      // If error, try to return cached data
      final cached = await _getCachedExercises();
      if (cached.isNotEmpty) {
        return cached;
      }
      // Fall back to local data
      return ListeningLocalData.getAllExercises();
    }
  }

  /// Get exercises by difficulty level
  /// 
  /// [difficulty]: 1 = 高一 (Easy), 2 = 高二 (Medium), 3 = 高三 (Hard)
  Future<List<ListeningModel>> getExercisesByDifficulty(int difficulty) async {
    final allExercises = await getAllExercises();
    return allExercises.where((e) => e.difficulty == difficulty).toList();
  }

  /// Get exercise by ID
  Future<ListeningModel?> getExerciseById(String id) async {
    // Check local data first
    final localExercise = ListeningLocalData.getExerciseById(id);
    if (localExercise != null) {
      return localExercise;
    }
    
    // In production: Check cache, then Firestore
    final cached = await _getCachedExercises();
    try {
      return cached.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get exercises by category
  Future<List<ListeningModel>> getExercisesByCategory(ListeningCategory category) async {
    final allExercises = await getAllExercises();
    return allExercises.where((e) => e.category == category).toList();
  }

  /// Search exercises by keyword
  Future<List<ListeningModel>> searchExercises(String keyword) async {
    final allExercises = await getAllExercises();
    final lowerKeyword = keyword.toLowerCase();
    
    return allExercises.where((e) {
      return e.title.toLowerCase().contains(lowerKeyword) ||
             e.transcript.toLowerCase().contains(lowerKeyword) ||
             e.tags.any((tag) => tag.toLowerCase().contains(lowerKeyword));
    }).toList();
  }

  /// Save listening progress for an exercise
  Future<void> saveProgress(String exerciseId, {
    int? listeningTimeSeconds,
    int? questionsAnswered,
    int? correctAnswers,
    bool isCompleted = false,
    double? playbackSpeed,
  }) async {
    final progressKey = '$_userProgressKey/$exerciseId';
    final existingProgress = await _storageService.getMap(progressKey) ?? {};
    
    final updatedProgress = {
      ...existingProgress,
      'exerciseId': exerciseId,
      'lastAccessed': DateTime.now().toIso8601String(),
      if (listeningTimeSeconds != null)
        'listeningTimeSeconds': (existingProgress['listeningTimeSeconds'] ?? 0) + listeningTimeSeconds,
      if (questionsAnswered != null)
        'questionsAnswered': questionsAnswered,
      if (correctAnswers != null)
        'correctAnswers': correctAnswers,
      if (playbackSpeed != null)
        'playbackSpeed': playbackSpeed,
      if (isCompleted)
        'completedAt': DateTime.now().toIso8601String(),
      'isCompleted': isCompleted || (existingProgress['isCompleted'] ?? false),
    };
    
    await _storageService.setMap(progressKey, updatedProgress);
    
    // Track completed exercises separately for easy access
    if (isCompleted) {
      await _addCompletedExercise(exerciseId);
    }
  }

  /// Save dictation progress
  Future<void> saveDictationProgress(
    String exerciseId, {
    required int segmentIndex,
    required String userAnswer,
    required bool isCorrect,
    double? accuracy,
  }) async {
    final key = '$_dictationProgressKey/$exerciseId';
    final existing = await _storageService.getMap(key) ?? {};
    final segments = Map<String, dynamic>.from(existing['segments'] ?? {});
    
    segments[segmentIndex.toString()] = {
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'accuracy': accuracy,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _storageService.setMap(key, {
      'exerciseId': exerciseId,
      'segments': segments,
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

  /// Get dictation progress for an exercise
  Future<Map<String, dynamic>?> getDictationProgress(String exerciseId) async {
    final key = '$_dictationProgressKey/$exerciseId';
    return await _storageService.getMap(key);
  }

  /// Get progress for a specific exercise
  Future<Map<String, dynamic>?> getProgress(String exerciseId) async {
    final progressKey = '$_userProgressKey/$exerciseId';
    return await _storageService.getMap(progressKey);
  }

  /// Get all listening progress
  Future<Map<String, Map<String, dynamic>>> getAllProgress() async {
    final allKeys = await _storageService.getKeys();
    final progressKeys = allKeys.where((k) => k.startsWith(_userProgressKey));
    
    final Map<String, Map<String, dynamic>> allProgress = {};
    for (final key in progressKeys) {
      final exerciseId = key.replaceFirst('$_userProgressKey/', '');
      final progress = await _storageService.getMap(key);
      if (progress != null) {
        allProgress[exerciseId] = progress;
      }
    }
    
    return allProgress;
  }

  /// Get list of completed exercise IDs
  Future<List<String>> getCompletedExerciseIds() async {
    final completed = await _storageService.getStringList(_completedExercisesKey);
    return completed ?? [];
  }

  /// Get completion statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final allExercises = await getAllExercises();
    final completedIds = await getCompletedExerciseIds();
    final allProgress = await getAllProgress();
    
    int totalListeningTime = 0;
    int totalCorrectAnswers = 0;
    int totalQuestionsAnswered = 0;
    
    for (final progress in allProgress.values) {
      totalListeningTime += (progress['listeningTimeSeconds'] ?? 0) as int;
      totalCorrectAnswers += (progress['correctAnswers'] ?? 0) as int;
      totalQuestionsAnswered += (progress['questionsAnswered'] ?? 0) as int;
    }
    
    return {
      'totalExercises': allExercises.length,
      'completedExercises': completedIds.length,
      'completionPercentage': allExercises.isEmpty 
          ? 0 
          : (completedIds.length / allExercises.length * 100).round(),
      'totalListeningTimeMinutes': (totalListeningTime / 60).round(),
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'accuracyPercentage': totalQuestionsAnswered == 0 
          ? 0 
          : (totalCorrectAnswers / totalQuestionsAnswered * 100).round(),
    };
  }

  /// Clear all listening progress (for testing/reset)
  Future<void> clearAllProgress() async {
    final allKeys = await _storageService.getKeys();
    final progressKeys = allKeys.where(
      (k) => k.startsWith(_userProgressKey) || 
             k.startsWith(_dictationProgressKey) ||
             k == _completedExercisesKey
    );
    
    for (final key in progressKeys) {
      await _storageService.remove(key);
    }
  }

  // ==================== Private Methods ====================

  Future<void> _cacheExercises(List<ListeningModel> exercises) async {
    final exercisesJson = exercises.map((e) => e.toJson()).toList();
    await _storageService.setMap(_exercisesCacheKey, {
      'exercises': exercisesJson,
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<ListeningModel>> _getCachedExercises() async {
    final cached = await _storageService.getMap(_exercisesCacheKey);
    if (cached == null || cached['exercises'] == null) {
      return [];
    }
    
    final exercisesList = cached['exercises'] as List;
    return exercisesList
        .map((json) => ListeningModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> _addCompletedExercise(String exerciseId) async {
    final completed = await getCompletedExerciseIds();
    if (!completed.contains(exerciseId)) {
      completed.add(exerciseId);
      await _storageService.setStringList(_completedExercisesKey, completed);
    }
  }
}

/// Provider for ListeningRepository
/// 
/// This would typically use Riverpod's Provider in the presentation layer
class ListeningRepositoryProvider {
  static final ListeningRepository _instance = ListeningRepository();
  static ListeningRepository get instance => _instance;
}
