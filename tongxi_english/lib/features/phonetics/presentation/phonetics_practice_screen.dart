import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../models/phonetic_model.dart';
import '../domain/phonetics_practice_models.dart';

class PhoneticsPracticeScreen extends StatelessWidget {
  const PhoneticsPracticeScreen({
    super.key,
    required this.exercise,
    required this.options,
    required this.selectedOptionId,
    required this.progress,
    required this.score,
    required this.answeredCount,
    required this.isCompleted,
    required this.lastAnswerCorrect,
    required this.answerSubmitted,
    required this.onChoose,
    required this.onSubmit,
    required this.onNext,
    required this.onRestart,
    required this.onPlayAudio,
  });

  final PhoneticsExercise? exercise;
  final List<PhoneticModel> options;
  final String? selectedOptionId;
  final double progress;
  final int score;
  final int answeredCount;
  final bool isCompleted;
  final bool lastAnswerCorrect;
  final bool answerSubmitted;
  final void Function(String optionId) onChoose;
  final VoidCallback onSubmit;
  final VoidCallback onNext;
  final VoidCallback onRestart;
  final Future<void> Function() onPlayAudio;

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isCompleted) {
      final accuracy = answeredCount == 0 ? 0 : score / answeredCount;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimeCard(
            showGradientBorder: true,
            borderGradient: accuracy >= 0.8
                ? AppColors.successGradient
                : AppColors.sunsetGradient,
            child: Column(
              children: [
                MascotWidget(
                  expression: accuracy >= 0.8
                      ? MascotExpression.celebrating
                      : MascotExpression.excited,
                  size: 108,
                  speechText: accuracy >= 0.8 ? '太棒啦！音标耳朵越来越灵啦！' : '继续加油，再刷一轮就更稳啦！',
                ),
                const SizedBox(height: 12),
                const Text(
                  '本轮练习完成',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _resultChip('得分', '$score / $answeredCount', AppColors.primaryPurpleLight, AppColors.primaryPurpleDark),
                    _resultChip('正确率', '${(accuracy * 100).round()}%', AppColors.accentLimeLight, AppColors.successGreen),
                    _resultChip('建议', accuracy >= 0.8 ? '挑战辅音混淆音' : '再练常见元音', AppColors.accentYellowLight, AppColors.accentOrange),
                  ],
                ),
                const SizedBox(height: 18),
                AnimeButton(
                  text: '再练一轮',
                  icon: Icons.refresh_rounded,
                  onPressed: onRestart,
                ),
              ],
            ),
          ).animate().fadeIn().scale(),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        AnimeCard(
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '发音闯关',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyanLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '得分 $score',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedProgressBar(
                progress: progress,
                showLabel: true,
                labelText: '已完成 ${(progress * 100).round()}%',
                gradient: AppColors.sunsetGradient,
              ),
              const SizedBox(height: 14),
              MascotWidget(
                expression: answerSubmitted
                    ? (lastAnswerCorrect ? MascotExpression.excited : MascotExpression.thinking)
                    : MascotExpression.happy,
                size: 86,
                speechText: answerSubmitted
                    ? (lastAnswerCorrect ? '答对啦，准备挑战下一题！' : '先记住这组音，再继续前进。')
                    : '听一听，选最像的音标！',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimeCard(
          showGradientBorder: true,
          borderGradient: AppColors.primaryGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise!.prompt,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              if (exercise!.type == PhoneticsExerciseType.listenAndChoose) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exercise!.audioText ?? '',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    AnimeButton(
                      text: '听音',
                      icon: Icons.volume_up_rounded,
                      height: 42,
                      onPressed: () => onPlayAudio(),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  exercise!.displayWord ?? '',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondaryPink,
                  ),
                ),
                if (exercise!.hint != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '提示：${exercise!.hint}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionTile(
              option: option,
              isSelected: selectedOptionId == option.id,
              onTap: answerSubmitted ? null : () => onChoose(option.id),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AnimeButton(
                text: '提交答案',
                icon: Icons.check_circle_outline_rounded,
                onPressed: selectedOptionId == null || answerSubmitted ? null : onSubmit,
                isDisabled: selectedOptionId == null || answerSubmitted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimeButton(
                text: '下一题',
                icon: Icons.navigate_next_rounded,
                gradient: AppColors.warmGradient,
                onPressed: answerSubmitted || isCompleted ? onNext : null,
                isDisabled: !answerSubmitted && !isCompleted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultChip(String title, String value, Color bg, Color textColor) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final PhoneticModel option;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurpleLight : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.divider,
            width: isSelected ? 2.4 : 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : AppColors.coolGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    option.symbol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.examples.first.word,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${option.examples.first.phoneticSpelling} · ${option.examples.first.meaning}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: isSelected ? AppColors.primaryPurple : AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
