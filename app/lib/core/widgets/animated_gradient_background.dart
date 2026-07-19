import 'dart:math' as math; // sin/cos/pi for the orbit motion
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated gradient backdrop with slowly drifting blurred orbs, used behind
/// the glass card on premium auth screens.
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child; // content painted on top of the animated backdrop

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin { // provides the vsync ticker the AnimationController needs
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18), // one full drift cycle
    )..repeat(); // loops forever, no reverse
  }

  @override
  void dispose() {
    _controller.dispose(); // stop the ticker when this widget leaves the tree
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors =
        isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient;

    return Stack(
      fit: StackFit.expand, // every child fills the full available size
      children: [
        DecoratedBox( // static base gradient, painted once
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
        AnimatedBuilder( // rebuilds only this subtree on every animation tick, not the whole screen
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value * 2 * math.pi; // controller's 0..1 progress mapped to a full circle
            return Stack(
              children: [
                _blurOrb( // each orb orbits along its own sin/cos path, offset in phase and radius
                  color: AppColors.primary,
                  alignment: Alignment(0.9 + 0.1 * math.sin(t), -0.9 + 0.1 * math.cos(t)),
                  size: 260,
                ),
                _blurOrb(
                  color: AppColors.accent,
                  alignment: Alignment(-1.0 + 0.15 * math.cos(t), 0.8 + 0.1 * math.sin(t)),
                  size: 220,
                ),
                _blurOrb(
                  color: AppColors.secondary,
                  alignment: Alignment(0.2 * math.sin(t * 0.7), 1.0 + 0.1 * math.cos(t)), // slower phase for variety
                  size: 300,
                ),
              ],
            );
          },
        ),
        widget.child, // painted last, on top of the animated backdrop
      ],
    );
  }

  // radial gradient fading to transparent — a cheap stand-in for a real Gaussian blur, avoids per-frame BackdropFilter cost
  Widget _blurOrb({required Color color, required Alignment alignment, required double size}) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.0)], // solid center fading to nothing
          ),
        ),
      ),
    );
  }
}
