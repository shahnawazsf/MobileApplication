import 'dart:math' as math; // sin/cos/pi for the orbit motion
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated gradient backdrop with slowly drifting blurred orbs, used behind
/// the glass card on premium auth screens.
// StatefulWidget: unlike a StatelessWidget, this one owns mutable state (the running animation) that persists and changes across frames.
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child; // content painted on top of the animated backdrop

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

// The State object holds the mutable data (here, the AnimationController) and is the thing Flutter actually calls build() on repeatedly.
class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin { // provides the vsync ticker the AnimationController needs
  late final AnimationController _controller; // drives the animation clock, producing a value that sweeps 0..1 over time

  @override
  void initState() { // called once when this State is first created, before the first build()
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18), // Duration: how long one animation cycle takes to run — here, one full drift cycle
    )..repeat(); // ".." is Dart's cascade operator — call repeat() on the same AnimationController just created, then assign it
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

    return Stack( // lays widgets on top of each other instead of side by side, so the gradient, orbs, and content can overlap
      fit: StackFit.expand, // every child fills the full available size
      children: [
        // BoxDecoration: describes a box's background/border/shadow; here it paints a LinearGradient (a smooth color blend along a line) instead of a flat color.
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
                // Alignment(x, y): both range roughly -1..1, where (0,0) is the widget's center, (-1,-1) its top-left corner, and (1,1) its bottom-right.
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
