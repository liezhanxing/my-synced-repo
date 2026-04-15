import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Main scaffold with bottom navigation bar
/// 
/// Contains 5 tabs: Home, Learn, Practice, Progress, Profile
/// Uses GoRouter's StatefulShellRoute for navigation state preservation
class MainScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: AppStrings.navHome,
                  index: 0,
                  isSelected: navigationShell.currentIndex == 0,
                  onTap: () => _onTap(context, 0),
                ),
                _buildNavItem(
                  icon: Icons.menu_book_rounded,
                  label: AppStrings.navLearn,
                  index: 1,
                  isSelected: navigationShell.currentIndex == 1,
                  onTap: () => _onTap(context, 1),
                ),
                _buildCenterButton(
                  onTap: () => _onTap(context, 2),
                  isSelected: navigationShell.currentIndex == 2,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart_rounded,
                  label: AppStrings.navProgress,
                  index: 3,
                  isSelected: navigationShell.currentIndex == 3,
                  onTap: () => _onTap(context, 3),
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: AppStrings.navProfile,
                  index: 4,
                  isSelected: navigationShell.currentIndex == 4,
                  onTap: () => _onTap(context, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryPurple : AppColors.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryPurple : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildCenterButton({
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.fitness_center_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1));
  }
}
