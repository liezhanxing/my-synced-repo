import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Module-specific colors for the 7 learning modules
/// This file re-exports ModuleColors from app_colors.dart for backward compatibility
export 'app_colors.dart' show ModuleColors;

/// Extension to provide easy access to module colors
extension ModuleColorExtension on String {
  /// Get the color for a module by name
  Color get moduleColor {
    switch (toLowerCase()) {
      case 'phonetics':
        return ModuleColors.phonetics;
      case 'vocabulary':
        return ModuleColors.vocabulary;
      case 'phrases':
        return ModuleColors.phrases;
      case 'grammar':
        return ModuleColors.grammar;
      case 'reading':
        return ModuleColors.reading;
      case 'listening':
        return ModuleColors.listening;
      case 'translation':
        return ModuleColors.translation;
      default:
        return AppColors.primaryPurple;
    }
  }
}
