import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/listening_model.dart';
import 'listening_controller.dart';

/// Listening module main screen
/// 
/// Lists all listening exercises as cards, filterable by difficulty.
/// Shows progress and statistics.
class ListeningScreen extends ConsumerStatefulWidget {
  const ListeningScreen({super.key});

  @override
  ConsumerState<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends ConsumerState<ListeningScreen> {
  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(filteredExercisesProvider);
    final filter = ref.watch(listeningFilterProvider);
    final statisticsAsync = ref.watch(listeningStatisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.moduleListening),
        backgroundColor: ModuleColors.listening.withOpacity(0.1),
        foregroundColor: ModuleColors.listening,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Statistics button
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showStatisticsBottomSheet(statisticsAsync),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter section
          _buildFilterSection(filter),
          
          // Exercises list
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) => _buildExercisesList(exercises),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ListeningFilter filter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Difficulty filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: '全部',
                  isSelected: filter.difficulty == null,
                  onTap: () => ref.read(listeningFilterProvider.notifier).state =
                      filter.copyWith(clearDifficulty: true),
                  color: ModuleColors.listening,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高一',
                  isSelected: filter.difficulty == 1,
                  onTap: () => ref.read(listeningFilterProvider.notifier).state =
                      filter.copyWith(difficulty: 1),
                  color: AppColors.successGreen,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高二',
                  isSelected: filter.difficulty == 2,
                  onTap: () => ref.read(listeningFilterProvider.notifier).state =
                      filter.copyWith(difficulty: 2),
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高三',
                  isSelected: filter.difficulty == 3,
                  onTap: () => ref.read(listeningFilterProvider.notifier).state =
                      filter.copyWith(difficulty: 3),
                  color: AppColors.errorRed,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: '全部类型',
                  isSelected: filter.category == null,
                  onTap: () => ref.read(listeningFilterProvider.notifier).state =
                      filter.copyWith(clearCategory: true),
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(width: 8),
                ...ListeningCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      label: '${category.icon} ${category.label}',
                      isSelected: filter.category == category,
                      onTap: () => ref.read(listeningFilterProvider.notifier).state =
                          filter.copyWith(category: category),
                      color: AppColors.primaryPurple,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildExercisesList(List<ListeningModel> exercises) {
    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MascotWidget(
              expression: MascotExpression.thinking,
              size: 100,
              speechText: '没有找到符合条件的听力练习',
            ),
            const SizedBox(height: 24),
            Text(
              '试试其他筛选条件吧',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _buildExerciseCard(exercise, index);
      },
    );
  }

  Widget _buildExerciseCard(ListeningModel exercise, int index) {
    return AnimeCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => _onExerciseTap(exercise),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with difficulty and category
          Row(
            children: [
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(exercise.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getDifficultyLabel(exercise.difficulty),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getDifficultyColor(exercise.difficulty),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${exercise.category.icon} ${exercise.category.label}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const Spacer(),
              // Accent badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentCyanLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exercise.accent,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            exercise.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Preview text
          Text(
            exercise.transcript.substring(0, exercise.transcript.length > 80 
                ? 80 
                : exercise.transcript.length) + '...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 16),
          
          // Footer with stats
          Row(
            children: [
              _buildStatItem(Icons.timer, _formatDuration(exercise.duration)),
              const SizedBox(width: 16),
              _buildStatItem(Icons.people, '${exercise.speakerCount} 人'),
              const SizedBox(width: 16),
              _buildStatItem(Icons.quiz, '${exercise.questions.length} 题'),
              const Spacer(),
              // Arrow icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ModuleColors.listening.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: ModuleColors.listening,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(Object error) {
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
          AnimeOutlinedButton(
            text: '重试',
            onPressed: () {
              ref.invalidate(allExercisesProvider);
            },
            borderColor: ModuleColors.listening,
            textColor: ModuleColors.listening,
          ),
        ],
      ),
    );
  }

  void _onExerciseTap(ListeningModel exercise) {
    // Select the exercise
    ref.read(listeningControllerProvider.notifier).selectExercise(exercise);
    
    // Navigate to player screen
    context.push('/listening/player/${exercise.id}');
  }

  void _showStatisticsBottomSheet(AsyncValue<Map<String, dynamic>> statisticsAsync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            const Text(
              '听力统计',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Statistics content
            statisticsAsync.when(
              data: (stats) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildStatRow('总练习数', '${stats['totalExercises'] ?? 0}'),
                    _buildStatRow('已完成', '${stats['completedExercises'] ?? 0}'),
                    _buildStatRow('完成率', '${stats['completionPercentage'] ?? 0}%'),
                    _buildStatRow('总听力时间', '${stats['totalListeningTimeMinutes'] ?? 0} 分钟'),
                    _buildStatRow('答题正确率', '${stats['accuracyPercentage'] ?? 0}%'),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('无法加载统计信息'),
            ),
            
            const SizedBox(height: 24),
            
            // Close button
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimeButton(
                text: '关闭',
                onPressed: () => Navigator.pop(context),
                height: 50,
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return AppColors.successGreen;
      case 2:
        return AppColors.accentOrange;
      case 3:
        return AppColors.errorRed;
      default:
        return AppColors.primaryPurple;
    }
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return '高一';
      case 2:
        return '高二';
      case 3:
        return '高三';
      default:
        return '未知';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}分${remainingSeconds > 0 ? '${remainingSeconds}秒' : ''}';
  }
}
