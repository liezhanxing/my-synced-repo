import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../models/word_model.dart';
import '../domain/vocabulary_models.dart';
import 'flashcard_screen.dart';
import 'review_screen.dart';
import 'vocabulary_controller.dart';
import 'vocabulary_quiz_screen.dart';
import 'word_list_screen.dart';

class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vocabularyControllerProvider);
    final controller = ref.read(vocabularyControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.moduleVocabulary),
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
          : state.error != null
              ? _buildErrorState(state.error!, ref)
              : SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: _VocabularyHero(
                          tab: state.tab,
                          totalWords: state.allWords.length,
                          dueCount: state.dueWords.length,
                          quizScore: state.quizScore,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: VocabularyTab.values
                              .map(
                                (tab) => SizedBox(
                                  width: (MediaQuery.of(context).size.width - 48) / 2,
                                  child: AnimeButton(
                                    text: tab.label,
                                    height: 42,
                                    gradient: state.tab == tab
                                        ? AppColors.primaryGradient
                                        : const LinearGradient(colors: [Colors.white, Colors.white]),
                                    textColor: state.tab == tab ? Colors.white : AppColors.textPrimary,
                                    onPressed: () => controller.switchTab(tab),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      if (state.tab == VocabularyTab.list || state.tab == VocabularyTab.flashcards)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.unitOptions
                                  .map(
                                    (unit) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(unit),
                                        selected: state.selectedUnit == unit,
                                        onSelected: (_) => controller.selectUnit(unit),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _buildTab(context, ref, state, controller),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    WidgetRef ref,
    VocabularyState state,
    VocabularyController controller,
  ) {
    switch (state.tab) {
      case VocabularyTab.list:
        final Map<String, List<WordModel>> grouped;
        if (state.selectedUnit == '全部') {
          grouped = Map<String, List<WordModel>>.from(state.groupedWords);
          grouped.remove('全部');
        } else {
          grouped = {state.selectedUnit: state.filteredWords};
        }
        return WordListScreen(
          groupedWords: grouped,
          onPlay: _playWord,
        );
      case VocabularyTab.flashcards:
        return FlashcardScreen(
          word: state.currentFlashcard,
          index: state.flashcardIndex,
          total: state.filteredWords.length,
          isFlipped: state.flashcardFlipped,
          onFlip: controller.flipFlashcard,
          onKnow: () async {
            await controller.rateFlashcard(true);
            await AudioService().playCorrectSound();
          },
          onDontKnow: () async {
            await controller.rateFlashcard(false);
            await AudioService().playWrongSound();
          },
          onPlay: _playWord,
        );
      case VocabularyTab.quiz:
        return VocabularyQuizScreen(
          question: state.currentQuestion,
          index: state.quizIndex,
          total: state.quizQuestions.length,
          score: state.quizScore,
          spellingAnswer: state.spellingAnswer,
          completed: state.quizCompleted,
          onSelectOption: (answer) async {
            final result = await controller.submitQuizAnswer(answer);
            if (result) {
              await AudioService().playCorrectSound();
            } else {
              await AudioService().playWrongSound();
            }
          },
          onSpellingChanged: controller.updateSpellingAnswer,
          onSubmitSpelling: () async {
            final result = await controller.submitQuizAnswer(state.spellingAnswer);
            if (result) {
              await AudioService().playCorrectSound();
            } else {
              await AudioService().playWrongSound();
            }
          },
          onRestart: controller.restartQuiz,
        );
      case VocabularyTab.review:
        return ReviewScreen(
          dueWords: state.dueWords,
          currentWord: state.currentReviewWord,
          currentIndex: state.reviewIndex,
          isFlipped: state.reviewFlipped,
          onFlip: controller.flipReviewCard,
          onKnow: () async {
            await controller.rateReviewWord(true);
            await AudioService().playCorrectSound();
          },
          onDontKnow: () async {
            await controller.rateReviewWord(false);
            await AudioService().playWrongSound();
          },
          onPlay: _playWord,
        );
    }
  }

  Future<void> _playWord(WordModel word) async {
    if (word.audioUrl.isNotEmpty) {
      await AudioService().playFromUrl(word.audioUrl);
      return;
    }
    final tts = TtsService();
    await tts.setLanguage('en-US');
    await tts.speakWord(word.word);
  }

  Widget _buildErrorState(String error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MascotWidget(
            expression: MascotExpression.sad,
            size: 100,
            speechText: '加载出错了，请重试',
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(color: AppColors.errorRed),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(vocabularyControllerProvider.notifier).load(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}

class _VocabularyHero extends StatelessWidget {
  const _VocabularyHero({
    required this.tab,
    required this.totalWords,
    required this.dueCount,
    required this.quizScore,
  });

  final VocabularyTab tab;
  final int totalWords;
  final int dueCount;
  final int quizScore;

  @override
  Widget build(BuildContext context) {
    final speech = switch (tab) {
      VocabularyTab.list => '先看词义和例句，建立语境记忆！',
      VocabularyTab.flashcards => '左右滑动前，先在脑中回忆一遍！',
      VocabularyTab.quiz => '选择题要快，拼写题要准！',
      VocabularyTab.review => '今天到期的单词，别让它们溜走啦！',
    };

    return AnimeCard(
      showGradientBorder: true,
      borderGradient: AppColors.coolGradient,
      child: Column(
        children: [
          Row(
            children: [
              MascotWidget(
                expression: tab == VocabularyTab.review
                    ? MascotExpression.thinking
                    : MascotExpression.happy,
                size: 88,
                speechText: speech,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tab.label,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill('词库 $totalWords', AppColors.primaryPurpleLight, AppColors.primaryPurpleDark),
                        _pill('待复习 $dueCount', AppColors.accentYellowLight, AppColors.accentOrange),
                        _pill('测验得分 $quizScore', AppColors.accentCyanLight, AppColors.accentCyan),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedProgressBar(
            progress: totalWords == 0 ? 0 : (dueCount == 0 ? 1 : (1 - (dueCount / totalWords)).clamp(0.0, 1.0)),
            showLabel: true,
            labelText: dueCount == 0 ? '今天复习清空啦' : '仍有 $dueCount 个单词待复习',
            gradient: AppColors.sunsetGradient,
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
