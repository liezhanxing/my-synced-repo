import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/grammar_model.dart';
import 'grammar_controller.dart';
import 'grammar_exercise_screen.dart';

/// Detailed grammar topic screen
/// 
/// Displays:
/// - Rule explanation with highlighted key points
/// - Example sentences with key structures highlighted
/// - Common mistakes section (错误示范 vs 正确用法)
/// - Practice button leading to exercises
class GrammarTopicScreen extends ConsumerWidget {
  final GrammarModel grammar;

  const GrammarTopicScreen({
    super.key,
    required this.grammar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          grammar.titleCn,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: ModuleColors.grammar.withOpacity(0.1),
        foregroundColor: ModuleColors.grammar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // Explanation section
            _buildExplanationSection(),
            const SizedBox(height: 20),

            // Key points section
            _buildKeyPointsSection(),
            const SizedBox(height: 20),

            // Examples section
            _buildExamplesSection(),
            const SizedBox(height: 20),

            // Common mistakes section
            if (grammar.commonMistakes.isNotEmpty) ...[
              _buildCommonMistakesSection(),
              const SizedBox(height: 20),
            ],

            // Mascot tip
            MascotWidget(
              expression: MascotExpression.thinking,
              size: 80,
              speechText: '理解了吗？来做几道练习题巩固一下吧！',
            ),
            const SizedBox(height: 24),

            // Practice button
            AnimeButton(
              text: '开始练习',
              icon: Icons.edit,
              onPressed: () => _navigateToPractice(context, ref),
              gradient: LinearGradient(
                colors: [
                  ModuleColors.grammar,
                  ModuleColors.grammar.withOpacity(0.8),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      showGradientBorder: true,
      borderGradient: LinearGradient(
        colors: [
          ModuleColors.grammar.withOpacity(0.5),
          ModuleColors.grammar,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ModuleColors.grammar.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getCategoryName(grammar.category),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ModuleColors.grammar,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(3, (index) {
                return Icon(
                  index < grammar.difficulty ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < grammar.difficulty 
                      ? AppColors.accentYellow 
                      : AppColors.textHint,
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            grammar.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            grammar.titleCn,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ModuleColors.grammar,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildExplanationSection() {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: ModuleColors.grammar,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '语法讲解',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormattedExplanation(grammar.explanation),
        ],
      ),
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 100))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildFormattedExplanation(String explanation) {
    // Parse markdown-like formatting
    final lines = explanation.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      final trimmed = line.trim();
      
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
        // Bold heading
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(
              trimmed.replaceAll('**', ''),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('- ')) {
        // Bullet point
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: ModuleColors.grammar,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRichText(trimmed.substring(2)),
                ),
              ],
            ),
          ),
        );
      } else if (trimmed.startsWith('|')) {
        // Table row - skip for now or handle specially
        if (!trimmed.contains('---')) {
          final cells = trimmed.split('|').where((s) => s.trim().isNotEmpty).toList();
          if (cells.isNotEmpty) {
            widgets.add(
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: cells.map((cell) {
                    return Expanded(
                      child: Text(
                        cell.trim(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        }
      } else {
        // Regular text
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRichText(trimmed),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildRichText(String text) {
    // Handle inline bold text
    final parts = text.split('**');
    if (parts.length > 1) {
      final spans = <TextSpan>[];
      for (var i = 0; i < parts.length; i++) {
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textPrimary,
            fontWeight: i % 2 == 1 ? FontWeight.bold : FontWeight.normal,
          ),
        ));
      }
      return RichText(
        text: TextSpan(children: spans),
      );
    }
    
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        height: 1.6,
        color: AppColors.textPrimary.withOpacity(0.9),
      ),
    );
  }

  Widget _buildKeyPointsSection() {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: AppColors.accentYellow,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '要点总结',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...grammar.keyPoints.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ModuleColors.grammar.withOpacity(0.8),
                          ModuleColors.grammar,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 200))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildExamplesSection() {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote,
                color: AppColors.accentCyan,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '例句',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...grammar.examples.asMap().entries.map((entry) {
            final index = entry.key;
            final example = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accentCyan.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _highlightGrammarStructure(example.correct),
                        ),
                      ],
                    ),
                    if (example.incorrect != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.errorRed,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              example.incorrect!,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.errorRed.withOpacity(0.8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        example.explanation,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary.withOpacity(0.8),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _highlightGrammarStructure(String sentence) {
    // Highlight key grammar patterns
    final patterns = [
      RegExp(r'\b(am|is|are|was|were|be|been|being)\b', caseSensitive: false),
      RegExp(r'\b(have|has|had)\b', caseSensitive: false),
      RegExp(r'\b(do|does|did|done)\b', caseSensitive: false),
      RegExp(r'\b(will|would|shall|should|can|could|may|might|must)\b', caseSensitive: false),
      RegExp(r'\b(if|when|while|because|although|that|which|who|whom)\b', caseSensitive: false),
    ];
    
    // For simplicity, just return styled text
    // In a real app, you'd parse and highlight specific patterns
    return Text(
      sentence,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
    );
  }

  Widget _buildCommonMistakesSection() {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: AppColors.errorRed,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '常见错误',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...grammar.commonMistakes.map((mistake) {
            final parts = mistake.split('→');
            if (parts.length == 2) {
              final incorrect = parts[0].trim();
              final correct = parts[1].trim();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.errorRed.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            color: AppColors.errorRed,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              incorrect.replaceAll('❌ ', ''),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.errorRed.withOpacity(0.9),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: AppColors.successGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              correct.replaceAll('✅ ', ''),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.successGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    ).animate()
      .fadeIn(delay: const Duration(milliseconds: 400))
      .slideY(begin: 0.1, end: 0);
  }

  void _navigateToPractice(BuildContext context, WidgetRef ref) {
    ref.read(grammarExerciseControllerProvider.notifier).startExercise(grammar);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GrammarExerciseScreen(grammar: grammar),
      ),
    );
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
}
