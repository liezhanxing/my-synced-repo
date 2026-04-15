import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import 'profile_controller.dart';

/// Progress screen
/// 
/// Detailed progress dashboard with charts and statistics
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('学习进度'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Overall progress section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingLg),
                      child: _buildOverallProgressCard(state),
                    ),
                  ),

                  // Weekly study chart
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingLg,
                      ),
                      child: _buildWeeklyStudyCard(state),
                    ),
                  ),

                  // Module progress section
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.paddingLg,
                        right: AppSizes.paddingLg,
                        top: AppSizes.paddingXl,
                        bottom: AppSizes.paddingMd,
                      ),
                      child: Text(
                        '各模块进度',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  // Module progress list
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final module = state.moduleProgress[index];
                          return _buildModuleProgressItem(module);
                        },
                        childCount: state.moduleProgress.length,
                      ),
                    ),
                  ),

                  // Recent activity section
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.paddingLg,
                        right: AppSizes.paddingLg,
                        top: AppSizes.paddingXl,
                        bottom: AppSizes.paddingMd,
                      ),
                      child: Text(
                        '最近学习活动',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  // Recent activity list
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final activity = state.recentActivities[index];
                          return _buildActivityItem(activity);
                        },
                        childCount: state.recentActivities.take(10).length,
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

  Widget _buildOverallProgressCard(ProfileState state) {
    final progress = state.overallProgress / 100;

    return AnimeCard(
      showGradientBorder: true,
      borderGradient: AppColors.primaryGradient,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '总体进度',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '所有模块的平均完成度',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryPurple,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${state.overallProgress.toInt()}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressStat(
                value: '${state.totalWordsLearned}',
                label: '已学单词',
              ),
              _buildProgressStat(
                value: '${state.totalStudyMinutes ~/ 60}h',
                label: '学习时长',
              ),
              _buildProgressStat(
                value: '${state.moduleProgress.fold<int>(0, (sum, m) => sum + m.itemsCompleted)}',
                label: '完成项目',
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildProgressStat({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStudyCard(ProfileState state) {
    final days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final today = DateTime.now().weekday - 1;
    
    // Reorder days so today is last
    final orderedDays = [
      ...days.sublist(today + 1),
      ...days.sublist(0, today + 1),
    ];

    final maxMinutes = state.weeklyStudyMinutes.reduce((a, b) => a > b ? a : b);
    final barGroups = state.weeklyStudyMinutes.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            gradient: AppColors.primaryGradient,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),
            width: 20,
          ),
        ],
      );
    }).toList();

    return AnimeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '本周学习时长',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '过去7天的学习分钟数',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
                  color: AppColors.accentLime.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: AppColors.accentOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${state.weeklyStudyMinutes.reduce((a, b) => a + b)}分钟',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxMinutes > 0 ? maxMinutes * 1.2 : 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppColors.textPrimary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}分钟',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= orderedDays.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            orderedDays[index],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200));
  }

  Widget _buildModuleProgressItem(ModuleProgress module) {
    return AnimeCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: module.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconData(module.iconName),
              color: module.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      module.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${module.completionPercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: module.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: module.completionPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(module.color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${module.itemsCompleted}/${module.totalItems} 完成',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(StudyActivity activity) {
    final timeAgo = _getTimeAgo(activity.timestamp);
    final iconColor = _getActivityColor(activity.contentType);

    return AnimeCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getActivityIcon(activity.contentType),
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${activity.xpEarned} XP',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentYellow,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return '${timestamp.month}/${timestamp.day}';
  }

  IconData _getIconData(String name) {
    return switch (name) {
      'record_voice_over' => Icons.record_voice_over,
      'menu_book' => Icons.menu_book,
      'chat_bubble' => Icons.chat_bubble,
      'psychology' => Icons.psychology,
      'article' => Icons.article,
      'headphones' => Icons.headphones,
      'translate' => Icons.translate,
      _ => Icons.school,
    };
  }

  IconData _getActivityIcon(ContentType type) {
    return switch (type) {
      ContentType.word => Icons.menu_book,
      ContentType.phrase => Icons.chat_bubble,
      ContentType.grammar => Icons.psychology,
      ContentType.reading => Icons.article,
      ContentType.listening => Icons.headphones,
      ContentType.translation => Icons.translate,
      ContentType.phonetic => Icons.record_voice_over,
    };
  }

  Color _getActivityColor(ContentType type) {
    return switch (type) {
      ContentType.word => AppColors.primaryPurple,
      ContentType.phrase => AppColors.secondaryPink,
      ContentType.grammar => AppColors.accentOrange,
      ContentType.reading => AppColors.accentLime,
      ContentType.listening => AppColors.accentYellow,
      ContentType.translation => AppColors.infoBlue,
      ContentType.phonetic => AppColors.accentCyan,
    };
  }
}
