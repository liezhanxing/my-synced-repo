import 'package:equatable/equatable.dart';

/// Phonetic model representing a phonetic sound/concept
/// 
/// Contains phonetic symbol, audio URL, examples, and practice data
class PhoneticModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// Phonetic symbol (IPA)
  final String symbol;
  
  /// Common spelling patterns
  final List<String> spellings;
  
  /// Description/articulation guide
  final String description;
  
  /// Audio URL for pronunciation
  final String audioUrl;
  
  /// Example words
  final List<PhoneticExample> examples;
  
  /// Category (vowel, consonant, etc.)
  final PhoneticCategory category;
  
  /// Difficulty level
  final int difficulty;

  const PhoneticModel({
    required this.id,
    required this.symbol,
    required this.spellings,
    required this.description,
    required this.audioUrl,
    required this.examples,
    required this.category,
    this.difficulty = 1,
  });

  factory PhoneticModel.fromJson(Map<String, dynamic> json) {
    return PhoneticModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      spellings: List<String>.from(json['spellings'] as List),
      description: json['description'] as String,
      audioUrl: json['audio_url'] as String,
      examples: (json['examples'] as List)
          .map((e) => PhoneticExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: PhoneticCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => PhoneticCategory.consonant,
      ),
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'spellings': spellings,
      'description': description,
      'audio_url': audioUrl,
      'examples': examples.map((e) => e.toJson()).toList(),
      'category': category.name,
      'difficulty': difficulty,
    };
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        spellings,
        description,
        audioUrl,
        examples,
        category,
        difficulty,
      ];
}

/// Phonetic example word
class PhoneticExample extends Equatable {
  final String word;
  final String phoneticSpelling;
  final String meaning;

  const PhoneticExample({
    required this.word,
    required this.phoneticSpelling,
    required this.meaning,
  });

  factory PhoneticExample.fromJson(Map<String, dynamic> json) {
    return PhoneticExample(
      word: json['word'] as String,
      phoneticSpelling: json['phonetic_spelling'] as String,
      meaning: json['meaning'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'phonetic_spelling': phoneticSpelling,
      'meaning': meaning,
    };
  }

  @override
  List<Object?> get props => [word, phoneticSpelling, meaning];
}

/// Phonetic category
enum PhoneticCategory {
  vowel,
  consonant,
  diphthong,
}
