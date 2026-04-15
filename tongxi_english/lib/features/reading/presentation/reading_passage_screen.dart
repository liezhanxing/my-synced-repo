import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/reading_model.dart';
import 'reading_controller.dart';
import 'vocabulary_popup.dart';

/// Reading passage screen
/// 
/// Displays the passage content with tappable vocabulary words,
/// font size adjustment, reading timer, and navigation to questions.
class ReadingPassageScreen extends ConsumerStatefulWidget {
  final String passageId;

  const ReadingPassageScreen({
    super.key,
    required this.passageId,
  });

  @override
  ConsumerState<ReadingPassageScreen> createState() => _ReadingPassageScreenState();
}

class _ReadingPassageScreenState extends ConsumerState<ReadingPassageScreen> {
  final TtsService _ttsService = TtsService();
  final ScrollController _scrollController = ScrollController();
  bool _showVocabularyHint = true;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _loadPassage();
    
    // Hide vocabulary hint after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showVocabularyHint = false;
        });
      }
    });
  }

  Future<void> _initializeTts() async {
    await _ttsService.initialize();
  }

  void _loadPassage() {
    // The passage should be pre-selected by the previous screen
    // If not, we need to load it
    final currentPassage = ref.read(selectedPassageProvider);
    if (currentPassage == null || currentPassage.id != widget.passageId) {
      // Load passage logic would go here
      // For now, we'll navigate back if no passage is selected
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    } else {
      // Start reading timer
      ref.read(readingControllerProvider.notifier).startReading();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passage = ref.watch(selectedPassageProvider);
    final controller = ref.watch(readingControllerProvider);
    final controllerNotifier = ref.read(readingControllerProvider.notifier);

    if (passage == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(passage, controller, controllerNotifier),
      body: Column(
        children: [
          // Reading progress indicator
          _buildProgressIndicator(passage, controller),
          
          // Passage content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title card
                  _buildTitleCard(passage),
                  
                  const SizedBox(height: 20),
                  
                  // Passage text with vocabulary
                  _buildPassageContent(passage, controller.fontScale),
                  
                  const SizedBox(height: 32),
                  
                  // Answer questions button
                  AnimeButton(
                    text: '开始答题',
                    icon: Icons.question_answer,
                    onPressed: () {
                      controllerNotifier.pauseReading();
                      context.push('/reading/questions');
                    },
                    height: 56,
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ReadingModel passage,
    ReadingState controller,
    ReadingController controllerNotifier,
  ) {
    return AppBar(
      backgroundColor: ModuleColors.reading.withOpacity(0.1),
      foregroundColor: ModuleColors.reading,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          controllerNotifier.saveReadingProgress();
          context.pop();
        },
      ),
      title: Column(
        children: [
          Text(
            '阅读中',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ModuleColors.reading,
            ),
          ),
          Text(
            controller.formattedReadingTime,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ModuleColors.reading.withOpacity(0.7),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        // Font size controls
        PopupMenuButton<double>(
          icon: Icon(Icons.text_fields, color: ModuleColors.reading),
          tooltip: '字体大小',
          onSelected: (scale) => controllerNotifier.setFontScale(scale),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0.8,
              child: Row(
                children: [
                  Icon(Icons.text_decrease, size: 18),
                  SizedBox(width: 8),
                  Text('小'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 1.0,
              child: Row(
                children: [
                  Icon(Icons.text_fields, size: 18),
                  SizedBox(width: 8),
                  Text('中'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 1.3,
              child: Row(
                children: [
                  Icon(Icons.text_increase, size: 18),
                  SizedBox(width: 8),
                  Text('大'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProgressIndicator(ReadingModel passage, ReadingState controller) {
    return Container(
      height: 3,
      color: AppColors.divider,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          double progress = 0;
          if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
            progress = _scrollController.offset / _scrollController.position.maxScrollExtent;
            progress = progress.clamp(0.0, 1.0);
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * progress,
              color: ModuleColors.reading,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleCard(ReadingModel passage) {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(passage.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getDifficultyLabel(passage.difficulty),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getDifficultyColor(passage.difficulty),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  passage.category.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            passage.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Meta info
          Row(
            children: [
              _buildMetaItem(Icons.menu_book, '${passage.wordCount} 词'),
              const SizedBox(width: 16),
              _buildMetaItem(Icons.timer, '${passage.estimatedTime} 分钟'),
              const SizedBox(width: 16),
              _buildMetaItem(Icons.quiz, '${passage.questions.length} 题'),
            ],
          ),
          
          if (_showVocabularyHint) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentYellowLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentYellow.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: AppColors.accentYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '点击高亮词汇查看释义',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 500))
              .slideX(begin: -0.1, end: 0),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textHint,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPassageContent(ReadingModel passage, double fontScale) {
    // Build text with tappable vocabulary
    final vocabularyWords = passage.vocabulary.map((v) => v.word.toLowerCase()).toSet();
    
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: RichText(
        text: _buildTextSpan(passage.content, vocabularyWords, fontScale),
      ),
    );
  }

  TextSpan _buildTextSpan(String content, Set<String> vocabularyWords, double fontScale) {
    final List<TextSpan> spans = [];
    final words = content.split(' ');
    
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final cleanWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      
      // Check if this word is in vocabulary (handle punctuation)
      final isVocabulary = vocabularyWords.contains(cleanWord) ||
          vocabularyWords.contains(word.toLowerCase().replaceAll(RegExp(r'[^a-z\'-]'), ''));
      
      if (isVocabulary) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _showVocabulary(word),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                decoration: BoxDecoration(
                  color: ModuleColors.reading.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border(
                    bottom: BorderSide(
                      color: ModuleColors.reading,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16 * fontScale,
                    height: 1.8,
                    color: ModuleColors.reading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: word,
            style: TextStyle(
              fontSize: 16 * fontScale,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }
      
      // Add space after each word except the last
      if (i < words.length - 1) {
        spans.add(
          TextSpan(
            text: ' ',
            style: TextStyle(
              fontSize: 16 * fontScale,
              height: 1.8,
            ),
          ),
        );
      }
    }
    
    return TextSpan(children: spans);
  }

  void _showVocabulary(String word) {
    final passage = ref.read(selectedPassageProvider);
    if (passage == null) return;
    
    // Find vocabulary item
    final cleanWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z\'-]'), '');
    final vocab = passage.vocabulary.firstWhere(
      (v) => v.word.toLowerCase() == cleanWord || 
             v.word.toLowerCase() == word.toLowerCase().replaceAll(RegExp(r'[^a-z\'-]'), ''),
      orElse: () => passage.vocabulary.first,
    );
    
    showVocabularyPopup(
      context,
      vocabulary: vocab,
      onSpeak: () => _ttsService.speak(vocab.word),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return AppColors.successGreen;
      case 2:
        return AppColors.accentOrange;
      case 3:
        return AppColors.errorRed;
      default:
        return AppColors.primaryPurple;
    }
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return '高一 · 简单';
      case 2:
        return '高二 · 中等';
      case 3:
        return '高三 · 困难';
      default:
        return '未知';
    }
  }
}
