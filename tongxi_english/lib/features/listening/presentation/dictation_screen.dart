import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/listening_model.dart';
import 'listening_controller.dart';

/// Dictation practice screen
/// 
/// Allows users to practice dictation by typing what they hear.
/// Shows comparison with correct text and accuracy score.
class DictationScreen extends ConsumerStatefulWidget {
  const DictationScreen({super.key});

  @override
  ConsumerState<DictationScreen> createState() => _DictationScreenState();
}

class _DictationScreenState extends ConsumerState<DictationScreen> {
  final TtsService _ttsService = TtsService();
  final TextEditingController _textController = TextEditingController();
  bool _hasCheckedAnswer = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _ttsService.initialize();
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(selectedExerciseProvider);
    final controller = ref.watch(listeningControllerProvider);
    final controllerNotifier = ref.read(listeningControllerProvider.notifier);

    if (exercise == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show results if finished
    if (controller.showDictationResults) {
      return _buildResultsScreen(context, exercise, controller, controllerNotifier);
    }

    final segments = controller.dictationSegments;
    final currentSegmentIndex = controller.currentDictationSegment;
    final currentSegment = segments[currentSegmentIndex];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: ModuleColors.listening.withOpacity(0.1),
        foregroundColor: ModuleColors.listening,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '听写练习 (${currentSegmentIndex + 1}/${segments.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ModuleColors.listening,
          ),
        ),
        centerTitle: true,
        actions: [
          // Exit dictation
          TextButton(
            onPressed: () {
              controllerNotifier.exitDictation();
              context.pop();
            },
            child: Text(
              '退出',
              style: TextStyle(
                color: ModuleColors.listening,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(segments.length, currentSegmentIndex),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructions
                  _buildInstructionsCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Play audio button
                  _buildPlayAudioButton(currentSegment),
                  
                  const SizedBox(height: 24),
                  
                  // Input area
                  _buildInputArea(controller, currentSegmentIndex),
                  
                  const SizedBox(height: 24),
                  
                  // Comparison result (if checked)
                  if (_hasCheckedAnswer)
                    _buildComparisonResult(
                      controller.dictationAnswers[currentSegmentIndex] ?? '',
                      currentSegment,
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Navigation buttons
                  _buildNavigationButtons(
                    context,
                    segments.length,
                    currentSegmentIndex,
                    controller,
                    controllerNotifier,
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int totalSegments, int currentIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / totalSegments,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(ModuleColors.listening),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Progress text
          Text(
            '第 ${currentIndex + 1} 段 / 共 $totalSegments 段',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return AnimeCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ModuleColors.listening.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit_note,
              color: ModuleColors.listening,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '听写练习',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '点击播放按钮听音频，然后在下方输入你听到的内容。',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildPlayAudioButton(String text) {
    return Center(
      child: GestureDetector(
        onTap: () => _ttsService.speak(text),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ModuleColors.listening, AppColors.accentOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ModuleColors.listening.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.volume_up,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 200))
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildInputArea(ListeningState controller, int segmentIndex) {
    final existingAnswer = controller.dictationAnswers[segmentIndex];
    if (existingAnswer != null && _textController.text.isEmpty) {
      _textController.text = existingAnswer;
    }

    return AnimeCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.keyboard,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              const Text(
                '输入你听到的内容',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          TextField(
            controller: _textController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '在此输入英文...',
              hintStyle: TextStyle(
                color: AppColors.textHint,
              ),
              filled: true,
              fillColor: AppColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ModuleColors.listening,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              // Reset check state when user types
              if (_hasCheckedAnswer) {
                setState(() {
                  _hasCheckedAnswer = false;
                });
              }
            },
          ),
          
          const SizedBox(height: 12),
          
          // Check button
          AnimeButton(
            text: '检查答案',
            onPressed: () {
              final answer = _textController.text;
              if (answer.isNotEmpty) {
                ref.read(listeningControllerProvider.notifier)
                    .submitDictationAnswer(answer);
                setState(() {
                  _hasCheckedAnswer = true;
                });
              }
            },
            height: 48,
            gradient: LinearGradient(
              colors: [ModuleColors.listening, AppColors.accentOrange],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonResult(String userAnswer, String correctAnswer) {
    // Calculate differences
    final comparison = _compareTexts(userAnswer, correctAnswer);
    
    return AnimeCard(
      padding: const EdgeInsets.all(16),
      showGradientBorder: true,
      borderGradient: LinearGradient(
        colors: comparison.accuracy >= 80
            ? [AppColors.successGreen, AppColors.accentLime]
            : comparison.accuracy >= 60
                ? [AppColors.accentOrange, AppColors.accentYellow]
                : [AppColors.errorRed, AppColors.accentOrange],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                comparison.accuracy >= 80
                    ? Icons.check_circle
                    : comparison.accuracy >= 60
                        ? Icons.warning
                        : Icons.error,
                color: comparison.accuracy >= 80
                    ? AppColors.successGreen
                    : comparison.accuracy >= 60
                        ? AppColors.accentOrange
                        : AppColors.errorRed,
              ),
              const SizedBox(width: 8),
              Text(
                '准确率: ${comparison.accuracy.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: comparison.accuracy >= 80
                      ? AppColors.successGreen
                      : comparison.accuracy >= 60
                          ? AppColors.accentOrange
                          : AppColors.errorRed,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Your answer
          const Text(
            '你的答案:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildHighlightedText(comparison.userWords),
          ),
          
          const SizedBox(height: 12),
          
          // Correct answer
          const Text(
            '正确答案:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
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
            child: Text(
              correctAnswer,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildHighlightedText(List<WordComparison> words) {
    return RichText(
      text: TextSpan(
        children: words.map((word) {
          Color textColor = AppColors.textPrimary;
          if (!word.isCorrect) {
            textColor = AppColors.errorRed;
          } else if (word.isExtra) {
            textColor = AppColors.accentOrange;
          }
          
          return TextSpan(
            text: '${word.word} ',
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              height: 1.6,
              decoration: word.isExtra ? TextDecoration.lineThrough : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    int totalSegments,
    int currentIndex,
    ListeningState controller,
    ListeningController controllerNotifier,
  ) {
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == totalSegments - 1;

    return Row(
      children: [
        // Previous button
        if (!isFirst)
          Expanded(
            child: AnimeOutlinedButton(
              text: '上一段',
              onPressed: () {
                controllerNotifier.previousDictationSegment();
                _textController.clear();
                setState(() {
                  _hasCheckedAnswer = false;
                });
              },
              borderColor: ModuleColors.listening,
              textColor: ModuleColors.listening,
              height: 50,
            ),
          )
        else
          const Expanded(child: SizedBox()),
        
        const SizedBox(width: 12),
        
        // Next/Finish button
        Expanded(
          child: isLast
              ? AnimeButton(
                  text: '完成练习',
                  onPressed: () {
                    // Calculate accuracy for current segment if not done
                    if (!_hasCheckedAnswer && _textController.text.isNotEmpty) {
                      controllerNotifier.submitDictationAnswer(_textController.text);
                    }
                    controllerNotifier.finishDictation();
                  },
                  gradient: LinearGradient(
                    colors: [AppColors.successGreen, AppColors.accentLime],
                  ),
                  height: 50,
                )
              : AnimeButton(
                  text: '下一段',
                  onPressed: () {
                    if (!_hasCheckedAnswer && _textController.text.isNotEmpty) {
                      controllerNotifier.submitDictationAnswer(_textController.text);
                    }
                    controllerNotifier.nextDictationSegment();
                    _textController.clear();
                    setState(() {
                      _hasCheckedAnswer = false;
                    });
                  },
                  gradient: LinearGradient(
                    colors: [ModuleColors.listening, AppColors.accentOrange],
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
    ListeningModel exercise,
    ListeningState controller,
    ListeningController controllerNotifier,
  ) {
    final averageAccuracy = controller.averageDictationAccuracy;
    
    // Determine mascot expression based on accuracy
    final MascotExpression mascotExpression;
    final String mascotMessage;
    
    if (averageAccuracy >= 80) {
      mascotExpression = MascotExpression.celebrating;
      mascotMessage = '太棒了！你的听写能力很强！🎉';
    } else if (averageAccuracy >= 60) {
      mascotExpression = MascotExpression.happy;
      mascotMessage = '做得不错！继续练习会更好！👍';
    } else {
      mascotExpression = MascotExpression.sad;
      mascotMessage = '别灰心，多听多写会有进步的！💪';
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
                  colors: averageAccuracy >= 60
                      ? [AppColors.successGreen, AppColors.accentLime]
                      : [AppColors.errorRed, AppColors.accentOrange],
                ),
                child: Column(
                  children: [
                    Text(
                      '平均准确率',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${averageAccuracy.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: averageAccuracy >= 60 
                            ? AppColors.successGreen 
                            : AppColors.errorRed,
                      ),
                    ),
                    Text(
                      '完成 ${controller.dictationAnswers.length} 段听写',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: AnimeOutlinedButton(
                      text: '重新练习',
                      onPressed: () {
                        controllerNotifier.restartDictation();
                        _textController.clear();
                        setState(() {
                          _hasCheckedAnswer = false;
                        });
                      },
                      borderColor: ModuleColors.listening,
                      textColor: ModuleColors.listening,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimeButton(
                      text: '返回列表',
                      onPressed: () {
                        controllerNotifier.exitDictation();
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

  // ==================== Helper Methods ====================

  ComparisonResult _compareTexts(String userText, String correctText) {
    final userWords = userText.toLowerCase().trim().split(RegExp(r'\s+'));
    final correctWords = correctText.toLowerCase().trim().split(RegExp(r'\s+'));
    
    final List<WordComparison> comparisons = [];
    int correctCount = 0;
    
    // Simple word-by-word comparison
    for (int i = 0; i < userWords.length; i++) {
      if (i < correctWords.length) {
        final isCorrect = userWords[i] == correctWords[i];
        if (isCorrect) correctCount++;
        comparisons.add(WordComparison(
          word: userWords[i],
          isCorrect: isCorrect,
          isExtra: false,
        ));
      } else {
        // Extra words in user answer
        comparisons.add(WordComparison(
          word: userWords[i],
          isCorrect: false,
          isExtra: true,
        ));
      }
    }
    
    final accuracy = correctWords.isEmpty 
        ? 0.0 
        : (correctCount / correctWords.length) * 100;
    
    return ComparisonResult(
      userWords: comparisons,
      accuracy: accuracy,
    );
  }
}

class WordComparison {
  final String word;
  final bool isCorrect;
  final bool isExtra;

  WordComparison({
    required this.word,
    required this.isCorrect,
    required this.isExtra,
  });
}

class ComparisonResult {
  final List<WordComparison> userWords;
  final double accuracy;

  ComparisonResult({
    required this.userWords,
    required this.accuracy,
  });
}
