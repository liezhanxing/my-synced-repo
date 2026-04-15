import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/mascot_widget.dart';
import 'phrase_list_screen.dart';
import 'phrase_practice_screen.dart';
import 'phrases_controller.dart';

/// Phrases module main screen
/// 
/// Features:
/// - Category tabs/chips for filtering
/// - Quick stats overview
/// - Navigation to phrase list and practice
class PhrasesScreen extends ConsumerStatefulWidget {
  const PhrasesScreen({super.key});

  @override
  ConsumerState<PhrasesScreen> createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends ConsumerState<PhrasesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  final List<String> _categories = ['all', 'daily', 'academic', 'travel', 'emotions', 'collocations'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phrasesControllerProvider);
    final categoryNames = ref.read(phrasesControllerProvider.notifier).getCategoryNames();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.modulePhrases),
        backgroundColor: ModuleColors.phrases.withOpacity(0.1),
        foregroundColor: ModuleColors.phrases,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ModuleColors.phrases,
          labelColor: ModuleColors.phrases,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: '短语学习'),
            Tab(icon: Icon(Icons.school), text: '练习'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? _buildErrorState(state.error!)
              : Column(
                  children: [
                    // Category filter chips (only show on learn tab)
                    if (_selectedTabIndex == 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                          child: Row(
                            children: _categories.map((category) {
                              final isSelected = state.selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(categoryNames[category] ?? category),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    ref.read(phrasesControllerProvider.notifier)
                                        .filterByCategory(category);
                                  },
                                  selectedColor: ModuleColors.phrases.withOpacity(0.2),
                                  backgroundColor: AppColors.surfaceVariant,
                                  labelStyle: TextStyle(
                                    color: isSelected ? ModuleColors.phrases : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Learn tab
                          const PhraseListScreen(),
                          
                          // Practice tab
                          _buildPracticeTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPracticeTab() {
    final state = ref.watch(phrasesControllerProvider);
    final categoryNames = ref.read(phrasesControllerProvider.notifier).getCategoryNames();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        children: [
          // Mascot welcome
          MascotWidget(
            expression: MascotExpression.excited,
            size: 100,
            speechText: '准备好练习短语了吗？',
          ),
          const SizedBox(height: 24),

          // Quick practice card
          AnimeCard(
            padding: const EdgeInsets.all(24),
            showGradientBorder: true,
            borderGradient: LinearGradient(
              colors: [
                ModuleColors.phrases.withOpacity(0.5),
                ModuleColors.phrases,
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.flash_on,
                  size: 48,
                  color: AppColors.accentYellow,
                ),
                const SizedBox(height: 16),
                const Text(
                  '快速练习',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '随机10道短语练习题',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                AnimeButton(
                  text: '开始练习',
                  icon: Icons.play_arrow,
                  onPressed: () => _navigateToPractice(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Category practice cards
          const Text(
            '按分类练习',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._categories.where((c) => c != 'all').map((category) {
            final progress = ref.read(phrasesControllerProvider.notifier)
                .getCategoryProgress(category);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCategoryPracticeCard(
                categoryNames[category] ?? category,
                progress,
                () => _navigateToPractice(category: category),
              ),
            );
          }),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300));
  }

  Widget _buildCategoryPracticeCard(
    String title,
    double progress,
    VoidCallback onTap,
  ) {
    return AnimeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ModuleColors.phrases.withOpacity(0.3),
                  ModuleColors.phrases.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.format_quote,
              color: ModuleColors.phrases,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(ModuleColors.phrases),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toInt()}% 完成',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }

  void _navigateToPractice({String? category}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhrasePracticeScreen(category: category),
      ),
    );
  }

  Widget _buildErrorState(String error) {
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
            onPressed: () => ref.read(phrasesControllerProvider.notifier).loadPhrases(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
