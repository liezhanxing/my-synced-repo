import 'package:flutter/foundation.dart';

import '../../../models/grammar_model.dart';
import 'grammar_local_data.dart';

/// Repository for fetching grammar rules from Firestore with local caching
/// 
/// This repository provides:
/// - Fetching grammar rules from local data source
/// - Future Firestore integration for dynamic content
/// - Caching mechanism for offline support
class GrammarRepository {
  static final GrammarRepository _instance = GrammarRepository._internal();
  factory GrammarRepository() => _instance;
  GrammarRepository._internal();

  // Cache for grammar rules
  List<GrammarModel>? _cachedGrammar;
  Map<String, List<GrammarModel>>? _cachedCategorizedGrammar;
  DateTime? _lastFetchTime;
  
  // Cache duration: 1 hour
  static const Duration _cacheDuration = Duration(hours: 1);

  /// Check if cache is valid
  bool get _isCacheValid {
    if (_lastFetchTime == null || _cachedGrammar == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  /// Get all grammar rules
  /// 
  /// Returns grammar rules from cache if valid, otherwise fetches from local data
  Future<List<GrammarModel>> getAllGrammar({bool forceRefresh = false}) async {
    try {
      // Return cached data if valid and not forcing refresh
      if (!forceRefresh && _isCacheValid && _cachedGrammar != null) {
        if (kDebugMode) {
          print('GrammarRepository: Returning cached grammar');
        }
        return _cachedGrammar!;
      }

      // Fetch from local data source
      if (kDebugMode) {
        print('GrammarRepository: Fetching grammar from local data');
      }
      
      final grammar = GrammarLocalData.allGrammarRules;
      
      // Update cache
      _cachedGrammar = grammar;
      _lastFetchTime = DateTime.now();
      
      return grammar;
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error: $e');
      }
      // Return empty list on error
      return [];
    }
  }

  /// Get grammar rules by grade level
  /// 
  /// [grade] can be: 'grade10', 'grade11', 'grade12'
  Future<List<GrammarModel>> getGrammarByGrade(String grade) async {
    try {
      return GrammarLocalData.getGrammarByGrade(grade);
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error getting grade $grade: $e');
      }
      return [];
    }
  }

  /// Get all categorized grammar
  Future<Map<String, List<GrammarModel>>> getCategorizedGrammar() async {
    try {
      if (_cachedCategorizedGrammar != null) {
        return _cachedCategorizedGrammar!;
      }
      
      final categorized = GrammarLocalData.categorizedGrammar;
      _cachedCategorizedGrammar = categorized;
      return categorized;
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error: $e');
      }
      return {};
    }
  }

  /// Get a specific grammar rule by ID
  Future<GrammarModel?> getGrammarById(String id) async {
    try {
      return GrammarLocalData.getGrammarById(id);
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error getting grammar $id: $e');
      }
      return null;
    }
  }

  /// Get grammar rules by category
  Future<List<GrammarModel>> getGrammarByCategory(GrammarCategory category) async {
    try {
      return GrammarLocalData.getGrammarByCategory(category);
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error: $e');
      }
      return [];
    }
  }

  /// Search grammar rules by keyword
  /// 
  /// Searches in title, titleCn, explanation, and key points
  Future<List<GrammarModel>> searchGrammar(String query) async {
    try {
      if (query.isEmpty) return [];
      
      final allGrammar = await getAllGrammar();
      final lowerQuery = query.toLowerCase();
      
      return allGrammar.where((grammar) {
        return grammar.title.toLowerCase().contains(lowerQuery) ||
               grammar.titleCn.toLowerCase().contains(lowerQuery) ||
               grammar.explanation.toLowerCase().contains(lowerQuery) ||
               grammar.keyPoints.any((point) => 
                   point.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error searching: $e');
      }
      return [];
    }
  }

  /// Get grammar rules by difficulty level
  Future<List<GrammarModel>> getGrammarByDifficulty(int difficulty) async {
    try {
      final allGrammar = await getAllGrammar();
      return allGrammar.where((g) => g.difficulty == difficulty).toList();
    } catch (e) {
      if (kDebugMode) {
        print('GrammarRepository Error: $e');
      }
      return [];
    }
  }

  /// Get grade display names
  Map<String, String> getGradeNames() {
    return GrammarLocalData.gradeNames;
  }

  /// Clear cache
  void clearCache() {
    _cachedGrammar = null;
    _cachedCategorizedGrammar = null;
    _lastFetchTime = null;
    if (kDebugMode) {
      print('GrammarRepository: Cache cleared');
    }
  }

  /// Future: Fetch grammar from Firestore
  /// 
  /// This method will be implemented when Firestore integration is needed
  Future<List<GrammarModel>> fetchFromFirestore() async {
    // TODO: Implement Firestore fetching when needed
    // This would typically:
    // 1. Check network connectivity
    // 2. Fetch from Firestore 'grammar' collection
    // 3. Update local cache
    // 4. Return updated grammar rules
    
    if (kDebugMode) {
      print('GrammarRepository: Firestore fetch not yet implemented');
    }
    return getAllGrammar();
  }
}
