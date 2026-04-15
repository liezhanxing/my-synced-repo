import 'package:equatable/equatable.dart';

/// Translation model for translation exercises
/// 
/// Contains source text, target translation, and hints
class TranslationModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// Source text (Chinese)
  final String sourceText;
  
  /// Target translation (English)
  final String targetTranslation;
  
  /// Alternative acceptable translations
  final List<String> alternatives;
  
  /// Difficulty level
  final int difficulty;
  
  /// Category (sentence, paragraph, idiom, etc.)
  final TranslationCategory category;
  
  /// Hints/tips for translation
  final List<String> hints;
  
  /// Key vocabulary
  final List<TranslationVocabulary> keyVocabulary;
  
  /// Common mistakes
  final List<String> commonMistakes;
  
  /// Grammar points involved
  final List<String> grammarPoints;
  
  /// Context/explanation
  final String context;

  const TranslationModel({
    required this.id,
    required this.sourceText,
    required this.targetTranslation,
    this.alternatives = const [],
    this.difficulty = 1,
    required this.category,
    this.hints = const [],
    this.keyVocabulary = const [],
    this.commonMistakes = const [],
    this.grammarPoints = const [],
    this.context = '',
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id: json['id'] as String,
      sourceText: json['source_text'] as String,
      targetTranslation: json['target_translation'] as String,
      alternatives: List<String>.from(json['alternatives'] ?? []),
      difficulty: json['difficulty'] as int? ?? 1,
      category: TranslationCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TranslationCategory.sentence,
      ),
      hints: List<String>.from(json['hints'] ?? []),
      keyVocabulary: (json['key_vocabulary'] as List?)
              ?.map((v) => TranslationVocabulary.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      commonMistakes: List<String>.from(json['common_mistakes'] ?? []),
      grammarPoints: List<String>.from(json['grammar_points'] ?? []),
      context: json['context'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_text': sourceText,
      'target_translation': targetTranslation,
      'alternatives': alternatives,
      'difficulty': difficulty,
      'category': category.name,
      'hints': hints,
      'key_vocabulary': keyVocabulary.map((v) => v.toJson()).toList(),
      'common_mistakes': commonMistakes,
      'grammar_points': grammarPoints,
      'context': context,
    };
  }

  @override
  List<Object?> get props => [
        id,
        sourceText,
        targetTranslation,
        alternatives,
        difficulty,
        category,
        hints,
        keyVocabulary,
        commonMistakes,
        grammarPoints,
        context,
      ];
}

/// Translation vocabulary
class TranslationVocabulary extends Equatable {
  final String word;
  final String translation;
  final String usage;

  const TranslationVocabulary({
    required this.word,
    required this.translation,
    required this.usage,
  });

  factory TranslationVocabulary.fromJson(Map<String, dynamic> json) {
    return TranslationVocabulary(
      word: json['word'] as String,
      translation: json['translation'] as String,
      usage: json['usage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'usage': usage,
    };
  }

  @override
  List<Object?> get props => [word, translation, usage];
}

/// Translation category
enum TranslationCategory {
  sentence,
  paragraph,
  idiom,
  dialogue,
  essay,
}
