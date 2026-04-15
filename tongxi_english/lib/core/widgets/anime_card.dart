import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Anime-style card with soft shadow and optional gradient border
/// 
/// Features:
/// - Soft anime-style shadow
/// - Rounded corners
/// - Optional gradient border
/// - Hover/tap animations
class AnimeCard extends StatelessWidget {
  /// Card content
  final Widget child;
  
  /// Optional gradient border
  final Gradient? borderGradient;
  
  /// Card background color
  final Color? backgroundColor;
  
  /// Border radius
  final double? borderRadius;
  
  /// Padding inside card
  final EdgeInsets? padding;
  
  /// Margin around card
  final EdgeInsets? margin;
  
  /// Shadow elevation
  final double? elevation;
  
  /// Callback when tapped
  final VoidCallback? onTap;
  
  /// Card height
  final double? height;
  
  /// Card width
  final double? width;
  
  /// Whether to show gradient border
  final bool showGradientBorder;

  const AnimeCard({
    super.key,
    required this.child,
    this.borderGradient,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.elevation,
    this.onTap,
    this.height,
    this.width,
    this.showGradientBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.cardBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.08),
            blurRadius: elevation ?? 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.04),
            blurRadius: elevation != null ? elevation! * 2 : 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: child,
    );

    // Add gradient border if requested
    if (showGradientBorder || borderGradient != null) {
      cardContent = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: borderGradient ?? AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
            (borderRadius ?? AppSizes.cardBorderRadius) + 2,
          ),
        ),
        child: Container(
          height: height != null ? height! - 4 : null,
          width: width != null ? width! - 4 : null,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSizes.cardBorderRadius,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
          child: child,
        ),
      );
    }

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSizes.cardBorderRadius,
          ),
          child: cardContent,
        ),
      );
    }

    return Container(
      margin: margin,
      child: cardContent,
    );
  }
}

/// Module card for the home screen
class ModuleCard extends StatelessWidget {
  /// Module name
  final String title;
  
  /// Module description
  final String subtitle;
  
  /// Module icon
  final IconData icon;
  
  /// Module color
  final Color color;
  
  /// Progress percentage (0-100)
  final double progress;
  
  /// Callback when tapped
  final VoidCallback? onTap;

  const ModuleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.progress = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          
          // Progress text
          Text(
            '${progress.toInt()}% 完成',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat card for displaying statistics
class StatCard extends StatelessWidget {
  /// Stat value
  final String value;
  
  /// Stat label
  final String label;
  
  /// Stat icon
  final IconData icon;
  
  /// Card color
  final Color color;
  
  /// Optional trend indicator
  final String? trend;
  
  /// Whether trend is positive
  final bool isPositiveTrend;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimeCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (trend != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPositiveTrend
                    ? AppColors.successGreen.withOpacity(0.1)
                    : AppColors.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                    color: isPositiveTrend
                        ? AppColors.successGreen
                        : AppColors.errorRed,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPositiveTrend
                          ? AppColors.successGreen
                          : AppColors.errorRed,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
