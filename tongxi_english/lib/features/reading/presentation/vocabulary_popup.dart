import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../models/reading_model.dart';

/// Bottom sheet popup for vocabulary word details
/// 
/// Shows word definition, phonetic pronunciation, and example usage
class VocabularyPopup extends StatelessWidget {
  final ReadingVocabulary vocabulary;
  final VoidCallback? onClose;
  final VoidCallback? onSpeak;

  const VocabularyPopup({
    super.key,
    required this.vocabulary,
    this.onClose,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Word header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Word
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vocabulary.word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Phonetic
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurpleLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vocabulary.phonetic,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Speak button
                          if (onSpeak != null)
                            InkWell(
                              onTap: onSpeak,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyanLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  color: AppColors.accentCyan,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Close button
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Definition section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('英文释义'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentLimeLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentLime.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    vocabulary.definition,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Chinese translation section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('中文释义'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryPinkLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondaryPink.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    vocabulary.translation,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: AnimeButton(
              text: '知道了',
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              height: 50,
            ),
          ),
          
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ).animate()
      .slideY(
        begin: 1,
        end: 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      )
      .fadeIn(duration: const Duration(milliseconds: 200));
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Show vocabulary popup as bottom sheet
Future<void> showVocabularyPopup(
  BuildContext context, {
  required ReadingVocabulary vocabulary,
  VoidCallback? onSpeak,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => VocabularyPopup(
      vocabulary: vocabulary,
      onSpeak: onSpeak,
    ),
  );
}
