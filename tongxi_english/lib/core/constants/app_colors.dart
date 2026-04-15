import 'package:flutter/material.dart';

/// Anime-style color palette for 童希英语
/// 
/// Features vibrant, playful colors inspired by anime aesthetics
/// and modern mobile game UI design.
class AppColors {
  AppColors._();

  // ==================== Primary Colors ====================
  
  /// Primary purple - Main brand color (#9B59B6)
  static const Color primaryPurple = Color(0xFF9B59B6);
  
  /// Light purple - For backgrounds and highlights
  static const Color primaryPurpleLight = Color(0xFFE8D5F0);
  
  /// Dark purple - For emphasis and hover states
  static const Color primaryPurpleDark = Color(0xFF7D3C98);
  
  // ==================== Secondary Colors ====================
  
  /// Secondary pink - Accent color (#E91E63)
  static const Color secondaryPink = Color(0xFFE91E63);
  
  /// Light pink - For soft backgrounds
  static const Color secondaryPinkLight = Color(0xFFFCE4EC);
  
  /// Dark pink - For emphasis
  static const Color secondaryPinkDark = Color(0xFFC2185B);
  
  // ==================== Accent Colors ====================
  
  /// Accent yellow - For highlights and achievements (#F1C40F)
  static const Color accentYellow = Color(0xFFF1C40F);
  
  /// Light yellow - For backgrounds
  static const Color accentYellowLight = Color(0xFFFEF9E7);
  
  /// Accent cyan - For interactive elements (#00BCD4)
  static const Color accentCyan = Color(0xFF00BCD4);
  
  /// Light cyan - For soft highlights
  static const Color accentCyanLight = Color(0xFFE0F7FA);
  
  /// Accent lime - For success states (#8BC34A)
  static const Color accentLime = Color(0xFF8BC34A);
  
  /// Light lime - For success backgrounds
  static const Color accentLimeLight = Color(0xFFF1F8E9);
  
  /// Accent orange - For warnings and heat (#FF9800)
  static const Color accentOrange = Color(0xFFFF9800);
  
  /// Light orange - For warning backgrounds
  static const Color accentOrangeLight = Color(0xFFFFF3E0);
  
  // ==================== Background Colors ====================
  
  /// Light lavender background - Main app background (#F8F0FF)
  static const Color backgroundLight = Color(0xFFF8F0FF);
  
  /// White surface - Cards and elevated surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  /// Slightly darker surface - For alternating rows
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // ==================== Text Colors ====================
  
  /// Primary text - Dark gray for readability
  static const Color textPrimary = Color(0xFF2D3436);
  
  /// Secondary text - Medium gray
  static const Color textSecondary = Color(0xFF636E72);
  
  /// Tertiary text - Light gray for hints
  static const Color textHint = Color(0xFFB2BEC3);
  
  /// Disabled text
  static const Color textDisabled = Color(0xFFDFE6E9);
  
  /// Inverse text - For dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // ==================== Semantic Colors ====================
  
  /// Success green
  static const Color successGreen = Color(0xFF27AE60);
  
  /// Success light
  static const Color successGreenLight = Color(0xFFD5F4E6);
  
  /// Error red
  static const Color errorRed = Color(0xFFE74C3C);
  
  /// Error light
  static const Color errorRedLight = Color(0xFFFADBD8);
  
  /// Warning amber
  static const Color warningAmber = Color(0xFFF39C12);
  
  /// Warning light
  static const Color warningAmberLight = Color(0xFFFDEBD0);
  
  /// Info blue
  static const Color infoBlue = Color(0xFF3498DB);
  
  /// Info light
  static const Color infoBlueLight = Color(0xFFD6EAF8);
  
  // ==================== Gradient Definitions ====================
  
  /// Primary gradient - Purple to pink
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, secondaryPink],
  );
  
  /// Success gradient - Lime to cyan
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLime, accentCyan],
  );
  
  /// Warm gradient - Yellow to orange
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentYellow, accentOrange],
  );
  
  /// Cool gradient - Cyan to purple
  static const LinearGradient coolGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, primaryPurple],
  );
  
  /// Sunset gradient - Pink to orange
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryPink, accentOrange],
  );
  
  // ==================== Utility Colors ====================
  
  /// Divider color
  static const Color divider = Color(0xFFE0E0E0);
  
  /// Shadow color
  static Color shadow = const Color(0xFF9B59B6).withOpacity(0.15);
  
  /// Overlay color
  static Color overlay = Colors.black.withOpacity(0.5);
  
  /// Transparent
  static const Color transparent = Colors.transparent;
}

/// Module-specific colors for the 7 learning modules
class ModuleColors {
  ModuleColors._();
  
  /// Phonetics module - Cyan
  static const Color phonetics = AppColors.accentCyan;
  
  /// Vocabulary module - Purple
  static const Color vocabulary = AppColors.primaryPurple;
  
  /// Phrases module - Pink
  static const Color phrases = AppColors.secondaryPink;
  
  /// Grammar module - Orange
  static const Color grammar = AppColors.accentOrange;
  
  /// Reading module - Lime
  static const Color reading = AppColors.accentLime;
  
  /// Listening module - Yellow
  static const Color listening = AppColors.accentYellow;
  
  /// Translation module - Blue
  static const Color translation = AppColors.infoBlue;
}
