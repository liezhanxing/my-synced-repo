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
import 'translation_exercise_screen.dart';

/// Translation result screen
/// 
/// Shows user's answer, model answer, score, and feedback
class TranslationResultScreen extends ConsumerWidget {
  const TranslationResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translationControllerProvider);
    final controller = ref.read(translationControllerProvider.notifier);
    final exercise = state.exerciseState.currentExercise;
    final score = state.exerciseState.score ?? 0;

    if (exercise == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final feedback = controller.getFeedbackMessage(score);
    final mascotExpression = _getMascotExpression(score);
    final scoreColor = _getScoreColor(score);
    final scoreLevel = controller.getScoreLevel(score);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Score header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(AppSizes.paddingXl),
                decoration: BoxDecoration(
                  gradient: _getScoreGradient(score),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // Score circle
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              score.toInt().toString(),
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                              ),
                            ),
                            Text(
                              '分',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      feedback,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getScoreLabel(score),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mascot reaction
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: MascotWidget(
                    expression: mascotExpression,
                    size: 100,
                    speechText: _getMascotMessage(score),
                  ),
                ),
              ),
            ),

            // Answers comparison
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User's answer
                    _buildAnswerCard(
                      title: '你的翻译',
                      answer: state.exerciseState.userAnswer,
                      icon: Icons.person_outline,
                      color: scoreColor,
                    ),
                    const SizedBox(height: 16),

                    // Model answer
                    _buildAnswerCard(
                      title: '参考译文',
                      answer: exercise.targetText,
                      icon: Icons.check_circle_outline,
                      color: AppColors.successGreen,
                      alternatives: exercise.alternativeAnswers,
                    ),
                  ],
                ),
              ),
            ),

            // Key points
            if (exercise.keyPoints.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  child: _buildKeyPointsCard(exercise.keyPoints),
                ),
              ),

            // Session stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: _buildSessionStatsCard(state),
              ),
            ),

            // Action buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLg,
                ),
                child: Column(
                  children: [
                    AnimeButton(
                      text: '下一题',
                      onPressed: () {
                        controller.goToNextExercise();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                const TranslationExerciseScreen(),
                          ),
                        );
                      },
                      icon: Icons.arrow_forward,
                    ),
                    const SizedBox(height: 12),
                    if (score < 70)
                      AnimeOutlinedButton(
                        text: '再试一次',
                        onPressed: () {
                          controller.tryAgain();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TranslationExerciseScreen(),
                            ),
                          );
                        },
                        icon: Icons.refresh,
                      ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('返回首页'),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.paddingXl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard({
    required String title,
    required String answer,
    required IconData icon,
    required Color color,
    List<String> alternatives = const [],
  }) {
    return AnimeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          if (alternatives.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              '其他可接受答案：',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            ...alternatives.map((alt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.successGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alt,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    ).animate().fadeIn().slideX(
          begin: title == '你的翻译' ? -0.1 : 0.1,
          end: 0,
          delay: const Duration(milliseconds: 200),
        );
  }

  Widget _buildKeyPointsCard(List<String> keyPoints) {
    return AnimeCard(
      backgroundColor: AppColors.accentYellowLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 18,
                color: AppColors.accentOrange,
              ),
              const SizedBox(width: 8),
              const Text(
                '本题考点',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...keyPoints.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < keyPoints.length - 1 ? 8 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.accentYellow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
          }),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 400));
  }

  Widget _buildSessionStatsCard(TranslationState state) {
    final stats = state.sessionStats;

    return AnimeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '本次练习统计',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  value: '${stats.exercisesAttempted}',
                  label: '已完成',
                  icon: Icons.check_circle,
                  color: AppColors.primaryPurple,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '${stats.exercisesCompleted}',
                  label: '达标',
                  icon: Icons.star,
                  color: AppColors.accentYellow,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  value: stats.averageScore.toInt().toString(),
                  label: '平均分',
                  icon: Icons.trending_up,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 500));
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  MascotExpression _getMascotExpression(double score) {
    if (score >= 90) return MascotExpression.celebrating;
    if (score >= 70) return MascotExpression.happy;
    if (score >= 50) return MascotExpression.thinking;
    return MascotExpression.sad;
  }

  String _getMascotMessage(double score) {
    if (score >= 90) return '太厉害了！满分！';
    if (score >= 80) return '很棒！继续保持！';
    if (score >= 70) return '不错哦，及格了！';
    if (score >= 50) return '还可以更好！';
    return '别灰心，再试一次！';
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.successGreen;
    if (score >= 70) return AppColors.infoBlue;
    if (score >= 50) return AppColors.accentOrange;
    return AppColors.errorRed;
  }

  LinearGradient _getScoreGradient(double score) {
    if (score >= 90) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accentLime, AppColors.successGreen],
      );
    }
    if (score >= 70) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accentCyan, AppColors.infoBlue],
      );
    }
    if (score >= 50) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.accentYellow, AppColors.accentOrange],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.secondaryPink, AppColors.errorRed],
    );
  }

  String _getScoreLabel(double score) {
    if (score >= 90) return '优秀';
    if (score >= 70) return '良好';
    if (score >= 50) return '及格';
    return '需努力';
  }
}
