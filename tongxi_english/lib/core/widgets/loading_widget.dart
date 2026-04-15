import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Shimmer loading placeholder widget
/// 
/// Features:
/// - Shimmer effect animation
/// - Multiple placeholder shapes (box, circle, line)
/// - Customizable colors and sizes
class LoadingWidget extends StatelessWidget {
  /// Width of the placeholder
  final double? width;
  
  /// Height of the placeholder
  final double? height;
  
  /// Border radius
  final double borderRadius;
  
  /// Shape type
  final LoadingShape shape;
  
  /// Base color for shimmer
  final Color? baseColor;
  
  /// Highlight color for shimmer
  final Color? highlightColor;

  const LoadingWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppSizes.radiusMd,
    this.shape = LoadingShape.box,
    this.baseColor,
    this.highlightColor,
  });

  /// Create a loading line
  const LoadingWidget.line({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = AppSizes.radiusSm,
    this.baseColor,
    this.highlightColor,
  }) : shape = LoadingShape.line;

  /// Create a loading circle
  const LoadingWidget.circle({
    super.key,
    this.width = 48,
    this.height = 48,
    this.borderRadius = 0,
    this.baseColor,
    this.highlightColor,
  }) : shape = LoadingShape.circle;

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? AppColors.divider;
    final effectiveHighlightColor = highlightColor ?? Colors.white;

    return Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBaseColor,
          borderRadius: BorderRadius.circular(
            shape == LoadingShape.circle ? 999 : borderRadius,
          ),
          shape: shape == LoadingShape.circle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

/// Loading shape types
enum LoadingShape {
  /// Rectangular box
  box,
  
  /// Circular shape
  circle,
  
  /// Horizontal line
  line,
}

/// Card loading placeholder
class CardLoadingPlaceholder extends StatelessWidget {
  final double? height;

  const CardLoadingPlaceholder({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            children: [
              const LoadingWidget.circle(width: 48, height: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoadingWidget.line(height: 16),
                    const SizedBox(height: 8),
                    LoadingWidget.line(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Content lines
          const LoadingWidget.line(height: 14),
          const SizedBox(height: 8),
          const LoadingWidget.line(height: 14),
          const SizedBox(height: 8),
          LoadingWidget.line(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 14,
          ),
        ],
      ),
    );
  }
}

/// List loading placeholder
class ListLoadingPlaceholder extends StatelessWidget {
  final int itemCount;

  const ListLoadingPlaceholder({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const CardLoadingPlaceholder();
      },
    );
  }
}

/// Grid loading placeholder
class GridLoadingPlaceholder extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;

  const GridLoadingPlaceholder({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const LoadingWidget(
          borderRadius: AppSizes.cardBorderRadius,
        );
      },
    );
  }
}

/// Full screen loading overlay
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const FullScreenLoading({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Pull to refresh loading indicator
class PullToRefreshIndicator extends StatelessWidget {
  final double progress;

  const PullToRefreshIndicator({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: progress < 1.0 ? progress : null,
            strokeWidth: 2,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
          ),
        ),
      ),
    );
  }
}
