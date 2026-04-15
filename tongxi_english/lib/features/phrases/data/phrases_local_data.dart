import '../../../models/phrase_model.dart';

/// Local data source for phrases with hardcoded sample data
/// 
/// Contains 40+ phrases organized by categories aligned with
/// 人教版高中英语 curriculum.
class PhrasesLocalData {
  PhrasesLocalData._();

  /// All phrases organized by category
  static final List<PhraseModel> allPhrases = [
    // ==================== Daily Conversations (日常对话) ====================
    PhraseModel(
      id: 'phrase_001',
      phrase: "How's it going?",
      translation: '最近怎么样？',
      meaning: '用于询问对方近况，非正式场合',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: "Hey Tom, how's it going?",
          translation: '嘿汤姆，最近怎么样？',
          context: 'greeting',
        ),
        PhraseExample(
          sentence: "How's it going with your new job?",
          translation: '你的新工作怎么样？',
          context: 'asking about situation',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['How are you?', "What's up?"],
    ),
    PhraseModel(
      id: 'phrase_002',
      phrase: 'Long time no see',
      translation: '好久不见',
      meaning: '用于久别重逢时的问候',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Long time no see! You look great!',
          translation: '好久不见！你看起来气色很好！',
          context: 'greeting after long time',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['I haven\'t seen you for ages'],
    ),
    PhraseModel(
      id: 'phrase_003',
      phrase: 'Take it easy',
      translation: '放轻松，别紧张',
      meaning: '用于安慰他人，让对方放松',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Take it easy, the exam is not that hard.',
          translation: '放轻松，考试没那么难。',
          context: 'comforting',
        ),
        PhraseExample(
          sentence: 'Take it easy on yourself.',
          translation: '对自己宽容一点。',
          context: 'advice',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Calm down', 'Relax'],
    ),
    PhraseModel(
      id: 'phrase_004',
      phrase: 'Catch up',
      translation: '叙旧，了解近况',
      meaning: '与某人交谈以了解他们的近况',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'We should catch up sometime.',
          translation: '我们应该找个时间叙叙旧。',
          context: 'making plans',
        ),
        PhraseExample(
          sentence: 'Let me catch you up on what happened.',
          translation: '让我告诉你发生了什么。',
          context: 'informing',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Keep in touch', 'Stay in contact'],
    ),
    PhraseModel(
      id: 'phrase_005',
      phrase: 'By the way',
      translation: '顺便说一下',
      meaning: '用于引入一个新话题或附带提及',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'By the way, have you finished your homework?',
          translation: '顺便问一下，你完成作业了吗？',
          context: 'changing topic',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Incidentally', 'Speaking of which'],
    ),
    PhraseModel(
      id: 'phrase_006',
      phrase: 'In the meantime',
      translation: '在此期间，与此同时',
      meaning: '在某事发生之前的时间段内',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'The food will be ready in 30 minutes. In the meantime, you can watch TV.',
          translation: '食物30分钟后好。在此期间，你可以看电视。',
          context: 'filling time',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Meanwhile', 'In the meanwhile'],
    ),
    PhraseModel(
      id: 'phrase_007',
      phrase: 'Make sense',
      translation: '有意义，讲得通',
      meaning: '合乎逻辑或容易理解',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'Does this sentence make sense?',
          translation: '这个句子讲得通吗？',
          context: 'checking understanding',
        ),
        PhraseExample(
          sentence: 'It makes sense to study hard for the exam.',
          translation: '为考试努力学习是明智的。',
          context: 'expressing logic',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Be logical', 'Be reasonable'],
    ),
    PhraseModel(
      id: 'phrase_008',
      phrase: 'Figure out',
      translation: '弄明白，解决',
      meaning: '理解或找到解决问题的方法',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'I need to figure out how to solve this problem.',
          translation: '我需要弄明白如何解决这个问题。',
          context: 'problem solving',
        ),
        PhraseExample(
          sentence: 'Can you figure out what he meant?',
          translation: '你能明白他的意思吗？',
          context: 'understanding',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Work out', 'Find out'],
    ),

    // ==================== Academic/School (学术/校园) ====================
    PhraseModel(
      id: 'phrase_009',
      phrase: 'Pay attention to',
      translation: '注意，关注',
      meaning: '集中精力于某事',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'Please pay attention to the teacher.',
          translation: '请注意听老师讲课。',
          context: 'classroom',
        ),
        PhraseExample(
          sentence: 'You should pay attention to your spelling.',
          translation: '你应该注意你的拼写。',
          context: 'advice',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Focus on', 'Concentrate on'],
    ),
    PhraseModel(
      id: 'phrase_010',
      phrase: 'Take notes',
      translation: '做笔记',
      meaning: '记录重要信息',
      contexts: ['formal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Don\'t forget to take notes during the lecture.',
          translation: '别忘了在讲座期间做笔记。',
          context: 'studying',
        ),
        PhraseExample(
          sentence: 'I always take notes when reading textbooks.',
          translation: '我读课本时总是做笔记。',
          context: 'studying',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Write down', 'Jot down'],
    ),
    PhraseModel(
      id: 'phrase_011',
      phrase: 'Hand in',
      translation: '上交，提交',
      meaning: '提交作业或文件',
      contexts: ['formal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Please hand in your homework by Friday.',
          translation: '请在周五前上交作业。',
          context: 'classroom',
        ),
        PhraseExample(
          sentence: 'Have you handed in your application form?',
          translation: '你交申请表了吗？',
          context: 'administrative',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Turn in', 'Submit'],
    ),
    PhraseModel(
      id: 'phrase_012',
      phrase: 'Look up',
      translation: '查阅，查找',
      meaning: '在词典或参考资料中查找信息',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'If you don\'t know the word, look it up in the dictionary.',
          translation: '如果你不认识这个词，查一下字典。',
          context: 'studying',
        ),
        PhraseExample(
          sentence: 'I need to look up some information for my essay.',
          translation: '我需要为论文查找一些资料。',
          context: 'research',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Search for', 'Consult'],
    ),
    PhraseModel(
      id: 'phrase_013',
      phrase: 'Go over',
      translation: '复习，仔细检查',
      meaning: '仔细检查或复习某事',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Let\'s go over the answers together.',
          translation: '让我们一起复习答案。',
          context: 'studying',
        ),
        PhraseExample(
          sentence: 'I need to go over my notes before the exam.',
          translation: '考试前我需要复习笔记。',
          context: 'exam preparation',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Review', 'Check over'],
    ),
    PhraseModel(
      id: 'phrase_014',
      phrase: 'Catch on',
      translation: '理解，流行',
      meaning: '开始理解或变得流行',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'It took me a while to catch on to the joke.',
          translation: '我过了一会儿才明白这个笑话。',
          context: 'understanding',
        ),
        PhraseExample(
          sentence: 'This new trend is starting to catch on.',
          translation: '这种新趋势开始流行起来。',
          context: 'trends',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Understand', 'Become popular'],
    ),
    PhraseModel(
      id: 'phrase_015',
      phrase: 'Keep up with',
      translation: '跟上，不落后于',
      meaning: '保持同步，不落后',
      contexts: ['formal', 'informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'It\'s hard to keep up with all the homework.',
          translation: '很难跟上所有的作业。',
          context: 'studying',
        ),
        PhraseExample(
          sentence: 'You need to keep up with the latest news.',
          translation: '你需要跟上最新的新闻。',
          context: 'staying informed',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Stay current with', 'Keep pace with'],
    ),
    PhraseModel(
      id: 'phrase_016',
      phrase: 'Fall behind',
      translation: '落后',
      meaning: '未能保持应有的进度',
      contexts: ['formal', 'informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'If you miss classes, you\'ll fall behind.',
          translation: '如果你缺课，你会落后的。',
          context: 'academic warning',
        ),
        PhraseExample(
          sentence: 'Don\'t let yourself fall behind with payments.',
          translation: '别让自己拖欠付款。',
          context: 'financial',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Lag behind', 'Get behind'],
    ),

    // ==================== Travel (旅行) ====================
    PhraseModel(
      id: 'phrase_017',
      phrase: 'Check in',
      translation: '办理入住/登机手续',
      meaning: '在酒店登记入住或在机场办理登机',
      contexts: ['formal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'We need to check in at the hotel by 3 PM.',
          translation: '我们需要在下午3点前在酒店办理入住。',
          context: 'hotel',
        ),
        PhraseExample(
          sentence: 'Please check in at least two hours before your flight.',
          translation: '请在航班起飞前两小时办理登机手续。',
          context: 'airport',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Check out', 'Register'],
    ),
    PhraseModel(
      id: 'phrase_018',
      phrase: 'Set off',
      translation: '出发，启程',
      meaning: '开始旅程',
      contexts: ['formal', 'informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'We set off early in the morning to avoid traffic.',
          translation: '我们一大早出发以避开交通高峰。',
          context: 'travel',
        ),
        PhraseExample(
          sentence: 'What time did you set off?',
          translation: '你几点出发的？',
          context: 'asking about departure',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Set out', 'Depart', 'Leave'],
    ),
    PhraseModel(
      id: 'phrase_019',
      phrase: 'Get around',
      translation: '四处走动，出行',
      meaning: '在城市或地方移动',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'It\'s easy to get around the city by subway.',
          translation: '乘地铁在这个城市出行很方便。',
          context: 'transportation',
        ),
        PhraseExample(
          sentence: 'How do you get around without a car?',
          translation: '没有车你怎么出行？',
          context: 'transportation',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Move around', 'Travel around'],
    ),
    PhraseModel(
      id: 'phrase_020',
      phrase: 'Look forward to',
      translation: '期待',
      meaning: '兴奋地等待某事',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'I\'m looking forward to the trip.',
          translation: '我很期待这次旅行。',
          context: 'expressing excitement',
        ),
        PhraseExample(
          sentence: 'We look forward to meeting you.',
          translation: '我们期待见到你。',
          context: 'formal correspondence',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Anticipate', 'Expect eagerly'],
    ),
    PhraseModel(
      id: 'phrase_021',
      phrase: 'Run out of',
      translation: '用完，耗尽',
      meaning: '某物被用完',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'We\'ve run out of gas.',
          translation: '我们的汽油用完了。',
          context: 'travel emergency',
        ),
        PhraseExample(
          sentence: 'I\'m running out of time.',
          translation: '我的时间快用完了。',
          context: 'time pressure',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Use up', 'Exhaust'],
    ),
    PhraseModel(
      id: 'phrase_022',
      phrase: 'Take off',
      translation: '起飞，脱下',
      meaning: '飞机离开地面或脱掉衣物',
      contexts: ['formal', 'informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'The plane will take off in 10 minutes.',
          translation: '飞机将在10分钟后起飞。',
          context: 'airport',
        ),
        PhraseExample(
          sentence: 'Please take off your shoes before entering.',
          translation: '进入前请脱鞋。',
          context: 'customs',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Depart', 'Remove'],
    ),
    PhraseModel(
      id: 'phrase_023',
      phrase: 'Get lost',
      translation: '迷路',
      meaning: '找不到路',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'We got lost in the old town.',
          translation: '我们在老城区迷路了。',
          context: 'travel problem',
        ),
        PhraseExample(
          sentence: 'Don\'t get lost!',
          translation: '别迷路了！',
          context: 'warning',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Lose one\'s way', 'Go astray'],
    ),
    PhraseModel(
      id: 'phrase_024',
      phrase: 'See the sights',
      translation: '观光，游览',
      meaning: '参观著名景点',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'We spent the day seeing the sights.',
          translation: '我们花了一天时间观光。',
          context: 'tourism',
        ),
        PhraseExample(
          sentence: 'There are many sights to see in Beijing.',
          translation: '北京有很多景点可以看。',
          context: 'recommendation',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Go sightseeing', 'Visit attractions'],
    ),

    // ==================== Emotions (情感表达) ====================
    PhraseModel(
      id: 'phrase_025',
      phrase: 'Cheer up',
      translation: '振作起来',
      meaning: '让某人感觉更好',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Cheer up! Things will get better.',
          translation: '振作起来！事情会好起来的。',
          context: 'comforting',
        ),
        PhraseExample(
          sentence: 'I bought you ice cream to cheer you up.',
          translation: '我给你买了冰淇淋让你开心。',
          context: 'comforting',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Feel better', 'Perk up'],
    ),
    PhraseModel(
      id: 'phrase_026',
      phrase: 'Calm down',
      translation: '冷静下来',
      meaning: '变得不那么激动或生气',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Calm down and tell me what happened.',
          translation: '冷静下来告诉我发生了什么。',
          context: 'managing emotions',
        ),
        PhraseExample(
          sentence: 'Take a deep breath to calm down.',
          translation: '深呼吸冷静下来。',
          context: 'advice',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Relax', 'Settle down'],
    ),
    PhraseModel(
      id: 'phrase_027',
      phrase: 'Freak out',
      translation: '惊慌失措',
      meaning: '变得非常焦虑或害怕',
      contexts: ['informal', 'spoken', 'slang'],
      examples: [
        PhraseExample(
          sentence: 'Don\'t freak out, but I lost your book.',
          translation: '别慌，但我把你的书弄丢了。',
          context: 'breaking bad news',
        ),
        PhraseExample(
          sentence: 'She freaked out when she saw the spider.',
          translation: '她看到蜘蛛时吓坏了。',
          context: 'reacting to fear',
        ),
      ],
      category: PhraseCategory.slang,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Panic', 'Lose it'],
    ),
    PhraseModel(
      id: 'phrase_028',
      phrase: 'Break down',
      translation: '情绪崩溃，出故障',
      meaning: '失去情绪控制或机器停止工作',
      contexts: ['formal', 'informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'She broke down in tears.',
          translation: '她崩溃大哭。',
          context: 'emotional breakdown',
        ),
        PhraseExample(
          sentence: 'The car broke down on the highway.',
          translation: '车在高速公路上抛锚了。',
          context: 'mechanical failure',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Collapse', 'Stop working'],
    ),
    PhraseModel(
      id: 'phrase_029',
      phrase: 'Be fed up with',
      translation: '受够了，厌烦',
      meaning: '对某事感到厌烦',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'I\'m fed up with this weather.',
          translation: '我受够了这种天气。',
          context: 'expressing frustration',
        ),
        PhraseExample(
          sentence: 'She\'s fed up with his excuses.',
          translation: '她受够了他的借口。',
          context: 'expressing frustration',
        ),
      ],
      category: PhraseCategory.idiom,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Be tired of', 'Be sick of'],
    ),
    PhraseModel(
      id: 'phrase_030',
      phrase: 'Be over the moon',
      translation: '欣喜若狂',
      meaning: '非常高兴',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'She was over the moon about her exam results.',
          translation: '她对考试成绩欣喜若狂。',
          context: 'expressing joy',
        ),
        PhraseExample(
          sentence: 'I\'m over the moon that you\'re coming!',
          translation: '你要来我太高兴了！',
          context: 'expressing joy',
        ),
      ],
      category: PhraseCategory.idiom,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Ecstatic', 'Thrilled', 'On cloud nine'],
    ),
    PhraseModel(
      id: 'phrase_031',
      phrase: 'Get along with',
      translation: '与...相处融洽',
      meaning: '与某人有良好关系',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Do you get along with your classmates?',
          translation: '你和同学相处得好吗？',
          context: 'relationships',
        ),
        PhraseExample(
          sentence: 'I get along well with my roommate.',
          translation: '我和室友相处得很好。',
          context: 'relationships',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Get on with', 'Have a good relationship with'],
    ),
    PhraseModel(
      id: 'phrase_032',
      phrase: 'Put up with',
      translation: '忍受，容忍',
      meaning: '接受不愉快的情况',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'I can\'t put up with this noise anymore.',
          translation: '我再也无法忍受这种噪音了。',
          context: 'expressing intolerance',
        ),
        PhraseExample(
          sentence: 'How do you put up with him?',
          translation: '你怎么能忍受他？',
          context: 'asking about tolerance',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Tolerate', 'Stand', 'Bear'],
    ),

    // ==================== Collocations (固定搭配) ====================
    PhraseModel(
      id: 'phrase_033',
      phrase: 'Make a decision',
      translation: '做决定',
      meaning: '决定做某事',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'I need to make a decision about my major.',
          translation: '我需要决定我的专业。',
          context: 'planning',
        ),
        PhraseExample(
          sentence: 'Have you made a decision yet?',
          translation: '你做决定了吗？',
          context: 'asking',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Decide', 'Make up one\'s mind'],
    ),
    PhraseModel(
      id: 'phrase_034',
      phrase: 'Take responsibility',
      translation: '承担责任',
      meaning: '对自己的行为负责',
      contexts: ['formal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'You should take responsibility for your actions.',
          translation: '你应该为自己的行为负责。',
          context: 'advice',
        ),
        PhraseExample(
          sentence: 'He took full responsibility for the mistake.',
          translation: '他对这个错误承担了全部责任。',
          context: 'accountability',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Be responsible', 'Accept blame'],
    ),
    PhraseModel(
      id: 'phrase_035',
      phrase: 'Have an impact on',
      translation: '对...有影响',
      meaning: '对某事产生效果或改变',
      contexts: ['formal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'Social media has a big impact on teenagers.',
          translation: '社交媒体对青少年有很大影响。',
          context: 'discussing effects',
        ),
        PhraseExample(
          sentence: 'The new policy will have an impact on education.',
          translation: '新政策将对教育产生影响。',
          context: 'discussing effects',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Affect', 'Influence', 'Have an effect on'],
    ),
    PhraseModel(
      id: 'phrase_036',
      phrase: 'Play a role in',
      translation: '在...中发挥作用',
      meaning: '参与并影响某事',
      contexts: ['formal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'Parents play an important role in education.',
          translation: '父母在教育中发挥重要作用。',
          context: 'discussing importance',
        ),
        PhraseExample(
          sentence: 'Technology plays a key role in modern life.',
          translation: '技术在现代生活中扮演关键角色。',
          context: 'discussing importance',
        ),
      ],
      category: PhraseCategory.collocation,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Be involved in', 'Contribute to'],
    ),
    PhraseModel(
      id: 'phrase_037',
      phrase: 'Come up with',
      translation: '想出，提出',
      meaning: '产生想法或解决方案',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Can you come up with a better idea?',
          translation: '你能想出更好的主意吗？',
          context: 'problem solving',
        ),
        PhraseExample(
          sentence: 'She came up with a brilliant solution.',
          translation: '她想出了一个绝妙的解决方案。',
          context: 'problem solving',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Think of', 'Devise', 'Create'],
    ),
    PhraseModel(
      id: 'phrase_038',
      phrase: 'Deal with',
      translation: '处理，应对',
      meaning: '处理问题或情况',
      contexts: ['formal', 'informal', 'spoken', 'written'],
      examples: [
        PhraseExample(
          sentence: 'I\'ll deal with this problem tomorrow.',
          translation: '我明天会处理这个问题。',
          context: 'problem solving',
        ),
        PhraseExample(
          sentence: 'She knows how to deal with difficult customers.',
          translation: '她知道如何应对难缠的客户。',
          context: 'handling situations',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Handle', 'Manage', 'Cope with'],
    ),
    PhraseModel(
      id: 'phrase_039',
      phrase: 'Give up',
      translation: '放弃',
      meaning: '停止尝试',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Never give up on your dreams.',
          translation: '永远不要放弃你的梦想。',
          context: 'encouragement',
        ),
        PhraseExample(
          sentence: 'He gave up smoking last year.',
          translation: '他去年戒烟了。',
          context: 'quitting habits',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 1,
      audioUrl: '',
      relatedPhrases: ['Quit', 'Stop trying', 'Abandon'],
    ),
    PhraseModel(
      id: 'phrase_040',
      phrase: 'Turn out',
      translation: '结果是，证明是',
      meaning: '以某种方式发展或被发现',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'It turned out to be a great day.',
          translation: '结果是很棒的一天。',
          context: 'outcome',
        ),
        PhraseExample(
          sentence: 'As it turned out, he was right.',
          translation: '结果证明他是对的。',
          context: 'outcome',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 3,
      audioUrl: '',
      relatedPhrases: ['Result', 'Prove to be', 'End up'],
    ),
    PhraseModel(
      id: 'phrase_041',
      phrase: 'Run into',
      translation: '偶遇，撞上',
      meaning: '偶然遇见或遇到困难',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'I ran into an old friend at the mall.',
          translation: '我在商场偶遇了一位老朋友。',
          context: 'unexpected meeting',
        ),
        PhraseExample(
          sentence: 'We ran into some problems with the project.',
          translation: '我们在项目上遇到了一些问题。',
          context: 'encountering difficulties',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Meet by chance', 'Encounter', 'Bump into'],
    ),
    PhraseModel(
      id: 'phrase_042',
      phrase: 'Put off',
      translation: '推迟，拖延',
      meaning: '延迟做某事',
      contexts: ['informal', 'spoken'],
      examples: [
        PhraseExample(
          sentence: 'Don\'t put off your homework.',
          translation: '不要拖延作业。',
          context: 'warning',
        ),
        PhraseExample(
          sentence: 'The meeting was put off until next week.',
          translation: '会议被推迟到下周。',
          context: 'rescheduling',
        ),
      ],
      category: PhraseCategory.phrasalVerb,
      difficulty: 2,
      audioUrl: '',
      relatedPhrases: ['Postpone', 'Delay', 'Put back'],
    ),
  ];

  /// Get phrases by category name
  static List<PhraseModel> getPhrasesByCategory(String categoryName) {
    final categoryMap = {
      'daily': '日常对话',
      'academic': '学术/校园',
      'travel': '旅行',
      'emotions': '情感表达',
      'collocations': '固定搭配',
    };
    
    // Map category names to phrase indices for filtering
    final categoryRanges = {
      'daily': [0, 7],
      'academic': [8, 15],
      'travel': [16, 23],
      'emotions': [24, 31],
      'collocations': [32, 41],
    };
    
    final range = categoryRanges[categoryName];
    if (range != null) {
      return allPhrases.sublist(range[0], range[1] + 1);
    }
    return allPhrases;
  }

  /// Get all categories with their phrases
  static Map<String, List<PhraseModel>> get categorizedPhrases => {
    'daily': getPhrasesByCategory('daily'),
    'academic': getPhrasesByCategory('academic'),
    'travel': getPhrasesByCategory('travel'),
    'emotions': getPhrasesByCategory('emotions'),
    'collocations': getPhrasesByCategory('collocations'),
  };

  /// Category display names
  static const Map<String, String> categoryNames = {
    'daily': '日常对话',
    'academic': '学术/校园',
    'travel': '旅行',
    'emotions': '情感表达',
    'collocations': '固定搭配',
  };

  /// Get phrase by ID
  static PhraseModel? getPhraseById(String id) {
    try {
      return allPhrases.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get random phrases for practice
  static List<PhraseModel> getRandomPhrases(int count) {
    final shuffled = List<PhraseModel>.from(allPhrases)..shuffle();
    return shuffled.take(count).toList();
  }
}
