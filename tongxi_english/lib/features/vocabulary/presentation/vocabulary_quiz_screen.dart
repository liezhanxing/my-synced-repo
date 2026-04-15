import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../domain/vocabulary_models.dart';

class VocabularyQuizScreen extends StatefulWidget {
  const VocabularyQuizScreen({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.score,
    required this.spellingAnswer,
    required this.completed,
    required this.onSelectOption,
    required this.onSpellingChanged,
    required this.onSubmitSpelling,
    required this.onRestart,
  });

  final VocabularyQuizQuestion? question;
  final int index;
  final int total;
  final int score;
  final String spellingAnswer;
  final bool completed;
  final Future<void> Function(String answer) onSelectOption;
  final ValueChanged<String> onSpellingChanged;
  final Future<void> Function() onSubmitSpelling;
  final VoidCallback onRestart;

  @override
  State<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.spellingAnswer);
  }

  @override
  void didUpdateWidget(covariant VocabularyQuizScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spellingAnswer != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.spellingAnswer,
        selection: TextSelection.collapsed(offset: widget.spellingAnswer.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.completed) {
      final accuracy = widget.total == 0 ? 0 : (widget.score / widget.total * 100).round();
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimeCard(
            showGradientBorder: true,
            borderGradient: accuracy >= 80 ? AppColors.successGradient : AppColors.warmGradient,
            child: Column(
              children: [
                MascotWidget(
                  expression: accuracy >= 80 ? MascotExpression.celebrating : MascotExpression.excited,
                  size: 108,
                  speechText: accuracy >= 80 ? '词汇拿捏住啦！' : '再来一轮，记忆会更稳！',
                ),
                const SizedBox(height: 12),
                Text(
                  '测验得分 ${widget.score} / ${widget.total}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '正确率：$accuracy%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                AnimeButton(
                  text: '重新出题',
                  icon: Icons.refresh_rounded,
                  onPressed: widget.onRestart,
                ),
              ],
            ),
          ).animate().fadeIn().scale(),
        ],
      );
    }

    if (widget.question == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '词汇测验',
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
                color: AppColors.primaryPurpleLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${widget.index + 1}/${widget.total}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryPurpleDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        MascotWidget(
          expression: widget.question!.type == VocabularyQuizType.spelling
              ? MascotExpression.thinking
              : MascotExpression.happy,
          size: 90,
          speechText: widget.question!.type == VocabularyQuizType.spelling
              ? '拼写题更考验细节哦！'
              : '先看题，再快速判断！',
        ),
        const SizedBox(height: 14),
        AnimeCard(
          showGradientBorder: true,
          borderGradient: AppColors.primaryGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question!.prompt,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '当前得分：${widget.score}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (widget.question!.type == VocabularyQuizType.spelling)
          AnimeCard(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: '请输入英文单词',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: widget.onSpellingChanged,
                  controller: _controller,
                ),
                Text(
                  widget.spellingAnswer.isEmpty
                      ? '先输入你记得的拼写，再点击提交。'
                      : '当前输入：${widget.spellingAnswer}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                AnimeButton(
                  text: '提交拼写',
                  icon: Icons.spellcheck_rounded,
                  onPressed: widget.onSubmitSpelling,
                ),
              ],
            ),
          )
        else
          ...widget.question!.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimeCard(
                onTap: () => widget.onSelectOption(option),
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ).animate().fadeIn(),
            ),
          ),
      ],
    );
  }
}
