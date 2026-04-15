import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/sm2_algorithm.dart';
import '../../../models/word_model.dart';
import '../domain/review_state.dart';
import '../domain/vocabulary_models.dart';
import 'vocabulary_local_data.dart';

class VocabularyRepository {
  VocabularyRepository({Box<dynamic>? progressBox})
      : _progressBox = progressBox ?? Hive.box('progressBox');

  final Box<dynamic> _progressBox;
  final Random _random = Random();

  static const String _cacheKey = 'vocabulary_words_cache_v1';
  static const String _cacheTimeKey = 'vocabulary_words_cache_time_v1';
  static const String _reviewKey = 'vocabulary_review_states_v1';
  static const Duration _cacheDuration = Duration(hours: 12);

  List<WordModel>? _memoryWords;

  Future<List<WordModel>> getAllWords({bool forceRefresh = false}) async {
    if (!forceRefresh && _memoryWords != null) return _memoryWords!;

    try {
      if (!forceRefresh && _isCacheValid()) {
        final raw = _progressBox.get(_cacheKey);
        if (raw is List) {
          final words = raw
              .whereType<Map>()
              .map((e) => WordModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          if (words.isNotEmpty) {
            _memoryWords = words;
            return words;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('读取单词缓存失败: $e');
      }
    }

    final words = VocabularyLocalData.allWords;
    _memoryWords = words;
    await _saveCache(words);
    return words;
  }

  Future<Map<String, List<WordModel>>> getGroupedWords() async {
    final words = await getAllWords();
    final grouped = <String, List<WordModel>>{};
    for (final unit in VocabularyLocalData.units) {
      grouped[unit] = words.where((word) => word.tags.contains(unit)).toList();
    }
    return grouped;
  }

  Future<List<WordModel>> getWordsByUnit(String unit) async {
    final words = await getAllWords();
    return words.where((word) => word.tags.contains(unit)).toList();
  }

  Future<Map<String, ReviewState>> getReviewStates() async {
    final raw = _progressBox.get(_reviewKey);
    if (raw is! Map) return {};
    return raw.map(
      (key, value) => MapEntry(
        key.toString(),
        ReviewState.fromJson(Map<String, dynamic>.from(value as Map)),
      ),
    );
  }

  Future<ReviewState> getReviewState(String wordId) async {
    final states = await getReviewStates();
    return states[wordId] ?? ReviewState.initial(wordId);
  }

  Future<void> updateReviewState(String wordId, int quality) async {
    final current = await getReviewState(wordId);
    final result = Sm2Algorithm.calculate(
      quality: quality,
      previousInterval: current.interval,
      previousEaseFactor: current.easeFactor,
      previousRepetitions: current.repetitions,
    );
    final updated = current.copyWith(
      interval: result.nextInterval,
      easeFactor: result.nextEaseFactor,
      repetitions: result.nextRepetitions,
      nextReviewDate: result.nextReviewDate,
      lastQuality: quality,
    );
    final states = await getReviewStates();
    states[wordId] = updated;
    await _progressBox.put(
      _reviewKey,
      states.map((key, value) => MapEntry(key, value.toJson())),
    );
  }

  Future<List<WordModel>> getDueWords() async {
    final words = await getAllWords();
    final states = await getReviewStates();
    return words.where((word) {
      final state = states[word.id];
      if (state == null) return true;
      return Sm2Algorithm.isDueForReview(state.nextReviewDate);
    }).toList();
  }

  Future<List<VocabularyQuizQuestion>> buildQuizQuestions({int count = 12}) async {
    final words = List<WordModel>.from(await getAllWords())..shuffle();
    final selected = words.take(count.clamp(1, words.length)).toList();
    final allWords = await getAllWords();
    final questions = <VocabularyQuizQuestion>[];

    for (var index = 0; index < selected.length; index++) {
      final word = selected[index];
      final type = VocabularyQuizType.values[index % VocabularyQuizType.values.length];
      switch (type) {
        case VocabularyQuizType.englishToChinese:
          questions.add(
            VocabularyQuizQuestion(
              id: 'eq_$index',
              type: type,
              prompt: '选择 ${word.word} 的中文意思',
              correctAnswer: word.translation,
              options: _buildOptions(
                correct: word.translation,
                pool: allWords.map((e) => e.translation).toList(),
              ),
              relatedWordId: word.id,
            ),
          );
          break;
        case VocabularyQuizType.chineseToEnglish:
          questions.add(
            VocabularyQuizQuestion(
              id: 'cq_$index',
              type: type,
              prompt: '选择“${word.translation}”对应的英文单词',
              correctAnswer: word.word,
              options: _buildOptions(
                correct: word.word,
                pool: allWords.map((e) => e.word).toList(),
              ),
              relatedWordId: word.id,
            ),
          );
          break;
        case VocabularyQuizType.spelling:
          questions.add(
            VocabularyQuizQuestion(
              id: 'sp_$index',
              type: type,
              prompt: '请拼写：${word.translation}',
              correctAnswer: word.word,
              options: const [],
              relatedWordId: word.id,
            ),
          );
          break;
      }
    }

    return questions;
  }

  List<String> _buildOptions({required String correct, required List<String> pool}) {
    final set = <String>{correct};
    final shuffled = List<String>.from(pool)..shuffle();
    for (final item in shuffled) {
      if (set.length >= 4) break;
      if (item != correct) set.add(item);
    }
    final options = set.toList()..shuffle();
    return options;
  }

  bool _isCacheValid() {
    final raw = _progressBox.get(_cacheTimeKey);
    if (raw is! String) return false;
    final time = DateTime.tryParse(raw);
    if (time == null) return false;
    return DateTime.now().difference(time) < _cacheDuration;
  }

  Future<void> _saveCache(List<WordModel> words) async {
    await _progressBox.put(_cacheKey, words.map((word) => word.toJson()).toList());
    await _progressBox.put(_cacheTimeKey, DateTime.now().toIso8601String());
  }
}
