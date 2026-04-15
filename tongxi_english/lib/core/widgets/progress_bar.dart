import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Animated progress bar with gradient fill
/// 
/// Features:
/// - Animated fill transition
/// - Gradient colors
/// - Optional percentage label
/// - Customizable height and border radius
class AnimatedProgressBar extends StatelessWidget {
  /// Progress value (0.0 to 1.0)
  final double progress;
  
  /// Bar height
  final double height;
  
  /// Bar gradient
  final Gradient? gradient;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border radius
  final double borderRadius;
  
  /// Whether to show percentage label
  final bool showLabel;
  
  /// Label style
  final TextStyle? labelStyle;
  
  /// Animation duration
  final Duration animationDuration;
  
  /// Optional label text
  final String? labelText;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = AppSizes.progressBarHeight,
    this.gradient,
    this.backgroundColor,
    this.borderRadius = AppSizes.progressBarRadius,
    this.showLabel = false,
    this.labelStyle,
    this.animationDuration = const Duration(milliseconds: 800),
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final barGradient = gradient ?? AppColors.primaryGradient;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.divider,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            children: [
              // Animated fill
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * clampedProgress,
                    decoration: BoxDecoration(
                      gradient: barGradient,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: barGradient.colors.first.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .width(
                        duration: animationDuration,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
              
              // Shine effect
              if (clampedProgress > 0.1)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .shimmer(
                        duration: const Duration(seconds: 2),
                        color: Colors.white.withOpacity(0.3),
                      ),
                ),
            ],
          ),
        ),
        
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            labelText ?? '${(clampedProgress * 100).toInt()}%',
            style: labelStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}

/// Circular progress indicator with anime style
class AnimeCircularProgress extends StatelessWidget {
  /// Progress value (0.0 to 1.0)
  final double progress;
  
  /// Size of the indicator
  final double size;
  
  /// Stroke width
  final double strokeWidth;
  
  /// Progress gradient
  final Gradient? gradient;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Whether to show percentage in center
  final bool showPercentage;
  
  /// Center text style
  final TextStyle? centerTextStyle;

  const AnimeCircularProgress({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 8,
    this.gradient,
    this.backgroundColor,
    this.showPercentage = true,
    this.centerTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor ?? AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
          ),
          
          // Progress arc with gradient
          ShaderMask(
            shaderCallback: (bounds) {
              return (gradient ?? AppColors.primaryGradient).createShader(bounds);
            },
            child: CircularProgressIndicator(
              value: clampedProgress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            )
                .animate()
                .rotate(
                  duration: const Duration(seconds: 20),
                  begin: 0,
                  end: 1,
                ),
          ),
          
          // Center percentage
          if (showPercentage)
            Center(
              child: Text(
                '${(clampedProgress * 100).toInt()}%',
                style: centerTextStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

/// XP progress bar with level indicator
class XpProgressBar extends StatelessWidget {
  /// Current XP
  final int currentXp;
  
  /// XP needed for next level
  final int xpForNextLevel;
  
  /// Current level
  final int level;
  
  /// Bar height
  final double height;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.level,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXp / xpForNextLevel;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Lv.$level',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            
            // XP text
            Text(
              '$currentXp / $xpForNextLevel XP',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AnimatedProgressBar(
          progress: progress,
          height: height,
          gradient: AppColors.warmGradient,
          borderRadius: height / 2,
        ),
      ],
    );
  }
}

/// Daily goal progress widget
class DailyGoalProgress extends StatelessWidget {
  /// Current progress
  final int current;
  
  /// Daily goal target
  final int goal;
  
  /// Goal label
  final String label;

  const DailyGoalProgress({
    super.key,
    required this.current,
    required this.goal,
    this.label = '今日目标',
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / goal).clamp(0.0, 1.0);
    final isCompleted = current >= goal;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isCompleted ? AppColors.successGradient : null,
        color: isCompleted ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isCompleted ? AppColors.accentLime : AppColors.primaryPurple)
                .withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.white : AppColors.textPrimary,
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AnimatedProgressBar(
                  progress: progress,
                  height: 8,
                  gradient: isCompleted
                      ? const LinearGradient(
                          colors: [Colors.white, Colors.white70],
                        )
                      : AppColors.successGradient,
                  backgroundColor: isCompleted
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.accentLimeLight,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$current/$goal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.white : AppColors.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
