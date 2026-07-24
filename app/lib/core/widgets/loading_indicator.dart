import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Shared branded spinner. `GradientButton` still rolls its own (needs a
/// fixed white color for its gradient fill and an `AnimatedSwitcher` key),
/// but anywhere else that just needs "a loading spinner" — the splash
/// screen, list refreshes, etc. — should use this instead of a bare
/// `CircularProgressIndicator` so the color/weight stay consistent.
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size / 12, // scales with size instead of Flutter's fixed default
        valueColor: AlwaysStoppedAnimation(color ?? AppColors.primary),
      ),
    );
  }
}
