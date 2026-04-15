import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../data/translation_local_data.dart';
import 'translation_controller.dart';
import 'translation_exercise_screen.dart';

/// Translation module screen
/// 
/// Main screen with exercise list, filters, and daily challenge
class TranslationScreen extends ConsumerWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translationControllerProvider);
    final controller = ref.read(translationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.moduleTranslation,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '中英互译练习',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.translate,
                            color: AppColors.infoBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${state.exercises.length}题',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.infoBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daily Challenge Card
            if (state.dailyChallenge != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  child: _buildDailyChallengeCard(
                    context,
                    state.dailyChallenge!,
                    controller,
                  ),
                ),
              ),

            // Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                  top: AppSizes.paddingXl,
                  bottom: AppSizes.paddingMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '翻译方向',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDirectionFilter(state.filter.direction, controller),
                    const SizedBox(height: 20),
                    const Text(
                      '难度等级',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDifficultyFilter(state.filter.difficulty, controller),
                  ],
                ),
              ),
            ),

            // Exercise list header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                  top: AppSizes.paddingLg,
                  bottom: AppSizes.paddingMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '练习列表 (${state.filteredExercises.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (state.filter.direction != null ||
                        state.filter.difficulty != null)
                      TextButton.icon(
                        onPressed: controller.clearFilters,
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('清除筛选'),
                      ),
                  ],
                ),
              ),
            ),

            // Exercise list
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final exercise = state.filteredExercises[index];
                    return _buildExerciseCard(
                      context,
                      exercise,
                      controller,
                    );
                  },
                  childCount: state.filteredExercises.length,
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

  Widget _buildDailyChallengeCard(
    BuildContext context,
    TranslationExercise challenge,
    TranslationController controller,
  ) {
    return AnimeCard(
      showGradientBorder: true,
      borderGradient: AppColors.warmGradient,
      onTap: () {
        controller.startExercise(challenge);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TranslationExerciseScreen(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.warmGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '每日挑战',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _buildDifficultyChip(challenge.difficulty),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const MascotWidget(
                expression: MascotExpression.excited,
                size: 60,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.direction == TranslationDirection.en2cn
                          ? '英译中挑战'
                          : '中译英挑战',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.sourceText.length > 50
                          ? '${challenge.sourceText.substring(0, 50)}...'
                          : challenge.sourceText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimeButton(
            text: '开始挑战',
            onPressed: () {
              controller.startExercise(challenge);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TranslationExerciseScreen(),
                ),
              );
            },
            gradient: AppColors.warmGradient,
            height: 44,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildDirectionFilter(
    TranslationDirection? selected,
    TranslationController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterChip(
            label: '全部',
            isSelected: selected == null,
            onTap: () => controller.setDirectionFilter(null),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterChip(
            label: '英译中',
            isSelected: selected == TranslationDirection.en2cn,
            onTap: () => controller.setDirectionFilter(TranslationDirection.en2cn),
            icon: Icons.arrow_forward,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterChip(
            label: '中译英',
            isSelected: selected == TranslationDirection.cn2en,
            onTap: () => controller.setDirectionFilter(TranslationDirection.cn2en),
            icon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyFilter(
    TranslationDifficulty? selected,
    TranslationController controller,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip(
          label: '全部',
          isSelected: selected == null,
          onTap: () => controller.setDifficultyFilter(null),
        ),
        _buildFilterChip(
          label: '基础 (高一)',
          isSelected: selected == TranslationDifficulty.basic,
          onTap: () => controller.setDifficultyFilter(TranslationDifficulty.basic),
          color: AppColors.accentLime,
        ),
        _buildFilterChip(
          label: '中级 (高二)',
          isSelected: selected == TranslationDifficulty.intermediate,
          onTap: () => controller.setDifficultyFilter(TranslationDifficulty.intermediate),
          color: AppColors.accentOrange,
        ),
        _buildFilterChip(
          label: '高级 (高三)',
          isSelected: selected == TranslationDifficulty.advanced,
          onTap: () => controller.setDifficultyFilter(TranslationDifficulty.advanced),
          color: AppColors.secondaryPink,
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    Color? color,
  }) {
    return Material(
      color: isSelected
          ? (color ?? AppColors.primaryPurple)
          : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    TranslationExercise exercise,
    TranslationController controller,
  ) {
    return AnimeCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        controller.startExercise(exercise);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TranslationExerciseScreen(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: exercise.direction == TranslationDirection.en2cn
                      ? AppColors.infoBlue.withOpacity(0.1)
                      : AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exercise.direction == TranslationDirection.en2cn
                      ? '英译中'
                      : '中译英',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: exercise.direction == TranslationDirection.en2cn
                        ? AppColors.infoBlue
                        : AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildDifficultyChip(exercise.difficulty),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exercise.sourceText.length > 80
                ? '${exercise.sourceText.substring(0, 80)}...'
                : exercise.sourceText,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          if (exercise.keyPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: exercise.keyPoints.take(2).map((point) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    point,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.accentOrange,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(TranslationDifficulty difficulty) {
    final label = switch (difficulty) {
      TranslationDifficulty.basic => '基础',
      TranslationDifficulty.intermediate => '中级',
      TranslationDifficulty.advanced => '高级',
    };
    
    final color = switch (difficulty) {
      TranslationDifficulty.basic => AppColors.accentLime,
      TranslationDifficulty.intermediate => AppColors.accentOrange,
      TranslationDifficulty.advanced => AppColors.secondaryPink,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
