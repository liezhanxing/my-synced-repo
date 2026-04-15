import 'package:flutter/foundation.dart';

import '../../../models/phrase_model.dart';
import 'phrases_local_data.dart';

/// Repository for fetching phrases from Firestore with local caching
/// 
/// This repository provides:
/// - Fetching phrases from local data source
/// - Future Firestore integration for dynamic content
/// - Caching mechanism for offline support
class PhrasesRepository {
  static final PhrasesRepository _instance = PhrasesRepository._internal();
  factory PhrasesRepository() => _instance;
  PhrasesRepository._internal();

  // Cache for phrases
  List<PhraseModel>? _cachedPhrases;
  Map<String, List<PhraseModel>>? _cachedCategorizedPhrases;
  DateTime? _lastFetchTime;
  
  // Cache duration: 1 hour
  static const Duration _cacheDuration = Duration(hours: 1);

  /// Check if cache is valid
  bool get _isCacheValid {
    if (_lastFetchTime == null || _cachedPhrases == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  /// Get all phrases
  /// 
  /// Returns phrases from cache if valid, otherwise fetches from local data
  Future<List<PhraseModel>> getAllPhrases({bool forceRefresh = false}) async {
    try {
      // Return cached data if valid and not forcing refresh
      if (!forceRefresh && _isCacheValid && _cachedPhrases != null) {
        if (kDebugMode) {
          print('PhrasesRepository: Returning cached phrases');
        }
        return _cachedPhrases!;
      }

      // Fetch from local data source
      if (kDebugMode) {
        print('PhrasesRepository: Fetching phrases from local data');
      }
      
      final phrases = PhrasesLocalData.allPhrases;
      
      // Update cache
      _cachedPhrases = phrases;
      _lastFetchTime = DateTime.now();
      
      return phrases;
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error: $e');
      }
      // Return empty list on error
      return [];
    }
  }

  /// Get phrases by category
  /// 
  /// [category] can be: 'daily', 'academic', 'travel', 'emotions', 'collocations'
  Future<List<PhraseModel>> getPhrasesByCategory(String category) async {
    try {
      return PhrasesLocalData.getPhrasesByCategory(category);
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error getting category $category: $e');
      }
      return [];
    }
  }

  /// Get all categorized phrases
  Future<Map<String, List<PhraseModel>>> getCategorizedPhrases() async {
    try {
      if (_cachedCategorizedPhrases != null) {
        return _cachedCategorizedPhrases!;
      }
      
      final categorized = PhrasesLocalData.categorizedPhrases;
      _cachedCategorizedPhrases = categorized;
      return categorized;
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error: $e');
      }
      return {};
    }
  }

  /// Get a specific phrase by ID
  Future<PhraseModel?> getPhraseById(String id) async {
    try {
      return PhrasesLocalData.getPhraseById(id);
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error getting phrase $id: $e');
      }
      return null;
    }
  }

  /// Get random phrases for practice
  /// 
  /// [count] number of phrases to return
  Future<List<PhraseModel>> getRandomPhrases(int count) async {
    try {
      return PhrasesLocalData.getRandomPhrases(count);
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error getting random phrases: $e');
      }
      return [];
    }
  }

  /// Search phrases by keyword
  /// 
  /// Searches in phrase text, translation, and meaning
  Future<List<PhraseModel>> searchPhrases(String query) async {
    try {
      if (query.isEmpty) return [];
      
      final allPhrases = await getAllPhrases();
      final lowerQuery = query.toLowerCase();
      
      return allPhrases.where((phrase) {
        return phrase.phrase.toLowerCase().contains(lowerQuery) ||
               phrase.translation.toLowerCase().contains(lowerQuery) ||
               phrase.meaning.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error searching: $e');
      }
      return [];
    }
  }

  /// Get phrases by difficulty level
  Future<List<PhraseModel>> getPhrasesByDifficulty(int difficulty) async {
    try {
      final allPhrases = await getAllPhrases();
      return allPhrases.where((p) => p.difficulty == difficulty).toList();
    } catch (e) {
      if (kDebugMode) {
        print('PhrasesRepository Error: $e');
      }
      return [];
    }
  }

  /// Get category display names
  Map<String, String> getCategoryNames() {
    return PhrasesLocalData.categoryNames;
  }

  /// Clear cache
  void clearCache() {
    _cachedPhrases = null;
    _cachedCategorizedPhrases = null;
    _lastFetchTime = null;
    if (kDebugMode) {
      print('PhrasesRepository: Cache cleared');
    }
  }

  /// Future: Fetch phrases from Firestore
  /// 
  /// This method will be implemented when Firestore integration is needed
  Future<List<PhraseModel>> fetchFromFirestore() async {
    // TODO: Implement Firestore fetching when needed
    // This would typically:
    // 1. Check network connectivity
    // 2. Fetch from Firestore 'phrases' collection
    // 3. Update local cache
    // 4. Return updated phrases
    
    if (kDebugMode) {
      print('PhrasesRepository: Firestore fetch not yet implemented');
    }
    return getAllPhrases();
  }
}
