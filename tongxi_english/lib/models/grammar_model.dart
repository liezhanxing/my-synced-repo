import 'package:equatable/equatable.dart';

/// Grammar model for grammar rules and exercises
/// 
/// Contains grammar rule data, explanations, and practice exercises
class GrammarModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// Grammar rule title
  final String title;
  
  /// Rule explanation
  final String explanation;
  
  /// Key points/formulas
  final List<String> keyPoints;
  
  /// Examples
  final List<GrammarExample> examples;
  
  /// Common mistakes
  final List<String> commonMistakes;
  
  /// Category (tenses, conditionals, etc.)
  final GrammarCategory category;
  
  /// Difficulty level
  final int difficulty;
  
  /// Related rules
  final List<String> relatedRules;

  const GrammarModel({
    required this.id,
    required this.title,
    required this.explanation,
    required this.keyPoints,
    required this.examples,
    required this.commonMistakes,
    required this.category,
    this.difficulty = 1,
    this.relatedRules = const [],
  });

  factory GrammarModel.fromJson(Map<String, dynamic> json) {
    return GrammarModel(
      id: json['id'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      keyPoints: List<String>.from(json['key_points'] ?? []),
      examples: (json['examples'] as List)
          .map((e) => GrammarExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      commonMistakes: List<String>.from(json['common_mistakes'] ?? []),
      category: GrammarCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => GrammarCategory.tenses,
      ),
      difficulty: json['difficulty'] as int? ?? 1,
      relatedRules: List<String>.from(json['related_rules'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'explanation': explanation,
      'key_points': keyPoints,
      'examples': examples.map((e) => e.toJson()).toList(),
      'common_mistakes': commonMistakes,
      'category': category.name,
      'difficulty': difficulty,
      'related_rules': relatedRules,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        explanation,
        keyPoints,
        examples,
        commonMistakes,
        category,
        difficulty,
        relatedRules,
      ];
}

/// Grammar example
class GrammarExample extends Equatable {
  final String correct;
  final String? incorrect;
  final String explanation;

  const GrammarExample({
    required this.correct,
    this.incorrect,
    required this.explanation,
  });

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      correct: json['correct'] as String,
      incorrect: json['incorrect'] as String?,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correct': correct,
      'incorrect': incorrect,
      'explanation': explanation,
    };
  }

  @override
  List<Object?> get props => [correct, incorrect, explanation];
}

/// Grammar category
enum GrammarCategory {
  tenses,
  conditionals,
  passiveVoice,
  reportedSpeech,
  articles,
  prepositions,
  conjunctions,
  relativeClauses,
  modalVerbs,
  gerunds,
  comparatives,
  questionForms,
}
