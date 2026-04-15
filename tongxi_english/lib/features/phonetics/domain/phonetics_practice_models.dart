import '../../../models/phonetic_model.dart';

class PhoneticsExercise {
  final String id;
  final PhoneticsExerciseType type;
  final String prompt;
  final String correctAnswerId;
  final List<String> optionIds;
  final String? audioText;
  final String? displayWord;
  final String? hint;

  const PhoneticsExercise({
    required this.id,
    required this.type,
    required this.prompt,
    required this.correctAnswerId,
    required this.optionIds,
    this.audioText,
    this.displayWord,
    this.hint,
  });
}

enum PhoneticsExerciseType {
  listenAndChoose,
  wordToPhonetic,
}

enum PhoneticsSection {
  vowels,
  consonants,
  practice,
}

extension PhoneticsSectionX on PhoneticsSection {
  String get label {
    switch (this) {
      case PhoneticsSection.vowels:
        return '元音';
      case PhoneticsSection.consonants:
        return '辅音';
      case PhoneticsSection.practice:
        return '练习';
    }
  }
}

extension PhoneticCategoryX on PhoneticCategory {
  String get label {
    switch (this) {
      case PhoneticCategory.vowel:
        return '单元音';
      case PhoneticCategory.consonant:
        return '辅音';
      case PhoneticCategory.diphthong:
        return '双元音';
    }
  }
}
