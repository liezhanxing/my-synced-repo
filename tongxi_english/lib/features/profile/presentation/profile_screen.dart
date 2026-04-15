import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../auth/presentation/auth_controller.dart';
import 'profile_controller.dart';
import 'achievements_screen.dart';
import 'progress_screen.dart';

/// Profile screen
/// 
/// Displays user profile, stats, achievements, and navigation to other profile screens
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileState = ref.watch(profileControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    // Use profile state if available, otherwise fall back to auth user
    final displayName = profileState.settings.displayName.isNotEmpty
        ? profileState.settings.displayName
        : user?.displayName ?? '学习者';
    final email = profileState.settings.email.isNotEmpty
        ? profileState.settings.email
        : user?.email ?? '';
    final level = profileState.level > 0 ? profileState.level : (user?.level ?? 1);
    final xp = profileState.xp > 0 ? profileState.xp : (user?.xp ?? 0);
    final streak = profileState.streak > 0 ? profileState.streak : (user?.streak ?? 0);
    final wordsLearned = profileState.totalWordsLearned > 0
        ? profileState.totalWordsLearned
        : (user?.wordsLearned ?? 0);

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
                    const Text(
                      AppStrings.navProfile,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.insights_outlined),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProgressScreen(),
                              ),
                            );
                          },
                          tooltip: '学习进度',
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () => context.push('/settings'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // User info card with mascot
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLg,
                ),
                child: AnimeCard(
                  showGradientBorder: true,
                  child: Column(
                    children: [
                      // Mascot greeting
                      const MascotWidget(
                        expression: MascotExpression.happy,
                        size: 80,
                        speechText: '你好，继续加油学习吧！',
                      ),
                      const SizedBox(height: 16),
                      
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPurple.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: user?.avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(user!.avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: user?.avatarUrl == null
                            ? Center(
                                child: Text(
                                  displayName.isNotEmpty
                                      ? displayName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Name
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Email
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Level and XP row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Level badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.warmGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Lv.$level',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // XP display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.accentYellow,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$xp XP',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentYellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Level progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: profileState.levelProgress,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryPurple,
                                ),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '距离升级还需 ${profileState.xpForNextLevel - xp} XP',
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
              ),
            ),

            // Streak card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                  top: AppSizes.paddingLg,
                ),
                child: _buildStreakCard(streak, profileState.longestStreak),
              ),
            ),

            // Stats section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                  top: AppSizes.paddingXl,
                  bottom: AppSizes.paddingMd,
                ),
                child: Text(
                  '学习统计',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // Stats cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLg,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        value: '$wordsLearned',
                        label: '已学单词',
                        icon: Icons.menu_book,
                        color: AppColors.accentLime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        value: '${profileState.totalStudyMinutes ~/ 60}h',
                        label: '学习时长',
                        icon: Icons.timer,
                        color: AppColors.infoBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        value: '${profileState.averageQuizScore.toInt()}%',
                        label: '平均得分',
                        icon: Icons.trending_up,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Achievements section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                  top: AppSizes.paddingXl,
                  bottom: AppSizes.paddingMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '成就徽章',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AchievementsScreen(),
                          ),
                        );
                      },
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
              ),
            ),

            // Achievements horizontal list
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  itemCount: profileState.achievements
                      .where((a) => a.isUnlocked)
                      .take(5)
                      .length,
                  itemBuilder: (context, index) {
                    final achievement = profileState.achievements
                        .where((a) => a.isUnlocked)
                        .toList()[index];
                    return _buildAchievementItem(achievement);
                  },
                ),
              ),
            ),

            // Quick actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  children: [
                    AnimeOutlinedButton(
                      text: '查看详细进度',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProgressScreen(),
                          ),
                        );
                      },
                      icon: Icons.insights,
                    ),
                    const SizedBox(height: 12),
                    AnimeOutlinedButton(
                      text: AppStrings.signOut,
                      onPressed: () => authController.signOut(),
                      icon: Icons.logout,
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

  Widget _buildStreakCard(int streak, int longestStreak) {
    return AnimeCard(
      backgroundColor: AppColors.accentOrange.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.warmGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak 天',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '当前连续学习',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '最高 $longestStreak 天',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
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
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    final (color, icon) = _getAchievementStyle(achievement.rarity);

    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              _getIconData(achievement.iconName),
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getAchievementStyle(AchievementRarity rarity) {
    return switch (rarity) {
      AchievementRarity.common => (const Color(0xFFCD7F32), Icons.school),
      AchievementRarity.rare => (const Color(0xFFC0C0C0), Icons.star),
      AchievementRarity.epic => (const Color(0xFFFFD700), Icons.emoji_events),
      AchievementRarity.legendary => (const Color(0xFFE5E4E2), Icons.diamond),
    };
  }

  IconData _getIconData(String name) {
    return switch (name) {
      'school' => Icons.school,
      'menu_book' => Icons.menu_book,
      'auto_stories' => Icons.auto_stories,
      'psychology' => Icons.psychology,
      'local_fire_department' => Icons.local_fire_department,
      'whatshot' => Icons.whatshot,
      'emoji_events' => Icons.emoji_events,
      'stars' => Icons.stars,
      'speed' => Icons.speed,
      'hearing' => Icons.hearing,
      'share' => Icons.share,
      _ => Icons.emoji_events,
    };
  }
}
