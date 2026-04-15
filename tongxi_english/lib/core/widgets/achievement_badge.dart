import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';

/// Achievement badge widget for displaying unlocked achievements
/// 
/// Features:
/// - Circular badge with icon
/// - Rarity-based colors (bronze, silver, gold, platinum)
/// - Unlock animation
/// - Progress indicator for locked achievements
class AchievementBadge extends StatelessWidget {
  /// Achievement name
  final String name;
  
  /// Achievement description
  final String description;
  
  /// Badge icon
  final IconData icon;
  
  /// Badge rarity
  final BadgeRarity rarity;
  
  /// Whether achievement is unlocked
  final bool isUnlocked;
  
  /// Unlock progress (0.0 to 1.0)
  final double progress;
  
  /// Unlock date (if unlocked)
  final DateTime? unlockDate;
  
  /// Badge size
  final double size;
  
  /// Whether to show details
  final bool showDetails;
  
  /// Callback when tapped
  final VoidCallback? onTap;
  
  /// Whether to animate unlock
  final bool animateUnlock;

  const AchievementBadge({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.rarity = BadgeRarity.bronze,
    this.isUnlocked = false,
    this.progress = 0,
    this.unlockDate,
    this.size = 80,
    this.showDetails = true,
    this.onTap,
    this.animateUnlock = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget badge = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge icon
        GestureDetector(
          onTap: onTap,
          child: _buildBadgeIcon()
              .animate(target: isUnlocked && animateUnlock ? 1 : 0)
              .scale(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
              )
              .shake(duration: const Duration(milliseconds: 500)),
        ),
        
        if (showDetails) ...[
          const SizedBox(height: 8),
          
          // Achievement name
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? AppColors.textPrimary : AppColors.textHint,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Progress indicator (if not unlocked)
          if (!isUnlocked && progress > 0) ...[
            const SizedBox(height: 4),
            SizedBox(
              width: size * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rarity.color.withOpacity(0.5),
                  ),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 10,
                color: rarity.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ],
    );

    return badge;
  }

  Widget _buildBadgeIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isUnlocked ? rarity.gradient : null,
        color: isUnlocked ? null : Colors.grey.shade300,
        shape: BoxShape.circle,
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: rarity.color.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
        border: !isUnlocked
            ? Border.all(
                color: Colors.grey.shade400,
                width: 2,
              )
            : null,
      ),
      child: Center(
        child: isUnlocked
            ? Icon(
                icon,
                color: Colors.white,
                size: size * 0.4,
              )
            : Icon(
                Icons.lock,
                color: Colors.grey.shade500,
                size: size * 0.3,
              ),
      ),
    );
  }
}

/// Badge rarity levels
enum BadgeRarity {
  /// Common - Bronze
  bronze,
  
  /// Uncommon - Silver
  silver,
  
  /// Rare - Gold
  gold,
  
  /// Epic - Platinum
  platinum,
  
  /// Legendary - Rainbow
  legendary,
}

/// Extension for badge rarity properties
extension BadgeRarityExtension on BadgeRarity {
  /// Get color for rarity
  Color get color {
    switch (this) {
      case BadgeRarity.bronze:
        return const Color(0xFFCD7F32);
      case BadgeRarity.silver:
        return const Color(0xFFC0C0C0);
      case BadgeRarity.gold:
        return const Color(0xFFFFD700);
      case BadgeRarity.platinum:
        return const Color(0xFFE5E4E2);
      case BadgeRarity.legendary:
        return AppColors.primaryPurple;
    }
  }

  /// Get gradient for rarity
  Gradient get gradient {
    switch (this) {
      case BadgeRarity.bronze:
        return const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFFA0522D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case BadgeRarity.silver:
        return const LinearGradient(
          colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case BadgeRarity.gold:
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case BadgeRarity.platinum:
        return const LinearGradient(
          colors: [Color(0xFFE5E4E2), Color(0xFFB0B0B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case BadgeRarity.legendary:
        return AppColors.primaryGradient;
    }
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case BadgeRarity.bronze:
        return '青铜';
      case BadgeRarity.silver:
        return '白银';
      case BadgeRarity.gold:
        return '黄金';
      case BadgeRarity.platinum:
        return '白金';
      case BadgeRarity.legendary:
        return '传说';
    }
  }
}

/// Achievement unlock dialog
class AchievementUnlockDialog extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final BadgeRarity rarity;

  const AchievementUnlockDialog({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.rarity,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: rarity.color.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Achievement badge
            AchievementBadge(
              name: name,
              description: description,
              icon: icon,
              rarity: rarity,
              isUnlocked: true,
              size: 100,
              showDetails: false,
              animateUnlock: true,
            ),
            
            const SizedBox(height: 20),
            
            // Title
            const Text(
              '成就解锁!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Achievement name
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: rarity.color,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Rarity tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: rarity.gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rarity.displayName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rarity.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '太棒了!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Achievement grid for displaying multiple achievements
class AchievementGrid extends StatelessWidget {
  final List<AchievementBadge> achievements;
  final int crossAxisCount;

  const AchievementGrid({
    super.key,
    required this.achievements,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return achievements[index]
            .animate(delay: Duration(milliseconds: index * 50))
            .fadeIn()
            .slideY(begin: 0.2, end: 0);
      },
    );
  }
}
