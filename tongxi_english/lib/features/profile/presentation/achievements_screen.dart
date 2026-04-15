import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import 'profile_controller.dart';

/// Achievements screen
/// 
/// Full achievements page with categorized badges
class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final unlockedCount = state.unlockedAchievementsCount;
    final totalCount = state.achievements.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('成就徽章'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryPurple,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: AppColors.primaryPurple,
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '学习'),
            Tab(text: '连续'),
            Tab(text: '挑战'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress summary
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: _buildProgressSummary(unlockedCount, totalCount),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementGrid(state.achievements),
                _buildAchievementGrid(
                  state.getAchievementsByCategory(AchievementCategory.learning),
                ),
                _buildAchievementGrid(
                  state.getAchievementsByCategory(AchievementCategory.streak),
                ),
                _buildAchievementGrid(
                  state.getAchievementsByCategory(AchievementCategory.challenge),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(int unlocked, int total) {
    final progress = total > 0 ? unlocked / total : 0.0;

    return AnimeCard(
      showGradientBorder: true,
      borderGradient: AppColors.warmGradient,
      child: Row(
        children: [
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
                    AppColors.accentYellow,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$unlocked',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentYellow,
                        ),
                      ),
                      Text(
                        '/$total',
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
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '成就收集进度',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '已解锁 $unlocked 个成就，还有 ${total - unlocked} 个待解锁',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accentYellow,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildAchievementGrid(List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MascotWidget(
              expression: MascotExpression.thinking,
              size: 100,
              speechText: '这里还没有成就哦',
            ),
            const SizedBox(height: 16),
            Text(
              '暂无此类成就',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement, index);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, int index) {
    final (color, icon, gradient) = _getAchievementStyle(achievement.rarity);
    final isUnlocked = achievement.isUnlocked;

    return AnimeCard(
      onTap: () => _showAchievementDetail(achievement),
      showGradientBorder: isUnlocked,
      borderGradient: gradient,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: isUnlocked ? gradient : null,
                  color: isUnlocked ? null : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: isUnlocked ? Colors.white : Colors.grey.shade400,
                ),
              ),
              if (!isUnlocked)
                Positioned(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            achievement.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Description
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 12,
              color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Progress bar for locked achievements
          if (!isUnlocked && achievement.progress != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: achievement.progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(achievement.progress! * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          // Rarity badge
          if (isUnlocked) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getRarityLabel(achievement.rarity),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
  }

  void _showAchievementDetail(Achievement achievement) {
    final (color, icon, gradient) = _getAchievementStyle(achievement.rarity);
    final isUnlocked = achievement.isUnlocked;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Badge icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: isUnlocked ? gradient : null,
                color: isUnlocked ? null : Colors.grey.shade200,
                shape: BoxShape.circle,
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                size: 50,
                color: isUnlocked ? Colors.white : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.successGreen.withOpacity(0.1)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUnlocked ? Icons.check_circle : Icons.lock,
                    size: 16,
                    color: isUnlocked
                        ? AppColors.successGreen
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isUnlocked ? '已解锁' : '未解锁',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked
                          ? AppColors.successGreen
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              achievement.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Rarity
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getRarityLabel(achievement.rarity),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),

            // Progress for locked
            if (!isUnlocked && achievement.progress != null) ...[
              const SizedBox(height: 24),
              const Text(
                '进度',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: achievement.progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(achievement.progress! * 100).toInt()}% 完成',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('关闭'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, IconData, LinearGradient) _getAchievementStyle(
    AchievementRarity rarity,
  ) {
    return switch (rarity) {
      AchievementRarity.common => (
          const Color(0xFFCD7F32),
          Icons.school,
          const LinearGradient(
            colors: [Color(0xFFD4A574), Color(0xFFCD7F32)],
          ),
        ),
      AchievementRarity.rare => (
          const Color(0xFFC0C0C0),
          Icons.star,
          const LinearGradient(
            colors: [Color(0xFFE8E8E8), Color(0xFFC0C0C0)],
          ),
        ),
      AchievementRarity.epic => (
          const Color(0xFFFFD700),
          Icons.emoji_events,
          const LinearGradient(
            colors: [Color(0xFFFFED4A), Color(0xFFFFD700)],
          ),
        ),
      AchievementRarity.legendary => (
          const Color(0xFF9B59B6),
          Icons.diamond,
          const LinearGradient(
            colors: [Color(0xFFBB8FCE), Color(0xFF9B59B6)],
          ),
        ),
    };
  }

  String _getRarityLabel(AchievementRarity rarity) {
    return switch (rarity) {
      AchievementRarity.common => '普通',
      AchievementRarity.rare => '稀有',
      AchievementRarity.epic => '史诗',
      AchievementRarity.legendary => '传说',
    };
  }
}
