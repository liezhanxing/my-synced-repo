import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'translation_local_data.dart';

/// Repository for translation exercises
/// 
/// Handles fetching exercises from local data with caching support
/// Future: Can be extended to fetch from Firestore
class TranslationRepository {
  static const String _cacheKeyPrefix = 'translation_exercise_';
  static const String _cacheTimestampKey = 'translation_cache_timestamp';
  static const Duration _cacheValidity = Duration(hours: 24);

  final SharedPreferences? _prefs;

  TranslationRepository([this._prefs]);

  /// Get all translation exercises
  Future<List<TranslationExercise>> getAllExercises() async {
    // For now, return local data directly
    // Future: Check cache, fetch from Firestore if needed
    return TranslationLocalData.getAllExercises();
  }

  /// Get exercises filtered by difficulty
  Future<List<TranslationExercise>> getExercisesByDifficulty(
    TranslationDifficulty difficulty,
  ) async {
    return TranslationLocalData.getExercisesByDifficulty(difficulty);
  }

  /// Get exercises filtered by direction (EN→CN or CN→EN)
  Future<List<TranslationExercise>> getExercisesByDirection(
    TranslationDirection direction,
  ) async {
    return TranslationLocalData.getExercisesByDirection(direction);
  }

  /// Get exercises with multiple filters
  Future<List<TranslationExercise>> getExercises({
    TranslationDifficulty? difficulty,
    TranslationDirection? direction,
  }) async {
    var exercises = TranslationLocalData.getAllExercises();

    if (difficulty != null) {
      exercises = exercises.where((e) => e.difficulty == difficulty).toList();
    }

    if (direction != null) {
      exercises = exercises.where((e) => e.direction == direction).toList();
    }

    return exercises;
  }

  /// Get daily challenge exercise
  Future<TranslationExercise> getDailyChallenge() async {
    return TranslationLocalData.getDailyChallenge();
  }

  /// Get a single exercise by ID
  Future<TranslationExercise?> getExerciseById(String id) async {
    final exercises = TranslationLocalData.getAllExercises();
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get random exercises for a practice session
  Future<List<TranslationExercise>> getRandomExercises({
    int count = 5,
    TranslationDifficulty? difficulty,
    TranslationDirection? direction,
  }) async {
    var exercises = await getExercises(
      difficulty: difficulty,
      direction: direction,
    );

    // Shuffle and take requested count
    exercises.shuffle();
    return exercises.take(count).toList();
  }

  /// Cache exercise result locally
  Future<void> cacheExerciseResult({
    required String exerciseId,
    required String userAnswer,
    required double score,
    required DateTime completedAt,
  }) async {
    if (_prefs == null) return;

    final key = '${_cacheKeyPrefix}result_$exerciseId';
    final data = {
      'exercise_id': exerciseId,
      'user_answer': userAnswer,
      'score': score,
      'completed_at': completedAt.toIso8601String(),
    };

    await _prefs!.setString(key, jsonEncode(data));
  }

  /// Get cached exercise result
  Future<Map<String, dynamic>?> getCachedResult(String exerciseId) async {
    if (_prefs == null) return null;

    final key = '${_cacheKeyPrefix}result_$exerciseId';
    final json = _prefs!.getString(key);
    if (json == null) return null;

    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Get all cached results
  Future<List<Map<String, dynamic>>> getAllCachedResults() async {
    if (_prefs == null) return [];

    final results = <Map<String, dynamic>>[];
    final keys = _prefs!.getKeys().where(
          (k) => k.startsWith('${_cacheKeyPrefix}result_'),
        );

    for (final key in keys) {
      final json = _prefs!.getString(key);
      if (json != null) {
        try {
          results.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (_) {
          // Skip invalid entries
        }
      }
    }

    return results;
  }

  /// Clear all cached results
  Future<void> clearCache() async {
    if (_prefs == null) return;

    final keys = _prefs!.getKeys().where(
          (k) => k.startsWith(_cacheKeyPrefix),
        );

    for (final key in keys) {
      await _prefs!.remove(key);
    }
  }

  /// Check if cache is valid
  bool _isCacheValid() {
    if (_prefs == null) return false;

    final timestamp = _prefs!.getInt(_cacheTimestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cachedTime) < _cacheValidity;
  }

  /// Update cache timestamp
  Future<void> _updateCacheTimestamp() async {
    if (_prefs == null) return;
    await _prefs!.setInt(
      _cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get exercise statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final results = await getAllCachedResults();
    
    if (results.isEmpty) {
      return {
        'total_attempted': 0,
        'average_score': 0.0,
        'completed_today': 0,
      };
    }

    final totalScore = results.fold<double>(
      0,
      (sum, r) => sum + ((r['score'] as num?)?.toDouble() ?? 0),
    );

    final today = DateTime.now();
    final completedToday = results.where((r) {
      final completedAt = DateTime.tryParse(r['completed_at'] as String? ?? '');
      if (completedAt == null) return false;
      return completedAt.year == today.year &&
          completedAt.month == today.month &&
          completedAt.day == today.day;
    }).length;

    return {
      'total_attempted': results.length,
      'average_score': totalScore / results.length,
      'completed_today': completedToday,
    };
  }
}
