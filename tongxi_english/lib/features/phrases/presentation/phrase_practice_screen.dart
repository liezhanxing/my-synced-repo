import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/phrase_model.dart';
import 'phrases_controller.dart';

/// Practice exercises screen for phrases
/// 
/// Exercise types:
/// - Fill in the blank: Sentence with missing phrase, choose from 4 options
/// - Match: Match English phrases to Chinese meanings
/// - Complete the sentence: Given context, type the correct phrase
/// - Session score tracking
class PhrasePracticeScreen extends ConsumerStatefulWidget {
  final String? category;

  const PhrasePracticeScreen({
    super.key,
    this.category,
  });

  @override
  ConsumerState<PhrasePracticeScreen> createState() => _PhrasePracticeScreenState();
}

class _PhrasePracticeScreenState extends ConsumerState<PhrasePracticeScreen> {
  final TtsService _ttsService = TtsService();
  int _currentExerciseType = 0; // 0: fill blank, 1: match, 2: complete
  
  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _startSession();
  }

  void _startSession() {
    Future.microtask(() {
      ref.read(practiceSessionControllerProvider.notifier)
          .startSession(category: widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(practiceSessionControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('短语练习'),
        backgroundColor: AppColors.secondaryPink.withOpacity(0.1),
        foregroundColor: AppColors.secondaryPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${sessionState.currentIndex + 1 > sessionState.totalQuestions ? sessionState.totalQuestions : sessionState.currentIndex + 1}/${sessionState.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: sessionState.isCompleted
          ? _buildResultsScreen(sessionState)
          : _buildExerciseScreen(sessionState),
    );
  }

  Widget _buildExerciseScreen(PracticeSessionState state) {
    final currentPhrase = ref.read(practiceSessionControllerProvider.notifier).currentPhrase;
    
    if (currentPhrase == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Cycle through exercise types
    _currentExerciseType = state.currentIndex % 3;

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: state.progress,
          backgroundColor: AppColors.divider,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryPink),
          minHeight: 4,
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Column(
              children: [
                // Mascot tip
                MascotWidget(
                  expression: MascotExpression.thinking,
                  size: 80,
                  speechText: _getMascotTip(),
                ),
                const SizedBox(height: 24),

                // Exercise content based on type
                if (_currentExerciseType == 0)
                  _buildFillInBlankExercise(currentPhrase, state)
                else if (_currentExerciseType == 1)
                  _buildMatchExercise(currentPhrase, state)
                else
                  _buildCompleteSentenceExercise(currentPhrase, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getMascotTip() {
    final tips = [
      '仔细读题，选择正确的短语！',
      '想一想这个短语的意思...',
      '加油！你可以的！',
      '记住短语的搭配用法哦！',
    ];
    return tips[_currentExerciseType % tips.length];
  }

  // Fill in the blank exercise
  Widget _buildFillInBlankExercise(PhraseModel phrase, PracticeSessionState state) {
    final options = ref.read(practiceSessionControllerProvider.notifier).getFillInBlankOptions();
    
    // Generate a sentence with blank
    final example = phrase.examples.first;
    final sentence = example.sentence;
    final phraseWords = phrase.phrase.toLowerCase().split(' ');
    
    // Create blanked sentence
    String blankedSentence = sentence;
    for (final word in phraseWords) {
      blankedSentence = blankedSentence.replaceAll(
        RegExp(word, caseSensitive: false),
        '_____',
      );
    }

    return Column(
      children: [
        AnimeCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                '选择正确的短语填空',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                blankedSentence,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                example.translation,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Options
        ...options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimeButton(
            text: option,
            onPressed: () => _checkFillBlankAnswer(option, phrase.phrase),
            gradient: LinearGradient(
              colors: [
                AppColors.secondaryPink.withOpacity(0.8),
                AppColors.secondaryPink,
              ],
            ),
          ),
        )),
      ],
    );
  }

  // Match exercise
  Widget _buildMatchExercise(PhraseModel phrase, PracticeSessionState state) {
    final allPhrases = ref.read(phrasesControllerProvider).phrases;
    final otherPhrases = allPhrases.where((p) => p.id != phrase.id).take(3).toList();
    final matchPhrases = [phrase, ...otherPhrases]..shuffle();
    
    return Column(
      children: [
        AnimeCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                '选择正确的释义',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  phrase.phrase,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Meaning options
        ...matchPhrases.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimeButton(
            text: p.translation,
            onPressed: () => _checkMatchAnswer(p.id, phrase.id),
            gradient: LinearGradient(
              colors: [
                AppColors.accentCyan.withOpacity(0.8),
                AppColors.accentCyan,
              ],
            ),
          ),
        )),
      ],
    );
  }

  // Complete sentence exercise
  final TextEditingController _answerController = TextEditingController();
  bool _hasSubmitted = false;
  bool _isCorrect = false;

  Widget _buildCompleteSentenceExercise(PhraseModel phrase, PracticeSessionState state) {
    final example = phrase.examples.first;
    
    return Column(
      children: [
        AnimeCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                '根据中文提示，填写正确的短语',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                example.translation,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _createHintSentence(example.sentence, phrase.phrase),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Input field
        TextField(
          controller: _answerController,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: '输入短语...',
            hintStyle: TextStyle(
              color: AppColors.textHint.withOpacity(0.5),
            ),
            filled: true,
            fillColor: _hasSubmitted
                ? (_isCorrect ? AppColors.successGreenLight : AppColors.errorRedLight)
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _hasSubmitted
                    ? (_isCorrect ? AppColors.successGreen : AppColors.errorRed)
                    : AppColors.divider,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.secondaryPink,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          onSubmitted: (_) => _checkCompleteAnswer(phrase.phrase),
        ),
        
        if (_hasSubmitted) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.error,
                color: _isCorrect ? AppColors.successGreen : AppColors.errorRed,
              ),
              const SizedBox(width: 8),
              Text(
                _isCorrect ? '回答正确！' : '正确答案是: ${phrase.phrase}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isCorrect ? AppColors.successGreen : AppColors.errorRed,
                ),
              ),
            ],
          ),
        ],
        
        const SizedBox(height: 24),
        AnimeButton(
          text: _hasSubmitted ? '下一题' : '提交',
          onPressed: () => _hasSubmitted
              ? _nextQuestion()
              : _checkCompleteAnswer(phrase.phrase),
          isDisabled: _answerController.text.isEmpty && !_hasSubmitted,
        ),
      ],
    );
  }

  String _createHintSentence(String sentence, String phrase) {
    // Replace phrase with underscores
    final phraseLower = phrase.toLowerCase();
    final words = phraseLower.split(' ');
    
    String hint = sentence;
    for (final word in words) {
      hint = hint.replaceAll(
        RegExp(word, caseSensitive: false),
        '____',
      );
    }
    return hint;
  }

  void _checkFillBlankAnswer(String selected, String correct) {
    final isCorrect = selected.toLowerCase().trim() == correct.toLowerCase().trim();
    _showFeedback(isCorrect, correct);
  }

  void _checkMatchAnswer(String selectedId, String correctId) {
    final isCorrect = selectedId == correctId;
    _showFeedback(isCorrect, '');
  }

  void _checkCompleteAnswer(String correct) {
    final answer = _answerController.text.trim();
    final isCorrect = answer.toLowerCase() == correct.toLowerCase();
    
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
    });
  }

  void _nextQuestion() {
    setState(() {
      _hasSubmitted = false;
      _isCorrect = false;
      _answerController.clear();
    });
    ref.read(practiceSessionControllerProvider.notifier).submitAnswer(_isCorrect);
  }

  void _showFeedback(bool isCorrect, String correctAnswer) {
    ref.read(practiceSessionControllerProvider.notifier).submitAnswer(isCorrect);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.error,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? '回答正确！' : '回答错误',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (!isCorrect && correctAnswer.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '正确答案是: $correctAnswer',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              AnimeButton(
                text: '继续',
                onPressed: () {
                  Navigator.pop(context);
                },
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white70],
                ),
                textColor: isCorrect ? AppColors.successGreen : AppColors.errorRed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen(PracticeSessionState state) {
    final accuracy = state.accuracy;
    final isGoodScore = accuracy >= 0.7;
    
    return Padding(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MascotWidget(
            expression: isGoodScore ? MascotExpression.celebrating : MascotExpression.happy,
            size: 120,
            speechText: isGoodScore ? '太棒了！继续加油！' : '不错哦，继续练习！',
          ),
          const SizedBox(height: 32),
          
          AnimeCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Text(
                  '练习完成！',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Score circle
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: isGoodScore ? AppColors.successGradient : AppColors.warmGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${state.score}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/ ${state.totalQuestions}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  '正确率: ${(accuracy * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isGoodScore ? AppColors.successGreen : AppColors.accentOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '答对 ${state.score} 题，答错 ${state.totalQuestions - state.score} 题',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: AnimeOutlinedButton(
                  text: '返回',
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimeButton(
                  text: '再练一次',
                  onPressed: () {
                    ref.read(practiceSessionControllerProvider.notifier).resetSession();
                    _startSession();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 500))
      .slideY(begin: 0.2, end: 0);
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('退出后练习进度将不会保存，确定要退出吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
