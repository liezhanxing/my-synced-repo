import 'package:equatable/equatable.dart';

/// Listening model for listening comprehension materials
/// 
/// Contains audio data, transcripts, and comprehension questions
class ListeningModel extends Equatable {
  /// Unique ID
  final String id;
  
  /// Title
  final String title;
  
  /// Audio URL
  final String audioUrl;
  
  /// Transcript
  final String transcript;
  
  /// Duration in seconds
  final int duration;
  
  /// Difficulty level
  final int difficulty;
  
  /// Category (dialogue, news, lecture, etc.)
  final ListeningCategory category;
  
  /// Tags/topics
  final List<String> tags;
  
  /// Comprehension questions
  final List<ListeningQuestion> questions;
  
  /// Key vocabulary
  final List<ListeningVocabulary> vocabulary;
  
  /// Accent (British, American, etc.)
  final String accent;
  
  /// Number of speakers
  final int speakerCount;

  const ListeningModel({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.transcript,
    required this.duration,
    this.difficulty = 1,
    required this.category,
    this.tags = const [],
    required this.questions,
    this.vocabulary = const [],
    this.accent = 'American',
    this.speakerCount = 1,
  });

  factory ListeningModel.fromJson(Map<String, dynamic> json) {
    return ListeningModel(
      id: json['id'] as String,
      title: json['title'] as String,
      audioUrl: json['audio_url'] as String,
      transcript: json['transcript'] as String,
      duration: json['duration'] as int,
      difficulty: json['difficulty'] as int? ?? 1,
      category: ListeningCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ListeningCategory.dialogue,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      questions: (json['questions'] as List)
          .map((q) => ListeningQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      vocabulary: (json['vocabulary'] as List?)
              ?.map((v) => ListeningVocabulary.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      accent: json['accent'] as String? ?? 'American',
      speakerCount: json['speaker_count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'audio_url': audioUrl,
      'transcript': transcript,
      'duration': duration,
      'difficulty': difficulty,
      'category': category.name,
      'tags': tags,
      'questions': questions.map((q) => q.toJson()).toList(),
      'vocabulary': vocabulary.map((v) => v.toJson()).toList(),
      'accent': accent,
      'speaker_count': speakerCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        audioUrl,
        transcript,
        duration,
        difficulty,
        category,
        tags,
        questions,
        vocabulary,
        accent,
        speakerCount,
      ];
}

/// Listening question
class ListeningQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final int timestamp; // When in audio this question relates to

  const ListeningQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.timestamp = 0,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) {
    return ListeningQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as int,
      explanation: json['explanation'] as String,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [id, question, options, correctAnswer, explanation, timestamp];
}

/// Listening vocabulary
class ListeningVocabulary extends Equatable {
  final String word;
  final String phonetic;
  final String definition;
  final String timestamp; // When word appears in audio

  const ListeningVocabulary({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.timestamp,
  });

  factory ListeningVocabulary.fromJson(Map<String, dynamic> json) {
    return ListeningVocabulary(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String,
      definition: json['definition'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'phonetic': phonetic,
      'definition': definition,
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [word, phonetic, definition, timestamp];
}

/// Listening category
enum ListeningCategory {
  dialogue,
  news,
  lecture,
  interview,
  announcement,
  story,
  conversation,
}
