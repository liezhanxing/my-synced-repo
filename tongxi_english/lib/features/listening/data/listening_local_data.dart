import '../../../models/listening_model.dart';

/// Local data source for listening exercises
/// 
/// Contains hardcoded sample listening exercises for offline use and testing.
/// Organized by difficulty level: 1=高一(Easy), 2=高二(Medium), 3=高三(Hard)
class ListeningLocalData {
  ListeningLocalData._();

  /// Get all sample listening exercises
  static List<ListeningModel> getAllExercises() {
    return [
      ..._easyExercises,
      ..._mediumExercises,
      ..._hardExercises,
    ];
  }

  /// Get exercises by difficulty level
  static List<ListeningModel> getExercisesByDifficulty(int difficulty) {
    return getAllExercises()
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  /// Get exercise by ID
  static ListeningModel? getExerciseById(String id) {
    try {
      return getAllExercises().firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== EASY EXERCISES (高一) ====================
  
  static final List<ListeningModel> _easyExercises = [
    // Easy 1: Daily Conversation - At a Restaurant
    ListeningModel(
      id: 'listening_easy_001',
      title: 'Ordering at a Restaurant',
      audioUrl: 'tts://restaurant_order',
      transcript: '''Waiter: Good evening! Welcome to Green Garden Restaurant. Do you have a reservation?

Tom: No, I don't. Do you have a table for two?

Waiter: Yes, we do. This way, please. Here is your table by the window.

Tom: Thank you. Could we see the menu, please?

Waiter: Of course. Here are the menus. Today's special is grilled salmon with vegetables. Would you like something to drink while you decide?

Tom: I'll have an iced tea, please. What about you, Mary?

Mary: Just water for me, thanks.

Waiter: I'll be right back with your drinks. Take your time with the menu.

Tom: Thanks. The salmon sounds good. What are you thinking of ordering?

Mary: I'm not sure yet. Maybe the chicken salad. I'm trying to eat healthy these days.''',
      duration: 90,
      difficulty: 1,
      category: ListeningCategory.dialogue,
      tags: ['daily life', 'restaurant', 'food'],
      accent: 'American',
      speakerCount: 3,
      vocabulary: [
        ListeningVocabulary(
          word: 'reservation',
          phonetic: '/ˌrezərˈveɪʃn/',
          definition: 'an arrangement to have something held for your use',
          timestamp: '00:05',
        ),
        ListeningVocabulary(
          word: 'special',
          phonetic: '/ˈspeʃl/',
          definition: 'a dish that is featured on a particular day',
          timestamp: '00:25',
        ),
        ListeningVocabulary(
          word: 'grilled',
          phonetic: '/ɡrɪld/',
          definition: 'cooked over direct heat',
          timestamp: '00:28',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'le1_q1',
          question: 'Where does this conversation take place?',
          options: ['At a hotel', 'At a restaurant', 'At a school', 'At a hospital'],
          correctAnswer: 1,
          explanation: 'The waiter welcomes them to "Green Garden Restaurant" and asks about a table and menu.',
          timestamp: 0,
        ),
        ListeningQuestion(
          id: 'le1_q2',
          question: 'How many people are dining together?',
          options: ['One', 'Two', 'Three', 'Four'],
          correctAnswer: 1,
          explanation: 'Tom asks for "a table for two" and mentions Mary when ordering drinks.',
          timestamp: 10,
        ),
        ListeningQuestion(
          id: 'le1_q3',
          question: 'What is today\'s special?',
          options: ['Chicken salad', 'Grilled salmon', 'Beef steak', 'Pasta'],
          correctAnswer: 1,
          explanation: 'The waiter says: "Today\'s special is grilled salmon with vegetables."',
          timestamp: 25,
        ),
        ListeningQuestion(
          id: 'le1_q4',
          question: 'What does Mary want to drink?',
          options: ['Iced tea', 'Coffee', 'Water', 'Juice'],
          correctAnswer: 2,
          explanation: 'Mary says: "Just water for me, thanks."',
          timestamp: 40,
        ),
      ],
    ),

    // Easy 2: School Life - Asking for Directions
    ListeningModel(
      id: 'listening_easy_002',
      title: 'Finding the Library',
      audioUrl: 'tts://library_directions',
      transcript: '''Student A: Excuse me, could you help me? I'm looking for the school library.

Student B: Sure! The library is in the main building. Are you new here?

Student A: Yes, I just transferred here last week. Everything is so confusing!

Student B: Don't worry, you'll get used to it soon. So, from here, go straight down this hallway until you see the science labs on your left.

Student A: Okay, science labs on the left. Got it.

Student B: Then turn right at the end of the hallway. You'll see a large staircase. Go up to the second floor.

Student A: Second floor. Okay.

Student B: The library is right at the top of the stairs. You can't miss it. There's a big sign above the door.

Student A: Great! Is it open now?

Student B: Yes, it opens at 8 AM and closes at 6 PM on weekdays. You can borrow books using your student ID card.

Student A: Perfect. Thank you so much for your help!

Student B: No problem! Good luck with your studies!''',
      duration: 85,
      difficulty: 1,
      category: ListeningCategory.dialogue,
      tags: ['school', 'directions', 'daily life'],
      accent: 'American',
      speakerCount: 2,
      vocabulary: [
        ListeningVocabulary(
          word: 'transferred',
          phonetic: '/trænsˈfɜːrd/',
          definition: 'moved from one school to another',
          timestamp: '00:15',
        ),
        ListeningVocabulary(
          word: 'hallway',
          phonetic: '/ˈhɔːlweɪ/',
          definition: 'a passage in a building with rooms on one or both sides',
          timestamp: '00:25',
        ),
        ListeningVocabulary(
          word: 'weekdays',
          phonetic: '/ˈwiːkdeɪz/',
          definition: 'Monday through Friday, not including weekends',
          timestamp: '01:05',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'le2_q1',
          question: 'Where is Student A trying to go?',
          options: ['Science lab', 'Library', 'Classroom', 'Cafeteria'],
          correctAnswer: 1,
          explanation: 'Student A says: "I\'m looking for the school library."',
          timestamp: 5,
        ),
        ListeningQuestion(
          id: 'le2_q2',
          question: 'When did Student A start at this school?',
          options: ['Yesterday', 'Last week', 'Last month', 'Last year'],
          correctAnswer: 1,
          explanation: 'Student A says: "I just transferred here last week."',
          timestamp: 15,
        ),
        ListeningQuestion(
          id: 'le2_q3',
          question: 'On which floor is the library located?',
          options: ['First floor', 'Second floor', 'Third floor', 'Ground floor'],
          correctAnswer: 1,
          explanation: 'Student B says: "Go up to the second floor. The library is right at the top of the stairs."',
          timestamp: 45,
        ),
        ListeningQuestion(
          id: 'le2_q4',
          question: 'What do you need to borrow books from the library?',
          options: ['Money', 'Student ID card', 'Library card', 'Teacher permission'],
          correctAnswer: 1,
          explanation: 'Student B says: "You can borrow books using your student ID card."',
          timestamp: 65,
        ),
      ],
    ),

    // Easy 3: Shopping - Buying Clothes
    ListeningModel(
      id: 'listening_easy_003',
      title: 'Shopping for a Gift',
      audioUrl: 'tts://shopping_gift',
      transcript: '''Shop Assistant: Hello! Can I help you find something?

Customer: Hi, yes. I'm looking for a birthday gift for my sister. She loves sweaters.

Shop Assistant: That's nice! What size does she wear?

Customer: She's about my size, maybe a medium.

Shop Assistant: Great. We have some beautiful sweaters on sale right now. What color does she like?

Customer: She prefers neutral colors like beige, gray, or white.

Shop Assistant: Perfect! We just got this new cashmere sweater in light gray. It's very soft and warm. Would you like to feel it?

Customer: Oh, it does feel nice. How much is it?

Shop Assistant: It's originally 80 dollars, but it's 30 percent off today. So that would be 56 dollars.

Customer: That's a good deal. I'll take it. Can you gift wrap it for me?

Shop Assistant: Of course! We offer free gift wrapping. Would you like a card to go with it?

Customer: Yes, please. And could you write "Happy Birthday, Love you!" on it?

Shop Assistant: Absolutely. I'll take care of that for you right away.''',
      duration: 95,
      difficulty: 1,
      category: ListeningCategory.dialogue,
      tags: ['shopping', 'daily life', 'gift'],
      accent: 'American',
      speakerCount: 2,
      vocabulary: [
        ListeningVocabulary(
          word: 'neutral',
          phonetic: '/ˈnuːtrəl/',
          definition: 'having no strongly marked or positive characteristics or features',
          timestamp: '00:35',
        ),
        ListeningVocabulary(
          word: 'cashmere',
          phonetic: '/ˈkæʒmɪr/',
          definition: 'fine soft wool from a type of goat',
          timestamp: '00:40',
        ),
        ListeningVocabulary(
          word: 'gift wrap',
          phonetic: '/ɡɪft ræp/',
          definition: 'to cover a present with decorative paper',
          timestamp: '01:10',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'le3_q1',
          question: 'Who is the customer buying a gift for?',
          options: ['Her mother', 'Her sister', 'Her friend', 'Her daughter'],
          correctAnswer: 1,
          explanation: 'The customer says: "I\'m looking for a birthday gift for my sister."',
          timestamp: 10,
        ),
        ListeningQuestion(
          id: 'le3_q2',
          question: 'What color sweater does the customer choose?',
          options: ['Beige', 'White', 'Light gray', 'Black'],
          correctAnswer: 2,
          explanation: 'The shop assistant mentions: "We just got this new cashmere sweater in light gray."',
          timestamp: 40,
        ),
        ListeningQuestion(
          id: 'le3_q3',
          question: 'How much does the sweater cost after the discount?',
          options: ['30 dollars', '56 dollars', '80 dollars', '110 dollars'],
          correctAnswer: 1,
          explanation: 'The shop assistant says: "It\'s originally 80 dollars, but it\'s 30 percent off today. So that would be 56 dollars."',
          timestamp: 55,
        ),
        ListeningQuestion(
          id: 'le3_q4',
          question: 'The gift wrapping service costs extra money.',
          options: ['True', 'False'],
          correctAnswer: 1,
          explanation: 'The shop assistant says: "We offer free gift wrapping."',
          timestamp: 65,
        ),
      ],
    ),

    // Easy 4: Making Plans - Weekend Activities
    ListeningModel(
      id: 'listening_easy_004',
      title: 'Planning the Weekend',
      audioUrl: 'tts://weekend_plans',
      transcript: '''Mike: Hey Sarah! Do you have any plans for this weekend?

Sarah: Not yet. I was thinking about just staying home and relaxing. Why? What's up?

Mike: A group of us are going hiking in the mountains on Saturday. Would you like to join us?

Sarah: That sounds fun! But I'm not very experienced at hiking. Is it a difficult trail?

Mike: Don't worry, it's an easy trail suitable for beginners. It takes about three hours to reach the top, and the view is amazing!

Sarah: Okay, that doesn't sound too bad. What should I bring?

Mike: Wear comfortable shoes and bring a water bottle. Also, pack some snacks and maybe a light jacket. It can get windy at the top.

Sarah: Got it. What time are we leaving?

Mike: We're meeting at the train station at 8 AM. The train leaves at 8:30.

Sarah: 8 AM? That's early! But okay, I'll be there. How many people are going?

Mike: There will be about six of us. Don't worry, everyone is friendly!

Sarah: Great! I'm looking forward to it. Thanks for inviting me, Mike!

Mike: No problem! See you Saturday morning!''',
      duration: 100,
      difficulty: 1,
      category: ListeningCategory.conversation,
      tags: ['weekend', 'hiking', 'plans'],
      accent: 'American',
      speakerCount: 2,
      vocabulary: [
        ListeningVocabulary(
          word: 'trail',
          phonetic: '/treɪl/',
          definition: 'a path through the countryside',
          timestamp: '00:30',
        ),
        ListeningVocabulary(
          word: 'beginners',
          phonetic: '/bɪˈɡɪnərz/',
          definition: 'people who are starting to learn or do something',
          timestamp: '00:35',
        ),
        ListeningVocabulary(
          word: 'comfortable',
          phonetic: '/ˈkʌmftəbl/',
          definition: 'providing physical ease and relaxation',
          timestamp: '00:50',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'le4_q1',
          question: 'What activity are Mike and his friends planning?',
          options: ['Swimming', 'Hiking', 'Camping', 'Biking'],
          correctAnswer: 1,
          explanation: 'Mike says: "A group of us are going hiking in the mountains on Saturday."',
          timestamp: 15,
        ),
        ListeningQuestion(
          id: 'le4_q2',
          question: 'How long does it take to reach the top of the mountain?',
          options: ['One hour', 'Two hours', 'Three hours', 'Four hours'],
          correctAnswer: 2,
          explanation: 'Mike says: "It takes about three hours to reach the top."',
          timestamp: 35,
        ),
        ListeningQuestion(
          id: 'le4_q3',
          question: 'Where are they meeting on Saturday?',
          options: ['At Mike\'s house', 'At the mountain', 'At the train station', 'At Sarah\'s home'],
          correctAnswer: 2,
          explanation: 'Mike says: "We\'re meeting at the train station at 8 AM."',
          timestamp: 70,
        ),
        ListeningQuestion(
          id: 'le4_q4',
          question: 'How many people will be in the hiking group?',
          options: ['Four', 'Five', 'Six', 'Seven'],
          correctAnswer: 2,
          explanation: 'Mike says: "There will be about six of us."',
          timestamp: 85,
        ),
      ],
    ),
  ];

  // ==================== MEDIUM EXERCISES (高二) ====================
  
  static final List<ListeningModel> _mediumExercises = [
    // Medium 1: Travel - At the Airport
    ListeningModel(
      id: 'listening_medium_001',
      title: 'Airport Check-in Problems',
      audioUrl: 'tts://airport_checkin',
      transcript: '''Agent: Next in line, please. Good morning. May I see your passport and ticket?

Passenger: Good morning. Here you go. I'm flying to London on flight BA284.

Agent: Thank you. Let me check... I'm sorry, but there seems to be a problem with your booking.

Passenger: What kind of problem? I confirmed my reservation yesterday.

Agent: The system shows that your flight was rescheduled due to mechanical issues with the aircraft. Your original flight has been cancelled.

Passenger: Oh no! What am I supposed to do now? I have an important meeting in London tomorrow morning.

Agent: Don't worry, sir. We've automatically rebooked you on the next available flight, which departs at 3 PM today instead of 9 AM. You'll arrive in London at 6:30 PM local time.

Passenger: That's quite a delay. Will I be compensated for this inconvenience?

Agent: Yes, since this is an airline-caused issue, you're entitled to meal vouchers and a partial refund. You'll also be upgraded to business class at no extra charge.

Passenger: Well, at least that's something. Will my checked baggage be transferred to the new flight?

Agent: Absolutely. Your bags will be automatically routed to flight BA284 departing at 3 PM. Please proceed to Gate 24 after going through security. The gate opens at 2 PM.

Passenger: Thank you for your assistance. I appreciate the upgrade.

Agent: You're welcome, sir. We apologize for the inconvenience. Have a pleasant flight!''',
      duration: 120,
      difficulty: 2,
      category: ListeningCategory.announcement,
      tags: ['travel', 'airport', 'problems'],
      accent: 'British',
      speakerCount: 2,
      vocabulary: [
        ListeningVocabulary(
          word: 'mechanical',
          phonetic: '/məˈkænɪkl/',
          definition: 'relating to machines or machinery',
          timestamp: '00:35',
        ),
        ListeningVocabulary(
          word: 'cancelled',
          phonetic: '/ˈkænsld/',
          definition: 'decided not to do something planned',
          timestamp: '00:40',
        ),
        ListeningVocabulary(
          word: 'compensated',
          phonetic: '/ˈkɒmpenseɪtɪd/',
          definition: 'given something to make up for a loss or injury',
          timestamp: '01:05',
        ),
        ListeningVocabulary(
          word: 'entitled',
          phonetic: '/ɪnˈtaɪtld/',
          definition: 'having the right to have or do something',
          timestamp: '01:15',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'lm1_q1',
          question: 'What is the passenger\'s destination?',
          options: ['Paris', 'New York', 'London', 'Tokyo'],
          correctAnswer: 2,
          explanation: 'The passenger says: "I\'m flying to London on flight BA284."',
          timestamp: 10,
        ),
        ListeningQuestion(
          id: 'lm1_q2',
          question: 'Why was the original flight cancelled?',
          options: ['Bad weather', 'Mechanical issues', 'Pilot illness', 'Air traffic control'],
          correctAnswer: 1,
          explanation: 'The agent says: "Your original flight has been cancelled" due to "mechanical issues with the aircraft."',
          timestamp: 35,
        ),
        ListeningQuestion(
          id: 'lm1_q3',
          question: 'What time does the new flight depart?',
          options: ['9 AM', '12 PM', '2 PM', '3 PM'],
          correctAnswer: 3,
          explanation: 'The agent says: "Your original flight has been cancelled" and "the next available flight, which departs at 3 PM today instead of 9 AM."',
          timestamp: 55,
        ),
        ListeningQuestion(
          id: 'lm1_q4',
          question: 'What compensation does the passenger receive?',
          options: ['Only meal vouchers', 'Only a refund', 'Meal vouchers, partial refund, and business class upgrade', 'Nothing'],
          correctAnswer: 2,
          explanation: 'The agent mentions: "meal vouchers and a partial refund" and "upgraded to business class at no extra charge."',
          timestamp: 75,
        ),
      ],
    ),

    // Medium 2: Environment - News Report
    ListeningModel(
      id: 'listening_medium_002',
      title: 'City Recycling Program',
      audioUrl: 'tts://recycling_news',
      transcript: '''News Anchor: Good evening. In tonight's environmental news, our city council has announced an ambitious new recycling program that will take effect starting next month.

Reporter: Thank you, Jane. I'm standing outside City Hall where officials just unveiled the "Green Future Initiative." The program aims to reduce household waste by 50 percent within two years.

Under the new system, residents will be required to separate their trash into four categories: organic waste, recyclable materials, hazardous waste, and general waste. Each household will receive color-coded bins free of charge.

Mayor Thompson spoke about the importance of this initiative:

Mayor: This is not just about keeping our streets clean. It's about our responsibility to future generations. If we don't act now, our landfills will reach capacity within five years. We can no longer afford the "throwaway culture" that has dominated for too long.

Reporter: The program will be rolled out in phases. Starting next month, the new bins will be distributed. In month two, educational workshops will be held in every neighborhood. Full enforcement, including fines for non-compliance, begins in month four.

Some residents have expressed concerns about the complexity of sorting requirements. In response, the city has developed a mobile app that helps identify which category different items belong to.

The program has a budget of 5 million dollars, funded partly by state environmental grants and partly by a small increase in municipal taxes. City officials estimate the program will pay for itself within three years through reduced landfill costs and revenue from selling recyclable materials.

Back to you, Jane.

News Anchor: Thank you, Mike. Residents with questions can call the dedicated hotline at 555-0123.''',
      duration: 140,
      difficulty: 2,
      category: ListeningCategory.news,
      tags: ['environment', 'news', 'recycling'],
      accent: 'American',
      speakerCount: 3,
      vocabulary: [
        ListeningVocabulary(
          word: 'ambitious',
          phonetic: '/æmˈbɪʃəs/',
          definition: 'having a strong desire for success or achievement',
          timestamp: '00:10',
        ),
        ListeningVocabulary(
          word: 'unveiled',
          phonetic: '/ʌnˈveɪld/',
          definition: 'showed or announced publicly for the first time',
          timestamp: '00:20',
        ),
        ListeningVocabulary(
          word: 'landfills',
          phonetic: '/ˈlændfɪlz/',
          definition: 'places where waste is buried under the ground',
          timestamp: '01:10',
        ),
        ListeningVocabulary(
          word: 'compliance',
          phonetic: '/kəmˈplaɪəns/',
          definition: 'the act of obeying rules or requests',
          timestamp: '01:45',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'lm2_q1',
          question: 'What is the goal of the Green Future Initiative?',
          options: [
            'To increase taxes',
            'To reduce household waste by 50%',
            'To build new landfills',
            'To close recycling centers'
          ],
          correctAnswer: 1,
          explanation: 'The reporter states: "The program aims to reduce household waste by 50 percent within two years."',
          timestamp: 30,
        ),
        ListeningQuestion(
          id: 'lm2_q2',
          question: 'How many categories will residents need to separate their trash into?',
          options: ['Two', 'Three', 'Four', 'Five'],
          correctAnswer: 2,
          explanation: 'The reporter says: "residents will be required to separate their trash into four categories."',
          timestamp: 40,
        ),
        ListeningQuestion(
          id: 'lm2_q3',
          question: 'According to the Mayor, how long until landfills reach capacity?',
          options: ['Two years', 'Three years', 'Five years', 'Ten years'],
          correctAnswer: 2,
          explanation: 'The Mayor says: "our landfills will reach capacity within five years."',
          timestamp: 70,
        ),
        ListeningQuestion(
          id: 'lm2_q4',
          question: 'When does full enforcement of the program begin?',
          options: ['Month one', 'Month two', 'Month three', 'Month four'],
          correctAnswer: 3,
          explanation: 'The reporter states: "Full enforcement, including fines for non-compliance, begins in month four."',
          timestamp: 105,
        ),
      ],
    ),

    // Medium 3: Interview - Job Interview
    ListeningModel(
      id: 'listening_medium_003',
      title: 'A Job Interview',
      audioUrl: 'tts://job_interview',
      transcript: '''Interviewer: Good afternoon. Please have a seat. I'm Mrs. Chen, the HR manager.

Candidate: Good afternoon, Mrs. Chen. Thank you for having me. I'm David Liu.

Interviewer: Nice to meet you, David. I've reviewed your resume, and I'm impressed by your educational background. You graduated from Beijing University with a degree in Computer Science, correct?

Candidate: Yes, that's right. I specialized in artificial intelligence and machine learning.

Interviewer: Excellent. Our company is looking for software engineers to work on our new AI-powered customer service platform. Could you tell me about your relevant experience?

Candidate: Certainly. During my internship at Tech Solutions last summer, I worked on a similar project. I helped develop a chatbot that could handle basic customer inquiries. We reduced response time by 40 percent and improved customer satisfaction scores.

Interviewer: That sounds very relevant. What programming languages are you proficient in?

Candidate: I'm most comfortable with Python and Java. I also have experience with JavaScript and have been learning Go recently. For AI projects, I frequently use TensorFlow and PyTorch.

Interviewer: Great skill set. Now, let me ask about your work style. How do you handle tight deadlines and pressure?

Candidate: I prioritize tasks based on urgency and importance. When facing tight deadlines, I break projects into smaller milestones and communicate regularly with my team. I actually work well under pressure—it helps me stay focused and productive.

Interviewer: Good approach. We value teamwork here. Can you give me an example of a conflict you resolved within a team?

Candidate: Sure. In a group project at university, two teammates disagreed on the technical approach. I organized a meeting where everyone could present their ideas. We evaluated the pros and cons objectively and found a hybrid solution that incorporated the best aspects of both approaches.

Interviewer: Excellent conflict resolution skills. Do you have any questions about the position?

Candidate: Yes. What does the career progression look like for this role? And what kind of training opportunities do you offer?

Interviewer: We have a clear promotion track from junior to senior to lead engineer. We also provide an annual training budget of 3,000 dollars per employee for conferences, courses, or certifications.

Candidate: That sounds fantastic. I'm very interested in this opportunity.

Interviewer: Well, thank you for coming in today, David. We'll be in touch within a week regarding the next steps.''',
      duration: 160,
      difficulty: 2,
      category: ListeningCategory.interview,
      tags: ['career', 'interview', 'work'],
      accent: 'American',
      speakerCount: 2,
      vocabulary: [
        ListeningVocabulary(
          word: 'proficient',
          phonetic: '/prəˈfɪʃnt/',
          definition: 'competent or skilled in doing something',
          timestamp: '01:30',
        ),
        ListeningVocabulary(
          word: 'prioritize',
          phonetic: '/praɪˈɒrətaɪz/',
          definition: 'to treat something as more important than other things',
          timestamp: '02:00',
        ),
        ListeningVocabulary(
          word: 'milestones',
          phonetic: '/ˈmaɪlstəʊnz/',
          definition: 'important stages in development',
          timestamp: '02:05',
        ),
        ListeningVocabulary(
          word: 'hybrid',
          phonetic: '/ˈhaɪbrɪd/',
          definition: 'something made by combining two different elements',
          timestamp: '02:40',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'lm3_q1',
          question: 'What did David study at university?',
          options: [
            'Business Administration',
            'Computer Science',
            'Mechanical Engineering',
            'Psychology'
          ],
          correctAnswer: 1,
          explanation: 'David says: "I specialized in artificial intelligence and machine learning" after confirming his Computer Science degree.',
          timestamp: 35,
        ),
        ListeningQuestion(
          id: 'lm3_q2',
          question: 'Where did David do his internship?',
          options: [
            'Beijing University',
            'Tech Solutions',
            'AI Company',
            'Customer Service Inc.'
          ],
          correctAnswer: 1,
          explanation: 'David says: "During my internship at Tech Solutions last summer..."',
          timestamp: 55,
        ),
        ListeningQuestion(
          id: 'lm3_q3',
          question: 'By how much did David\'s chatbot project reduce response time?',
          options: ['20%', '30%', '40%', '50%'],
          correctAnswer: 2,
          explanation: 'David says: "We reduced response time by 40 percent."',
          timestamp: 65,
        ),
        ListeningQuestion(
          id: 'lm3_q4',
          question: 'What is the annual training budget per employee?',
          options: [
            '1,000 dollars',
            '2,000 dollars',
            '3,000 dollars',
            '5,000 dollars'
          ],
          correctAnswer: 2,
          explanation: 'Mrs. Chen says: "We also provide an annual training budget of 3,000 dollars per employee."',
          timestamp: 155,
        ),
      ],
    ),
  ];

  // ==================== HARD EXERCISES (高三) ====================
  
  static final List<ListeningModel> _hardExercises = [
    // Hard 1: Academic Lecture - Psychology
    ListeningModel(
      id: 'listening_hard_001',
      title: 'The Psychology of Decision Making',
      audioUrl: 'tts://psychology_lecture',
      transcript: '''Professor: Good morning, everyone. Today we'll explore the fascinating field of behavioral economics and how cognitive biases affect our decision-making processes. This topic bridges psychology and economics, offering insights into why humans often make irrational choices despite having access to logical information.

Let's begin with the concept of "loss aversion," first identified by psychologists Daniel Kahneman and Amos Tversky in 1979. Their research demonstrated that people experience the psychological impact of losses approximately twice as intensely as equivalent gains. In practical terms, losing one hundred dollars feels roughly as bad as gaining two hundred dollars feels good. This asymmetry profoundly influences financial decisions, risk assessment, and even personal relationships.

Consider the following experiment: Participants are divided into two groups. Group A receives a coffee mug and is asked the minimum price they would sell it for. Group B is shown the same mug and asked the maximum price they would pay for it. Consistently, Group A's selling prices are two to three times higher than Group B's buying prices. This "endowment effect" occurs because once people possess an object, they irrationally overvalue it due to loss aversion.

Another critical bias is "confirmation bias"—our tendency to seek, interpret, and remember information that confirms our preexisting beliefs while dismissing contradictory evidence. In the digital age, this phenomenon has been amplified by algorithmic filtering. Social media platforms show us content aligned with our views, creating "echo chambers" that reinforce our convictions and make us resistant to changing our minds, even when presented with factual corrections.

The "availability heuristic" also shapes our judgment. We tend to overestimate the probability of events that are easily recalled, usually because they're dramatic or recently experienced. After watching news coverage of an airplane crash, people often overestimate the danger of flying while underestimating the much higher risks of driving. This bias affects everything from investment decisions to health choices.

Understanding these biases doesn't make us immune to them, but awareness allows us to implement safeguards. Some strategies include: seeking diverse perspectives before making important decisions, using systematic checklists rather than intuition for complex choices, and deliberately considering opposite viewpoints to challenge our assumptions.

Research by psychologist Philip Tetlock shows that experts who consider multiple scenarios and update their beliefs based on new evidence—what he calls "foxes"—make significantly more accurate predictions than those who rely on single grand theories—the "hedgehogs." The fox approach requires intellectual humility and comfort with uncertainty.

As we continue through this course, I encourage you to observe these biases in your own thinking. Keep a decision journal, recording not just what you decided but why, and review it periodically. You'll likely discover patterns of irrationality that, once recognized, can be addressed.

Any questions before we move to our case study analysis?''',
      duration: 210,
      difficulty: 3,
      category: ListeningCategory.lecture,
      tags: ['psychology', 'academic', 'decision making'],
      accent: 'British',
      speakerCount: 1,
      vocabulary: [
        ListeningVocabulary(
          word: 'cognitive biases',
          phonetic: '/ˈkɒɡnɪtɪv ˈbaɪəsɪz/',
          definition: 'systematic patterns of deviation from rational judgment',
          timestamp: '00:15',
        ),
        ListeningVocabulary(
          word: 'loss aversion',
          phonetic: '/lɒs əˈvɜːrʒn/',
          definition: 'the tendency to prefer avoiding losses to acquiring equivalent gains',
          timestamp: '00:35',
        ),
        ListeningVocabulary(
          word: 'endowment effect',
          phonetic: '/ɪnˈdaʊmənt ɪˈfekt/',
          definition: 'the tendency to value something more once we own it',
          timestamp: '01:35',
        ),
        ListeningVocabulary(
          word: 'heuristic',
          phonetic: '/hjʊˈrɪstɪk/',
          definition: 'a mental shortcut that allows people to solve problems quickly',
          timestamp: '02:50',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'lh1_q1',
          question: 'According to the lecture, how much more intensely do people experience losses compared to gains?',
          options: ['The same', 'About 1.5 times', 'About twice as intensely', 'About three times'],
          correctAnswer: 2,
          explanation: 'The professor states: "people experience the psychological impact of losses approximately twice as intensely as equivalent gains."',
          timestamp: 50,
        ),
        ListeningQuestion(
          id: 'lh1_q2',
          question: 'What is the "endowment effect"?',
          options: [
            'The tendency to buy expensive items',
            'The tendency to value something more once we own it',
            'The tendency to give away possessions',
            'The tendency to avoid owning things'
          ],
          correctAnswer: 1,
          explanation: 'The professor defines it as occurring "because once people possess an object, they irrationally overvalue it due to loss aversion."',
          timestamp: 95,
        ),
        ListeningQuestion(
          id: 'lh1_q3',
          question: 'What does the professor call experts who consider multiple scenarios?',
          options: ['Hedgehogs', 'Foxes', 'Eagles', 'Wolves'],
          correctAnswer: 1,
          explanation: 'The professor mentions: "experts who consider multiple scenarios and update their beliefs based on new evidence—what he calls \'foxes\'"',
          timestamp: 230,
        ),
        ListeningQuestion(
          id: 'lh1_q4',
          question: 'According to the lecture, what creates "echo chambers"?',
          options: [
            'University lectures',
            'Social media algorithms',
            'Newspaper articles',
            'Book clubs'
          ],
          correctAnswer: 1,
          explanation: 'The professor states: "Social media platforms show us content aligned with our views, creating \'echo chambers\'"',
          timestamp: 140,
        ),
        ListeningQuestion(
          id: 'lh1_q5',
          question: 'What strategy does the professor recommend for making better decisions?',
          options: [
            'Always follow your intuition',
            'Avoid seeking diverse perspectives',
            'Use systematic checklists and consider opposite viewpoints',
            'Make decisions quickly without thinking'
          ],
          correctAnswer: 2,
          explanation: 'The professor recommends: "using systematic checklists rather than intuition for complex choices, and deliberately considering opposite viewpoints."',
          timestamp: 200,
        ),
      ],
    ),

    // Hard 2: Debate - Technology and Society
    ListeningModel(
      id: 'listening_hard_002',
      title: 'Should Social Media Be Regulated?',
      audioUrl: 'tts://social_media_debate',
      transcript: '''Moderator: Welcome to tonight's debate on social media regulation. Speaking for the proposition is Dr. Sarah Mitchell, a digital ethics researcher. Speaking against is Mr. James Chen, CEO of TechForward. Each speaker has five minutes.

Dr. Mitchell: Thank you. Social media platforms have become the public squares of the 21st century, yet they operate with minimal oversight. This lack of regulation has enabled the spread of misinformation, hate speech, and harmful content that undermines democratic institutions and public health.

Consider the evidence: During the 2020 pandemic, false information about vaccines spread faster than factual content because algorithms prioritize engagement over accuracy. A recent MIT study found that false news stories are 70 percent more likely to be retweeted than true ones. Without regulation, platforms have no incentive to change these destructive algorithms.

Furthermore, these companies exploit psychological vulnerabilities to maximize screen time. Features like infinite scroll and variable reward mechanisms—similar to slot machines—create addictive behaviors, particularly among adolescents. Research links heavy social media use to increased rates of anxiety, depression, and suicide in teenagers.

The opposition will argue that regulation stifles innovation. But we regulate countless industries—pharmaceuticals, aviation, food safety—without destroying them. Regulation ensures that profit motives align with public good. The European Union's Digital Services Act demonstrates that effective regulation is possible without crushing the industry.

We need transparency requirements for algorithms, strict data privacy protections, and accountability for content moderation decisions. The question isn't whether we can afford to regulate, but whether we can afford not to.

Mr. Chen: Dr. Mitchell raises valid concerns, but her solution—government regulation—creates far worse problems than it solves.

First, who decides what constitutes "misinformation"? Yesterday's conspiracy theory becomes today's accepted fact. Galileo was persecuted for spreading "false information" about the solar system. Giving governments power to censor online speech inevitably leads to suppression of legitimate dissent.

Second, regulation disproportionately harms smaller competitors who cannot afford compliance costs. The GDPR in Europe cost companies billions, and the biggest tech firms—Google, Facebook, Amazon—welcomed it because it cemented their dominance by crushing potential rivals. Regulation creates moats around incumbent monopolies.

Third, algorithmic transparency sounds appealing but is technically impossible without exposing trade secrets. Requiring platforms to explain exactly how their algorithms work is like forcing Coca-Cola to publish its secret formula. It would destroy competitive advantage and help malicious actors game the system.

The real solution lies in education and competition, not regulation. Teach digital literacy in schools so citizens can critically evaluate information. Support decentralized platforms that give users control over their data and feeds. Innovation, not legislation, will solve these challenges.

History shows that regulating emerging technologies prematurely stifles their potential. We should learn from the open internet's success, not repeat the mistakes of overreach.

Moderator: Thank you both. We'll now move to cross-examination...''',
      duration: 240,
      difficulty: 3,
      category: ListeningCategory.interview,
      tags: ['debate', 'technology', 'social media', 'politics'],
      accent: 'American',
      speakerCount: 3,
      vocabulary: [
        ListeningVocabulary(
          word: 'misinformation',
          phonetic: '/ˌmɪsɪnfərˈmeɪʃn/',
          definition: 'false or inaccurate information',
          timestamp: '01:00',
        ),
        ListeningVocabulary(
          word: 'algorithms',
          phonetic: '/ˈælɡərɪðəmz/',
          definition: 'sets of rules followed by computers',
          timestamp: '01:20',
        ),
        ListeningVocabulary(
          word: 'incumbent',
          phonetic: '/ɪnˈkʌmbənt/',
          definition: 'the current holder of a position or office',
          timestamp: '03:30',
        ),
        ListeningVocabulary(
          word: 'decentralized',
          phonetic: '/diːˈsentrəlaɪzd/',
          definition: 'controlled by several local offices rather than one main one',
          timestamp: '04:20',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'lh2_q1',
          question: 'According to Dr. Mitchell, what percentage more likely are false news stories to be retweeted?',
          options: ['50%', '60%', '70%', '80%'],
          correctAnswer: 2,
          explanation: 'Dr. Mitchell states: "A recent MIT study found that false news stories are 70 percent more likely to be retweeted than true ones."',
          timestamp: 80,
        ),
        ListeningQuestion(
          id: 'lh2_q2',
          question: 'What does Mr. Chen compare requiring algorithmic transparency to?',
          options: [
            'Publishing a book',
            'Forcing Coca-Cola to publish its secret formula',
            'Opening a bank account',
            'Getting a driver\'s license'
          ],
          correctAnswer: 1,
          explanation: 'Mr. Chen says: "Requiring platforms to explain exactly how their algorithms work is like forcing Coca-Cola to publish its secret formula."',
          timestamp: 220,
        ),
        ListeningQuestion(
          id: 'lh2_q3',
          question: 'What historical example does Mr. Chen use to argue against censorship?',
          options: [
            'The printing press',
            'Galileo',
            'The internet',
            'Television'
          ],
          correctAnswer: 1,
          explanation: 'Mr. Chen mentions: "Galileo was persecuted for spreading \'false information\' about the solar system."',
          timestamp: 180,
        ),
        ListeningQuestion(
          id: 'lh2_q4',
          question: 'According to Dr. Mitchell, which region has demonstrated effective regulation?',
          options: [
            'The United States',
            'China',
            'The European Union',
            'Japan'
          ],
          correctAnswer: 2,
          explanation: 'Dr. Mitchell says: "The European Union\'s Digital Services Act demonstrates that effective regulation is possible."',
          timestamp: 140,
        ),
        ListeningQuestion(
          id: 'lh2_q5',
          question: 'What solution does Mr. Chen propose instead of regulation?',
          options: [
            'Banning social media',
            'Education and competition',
            'Higher taxes on tech companies',
            'Government control of platforms'
          ],
          correctAnswer: 1,
          explanation: 'Mr. Chen states: "The real solution lies in education and competition, not regulation."',
          timestamp: 240,
        ),
      ],
    ),

    // Hard 3: Complex Dialogue - University Admissions
    ListeningModel(
      id: 'listening_hard_003',
      title: 'University Admissions Interview',
      audioUrl: 'tts://university_admissions',
      transcript: '''Admissions Officer: Good afternoon. I'm Professor Williams from the admissions committee. Please, sit down.

Student: Good afternoon, Professor. Thank you for this opportunity.

Admissions Officer: Let's begin. Your academic record is impressive—top grades in mathematics and science. But I notice you took a gap year between high school and now. Can you tell us about that decision?

Student: Yes, absolutely. I chose to take a gap year because I felt I needed real-world experience before committing to a specific field of study. I spent six months volunteering at a rural medical clinic in Yunnan Province, and then three months interning at a renewable energy startup in Shenzhen.

Admissions Officer: Interesting combination. What did you learn from these experiences?

Student: At the clinic, I saw how limited access to electricity affects healthcare delivery. Vaccines couldn't be refrigerated, medical equipment couldn't be sterilized properly, and emergency surgeries were often impossible after dark. This made me realize that infrastructure and energy policy are fundamental to public health.

Then at the startup, I worked on solar microgrid projects for remote villages. I discovered that the technical challenges are often less significant than the social and economic barriers—community buy-in, financing models, maintenance training. Solving these problems requires interdisciplinary thinking that combines engineering, economics, and anthropology.

Admissions Officer: That's a sophisticated understanding for someone your age. Your application essay mentioned wanting to study "engineering for social impact." Our university has traditionally focused on pure technical excellence. How do you see yourself fitting into our program?

Student: I believe the greatest engineering challenges of our time—climate change, sustainable development, equitable technology access—cannot be solved by technical expertise alone. They require understanding human systems, political realities, and cultural contexts. I want to push the boundaries of what engineering education can be.

I've reviewed Professor Chen's work on appropriate technology and Dr. Martinez's research on energy justice. Their interdisciplinary approach aligns perfectly with my interests. I would hope to contribute to their research while also bringing my field experience to classroom discussions.

Admissions Officer: Your references mention that you taught yourself Mandarin during your gap year. That's quite an achievement.

Student: Thank you. Living in Yunnan, I realized that language is more than communication—it's a key to understanding different worldviews. The way Chinese conceptualizes relationships between individuals and society, for instance, shaped how I think about collective action problems in energy policy.

Admissions Officer: We have over three thousand applicants for two hundred spots this year. What makes you unique?

Student: Most applicants have better test scores or more prestigious awards. But few have spent months in villages without electricity, negotiating with local officials, adapting when plans failed, and learning that effective solutions must emerge from collaboration with communities rather than being imposed on them. I bring humility, resilience, and a commitment to listening before acting.

Admissions Officer: One final question. Where do you see yourself in ten years?

Student: I hope to lead an organization that designs and implements sustainable energy systems for underserved communities—whether that's in rural China, sub-Saharan Africa, or other regions facing similar challenges. But more importantly, I want to train the next generation of engineers to think beyond the technical specifications and consider the human impact of their work.

Admissions Officer: Thank you for your thoughtful responses. The committee will make decisions by April 1st. Do you have any questions for me?

Student: Yes. How does the university support students who want to pursue interdisciplinary research that doesn't fit neatly into traditional departmental boundaries?

Admissions Officer: That's an excellent question. We actually launched a new initiative last year specifically for...''',
      duration: 260,
      difficulty: 3,
      category: ListeningCategory.interview,
      tags: ['education', 'career', 'university', 'gap year'],
      accent: 'American',
      speakerCount: 2,
      vocabulary: [
        ListeningVocabulary(
          word: 'interdisciplinary',
          phonetic: '/ˌɪntərˈdɪsəplɪneri/',
          definition: 'involving two or more academic disciplines',
          timestamp: '02:00',
        ),
        ListeningVocabulary(
          word: 'microgrid',
          phonetic: '/ˈmaɪkrəʊɡrɪd/',
          definition: 'a small-scale power grid that can operate independently',
          timestamp: '01:35',
        ),
        ListeningVocabulary(
          word: 'buy-in',
          phonetic: '/ˈbaɪ ɪn/',
          definition: 'acceptance of and agreement with a decision or proposal',
          timestamp: '01:45',
        ),
        ListeningVocabulary(
          word: 'prestigious',
          phonetic: '/preˈstɪdʒəs/',
          definition: 'having high status or respect',
          timestamp: '04:00',
        ),
      ],
      questions: [
        ListeningQuestion(
          id: 'lh3_q1',
          question: 'Where did the student volunteer during the gap year?',
          options: [
            'A hospital in Beijing',
            'A rural medical clinic in Yunnan Province',
            'A school in Shanghai',
            'An orphanage in Guangzhou'
          ],
          correctAnswer: 1,
          explanation: 'The student says: "I spent six months volunteering at a rural medical clinic in Yunnan Province."',
          timestamp: 50,
        ),
        ListeningQuestion(
          id: 'lh3_q2',
          question: 'What problem did the student observe at the clinic related to electricity?',
          options: [
            'Too much electricity was being used',
            'Vaccines couldn\'t be refrigerated',
            'The lights were too bright',
            'Computers didn\'t work'
          ],
          correctAnswer: 1,
          explanation: 'The student mentions: "Vaccines couldn\'t be refrigerated, medical equipment couldn\'t be sterilized properly."',
          timestamp: 75,
        ),
        ListeningQuestion(
          id: 'lh3_q3',
          question: 'What language did the student learn during the gap year?',
          options: ['English', 'Japanese', 'Mandarin', 'Korean'],
          correctAnswer: 2,
          explanation: 'The admissions officer mentions: "Your references mention that you taught yourself Mandarin during your gap year."',
          timestamp: 180,
        ),
        ListeningQuestion(
          id: 'lh3_q4',
          question: 'How many applicants are there for how many spots?',
          options: [
            '1,000 applicants for 100 spots',
            '2,000 applicants for 150 spots',
            '3,000 applicants for 200 spots',
            '5,000 applicants for 500 spots'
          ],
          correctAnswer: 2,
          explanation: 'The admissions officer says: "We have over three thousand applicants for two hundred spots this year."',
          timestamp: 200,
        ),
        ListeningQuestion(
          id: 'lh3_q5',
          question: 'What does the student want to do in ten years?',
          options: [
            'Become a medical doctor',
            'Lead an organization for sustainable energy in underserved communities',
            'Work at a technology company',
            'Teach at a university'
          ],
          correctAnswer: 1,
          explanation: 'The student says: "I hope to lead an organization that designs and implements sustainable energy systems for underserved communities."',
          timestamp: 230,
        ),
      ],
    ),
  ];
}
