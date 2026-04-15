enum VocabularyTab {
  list,
  flashcards,
  quiz,
  review,
}

extension VocabularyTabX on VocabularyTab {
  String get label {
    switch (this) {
      case VocabularyTab.list:
        return '单词表';
      case VocabularyTab.flashcards:
        return '闪卡';
      case VocabularyTab.quiz:
        return '测验';
      case VocabularyTab.review:
        return '复习';
    }
  }
}

enum VocabularyQuizType {
  englishToChinese,
  chineseToEnglish,
  spelling,
}

class VocabularyQuizQuestion {
  final String id;
  final VocabularyQuizType type;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final String relatedWordId;

  const VocabularyQuizQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.correctAnswer,
    required this.options,
    required this.relatedWordId,
  });
}
