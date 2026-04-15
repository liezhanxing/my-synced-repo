import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';

/// Mascot expression types
enum MascotExpression {
  /// Default happy expression
  happy,
  
  /// Thinking/examining
  thinking,
  
  /// Celebrating success
  celebrating,
  
  /// Sad/disappointed
  sad,
  
  /// Surprised
  surprised,
  
  /// Sleeping/resting
  sleeping,
  
  /// Excited
  excited,
}

/// Mascot widget for displaying character with different expressions
/// 
/// Features:
/// - Multiple expressions (happy, thinking, celebrating, sad, etc.)
/// - Animated transitions between expressions
/// - Speech bubble support
/// - Customizable size
class MascotWidget extends StatelessWidget {
  /// Current expression
  final MascotExpression expression;
  
  /// Widget size
  final double size;
  
  /// Optional speech bubble text
  final String? speechText;
  
  /// Whether to show animation
  final bool animate;
  
  /// Background color
  final Color? backgroundColor;

  const MascotWidget({
    super.key,
    this.expression = MascotExpression.happy,
    this.size = 120,
    this.speechText,
    this.animate = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speech bubble
        if (speechText != null)
          _buildSpeechBubble()
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 300))
              .slideY(begin: 0.2, end: 0),
        
        if (speechText != null) const SizedBox(height: 12),
        
        // Mascot character
        _buildMascot()
            .animate(target: animate ? 1 : 0)
            .shake(duration: const Duration(seconds: 2)),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        speechText!,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMascot() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: _getBackgroundGradient(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getPrimaryColor().withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: _buildFace(),
      ),
    );
  }

  Widget _buildFace() {
    switch (expression) {
      case MascotExpression.happy:
        return _buildHappyFace();
      case MascotExpression.thinking:
        return _buildThinkingFace();
      case MascotExpression.celebrating:
        return _buildCelebratingFace();
      case MascotExpression.sad:
        return _buildSadFace();
      case MascotExpression.surprised:
        return _buildSurprisedFace();
      case MascotExpression.sleeping:
        return _buildSleepingFace();
      case MascotExpression.excited:
        return _buildExcitedFace();
    }
  }

  Widget _buildHappyFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Eyes
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(isHappy: true),
            SizedBox(width: size * 0.15),
            _buildEye(isHappy: true),
          ],
        ),
        SizedBox(height: size * 0.1),
        // Smile
        Container(
          width: size * 0.4,
          height: size * 0.2,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThinkingFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Eyes (one closed, one open)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(isClosed: true),
            SizedBox(width: size * 0.15),
            _buildEye(),
          ],
        ),
        SizedBox(height: size * 0.1),
        // Small mouth
        Container(
          width: size * 0.15,
          height: size * 0.05,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Thought bubble indicator
        Positioned(
          top: 0,
          right: 0,
          child: Icon(
            Icons.lightbulb,
            color: AppColors.accentYellow,
            size: size * 0.25,
          ),
        ),
      ],
    );
  }

  Widget _buildCelebratingFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star eyes
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.white, size: size * 0.2),
            SizedBox(width: size * 0.15),
            Icon(Icons.star, color: Colors.white, size: size * 0.2),
          ],
        ),
        SizedBox(height: size * 0.1),
        // Big smile
        Container(
          width: size * 0.5,
          height: size * 0.25,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSadFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Eyes (looking down)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(isSad: true),
            SizedBox(width: size * 0.15),
            _buildEye(isSad: true),
          ],
        ),
        SizedBox(height: size * 0.15),
        // Frown
        Transform.rotate(
          angle: 3.14,
          child: Container(
            width: size * 0.3,
            height: size * 0.15,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSurprisedFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wide eyes
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(isSurprised: true),
            SizedBox(width: size * 0.15),
            _buildEye(isSurprised: true),
          ],
        ),
        SizedBox(height: size * 0.1),
        // O mouth
        Container(
          width: size * 0.2,
          height: size * 0.25,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepingFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Closed eyes with Zzz
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(isClosed: true),
            SizedBox(width: size * 0.15),
            _buildEye(isClosed: true),
          ],
        ),
        SizedBox(height: size * 0.1),
        // Small peaceful mouth
        Container(
          width: size * 0.1,
          height: size * 0.05,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildExcitedFace() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Happy eyes with sparkles
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(isHappy: true),
            SizedBox(width: size * 0.15),
            _buildEye(isHappy: true),
          ],
        ),
        SizedBox(height: size * 0.1),
        // Big open smile
        Container(
          width: size * 0.45,
          height: size * 0.3,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Container(
              width: size * 0.25,
              height: size * 0.15,
              decoration: BoxDecoration(
                color: AppColors.secondaryPink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEye({
    bool isHappy = false,
    bool isSad = false,
    bool isSurprised = false,
    bool isClosed = false,
  }) {
    if (isClosed) {
      return Container(
        width: size * 0.18,
        height: size * 0.05,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    if (isSurprised) {
      return Container(
        width: size * 0.22,
        height: size * 0.25,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: size * 0.1,
            height: size * 0.15,
            decoration: const BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Container(
      width: size * 0.18,
      height: isHappy ? size * 0.12 : size * 0.22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isHappy ? 8 : 12),
      ),
      child: isSad
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size * 0.08,
                height: size * 0.12,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : Center(
              child: Container(
                width: size * 0.08,
                height: size * 0.12,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }

  Gradient _getBackgroundGradient() {
    switch (expression) {
      case MascotExpression.happy:
        return AppColors.primaryGradient;
      case MascotExpression.thinking:
        return AppColors.coolGradient;
      case MascotExpression.celebrating:
        return AppColors.successGradient;
      case MascotExpression.sad:
        return const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
        );
      case MascotExpression.surprised:
        return AppColors.warmGradient;
      case MascotExpression.sleeping:
        return const LinearGradient(
          colors: [Color(0xFF9B59B6), Color(0xFF3498DB)],
        );
      case MascotExpression.excited:
        return AppColors.sunsetGradient;
    }
  }

  Color _getPrimaryColor() {
    switch (expression) {
      case MascotExpression.happy:
        return AppColors.primaryPurple;
      case MascotExpression.thinking:
        return AppColors.accentCyan;
      case MascotExpression.celebrating:
        return AppColors.accentLime;
      case MascotExpression.sad:
        return Colors.grey;
      case MascotExpression.surprised:
        return AppColors.accentOrange;
      case MascotExpression.sleeping:
        return AppColors.primaryPurple;
      case MascotExpression.excited:
        return AppColors.secondaryPink;
    }
  }
}

/// Animated mascot that responds to user actions
class AnimatedMascot extends StatefulWidget {
  final double size;
  final String? initialMessage;

  const AnimatedMascot({
    super.key,
    this.size = 120,
    this.initialMessage,
  });

  @override
  State<AnimatedMascot> createState() => _AnimatedMascotState();
}

class _AnimatedMascotState extends State<AnimatedMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  MascotExpression _expression = MascotExpression.happy;
  String? _message;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _message = widget.initialMessage;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setExpression(MascotExpression expression, {String? message}) {
    setState(() {
      _expression = expression;
      _message = message;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MascotWidget(
      expression: _expression,
      size: widget.size,
      speechText: _message,
    );
  }
}
