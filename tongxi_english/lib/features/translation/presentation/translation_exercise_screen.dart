import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../data/translation_local_data.dart';
import 'translation_controller.dart';
import 'translation_result_screen.dart';

/// Translation exercise screen
/// 
/// Screen for completing a single translation exercise
class TranslationExerciseScreen extends ConsumerStatefulWidget {
  const TranslationExerciseScreen({super.key});

  @override
  ConsumerState<TranslationExerciseScreen> createState() =>
      _TranslationExerciseScreenState();
}

class _TranslationExerciseScreenState
    extends ConsumerState<TranslationExerciseScreen> {
  late TextEditingController _textController;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translationControllerProvider);
    final controller = ref.read(translationControllerProvider.notifier);
    final exercise = state.exerciseState.currentExercise;

    if (exercise == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Update text controller when state changes
    if (_textController.text != state.exerciseState.userAnswer) {
      _textController.text = state.exerciseState.userAnswer;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          exercise.direction == TranslationDirection.en2cn ? '英译中' : '中译英',
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '练习 ${state.sessionStats.exercisesAttempted + 1}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source text card
                    _buildSourceCard(exercise),
                    const SizedBox(height: 24),

                    // Hint section
                    if (exercise.hints.isNotEmpty) ...[
                      _buildHintSection(exercise),
                      const SizedBox(height: 24),
                    ],

                    // Input section
                    _buildInputSection(exercise, state, controller),
                  ],
                ),
              ),
            ),

            // Bottom action bar
            _buildBottomBar(exercise, state, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceCard(TranslationExercise exercise) {
    return AnimeCard(
      showGradientBorder: true,
      borderGradient: exercise.direction == TranslationDirection.en2cn
          ? AppColors.coolGradient
          : AppColors.primaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: exercise.direction == TranslationDirection.en2cn
                      ? AppColors.infoBlue.withOpacity(0.1)
                      : AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      exercise.direction == TranslationDirection.en2cn
                          ? Icons.translate
                          : Icons.g_translate,
                      size: 14,
                      color: exercise.direction == TranslationDirection.en2cn
                          ? AppColors.infoBlue
                          : AppColors.primaryPurple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      exercise.direction == TranslationDirection.en2cn
                          ? '请将以下英文翻译成中文'
                          : '请将以下中文翻译成英文',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: exercise.direction == TranslationDirection.en2cn
                            ? AppColors.infoBlue
                            : AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _buildDifficultyBadge(exercise.difficulty),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            exercise.sourceText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          if (exercise.context != null && exercise.context!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              exercise.context!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildDifficultyBadge(TranslationDifficulty difficulty) {
    final (label, color) = switch (difficulty) {
      TranslationDifficulty.basic => ('基础', AppColors.accentLime),
      TranslationDifficulty.intermediate => ('中级', AppColors.accentOrange),
      TranslationDifficulty.advanced => ('高级', AppColors.secondaryPink),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildHintSection(TranslationExercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 18,
              color: AppColors.accentYellow,
            ),
            const SizedBox(width: 8),
            const Text(
              '提示',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _showHint = !_showHint;
                });
              },
              icon: Icon(
                _showHint ? Icons.visibility_off : Icons.visibility,
                size: 16,
              ),
              label: Text(_showHint ? '隐藏' : '显示'),
            ),
          ],
        ),
        if (_showHint) ...[
          const SizedBox(height: 12),
          AnimeCard(
            backgroundColor: AppColors.accentYellowLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: exercise.hints.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < exercise.hints.length - 1 ? 8 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn().slideY(begin: -0.1, end: 0),
        ],
      ],
    );
  }

  Widget _buildInputSection(
    TranslationExercise exercise,
    TranslationState state,
    TranslationController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '你的翻译',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _textController,
            onChanged: controller.updateUserAnswer,
            maxLines: 6,
            minLines: 4,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: exercise.direction == TranslationDirection.en2cn
                  ? '请输入中文翻译...'
                  : 'Please enter English translation...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
        if (exercise.keyVocabulary.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            '重点词汇',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exercise.keyVocabulary.map((vocab) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vocab.word,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    Text(
                      vocab.translation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar(
    TranslationExercise exercise,
    TranslationState state,
    TranslationController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Mascot hint
            const MascotWidget(
              expression: MascotExpression.thinking,
              size: 50,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '认真思考后再提交哦！',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '参考译文包含多个可接受答案',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: AnimeButton(
                text: '提交',
                onPressed: state.exerciseState.userAnswer.trim().isEmpty
                    ? null
                    : () async {
                        await controller.submitAnswer();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TranslationResultScreen(),
                            ),
                          );
                        }
                      },
                isDisabled: state.exerciseState.userAnswer.trim().isEmpty,
                isLoading: state.exerciseState.isLoading,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
