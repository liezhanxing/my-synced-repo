import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/word_model.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({
    super.key,
    required this.word,
    required this.index,
    required this.total,
    required this.isFlipped,
    required this.onFlip,
    required this.onKnow,
    required this.onDontKnow,
    required this.onPlay,
    this.title = '闪卡记忆',
  });

  final WordModel? word;
  final int index;
  final int total;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onKnow;
  final VoidCallback onDontKnow;
  final Future<void> Function(WordModel word) onPlay;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (word == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AnimeCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('当前没有可展示的单词卡片。'),
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentYellowLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${total == 0 ? 0 : index + 1}/$total',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentOrange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        MascotWidget(
          expression: isFlipped ? MascotExpression.excited : MascotExpression.thinking,
          size: 94,
          speechText: isFlipped ? '会用例句记得更牢哦！' : '先猜意思，再点卡片翻面～',
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onFlip,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            transitionBuilder: (child, animation) {
              return RotationYTransition(turns: animation, child: child);
            },
            child: isFlipped
                ? _CardBack(key: const ValueKey('back'), word: word!, onPlay: onPlay)
                : _CardFront(key: const ValueKey('front'), word: word!, onPlay: onPlay),
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.96, 0.96)),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: AnimeButton(
                text: '不太会',
                icon: Icons.swipe_left_rounded,
                gradient: AppColors.warmGradient,
                onPressed: onDontKnow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimeButton(
                text: '我会了',
                icon: Icons.swipe_right_rounded,
                gradient: AppColors.successGradient,
                onPressed: onKnow,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    super.key,
    required this.word,
    required this.onPlay,
  });

  final WordModel word;
  final Future<void> Function(WordModel word) onPlay;

  @override
  Widget build(BuildContext context) {
    return AnimeCard(
      key: key,
      showGradientBorder: true,
      borderGradient: AppColors.primaryGradient,
      child: SizedBox(
        height: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton.filled(
                onPressed: () => onPlay(word),
                style: IconButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                icon: const Icon(Icons.volume_up_rounded),
              ),
            ),
            const Spacer(),
            Text(
              word.word,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              word.phonetic,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              word.partOfSpeech,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const Text(
              '轻触卡片翻面',
              style: TextStyle(
                color: AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    super.key,
    required this.word,
    required this.onPlay,
  });

  final WordModel word;
  final Future<void> Function(WordModel word) onPlay;

  @override
  Widget build(BuildContext context) {
    return AnimeCard(
      key: key,
      showGradientBorder: true,
      borderGradient: AppColors.sunsetGradient,
      child: SizedBox(
        height: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton.filled(
                onPressed: () => onPlay(word),
                style: IconButton.styleFrom(backgroundColor: AppColors.secondaryPink),
                icon: const Icon(Icons.volume_up_rounded),
              ),
            ),
            Text(
              word.translation,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.secondaryPink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              word.definition,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentCyanLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.examples.first.sentence,
                    style: const TextStyle(
                      height: 1.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    word.examples.first.translation,
                    style: const TextStyle(
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '词性：${word.partOfSpeech}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    super.key,
    required Animation<double> turns,
    required this.child,
  }) : super(listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final value = turns.value;
    final angle = value * 3.1415926;
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
