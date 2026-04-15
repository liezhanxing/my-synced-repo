import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/phonetic_model.dart';

class PhoneticDetailCard extends StatelessWidget {
  const PhoneticDetailCard({
    super.key,
    required this.item,
    required this.similarSounds,
    required this.onPlay,
  });

  final PhoneticModel item;
  final List<PhoneticModel> similarSounds;
  final Future<void> Function() onPlay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 52,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      gradient: item.category == PhoneticCategory.consonant
                          ? AppColors.coolGradient
                          : AppColors.sunsetGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        item.symbol,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ).animate().scale(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '发音详情',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '/${item.symbol}/',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.spellings
                              .map(
                                (spelling) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPurpleLight,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    spelling,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryPurpleDark,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AnimeCard(
                backgroundColor: AppColors.surfaceLight,
                child: Row(
                  children: [
                    const MascotWidget(
                      expression: MascotExpression.thinking,
                      size: 70,
                      speechText: '观察口型，再跟读一遍～',
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        item.description,
                        style: const TextStyle(
                          height: 1.65,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AnimeButton(
                text: '播放示范发音',
                icon: Icons.volume_up_rounded,
                onPressed: () => onPlay(),
              ),
              const SizedBox(height: 18),
              const Text(
                '例词联想',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...item.examples.take(5).map(
                    (example) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AnimeCard(
                        backgroundColor: AppColors.accentYellowLight,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    example.word,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${example.phoneticSpelling} · ${example.meaning}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.auto_awesome,
                              color: AppColors.accentOrange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 10),
              const Text(
                '易混音对比',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (similarSounds.isEmpty)
                AnimeCard(
                  backgroundColor: AppColors.accentCyanLight,
                  child: const Text(
                    '这个音比较独特，先把它读稳，再继续挑战下一组吧！',
                    style: TextStyle(height: 1.6),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: similarSounds
                      .map(
                        (sound) => AnimeCard(
                          width: 150,
                          backgroundColor: AppColors.surfaceLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sound.symbol,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                sound.examples.first.word,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sound.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
