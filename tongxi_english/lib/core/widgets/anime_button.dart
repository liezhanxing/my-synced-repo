import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Anime-style elevated button with gradient background and bounce animation
/// 
/// Features:
/// - Gradient background (customizable)
/// - Rounded corners with anime-style shadows
/// - Bounce animation on tap
/// - Optional icon support
class AnimeButton extends StatefulWidget {
  /// Button text
  final String text;
  
  /// Callback when pressed
  final VoidCallback? onPressed;
  
  /// Optional icon
  final IconData? icon;
  
  /// Custom gradient (defaults to primary gradient)
  final Gradient? gradient;
  
  /// Custom text color
  final Color? textColor;
  
  /// Button height
  final double? height;
  
  /// Whether button is in loading state
  final bool isLoading;
  
  /// Whether button is disabled
  final bool isDisabled;
  
  /// Custom padding
  final EdgeInsets? padding;
  
  /// Border radius
  final double? borderRadius;
  
  /// Shadow elevation
  final double? elevation;

  const AnimeButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.gradient,
    this.textColor,
    this.height,
    this.isLoading = false,
    this.isDisabled = false,
    this.padding,
    this.borderRadius,
    this.elevation,
  });

  @override
  State<AnimeButton> createState() => _AnimeButtonState();
}

class _AnimeButtonState extends State<AnimeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || widget.isLoading;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.05);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              height: widget.height ?? AppSizes.buttonHeightMd,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppSizes.buttonHorizontalPadding,
                  ),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? LinearGradient(
                        colors: [
                          Colors.grey.shade400,
                          Colors.grey.shade500,
                        ],
                      )
                    : (widget.gradient ?? AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppSizes.buttonBorderRadius,
                ),
                boxShadow: isDisabled
                    ? []
                    : [
                        BoxShadow(
                          color: (widget.gradient?.colors.first ??
                                  AppColors.primaryPurple)
                              .withOpacity(0.4),
                          blurRadius: widget.elevation ?? 8,
                          offset: Offset(0, _isPressed ? 2 : 4),
                          spreadRadius: _isPressed ? 0 : 1,
                        ),
                      ],
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.textColor ?? Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.textColor ?? Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: const Duration(seconds: 3),
          color: Colors.white.withOpacity(0.1),
        );
  }
}

/// Secondary anime-style button with outline
class AnimeOutlinedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final bool isLoading;
  final bool isDisabled;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AnimeOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
    this.height,
    this.isLoading = false,
    this.isDisabled = false,
    this.padding,
    this.borderRadius,
  });

  @override
  State<AnimeOutlinedButton> createState() => _AnimeOutlinedButtonState();
}

class _AnimeOutlinedButtonState extends State<AnimeOutlinedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || widget.isLoading;
    final color = widget.borderColor ?? AppColors.primaryPurple;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.05);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              height: widget.height ?? AppSizes.buttonHeightMd,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppSizes.buttonHorizontalPadding,
                  ),
              decoration: BoxDecoration(
                color: _isPressed ? color.withOpacity(0.1) : Colors.transparent,
                border: Border.all(
                  color: isDisabled ? Colors.grey.shade400 : color,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? AppSizes.buttonBorderRadius,
                ),
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDisabled ? Colors.grey : color,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: isDisabled
                                  ? Colors.grey
                                  : (widget.textColor ?? color),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: isDisabled
                                  ? Colors.grey
                                  : (widget.textColor ?? color),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
