import 'package:flutter/material.dart';

import '../../../models/word_model.dart';
import 'flashcard_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    super.key,
    required this.dueWords,
    required this.currentWord,
    required this.currentIndex,
    required this.isFlipped,
    required this.onFlip,
    required this.onKnow,
    required this.onDontKnow,
    required this.onPlay,
  });

  final List<WordModel> dueWords;
  final WordModel? currentWord;
  final int currentIndex;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onKnow;
  final VoidCallback onDontKnow;
  final Future<void> Function(WordModel word) onPlay;

  @override
  Widget build(BuildContext context) {
    return FlashcardScreen(
      word: currentWord,
      index: currentIndex,
      total: dueWords.length,
      isFlipped: isFlipped,
      onFlip: onFlip,
      onKnow: onKnow,
      onDontKnow: onDontKnow,
      onPlay: onPlay,
      title: '今日复习',
    );
  }
}
