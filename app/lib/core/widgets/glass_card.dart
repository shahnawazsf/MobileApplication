import 'dart:ui'; // ImageFilter.blur
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Frosted-glass panel (blurred backdrop + translucent tint) used behind
/// auth-screen content, e.g. the login form.
// StatelessWidget: no internal mutable state — it just renders from the child/padding/borderRadius passed in.
class GlassCard extends StatelessWidget {
  final Widget child; // content shown inside the glass panel
  final EdgeInsetsGeometry padding; // space between the panel edge and child
  final double borderRadius; // corner rounding, shared by the clip, decoration and blur

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.borderRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ClipRRect( // BackdropFilter needs a clip or it blurs the entire layer, not just this card's bounds
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter( // the actual glassmorphism: blurs whatever is behind this widget
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), // sigma = blur strength in each direction; higher looks softer/more frosted
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glassFill(brightness), // translucent tint on top of the blurred backdrop
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.glassBorder(brightness)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.35 : 0.08), // stronger shadow needed in dark mode to read against a dark backdrop
                blurRadius: 40,
                offset: const Offset(0, 20), // shadow falls downward, giving the card a "floating" look
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
