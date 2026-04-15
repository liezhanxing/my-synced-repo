import 'package:flutter/material.dart';

/// Extension methods on BuildContext for common operations
extension ContextExtensions on BuildContext {
  // ==================== MediaQuery ====================

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if screen is in portrait mode
  bool get isPortrait => screenSize.height > screenSize.width;

  /// Check if screen is in landscape mode
  bool get isLandscape => screenSize.width > screenSize.height;

  /// Get device pixel ratio
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Get view insets (keyboard height)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Get status bar height
  double get statusBarHeight => safeAreaPadding.top;

  /// Get bottom safe area height
  double get bottomSafeAreaHeight => safeAreaPadding.bottom;

  // ==================== Theme ====================

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get primary color
  Color get primaryColor => theme.primaryColor;

  /// Get scaffold background color
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  /// Get card color
  Color get cardColor => theme.cardColor;

  /// Get divider color
  Color get dividerColor => theme.dividerColor;

  // ==================== Navigation ====================

  /// Pop current route
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Push new route
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push replacement
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push and remove until
  Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    required RoutePredicate predicate,
  }) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  // ==================== SnackBar ====================

  /// Show snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
    );
  }

  /// Hide current snackbar
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  // ==================== Dialog ====================

  /// Show dialog
  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Show alert dialog
  Future<bool?> showAlertDialog({
    required String title,
    required String content,
    String confirmText = '确定',
    String cancelText = '取消',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show bottom sheet
  Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      builder: builder,
    );
  }

  // ==================== Focus ====================

  /// Unfocus current focus node
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus
  void requestFocus([FocusNode? node]) {
    FocusScope.of(this).requestFocus(node);
  }

  // ==================== Responsive ====================

  /// Check if screen is small (phone)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if screen is medium (tablet)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Check if screen is large (desktop)
  bool get isLargeScreen => screenWidth >= 1200;

  /// Get responsive value
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isLargeScreen && desktop != null) {
      return desktop;
    }
    if (isMediumScreen && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}

/// Extension on Widget for padding shortcuts
extension WidgetPadding on Widget {
  /// Add padding to all sides
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Add horizontal padding
  Widget paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  /// Add vertical padding
  Widget paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  /// Add symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  /// Add custom padding
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }
}

/// Extension on String for text styling
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize all words
  String capitalizeWords() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Truncate with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}
