import '../../../models/grammar_model.dart';

/// Local data source for grammar rules with hardcoded content
/// 
/// Contains 15+ grammar points organized by high school year:
/// - 高一: Present/Past Tenses, Modal Verbs, Subject-Verb Agreement, Attributive Clauses
/// - 高二: Subjunctive Mood, Non-finite Verbs, Noun Clauses, Emphasis Structures
/// - 高三: Adverbial Clauses, Inversion, Special Sentence Patterns, Comprehensive Review
class GrammarLocalData {
  GrammarLocalData._();

  /// All grammar rules organized by grade level
  static final List<GrammarModel> allGrammarRules = [
    // ==================== 高一 (Grade 10) ====================
    
    // Present Tenses
    GrammarModel(
      id: 'grammar_001',
      title: 'Present Simple & Present Continuous',
      titleCn: '一般现在时与现在进行时',
      explanation: '''
**一般现在时 (Present Simple)**
- 表示经常性、习惯性的动作或状态
- 表示客观事实、真理
- 时间状语：always, usually, often, sometimes, every day

**现在进行时 (Present Continuous)**
- 表示此时此刻正在进行的动作
- 表示现阶段正在进行的动作
- 时间状语：now, at the moment, these days
- 结构：am/is/are + doing

**注意**：某些动词（如 like, know, want, need, belong）通常不用于进行时
      ''',
      keyPoints: [
        '一般现在时第三人称单数动词加 -s/-es',
        '现在进行时 be 动词随主语变化',
        '状态动词通常不用进行时',
        '现在进行时可表示计划好的将来',
      ],
      examples: [
        GrammarExample(
          correct: 'I usually go to school by bus.',
          explanation: '一般现在时表示习惯性动作',
        ),
        GrammarExample(
          correct: 'She is reading a book now.',
          explanation: '现在进行时表示正在进行的动作',
        ),
        GrammarExample(
          correct: 'The earth goes around the sun.',
          explanation: '一般现在时表示客观真理',
        ),
        GrammarExample(
          correct: 'I am meeting him tomorrow.',
          explanation: '现在进行时表示计划好的将来',
        ),
      ],
      commonMistakes: [
        '❌ She is liking music. → ✅ She likes music.（like 是状态动词，不用进行时）',
        '❌ He go to school every day. → ✅ He goes to school every day.（第三人称单数要加 -es）',
        '❌ I am go to school. → ✅ I am going to school.（进行时要用 doing 形式）',
      ],
      category: GrammarCategory.tenses,
      difficulty: 1,
      relatedRules: ['grammar_002', 'grammar_003'],
    ),

    // Past Tenses
    GrammarModel(
      id: 'grammar_002',
      title: 'Past Simple & Past Continuous',
      titleCn: '一般过去时与过去进行时',
      explanation: '''
**一般过去时 (Past Simple)**
- 表示过去某个时间发生的动作或存在的状态
- 表示过去经常发生的动作
- 规则动词加 -ed，不规则动词需记忆

**过去进行时 (Past Continuous)**
- 表示过去某一时刻正在进行的动作
- 表示过去某段时间内持续进行的动作
- 结构：was/were + doing

**过去进行时 vs 一般过去时**
- 过去进行时表示背景动作，一般过去时表示打断的动作
- When/While 引导的时间状语从句
      ''',
      keyPoints: [
        '一般过去时动词要用过去式',
        '过去进行时 was/were 的选择看主语',
        'when 引导的从句常用一般过去时',
        'while 引导的从句常用过去进行时',
      ],
      examples: [
        GrammarExample(
          correct: 'I watched TV yesterday evening.',
          explanation: '一般过去时表示过去发生的动作',
        ),
        GrammarExample(
          correct: 'At 8 o\'clock last night, I was doing my homework.',
          explanation: '过去进行时表示过去某时刻正在进行的动作',
        ),
        GrammarExample(
          correct: 'While I was walking, I saw an old friend.',
          explanation: 'while 从句用进行时，主句用一般过去时',
        ),
        GrammarExample(
          correct: 'When the phone rang, I was having dinner.',
          explanation: 'when 从句用一般过去时，主句用过去进行时',
        ),
      ],
      commonMistakes: [
        '❌ I was see him yesterday. → ✅ I saw him yesterday.（see 是瞬间动词，不用进行时）',
        '❌ When I was walking in the park, it was starting to rain. → ✅ When I was walking in the park, it started to rain.（start 是瞬间动作，不用进行时）',
        '❌ I didn\'t went to school. → ✅ I didn\'t go to school.（did 后接动词原形）',
      ],
      category: GrammarCategory.tenses,
      difficulty: 1,
      relatedRules: ['grammar_001', 'grammar_003'],
    ),

    // Present Perfect
    GrammarModel(
      id: 'grammar_003',
      title: 'Present Perfect Tense',
      titleCn: '现在完成时',
      explanation: '''
**现在完成时 (Present Perfect)**
- 表示过去发生的动作对现在造成的影响
- 表示从过去开始持续到现在的动作或状态
- 结构：have/has + 过去分词 (done)

**时间状语**
- already, yet, just, ever, never
- for + 时间段, since + 时间点
- so far, up to now, in the past/last few years

**have been to vs have gone to**
- have been to：去过某地（已回）
- have gone to：去了某地（未回）
      ''',
      keyPoints: [
        'have/has 的选择看主语是否为第三人称单数',
        '过去分词规则变化加 -ed，不规则需记忆',
        '瞬间动词不能与 for/since 连用表示持续',
        '延续性动词可与 for/since 连用',
      ],
      examples: [
        GrammarExample(
          correct: 'I have finished my homework.',
          explanation: '现在完成时表示动作已完成并对现在有影响',
        ),
        GrammarExample(
          correct: 'She has lived here for ten years.',
          explanation: '现在完成时表示从过去持续到现在的状态',
        ),
        GrammarExample(
          correct: 'Have you ever been to Beijing?',
          explanation: '现在完成时询问经历',
        ),
        GrammarExample(
          correct: 'He has gone to Shanghai. (He is not here now.)',
          explanation: 'have gone to 表示去了未回',
        ),
      ],
      commonMistakes: [
        '❌ He has gone to Beijing twice. → ✅ He has been to Beijing twice.（去过用 been）',
        '❌ I have bought this book for two years. → ✅ I have had this book for two years.（buy 是瞬间动词，不能持续）',
        '❌ She has married for five years. → ✅ She has been married for five years.（marry 是瞬间动词）',
      ],
      category: GrammarCategory.tenses,
      difficulty: 2,
      relatedRules: ['grammar_001', 'grammar_002'],
    ),

    // Modal Verbs
    GrammarModel(
      id: 'grammar_004',
      title: 'Modal Verbs',
      titleCn: '情态动词',
      explanation: '''
**情态动词的特点**
- 后接动词原形
- 无人称和数的变化（除 have to）
- 否定形式直接加 not

**常见情态动词的用法**

**can/could**
- 能力：I can swim.
- 许可：You can go now.
- 请求：Can/Could you help me?

**may/might**
- 许可：You may leave now.
- 可能：It may rain tomorrow.
- might 比 may 可能性更小

**must/have to**
- must：主观必须，否定 mustn't 表示禁止
- have to：客观必须，否定 don't have to 表示不必

**should/ought to**
- 应该，表示建议或义务
- ought to 语气比 should 稍强

**need/dare**
- 既可以是情态动词也可以是实义动词
- 作情态动词：Need I go? / Dare he try?
- 作实义动词：I need to go. / He dares to try.
      ''',
      keyPoints: [
        '情态动词后接动词原形',
        'mustn\'t ≠ don\'t have to',
        'could/might 可用于虚拟语气',
        'should have done 表示本应该做而未做',
      ],
      examples: [
        GrammarExample(
          correct: 'You mustn\'t smoke here. (禁止)',
          explanation: 'mustn\'t 表示禁止',
        ),
        GrammarExample(
          correct: 'You don\'t have to come if you\'re busy. (不必)',
          explanation: 'don\'t have to 表示不必',
        ),
        GrammarExample(
          correct: 'He should have told me the truth.',
          explanation: 'should have done 表示本应该做而未做',
        ),
        GrammarExample(
          correct: 'Could you please open the window?',
          explanation: 'could 表示委婉请求',
        ),
      ],
      commonMistakes: [
        '❌ You mustn\'t finish it today. → ✅ You don\'t have to finish it today.（不必用 don\'t have to）',
        '❌ He can swims. → ✅ He can swim.（情态动词后接原形）',
        '❌ Must you go now? No, you mustn\'t. → ✅ No, you needn\'t.（must 疑问句否定回答用 needn\'t）',
      ],
      category: GrammarCategory.modalVerbs,
      difficulty: 2,
      relatedRules: ['grammar_005'],
    ),

    // Subject-Verb Agreement
    GrammarModel(
      id: 'grammar_005',
      title: 'Subject-Verb Agreement',
      titleCn: '主谓一致',
      explanation: '''
**主谓一致的基本原则**
- 主语是单数，谓语用单数
- 主语是复数，谓语用复数

**特殊情况**

**集合名词**
- family, team, class, group 等
- 强调整体时用单数，强调成员时用复数

**不定代词**
- each, either, neither, everyone, someone 等用单数
- both, few, many, several 用复数
- all, some, most, none 看指代对象

**就远/就近原则**
- with, together with, as well as, besides 等用就远原则
- either...or, neither...nor, not only...but also 用就近原则

**分数/百分数 + of + 名词**
- 谓语动词与 of 后的名词一致

**the + 形容词**
- 表示一类人时用复数
      ''',
      keyPoints: [
        '集体名词根据意义确定单复数',
        '不定代词 each, every, either, neither 接单数',
        'with/as well as 等用就远原则',
        'either...or/neither...nor 用就近原则',
      ],
      examples: [
        GrammarExample(
          correct: 'The family is listening to the radio.',
          explanation: 'family 强调整体，谓语用单数',
        ),
        GrammarExample(
          correct: 'The family are watching TV.',
          explanation: 'family 强调成员，谓语用复数',
        ),
        GrammarExample(
          correct: 'Tom, together with his parents, is going to Beijing.',
          explanation: 'together with 用就远原则，谓语与 Tom 一致',
        ),
        GrammarExample(
          correct: 'Neither you nor he is wrong.',
          explanation: 'neither...nor 用就近原则，谓语与 he 一致',
        ),
      ],
      commonMistakes: [
        '❌ Every student have a book. → ✅ Every student has a book.（every 接单数）',
        '❌ The number of students are increasing. → ✅ The number of students is increasing.（the number of 接单数）',
        '❌ A number of students is absent. → ✅ A number of students are absent.（a number of 接复数）',
      ],
      category: GrammarCategory.articles,
      difficulty: 2,
      relatedRules: [],
    ),

    // Attributive Clauses
    GrammarModel(
      id: 'grammar_006',
      title: 'Attributive Clauses (定语从句)',
      titleCn: '定语从句',
      explanation: '''
**定语从句概述**
- 修饰名词或代词的从句
- 先行词 + 关系词 + 从句

**关系代词**
- who/whom：指人，who 作主语/宾语，whom 作宾语
- which：指物，可作主语/宾语
- that：指人或物，可作主语/宾语
- whose：指人或物，作定语

**关系副词**
- when：指时间
- where：指地点
- why：指原因

**限制性 vs 非限制性定语从句**
- 限制性：不用逗号隔开，起限定作用
- 非限制性：用逗号隔开，起补充说明作用，不能用 that

**只用 that 的情况**
- 先行词是不定代词 all, little, much 等
- 先行词被序数词、最高级修饰
- 先行词既有人又有物
- 主句是以 who/which 开头的疑问句

**介词 + 关系代词**
- 指人用 whom，指物用 which
- 介词的选择看从句中的搭配
      ''',
      keyPoints: [
        '关系代词在从句中充当成分',
        'that 可指人指物，which 只能指物',
        '非限制性定语从句不能用 that',
        '介词后指人用 whom，指物用 which',
      ],
      examples: [
        GrammarExample(
          correct: 'The man who/that is talking to Mary is my teacher.',
          explanation: 'who/that 指人，在从句中作主语',
        ),
        GrammarExample(
          correct: 'This is the book which/that I bought yesterday.',
          explanation: 'which/that 指物，在从句中作宾语',
        ),
        GrammarExample(
          correct: 'I still remember the day when we first met.',
          explanation: 'when 指时间，相当于 on which',
        ),
        GrammarExample(
          correct: 'The boy, who is my brother, is very tall.',
          explanation: '非限制性定语从句用逗号隔开',
        ),
      ],
      commonMistakes: [
        '❌ This is the house which I lived. → ✅ This is the house in which I lived. / This is the house which I lived in.（live 是不及物动词，需要介词）',
        '❌ The reason is because... → ✅ The reason is that...（reason 作主语时表语从句用 that）',
        '❌ He is the only one of the students who have passed. → ✅ He is the only one of the students who has passed.（先行词是 the only one，谓语用单数）',
      ],
      category: GrammarCategory.relativeClauses,
      difficulty: 3,
      relatedRules: ['grammar_010'],
    ),

    // ==================== 高二 (Grade 11) ====================

    // Subjunctive Mood
    GrammarModel(
      id: 'grammar_007',
      title: 'Subjunctive Mood (虚拟语气)',
      titleCn: '虚拟语气',
      explanation: '''
**虚拟语气概述**
- 表示与事实相反或不可能实现的愿望、假设

**if 条件句的虚拟语气**

| 时间 | 从句 | 主句 |
|------|------|------|
| 与现在相反 | did/were | would/should/could/might + do |
| 与过去相反 | had done | would/should/could/might + have done |
| 与将来相反 | did/were to/should do | would/should/could/might + do |

**wish 的虚拟语气**
- 与现在相反：wish + 主语 + did/were
- 与过去相反：wish + 主语 + had done
- 与将来相反：wish + 主语 + would/could do

**其他虚拟语气**
- as if/as though + 从句（与事实相反）
- would rather + 从句（与现在/过去相反）
- It\'s time + 从句（该做某事了）
- suggest, insist, demand 等 + (should) do
      ''',
      keyPoints: [
        'if 条件句虚拟语气注意时态后退',
        'wish 后宾语从句用虚拟语气',
        'suggest, insist 等词后用 (should) do',
        'as if/as though 后可用虚拟语气',
      ],
      examples: [
        GrammarExample(
          correct: 'If I were you, I would take the job.',
          explanation: '与现在事实相反，从句用过去式',
        ),
        GrammarExample(
          correct: 'If I had studied harder, I would have passed the exam.',
          explanation: '与过去事实相反，从句用 had done',
        ),
        GrammarExample(
          correct: 'I wish I knew the answer.',
          explanation: 'wish 与现在相反用过去式',
        ),
        GrammarExample(
          correct: 'He suggested that we (should) go there at once.',
          explanation: 'suggest 后宾语从句用 (should) do',
        ),
      ],
      commonMistakes: [
        '❌ If I was you... → ✅ If I were you...（虚拟语气中 be 动词用 were）',
        '❌ I wish I am a bird. → ✅ I wish I were a bird.（wish 后用虚拟语气）',
        '❌ He suggested that we went there. → ✅ He suggested that we (should) go there.（suggest 后用 should do，should 可省）',
      ],
      category: GrammarCategory.conditionals,
      difficulty: 3,
      relatedRules: ['grammar_008'],
    ),

    // Non-finite Verbs
    GrammarModel(
      id: 'grammar_008',
      title: 'Non-finite Verbs (非谓语动词)',
      titleCn: '非谓语动词',
      explanation: '''
**非谓语动词概述**
- 不充当谓语的动词形式：不定式、动名词、分词

**不定式 (to do)**
- 作主语：To learn English is important.
- 作宾语：want to do, decide to do
- 作表语：My dream is to travel.
- 作定语：something to eat
- 作状语：He came to help me.

**动名词 (doing)**
- 作主语：Swimming is good exercise.
- 作宾语：enjoy doing, finish doing
- 作表语：My hobby is reading.

**分词**
- 现在分词 (doing)：表示主动/进行
- 过去分词 (done)：表示被动/完成
- 作定语、表语、宾补、状语

**常见接不定式的动词**
want, hope, wish, decide, plan, agree, refuse, learn, pretend, promise, manage, fail

**常见接动名词的动词**
enjoy, finish, practice, avoid, consider, suggest, mind, keep, imagine, risk, admit

**既可接不定式又可接动名词的动词**
- remember/forget/regret + to do（未做）/ doing（已做）
- stop to do（停下来去做）/ doing（停止做）
- try to do（努力做）/ doing（尝试做）
- mean to do（打算做）/ doing（意味着）
      ''',
      keyPoints: [
        '不定式表示目的、将来',
        '动名词表示抽象、习惯性动作',
        '现在分词表示主动/进行',
        '过去分词表示被动/完成',
      ],
      examples: [
        GrammarExample(
          correct: 'I want to learn English.',
          explanation: 'want 后接不定式作宾语',
        ),
        GrammarExample(
          correct: 'I enjoy reading books.',
          explanation: 'enjoy 后接动名词作宾语',
        ),
        GrammarExample(
          correct: 'The man standing there is my teacher.',
          explanation: '现在分词作定语，表示主动',
        ),
        GrammarExample(
          correct: 'Seen from the hill, the city looks beautiful.',
          explanation: '过去分词作状语，表示被动',
        ),
      ],
      commonMistakes: [
        '❌ I enjoy to swim. → ✅ I enjoy swimming.（enjoy 后接动名词）',
        '❌ He suggested to go there. → ✅ He suggested going there.（suggest 后接动名词）',
        '❌ The problem discussing now is important. → ✅ The problem being discussed now is important.（problem 与 discuss 是被动关系）',
      ],
      category: GrammarCategory.gerunds,
      difficulty: 3,
      relatedRules: [],
    ),

    // Noun Clauses
    GrammarModel(
      id: 'grammar_009',
      title: 'Noun Clauses (名词性从句)',
      titleCn: '名词性从句',
      explanation: '''
**名词性从句概述**
- 在句中充当名词作用的从句
- 包括：主语从句、宾语从句、表语从句、同位语从句

**连接词**
- that：无意义，不充当成分，只起连接作用
- whether/if："是否"，不充当成分
- 连接代词：what, who, whom, whose, which, whatever, whoever
- 连接副词：when, where, why, how

**主语从句**
- That he passed the exam surprised us.
- What he said is true.
- It is important that we learn English. (it 作形式主语)

**宾语从句**
- I believe that he is honest.
- I don\'t know whether he will come.
- Tell me what you want.

**表语从句**
- The problem is that we don\'t have enough time.
- This is where I was born.

**同位语从句**
- The news that he won the prize surprised us.
- I have no idea when he will come.

**注意**
- that 引导的主语从句、表语从句、同位语从句一般不省略
- that 引导的宾语从句可省略
- 同位语从句说明名词的具体内容，定语从句修饰名词
      ''',
      keyPoints: [
        'that 在名词性从句中不充当成分',
        'what 在从句中充当成分（主语、宾语、表语）',
        '同位语从句说明抽象名词的内容',
        'it 可作形式主语/宾语',
      ],
      examples: [
        GrammarExample(
          correct: 'What he said is very important.',
          explanation: 'what 引导主语从句，在从句中作宾语',
        ),
        GrammarExample(
          correct: 'I believe that he will succeed.',
          explanation: 'that 引导宾语从句',
        ),
        GrammarExample(
          correct: 'The reason is that he is ill.',
          explanation: 'that 引导表语从句',
        ),
        GrammarExample(
          correct: 'The news that he passed the exam is true.',
          explanation: 'that 引导同位语从句，说明 news 的内容',
        ),
      ],
      commonMistakes: [
        '❌ What he said it is true. → ✅ What he said is true.（what 在从句中作宾语，主句不需要 it）',
        '❌ I don\'t know that he will come. → ✅ I don\'t know whether/if he will come.（表示"是否"用 whether/if）',
        '❌ The reason is because he is ill. → ✅ The reason is that he is ill.（reason 后的表语从句用 that）',
      ],
      category: GrammarCategory.conjunctions,
      difficulty: 3,
      relatedRules: ['grammar_006', 'grammar_010'],
    ),

    // Emphasis Structures
    GrammarModel(
      id: 'grammar_010',
      title: 'Emphasis Structures (强调句)',
      titleCn: '强调句',
      explanation: '''
**强调句结构**
- It is/was + 被强调部分 + that/who + 其他部分

**强调句的特点**
- 可以强调除谓语外的任何句子成分
- 强调人时可用 who/that，强调其他用 that
- 去掉 It is/was...that/who 后，句子仍然完整

**强调句 vs 主语从句**
- 强调句：It was in the park that I met him. (去掉后为 I met him in the park.)
- 主语从句：It was a pity that he failed. (去掉后不成句)

**not...until 的强调**
- It was not until...that...
- 例：It was not until midnight that he came back.

**特殊疑问词的强调**
- 疑问词 + is/was + it + that...
- 例：What was it that made you so angry?

**助动词 do 的强调**
- I do like English.
- He did finish his homework.
      ''',
      keyPoints: [
        '强调句结构：It is/was...that/who...',
        '强调人可用 who/that，其他用 that',
        '去掉强调结构后句子应完整',
        'not until 强调用 It was not until...that...',
      ],
      examples: [
        GrammarExample(
          correct: 'It was Tom who/that broke the window.',
          explanation: '强调主语（人）',
        ),
        GrammarExample(
          correct: 'It was in Paris that I met her.',
          explanation: '强调地点状语',
        ),
        GrammarExample(
          correct: 'It was not until yesterday that I knew the truth.',
          explanation: '强调 not...until',
        ),
        GrammarExample(
          correct: 'Why is it that you are always late?',
          explanation: '强调特殊疑问句',
        ),
      ],
      commonMistakes: [
        '❌ It was him that I met. → ✅ It was he that I met.（强调主语用主格）',
        '❌ It was in the room where I met him. → ✅ It was in the room that I met him.（强调句用 that，不用 where）',
        '❌ It was not until he came back when I left. → ✅ It was not until he came back that I left.（not until 强调用 that）',
      ],
      category: GrammarCategory.questionForms,
      difficulty: 3,
      relatedRules: ['grammar_006', 'grammar_009'],
    ),

    // ==================== 高三 (Grade 12) ====================

    // Adverbial Clauses
    GrammarModel(
      id: 'grammar_011',
      title: 'Adverbial Clauses (状语从句)',
      titleCn: '状语从句',
      explanation: '''
**状语从句概述**
- 在句中充当状语的从句
- 包括：时间、地点、原因、目的、结果、条件、让步、方式、比较

**时间状语从句**
- when, while, as, before, after, since, until, as soon as
- 主将从现：I will tell him when he comes.
- while 后接延续性动词，when 后可接任意动词

**条件状语从句**
- if, unless, as/so long as, on condition that
- 主将从现：If it rains, we will stay at home.

**原因状语从句**
- because, since, as, for
- because 语气最强，回答 why
- since/as 表示已知的原因

**让步状语从句**
- although/though, even if/though, no matter + wh-, whatever
- although/though 不与 but 连用，可与 yet/still 连用

**目的状语从句**
- so that, in order that + can/could/may/might

**结果状语从句**
- so...that, such...that
- so + adj./adv. + that
- such + (a/an) + adj. + n. + that
      ''',
      keyPoints: [
        '时间/条件状语从句常用"主将从现"',
        'because 不与 so 连用，although 不与 but 连用',
        'so...that 与 such...that 的区别',
        'no matter what = whatever',
      ],
      examples: [
        GrammarExample(
          correct: 'I will call you as soon as I arrive.',
          explanation: 'as soon as 引导时间状语从句，主将从现',
        ),
        GrammarExample(
          correct: 'He worked so hard that he passed the exam.',
          explanation: 'so...that 引导结果状语从句',
        ),
        GrammarExample(
          correct: 'Although he is poor, he is happy.',
          explanation: 'although 引导让步状语从句',
        ),
        GrammarExample(
          correct: 'He got up early so that he could catch the train.',
          explanation: 'so that 引导目的状语从句',
        ),
      ],
      commonMistakes: [
        '❌ Because he is ill, so he can\'t come. → ✅ Because he is ill, he can\'t come. / He is ill, so he can\'t come.（because 与 so 不能连用）',
        '❌ Though he is young, but he knows a lot. → ✅ Though he is young, he knows a lot.（though 与 but 不能连用）',
        '❌ He is such a good student that everyone likes him. → ✅ He is such a good student that everyone likes him.（正确）/ He is so good a student that everyone likes him.（so 的用法）',
      ],
      category: GrammarCategory.conjunctions,
      difficulty: 2,
      relatedRules: ['grammar_007'],
    ),

    // Inversion
    GrammarModel(
      id: 'grammar_012',
      title: 'Inversion (倒装句)',
      titleCn: '倒装句',
      explanation: '''
**倒装句概述**
- 完全倒装：整个谓语移到主语前
- 部分倒装：助动词/情态动词/be 动词移到主语前

**完全倒装**
- 表示方位/时间的副词置于句首：here, there, now, then
- 例：Here comes the bus.
- 例：On the wall hangs a picture.
- 主语是代词时不倒装：Here you are.

**部分倒装（否定词置于句首）**
- never, hardly, seldom, rarely, little, few, not until, no sooner...than
- 例：Never have I seen such a beautiful sight.
- 例：Hardly had he arrived when it began to rain.

**部分倒装（so/neither/nor）**
- So do I. / Neither/Nor do I.

**部分倒装（only + 状语置于句首）**
- Only in this way can we solve the problem.
- Only when he came back did I know the truth.

**部分倒装（so...that/such...that 的 so/such 置于句首）**
- So fast does he run that I can\'t catch up.

**虚拟条件句的省略倒装**
- Had I known it, I would have told you. (= If I had known it...)
- Were I you, I would accept the offer. (= If I were you...)
- Should it rain, we would cancel the trip. (= If it should rain...)
      ''',
      keyPoints: [
        '完全倒装：副词 + 谓语 + 主语',
        '部分倒装：助动词 + 主语 + 谓语',
        '否定词置于句首要部分倒装',
        'only + 状语置于句首要部分倒装',
      ],
      examples: [
        GrammarExample(
          correct: 'Here comes the bus.',
          explanation: 'here 置于句首，完全倒装',
        ),
        GrammarExample(
          correct: 'Never have I been to Paris.',
          explanation: 'never 置于句首，部分倒装',
        ),
        GrammarExample(
          correct: 'Only then did I realize my mistake.',
          explanation: 'only + 状语置于句首，部分倒装',
        ),
        GrammarExample(
          correct: 'Had I known the truth, I would have told you.',
          explanation: '虚拟条件句省略 if 的倒装',
        ),
      ],
      commonMistakes: [
        '❌ Here he comes. → ✅ Here he comes.（主语是代词时不倒装）',
        '❌ Never I have seen such a thing. → ✅ Never have I seen such a thing.（否定词置于句首要倒装）',
        '❌ Only in this way you can learn English well. → ✅ Only in this way can you learn English well.（only + 状语置于句首要倒装）',
      ],
      category: GrammarCategory.questionForms,
      difficulty: 3,
      relatedRules: ['grammar_007', 'grammar_011'],
    ),

    // Passive Voice
    GrammarModel(
      id: 'grammar_013',
      title: 'Passive Voice (被动语态)',
      titleCn: '被动语态',
      explanation: '''
**被动语态概述**
- 结构：be + 过去分词 (done)
- 时态通过 be 动词的变化体现

**各时态的被动语态**

| 时态 | 结构 |
|------|------|
| 一般现在时 | am/is/are + done |
| 一般过去时 | was/were + done |
| 一般将来时 | will be + done |
| 现在进行时 | am/is/are being + done |
| 过去进行时 | was/were being + done |
| 现在完成时 | have/has been + done |
| 过去完成时 | had been + done |
| 情态动词 | can/must/should + be + done |

**被动语态的用法**
- 不知道动作执行者时
- 不必指出动作执行者时
- 强调动作承受者时

**主动变被动的步骤**
1. 宾语变主语
2. 谓语变 be + done
3. 主语变 by 的宾语（可省略）

**不能用被动语态的情况**
- 不及物动词（happen, take place, occur, belong 等）
- 系动词（be, become, seem, look 等）
- 某些表示状态的及物动词（have, own, possess, lack 等）

**主动表被动的情况**
- need/want/require + doing = need/want/require + to be done
- be worth doing
- 感官动词 + doing（主动表被动）
      ''',
      keyPoints: [
        '被动语态结构：be + 过去分词',
        '时态通过 be 动词体现',
        '不及物动词无被动语态',
        'need/want/require + doing = to be done',
      ],
      examples: [
        GrammarExample(
          correct: 'The book was written by Lu Xun.',
          explanation: '一般过去时的被动语态',
        ),
        GrammarExample(
          correct: 'The house is being built.',
          explanation: '现在进行时的被动语态',
        ),
        GrammarExample(
          correct: 'The work has been finished.',
          explanation: '现在完成时的被动语态',
        ),
        GrammarExample(
          correct: 'The book is worth reading.',
          explanation: 'worth 后主动表被动',
        ),
      ],
      commonMistakes: [
        '❌ The accident was happened yesterday. → ✅ The accident happened yesterday.（happen 是不及物动词，无被动）',
        '❌ The book is worth to be read. → ✅ The book is worth reading.（worth 后接 doing）',
        '❌ The house has been being built for two years. → ✅ The house has been being built for two years.（正确，现在完成进行时的被动）',
      ],
      category: GrammarCategory.passiveVoice,
      difficulty: 2,
      relatedRules: ['grammar_001', 'grammar_002', 'grammar_003'],
    ),

    // Direct and Indirect Speech
    GrammarModel(
      id: 'grammar_014',
      title: 'Direct & Indirect Speech (直接引语与间接引语)',
      titleCn: '直接引语与间接引语',
      explanation: '''
**直接引语变间接引语**

**陈述句**
- 引述动词：say, tell, explain
- that 引导（可省略）
- 例：He said, "I am tired." → He said (that) he was tired.

**一般疑问句**
- 引述动词：ask, wonder, want to know
- if/whether 引导
- 例：He asked, "Are you tired?" → He asked if/whether I was tired.

**特殊疑问句**
- 引述动词：ask, wonder
- 疑问词引导，用陈述语序
- 例：He asked, "Where are you going?" → He asked where I was going.

**祈使句**
- 引述动词：tell, ask, order, warn, advise
- tell/ask sb. (not) to do sth.
- 例：He said, "Sit down." → He told me to sit down.

**时态变化规则**
- 主句过去时，从句时态后退一步
- 一般现在时 → 一般过去时
- 现在进行时 → 过去进行时
- 现在完成时 → 过去完成时
- 一般过去时 → 过去完成时
- 过去完成时 → 不变
- 一般将来时 → 过去将来时 (would do)

**例外情况（时态不变）**
- 客观真理：He said the earth goes around the sun.
- 说话时仍有效的情况
      ''',
      keyPoints: [
        '陈述句用 that 引导',
        '一般疑问句用 if/whether 引导',
        '特殊疑问句用疑问词引导，陈述语序',
        '祈使句用 tell/ask sb. (not) to do',
      ],
      examples: [
        GrammarExample(
          correct: 'He said, "I am tired." → He said (that) he was tired.',
          explanation: '陈述句变间接引语',
        ),
        GrammarExample(
          correct: 'He asked, "Do you like English?" → He asked if I liked English.',
          explanation: '一般疑问句变间接引语',
        ),
        GrammarExample(
          correct: 'He asked, "What are you doing?" → He asked what I was doing.',
          explanation: '特殊疑问句变间接引语',
        ),
        GrammarExample(
          correct: 'He said, "Don\'t be late." → He told me not to be late.',
          explanation: '否定祈使句变间接引语',
        ),
      ],
      commonMistakes: [
        '❌ He asked me where was I going. → ✅ He asked me where I was going.（间接引语用陈述语序）',
        '❌ He said that the earth went around the sun. → ✅ He said that the earth goes around the sun.（客观真理时态不变）',
        '❌ He asked me that if I liked English. → ✅ He asked me if I liked English.（if/whether 前不加 that）',
      ],
      category: GrammarCategory.reportedSpeech,
      difficulty: 3,
      relatedRules: ['grammar_001', 'grammar_002'],
    ),

    // It 用法
    GrammarModel(
      id: 'grammar_015',
      title: 'It Usage (it 的用法)',
      titleCn: 'it 的用法',
      explanation: '''
**it 的多种用法**

**1. 作人称代词**
- 指代事物、动物、不明身份的人
- 指代婴儿或小孩

**2. 作指示代词**
- 指时间、日期、天气、距离
- What time is it? It\'s 8 o\'clock.
- It\'s raining. / It\'s Sunday today.

**3. 作形式主语**
- It\'s important to learn English.
- It\'s no use crying over spilt milk.
- It\'s said/reported/believed that...

**4. 作形式宾语**
- I find it difficult to learn English.
- I think it no use arguing with him.

**5. 强调句中的 it**
- It is/was...that/who...

**6. 固定句型**
- It takes/took sb. some time to do sth.
- It is/was the first time that... (从句用完成时)
- It is/has been + 时间段 + since... (since 从句用一般过去时)
- It will be + 时间段 + before... (多久之后才...)
- It is + adj. + of/for sb. + to do sth.
  - of：形容人的品质 (kind, nice, clever, foolish)
  - for：形容事情的性质 (important, necessary, difficult)
      ''',
      keyPoints: [
        'it 可作形式主语、形式宾语',
        'It takes sb. time to do sth.',
        'It is the first time that + 完成时',
        'It is + 时间段 + since + 一般过去时',
      ],
      examples: [
        GrammarExample(
          correct: 'It is important to learn English well.',
          explanation: 'it 作形式主语',
        ),
        GrammarExample(
          correct: 'I find it difficult to finish the work.',
          explanation: 'it 作形式宾语',
        ),
        GrammarExample(
          correct: 'It is the first time that I have been here.',
          explanation: 'It is the first time that + 现在完成时',
        ),
        GrammarExample(
          correct: 'It is three years since he left.',
          explanation: 'It is + 时间段 + since + 一般过去时',
        ),
      ],
      commonMistakes: [
        '❌ It is kind for you to help me. → ✅ It is kind of you to help me.（形容人的品质用 of）',
        '❌ It is the first time that I came here. → ✅ It is the first time that I have come here.（that 从句用完成时）',
        '❌ It was three years since he has left. → ✅ It is three years since he left. / It has been three years since he left.（since 从句用一般过去时）',
      ],
      category: GrammarCategory.tenses,
      difficulty: 3,
      relatedRules: ['grammar_010'],
    ),
  ];

  /// Get grammar rules by grade level
  static List<GrammarModel> getGrammarByGrade(String grade) {
    final gradeMap = {
      'grade10': [0, 5],   // grammar_001 to grammar_006
      'grade11': [6, 9],   // grammar_007 to grammar_010
      'grade12': [10, 14], // grammar_011 to grammar_015
    };
    
    final range = gradeMap[grade];
    if (range != null) {
      return allGrammarRules.sublist(range[0], range[1] + 1);
    }
    return allGrammarRules;
  }

  /// Get all categorized grammar
  static Map<String, List<GrammarModel>> get categorizedGrammar => {
    'grade10': getGrammarByGrade('grade10'),
    'grade11': getGrammarByGrade('grade11'),
    'grade12': getGrammarByGrade('grade12'),
  };

  /// Grade display names
  static const Map<String, String> gradeNames = {
    'grade10': '高一',
    'grade11': '高二',
    'grade12': '高三',
  };

  /// Get grammar rule by ID
  static GrammarModel? getGrammarById(String id) {
    try {
      return allGrammarRules.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get grammar rules by category
  static List<GrammarModel> getGrammarByCategory(GrammarCategory category) {
    return allGrammarRules.where((g) => g.category == category).toList();
  }
}
