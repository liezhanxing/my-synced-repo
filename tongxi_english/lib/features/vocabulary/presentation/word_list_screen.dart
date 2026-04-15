import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/word_model.dart';

class WordListScreen extends StatelessWidget {
  const WordListScreen({
    super.key,
    required this.groupedWords,
    required this.onPlay,
  });

  final Map<String, List<WordModel>> groupedWords;
  final Future<void> Function(WordModel word) onPlay;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const MascotWidget(
          expression: MascotExpression.happy,
          size: 92,
          speechText: '先看词，再听音，再记例句！',
        ),
        const SizedBox(height: 14),
        for (final entry in groupedWords.entries) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...entry.value.map(
            (word) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimeCard(
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${word.phonetic}  ·  ${word.translation}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyanLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      word.partOfSpeech,
                      style: const TextStyle(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.definition,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                word.examples.first.sentence,
                                style: const TextStyle(height: 1.6),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                word.examples.first.translation,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filled(
                          onPressed: () => onPlay(word),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.secondaryPink,
                          ),
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
