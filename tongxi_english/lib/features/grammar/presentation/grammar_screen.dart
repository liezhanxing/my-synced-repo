import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/grammar_model.dart';
import 'grammar_controller.dart';
import 'grammar_topic_screen.dart';

/// Grammar module main screen
/// 
/// Features:
/// - Grade-level tabs (高一, 高二, 高三)
/// - List of grammar topics
/// - Progress tracking per topic
class GrammarScreen extends ConsumerStatefulWidget {
  const GrammarScreen({super.key});

  @override
  ConsumerState<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends ConsumerState<GrammarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _grades = ['all', 'grade10', 'grade11', 'grade12'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _grades.length, vsync: this);
    _tabController.addListener(() {
      final grade = _grades[_tabController.index];
      ref.read(grammarControllerProvider.notifier).filterByGrade(grade);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(grammarControllerProvider);
    final gradeNames = ref.read(grammarControllerProvider.notifier).getGradeNames();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.moduleGrammar),
        backgroundColor: ModuleColors.grammar.withOpacity(0.1),
        foregroundColor: ModuleColors.grammar,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(),
              )
            : null,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: ModuleColors.grammar,
          labelColor: ModuleColors.grammar,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: _grades.map((grade) {
            return Tab(text: gradeNames[grade] ?? grade);
          }).toList(),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? _buildErrorState(state.error!)
              : _buildContent(state),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.errorRed.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(color: AppColors.errorRed),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(grammarControllerProvider.notifier).loadGrammar(),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(GrammarState state) {
    if (state.filteredRules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: AppColors.textHint.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无语法内容',
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
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      itemCount: state.filteredRules.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeader();
        }
        final rule = state.filteredRules[index - 1];
        return _buildGrammarCard(rule, index - 1);
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          MascotWidget(
            expression: MascotExpression.happy,
            size: 100,
            speechText: '选择你想学习的语法知识点吧！',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ModuleColors.grammar.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: ModuleColors.grammar,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '共 ${ref.read(grammarControllerProvider).filteredRules.length} 个语法知识点',
                  style: TextStyle(
                    fontSize: 14,
                    color: ModuleColors.grammar,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300));
  }

  Widget _buildGrammarCard(GrammarModel grammar, int index) {
    final progress = ref.read(grammarControllerProvider.notifier)
        .getTopicProgress(grammar.id);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimeCard(
        onTap: () => _navigateToTopic(grammar),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Index number
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ModuleColors.grammar.withOpacity(0.8),
                    ModuleColors.grammar,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grammar.titleCn,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grammar.title,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(grammar.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getCategoryName(grammar.category),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getCategoryColor(grammar.category),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(3, (i) {
                        return Icon(
                          i < grammar.difficulty ? Icons.star : Icons.star_border,
                          size: 14,
                          color: i < grammar.difficulty 
                              ? AppColors.accentYellow 
                              : AppColors.textHint,
                        );
                      }),
                    ],
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(ModuleColors.grammar),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideY(begin: 0.1, end: 0);
  }

  Color _getCategoryColor(GrammarCategory category) {
    final colors = {
      GrammarCategory.tenses: AppColors.accentCyan,
      GrammarCategory.conditionals: AppColors.secondaryPink,
      GrammarCategory.passiveVoice: AppColors.accentLime,
      GrammarCategory.reportedSpeech: AppColors.accentOrange,
      GrammarCategory.articles: AppColors.primaryPurple,
      GrammarCategory.prepositions: AppColors.accentYellow,
      GrammarCategory.conjunctions: AppColors.infoBlue,
      GrammarCategory.relativeClauses: AppColors.secondaryPink,
      GrammarCategory.modalVerbs: AppColors.accentCyan,
      GrammarCategory.gerunds: AppColors.accentLime,
      GrammarCategory.comparatives: AppColors.accentOrange,
      GrammarCategory.questionForms: AppColors.primaryPurple,
    };
    return colors[category] ?? ModuleColors.grammar;
  }

  String _getCategoryName(GrammarCategory category) {
    final names = {
      GrammarCategory.tenses: '时态',
      GrammarCategory.conditionals: '条件句',
      GrammarCategory.passiveVoice: '被动语态',
      GrammarCategory.reportedSpeech: '间接引语',
      GrammarCategory.articles: '冠词',
      GrammarCategory.prepositions: '介词',
      GrammarCategory.conjunctions: '连词',
      GrammarCategory.relativeClauses: '定语从句',
      GrammarCategory.modalVerbs: '情态动词',
      GrammarCategory.gerunds: '非谓语动词',
      GrammarCategory.comparatives: '比较级',
      GrammarCategory.questionForms: '疑问句',
    };
    return names[category] ?? '语法';
  }

  void _navigateToTopic(GrammarModel grammar) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GrammarTopicScreen(grammar: grammar),
      ),
    );
  }
}
