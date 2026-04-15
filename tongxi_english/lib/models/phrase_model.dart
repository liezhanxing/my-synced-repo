import 'package:equatable/equatable.dart';

/// Phrase model for common English phrases and collocations
/// 
/// Contains phrase data, usage contexts, and examples
class PhraseModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// The phrase/collocation
  final String phrase;
  
  /// Chinese translation
  final String translation;
  
  /// Meaning/explanation
  final String meaning;
  
  /// Usage contexts (formal, informal, written, spoken, etc.)
  final List<String> contexts;
  
  /// Example sentences
  final List<PhraseExample> examples;
  
  /// Category (idiom, phrasal verb, collocation, etc.)
  final PhraseCategory category;
  
  /// Difficulty level
  final int difficulty;
  
  /// Audio URL
  final String audioUrl;
  
  /// Related phrases
  final List<String> relatedPhrases;

  const PhraseModel({
    required this.id,
    required this.phrase,
    required this.translation,
    required this.meaning,
    required this.contexts,
    required this.examples,
    required this.category,
    this.difficulty = 1,
    required this.audioUrl,
    this.relatedPhrases = const [],
  });

  factory PhraseModel.fromJson(Map<String, dynamic> json) {
    return PhraseModel(
      id: json['id'] as String,
      phrase: json['phrase'] as String,
      translation: json['translation'] as String,
      meaning: json['meaning'] as String,
      contexts: List<String>.from(json['contexts'] ?? []),
      examples: (json['examples'] as List)
          .map((e) => PhraseExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: PhraseCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => PhraseCategory.collocation,
      ),
      difficulty: json['difficulty'] as int? ?? 1,
      audioUrl: json['audio_url'] as String,
      relatedPhrases: List<String>.from(json['related_phrases'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phrase': phrase,
      'translation': translation,
      'meaning': meaning,
      'contexts': contexts,
      'examples': examples.map((e) => e.toJson()).toList(),
      'category': category.name,
      'difficulty': difficulty,
      'audio_url': audioUrl,
      'related_phrases': relatedPhrases,
    };
  }

  @override
  List<Object?> get props => [
        id,
        phrase,
        translation,
        meaning,
        contexts,
        examples,
        category,
        difficulty,
        audioUrl,
        relatedPhrases,
      ];
}

/// Phrase example
class PhraseExample extends Equatable {
  final String sentence;
  final String translation;
  final String context;

  const PhraseExample({
    required this.sentence,
    required this.translation,
    required this.context,
  });

  factory PhraseExample.fromJson(Map<String, dynamic> json) {
    return PhraseExample(
      sentence: json['sentence'] as String,
      translation: json['translation'] as String,
      context: json['context'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'translation': translation,
      'context': context,
    };
  }

  @override
  List<Object?> get props => [sentence, translation, context];
}

/// Phrase category
enum PhraseCategory {
  idiom,
  phrasalVerb,
  collocation,
  proverb,
  slang,
}
