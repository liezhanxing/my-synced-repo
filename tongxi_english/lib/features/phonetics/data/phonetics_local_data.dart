import '../../../models/phonetic_model.dart';
import '../domain/phonetics_practice_models.dart';

class PhoneticsLocalData {
  PhoneticsLocalData._();

  static PhoneticModel _item({
    required String id,
    required String symbol,
    required List<String> spellings,
    required String description,
    required List<PhoneticExample> examples,
    required PhoneticCategory category,
    int difficulty = 1,
  }) {
    return PhoneticModel(
      id: id,
      symbol: symbol,
      spellings: spellings,
      description: description,
      audioUrl: '',
      examples: examples,
      category: category,
      difficulty: difficulty,
    );
  }

  static PhoneticExample _ex(String word, String phonetic, String meaning) {
    return PhoneticExample(
      word: word,
      phoneticSpelling: phonetic,
      meaning: meaning,
    );
  }

  static List<PhoneticModel> getAllPhonetics() {
    return [...getVowels(), ...getDiphthongs(), ...getConsonants()];
  }

  static List<PhoneticModel> getVowels() {
    return [
      _item(
        id: 'v_1',
        symbol: 'iː',
        spellings: ['ee', 'ea', 'e'],
        description: '长元音，嘴角向两侧展开，舌前部抬高，声音拉长。',
        examples: [_ex('see', '/siː/', '看见'), _ex('teacher', '/ˈtiːtʃə/', '老师'), _ex('green', '/ɡriːn/', '绿色的')],
        category: PhoneticCategory.vowel,
      ),
      _item(
        id: 'v_2',
        symbol: 'ɪ',
        spellings: ['i', 'y', 'ui'],
        description: '短元音，口型比/iː/放松，发音短促轻快。',
        examples: [_ex('sit', '/sɪt/', '坐'), _ex('milk', '/mɪlk/', '牛奶'), _ex('busy', '/ˈbɪzi/', '忙碌的')],
        category: PhoneticCategory.vowel,
      ),
      _item(
        id: 'v_3',
        symbol: 'e',
        spellings: ['e', 'ea'],
        description: '短元音，嘴巴微张，舌前部稍抬。',
        examples: [_ex('bed', '/bed/', '床'), _ex('head', '/hed/', '头'), _ex('many', '/ˈmeni/', '许多')],
        category: PhoneticCategory.vowel,
      ),
      _item(
        id: 'v_4',
        symbol: 'æ',
        spellings: ['a'],
        description: '短元音，嘴巴张得更大，舌尖抵下齿。',
        examples: [_ex('cat', '/kæt/', '猫'), _ex('apple', '/ˈæpl/', '苹果'), _ex('match', '/mætʃ/', '比赛')],
        category: PhoneticCategory.vowel,
      ),
      _item(
        id: 'v_5',
        symbol: 'ʌ',
        spellings: ['u', 'o', 'ou'],
        description: '短元音，口型自然放松，舌位居中。',
        examples: [_ex('cup', '/kʌp/', '杯子'), _ex('love', '/lʌv/', '爱'), _ex('young', '/jʌŋ/', '年轻的')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
      _item(
        id: 'v_6',
        symbol: 'ɒ',
        spellings: ['o', 'a'],
        description: '短元音，双唇微圆，舌后部抬起，偏英式。',
        examples: [_ex('hot', '/hɒt/', '热的'), _ex('dog', '/dɒɡ/', '狗'), _ex('watch', '/wɒtʃ/', '观看')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
      _item(
        id: 'v_7',
        symbol: 'ʊ',
        spellings: ['oo', 'u'],
        description: '短元音，嘴唇收圆但较松，声音短。',
        examples: [_ex('book', '/bʊk/', '书'), _ex('good', '/ɡʊd/', '好的'), _ex('put', '/pʊt/', '放')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
      _item(
        id: 'v_8',
        symbol: 'ə',
        spellings: ['a', 'e', 'o', 'u'],
        description: '弱读中央元音，最常见于非重读音节。',
        examples: [_ex('about', '/əˈbaʊt/', '关于'), _ex('teacher', '/ˈtiːtʃə/', '老师'), _ex('today', '/təˈdeɪ/', '今天')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
      _item(
        id: 'v_9',
        symbol: 'ɑː',
        spellings: ['ar', 'a'],
        description: '长元音，嘴巴张大，舌后部放低，声音饱满。',
        examples: [_ex('car', '/kɑː/', '汽车'), _ex('father', '/ˈfɑːðə/', '父亲'), _ex('class', '/klɑːs/', '班级')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
      _item(
        id: 'v_10',
        symbol: 'ɔː',
        spellings: ['or', 'aw', 'au'],
        description: '长元音，双唇收圆，声音较深。',
        examples: [_ex('door', '/dɔː/', '门'), _ex('small', '/smɔːl/', '小的'), _ex('autumn', '/ˈɔːtəm/', '秋天')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
      _item(
        id: 'v_11',
        symbol: 'ɜː',
        spellings: ['ir', 'er', 'ur'],
        description: '长元音，舌位居中，唇形自然，卷舌色彩弱。',
        examples: [_ex('bird', '/bɜːd/', '鸟'), _ex('nurse', '/nɜːs/', '护士'), _ex('turn', '/tɜːn/', '转动')],
        category: PhoneticCategory.vowel,
        difficulty: 3,
      ),
      _item(
        id: 'v_12',
        symbol: 'uː',
        spellings: ['oo', 'u', 'ue'],
        description: '长元音，双唇明显收圆，舌后部抬高。',
        examples: [_ex('blue', '/bluː/', '蓝色的'), _ex('food', '/fuːd/', '食物'), _ex('student', '/ˈstjuːdnt/', '学生')],
        category: PhoneticCategory.vowel,
        difficulty: 2,
      ),
    ];
  }

  static List<PhoneticModel> getDiphthongs() {
    return [
      _item(
        id: 'd_1',
        symbol: 'eɪ',
        spellings: ['a', 'ai', 'ay'],
        description: '双元音，从/e/滑向/ɪ/，口型逐渐收窄。',
        examples: [_ex('day', '/deɪ/', '白天'), _ex('make', '/meɪk/', '制作'), _ex('rain', '/reɪn/', '雨')],
        category: PhoneticCategory.diphthong,
      ),
      _item(
        id: 'd_2',
        symbol: 'aɪ',
        spellings: ['i', 'y', 'igh'],
        description: '双元音，从/a/滑向/ɪ/，类似中文“爱”。',
        examples: [_ex('my', '/maɪ/', '我的'), _ex('time', '/taɪm/', '时间'), _ex('light', '/laɪt/', '光')],
        category: PhoneticCategory.diphthong,
      ),
      _item(
        id: 'd_3',
        symbol: 'ɔɪ',
        spellings: ['oi', 'oy'],
        description: '双元音，从/ɔ/滑向/ɪ/，先圆后扁。',
        examples: [_ex('boy', '/bɔɪ/', '男孩'), _ex('choice', '/tʃɔɪs/', '选择'), _ex('toy', '/tɔɪ/', '玩具')],
        category: PhoneticCategory.diphthong,
        difficulty: 2,
      ),
      _item(
        id: 'd_4',
        symbol: 'aʊ',
        spellings: ['ou', 'ow'],
        description: '双元音，从/a/滑向/ʊ/，类似中文“奥”。',
        examples: [_ex('now', '/naʊ/', '现在'), _ex('house', '/haʊs/', '房子'), _ex('flower', '/ˈflaʊə/', '花')],
        category: PhoneticCategory.diphthong,
      ),
      _item(
        id: 'd_5',
        symbol: 'əʊ',
        spellings: ['o', 'oa', 'ow'],
        description: '双元音，从/ə/滑向/ʊ/，英式常见。',
        examples: [_ex('go', '/ɡəʊ/', '去'), _ex('home', '/həʊm/', '家'), _ex('show', '/ʃəʊ/', '展示')],
        category: PhoneticCategory.diphthong,
      ),
      _item(
        id: 'd_6',
        symbol: 'ɪə',
        spellings: ['ear', 'eer'],
        description: '集中双元音，从/ɪ/滑向/ə/。',
        examples: [_ex('ear', '/ɪə/', '耳朵'), _ex('near', '/nɪə/', '近的'), _ex('idea', '/aɪˈdɪə/', '想法')],
        category: PhoneticCategory.diphthong,
        difficulty: 3,
      ),
      _item(
        id: 'd_7',
        symbol: 'eə',
        spellings: ['air', 'are', 'ear'],
        description: '集中双元音，从/e/滑向/ə/。',
        examples: [_ex('air', '/eə/', '空气'), _ex('care', '/keə/', '关心'), _ex('bear', '/beə/', '熊')],
        category: PhoneticCategory.diphthong,
        difficulty: 3,
      ),
      _item(
        id: 'd_8',
        symbol: 'ʊə',
        spellings: ['ure', 'our'],
        description: '集中双元音，从/ʊ/滑向/ə/，现代口语中较少。',
        examples: [_ex('tour', '/tʊə/', '旅行'), _ex('pure', '/pjʊə/', '纯净的'), _ex('cure', '/kjʊə/', '治愈')],
        category: PhoneticCategory.diphthong,
        difficulty: 4,
      ),
    ];
  }

  static List<PhoneticModel> getConsonants() {
    return [
      _item(
        id: 'c_1',
        symbol: 'p',
        spellings: ['p', 'pp'],
        description: '清双唇爆破音，双唇闭合后突然放开，不振动声带。',
        examples: [_ex('pen', '/pen/', '钢笔'), _ex('apple', '/ˈæpl/', '苹果'), _ex('map', '/mæp/', '地图')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_2',
        symbol: 'b',
        spellings: ['b', 'bb'],
        description: '浊双唇爆破音，与/p/口型相同但声带振动。',
        examples: [_ex('book', '/bʊk/', '书'), _ex('baby', '/ˈbeɪbi/', '婴儿'), _ex('job', '/dʒɒb/', '工作')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_3',
        symbol: 't',
        spellings: ['t', 'tt', 'ed'],
        description: '清齿龈爆破音，舌尖抵上齿龈后迅速放开。',
        examples: [_ex('time', '/taɪm/', '时间'), _ex('letter', '/ˈletə/', '信'), _ex('cat', '/kæt/', '猫')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_4',
        symbol: 'd',
        spellings: ['d', 'dd', 'ed'],
        description: '浊齿龈爆破音，口型与/t/相近但声带振动。',
        examples: [_ex('dog', '/dɒɡ/', '狗'), _ex('day', '/deɪ/', '白天'), _ex('under', '/ˈʌndə/', '在下面')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_5',
        symbol: 'k',
        spellings: ['k', 'c', 'ck', 'qu'],
        description: '清软腭爆破音，舌后部抵住软腭再放开。',
        examples: [_ex('key', '/kiː/', '钥匙'), _ex('cat', '/kæt/', '猫'), _ex('school', '/skuːl/', '学校')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_6',
        symbol: 'g',
        spellings: ['g', 'gg'],
        description: '浊软腭爆破音，发音位置与/k/相同。',
        examples: [_ex('go', '/ɡəʊ/', '去'), _ex('green', '/ɡriːn/', '绿色的'), _ex('big', '/bɪɡ/', '大的')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_7',
        symbol: 'f',
        spellings: ['f', 'ph'],
        description: '清唇齿摩擦音，上齿轻触下唇。',
        examples: [_ex('fish', '/fɪʃ/', '鱼'), _ex('photo', '/ˈfəʊtəʊ/', '照片'), _ex('life', '/laɪf/', '生活')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_8',
        symbol: 'v',
        spellings: ['v'],
        description: '浊唇齿摩擦音，发音位置与/f/相同但声带振动。',
        examples: [_ex('very', '/ˈveri/', '非常'), _ex('voice', '/vɔɪs/', '声音'), _ex('love', '/lʌv/', '爱')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_9',
        symbol: 'θ',
        spellings: ['th'],
        description: '清齿间摩擦音，舌尖轻触上齿。',
        examples: [_ex('think', '/θɪŋk/', '思考'), _ex('three', '/θriː/', '三'), _ex('mouth', '/maʊθ/', '嘴')],
        category: PhoneticCategory.consonant,
        difficulty: 3,
      ),
      _item(
        id: 'c_10',
        symbol: 'ð',
        spellings: ['th'],
        description: '浊齿间摩擦音，是/θ/的浊音对应。',
        examples: [_ex('this', '/ðɪs/', '这个'), _ex('mother', '/ˈmʌðə/', '母亲'), _ex('they', '/ðeɪ/', '他们')],
        category: PhoneticCategory.consonant,
        difficulty: 3,
      ),
      _item(
        id: 'c_11',
        symbol: 's',
        spellings: ['s', 'ss', 'c'],
        description: '清齿龈摩擦音，舌尖接近上齿龈。',
        examples: [_ex('sun', '/sʌn/', '太阳'), _ex('class', '/klɑːs/', '班级'), _ex('city', '/ˈsɪti/', '城市')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_12',
        symbol: 'z',
        spellings: ['z', 's'],
        description: '浊齿龈摩擦音，与/s/对应。',
        examples: [_ex('zoo', '/zuː/', '动物园'), _ex('easy', '/ˈiːzi/', '容易的'), _ex('music', '/ˈmjuːzɪk/', '音乐')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_13',
        symbol: 'ʃ',
        spellings: ['sh', 'ti', 'ci'],
        description: '清后齿龈摩擦音，双唇略圆。',
        examples: [_ex('ship', '/ʃɪp/', '船'), _ex('she', '/ʃiː/', '她'), _ex('special', '/ˈspeʃl/', '特别的')],
        category: PhoneticCategory.consonant,
        difficulty: 2,
      ),
      _item(
        id: 'c_14',
        symbol: 'ʒ',
        spellings: ['s', 'si', 'ge'],
        description: '浊后齿龈摩擦音，常出现在词中间。',
        examples: [_ex('vision', '/ˈvɪʒn/', '视力'), _ex('measure', '/ˈmeʒə/', '测量'), _ex('usual', '/ˈjuːʒuəl/', '通常的')],
        category: PhoneticCategory.consonant,
        difficulty: 3,
      ),
      _item(
        id: 'c_15',
        symbol: 'h',
        spellings: ['h', 'wh'],
        description: '清声门摩擦音，气流从喉部轻轻送出。',
        examples: [_ex('happy', '/ˈhæpi/', '快乐的'), _ex('home', '/həʊm/', '家'), _ex('who', '/huː/', '谁')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_16',
        symbol: 'tʃ',
        spellings: ['ch', 'tch'],
        description: '清破擦音，先堵后擦，接近中文“吃”。',
        examples: [_ex('chair', '/tʃeə/', '椅子'), _ex('teacher', '/ˈtiːtʃə/', '老师'), _ex('watch', '/wɒtʃ/', '手表')],
        category: PhoneticCategory.consonant,
        difficulty: 2,
      ),
      _item(
        id: 'c_17',
        symbol: 'dʒ',
        spellings: ['j', 'g', 'dge'],
        description: '浊破擦音，接近中文“知”。',
        examples: [_ex('job', '/dʒɒb/', '工作'), _ex('page', '/peɪdʒ/', '页'), _ex('bridge', '/brɪdʒ/', '桥')],
        category: PhoneticCategory.consonant,
        difficulty: 2,
      ),
      _item(
        id: 'c_18',
        symbol: 'm',
        spellings: ['m', 'mm'],
        description: '双唇鼻音，双唇闭合，气流从鼻腔通过。',
        examples: [_ex('milk', '/mɪlk/', '牛奶'), _ex('summer', '/ˈsʌmə/', '夏天'), _ex('team', '/tiːm/', '团队')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_19',
        symbol: 'n',
        spellings: ['n', 'nn', 'kn'],
        description: '齿龈鼻音，舌尖抵住上齿龈。',
        examples: [_ex('name', '/neɪm/', '名字'), _ex('sunny', '/ˈsʌni/', '晴朗的'), _ex('know', '/nəʊ/', '知道')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_20',
        symbol: 'ŋ',
        spellings: ['ng', 'n'],
        description: '软腭鼻音，舌后部抬起，词尾常见。',
        examples: [_ex('song', '/sɒŋ/', '歌曲'), _ex('English', '/ˈɪŋɡlɪʃ/', '英语'), _ex('think', '/θɪŋk/', '思考')],
        category: PhoneticCategory.consonant,
        difficulty: 2,
      ),
      _item(
        id: 'c_21',
        symbol: 'l',
        spellings: ['l', 'll'],
        description: '舌侧音，舌尖抵上齿龈，气流从舌侧通过。',
        examples: [_ex('love', '/lʌv/', '爱'), _ex('yellow', '/ˈjeləʊ/', '黄色'), _ex('school', '/skuːl/', '学校')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_22',
        symbol: 'r',
        spellings: ['r', 'wr'],
        description: '卷舌近音，舌尖上卷但不真正接触。',
        examples: [_ex('red', '/red/', '红色'), _ex('write', '/raɪt/', '写'), _ex('green', '/ɡriːn/', '绿色')],
        category: PhoneticCategory.consonant,
        difficulty: 2,
      ),
      _item(
        id: 'c_23',
        symbol: 'w',
        spellings: ['w', 'wh'],
        description: '双唇近音，双唇先收圆再滑向元音。',
        examples: [_ex('we', '/wiː/', '我们'), _ex('window', '/ˈwɪndəʊ/', '窗户'), _ex('what', '/wɒt/', '什么')],
        category: PhoneticCategory.consonant,
      ),
      _item(
        id: 'c_24',
        symbol: 'j',
        spellings: ['y', 'u'],
        description: '硬腭近音，接近汉语“衣”的起始滑音。',
        examples: [_ex('yes', '/jes/', '是的'), _ex('year', '/jɪə/', '年'), _ex('use', '/juːz/', '使用')],
        category: PhoneticCategory.consonant,
      ),
    ];
  }

  static List<PhoneticModel> getPhoneticsByCategory(PhoneticCategory category) {
    switch (category) {
      case PhoneticCategory.vowel:
        return getVowels();
      case PhoneticCategory.diphthong:
        return getDiphthongs();
      case PhoneticCategory.consonant:
        return getConsonants();
    }
  }

  static PhoneticModel? getPhoneticById(String id) {
    try {
      return getAllPhonetics().firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<PhoneticsExercise> getPracticeExercises() {
    return const [
      PhoneticsExercise(id: 'p1', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'v_1', optionIds: ['v_1', 'v_2', 'v_3', 'v_4'], audioText: 'see', hint: '长音，像“衣——”'),
      PhoneticsExercise(id: 'p2', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'v_4', optionIds: ['v_3', 'v_4', 'v_5', 'd_1'], audioText: 'cat', hint: '开口更大'),
      PhoneticsExercise(id: 'p3', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'd_2', optionIds: ['d_1', 'd_2', 'd_4', 'v_9'], audioText: 'time', hint: '像“爱”'),
      PhoneticsExercise(id: 'p4', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'c_9', optionIds: ['c_7', 'c_9', 'c_10', 'c_11'], audioText: 'think', hint: '舌尖轻咬'),
      PhoneticsExercise(id: 'p5', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'c_16', optionIds: ['c_13', 'c_16', 'c_17', 'c_24'], audioText: 'chair'),
      PhoneticsExercise(id: 'p6', type: PhoneticsExerciseType.wordToPhonetic, prompt: '看到单词，选出划线部分最接近的音标', correctAnswerId: 'v_12', optionIds: ['v_7', 'v_12', 'd_5', 'v_11'], displayWord: 'blue'),
      PhoneticsExercise(id: 'p7', type: PhoneticsExerciseType.wordToPhonetic, prompt: '看到单词，选出划线部分最接近的音标', correctAnswerId: 'v_8', optionIds: ['v_8', 'v_11', 'd_6', 'v_5'], displayWord: 'about'),
      PhoneticsExercise(id: 'p8', type: PhoneticsExerciseType.wordToPhonetic, prompt: '看到单词，选出划线部分最接近的音标', correctAnswerId: 'c_20', optionIds: ['c_18', 'c_19', 'c_20', 'c_21'], displayWord: 'English'),
      PhoneticsExercise(id: 'p9', type: PhoneticsExerciseType.wordToPhonetic, prompt: '看到单词，选出划线部分最接近的音标', correctAnswerId: 'd_5', optionIds: ['d_1', 'd_3', 'd_4', 'd_5'], displayWord: 'home'),
      PhoneticsExercise(id: 'p10', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'c_22', optionIds: ['c_21', 'c_22', 'c_23', 'c_24'], audioText: 'red'),
      PhoneticsExercise(id: 'p11', type: PhoneticsExerciseType.wordToPhonetic, prompt: '看到单词，选出划线部分最接近的音标', correctAnswerId: 'c_17', optionIds: ['c_13', 'c_16', 'c_17', 'c_14'], displayWord: 'job'),
      PhoneticsExercise(id: 'p12', type: PhoneticsExerciseType.listenAndChoose, prompt: '听发音，选出正确的音标', correctAnswerId: 'd_7', optionIds: ['d_6', 'd_7', 'd_8', 'v_3'], audioText: 'care'),
    ];
  }

  static Map<String, List<PhoneticModel>> getConsonantGroups() {
    final all = getConsonants();
    return {
      '爆破音': [for (final id in ['c_1', 'c_2', 'c_3', 'c_4', 'c_5', 'c_6']) getPhoneticById(id)!],
      '摩擦音': [for (final id in ['c_7', 'c_8', 'c_9', 'c_10', 'c_11', 'c_12', 'c_13', 'c_14', 'c_15']) getPhoneticById(id)!],
      '破擦音': [for (final id in ['c_16', 'c_17']) getPhoneticById(id)!],
      '鼻音': [for (final id in ['c_18', 'c_19', 'c_20']) getPhoneticById(id)!],
      '近音/边音': [for (final id in ['c_21', 'c_22', 'c_23', 'c_24']) getPhoneticById(id)!],
      '全部辅音': all,
    };
  }

  static Map<String, List<PhoneticModel>> getVowelGroups() {
    return {
      '单元音': getVowels(),
      '双元音': getDiphthongs(),
    };
  }

  static List<PhoneticModel> getSimilarSounds(String symbol) {
    final mapping = <String, List<String>>{
      'iː': ['ɪ'],
      'ɪ': ['iː', 'e'],
      'e': ['æ', 'ɪ'],
      'æ': ['e', 'ʌ'],
      'ʌ': ['ɑː', 'æ'],
      'ɒ': ['ɔː'],
      'ʊ': ['uː'],
      'uː': ['ʊ'],
      'ə': ['ɜː'],
      'ɜː': ['ə'],
      'eɪ': ['aɪ'],
      'aɪ': ['eɪ', 'aʊ'],
      'θ': ['ð', 's'],
      'ð': ['θ', 'z'],
      'ʃ': ['ʒ', 'tʃ'],
      'ʒ': ['ʃ', 'dʒ'],
      'tʃ': ['ʃ', 'dʒ'],
      'dʒ': ['tʃ', 'ʒ'],
      'l': ['r'],
      'r': ['l'],
      'w': ['v'],
      'v': ['w', 'f'],
    };
    final targets = mapping[symbol] ?? const [];
    return getAllPhonetics().where((item) => targets.contains(item.symbol)).toList();
  }
}
