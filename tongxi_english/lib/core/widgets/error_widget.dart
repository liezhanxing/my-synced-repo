import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'anime_button.dart';
import 'mascot_widget.dart';

/// Error display widget with mascot and retry button
/// 
/// Features:
/// - Sad mascot character
/// - Error message display
/// - Retry button
/// - Customizable for different error types
class AppErrorWidget extends StatelessWidget {
  /// Error message
  final String message;
  
  /// Callback when retry is pressed
  final VoidCallback? onRetry;
  
  /// Error type
  final ErrorType type;
  
  /// Custom mascot expression
  final MascotExpression? mascotExpression;
  
  /// Custom action button text
  final String? actionText;

  const AppErrorWidget({
    super.key,
    this.message = AppStrings.errorGeneric,
    this.onRetry,
    this.type = ErrorType.generic,
    this.mascotExpression,
    this.actionText,
  });

  /// Network error constructor
  const AppErrorWidget.network({
    super.key,
    this.onRetry,
    this.actionText,
  })  : message = AppStrings.errorNetwork,
        type = ErrorType.network,
        mascotExpression = null;

  /// Not found error constructor
  const AppErrorWidget.notFound({
    super.key,
    this.onRetry,
    this.actionText,
  })  : message = AppStrings.errorNotFound,
        type = ErrorType.notFound,
        mascotExpression = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sad mascot
            MascotWidget(
              expression: mascotExpression ?? _getMascotExpression(),
              size: 120,
              speechText: _getErrorMessage(),
            ),
            
            const SizedBox(height: 32),
            
            // Error title
            Text(
              _getErrorTitle(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Error message
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Retry button
            if (onRetry != null)
              SizedBox(
                width: 200,
                child: AnimeButton(
                  text: actionText ?? AppStrings.retry,
                  onPressed: onRetry,
                  icon: Icons.refresh,
                ),
              ),
          ],
        ),
      ),
    );
  }

  MascotExpression _getMascotExpression() {
    switch (type) {
      case ErrorType.network:
        return MascotExpression.sad;
      case ErrorType.notFound:
        return MascotExpression.thinking;
      case ErrorType.server:
        return MascotExpression.surprised;
      case ErrorType.generic:
      default:
        return MascotExpression.sad;
    }
  }

  String _getErrorMessage() {
    switch (type) {
      case ErrorType.network:
        return '网络好像断开了...';
      case ErrorType.notFound:
        return '找不到这个内容呢';
      case ErrorType.server:
        return '服务器开小差了';
      case ErrorType.generic:
      default:
        return '出错了...';
    }
  }

  String _getErrorTitle() {
    switch (type) {
      case ErrorType.network:
        return '网络错误';
      case ErrorType.notFound:
        return '内容未找到';
      case ErrorType.server:
        return '服务器错误';
      case ErrorType.generic:
      default:
        return '出错了';
    }
  }
}

/// Error types
enum ErrorType {
  /// Generic error
  generic,
  
  /// Network error
  network,
  
  /// Not found error
  notFound,
  
  /// Server error
  server,
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  /// Empty state message
  final String message;
  
  /// Optional sub-message
  final String? subMessage;
  
  /// Optional icon
  final IconData icon;
  
  /// Optional action button
  final String? actionText;
  
  /// Callback when action is pressed
  final VoidCallback? onAction;
  
  /// Mascot expression
  final MascotExpression mascotExpression;

  const EmptyStateWidget({
    super.key,
    this.message = AppStrings.emptyState,
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
    this.mascotExpression = MascotExpression.thinking,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mascot
            MascotWidget(
              expression: mascotExpression,
              size: 100,
            ),
            
            const SizedBox(height: 24),
            
            // Icon
            Icon(
              icon,
              size: 64,
              color: AppColors.textHint,
            ),
            
            const SizedBox(height: 16),
            
            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                subMessage!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              AnimeButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Coming soon widget
class ComingSoonWidget extends StatelessWidget {
  final String? featureName;

  const ComingSoonWidget({
    super.key,
    this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Excited mascot
            const MascotWidget(
              expression: MascotExpression.excited,
              size: 120,
              speechText: '敬请期待!',
            ),
            
            const SizedBox(height: 32),
            
            // Title
            Text(
              featureName != null ? '$featureName - ${AppStrings.comingSoon}' : AppStrings.comingSoon,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Message
            const Text(
              '我们正在努力开发这个功能，很快就可以使用了!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline error message widget
class InlineErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const InlineErrorMessage({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorRedLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.errorRed,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.errorRed,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
        ],
      ),
    );
  }
}
