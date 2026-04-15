import 'package:equatable/equatable.dart';

/// Reading model for reading comprehension passages
/// 
/// Contains passage data, questions, and difficulty settings
class ReadingModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// Passage title
  final String title;
  
  /// Passage content
  final String content;
  
  /// Source/author
  final String source;
  
  /// Word count
  final int wordCount;
  
  /// Difficulty level
  final int difficulty;
  
  /// Category (news, story, academic, etc.)
  final ReadingCategory category;
  
  /// Tags/topics
  final List<String> tags;
  
  /// Comprehension questions
  final List<ReadingQuestion> questions;
  
  /// Vocabulary highlights
  final List<ReadingVocabulary> vocabulary;
  
  /// Estimated reading time in minutes
  final int estimatedTime;
  
  /// Image URL (optional)
  final String? imageUrl;

  const ReadingModel({
    required this.id,
    required this.title,
    required this.content,
    required this.source,
    required this.wordCount,
    this.difficulty = 1,
    required this.category,
    this.tags = const [],
    required this.questions,
    this.vocabulary = const [],
    required this.estimatedTime,
    this.imageUrl,
  });

  factory ReadingModel.fromJson(Map<String, dynamic> json) {
    return ReadingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      source: json['source'] as String,
      wordCount: json['word_count'] as int,
      difficulty: json['difficulty'] as int? ?? 1,
      category: ReadingCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ReadingCategory.news,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      questions: (json['questions'] as List)
          .map((q) => ReadingQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      vocabulary: (json['vocabulary'] as List?)
              ?.map((v) => ReadingVocabulary.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      estimatedTime: json['estimated_time'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'source': source,
      'word_count': wordCount,
      'difficulty': difficulty,
      'category': category.name,
      'tags': tags,
      'questions': questions.map((q) => q.toJson()).toList(),
      'vocabulary': vocabulary.map((v) => v.toJson()).toList(),
      'estimated_time': estimatedTime,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        source,
        wordCount,
        difficulty,
        category,
        tags,
        questions,
        vocabulary,
        estimatedTime,
        imageUrl,
      ];
}

/// Reading comprehension question
class ReadingQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final QuestionType type;

  const ReadingQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.type = QuestionType.multipleChoice,
  });

  factory ReadingQuestion.fromJson(Map<String, dynamic> json) {
    return ReadingQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as int,
      explanation: json['explanation'] as String,
      type: QuestionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'type': type.name,
    };
  }

  @override
  List<Object?> get props => [id, question, options, correctAnswer, explanation, type];
}

/// Reading vocabulary highlight
class ReadingVocabulary extends Equatable {
  final String word;
  final String phonetic;
  final String definition;
  final String translation;

  const ReadingVocabulary({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.translation,
  });

  factory ReadingVocabulary.fromJson(Map<String, dynamic> json) {
    return ReadingVocabulary(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String,
      definition: json['definition'] as String,
      translation: json['translation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'phonetic': phonetic,
      'definition': definition,
      'translation': translation,
    };
  }

  @override
  List<Object?> get props => [word, phonetic, definition, translation];
}

/// Reading category
enum ReadingCategory {
  news,
  story,
  academic,
  biography,
  science,
  history,
  culture,
}

/// Question type
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillInBlank,
}
