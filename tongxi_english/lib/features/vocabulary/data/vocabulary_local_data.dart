import '../../../models/word_model.dart';

class VocabularyLocalData {
  VocabularyLocalData._();

  static WordModel _word({
    required String id,
    required String word,
    required String phonetic,
    required String partOfSpeech,
    required String translation,
    required String definition,
    required String unit,
    required int difficulty,
    required String sentence,
    required String sentenceTranslation,
  }) {
    return WordModel(
      id: id,
      word: word,
      phonetic: phonetic,
      partOfSpeech: partOfSpeech,
      translation: translation,
      definition: definition,
      examples: [WordExample(sentence: sentence, translation: sentenceTranslation)],
      audioUrl: '',
      difficulty: difficulty,
      tags: [unit],
    );
  }

  static final List<WordModel> allWords = [
    _word(id: 'u1_1', word: 'survey', phonetic: '/ˈsɜːveɪ/', partOfSpeech: 'n.', translation: '调查', definition: 'a detailed study', unit: '必修一 Unit 1', difficulty: 1, sentence: 'Our class did a survey about study habits.', sentenceTranslation: '我们班做了一项关于学习习惯的调查。'),
    _word(id: 'u1_2', word: 'addicted', phonetic: '/əˈdɪktɪd/', partOfSpeech: 'adj.', translation: '上瘾的', definition: 'unable to stop taking or doing', unit: '必修一 Unit 1', difficulty: 2, sentence: 'Some teens are addicted to mobile games.', sentenceTranslation: '一些青少年沉迷于手机游戏。'),
    _word(id: 'u1_3', word: 'schedule', phonetic: '/ˈʃedjuːl/', partOfSpeech: 'n.', translation: '日程安排', definition: 'a plan of activities', unit: '必修一 Unit 1', difficulty: 2, sentence: 'She made a clear study schedule for the week.', sentenceTranslation: '她为这一周制定了清晰的学习计划。'),
    _word(id: 'u1_4', word: 'challenge', phonetic: '/ˈtʃælɪndʒ/', partOfSpeech: 'n.', translation: '挑战', definition: 'something difficult', unit: '必修一 Unit 1', difficulty: 1, sentence: 'Learning English well is a big challenge.', sentenceTranslation: '学好英语是一个很大的挑战。'),
    _word(id: 'u1_5', word: 'improve', phonetic: '/ɪmˈpruːv/', partOfSpeech: 'v.', translation: '提高', definition: 'to become better', unit: '必修一 Unit 1', difficulty: 1, sentence: 'Reading aloud can improve your pronunciation.', sentenceTranslation: '大声朗读可以提高你的发音。'),
    _word(id: 'u1_6', word: 'fluent', phonetic: '/ˈfluːənt/', partOfSpeech: 'adj.', translation: '流利的', definition: 'able to speak smoothly', unit: '必修一 Unit 1', difficulty: 2, sentence: 'She wants to become fluent in spoken English.', sentenceTranslation: '她想让英语口语变得流利。'),
    _word(id: 'u1_7', word: 'confidence', phonetic: '/ˈkɒnfɪdəns/', partOfSpeech: 'n.', translation: '信心', definition: 'belief in yourself', unit: '必修一 Unit 1', difficulty: 2, sentence: 'Practice gives students more confidence.', sentenceTranslation: '练习会给学生更多信心。'),
    _word(id: 'u1_8', word: 'graduate', phonetic: '/ˈɡrædʒueɪt/', partOfSpeech: 'v.', translation: '毕业', definition: 'to complete school', unit: '必修一 Unit 1', difficulty: 2, sentence: 'He plans to graduate from high school next year.', sentenceTranslation: '他计划明年高中毕业。'),
    _word(id: 'u1_9', word: 'responsible', phonetic: '/rɪˈspɒnsəbl/', partOfSpeech: 'adj.', translation: '负责的', definition: 'having a duty to care', unit: '必修一 Unit 1', difficulty: 2, sentence: 'A monitor should be responsible for the class.', sentenceTranslation: '班长应该对班级负责。'),
    _word(id: 'u1_10', word: 'goal', phonetic: '/ɡəʊl/', partOfSpeech: 'n.', translation: '目标', definition: 'an aim you try to reach', unit: '必修一 Unit 1', difficulty: 1, sentence: 'Set a small goal every day.', sentenceTranslation: '每天设定一个小目标。'),
    _word(id: 'u1_11', word: 'strategy', phonetic: '/ˈstrætədʒi/', partOfSpeech: 'n.', translation: '策略', definition: 'a careful plan', unit: '必修一 Unit 1', difficulty: 3, sentence: 'This memory strategy works well for vocabulary.', sentenceTranslation: '这个记忆策略对词汇学习很有效。'),
    _word(id: 'u1_12', word: 'recommend', phonetic: '/ˌrekəˈmend/', partOfSpeech: 'v.', translation: '推荐', definition: 'to suggest something', unit: '必修一 Unit 1', difficulty: 2, sentence: 'My teacher recommended this English app.', sentenceTranslation: '我的老师推荐了这个英语应用。'),
    _word(id: 'u1_13', word: 'confuse', phonetic: '/kənˈfjuːz/', partOfSpeech: 'v.', translation: '使困惑', definition: 'to make someone unable to understand', unit: '必修一 Unit 1', difficulty: 2, sentence: 'Similar spellings often confuse beginners.', sentenceTranslation: '相似的拼写常常让初学者困惑。'),
    _word(id: 'u1_14', word: 'exchange', phonetic: '/ɪksˈtʃeɪndʒ/', partOfSpeech: 'v.', translation: '交流；交换', definition: 'to give and receive', unit: '必修一 Unit 1', difficulty: 2, sentence: 'Students exchange ideas in class discussion.', sentenceTranslation: '学生们在课堂讨论中交流想法。'),
    _word(id: 'u1_15', word: 'curious', phonetic: '/ˈkjʊəriəs/', partOfSpeech: 'adj.', translation: '好奇的', definition: 'eager to know', unit: '必修一 Unit 1', difficulty: 2, sentence: 'Curious students ask a lot of questions.', sentenceTranslation: '好奇的学生会问很多问题。'),
    _word(id: 'u1_16', word: 'lecture', phonetic: '/ˈlektʃə/', partOfSpeech: 'n.', translation: '讲座', definition: 'a formal talk', unit: '必修一 Unit 1', difficulty: 2, sentence: 'We listened to a lecture on healthy study habits.', sentenceTranslation: '我们听了一场关于健康学习习惯的讲座。'),
    _word(id: 'u1_17', word: 'volunteer', phonetic: '/ˌvɒlənˈtɪə/', partOfSpeech: 'n.', translation: '志愿者', definition: 'a person who offers help freely', unit: '必修一 Unit 2', difficulty: 2, sentence: 'She works as a volunteer at the weekend.', sentenceTranslation: '她周末当志愿者。'),
    _word(id: 'u1_18', word: 'debate', phonetic: '/dɪˈbeɪt/', partOfSpeech: 'n.', translation: '辩论', definition: 'a formal discussion', unit: '必修一 Unit 2', difficulty: 2, sentence: 'The class had a debate on school uniforms.', sentenceTranslation: '班级就校服问题举行了一场辩论。'),
    _word(id: 'u1_19', word: 'content', phonetic: '/ˈkɒntent/', partOfSpeech: 'adj.', translation: '满足的', definition: 'feeling happy and satisfied', unit: '必修一 Unit 2', difficulty: 2, sentence: 'He felt content after finishing his homework.', sentenceTranslation: '完成作业后他感到很满足。'),
    _word(id: 'u1_20', word: 'adventure', phonetic: '/ədˈventʃə/', partOfSpeech: 'n.', translation: '冒险', definition: 'an exciting experience', unit: '必修一 Unit 2', difficulty: 2, sentence: 'The trip became an unforgettable adventure.', sentenceTranslation: '这次旅行成了一次难忘的冒险。'),
    _word(id: 'u2_1', word: 'debate', phonetic: '/dɪˈbeɪt/', partOfSpeech: 'v.', translation: '辩论', definition: 'to discuss seriously', unit: '必修一 Unit 2', difficulty: 2, sentence: 'We debated whether homework should be reduced.', sentenceTranslation: '我们辩论是否应该减少作业。'),
    _word(id: 'u2_2', word: 'prefer', phonetic: '/prɪˈfɜː/', partOfSpeech: 'v.', translation: '更喜欢', definition: 'to like better', unit: '必修一 Unit 2', difficulty: 1, sentence: 'I prefer reading to watching TV.', sentenceTranslation: '比起看电视，我更喜欢阅读。'),
    _word(id: 'u2_3', word: 'actually', phonetic: '/ˈæktʃuəli/', partOfSpeech: 'adv.', translation: '事实上', definition: 'really; in fact', unit: '必修一 Unit 2', difficulty: 2, sentence: 'Actually, learning can be fun.', sentenceTranslation: '事实上，学习可以很有趣。'),
    _word(id: 'u2_4', word: 'suitable', phonetic: '/ˈsuːtəbl/', partOfSpeech: 'adj.', translation: '合适的', definition: 'right for a purpose', unit: '必修一 Unit 2', difficulty: 2, sentence: 'This book is suitable for high school students.', sentenceTranslation: '这本书适合高中生。'),
    _word(id: 'u2_5', word: 'obvious', phonetic: '/ˈɒbviəs/', partOfSpeech: 'adj.', translation: '明显的', definition: 'easy to see or understand', unit: '必修一 Unit 2', difficulty: 1, sentence: 'It was obvious that she had prepared well.', sentenceTranslation: '很明显她准备得很充分。'),
    _word(id: 'u2_6', word: 'solution', phonetic: '/səˈluːʃn/', partOfSpeech: 'n.', translation: '解决办法', definition: 'an answer to a problem', unit: '必修一 Unit 2', difficulty: 2, sentence: 'Group work is a good solution to the problem.', sentenceTranslation: '小组合作是解决这个问题的好办法。'),
    _word(id: 'u2_7', word: 'attract', phonetic: '/əˈtrækt/', partOfSpeech: 'v.', translation: '吸引', definition: 'to draw attention', unit: '必修一 Unit 2', difficulty: 2, sentence: 'Bright posters attract students easily.', sentenceTranslation: '鲜艳的海报很容易吸引学生。'),
    _word(id: 'u2_8', word: 'design', phonetic: '/dɪˈzaɪn/', partOfSpeech: 'v.', translation: '设计', definition: 'to plan how something looks', unit: '必修一 Unit 2', difficulty: 1, sentence: 'They designed a new English corner poster.', sentenceTranslation: '他们设计了一张新的英语角海报。'),
    _word(id: 'u2_9', word: 'formal', phonetic: '/ˈfɔːml/', partOfSpeech: 'adj.', translation: '正式的', definition: 'serious and correct', unit: '必修一 Unit 2', difficulty: 2, sentence: 'Please use formal language in the speech.', sentenceTranslation: '请在演讲中使用正式语言。'),
    _word(id: 'u2_10', word: 'generation', phonetic: '/ˌdʒenəˈreɪʃn/', partOfSpeech: 'n.', translation: '一代人', definition: 'all people born around the same time', unit: '必修一 Unit 2', difficulty: 3, sentence: 'Each generation has its own way of learning.', sentenceTranslation: '每一代人都有自己的学习方式。'),
    _word(id: 'u2_11', word: 'respect', phonetic: '/rɪˈspekt/', partOfSpeech: 'v.', translation: '尊重', definition: 'to admire and treat well', unit: '必修一 Unit 2', difficulty: 1, sentence: 'Students should respect different opinions.', sentenceTranslation: '学生应该尊重不同的观点。'),
    _word(id: 'u2_12', word: 'expert', phonetic: '/ˈekspɜːt/', partOfSpeech: 'n.', translation: '专家', definition: 'a person with special knowledge', unit: '必修一 Unit 2', difficulty: 2, sentence: 'An expert gave us advice on memory skills.', sentenceTranslation: '一位专家给了我们记忆技巧方面的建议。'),
    _word(id: 'u2_13', word: 'focus', phonetic: '/ˈfəʊkəs/', partOfSpeech: 'v.', translation: '集中注意力', definition: 'to give full attention', unit: '必修一 Unit 2', difficulty: 1, sentence: 'Try to focus on one task at a time.', sentenceTranslation: '试着一次只专注于一项任务。'),
    _word(id: 'u2_14', word: 'positive', phonetic: '/ˈpɒzətɪv/', partOfSpeech: 'adj.', translation: '积极的', definition: 'hopeful and helpful', unit: '必修一 Unit 2', difficulty: 1, sentence: 'A positive attitude makes learning easier.', sentenceTranslation: '积极的态度会让学习更轻松。'),
    _word(id: 'u2_15', word: 'independent', phonetic: '/ˌɪndɪˈpendənt/', partOfSpeech: 'adj.', translation: '独立的', definition: 'able to do things by yourself', unit: '必修一 Unit 2', difficulty: 2, sentence: 'Good learners become more independent.', sentenceTranslation: '优秀的学习者会变得更加独立。'),
    _word(id: 'u2_16', word: 'pressure', phonetic: '/ˈpreʃə/', partOfSpeech: 'n.', translation: '压力', definition: 'the feeling of being pushed', unit: '必修一 Unit 2', difficulty: 2, sentence: 'Too much pressure may affect your sleep.', sentenceTranslation: '太大的压力可能会影响你的睡眠。'),
    _word(id: 'u3_1', word: 'transport', phonetic: '/ˈtrænspɔːt/', partOfSpeech: 'n.', translation: '交通', definition: 'a system of moving people or goods', unit: '必修一 Unit 3', difficulty: 2, sentence: 'Public transport is convenient in big cities.', sentenceTranslation: '大城市的公共交通很方便。'),
    _word(id: 'u3_2', word: 'destination', phonetic: '/ˌdestɪˈneɪʃn/', partOfSpeech: 'n.', translation: '目的地', definition: 'the place you are going to', unit: '必修一 Unit 3', difficulty: 3, sentence: 'Xi’an was our final travel destination.', sentenceTranslation: '西安是我们旅行的最终目的地。'),
    _word(id: 'u3_3', word: 'arrange', phonetic: '/əˈreɪndʒ/', partOfSpeech: 'v.', translation: '安排', definition: 'to plan and prepare', unit: '必修一 Unit 3', difficulty: 2, sentence: 'They arranged everything before the trip.', sentenceTranslation: '他们在旅行前安排好了一切。'),
    _word(id: 'u3_4', word: 'source', phonetic: '/sɔːs/', partOfSpeech: 'n.', translation: '来源', definition: 'the place something comes from', unit: '必修一 Unit 3', difficulty: 2, sentence: 'The river is an important water source.', sentenceTranslation: '这条河是重要的水源。'),
    _word(id: 'u3_5', word: 'attitude', phonetic: '/ˈætɪtjuːd/', partOfSpeech: 'n.', translation: '态度', definition: 'the way you think or feel', unit: '必修一 Unit 3', difficulty: 2, sentence: 'A good attitude helps in difficult situations.', sentenceTranslation: '良好的态度有助于应对困难情境。'),
    _word(id: 'u3_6', word: 'forecast', phonetic: '/ˈfɔːkɑːst/', partOfSpeech: 'n.', translation: '预报', definition: 'a statement about future weather', unit: '必修一 Unit 3', difficulty: 2, sentence: 'The weather forecast said it would rain.', sentenceTranslation: '天气预报说会下雨。'),
    _word(id: 'u3_7', word: 'view', phonetic: '/vjuː/', partOfSpeech: 'n.', translation: '风景；视野', definition: 'what you can see', unit: '必修一 Unit 3', difficulty: 1, sentence: 'The mountain view was amazing.', sentenceTranslation: '山间景色令人惊叹。'),
    _word(id: 'u3_8', word: 'detail', phonetic: '/ˈdiːteɪl/', partOfSpeech: 'n.', translation: '细节', definition: 'a small part of something', unit: '必修一 Unit 3', difficulty: 1, sentence: 'Please check every detail of the plan.', sentenceTranslation: '请检查计划中的每个细节。'),
    _word(id: 'u3_9', word: 'journey', phonetic: '/ˈdʒɜːni/', partOfSpeech: 'n.', translation: '旅行；旅程', definition: 'the act of traveling', unit: '必修一 Unit 3', difficulty: 1, sentence: 'The train journey took five hours.', sentenceTranslation: '这趟火车旅程用了五个小时。'),
    _word(id: 'u3_10', word: 'pace', phonetic: '/peɪs/', partOfSpeech: 'n.', translation: '速度；步伐', definition: 'the speed at which something happens', unit: '必修一 Unit 3', difficulty: 2, sentence: 'We walked at a slow pace.', sentenceTranslation: '我们以缓慢的步伐行走。'),
    _word(id: 'u3_11', word: 'persuade', phonetic: '/pəˈsweɪd/', partOfSpeech: 'v.', translation: '说服', definition: 'to make someone agree', unit: '必修一 Unit 3', difficulty: 3, sentence: 'She persuaded her parents to let her join the trip.', sentenceTranslation: '她说服了父母让她参加旅行。'),
    _word(id: 'u3_12', word: 'reliable', phonetic: '/rɪˈlaɪəbl/', partOfSpeech: 'adj.', translation: '可靠的', definition: 'able to be trusted', unit: '必修一 Unit 3', difficulty: 2, sentence: 'A reliable friend always keeps promises.', sentenceTranslation: '可靠的朋友总是会信守承诺。'),
    _word(id: 'u3_13', word: 'stubborn', phonetic: '/ˈstʌbən/', partOfSpeech: 'adj.', translation: '固执的', definition: 'not willing to change your mind', unit: '必修一 Unit 3', difficulty: 2, sentence: 'He was stubborn and refused to change the plan.', sentenceTranslation: '他很固执，拒绝改变计划。'),
    _word(id: 'u3_14', word: 'organize', phonetic: '/ˈɔːɡənaɪz/', partOfSpeech: 'v.', translation: '组织', definition: 'to arrange things in order', unit: '必修一 Unit 3', difficulty: 2, sentence: 'Students organized a school trip to the museum.', sentenceTranslation: '学生们组织了一次去博物馆的校外活动。'),
    _word(id: 'u3_15', word: 'familiar', phonetic: '/fəˈmɪliə/', partOfSpeech: 'adj.', translation: '熟悉的', definition: 'well known to you', unit: '必修一 Unit 3', difficulty: 2, sentence: 'The song sounded familiar to me.', sentenceTranslation: '那首歌听起来我很熟悉。'),
    _word(id: 'u3_16', word: 'beneath', phonetic: '/bɪˈniːθ/', partOfSpeech: 'prep.', translation: '在……下面', definition: 'under something', unit: '必修一 Unit 3', difficulty: 3, sentence: 'A small village lies beneath the mountain.', sentenceTranslation: '山下有一个小村庄。'),
  ];

  static List<String> get units => ['必修一 Unit 1', '必修一 Unit 2', '必修一 Unit 3'];

  static Map<String, List<WordModel>> groupedByUnit() {
    final map = <String, List<WordModel>>{};
    for (final unit in units) {
      map[unit] = allWords.where((word) => word.tags.contains(unit)).toList();
    }
    return map;
  }
}
