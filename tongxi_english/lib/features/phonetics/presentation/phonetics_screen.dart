import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../models/phonetic_model.dart';
import '../domain/phonetics_practice_models.dart';
import 'ipa_chart_screen.dart';
import 'phonetic_detail_card.dart';
import 'phonetics_controller.dart';
import 'phonetics_practice_screen.dart';

class PhoneticsScreen extends ConsumerWidget {
  const PhoneticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phoneticsControllerProvider);
    final controller = ref.read(phoneticsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.modulePhonetics),
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: _HeroPanel(
                      section: state.section,
                      score: state.score,
                      progress: state.progress,
                      expression: state.section == PhoneticsSection.practice
                          ? (state.lastAnswerCorrect
                              ? MascotExpression.excited
                              : MascotExpression.thinking)
                          : MascotExpression.happy,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: PhoneticsSection.values
                          .map(
                            (section) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AnimeButton(
                                  text: section.label,
                                  height: 42,
                                  gradient: state.section == section
                                      ? AppColors.primaryGradient
                                      : const LinearGradient(
                                          colors: [Colors.white, Colors.white],
                                        ),
                                  textColor: state.section == section
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  onPressed: () => controller.switchSection(section),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildSection(context, ref, state, controller),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    WidgetRef ref,
    PhoneticsState state,
    PhoneticsController controller,
  ) {
    switch (state.section) {
      case PhoneticsSection.vowels:
        return IpaChartScreen(
          title: '20个核心元音音标',
          groups: state.vowelGroups,
          onTapItem: (item) => _showDetail(context, ref, item),
        );
      case PhoneticsSection.consonants:
        return IpaChartScreen(
          title: '24个常见辅音音标',
          groups: state.consonantGroups,
          onTapItem: (item) => _showDetail(context, ref, item),
        );
      case PhoneticsSection.practice:
        final current = state.currentExercise;
        final options = current == null
            ? <PhoneticModel>[]
            : current.optionIds
                .map((id) => [...state.vowels, ...state.consonants]
                    .firstWhere((item) => item.id == id))
                .toList();
        return PhoneticsPracticeScreen(
          exercise: current,
          options: options,
          selectedOptionId: state.selectedOptionId,
          progress: state.progress,
          score: state.score,
          answeredCount: state.answeredCount,
          isCompleted: state.practiceCompleted,
          lastAnswerCorrect: state.lastAnswerCorrect,
          answerSubmitted: state.answerSubmitted,
          onChoose: controller.chooseOption,
          onSubmit: () async {
            final result = controller.submitCurrentAnswer();
            if (result) {
              await AudioService().playCorrectSound();
            } else {
              await AudioService().playWrongSound();
            }
          },
          onNext: controller.nextExercise,
          onRestart: controller.restartPractice,
          onPlayAudio: () => _playExerciseAudio(current),
        );
    }
  }

  Future<void> _playExerciseAudio(PhoneticsExercise? exercise) async {
    if (exercise == null) return;
    final tts = TtsService();
    await tts.setLanguage('en-US');
    await tts.speakWord(exercise.audioText ?? exercise.displayWord ?? '');
  }

  Future<void> _showDetail(
    BuildContext context,
    WidgetRef ref,
    PhoneticModel item,
  ) async {
    final repo = ref.read(phoneticsRepositoryProvider);
    final similar = await repo.getSimilarSounds(item.symbol);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => PhoneticDetailCard(
        item: item,
        similarSounds: similar,
        onPlay: () => _playPhonetic(item),
      ),
    );
  }

  Future<void> _playPhonetic(PhoneticModel item) async {
    if (item.audioUrl.isNotEmpty) {
      await AudioService().playFromUrl(item.audioUrl);
      return;
    }
    final tts = TtsService();
    await tts.setLanguage('en-US');
    await tts.speakWord(item.examples.first.word);
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.section,
    required this.score,
    required this.progress,
    required this.expression,
  });

  final PhoneticsSection section;
  final int score;
  final double progress;
  final MascotExpression expression;

  @override
  Widget build(BuildContext context) {
    final speech = switch (section) {
      PhoneticsSection.vowels => '先把元音口型练稳，单词会更好听！',
      PhoneticsSection.consonants => '爆破音和摩擦音，要分得清清楚楚！',
      PhoneticsSection.practice => '挑战开始！听音、辨音、拿高分！',
    };

    return AnimeCard(
      showGradientBorder: true,
      borderGradient: AppColors.sunsetGradient,
      child: Column(
        children: [
          Row(
            children: [
              MascotWidget(
                expression: expression,
                size: 88,
                speechText: speech,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.label,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      section == PhoneticsSection.practice
                          ? '当前得分：$score'
                          : '点击卡片即可试听并查看发音细节',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedProgressBar(
            progress: progress,
            showLabel: true,
            gradient: AppColors.coolGradient,
            labelText: section == PhoneticsSection.practice
                ? '练习进度 ${(progress * 100).round()}%'
                : '模块探索中',
          ),
        ],
      ),
    );
  }
}
