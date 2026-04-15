import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../models/phrase_model.dart';

/// Expanded phrase detail card with full information
/// 
/// Displays:
/// - Phrase with phonetic guide
/// - Chinese meaning
/// - 2-3 example sentences
/// - Usage notes
/// - Audio playback button
class PhraseDetailCard extends StatefulWidget {
  final PhraseModel phrase;
  final VoidCallback? onClose;

  const PhraseDetailCard({
    super.key,
    required this.phrase,
    this.onClose,
  });

  @override
  State<PhraseDetailCard> createState() => _PhraseDetailCardState();
}

class _PhraseDetailCardState extends State<PhraseDetailCard> {
  final TtsService _ttsService = TtsService();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  Future<void> _playAudio() async {
    if (_isPlaying) return;
    
    setState(() => _isPlaying = true);
    await _ttsService.speak(widget.phrase.phrase);
    
    // Wait a bit then mark as not playing
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  Future<void> _playExample(String text) async {
    await _ttsService.speak(text);
  }

  String _generatePhonetic(String phrase) {
    // Simple phonetic approximation for common words
    // In a real app, this would come from a dictionary API
    final phoneticMap = {
      'how': 'haʊ',
      'is': 'ɪz',
      'it': 'ɪt',
      'going': 'ˈɡoʊɪŋ',
      'long': 'lɔːŋ',
      'time': 'taɪm',
      'no': 'noʊ',
      'see': 'siː',
      'take': 'teɪk',
      'easy': 'ˈiːzi',
      'catch': 'kætʃ',
      'up': 'ʌp',
      'by': 'baɪ',
      'the': 'ðə',
      'way': 'weɪ',
      'in': 'ɪn',
      'meantime': 'ˈmiːntaɪm',
      'make': 'meɪk',
      'sense': 'sens',
      'figure': 'ˈfɪɡjər',
      'out': 'aʊt',
      'pay': 'peɪ',
      'attention': 'əˈtenʃn',
      'to': 'tuː',
      'notes': 'noʊts',
      'hand': 'hænd',
      'look': 'lʊk',
      'go': 'ɡoʊ',
      'over': 'ˈoʊvər',
      'on': 'ɑːn',
      'keep': 'kiːp',
      'with': 'wɪð',
      'fall': 'fɔːl',
      'behind': 'bɪˈhaɪnd',
      'check': 'tʃek',
      'set': 'set',
      'off': 'ɔːf',
      'get': 'ɡet',
      'around': 'əˈraʊnd',
      'forward': 'ˈfɔːrwərd',
      'run': 'rʌn',
      'of': 'əv',
      'cheer': 'tʃɪr',
      'calm': 'kɑːm',
      'down': 'daʊn',
      'freak': 'friːk',
      'break': 'breɪk',
      'fed': 'fed',
      'moon': 'muːn',
      'along': 'əˈlɔːŋ',
      'put': 'pʊt',
      'a': 'ə',
      'decision': 'dɪˈsɪʒn',
      'responsibility': 'rɪˌspɑːnsəˈbɪləti',
      'have': 'hæv',
      'an': 'æn',
      'impact': 'ˈɪmpækt',
      'play': 'pleɪ',
      'role': 'roʊl',
      'come': 'kʌm',
      'deal': 'diːl',
      'give': 'ɡɪv',
      'turn': 'tɜːrn',
      'into': 'ˈɪntuː',
    };
    
    final words = phrase.toLowerCase().split(' ');
    final phonetics = words.map((word) {
      // Remove punctuation
      final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
      return phoneticMap[cleanWord] ?? cleanWord;
    }).join(' ');
    
    return '/$phonetics/';
  }

  @override
  Widget build(BuildContext context) {
    return AnimeCard(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getCategoryDisplayName(widget.phrase.category),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryPink,
                  ),
                ),
              ),
              if (widget.onClose != null)
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Phrase with audio button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.phrase.phrase,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _generatePhonetic(widget.phrase.phrase),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _playAudio,
                child: Container(
                  width: 56,
                  height: 56,
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
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isPlaying
                        ? const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 28,
                          )
                        : const Icon(
                            Icons.volume_up_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chinese meaning
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryPurpleLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '中文释义',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.phrase.translation,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.phrase.meaning,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Usage contexts
          if (widget.phrase.contexts.isNotEmpty) ...[
            const Text(
              '使用场景',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.phrase.contexts.map((context) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentCyan.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getContextDisplayName(context),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.accentCyan,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Example sentences
          const Text(
            '例句',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.phrase.examples.asMap().entries.map((entry) {
            final index = entry.key;
            final example = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildExampleCard(example, index),
            );
          }),

          // Related phrases
          if (widget.phrase.relatedPhrases.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              '相关短语',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.phrase.relatedPhrases.map((related) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    related,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.accentOrange,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Difficulty indicator
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                '难度: ',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              ...List.generate(3, (index) {
                return Icon(
                  index < widget.phrase.difficulty ? Icons.star : Icons.star_border,
                  size: 16,
                  color: index < widget.phrase.difficulty 
                      ? AppColors.accentYellow 
                      : AppColors.textHint,
                );
              }),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildExampleCard(PhraseExample example, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
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
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  example.sentence,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _playExample(example.sentence),
                icon: Icon(
                  Icons.volume_up_outlined,
                  size: 20,
                  color: AppColors.primaryPurple.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              example.translation,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
          if (example.context.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  example.context,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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

  String _getContextDisplayName(String context) {
    final names = {
      'formal': '正式',
      'informal': '非正式',
      'spoken': '口语',
      'written': '书面',
      'slang': '俚语',
    };
    return names[context.toLowerCase()] ?? context;
  }
}
