import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../models/phonetic_model.dart';
import '../domain/phonetics_practice_models.dart';
import 'phonetics_local_data.dart';

class PhoneticsRepository {
  PhoneticsRepository({Box<dynamic>? progressBox})
      : _progressBox = progressBox ?? Hive.box('progressBox');

  final Box<dynamic> _progressBox;

  static const String _cacheKey = 'phonetics_cache_v1';
  static const String _cacheTimeKey = 'phonetics_cache_time_v1';
  static const Duration _cacheDuration = Duration(hours: 12);

  List<PhoneticModel>? _memoryCache;

  Future<List<PhoneticModel>> getAllPhonetics({bool forceRefresh = false}) async {
    if (!forceRefresh && _memoryCache != null) {
      return _memoryCache!;
    }

    try {
      if (!forceRefresh && _isCacheValid()) {
        final raw = _progressBox.get(_cacheKey);
        if (raw is List) {
          final items = raw
              .whereType<Map>()
              .map((e) => PhoneticModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          if (items.isNotEmpty) {
            _memoryCache = items;
            return items;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('读取音标缓存失败: $e');
      }
    }

    final items = PhoneticsLocalData.getAllPhonetics();
    _memoryCache = items;
    await _saveCache(items);
    return items;
  }

  Future<List<PhoneticModel>> getVowels() async {
    final vowels = await getByCategory(PhoneticCategory.vowel);
    final diphthongs = await getByCategory(PhoneticCategory.diphthong);
    return [...vowels, ...diphthongs];
  }

  Future<List<PhoneticModel>> getConsonants() async {
    return getByCategory(PhoneticCategory.consonant);
  }

  Future<List<PhoneticModel>> getByCategory(PhoneticCategory category) async {
    final items = await getAllPhonetics();
    return items.where((item) => item.category == category).toList();
  }

  Future<PhoneticModel?> getById(String id) async {
    final items = await getAllPhonetics();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<PhoneticsExercise>> getPracticeExercises() async {
    return PhoneticsLocalData.getPracticeExercises();
  }

  Future<Map<String, List<PhoneticModel>>> getVowelGroups() async {
    return PhoneticsLocalData.getVowelGroups();
  }

  Future<Map<String, List<PhoneticModel>>> getConsonantGroups() async {
    return PhoneticsLocalData.getConsonantGroups();
  }

  Future<List<PhoneticModel>> getSimilarSounds(String symbol) async {
    return PhoneticsLocalData.getSimilarSounds(symbol);
  }

  bool _isCacheValid() {
    final raw = _progressBox.get(_cacheTimeKey);
    if (raw is! String) return false;
    final time = DateTime.tryParse(raw);
    if (time == null) return false;
    return DateTime.now().difference(time) < _cacheDuration;
  }

  Future<void> _saveCache(List<PhoneticModel> items) async {
    try {
      await _progressBox.put(_cacheKey, items.map((e) => e.toJson()).toList());
      await _progressBox.put(_cacheTimeKey, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('写入音标缓存失败: $e');
      }
    }
  }
}
