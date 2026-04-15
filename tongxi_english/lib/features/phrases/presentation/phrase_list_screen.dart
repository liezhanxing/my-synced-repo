import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../models/phrase_model.dart';
import 'phrase_detail_card.dart';
import 'phrases_controller.dart';

/// Phrase list screen showing phrases grouped by category
/// 
/// Each card displays:
/// - The phrase
/// - Chinese meaning
/// - Expand button for full details
class PhraseListScreen extends ConsumerStatefulWidget {
  const PhraseListScreen({super.key});

  @override
  ConsumerState<PhraseListScreen> createState() => _PhraseListScreenState();
}

class _PhraseListScreenState extends ConsumerState<PhraseListScreen> {
  final TtsService _ttsService = TtsService();
  String? _expandedPhraseId;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  void _toggleExpand(String phraseId) {
    setState(() {
      if (_expandedPhraseId == phraseId) {
        _expandedPhraseId = null;
      } else {
        _expandedPhraseId = phraseId;
      }
    });
  }

  Future<void> _playPhrase(String phrase) async {
    await _ttsService.speak(phrase);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phrasesControllerProvider);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
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
              state.error!,
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

    if (state.filteredPhrases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textHint.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              '没有找到短语',
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
      itemCount: state.filteredPhrases.length,
      itemBuilder: (context, index) {
        final phrase = state.filteredPhrases[index];
        final isExpanded = _expandedPhraseId == phrase.id;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: isExpanded
              ? PhraseDetailCard(
                  phrase: phrase,
                  onClose: () => _toggleExpand(phrase.id),
                )
              : _buildCompactCard(phrase, index),
        );
      },
    );
  }

  Widget _buildCompactCard(PhraseModel phrase, int index) {
    return AnimeCard(
      onTap: () => _toggleExpand(phrase.id),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Index number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
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
              
              // Phrase content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phrase.phrase,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phrase.translation,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Audio button
                  IconButton(
                    onPressed: () => _playPhrase(phrase.phrase),
                    icon: Icon(
                      Icons.volume_up_outlined,
                      size: 22,
                      color: AppColors.primaryPurple.withOpacity(0.6),
                    ),
                  ),
                  // Expand button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Category and difficulty
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(phrase.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getCategoryDisplayName(phrase.category),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getCategoryColor(phrase.category),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(3, (i) {
                return Icon(
                  i < phrase.difficulty ? Icons.star : Icons.star_border,
                  size: 14,
                  color: i < phrase.difficulty 
                      ? AppColors.accentYellow 
                      : AppColors.textHint,
                );
              }),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideY(begin: 0.1, end: 0);
  }

  Color _getCategoryColor(PhraseCategory category) {
    final colors = {
      PhraseCategory.idiom: AppColors.accentOrange,
      PhraseCategory.phrasalVerb: AppColors.accentCyan,
      PhraseCategory.collocation: AppColors.secondaryPink,
      PhraseCategory.proverb: AppColors.accentLime,
      PhraseCategory.slang: AppColors.accentYellow,
    };
    return colors[category] ?? AppColors.primaryPurple;
  }

  String _getCategoryDisplayName(PhraseCategory category) {
    final names = {
      PhraseCategory.idiom: '习语',
      PhraseCategory.phrasalVerb: '短语动词',
      PhraseCategory.collocation: '固定搭配',
      PhraseCategory.proverb: '谚语',
      PhraseCategory.slang: '俚语',
    };
    return names[category] ?? '短语';
  }
}
