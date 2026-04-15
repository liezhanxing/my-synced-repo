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
import '../../../models/reading_model.dart';
import 'reading_controller.dart';

/// Reading module main screen
/// 
/// Lists all reading passages as cards, filterable by difficulty
/// and category. Shows progress and statistics.
class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  @override
  Widget build(BuildContext context) {
    final passagesAsync = ref.watch(filteredPassagesProvider);
    final filter = ref.watch(readingFilterProvider);
    final statisticsAsync = ref.watch(readingStatisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.moduleReading),
        backgroundColor: ModuleColors.reading.withOpacity(0.1),
        foregroundColor: ModuleColors.reading,
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
          
          // Passages list
          Expanded(
            child: passagesAsync.when(
              data: (passages) => _buildPassagesList(passages),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ReadingFilter filter) {
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
                  onTap: () => ref.read(readingFilterProvider.notifier).state =
                      filter.copyWith(clearDifficulty: true),
                  color: ModuleColors.reading,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高一',
                  isSelected: filter.difficulty == 1,
                  onTap: () => ref.read(readingFilterProvider.notifier).state =
                      filter.copyWith(difficulty: 1),
                  color: AppColors.successGreen,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高二',
                  isSelected: filter.difficulty == 2,
                  onTap: () => ref.read(readingFilterProvider.notifier).state =
                      filter.copyWith(difficulty: 2),
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '高三',
                  isSelected: filter.difficulty == 3,
                  onTap: () => ref.read(readingFilterProvider.notifier).state =
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
                  onTap: () => ref.read(readingFilterProvider.notifier).state =
                      filter.copyWith(clearCategory: true),
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(width: 8),
                ...ReadingCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      label: '${category.icon} ${category.label}',
                      isSelected: filter.category == category,
                      onTap: () => ref.read(readingFilterProvider.notifier).state =
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

  Widget _buildPassagesList(List<ReadingModel> passages) {
    if (passages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MascotWidget(
              expression: MascotExpression.thinking,
              size: 100,
              speechText: '没有找到符合条件的文章',
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
      itemCount: passages.length,
      itemBuilder: (context, index) {
        final passage = passages[index];
        return _buildPassageCard(passage, index);
      },
    );
  }

  Widget _buildPassageCard(ReadingModel passage, int index) {
    return AnimeCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => _onPassageTap(passage),
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
                  color: _getDifficultyColor(passage.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getDifficultyLabel(passage.difficulty),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getDifficultyColor(passage.difficulty),
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
                  '${passage.category.icon} ${passage.category.label}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            passage.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Preview text
          Text(
            passage.content.substring(0, passage.content.length > 100 
                ? 100 
                : passage.content.length) + '...',
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
              _buildStatItem(Icons.menu_book, '${passage.wordCount} 词'),
              const SizedBox(width: 16),
              _buildStatItem(Icons.timer, '${passage.estimatedTime} 分钟'),
              const SizedBox(width: 16),
              _buildStatItem(Icons.quiz, '${passage.questions.length} 题'),
              const Spacer(),
              // Arrow icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ModuleColors.reading.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: ModuleColors.reading,
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
              ref.invalidate(allPassagesProvider);
            },
            borderColor: ModuleColors.reading,
            textColor: ModuleColors.reading,
          ),
        ],
      ),
    );
  }

  void _onPassageTap(ReadingModel passage) {
    // Select the passage
    ref.read(readingControllerProvider.notifier).selectPassage(passage);
    
    // Navigate to passage screen
    context.push('/reading/passage/${passage.id}');
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
              '阅读统计',
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
                    _buildStatRow('总文章数', '${stats['totalPassages'] ?? 0}'),
                    _buildStatRow('已完成', '${stats['completedPassages'] ?? 0}'),
                    _buildStatRow('完成率', '${stats['completionPercentage'] ?? 0}%'),
                    _buildStatRow('总阅读时间', '${stats['totalTimeSpentMinutes'] ?? 0} 分钟'),
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
}
