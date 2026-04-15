import '../../../models/translation_model.dart';

/// Translation direction enum
enum TranslationDirection {
  en2cn,
  cn2en,
}

/// Translation difficulty enum
enum TranslationDifficulty {
  basic, // 高一
  intermediate, // 高二
  advanced, // 高三
}

/// Extended translation exercise model with direction
class TranslationExercise {
  final String id;
  final String sourceText;
  final String targetText;
  final List<String> alternativeAnswers;
  final TranslationDifficulty difficulty;
  final TranslationDirection direction;
  final TranslationCategory category;
  final List<String> keyPoints;
  final List<String> hints;
  final List<TranslationVocabulary> keyVocabulary;
  final String? context;

  const TranslationExercise({
    required this.id,
    required this.sourceText,
    required this.targetText,
    this.alternativeAnswers = const [],
    required this.difficulty,
    required this.direction,
    this.category = TranslationCategory.sentence,
    this.keyPoints = const [],
    this.hints = const [],
    this.keyVocabulary = const [],
    this.context,
  });

  /// Convert to TranslationModel
  TranslationModel toTranslationModel() {
    return TranslationModel(
      id: id,
      sourceText: sourceText,
      targetTranslation: targetText,
      alternatives: alternativeAnswers,
      difficulty: difficulty.index + 1,
      category: category,
      hints: hints,
      keyVocabulary: keyVocabulary,
      grammarPoints: keyPoints,
      context: context ?? '',
    );
  }
}

/// Local data source for translation exercises
/// 
/// Contains 30+ hardcoded exercises organized by difficulty and direction
class TranslationLocalData {
  TranslationLocalData._();

  /// Get all translation exercises
  static List<TranslationExercise> getAllExercises() {
    return [
      ..._basicEn2CnExercises,
      ..._basicCn2EnExercises,
      ..._intermediateEn2CnExercises,
      ..._intermediateCn2EnExercises,
      ..._advancedEn2CnExercises,
      ..._advancedCn2EnExercises,
    ];
  }

  /// Get exercises by difficulty
  static List<TranslationExercise> getExercisesByDifficulty(
    TranslationDifficulty difficulty,
  ) {
    return getAllExercises()
        .where((e) => e.difficulty == difficulty)
        .toList();
  }

  /// Get exercises by direction
  static List<TranslationExercise> getExercisesByDirection(
    TranslationDirection direction,
  ) {
    return getAllExercises()
        .where((e) => e.direction == direction)
        .toList();
  }

  /// Get daily challenge exercise (rotates based on day)
  static TranslationExercise getDailyChallenge() {
    final dayOfYear = DateTime.now().difference(DateTime(2024, 1, 1)).inDays;
    final exercises = getAllExercises();
    return exercises[dayOfYear % exercises.length];
  }

  // ==================== Basic EN→CN Exercises (高一) ====================
  static final List<TranslationExercise> _basicEn2CnExercises = [
    const TranslationExercise(
      id: 'basic_en2cn_001',
      sourceText: "I am a student.",
      targetText: "我是一名学生。",
      alternativeAnswers: ["我是学生。", "我是个学生。"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.en2cn,
      keyPoints: ["be动词am/is/are的用法", "不定冠词a/an"],
      hints: ["注意：I后面用am", "student是可数名词，前面需要冠词"],
      keyVocabulary: [
        TranslationVocabulary(
          word: 'student',
          translation: '学生',
          usage: 'I am a student.',
        ),
      ],
    ),
    const TranslationExercise(
      id: 'basic_en2cn_002',
      sourceText: "She likes playing basketball.",
      targetText: "她喜欢打篮球。",
      alternativeAnswers: ["她喜欢玩篮球。"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.en2cn,
      keyPoints: ["like doing sth. 喜欢做某事", "第三人称单数动词变化"],
      hints: ["注意：she是第三人称单数，like要加s", "play basketball 打篮球"],
      keyVocabulary: [
        TranslationVocabulary(
          word: 'like doing',
          translation: '喜欢做...',
          usage: 'She likes playing...',
        ),
      ],
    ),
    const TranslationExercise(
      id: 'basic_en2cn_003',
      sourceText: "There are many books on the desk.",
      targetText: "桌子上有很多书。",
      alternativeAnswers: ["书桌上有许多书。", "桌上有很多书。"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.en2cn,
      keyPoints: ["There be句型", "many修饰可数名词复数"],
      hints: ["注意：books是复数，用there are", "on the desk 在桌子上"],
      keyVocabulary: [
        TranslationVocabulary(
          word: 'there be',
          translation: '有...',
          usage: 'There are many...',
        ),
      ],
    ),
    const TranslationExercise(
      id: 'basic_en2cn_004',
      sourceText: "My father is a doctor.",
      targetText: "我的父亲是一名医生。",
      alternativeAnswers: ["我爸爸是医生。", "我父亲是个医生。"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.en2cn,
      keyPoints: ["名词所有格", "职业表达"],
      hints: ["注意：my father 我的父亲/爸爸", "doctor 医生"],
    ),
    const TranslationExercise(
      id: 'basic_en2cn_005',
      sourceText: "We usually go to school at 7 o'clock.",
      targetText: "我们通常七点去上学。",
      alternativeAnswers: ["我们一般七点上学。", "我们通常7点去学校。"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.en2cn,
      keyPoints: ["一般现在时", "时间表达"],
      hints: ["注意：usually表示通常，用一般现在时", "go to school 去上学"],
    ),
    const TranslationExercise(
      id: 'basic_en2cn_006',
      sourceText: "The weather is very nice today.",
      targetText: "今天天气很好。",
      alternativeAnswers: ["今天的天气非常好。"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.en2cn,
      keyPoints: ["weather不可数名词", "very修饰形容词"],
      hints: ["注意：weather是不可数名词，不能说a weather", "nice 好的"],
    ),
  ];

  // ==================== Basic CN→EN Exercises (高一) ====================
  static final List<TranslationExercise> _basicCn2EnExercises = [
    const TranslationExercise(
      id: 'basic_cn2en_001',
      sourceText: "我是一名高中生。",
      targetText: "I am a high school student.",
      alternativeAnswers: ["I'm a senior high school student."],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.cn2en,
      keyPoints: ["high school student 高中生", "senior high school 高中"],
      hints: ["注意：高中生用 high school student", "I am 可以缩写为 I'm"],
    ),
    const TranslationExercise(
      id: 'basic_cn2en_002',
      sourceText: "他每天骑自行车上学。",
      targetText: "He goes to school by bike every day.",
      alternativeAnswers: [
        "He rides a bike to school every day.",
        "He cycles to school every day.",
      ],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.cn2en,
      keyPoints: ["by bike 骑自行车", "every day 每天", "第三人称单数"],
      hints: ["注意：he是第三人称单数，动词go要加es", "by bike = ride a bike"],
    ),
    const TranslationExercise(
      id: 'basic_cn2en_003',
      sourceText: "教室里有多少学生？",
      targetText: "How many students are there in the classroom?",
      alternativeAnswers: ["How many students are there in the class?"],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.cn2en,
      keyPoints: ["How many 多少", "There be句型的疑问形式"],
      hints: ["注意：students是可数名词复数，用how many", "classroom 教室"],
    ),
    const TranslationExercise(
      id: 'basic_cn2en_004',
      sourceText: "我的英语老师很友好。",
      targetText: "My English teacher is very friendly.",
      alternativeAnswers: ["My English teacher is very kind."],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.cn2en,
      keyPoints: ["friendly 友好的", "English teacher 英语老师"],
      hints: ["注意：friendly是形容词，前面用be动词", "kind也可以表示友好"],
    ),
    const TranslationExercise(
      id: 'basic_cn2en_005',
      sourceText: "这本书很有趣。",
      targetText: "This book is very interesting.",
      alternativeAnswers: ["The book is very interesting."],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.cn2en,
      keyPoints: ["interesting 有趣的", "this 这个"],
      hints: ["注意：interesting修饰物，interested修饰人", "book是可数名词"],
    ),
    const TranslationExercise(
      id: 'basic_cn2en_006',
      sourceText: "我们在学校吃午饭。",
      targetText: "We have lunch at school.",
      alternativeAnswers: ["We eat lunch at school."],
      difficulty: TranslationDifficulty.basic,
      direction: TranslationDirection.cn2en,
      keyPoints: ["have lunch 吃午饭", "at school 在学校"],
      hints: ["注意：have lunch 是固定搭配", "at school 在学校"],
    ),
  ];

  // ==================== Intermediate EN→CN Exercises (高二) ====================
  static final List<TranslationExercise> _intermediateEn2CnExercises = [
    const TranslationExercise(
      id: 'inter_en2cn_001',
      sourceText: "If it rains tomorrow, we will stay at home.",
      targetText: "如果明天下雨，我们就待在家里。",
      alternativeAnswers: ["如果明天下雨，我们会留在家里。"],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.en2cn,
      keyPoints: ["if条件状语从句", "主将从现原则"],
      hints: ["注意：if从句用一般现在时，主句用一般将来时", "stay at home 待在家里"],
    ),
    const TranslationExercise(
      id: 'inter_en2cn_002',
      sourceText: "The book that I borrowed from the library is very interesting.",
      targetText: "我从图书馆借的那本书非常有趣。",
      alternativeAnswers: ["我从图书馆借来的这本书很有趣。"],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.en2cn,
      keyPoints: ["定语从句", "关系代词that"],
      hints: ["注意：that引导定语从句修饰the book", "borrow from 从...借"],
    ),
    const TranslationExercise(
      id: 'inter_en2cn_003',
      sourceText: "Not only does he study hard, but he also helps others.",
      targetText: "他不仅学习努力，而且还帮助别人。",
      alternativeAnswers: ["他不但学习刻苦，还帮助他人。"],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.en2cn,
      keyPoints: ["Not only...but also...句型", "倒装结构"],
      hints: ["注意：not only开头时，句子要部分倒装", "help others 帮助别人"],
    ),
    const TranslationExercise(
      id: 'inter_en2cn_004',
      sourceText: "It is said that the new policy will benefit millions of people.",
      targetText: "据说新政策将使数百万人受益。",
      alternativeAnswers: ["据说这项新政策会让数百万人获益。"],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.en2cn,
      keyPoints: ["It is said that... 据说...", "benefit 使受益"],
      hints: ["注意：It is said that...是固定句型", "millions of 数百万的"],
    ),
    const TranslationExercise(
      id: 'inter_en2cn_005',
      sourceText: "Hardly had I arrived home when it began to rain.",
      targetText: "我刚到家，天就开始下雨了。",
      alternativeAnswers: ["我一到家，就开始下雨了。"],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.en2cn,
      keyPoints: ["Hardly...when... 刚...就...", "过去完成时倒装"],
      hints: ["注意：hardly开头时，主句要部分倒装", "begin to rain 开始下雨"],
    ),
    const TranslationExercise(
      id: 'inter_en2cn_006',
      sourceText: "What matters most is not winning but participating.",
      targetText: "最重要的不是获胜，而是参与。",
      alternativeAnswers: ["最重要的不是赢，而是参与。"],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.en2cn,
      keyPoints: ["主语从句", "not...but... 不是...而是..."],
      hints: ["注意：what matters most是主语从句", "participate 参与"],
    ),
  ];

  // ==================== Intermediate CN→EN Exercises (高二) ====================
  static final List<TranslationExercise> _intermediateCn2EnExercises = [
    const TranslationExercise(
      id: 'inter_cn2en_001',
      sourceText: "尽管他很累，他还是坚持工作。",
      targetText: "Although he was very tired, he kept working.",
      alternativeAnswers: [
        "Though he was tired, he continued to work.",
        "Tired as he was, he insisted on working.",
      ],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.cn2en,
      keyPoints: ["although/though 尽管", "keep doing 坚持做"],
      hints: ["注意：although和but不能同时使用", "insist on doing 坚持做"],
    ),
    const TranslationExercise(
      id: 'inter_cn2en_002',
      sourceText: "这是我见过的最美丽的城市。",
      targetText: "This is the most beautiful city that I have ever seen.",
      alternativeAnswers: ["This is the most beautiful city I have ever visited."],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.cn2en,
      keyPoints: ["定语从句", "现在完成时", "最高级"],
      hints: ["注意：先行词有最高级修饰时，关系代词用that", "have ever seen 曾经见过"],
    ),
    const TranslationExercise(
      id: 'inter_cn2en_003',
      sourceText: "只有通过努力，你才能实现梦想。",
      targetText: "Only by working hard can you achieve your dream.",
      alternativeAnswers: [
        "Only through hard work can you realize your dream.",
      ],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.cn2en,
      keyPoints: ["Only+状语开头的倒装", "achieve one's dream 实现梦想"],
      hints: ["注意：only+状语开头时，句子要部分倒装", "work hard 努力学习/工作"],
    ),
    const TranslationExercise(
      id: 'inter_cn2en_004',
      sourceText: "他宁愿待在家里也不愿出去。",
      targetText: "He would rather stay at home than go out.",
      alternativeAnswers: [
        "He prefers to stay at home rather than go out.",
        "He would sooner stay home than go out.",
      ],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.cn2en,
      keyPoints: ["would rather...than... 宁愿...也不愿...", "prefer...rather than..."],
      hints: ["注意：would rather和than后面都用动词原形", "stay at home 待在家里"],
    ),
    const TranslationExercise(
      id: 'inter_cn2en_005',
      sourceText: "无论遇到什么困难，我都不会放弃。",
      targetText: "Whatever difficulties I meet, I will never give up.",
      alternativeAnswers: [
        "No matter what difficulties I encounter, I won't give up.",
      ],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.cn2en,
      keyPoints: ["whatever/no matter what 无论什么", "give up 放弃"],
      hints: ["注意：whatever引导让步状语从句", "give up 放弃"],
    ),
    const TranslationExercise(
      id: 'inter_cn2en_006',
      sourceText: "我们应该充分利用时间学习。",
      targetText: "We should make full use of time to study.",
      alternativeAnswers: [
        "We ought to take full advantage of time for studying.",
      ],
      difficulty: TranslationDifficulty.intermediate,
      direction: TranslationDirection.cn2en,
      keyPoints: ["make use of 利用", "take advantage of 利用"],
      hints: ["注意：make full use of 充分利用", "ought to = should"],
    ),
  ];

  // ==================== Advanced EN→CN Exercises (高三) ====================
  static final List<TranslationExercise> _advancedEn2CnExercises = [
    const TranslationExercise(
      id: 'adv_en2cn_001',
      sourceText: "Were it not for your help, I would have failed the exam.",
      targetText: "要不是你的帮助，我考试就会不及格了。",
      alternativeAnswers: ["如果没有你的帮助，我考试就失败了。"],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.en2cn,
      keyPoints: ["虚拟语气", "省略if的倒装", "与过去事实相反"],
      hints: ["注意：were it not for = if it were not for", "would have done 本会做（却没做）"],
    ),
    const TranslationExercise(
      id: 'adv_en2cn_002',
      sourceText: "The moment he heard the news, he rushed to the scene without hesitation.",
      targetText: "他一听到这个消息，就毫不犹豫地赶往现场。",
      alternativeAnswers: ["听到消息的那一刻，他立刻赶往现场。"],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.en2cn,
      keyPoints: ["the moment 一...就...", "without hesitation 毫不犹豫"],
      hints: ["注意：the moment可作连词引导时间状语从句", "rush to 赶往"],
    ),
    const TranslationExercise(
      id: 'adv_en2cn_003',
      sourceText: "It is high time that we took effective measures to protect the environment.",
      targetText: "是时候采取有效措施保护环境了。",
      alternativeAnswers: ["我们该采取有效措施来保护环境了。"],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.en2cn,
      keyPoints: ["It is high time that... 是时候...", "虚拟语气用过去式"],
      hints: ["注意：It is high time that从句中用过去式", "take measures 采取措施"],
    ),
    const TranslationExercise(
      id: 'adv_en2cn_004',
      sourceText: "So absorbed was he in reading that he didn't notice my arrival.",
      targetText: "他如此专注于阅读，以至于没有注意到我的到来。",
      alternativeAnswers: ["他读书如此入迷，以至于没注意到我来了。"],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.en2cn,
      keyPoints: ["so...that...如此...以至于...", "so开头引起的倒装"],
      hints: ["注意：so+形容词开头时，句子要部分倒装", "be absorbed in 专注于"],
    ),
    const TranslationExercise(
      id: 'adv_en2cn_005',
      sourceText: "Contrary to popular belief, success is not solely determined by intelligence.",
      targetText: "与普遍看法相反，成功并非完全由智力决定。",
      alternativeAnswers: ["与人们普遍认为的不同，成功不只取决于智商。"],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.en2cn,
      keyPoints: ["contrary to 与...相反", "be determined by 由...决定"],
      hints: ["注意：contrary to是介词短语", "solely = only 仅仅"],
    ),
    const TranslationExercise(
      id: 'adv_en2cn_006',
      sourceText: "Had he not been injured, he would have broken the world record.",
      targetText: "如果他没有受伤的话，他本会打破世界纪录的。",
      alternativeAnswers: ["要不是受伤，他就能打破世界纪录了。"],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.en2cn,
      keyPoints: ["虚拟语气", "省略if的倒装", "与过去事实相反"],
      hints: ["注意：had he not been = if he had not been", "break the record 打破纪录"],
    ),
  ];

  // ==================== Advanced CN→EN Exercises (高三) ====================
  static final List<TranslationExercise> _advancedCn2EnExercises = [
    const TranslationExercise(
      id: 'adv_cn2en_001',
      sourceText: "随着科技的发展，我们的生活发生了巨大的变化。",
      targetText: "With the development of science and technology, great changes have taken place in our life.",
      alternativeAnswers: [
        "As science and technology develop, tremendous changes have occurred in our lives.",
      ],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.cn2en,
      keyPoints: ["with复合结构", "take place 发生", "现在完成时"],
      hints: ["注意：with+名词+介词短语构成复合结构", "take place没有被动语态"],
    ),
    const TranslationExercise(
      id: 'adv_cn2en_002',
      sourceText: "这个问题值得进一步讨论。",
      targetText: "This problem is worth discussing further.",
      alternativeAnswers: [
        "This issue deserves to be discussed further.",
        "The problem is worthy of further discussion.",
      ],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.cn2en,
      keyPoints: ["be worth doing 值得做", "deserve to be done"],
      hints: ["注意：worth后面用主动形式表被动意义", "worthy of + 名词"],
    ),
    const TranslationExercise(
      id: 'adv_cn2en_003',
      sourceText: "他被认为是班上最优秀的学生之一。",
      targetText: "He is regarded as one of the best students in the class.",
      alternativeAnswers: [
        "He is considered to be one of the most excellent students in the class.",
      ],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.cn2en,
      keyPoints: ["be regarded as 被认为是", "one of + 最高级 + 复数名词"],
      hints: ["注意：one of后面接最高级+复数名词", "regard...as... 把...视为..."],
    ),
    const TranslationExercise(
      id: 'adv_cn2en_004',
      sourceText: "正是他的坚持不懈使他最终获得了成功。",
      targetText: "It was his perseverance that made him succeed in the end.",
      alternativeAnswers: [
        "It was his persistence that led to his eventual success.",
      ],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.cn2en,
      keyPoints: ["强调句 It is/was...that...", "perseverance 坚持不懈"],
      hints: ["注意：强调句结构It is/was+被强调部分+that+其他", "in the end 最终"],
    ),
    const TranslationExercise(
      id: 'adv_cn2en_005',
      sourceText: "如果当初听你的建议，我就不会犯这个错误了。",
      targetText: "If I had followed your advice, I wouldn't have made this mistake.",
      alternativeAnswers: [
        "Had I taken your advice, I wouldn't have committed this error.",
      ],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.cn2en,
      keyPoints: ["虚拟语气", "与过去事实相反", "省略if的倒装"],
      hints: ["注意：与过去事实相反，从句用had done，主句用would have done", "follow one's advice 听从建议"],
    ),
    const TranslationExercise(
      id: 'adv_cn2en_006',
      sourceText: "只有在失去后，我们才懂得珍惜。",
      targetText: "Only after we lose something do we learn to cherish it.",
      alternativeAnswers: [
        "Only when we have lost it do we come to value it.",
      ],
      difficulty: TranslationDifficulty.advanced,
      direction: TranslationDirection.cn2en,
      keyPoints: ["Only+状语开头的倒装", "learn to do 学会做"],
      hints: ["注意：only+状语开头时，主句要部分倒装", "cherish = value 珍惜"],
    ),
  ];
}
