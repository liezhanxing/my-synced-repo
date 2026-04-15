import 'package:flutter_test/flutter_test.dart';
import 'package:tongxi_english/models/word_model.dart';

void main() {
  group('WordModel', () {
    test('fromJson/toJson roundtrip preserves all data', () {
      final original = WordModel(
        id: 'word_001',
        word: 'abandon',
        phonetic: '/əˈbændən/',
        partOfSpeech: 'verb',
        translation: '放弃，遗弃',
        definition: 'to leave behind, to give up',
        examples: [
          WordExample(
            sentence: 'They had to abandon their car in the snow.',
            translation: '他们不得不把汽车弃置在雪中。',
          ),
          WordExample(
            sentence: 'She abandoned her career to travel the world.',
            translation: '她放弃了事业去环游世界。',
          ),
        ],
        audioUrl: 'https://example.com/audio/abandon.mp3',
        imageUrl: 'https://example.com/images/abandon.jpg',
        difficulty: 2,
        tags: ['common', 'verb', 'academic'],
        frequency: WordFrequency.common,
        relatedWords: ['desert', 'forsake', 'leave'],
        forms: {
          'past': 'abandoned',
          'past_participle': 'abandoned',
          'present_participle': 'abandoning',
        },
      );

      final json = original.toJson();
      final restored = WordModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.word, original.word);
      expect(restored.phonetic, original.phonetic);
      expect(restored.partOfSpeech, original.partOfSpeech);
      expect(restored.translation, original.translation);
      expect(restored.definition, original.definition);
      expect(restored.audioUrl, original.audioUrl);
      expect(restored.imageUrl, original.imageUrl);
      expect(restored.difficulty, original.difficulty);
      expect(restored.tags, original.tags);
      expect(restored.frequency, original.frequency);
      expect(restored.relatedWords, original.relatedWords);
      expect(restored.forms, original.forms);
      expect(restored.examples.length, original.examples.length);
      expect(restored.examples[0].sentence, original.examples[0].sentence);
      expect(restored.examples[0].translation, original.examples[0].translation);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'word_002',
        'word': 'test',
        'phonetic': '/test/',
        'part_of_speech': 'noun',
        'translation': '测试',
        'definition': 'a procedure for testing',
        'examples': [],
        'audio_url': 'https://example.com/test.mp3',
      };

      final word = WordModel.fromJson(json);

      expect(word.id, 'word_002');
      expect(word.word, 'test');
      expect(word.imageUrl, isNull);
      expect(word.difficulty, 1); // default value
      expect(word.tags, isEmpty);
      expect(word.frequency, WordFrequency.common); // default value
      expect(word.relatedWords, isEmpty);
      expect(word.forms, isNull);
    });

    test('fromJson handles all fields present', () {
      final json = {
        'id': 'word_003',
        'word': 'comprehensive',
        'phonetic': '/ˌkɒmprɪˈhensɪv/',
        'part_of_speech': 'adjective',
        'translation': '全面的，综合的',
        'definition': 'complete and including everything',
        'examples': [
          {
            'sentence': 'We offer a comprehensive range of services.',
            'translation': '我们提供全面的服务。',
          },
        ],
        'audio_url': 'https://example.com/comprehensive.mp3',
        'image_url': 'https://example.com/comprehensive.jpg',
        'difficulty': 4,
        'tags': ['academic', 'formal'],
        'frequency': 'uncommon',
        'related_words': ['complete', 'thorough', 'extensive'],
        'forms': {},
      };

      final word = WordModel.fromJson(json);

      expect(word.id, 'word_003');
      expect(word.word, 'comprehensive');
      expect(word.difficulty, 4);
      expect(word.tags, ['academic', 'formal']);
      expect(word.frequency, WordFrequency.uncommon);
      expect(word.relatedWords, ['complete', 'thorough', 'extensive']);
      expect(word.forms, isEmpty);
      expect(word.imageUrl, 'https://example.com/comprehensive.jpg');
    });

    test('fromJson handles WordFrequency enum correctly', () {
      final commonJson = {
        'id': 'word_004',
        'word': 'hello',
        'phonetic': '/həˈloʊ/',
        'part_of_speech': 'interjection',
        'translation': '你好',
        'definition': 'used as a greeting',
        'examples': [],
        'audio_url': 'https://example.com/hello.mp3',
        'frequency': 'common',
      };

      final rareJson = {
        'id': 'word_005',
        'word': 'sesquipedalian',
        'phonetic': '/ˌseskwɪpɪˈdeɪliən/',
        'part_of_speech': 'adjective',
        'translation': '冗长的，多音节的',
        'definition': 'using long words',
        'examples': [],
        'audio_url': 'https://example.com/sesquipedalian.mp3',
        'frequency': 'rare',
      };

      final commonWord = WordModel.fromJson(commonJson);
      final rareWord = WordModel.fromJson(rareJson);

      expect(commonWord.frequency, WordFrequency.common);
      expect(rareWord.frequency, WordFrequency.rare);
    });

    test('fromJson defaults to common for unknown frequency', () {
      final json = {
        'id': 'word_006',
        'word': 'unknown',
        'phonetic': '/ʌnˈnoʊn/',
        'part_of_speech': 'adjective',
        'translation': '未知的',
        'definition': 'not known',
        'examples': [],
        'audio_url': 'https://example.com/unknown.mp3',
        'frequency': 'invalid_frequency',
      };

      final word = WordModel.fromJson(json);
      expect(word.frequency, WordFrequency.common);
    });

    test('toJson produces correct structure', () {
      final word = WordModel(
        id: 'word_007',
        word: 'example',
        phonetic: '/ɪɡˈzæmpl/',
        partOfSpeech: 'noun',
        translation: '例子',
        definition: 'a thing characteristic of its kind',
        examples: [
          WordExample(
            sentence: 'This is an example.',
            translation: '这是一个例子。',
          ),
        ],
        audioUrl: 'https://example.com/example.mp3',
        difficulty: 1,
        frequency: WordFrequency.common,
      );

      final json = word.toJson();

      expect(json['id'], 'word_007');
      expect(json['word'], 'example');
      expect(json['phonetic'], '/ɪɡˈzæmpl/');
      expect(json['part_of_speech'], 'noun');
      expect(json['translation'], '例子');
      expect(json['definition'], 'a thing characteristic of its kind');
      expect(json['audio_url'], 'https://example.com/example.mp3');
      expect(json['difficulty'], 1);
      expect(json['frequency'], 'common');
      expect(json['examples'], isA<List>());
      expect(json['examples'].length, 1);
    });

    test('props includes all fields for equality', () {
      final word1 = WordModel(
        id: 'word_008',
        word: 'equal',
        phonetic: '/ˈiːkwəl/',
        partOfSpeech: 'adjective',
        translation: '相等的',
        definition: 'being the same',
        examples: [],
        audioUrl: 'https://example.com/equal.mp3',
      );

      final word2 = WordModel(
        id: 'word_008',
        word: 'equal',
        phonetic: '/ˈiːkwəl/',
        partOfSpeech: 'adjective',
        translation: '相等的',
        definition: 'being the same',
        examples: [],
        audioUrl: 'https://example.com/equal.mp3',
      );

      final word3 = WordModel(
        id: 'word_009',
        word: 'different',
        phonetic: '/ˈdɪfrənt/',
        partOfSpeech: 'adjective',
        translation: '不同的',
        definition: 'not the same',
        examples: [],
        audioUrl: 'https://example.com/different.mp3',
      );

      expect(word1, word2);
      expect(word1 == word3, isFalse);
    });
  });

  group('WordExample', () {
    test('fromJson/toJson roundtrip preserves data', () {
      final original = WordExample(
        sentence: 'This is a test sentence.',
        translation: '这是一个测试句子。',
      );

      final json = original.toJson();
      final restored = WordExample.fromJson(json);

      expect(restored.sentence, original.sentence);
      expect(restored.translation, original.translation);
    });

    test('props includes all fields for equality', () {
      final example1 = WordExample(
        sentence: 'Hello world.',
        translation: '你好世界。',
      );

      final example2 = WordExample(
        sentence: 'Hello world.',
        translation: '你好世界。',
      );

      final example3 = WordExample(
        sentence: 'Goodbye world.',
        translation: '再见世界。',
      );

      expect(example1, example2);
      expect(example1 == example3, isFalse);
    });
  });

  group('WordFrequency', () {
    test('enum values are correct', () {
      expect(WordFrequency.values, [
        WordFrequency.common,
        WordFrequency.uncommon,
        WordFrequency.rare,
      ]);
    });

    test('enum names are correct', () {
      expect(WordFrequency.common.name, 'common');
      expect(WordFrequency.uncommon.name, 'uncommon');
      expect(WordFrequency.rare.name, 'rare');
    });
  });
}
