import '../../../models/reading_model.dart';

/// Local data source for reading passages
/// 
/// Contains hardcoded sample passages for offline use and testing.
/// Organized by difficulty level: 1=高一(Easy), 2=高二(Medium), 3=高三(Hard)
class ReadingLocalData {
  ReadingLocalData._();

  /// Get all sample reading passages
  static List<ReadingModel> getAllPassages() {
    return [
      ..._easyPassages,
      ..._mediumPassages,
      ..._hardPassages,
    ];
  }

  /// Get passages by difficulty level
  static List<ReadingModel> getPassagesByDifficulty(int difficulty) {
    return getAllPassages()
        .where((passage) => passage.difficulty == difficulty)
        .toList();
  }

  /// Get passage by ID
  static ReadingModel? getPassageById(String id) {
    try {
      return getAllPassages().firstWhere((passage) => passage.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== EASY PASSAGES (高一) ====================
  
  static final List<ReadingModel> _easyPassages = [
    // Easy 1: School Life
    ReadingModel(
      id: 'reading_easy_001',
      title: 'My First Day at High School',
      content: '''My first day at high school was both exciting and nerve-wracking. I woke up early, put on my new uniform, and ate a quick breakfast. My mother drove me to school, and when we arrived, I saw hundreds of students walking through the gates.

The school building was much bigger than my middle school. I had trouble finding my classroom, but a friendly senior student helped me. My homeroom teacher, Mr. Zhang, welcomed us warmly. He told us that high school would be challenging but rewarding.

During the first week, I made several new friends. We sat together at lunch and shared stories about our summer vacations. My favorite subject so far is English because our teacher makes the lessons fun and interactive.

Although the homework is more difficult than before, I am determined to do my best. I joined the school's English club to practice speaking with other students. High school is a new chapter in my life, and I am ready to embrace all the opportunities it offers.''',
      source: 'Student Essay Collection',
      wordCount: 178,
      difficulty: 1,
      category: ReadingCategory.story,
      tags: ['school', 'personal', 'narrative'],
      estimatedTime: 5,
      vocabulary: [
        ReadingVocabulary(
          word: 'nerve-wracking',
          phonetic: '/ˈnɜːv rækɪŋ/',
          definition: 'making you feel very nervous and worried',
          translation: '令人紧张的',
        ),
        ReadingVocabulary(
          word: 'uniform',
          phonetic: '/ˈjuːnɪfɔːm/',
          definition: 'the special set of clothes worn by members of the same organization',
          translation: '校服，制服',
        ),
        ReadingVocabulary(
          word: 'rewarding',
          phonetic: '/rɪˈwɔːdɪŋ/',
          definition: 'giving satisfaction, pleasure, or profit',
          translation: '有回报的，值得的',
        ),
        ReadingVocabulary(
          word: 'interactive',
          phonetic: '/ˌɪntərˈæktɪv/',
          definition: 'allowing communication between the user and the computer or between users',
          translation: '互动的，交互的',
        ),
        ReadingVocabulary(
          word: 'determined',
          phonetic: '/dɪˈtɜːrmɪnd/',
          definition: 'having made a firm decision and being resolved not to change it',
          translation: '坚定的，决心的',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'q1_001',
          question: 'How did the author feel on the first day of high school?',
          options: ['Only excited', 'Only nervous', 'Both excited and nervous', 'Neither excited nor nervous'],
          correctAnswer: 2,
          explanation: 'The first sentence states: "My first day at high school was both exciting and nerve-wracking."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q1_002',
          question: 'Who helped the author find the classroom?',
          options: ['Mr. Zhang', 'A senior student', 'His mother', 'A classmate'],
          correctAnswer: 1,
          explanation: 'The text mentions: "I had trouble finding my classroom, but a friendly senior student helped me."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q1_003',
          question: 'What is the author\'s favorite subject?',
          options: ['Mathematics', 'Chinese', 'English', 'Physics'],
          correctAnswer: 2,
          explanation: 'The text clearly states: "My favorite subject so far is English because our teacher makes the lessons fun and interactive."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q1_004',
          question: 'The author joined the English club to practice writing.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The text says the author joined "to practice speaking with other students," not writing.',
          type: QuestionType.trueFalse,
        ),
      ],
    ),

    // Easy 2: Hobbies
    ReadingModel(
      id: 'reading_easy_002',
      title: 'The Joy of Reading',
      content: '''In my free time, I love to read books. Reading has been my favorite hobby since I was eight years old. My father gave me my first book, "Charlotte\'s Web," and I have been hooked ever since.

Every weekend, I visit the local library to borrow new books. The librarian knows me well and often recommends interesting titles. I enjoy reading various genres, including mystery novels, science fiction, and biographies of famous people.

Reading offers many benefits. It improves my vocabulary and helps me understand different cultures. When I read, I can travel to distant lands and meet fascinating characters without leaving my room. It also helps me relax after a long day of studying.

My favorite place to read is a cozy corner in my bedroom. I have a comfortable chair and a small lamp there. Sometimes, I lose track of time and read until midnight. My parents often remind me to get enough sleep!

I hope to write my own book someday. Reading has taught me so much about storytelling, and I want to share my own stories with others.''',
      source: 'Youth Magazine',
      wordCount: 186,
      difficulty: 1,
      category: ReadingCategory.story,
      tags: ['hobbies', 'reading', 'personal'],
      estimatedTime: 5,
      vocabulary: [
        ReadingVocabulary(
          word: 'hooked',
          phonetic: '/hʊkt/',
          definition: 'enjoying something so much that you cannot stop',
          translation: '入迷的，上瘾的',
        ),
        ReadingVocabulary(
          word: 'recommend',
          phonetic: '/ˌrekəˈmend/',
          definition: 'to advise someone to do or use something',
          translation: '推荐',
        ),
        ReadingVocabulary(
          word: 'genre',
          phonetic: '/ˈʒɑːnrə/',
          definition: 'a particular type of literature, art, or music',
          translation: '体裁，类型',
        ),
        ReadingVocabulary(
          word: 'biography',
          phonetic: '/baɪˈɑːɡrəfi/',
          definition: 'the story of a person\'s life written by someone else',
          translation: '传记',
        ),
        ReadingVocabulary(
          word: 'cozy',
          phonetic: '/ˈkoʊzi/',
          definition: 'comfortable, warm, and pleasant',
          translation: '舒适的，温馨的',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'q2_001',
          question: 'How old was the author when he/she started reading?',
          options: ['Six years old', 'Seven years old', 'Eight years old', 'Ten years old'],
          correctAnswer: 2,
          explanation: 'The text states: "Reading has been my favorite hobby since I was eight years old."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q2_002',
          question: 'What was the first book the author read?',
          options: ['Harry Potter', 'Charlotte\'s Web', 'The Little Prince', 'Alice in Wonderland'],
          correctAnswer: 1,
          explanation: 'The text mentions: "My father gave me my first book, \'Charlotte\'s Web,\' and I have been hooked ever since."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q2_003',
          question: 'Which of the following is NOT mentioned as a benefit of reading?',
          options: ['Improving vocabulary', 'Understanding different cultures', 'Making new friends', 'Relaxing after studying'],
          correctAnswer: 2,
          explanation: 'The text mentions improving vocabulary, understanding cultures, and relaxing, but does not mention making new friends.',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q2_004',
          question: 'Where does the author like to read?',
          options: ['In the library', 'In a park', 'In a cozy corner of the bedroom', 'In the living room'],
          correctAnswer: 2,
          explanation: 'The text states: "My favorite place to read is a cozy corner in my bedroom."',
          type: QuestionType.multipleChoice,
        ),
      ],
    ),

    // Easy 3: Family
    ReadingModel(
      id: 'reading_easy_003',
      title: 'A Family Tradition',
      content: '''Every Sunday, my family has a special tradition. We cook dinner together and share stories about our week. This tradition started when I was young, and it has brought us closer as a family.

My mother usually prepares the main dish. She is an excellent cook and makes delicious Chinese food. My father helps by washing vegetables and setting the table. My younger sister and I are responsible for making dessert.

Last Sunday, we made dumplings together. My grandmother taught us her secret recipe. She showed us how to fold the dumplings properly so they would not break when boiled. It was messy but fun, and we laughed a lot when some dumplings looked funny.

During dinner, we talked about our plans for the upcoming holiday. My father suggested visiting the countryside to see my aunt. My mother wanted to stay home and rest. In the end, we decided to have a short trip to a nearby city.

These Sunday dinners are important to me. They remind me that family is precious, and spending time together is the best gift we can give each other. I hope to continue this tradition when I have my own family someday.''',
      source: 'Family Life Magazine',
      wordCount: 192,
      difficulty: 1,
      category: ReadingCategory.story,
      tags: ['family', 'tradition', 'food'],
      estimatedTime: 5,
      vocabulary: [
        ReadingVocabulary(
          word: 'tradition',
          phonetic: '/trəˈdɪʃn/',
          definition: 'a belief, custom, or way of doing something that has existed for a long time',
          translation: '传统',
        ),
        ReadingVocabulary(
          word: 'excellent',
          phonetic: '/ˈeksələnt/',
          definition: 'extremely good; of very high quality',
          translation: '优秀的，极好的',
        ),
        ReadingVocabulary(
          word: 'responsible',
          phonetic: '/rɪˈspɑːnsəbl/',
          definition: 'having the duty to take care of something',
          translation: '负责的',
        ),
        ReadingVocabulary(
          word: 'properly',
          phonetic: '/ˈprɑːpərli/',
          definition: 'in a way that is correct or appropriate',
          translation: '正确地，恰当地',
        ),
        ReadingVocabulary(
          word: 'precious',
          phonetic: '/ˈpreʃəs/',
          definition: 'of great value and deserving to be protected',
          translation: '珍贵的',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'q3_001',
          question: 'When does the family have their special tradition?',
          options: ['Every Saturday', 'Every Sunday', 'Every Friday', 'Every holiday'],
          correctAnswer: 1,
          explanation: 'The first sentence states: "Every Sunday, my family has a special tradition."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q3_002',
          question: 'What did the family make last Sunday?',
          options: ['Noodles', 'Rice', 'Dumplings', 'Cake'],
          correctAnswer: 2,
          explanation: 'The text says: "Last Sunday, we made dumplings together."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q3_003',
          question: 'Who taught the family the secret dumpling recipe?',
          options: ['Mother', 'Father', 'Grandmother', 'Aunt'],
          correctAnswer: 2,
          explanation: 'The text mentions: "My grandmother taught us her secret recipe."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q3_004',
          question: 'The author and his/her sister are responsible for making the main dish.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The text states that the author and sister are "responsible for making dessert," not the main dish.',
          type: QuestionType.trueFalse,
        ),
      ],
    ),

    // Easy 4: Sports
    ReadingModel(
      id: 'reading_easy_004',
      title: 'Learning to Swim',
      content: '''Last summer, I decided to learn how to swim. Many of my friends could swim well, and I felt embarrassed that I could not. I asked my parents to enroll me in swimming classes at the community pool.

On the first day, I was very nervous. The water looked deep and scary. My instructor, Coach Li, was patient and kind. He told me that everyone starts as a beginner and that I should not worry about making mistakes.

We started with basic breathing exercises. I practiced blowing bubbles in the water and holding my breath. Then, Coach Li taught me how to float on my back. At first, I sank like a stone, but after many tries, I finally floated for a few seconds.

By the end of the second week, I could swim across the shallow end of the pool. I was so proud of myself! My parents came to watch my progress and took many photos. My mother said I looked like a real swimmer.

Now, I can swim fifty meters without stopping. I go to the pool every Saturday to practice. Swimming has become my favorite exercise because it keeps me fit and cool during hot summer days. I am glad I overcame my fear of water.''',
      source: 'Sports for Youth',
      wordCount: 205,
      difficulty: 1,
      category: ReadingCategory.story,
      tags: ['sports', 'swimming', 'personal growth'],
      estimatedTime: 6,
      vocabulary: [
        ReadingVocabulary(
          word: 'embarrassed',
          phonetic: '/ɪmˈbærəst/',
          definition: 'feeling ashamed, shy, or awkward',
          translation: '尴尬的，难为情的',
        ),
        ReadingVocabulary(
          word: 'enroll',
          phonetic: '/ɪnˈroʊl/',
          definition: 'to officially join a course, school, or program',
          translation: '注册，报名',
        ),
        ReadingVocabulary(
          word: 'patient',
          phonetic: '/ˈpeɪʃnt/',
          definition: 'able to wait calmly for something',
          translation: '耐心的',
        ),
        ReadingVocabulary(
          word: 'sink',
          phonetic: '/sɪŋk/',
          definition: 'to go down below the surface of water',
          translation: '下沉',
        ),
        ReadingVocabulary(
          word: 'overcome',
          phonetic: '/ˌoʊvərˈkʌm/',
          definition: 'to successfully deal with a problem',
          translation: '克服',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'q4_001',
          question: 'Why did the author decide to learn swimming?',
          options: ['Parents forced him/her', 'Friends could swim and he/she felt embarrassed', 'School required it', 'Wanted to join a competition'],
          correctAnswer: 1,
          explanation: 'The text states: "Many of my friends could swim well, and I felt embarrassed that I could not."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q4_002',
          question: 'What did the author practice first?',
          options: ['Floating', 'Breathing exercises', 'Kicking', 'Arm movements'],
          correctAnswer: 1,
          explanation: 'The text mentions: "We started with basic breathing exercises."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q4_003',
          question: 'How long did it take the author to swim across the shallow end?',
          options: ['One week', 'Two weeks', 'One month', 'Three weeks'],
          correctAnswer: 1,
          explanation: 'The text says: "By the end of the second week, I could swim across the shallow end of the pool."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'q4_004',
          question: 'When does the author go to the pool to practice now?',
          options: ['Every day', 'Every Saturday', 'Every Sunday', 'Twice a week'],
          correctAnswer: 1,
          explanation: 'The text states: "I go to the pool every Saturday to practice."',
          type: QuestionType.multipleChoice,
        ),
      ],
    ),
  ];

  // ==================== MEDIUM PASSAGES (高二) ====================
  
  static final List<ReadingModel> _mediumPassages = [
    // Medium 1: Environment
    ReadingModel(
      id: 'reading_medium_001',
      title: 'The Importance of Urban Green Spaces',
      content: '''In modern cities, concrete buildings and busy streets dominate the landscape. However, urban green spaces such as parks, gardens, and green roofs play a crucial role in maintaining the health and well-being of city residents. These natural areas provide numerous benefits that extend far beyond their aesthetic appeal.

Firstly, green spaces significantly improve air quality. Trees and plants absorb carbon dioxide and release oxygen, filtering harmful pollutants from the air. Studies have shown that neighborhoods with more trees have lower rates of respiratory diseases among residents. In heavily polluted cities, urban forests can reduce airborne particles by up to 60 percent.

Secondly, access to nature has profound effects on mental health. Research conducted by the University of Exeter found that people who spend at least two hours per week in natural environments report better psychological well-being. Green spaces offer a peaceful retreat from the stress of urban life, reducing anxiety and depression symptoms.

Furthermore, urban parks promote physical activity. When people have access to pleasant outdoor areas, they are more likely to walk, jog, or exercise regularly. This helps combat the growing problem of obesity and related health issues in urban populations.

Finally, green spaces strengthen community bonds. Parks serve as gathering places where neighbors meet, children play together, and community events take place. These interactions build social connections and create a sense of belonging among residents.

Despite these benefits, many cities continue to prioritize development over green space preservation. Urban planners must recognize that investing in nature is investing in public health and community welfare.''',
      source: 'Environmental Science Quarterly',
      wordCount: 258,
      difficulty: 2,
      category: ReadingCategory.science,
      tags: ['environment', 'health', 'urban planning'],
      estimatedTime: 7,
      vocabulary: [
        ReadingVocabulary(
          word: 'dominate',
          phonetic: '/ˈdɑːmɪneɪt/',
          definition: 'to be the most important or conspicuous feature',
          translation: '主导，支配',
        ),
        ReadingVocabulary(
          word: 'aesthetic',
          phonetic: '/esˈθetɪk/',
          definition: 'concerned with beauty or the appreciation of beauty',
          translation: '美学的，审美的',
        ),
        ReadingVocabulary(
          word: 'respiratory',
          phonetic: '/ˈrespərətɔːri/',
          definition: 'relating to the action of breathing',
          translation: '呼吸的',
        ),
        ReadingVocabulary(
          word: 'profound',
          phonetic: '/prəˈfaʊnd/',
          definition: 'having deep insight or understanding; intense',
          translation: '深远的，深刻的',
        ),
        ReadingVocabulary(
          word: 'combat',
          phonetic: '/ˈkɑːmbæt/',
          definition: 'to take action to reduce or prevent something bad',
          translation: '对抗，战斗',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'qm1_001',
          question: 'According to the passage, how much can urban forests reduce airborne particles?',
          options: ['Up to 30 percent', 'Up to 45 percent', 'Up to 60 percent', 'Up to 75 percent'],
          correctAnswer: 2,
          explanation: 'The text states: "In heavily polluted cities, urban forests can reduce airborne particles by up to 60 percent."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm1_002',
          question: 'What did the University of Exeter research find about nature exposure?',
          options: ['It has no effect on mental health', 'Two hours per week improves psychological well-being', 'Only long-term exposure helps', 'It only benefits physical health'],
          correctAnswer: 1,
          explanation: 'The text mentions: "Research conducted by the University of Exeter found that people who spend at least two hours per week in natural environments report better psychological well-being."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm1_003',
          question: 'Which of the following is NOT mentioned as a benefit of green spaces?',
          options: ['Improving air quality', 'Reducing traffic congestion', 'Promoting physical activity', 'Strengthening community bonds'],
          correctAnswer: 1,
          explanation: 'The passage discusses air quality, mental health, physical activity, and community bonds, but does not mention traffic congestion.',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm1_004',
          question: 'The author suggests that urban planners should prioritize development over green spaces.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The author argues the opposite: "Urban planners must recognize that investing in nature is investing in public health and community welfare."',
          type: QuestionType.trueFalse,
        ),
      ],
    ),

    // Medium 2: Technology
    ReadingModel(
      id: 'reading_medium_002',
      title: 'The Rise of Artificial Intelligence in Education',
      content: '''Artificial Intelligence (AI) is transforming every aspect of modern life, and education is no exception. From personalized learning platforms to automated grading systems, AI technologies are reshaping how students learn and how teachers teach. This revolution brings both exciting opportunities and important challenges.

One of the most significant advantages of AI in education is personalized learning. Traditional classrooms follow a one-size-fits-all approach, where all students learn the same material at the same pace. AI-powered systems can analyze each student\'s strengths, weaknesses, and learning patterns to create customized lesson plans. For example, if a student struggles with algebra but excels at geometry, the system will provide additional algebra practice while advancing the geometry curriculum.

Intelligent tutoring systems represent another breakthrough. These AI programs can answer student questions, explain difficult concepts, and provide immediate feedback 24 hours a day. Students in remote areas or those who cannot afford private tutors now have access to high-quality educational support. Research shows that students using AI tutors improve their test scores by an average of 30 percent.

However, the integration of AI in education raises valid concerns. Privacy is a major issue, as these systems collect vast amounts of data about students\' learning behaviors and personal information. There are also worries about over-reliance on technology reducing human interaction, which is essential for developing social skills and emotional intelligence.

Moreover, AI systems can perpetuate biases present in their training data. If the data reflects historical inequalities, the AI may recommend different educational paths for students based on gender, race, or socioeconomic background. Ensuring fairness in AI education tools requires careful monitoring and diverse data sets.

As we move forward, the goal should be using AI to enhance rather than replace human teachers. The most effective educational models will combine AI\'s analytical capabilities with teachers\' empathy, creativity, and mentorship. By addressing the challenges proactively, we can harness AI\'s potential to create more equitable and effective education for all students.''',
      source: 'Technology and Learning Review',
      wordCount: 312,
      difficulty: 2,
      category: ReadingCategory.science,
      tags: ['technology', 'AI', 'education'],
      estimatedTime: 8,
      vocabulary: [
        ReadingVocabulary(
          word: 'transform',
          phonetic: '/trænsˈfɔːrm/',
          definition: 'to change completely in form, appearance, or nature',
          translation: '转变，改变',
        ),
        ReadingVocabulary(
          word: 'personalized',
          phonetic: '/ˈpɜːrsənəlaɪzd/',
          definition: 'designed to meet someone\'s individual needs',
          translation: '个性化的',
        ),
        ReadingVocabulary(
          word: 'curriculum',
          phonetic: '/kəˈrɪkjələm/',
          definition: 'the subjects comprising a course of study in a school',
          translation: '课程',
        ),
        ReadingVocabulary(
          word: 'perpetuate',
          phonetic: '/pərˈpetʃueɪt/',
          definition: 'to make something continue indefinitely',
          translation: '使持续，使永久化',
        ),
        ReadingVocabulary(
          word: 'proactively',
          phonetic: '/proʊˈæktɪvli/',
          definition: 'by taking action to control a situation rather than just responding',
          translation: '积极主动地',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'qm2_001',
          question: 'According to the passage, how much do students improve using AI tutors?',
          options: ['10 percent', '20 percent', '30 percent', '40 percent'],
          correctAnswer: 2,
          explanation: 'The text states: "Research shows that students using AI tutors improve their test scores by an average of 30 percent."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm2_002',
          question: 'What is a major concern about AI in education mentioned in the passage?',
          options: ['AI is too expensive', 'Privacy issues with data collection', 'AI cannot teach math', 'Students do not like AI'],
          correctAnswer: 1,
          explanation: 'The text mentions: "Privacy is a major issue, as these systems collect vast amounts of data about students\' learning behaviors and personal information."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm2_003',
          question: 'What does the author suggest about the role of AI in education?',
          options: ['AI should replace all teachers', 'AI should enhance rather than replace human teachers', 'AI should only be used for grading', 'AI should not be used in education'],
          correctAnswer: 1,
          explanation: 'The text states: "As we move forward, the goal should be using AI to enhance rather than replace human teachers."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm2_004',
          question: 'AI systems can perpetuate biases if the training data reflects historical inequalities.',
          options: ['True', 'False'],
          correctAnswer: 0,
          explanation: 'The text confirms: "Moreover, AI systems can perpetuate biases present in their training data. If the data reflects historical inequalities..."',
          type: QuestionType.trueFalse,
        ),
      ],
    ),

    // Medium 3: Culture
    ReadingModel(
      id: 'reading_medium_003',
      title: 'The Art of Chinese Calligraphy',
      content: '''Chinese calligraphy, known as "Shufa" in Mandarin, is one of the most revered art forms in Chinese culture. Dating back over three thousand years, it represents much more than mere writing. Calligraphy is considered the highest form of visual art in China, combining literature, history, and personal expression into a single discipline.

The practice of calligraphy requires four essential tools, collectively known as the "Four Treasures of the Study": the brush, ink, paper, and ink stone. Each tool has specific qualities that affect the final artwork. The brush must be held at a precise angle, and the pressure applied determines the thickness and fluidity of each stroke. Mastering these technical aspects can take decades of dedicated practice.

What distinguishes calligraphy from ordinary writing is the emphasis on rhythm, balance, and spiritual connection. A calligrapher must be in the right mental state before beginning to write. Traditional masters would meditate and clear their minds, believing that the characters reflect the writer\'s inner character and emotional state. This philosophy connects calligraphy to Confucian ideals of self-cultivation and moral development.

There are five major styles of Chinese calligraphy: Seal Script, Clerical Script, Regular Script, Running Script, and Cursive Script. Each style developed during different historical periods and has distinct characteristics. Regular Script is taught in schools because of its clarity and structure, while Cursive Script offers the most creative freedom but requires the highest level of mastery.

Today, calligraphy remains an important part of Chinese education and cultural identity. While modern technology has reduced the need for handwritten communication, many Chinese people continue to practice calligraphy as a way to connect with their heritage and find inner peace. International interest in this art form has also grown, with exhibitions and workshops held worldwide.

Learning calligraphy teaches patience, discipline, and appreciation for beauty. As the famous Tang dynasty calligrapher Yan Zhenqing once said, "Calligraphy is the painting of the heart." Through this ancient art, practitioners continue to express their souls while preserving a vital thread of Chinese civilization.''',
      source: 'Cultural Heritage Magazine',
      wordCount: 328,
      difficulty: 2,
      category: ReadingCategory.culture,
      tags: ['culture', 'art', 'Chinese tradition'],
      estimatedTime: 8,
      vocabulary: [
        ReadingVocabulary(
          word: 'revere',
          phonetic: '/rɪˈvɪr/',
          definition: 'to feel deep respect or admiration for something',
          translation: '尊敬，崇敬',
        ),
        ReadingVocabulary(
          word: 'discipline',
          phonetic: '/ˈdɪsəplɪn/',
          definition: 'a branch of knowledge or field of study',
          translation: '学科，领域',
        ),
        ReadingVocabulary(
          word: 'fluidity',
          phonetic: '/fluˈɪdəti/',
          definition: 'the ability to flow easily and smoothly',
          translation: '流畅性',
        ),
        ReadingVocabulary(
          word: 'meditate',
          phonetic: '/ˈmedɪteɪt/',
          definition: 'to focus one\'s mind for a period of time for relaxation or spiritual purposes',
          translation: '冥想，沉思',
        ),
        ReadingVocabulary(
          word: 'heritage',
          phonetic: '/ˈherɪtɪdʒ/',
          definition: 'valued traditions and culture passed down from previous generations',
          translation: '遗产，传统',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'qm3_001',
          question: 'What are the "Four Treasures of the Study"?',
          options: ['Pen, pencil, eraser, ruler', 'Brush, ink, paper, ink stone', 'Desk, chair, lamp, book', 'Knife, stone, wood, cloth'],
          correctAnswer: 1,
          explanation: 'The text states: "The practice of calligraphy requires four essential tools, collectively known as the \'Four Treasures of the Study\': the brush, ink, paper, and ink stone."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm3_002',
          question: 'Which style of calligraphy is taught in schools?',
          options: ['Seal Script', 'Cursive Script', 'Regular Script', 'Running Script'],
          correctAnswer: 2,
          explanation: 'The text mentions: "Regular Script is taught in schools because of its clarity and structure."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm3_003',
          question: 'According to the passage, what does calligraphy teach practitioners?',
          options: ['Speed writing', 'Patience, discipline, and appreciation for beauty', 'Computer skills', 'Foreign languages'],
          correctAnswer: 1,
          explanation: 'The text states: "Learning calligraphy teaches patience, discipline, and appreciation for beauty."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qm3_004',
          question: 'The passage suggests that technology has increased interest in calligraphy.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The text says: "While modern technology has reduced the need for handwritten communication," indicating technology has decreased, not increased, the practical need for calligraphy.',
          type: QuestionType.trueFalse,
        ),
      ],
    ),
  ];

  // ==================== HARD PASSAGES (高三) ====================
  
  static final List<ReadingModel> _hardPassages = [
    // Hard 1: Argumentative - Social Media
    ReadingModel(
      id: 'reading_hard_001',
      title: 'The Paradox of Social Connection in the Digital Age',
      content: '''We live in an era of unprecedented connectivity. Social media platforms promise to bring us closer together, yet mounting evidence suggests that our digital interactions may be undermining the very connections they claim to enhance. This paradox lies at the heart of contemporary debates about technology\'s impact on human relationships.

The statistics paint a compelling picture. The average person now spends nearly two and a half hours daily on social media platforms, yet loneliness rates have reached historic highs. A 2023 study by the American Psychological Association found that young adults who use social media for more than three hours per day are twice as likely to report feeling socially isolated compared to those who use it less frequently. These findings challenge the assumption that digital communication naturally translates to meaningful human connection.

The mechanisms behind this phenomenon are multifaceted. Social media encourages what researchers call "passive consumption"—scrolling through others\' curated lives without genuine interaction. This creates a distorted reality where everyone else appears to be living more fulfilling lives, leading to social comparison and decreased self-esteem. Furthermore, the asynchronous nature of digital communication lacks the emotional depth of face-to-face interaction, where body language, tone of voice, and physical presence convey nuanced meaning.

Critics argue that social media has transformed friendship from a deep, reciprocal relationship into a superficial numbers game. The concept of "friends" has been diluted to mean little more than mutual acknowledgment in a digital directory. Birthday greetings have been reduced to automated notifications, and meaningful conversations have been replaced by emoji reactions. This quantification of relationships prioritizes breadth over depth, quantity over quality.

However, defenders of social media point to its undeniable benefits. For individuals in isolated communities, those with disabilities, or people living far from family, digital platforms provide vital lifelines to the outside world. During the COVID-19 pandemic, social media enabled countless people to maintain relationships when physical contact was impossible. The technology itself is neutral; its impact depends entirely on how we choose to use it.

The path forward requires a more nuanced approach to digital communication. Rather than abandoning social media entirely, we must develop what researchers call "digital literacy"—the ability to use technology intentionally and mindfully. This means setting boundaries on usage, prioritizing quality interactions over passive scrolling, and recognizing that digital connection should supplement rather than replace face-to-face relationships.

Ultimately, the question is not whether social media is good or bad, but how we can harness its potential while mitigating its risks. As we navigate this digital landscape, we must remember that technology is a tool for human connection, not a substitute for it. The quality of our relationships will always depend more on our willingness to be vulnerable, present, and authentic than on the platforms we use to communicate.''',
      source: 'Contemporary Social Review',
      wordCount: 438,
      difficulty: 3,
      category: ReadingCategory.academic,
      tags: ['social media', 'technology', 'psychology', 'relationships'],
      estimatedTime: 10,
      vocabulary: [
        ReadingVocabulary(
          word: 'unprecedented',
          phonetic: '/ʌnˈpresɪdentɪd/',
          definition: 'never done or known before',
          translation: '前所未有的',
        ),
        ReadingVocabulary(
          word: 'paradox',
          phonetic: '/ˈpærədɑːks/',
          definition: 'a seemingly contradictory statement that may nonetheless be true',
          translation: '悖论，矛盾',
        ),
        ReadingVocabulary(
          word: 'multifaceted',
          phonetic: '/ˌmʌltiˈfæsɪtɪd/',
          definition: 'having many different aspects or features',
          translation: '多方面的',
        ),
        ReadingVocabulary(
          word: 'asynchronous',
          phonetic: '/eɪˈsɪŋkrənəs/',
          definition: 'not existing or occurring at the same time',
          translation: '异步的',
        ),
        ReadingVocabulary(
          word: 'mitigate',
          phonetic: '/ˈmɪtɪɡeɪt/',
          definition: 'to make less severe, serious, or painful',
          translation: '减轻，缓和',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'qh1_001',
          question: 'According to the passage, what did the 2023 APA study find?',
          options: [
            'Social media has no effect on loneliness',
            'Young adults using social media over 3 hours daily are twice as likely to feel isolated',
            'All social media users feel lonely',
            'Older adults are more affected by social media than young adults'
          ],
          correctAnswer: 1,
          explanation: 'The text states: "A 2023 study by the American Psychological Association found that young adults who use social media for more than three hours per day are twice as likely to report feeling socially isolated."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh1_002',
          question: 'What is "passive consumption" according to the passage?',
          options: [
            'Actively posting on social media',
            'Scrolling through others\' lives without genuine interaction',
            'Buying products online',
            'Creating digital content'
          ],
          correctAnswer: 1,
          explanation: 'The text defines it as: "scrolling through others\' curated lives without genuine interaction."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh1_003',
          question: 'What does the author suggest as the solution to social media\'s negative effects?',
          options: [
            'Abandoning social media completely',
            'Developing digital literacy and using technology mindfully',
            'Creating new social media platforms',
            'Limiting social media to professionals only'
          ],
          correctAnswer: 1,
          explanation: 'The text states: "Rather than abandoning social media entirely, we must develop what researchers call \'digital literacy\'—the ability to use technology intentionally and mindfully."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh1_004',
          question: 'According to the passage, the author believes that technology is inherently harmful to human relationships.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The author argues that "The technology itself is neutral; its impact depends entirely on how we choose to use it."',
          type: QuestionType.trueFalse,
        ),
        ReadingQuestion(
          id: 'qh1_005',
          question: 'What is the main argument of the passage?',
          options: [
            'Social media should be banned',
            'Social media creates a paradox where connectivity increases loneliness',
            'Social media is the best way to make friends',
            'Only young people are affected by social media'
          ],
          correctAnswer: 1,
          explanation: 'The passage\'s central thesis is that despite unprecedented connectivity through social media, loneliness rates have increased, creating a paradox.',
          type: QuestionType.multipleChoice,
        ),
      ],
    ),

    // Hard 2: Analytical - Climate Change
    ReadingModel(
      id: 'reading_hard_002',
      title: 'Rethinking Economic Growth in a Warming World',
      content: '''The prevailing economic paradigm of perpetual growth faces an existential challenge from climate change. For decades, Gross Domestic Product (GDP) has been the primary metric of national success, with policymakers assuming that economic expansion and environmental protection are fundamentally at odds. However, emerging evidence suggests that this dichotomy is not only false but dangerously counterproductive. A new framework that reconciles prosperity with planetary boundaries is not merely desirable—it is essential for human survival.

The traditional model of economic development follows a linear trajectory: extract resources, manufacture products, consume goods, and dispose of waste. This "take-make-waste" approach has delivered unprecedented material prosperity but at enormous environmental cost. Since the Industrial Revolution, atmospheric carbon dioxide concentrations have risen by nearly 50 percent, global temperatures have increased by approximately 1.1 degrees Celsius, and biodiversity has declined at rates unprecedented in human history. The uncomfortable truth is that our economic system treats the natural world as an infinite resource and a limitless dumping ground.

Proponents of "green growth" argue that technological innovation can decouple economic expansion from environmental degradation. Renewable energy, circular economy principles, and sustainable agriculture offer pathways to prosperity without destruction. Indeed, countries like Denmark and Costa Rica have demonstrated that robust economic performance is compatible with declining carbon emissions. The cost of solar and wind energy has plummeted by over 80 percent in the past decade, making them competitive with fossil fuels in many markets.

However, critics contend that green growth is insufficient to address the scale of the crisis. They point to the Jevons paradox, where efficiency gains lead to increased overall resource consumption. When energy becomes cheaper and cleaner, people use more of it, offsetting environmental benefits. Furthermore, even renewable energy requires mining, manufacturing, and land use that impact ecosystems. Absolute decoupling—growing the economy while reducing absolute resource use—has never been achieved at the global level and may be physically impossible on a finite planet.

This critique has fueled interest in "degrowth" and "post-growth" economics. These approaches prioritize well-being, equity, and sustainability over GDP expansion. They advocate for shorter working hours, reduced consumption in wealthy nations, and investment in public goods like healthcare, education, and green infrastructure. Proponents argue that beyond a certain threshold, additional income contributes little to happiness while significantly increasing environmental impact.

The choice between growth and the environment is a false one. What we need is a fundamental redefinition of progress that accounts for natural capital, social cohesion, and human flourishing. Alternative metrics like the Genuine Progress Indicator (GPI) and the Happy Planet Index offer more holistic assessments of societal well-being. These tools reveal that countries with lower GDPs often outperform wealthy nations in terms of life satisfaction and ecological efficiency.

The transition to a sustainable economy requires unprecedented cooperation among governments, businesses, and citizens. Carbon pricing, regulatory frameworks, and international agreements must align incentives with environmental stewardship. Individual choices matter, but systemic change is essential. As the window for avoiding catastrophic warming narrows, we must question the assumptions that have guided economic policy for generations. The future of both our economy and our planet depends on our willingness to imagine—and create—a world where prosperity means something more than perpetual growth.''',
      source: 'Global Economics Review',
      wordCount: 542,
      difficulty: 3,
      category: ReadingCategory.academic,
      tags: ['economics', 'climate change', 'environment', 'sustainability'],
      estimatedTime: 12,
      vocabulary: [
        ReadingVocabulary(
          word: 'paradigm',
          phonetic: '/ˈpærədaɪm/',
          definition: 'a typical example or pattern of something; a model',
          translation: '范式，模式',
        ),
        ReadingVocabulary(
          word: 'dichotomy',
          phonetic: '/daɪˈkɑːtəmi/',
          definition: 'a division or contrast between two things that are opposed',
          translation: '二分法，对立',
        ),
        ReadingVocabulary(
          word: 'decouple',
          phonetic: '/diːˈkʌpl/',
          definition: 'to separate, disengage, or dissociate something from something else',
          translation: '脱钩，分离',
        ),
        ReadingVocabulary(
          word: 'paradox',
          phonetic: '/ˈpærədɑːks/',
          definition: 'a seemingly absurd or contradictory statement that may be true',
          translation: '悖论',
        ),
        ReadingVocabulary(
          word: 'catastrophic',
          phonetic: '/ˌkætəˈstrɑːfɪk/',
          definition: 'involving or causing sudden great damage or suffering',
          translation: '灾难性的',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'qh2_001',
          question: 'What is the "take-make-waste" approach mentioned in the passage?',
          options: [
            'A recycling program',
            'The traditional linear economic model of resource extraction and disposal',
            'A sustainable farming method',
            'A type of renewable energy'
          ],
          correctAnswer: 1,
          explanation: 'The text describes it as: "extract resources, manufacture products, consume goods, and dispose of waste" and calls it the "traditional model of economic development."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh2_002',
          question: 'What is the Jevons paradox?',
          options: [
            'When efficiency gains lead to increased overall resource consumption',
            'When renewable energy becomes more expensive',
            'When economic growth stops completely',
            'When countries stop trading with each other'
          ],
          correctAnswer: 0,
          explanation: 'The text explains: "They point to the Jevons paradox, where efficiency gains lead to increased overall resource consumption."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh2_003',
          question: 'According to the passage, what do degrowth economics prioritize?',
          options: [
            'Maximum GDP expansion',
            'Well-being, equity, and sustainability over GDP expansion',
            'Increased manufacturing output',
            'Higher consumption levels'
          ],
          correctAnswer: 1,
          explanation: 'The text states: "These approaches prioritize well-being, equity, and sustainability over GDP expansion."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh2_004',
          question: 'The passage suggests that absolute decoupling has been achieved at the global level.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The text explicitly states: "Absolute decoupling—growing the economy while reducing absolute resource use—has never been achieved at the global level."',
          type: QuestionType.trueFalse,
        ),
        ReadingQuestion(
          id: 'qh2_005',
          question: 'What is the author\'s main conclusion?',
          options: [
            'Economic growth should continue without any changes',
            'We need to redefine progress beyond GDP to ensure survival',
            'Renewable energy is not effective',
            'Only developed countries need to change their economies'
          ],
          correctAnswer: 1,
          explanation: 'The author concludes: "What we need is a fundamental redefinition of progress that accounts for natural capital, social cohesion, and human flourishing."',
          type: QuestionType.multipleChoice,
        ),
      ],
    ),

    // Hard 3: Analytical - Education Reform
    ReadingModel(
      id: 'reading_hard_003',
      title: 'The Case for Competency-Based Education',
      content: '''The assembly-line model of education that has dominated for over a century is showing signs of obsolescence. Designed to produce standardized workers for industrial economies, traditional schooling emphasizes time spent in classrooms rather than actual learning achieved. Students progress through grade levels based on age, not mastery, creating a system where gaps in understanding accumulate until they become insurmountable. Competency-based education (CBE) offers a radical alternative that prioritizes demonstrated skills over seat time, potentially transforming how we prepare students for an increasingly complex world.

The fundamental premise of CBE is straightforward: education should ensure that students master essential skills and knowledge before moving forward, regardless of how long this takes. In a competency-based system, time becomes a variable while learning becomes constant. A student who grasps algebra quickly can advance immediately, while another who needs additional support receives it without the stigma of "falling behind." This approach recognizes what cognitive science has long established: individuals learn at different rates, and forcing uniform progression is both inefficient and inequitable.

Implementation of CBE requires fundamental restructuring of curriculum, assessment, and credentialing. Rather than earning credits based on hours in class, students demonstrate proficiency through authentic assessments—projects, portfolios, and performance tasks that mirror real-world challenges. A high school diploma or college degree represents verified capabilities rather than accumulated time. This shift demands new assessment tools that can reliably measure complex skills like critical thinking, collaboration, and creativity.

Critics raise legitimate concerns about CBE\'s feasibility. Scaling personalized learning pathways for millions of students requires substantial technological infrastructure and teacher training. Questions about standardization persist: if students progress at different paces, how do we ensure consistent quality across institutions? Furthermore, traditional transcripts and credentials serve important signaling functions in labor markets; radical changes could disadvantage early adopters until employers adjust their hiring practices.

Despite these challenges, early evidence suggests CBE can improve outcomes, particularly for disadvantaged students. The Chugach School District in Alaska, an early adopter of CBE, saw graduation rates increase from 50 percent to over 90 percent after implementation. Western Governors University, a competency-based institution, produces graduates at significantly lower cost than traditional universities while maintaining comparable employment outcomes. These successes demonstrate that CBE is not merely theoretical but practically achievable.

The transition to competency-based education represents more than a policy change—it signals a philosophical shift in how we conceptualize learning and human potential. In an era of rapid technological change, the specific knowledge students acquire in school may become obsolete within years. The ability to learn continuously, adapt to new challenges, and demonstrate transferable skills becomes paramount. CBE develops these metacognitive capacities by making the learning process itself transparent and intentional.

Ultimately, the question facing education reformers is whether we are content with a system that sorts students by age and socioeconomic status or whether we are committed to ensuring that every graduate possesses the competencies needed for citizenship and career success. The industrial model of education served its purpose in a bygone era. As we confront the challenges of the twenty-first century—from automation to climate change—we need an educational system that develops the full potential of every learner. Competency-based education offers a promising pathway toward that goal.''',
      source: 'Education Policy Journal',
      wordCount: 528,
      difficulty: 3,
      category: ReadingCategory.academic,
      tags: ['education', 'reform', 'policy', 'learning'],
      estimatedTime: 12,
      vocabulary: [
        ReadingVocabulary(
          word: 'obsolescence',
          phonetic: '/ˌɑːbsəˈlesns/',
          definition: 'the process of becoming obsolete or outdated',
          translation: '过时，淘汰',
        ),
        ReadingVocabulary(
          word: 'insurmountable',
          phonetic: '/ˌɪnsərˈmaʊntəbl/',
          definition: 'too great to be overcome',
          translation: '无法克服的',
        ),
        ReadingVocabulary(
          word: 'stigma',
          phonetic: '/ˈstɪɡmə/',
          definition: 'a mark of disgrace associated with a particular circumstance',
          translation: '耻辱，污名',
        ),
        ReadingVocabulary(
          word: 'credentialing',
          phonetic: '/krəˈdenʃəlɪŋ/',
          definition: 'the process of establishing qualifications',
          translation: '资格认证',
        ),
        ReadingVocabulary(
          word: 'paramount',
          phonetic: '/ˈpærəmaʊnt/',
          definition: 'more important than anything else; supreme',
          translation: '至高无上的，最重要的',
        ),
      ],
      questions: [
        ReadingQuestion(
          id: 'qh3_001',
          question: 'What is the fundamental premise of competency-based education?',
          options: [
            'Students should spend more time in classrooms',
            'Students should master skills before moving forward, regardless of time taken',
            'All students should learn at the same pace',
            'Education should focus only on test scores'
          ],
          correctAnswer: 1,
          explanation: 'The text states: "The fundamental premise of CBE is straightforward: education should ensure that students master essential skills and knowledge before moving forward, regardless of how long this takes."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh3_002',
          question: 'What happened to graduation rates in the Chugach School District after CBE implementation?',
          options: [
            'They decreased from 90% to 50%',
            'They increased from 50% to over 90%',
            'They remained the same at 50%',
            'They dropped to 30%'
          ],
          correctAnswer: 1,
          explanation: 'The text mentions: "The Chugach School District in Alaska... saw graduation rates increase from 50 percent to over 90 percent after implementation."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh3_003',
          question: 'What concern do critics have about CBE?',
          options: [
            'It requires substantial technological infrastructure',
            'It is too easy to implement',
            'It only works for wealthy students',
            'It eliminates all assessments'
          ],
          correctAnswer: 0,
          explanation: 'The text states: "Scaling personalized learning pathways for millions of students requires substantial technological infrastructure and teacher training."',
          type: QuestionType.multipleChoice,
        ),
        ReadingQuestion(
          id: 'qh3_004',
          question: 'According to the passage, CBE makes time a constant and learning a variable.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The text states the opposite: "In a competency-based system, time becomes a variable while learning becomes constant."',
          type: QuestionType.trueFalse,
        ),
        ReadingQuestion(
          id: 'qh3_005',
          question: 'What does the author suggest is paramount in the modern era?',
          options: [
            'Memorizing facts',
            'The ability to learn continuously and demonstrate transferable skills',
            'Spending more years in school',
            'Traditional credentials only'
          ],
          correctAnswer: 1,
          explanation: 'The text states: "The ability to learn continuously, adapt to new challenges, and demonstrate transferable skills becomes paramount."',
          type: QuestionType.multipleChoice,
        ),
      ],
    ),
  ];
}
