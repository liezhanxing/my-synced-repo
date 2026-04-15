import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/module_colors.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/anime_card.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../models/listening_model.dart';
import 'listening_controller.dart';

/// Listening player screen
/// 
/// Audio playback screen with custom player UI, speed control,
/// transcript toggle, and navigation to questions/dictation.
class ListeningPlayerScreen extends ConsumerStatefulWidget {
  final String exerciseId;

  const ListeningPlayerScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  ConsumerState<ListeningPlayerScreen> createState() => _ListeningPlayerScreenState();
}

class _ListeningPlayerScreenState extends ConsumerState<ListeningPlayerScreen> {
  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  void _loadExercise() {
    // The exercise should be pre-selected by the previous screen
    final currentExercise = ref.read(selectedExerciseProvider);
    if (currentExercise == null || currentExercise.id != widget.exerciseId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(selectedExerciseProvider);
    final controller = ref.watch(listeningControllerProvider);
    final controllerNotifier = ref.read(listeningControllerProvider.notifier);

    if (exercise == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: ModuleColors.listening.withOpacity(0.1),
        foregroundColor: ModuleColors.listening,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            controllerNotifier.saveListeningProgress();
            context.pop();
          },
        ),
        title: Text(
          exercise.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ModuleColors.listening,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          // Transcript toggle
          IconButton(
            icon: Icon(
              controller.showTranscript ? Icons.article : Icons.article_outlined,
              color: controller.showTranscript ? ModuleColors.listening : null,
            ),
            tooltip: '显示文本',
            onPressed: controllerNotifier.toggleTranscript,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(controller),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Exercise info card
                  _buildExerciseInfoCard(exercise),
                  
                  const SizedBox(height: 24),
                  
                  // Player controls
                  _buildPlayerControls(controller, controllerNotifier),
                  
                  const SizedBox(height: 24),
                  
                  // Speed control
                  _buildSpeedControl(controller, controllerNotifier),
                  
                  const SizedBox(height: 24),
                  
                  // Transcript (if shown)
                  if (controller.showTranscript)
                    _buildTranscriptCard(exercise),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  _buildActionButtons(context, controllerNotifier),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ListeningState controller) {
    return Column(
      children: [
        // Progress bar
        Container(
          height: 4,
          color: AppColors.divider,
          child: AnimatedBuilder(
            animation: AlwaysStoppedAnimation(controller.progressPercentage),
            builder: (context, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * controller.progressPercentage,
                  decoration: BoxDecoration(
                    color: ModuleColors.listening,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Time display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.formattedCurrentTime,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ModuleColors.listening,
                ),
              ),
              Text(
                controller.formattedTotalTime,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseInfoCard(ListeningModel exercise) {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(exercise.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getDifficultyLabel(exercise.difficulty),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getDifficultyColor(exercise.difficulty),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exercise.category.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            exercise.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Stats
          Row(
            children: [
              _buildInfoItem(Icons.timer, _formatDuration(exercise.duration)),
              const SizedBox(width: 16),
              _buildInfoItem(Icons.people, '${exercise.speakerCount} 人对话'),
              const SizedBox(width: 16),
              _buildInfoItem(Icons.record_voice_over, exercise.accent),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exercise.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildInfoItem(IconData icon, String text) {
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

  Widget _buildPlayerControls(ListeningState controller, ListeningController controllerNotifier) {
    return AnimeCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Mascot visualization
          MascotWidget(
            expression: controller.isPlaying 
                ? MascotExpression.excited 
                : MascotExpression.happy,
            size: 80,
            animate: controller.isPlaying,
          ),
          
          const SizedBox(height: 24),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind button
              _buildControlButton(
                icon: Icons.replay_10,
                onPressed: () {
                  controllerNotifier.seekTo(
                    controller.currentPositionSeconds - 10,
                  );
                },
                size: 48,
                iconSize: 24,
              ),
              
              const SizedBox(width: 20),
              
              // Play/Pause button
              GestureDetector(
                onTap: () {
                  if (controller.isPlaying) {
                    controllerNotifier.pause();
                  } else if (controller.isPaused) {
                    controllerNotifier.resume();
                  } else {
                    controllerNotifier.play();
                  }
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ModuleColors.listening, AppColors.accentOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ModuleColors.listening.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    controller.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Forward button
              _buildControlButton(
                icon: Icons.forward_10,
                onPressed: () {
                  controllerNotifier.seekTo(
                    controller.currentPositionSeconds + 10,
                  );
                },
                size: 48,
                iconSize: 24,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Status text
          Text(
            controller.isPlaying 
                ? '正在播放...' 
                : controller.isPaused 
                    ? '已暂停' 
                    : '点击播放开始听力',
            style: TextStyle(
              fontSize: 14,
              color: controller.isPlaying 
                  ? ModuleColors.listening 
                  : AppColors.textSecondary,
              fontWeight: controller.isPlaying ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 48,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.textSecondary,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildSpeedControl(ListeningState controller, ListeningController controllerNotifier) {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5];
    final labels = ['0.5x', '0.75x', '1.0x', '1.25x', '1.5x'];
    
    return AnimeCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              const Text(
                '播放速度',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Speed buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(speeds.length, (index) {
              final speed = speeds[index];
              final label = labels[index];
              final isSelected = controller.playbackSpeed == speed;
              
              return GestureDetector(
                onTap: () => controllerNotifier.setPlaybackSpeed(speed),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? ModuleColors.listening 
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard(ListeningModel exercise) {
    return AnimeCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.article,
                size: 18,
                color: ModuleColors.listening,
              ),
              const SizedBox(width: 8),
              const Text(
                '听力原文',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Transcript text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              exercise.transcript,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButtons(BuildContext context, ListeningController controllerNotifier) {
    return Column(
      children: [
        // Start questions button
        AnimeButton(
          text: '开始答题',
          icon: Icons.question_answer,
          onPressed: () {
            controllerNotifier.startAnsweringQuestions();
            context.push('/listening/questions');
          },
          height: 54,
          gradient: LinearGradient(
            colors: [ModuleColors.listening, AppColors.accentOrange],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Start dictation button
        AnimeOutlinedButton(
          text: '听写练习',
          icon: Icons.edit_note,
          onPressed: () {
            controllerNotifier.startDictation();
            context.push('/listening/dictation');
          },
          height: 54,
          borderColor: ModuleColors.listening,
          textColor: ModuleColors.listening,
        ),
      ],
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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (remainingSeconds == 0) {
      return '$minutes分钟';
    }
    return '$minutes分${remainingSeconds}秒';
  }
}
