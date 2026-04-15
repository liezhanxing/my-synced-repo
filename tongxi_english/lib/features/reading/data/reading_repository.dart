import '../../../models/reading_model.dart';
import '../../../core/services/storage_service.dart';
import 'reading_local_data.dart';

/// Repository for reading passages
/// 
/// Handles data operations for reading comprehension materials,
/// including fetching from local data and caching.
class ReadingRepository {
  final StorageService _storageService;
  
  // Cache keys
  static const String _passagesCacheKey = 'cached_reading_passages';
  static const String _userProgressKey = 'reading_progress';
  static const String _completedPassagesKey = 'completed_reading_passages';
  
  ReadingRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Get all reading passages
  /// 
  /// Returns local data. In production, this would fetch from Firestore
  /// and fall back to local data when offline.
  Future<List<ReadingModel>> getAllPassages() async {
    try {
      // In production: Check cache first, then Firestore
      // For now, return local data
      final passages = ReadingLocalData.getAllPassages();
      
      // Cache the passages locally
      await _cachePassages(passages);
      
      return passages;
    } catch (e) {
      // If error, try to return cached data
      final cached = await _getCachedPassages();
      if (cached.isNotEmpty) {
        return cached;
      }
      // Fall back to local data
      return ReadingLocalData.getAllPassages();
    }
  }

  /// Get passages by difficulty level
  /// 
  /// [difficulty]: 1 = 高一 (Easy), 2 = 高二 (Medium), 3 = 高三 (Hard)
  Future<List<ReadingModel>> getPassagesByDifficulty(int difficulty) async {
    final allPassages = await getAllPassages();
    return allPassages.where((p) => p.difficulty == difficulty).toList();
  }

  /// Get passage by ID
  Future<ReadingModel?> getPassageById(String id) async {
    // Check local data first
    final localPassage = ReadingLocalData.getPassageById(id);
    if (localPassage != null) {
      return localPassage;
    }
    
    // In production: Check cache, then Firestore
    final cached = await _getCachedPassages();
    try {
      return cached.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get passages by category
  Future<List<ReadingModel>> getPassagesByCategory(ReadingCategory category) async {
    final allPassages = await getAllPassages();
    return allPassages.where((p) => p.category == category).toList();
  }

  /// Search passages by keyword
  Future<List<ReadingModel>> searchPassages(String keyword) async {
    final allPassages = await getAllPassages();
    final lowerKeyword = keyword.toLowerCase();
    
    return allPassages.where((p) {
      return p.title.toLowerCase().contains(lowerKeyword) ||
             p.content.toLowerCase().contains(lowerKeyword) ||
             p.tags.any((tag) => tag.toLowerCase().contains(lowerKeyword));
    }).toList();
  }

  /// Save reading progress for a passage
  Future<void> saveProgress(String passageId, {
    int? timeSpentSeconds,
    int? questionsAnswered,
    int? correctAnswers,
    bool isCompleted = false,
  }) async {
    final progressKey = '$_userProgressKey/$passageId';
    final existingProgress = await _storageService.getMap(progressKey) ?? {};
    
    final updatedProgress = {
      ...existingProgress,
      'passageId': passageId,
      'lastAccessed': DateTime.now().toIso8601String(),
      if (timeSpentSeconds != null)
        'timeSpentSeconds': (existingProgress['timeSpentSeconds'] ?? 0) + timeSpentSeconds,
      if (questionsAnswered != null)
        'questionsAnswered': questionsAnswered,
      if (correctAnswers != null)
        'correctAnswers': correctAnswers,
      if (isCompleted)
        'completedAt': DateTime.now().toIso8601String(),
      'isCompleted': isCompleted || (existingProgress['isCompleted'] ?? false),
    };
    
    await _storageService.setMap(progressKey, updatedProgress);
    
    // Track completed passages separately for easy access
    if (isCompleted) {
      await _addCompletedPassage(passageId);
    }
  }

  /// Get progress for a specific passage
  Future<Map<String, dynamic>?> getProgress(String passageId) async {
    final progressKey = '$_userProgressKey/$passageId';
    return await _storageService.getMap(progressKey);
  }

  /// Get all reading progress
  Future<Map<String, Map<String, dynamic>>> getAllProgress() async {
    final allKeys = await _storageService.getKeys();
    final progressKeys = allKeys.where((k) => k.startsWith(_userProgressKey));
    
    final Map<String, Map<String, dynamic>> allProgress = {};
    for (final key in progressKeys) {
      final passageId = key.replaceFirst('$_userProgressKey/', '');
      final progress = await _storageService.getMap(key);
      if (progress != null) {
        allProgress[passageId] = progress;
      }
    }
    
    return allProgress;
  }

  /// Get list of completed passage IDs
  Future<List<String>> getCompletedPassageIds() async {
    final completed = await _storageService.getStringList(_completedPassagesKey);
    return completed ?? [];
  }

  /// Get completion statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final allPassages = await getAllPassages();
    final completedIds = await getCompletedPassageIds();
    final allProgress = await getAllProgress();
    
    int totalTimeSpent = 0;
    int totalCorrectAnswers = 0;
    int totalQuestionsAnswered = 0;
    
    for (final progress in allProgress.values) {
      totalTimeSpent += (progress['timeSpentSeconds'] ?? 0) as int;
      totalCorrectAnswers += (progress['correctAnswers'] ?? 0) as int;
      totalQuestionsAnswered += (progress['questionsAnswered'] ?? 0) as int;
    }
    
    return {
      'totalPassages': allPassages.length,
      'completedPassages': completedIds.length,
      'completionPercentage': allPassages.isEmpty 
          ? 0 
          : (completedIds.length / allPassages.length * 100).round(),
      'totalTimeSpentMinutes': (totalTimeSpent / 60).round(),
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'accuracyPercentage': totalQuestionsAnswered == 0 
          ? 0 
          : (totalCorrectAnswers / totalQuestionsAnswered * 100).round(),
    };
  }

  /// Clear all reading progress (for testing/reset)
  Future<void> clearAllProgress() async {
    final allKeys = await _storageService.getKeys();
    final progressKeys = allKeys.where(
      (k) => k.startsWith(_userProgressKey) || k == _completedPassagesKey
    );
    
    for (final key in progressKeys) {
      await _storageService.remove(key);
    }
  }

  // ==================== Private Methods ====================

  Future<void> _cachePassages(List<ReadingModel> passages) async {
    final passagesJson = passages.map((p) => p.toJson()).toList();
    await _storageService.setMap(_passagesCacheKey, {
      'passages': passagesJson,
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<ReadingModel>> _getCachedPassages() async {
    final cached = await _storageService.getMap(_passagesCacheKey);
    if (cached == null || cached['passages'] == null) {
      return [];
    }
    
    final passagesList = cached['passages'] as List;
    return passagesList
        .map((json) => ReadingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> _addCompletedPassage(String passageId) async {
    final completed = await getCompletedPassageIds();
    if (!completed.contains(passageId)) {
      completed.add(passageId);
      await _storageService.setStringList(_completedPassagesKey, completed);
    }
  }
}

/// Provider for ReadingRepository
/// 
/// This would typically use Riverpod's Provider in the presentation layer
class ReadingRepositoryProvider {
  static final ReadingRepository _instance = ReadingRepository();
  static ReadingRepository get instance => _instance;
}
