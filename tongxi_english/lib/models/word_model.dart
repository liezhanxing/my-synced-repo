import 'package:equatable/equatable.dart';

/// Word model for vocabulary items
/// 
/// Contains word data, definitions, examples, and learning progress
class WordModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// The word itself
  final String word;
  
  /// Phonetic pronunciation
  final String phonetic;
  
  /// Part of speech (noun, verb, adjective, etc.)
  final String partOfSpeech;
  
  /// Chinese translation
  final String translation;
  
  /// English definition
  final String definition;
  
  /// Example sentences
  final List<WordExample> examples;
  
  /// Audio URL for pronunciation
  final String audioUrl;
  
  /// Image URL (optional)
  final String? imageUrl;
  
  /// Difficulty level (1-5)
  final int difficulty;
  
  /// Tags/categories
  final List<String> tags;
  
  /// Word frequency (common, uncommon, rare)
  final WordFrequency frequency;
  
  /// Related words
  final List<String> relatedWords;
  
  /// Word forms (plural, past tense, etc.)
  final Map<String, String>? forms;

  const WordModel({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.partOfSpeech,
    required this.translation,
    required this.definition,
    required this.examples,
    required this.audioUrl,
    this.imageUrl,
    this.difficulty = 1,
    this.tags = const [],
    this.frequency = WordFrequency.common,
    this.relatedWords = const [],
    this.forms,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String,
      word: json['word'] as String,
      phonetic: json['phonetic'] as String,
      partOfSpeech: json['part_of_speech'] as String,
      translation: json['translation'] as String,
      definition: json['definition'] as String,
      examples: (json['examples'] as List)
          .map((e) => WordExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      audioUrl: json['audio_url'] as String,
      imageUrl: json['image_url'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
      tags: List<String>.from(json['tags'] ?? []),
      frequency: WordFrequency.values.firstWhere(
        (f) => f.name == json['frequency'],
        orElse: () => WordFrequency.common,
      ),
      relatedWords: List<String>.from(json['related_words'] ?? []),
      forms: json['forms'] != null
          ? Map<String, String>.from(json['forms'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'phonetic': phonetic,
      'part_of_speech': partOfSpeech,
      'translation': translation,
      'definition': definition,
      'examples': examples.map((e) => e.toJson()).toList(),
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'difficulty': difficulty,
      'tags': tags,
      'frequency': frequency.name,
      'related_words': relatedWords,
      'forms': forms,
    };
  }

  @override
  List<Object?> get props => [
        id,
        word,
        phonetic,
        partOfSpeech,
        translation,
        definition,
        examples,
        audioUrl,
        imageUrl,
        difficulty,
        tags,
        frequency,
        relatedWords,
        forms,
      ];
}

/// Word example sentence
class WordExample extends Equatable {
  final String sentence;
  final String translation;

  const WordExample({
    required this.sentence,
    required this.translation,
  });

  factory WordExample.fromJson(Map<String, dynamic> json) {
    return WordExample(
      sentence: json['sentence'] as String,
      translation: json['translation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'translation': translation,
    };
  }

  @override
  List<Object?> get props => [sentence, translation];
}

/// Word frequency levels
enum WordFrequency {
  common,
  uncommon,
  rare,
}
