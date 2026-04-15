import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../app/routes.dart';
import '../../auth/presentation/auth_controller.dart';

/// Home screen with dashboard showing all 7 learning modules
/// 
/// Features:
/// - Mascot greeting
/// - Daily goal progress
/// - XP and streak display
/// - Grid of 7 module cards
/// - Quick access to recent activities
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar with user info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Row(
                  children: [
                    // User avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user?.displayName.isNotEmpty == true
                              ? user!.displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Greeting
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            user?.displayName ?? '学习者',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Streak badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: AppColors.accentOrange,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user?.streak ?? 0}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mascot greeting section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLg,
                ),
                child: Row(
                  children: [
                    MascotWidget(
                      expression: MascotExpression.happy,
                      size: 100,
                      speechText: '今天也要加油学习哦！',
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // XP Progress
                          if (user != null)
                            XpProgressBar(
                              currentXp: user.xp,
                              xpForNextLevel: user.xpForNextLevel,
                              level: user.level,
                            )
                                .animate()
                                .fadeIn(delay: const Duration(milliseconds: 200)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daily goal section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: DailyGoalProgress(
                  current: 35,
                  goal: user?.dailyGoal ?? 50,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideY(begin: 0.2, end: 0),
              ),
            ),

            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLg,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.menu_book,
                        value: '${user?.wordsLearned ?? 0}',
                        label: '已学单词',
                        color: AppColors.accentLime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.timer,
                        value: '${user?.totalStudyMinutes ?? 0}',
                        label: '学习分钟',
                        color: AppColors.accentCyan,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.emoji_events,
                        value: '12',
                        label: '获得成就',
                        color: AppColors.accentYellow,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.paddingLg,
                  right: AppSizes.paddingLg,
                  top: AppSizes.paddingXl,
                  bottom: AppSizes.paddingMd,
                ),
                child: Text(
                  '学习模块',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // Module grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildListDelegate([
                  ModuleCard(
                    title: AppStrings.modulePhonetics,
                    subtitle: AppStrings.modulePhoneticsDesc,
                    icon: Icons.record_voice_over,
                    color: ModuleColors.phonetics,
                    progress: 45,
                    onTap: () => context.goToPhonetics(),
                  ),
                  ModuleCard(
                    title: AppStrings.moduleVocabulary,
                    subtitle: AppStrings.moduleVocabularyDesc,
                    icon: Icons.menu_book,
                    color: ModuleColors.vocabulary,
                    progress: 62,
                    onTap: () => context.goToVocabulary(),
                  ),
                  ModuleCard(
                    title: AppStrings.modulePhrases,
                    subtitle: AppStrings.modulePhrasesDesc,
                    icon: Icons.format_quote,
                    color: ModuleColors.phrases,
                    progress: 30,
                    onTap: () => context.goToPhrases(),
                  ),
                  ModuleCard(
                    title: AppStrings.moduleGrammar,
                    subtitle: AppStrings.moduleGrammarDesc,
                    icon: Icons.psychology,
                    color: ModuleColors.grammar,
                    progress: 25,
                    onTap: () => context.goToGrammar(),
                  ),
                  ModuleCard(
                    title: AppStrings.moduleReading,
                    subtitle: AppStrings.moduleReadingDesc,
                    icon: Icons.article,
                    color: ModuleColors.reading,
                    progress: 40,
                    onTap: () => context.goToReading(),
                  ),
                  ModuleCard(
                    title: AppStrings.moduleListening,
                    subtitle: AppStrings.moduleListeningDesc,
                    icon: Icons.headphones,
                    color: ModuleColors.listening,
                    progress: 35,
                    onTap: () => context.goToListening(),
                  ),
                  ModuleCard(
                    title: AppStrings.moduleTranslation,
                    subtitle: AppStrings.moduleTranslationDesc,
                    icon: Icons.translate,
                    color: ModuleColors.translation,
                    progress: 20,
                    onTap: () => context.goToTranslation(),
                  ),
                ]),
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

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '早上好!';
    } else if (hour < 18) {
      return '下午好!';
    } else {
      return '晚上好!';
    }
  }
}
