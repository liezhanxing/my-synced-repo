import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/grammar_model.dart';
import 'grammar_controller.dart';

/// Interactive grammar exercise screen
/// 
/// Exercise types:
/// - Fill in the blank with correct grammar form
/// - Error correction: Find and fix the grammatical error
/// - Sentence reordering: Arrange words to form a correct sentence
/// - Multiple choice grammar questions
/// - Score and feedback at end
class GrammarExerciseScreen extends ConsumerStatefulWidget {
  final GrammarModel grammar;

  const GrammarExerciseScreen({
    super.key,
    required this.grammar,
  });

  @override
  ConsumerState<GrammarExerciseScreen> createState() => _GrammarExerciseScreenState();
}

class _GrammarExerciseScreenState extends ConsumerState<GrammarExerciseScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // Start exercise when screen loads
    Future.microtask(() {
      ref.read(grammarExerciseControllerProvider.notifier).startExercise(widget.grammar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseState = ref.watch(grammarExerciseControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('语法练习'),
        backgroundColor: ModuleColors.grammar.withOpacity(0.1),
        foregroundColor: ModuleColors.grammar,
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
                '${exerciseState.currentQuestionIndex + 1 > exerciseState.totalQuestions ? exerciseState.totalQuestions : exerciseState.currentQuestionIndex + 1}/${exerciseState.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: exerciseState.isCompleted
          ? _buildResultsScreen(exerciseState)
          : _buildExerciseScreen(exerciseState),
    );
  }

  Widget _buildExerciseScreen(GrammarExerciseState state) {
    final question = state.currentQuestion;
    
    if (question == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: state.progress,
          backgroundColor: AppColors.divider,
          valueColor: AlwaysStoppedAnimation<Color>(ModuleColors.grammar),
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
                  speechText: _getMascotTip(question.type),
                ),
                const SizedBox(height: 24),

                // Question type indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: ModuleColors.grammar.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getQuestionTypeName(question.type),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ModuleColors.grammar,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Question content based on type
                if (question.type == 'fill_blank')
                  _buildFillBlankQuestion(question)
                else if (question.type == 'error_correction')
                  _buildErrorCorrectionQuestion(question)
                else if (question.type == 'multiple_choice')
                  _buildMultipleChoiceQuestion(question)
                else
                  _buildGenericQuestion(question),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getMascotTip(String questionType) {
    final tips = {
      'fill_blank': '仔细读题，选择正确的形式！',
      'error_correction': '找出句子中的语法错误！',
      'multiple_choice': '选择正确的答案！',
      'reordering': '把单词排列成正确的句子！',
    };
    return tips[questionType] ?? '认真思考，你可以的！';
  }

  String _getQuestionTypeName(String type) {
    final names = {
      'fill_blank': '填空题',
      'error_correction': '改错题',
      'multiple_choice': '选择题',
      'reordering': '排序题',
    };
    return names[type] ?? '练习题';
  }

  Widget _buildFillBlankQuestion(GrammarExerciseQuestion question) {
    return Column(
      children: [
        AnimeCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              if (question.sentence != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _createBlankSentence(question.sentence!),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Options
        if (question.options != null)
          ...question.options!.map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionButton(option, question.correctAnswer),
          )),
      ],
    );
  }

  String _createBlankSentence(String sentence) {
    // Create a sentence with blank by removing key words
    // For now, just return the sentence with a placeholder
    return sentence;
  }

  Widget _buildErrorCorrectionQuestion(GrammarExerciseQuestion question) {
    return Column(
      children: [
        AnimeCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              if (question.sentence != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.errorRed.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.errorRed,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.sentence!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Input field for corrected sentence
        TextField(
          controller: _answerController,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: '输入正确的句子...',
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
                color: ModuleColors.grammar,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
        
        if (_hasSubmitted) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect ? AppColors.successGreenLight : AppColors.errorRedLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _isCorrect ? Icons.check_circle : Icons.error,
                      color: _isCorrect ? AppColors.successGreen : AppColors.errorRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCorrect ? '回答正确！' : '回答错误',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isCorrect ? AppColors.successGreen : AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
                if (!_isCorrect) ...[
                  const SizedBox(height: 8),
                  Text(
                    '正确答案: ${question.correctAnswer}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  question.explanation,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 24),
        AnimeButton(
          text: _hasSubmitted ? '下一题' : '提交',
          onPressed: () => _hasSubmitted
              ? _nextQuestion()
              : _checkErrorCorrection(question.correctAnswer),
          isDisabled: _answerController.text.isEmpty && !_hasSubmitted,
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceQuestion(GrammarExerciseQuestion question) {
    return Column(
      children: [
        AnimeCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Options
        if (question.options != null)
          ...question.options!.map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionButton(option, question.correctAnswer),
          )),
      ],
    );
  }

  Widget _buildGenericQuestion(GrammarExerciseQuestion question) {
    return AnimeCard(
      padding: const EdgeInsets.all(24),
      child: Text(
        question.question,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    final isSelected = _selectedOption == option;
    final isCorrect = option == correctAnswer;
    
    Color backgroundColor = Colors.white;
    Color borderColor = AppColors.divider;
    
    if (_hasSubmitted) {
      if (isCorrect) {
        backgroundColor = AppColors.successGreenLight;
        borderColor = AppColors.successGreen;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.errorRedLight;
        borderColor = AppColors.errorRed;
      }
    } else if (isSelected) {
      backgroundColor = ModuleColors.grammar.withOpacity(0.1);
      borderColor = ModuleColors.grammar;
    }

    return GestureDetector(
      onTap: _hasSubmitted ? null : () => _selectOption(option, correctAnswer),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: _hasSubmitted && isCorrect 
                      ? AppColors.successGreen 
                      : (_hasSubmitted && isSelected && !isCorrect)
                          ? AppColors.errorRed
                          : AppColors.textPrimary,
                ),
              ),
            ),
            if (_hasSubmitted && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.successGreen)
            else if (_hasSubmitted && isSelected && !isCorrect)
              const Icon(Icons.error, color: AppColors.errorRed),
          ],
        ),
      ),
    );
  }

  void _selectOption(String option, String correctAnswer) {
    setState(() {
      _selectedOption = option;
      _hasSubmitted = true;
      _isCorrect = option == correctAnswer;
    });

    // Auto advance after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        ref.read(grammarExerciseControllerProvider.notifier).submitAnswer(_isCorrect);
        setState(() {
          _hasSubmitted = false;
          _isCorrect = false;
          _selectedOption = null;
        });
      }
    });
  }

  void _checkErrorCorrection(String correctAnswer) {
    final answer = _answerController.text.trim();
    final isCorrect = answer.toLowerCase() == correctAnswer.toLowerCase();
    
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
    });
  }

  void _nextQuestion() {
    ref.read(grammarExerciseControllerProvider.notifier).submitAnswer(_isCorrect);
    setState(() {
      _hasSubmitted = false;
      _isCorrect = false;
      _selectedOption = null;
      _answerController.clear();
    });
  }

  Widget _buildResultsScreen(GrammarExerciseState state) {
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
            speechText: isGoodScore ? '太棒了！掌握得很好！' : '继续加油，你会更好的！',
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
                const SizedBox(height: 8),
                Text(
                  widget.grammar.titleCn,
                  style: TextStyle(
                    fontSize: 16,
                    color: ModuleColors.grammar,
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
                    ref.read(grammarExerciseControllerProvider.notifier).resetExercise();
                    ref.read(grammarExerciseControllerProvider.notifier).startExercise(widget.grammar);
                    setState(() {
                      _hasSubmitted = false;
                      _isCorrect = false;
                      _selectedOption = null;
                      _answerController.clear();
                    });
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
