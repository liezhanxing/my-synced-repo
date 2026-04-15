import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/reading_model.dart';
import 'reading_controller.dart';

/// Reading comprehension questions screen
/// 
/// Displays multiple choice and true/false questions with
/// feedback, explanations, and final score summary.
class ReadingQuestionsScreen extends ConsumerWidget {
  const ReadingQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passage = ref.watch(selectedPassageProvider);
    final controller = ref.watch(readingControllerProvider);
    final controllerNotifier = ref.read(readingControllerProvider.notifier);

    if (passage == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show results if submitted
    if (controller.showResults) {
      return _buildResultsScreen(context, passage, controller, controllerNotifier);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: ModuleColors.reading.withOpacity(0.1),
        foregroundColor: ModuleColors.reading,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '阅读理解 (${controller.currentQuestionIndex + 1}/${passage.questions.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ModuleColors.reading,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildQuestionProgress(passage, controller),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  _buildQuestionCard(passage, controller, controllerNotifier),
                  
                  const SizedBox(height: 24),
                  
                  // Navigation buttons
                  _buildNavigationButtons(context, passage, controller, controllerNotifier),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionProgress(ReadingModel passage, ReadingState controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          // Question dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(passage.questions.length, (index) {
              final isCurrent = index == controller.currentQuestionIndex;
              final isAnswered = controller.userAnswers.containsKey(passage.questions[index].id);
              
              return GestureDetector(
                onTap: () => ref.read(readingControllerProvider.notifier).goToQuestion(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isCurrent ? 32 : 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? ModuleColors.reading
                        : isAnswered
                            ? ModuleColors.reading.withOpacity(0.5)
                            : AppColors.divider,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: isCurrent
                      ? Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Progress text
          Text(
            '已答 ${controller.userAnswers.length}/${passage.questions.length} 题',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    ReadingModel passage,
    ReadingState controller,
    ReadingController controllerNotifier,
  ) {
    final question = passage.questions[controller.currentQuestionIndex];
    final selectedAnswer = controller.userAnswers[question.id];

    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question type badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question.type.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Question text
          Text(
            '${controller.currentQuestionIndex + 1}. ${question.question}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Options
          ...List.generate(question.options.length, (index) {
            final isSelected = selectedAnswer == index;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOptionCard(
                optionIndex: index,
                optionText: question.options[index],
                isSelected: isSelected,
                onTap: () => controllerNotifier.answerQuestion(question.id, index),
              ),
            );
          }),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildOptionCard({
    required int optionIndex,
    required String optionText,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final optionLetters = ['A', 'B', 'C', 'D'];
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? ModuleColors.reading.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ModuleColors.reading : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Option letter
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? ModuleColors.reading : AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  optionLetters[optionIndex],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Option text
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: ModuleColors.reading,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    ReadingModel passage,
    ReadingState controller,
    ReadingController controllerNotifier,
  ) {
    final isFirstQuestion = controller.currentQuestionIndex == 0;
    final isLastQuestion = controller.currentQuestionIndex == passage.questions.length - 1;
    final canSubmit = controller.allQuestionsAnswered;

    return Row(
      children: [
        // Previous button
        if (!isFirstQuestion)
          Expanded(
            flex: 1,
            child: AnimeOutlinedButton(
              text: '上一题',
              onPressed: controllerNotifier.previousQuestion,
              borderColor: ModuleColors.reading,
              textColor: ModuleColors.reading,
              height: 50,
            ),
          )
        else
          const Expanded(flex: 1, child: SizedBox()),
        
        const SizedBox(width: 12),
        
        // Next/Submit button
        Expanded(
          flex: 2,
          child: isLastQuestion
              ? AnimeButton(
                  text: canSubmit ? '提交答案' : '请先完成所有题目',
                  onPressed: canSubmit ? controllerNotifier.submitAnswers : null,
                  gradient: LinearGradient(
                    colors: canSubmit
                        ? [ModuleColors.reading, AppColors.accentLime]
                        : [Colors.grey, Colors.grey.shade400],
                  ),
                  height: 50,
                  isDisabled: !canSubmit,
                )
              : AnimeButton(
                  text: '下一题',
                  onPressed: controllerNotifier.nextQuestion,
                  gradient: LinearGradient(
                    colors: [ModuleColors.reading, AppColors.accentLime],
                  ),
                  height: 50,
                ),
        ),
      ],
    );
  }

  // ==================== Results Screen ====================

  Widget _buildResultsScreen(
    BuildContext context,
    ReadingModel passage,
    ReadingState controller,
    ReadingController controllerNotifier,
  ) {
    final score = controller.scorePercentage;
    final correctCount = controller.correctAnswersCount;
    final totalQuestions = passage.questions.length;
    
    // Determine mascot expression based on score
    final MascotExpression mascotExpression;
    final String mascotMessage;
    
    if (score >= 80) {
      mascotExpression = MascotExpression.celebrating;
      mascotMessage = '太棒了！你的阅读理解能力真强！🎉';
    } else if (score >= 60) {
      mascotExpression = MascotExpression.happy;
      mascotMessage = '做得不错！继续加油！👍';
    } else {
      mascotExpression = MascotExpression.sad;
      mascotMessage = '别灰心，再试一次会更好！💪';
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Mascot
              MascotWidget(
                expression: mascotExpression,
                size: 100,
                speechText: mascotMessage,
              ),
              
              const SizedBox(height: 32),
              
              // Score card
              AnimeCard(
                padding: const EdgeInsets.all(24),
                showGradientBorder: true,
                borderGradient: LinearGradient(
                  colors: score >= 60
                      ? [AppColors.successGreen, AppColors.accentLime]
                      : [AppColors.errorRed, AppColors.accentOrange],
                ),
                child: Column(
                  children: [
                    Text(
                      '得分',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${score.toInt()}',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: score >= 60 ? AppColors.successGreen : AppColors.errorRed,
                      ),
                    ),
                    Text(
                      '$correctCount/$totalQuestions 正确',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Question review
              ...List.generate(passage.questions.length, (index) {
                final question = passage.questions[index];
                final userAnswer = controller.userAnswers[question.id];
                final isCorrect = userAnswer == question.correctAnswer;
                
                return _buildQuestionReviewCard(
                  index: index,
                  question: question,
                  userAnswer: userAnswer,
                  isCorrect: isCorrect,
                );
              }),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AnimeOutlinedButton(
                      text: '重新答题',
                      onPressed: controllerNotifier.restartQuestions,
                      borderColor: ModuleColors.reading,
                      textColor: ModuleColors.reading,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimeButton(
                      text: '返回列表',
                      onPressed: () {
                        controllerNotifier.clearSelectedPassage();
                        context.pop();
                        context.pop();
                      },
                      height: 50,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionReviewCard({
    required int index,
    required ReadingQuestion question,
    required int? userAnswer,
    required bool isCorrect,
  }) {
    final optionLetters = ['A', 'B', 'C', 'D'];
    
    return AnimeCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '问题 ${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Question text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // User answer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect 
                  ? AppColors.successGreen.withOpacity(0.1) 
                  : AppColors.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect 
                    ? AppColors.successGreen.withOpacity(0.3) 
                    : AppColors.errorRed.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? '你的答案 (正确)' : '你的答案',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userAnswer != null 
                      ? '${optionLetters[userAnswer]}. ${question.options[userAnswer]}'
                      : '未作答',
                  style: TextStyle(
                    fontSize: 14,
                    color: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ),
          
          // Show correct answer if wrong
          if (!isCorrect) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.successGreen.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '正确答案',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${optionLetters[question.correctAnswer]}. ${question.options[question.correctAnswer]}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Explanation
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentCyanLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '解析',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question.explanation,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 100))
      .slideY(begin: 0.1, end: 0);
  }
}
