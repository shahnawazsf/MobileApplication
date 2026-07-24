import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Frosted glass-style surface shared by the dashboard and shipment screens —
/// uses the same AppColors.glassFill/glassBorder tokens as PremiumSideMenu.
// StatelessWidget: purely derived from child/padding/radius/onTap — no state of its own to manage.
class SoftCard extends StatelessWidget {
  final Widget child; // content shown inside the card
  final EdgeInsetsGeometry padding;
  final double radius; // corner rounding, shared by the ink ripple clip and the decoration
  final VoidCallback? onTap; // null makes the card non-interactive (no ripple, no tap handling)

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    // Material + InkWell: Flutter's standard way to get the native tap ripple/highlight effect; color: transparent so only the InkWell's own splash shows, not a default surface color.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius), // keeps the ripple clipped to the card's rounded corners
        child: Ink( // like Container, but paints its decoration below the InkWell's splash so the ripple stays visible on top
          padding: padding,
          decoration: BoxDecoration( // background fill, border and shadow for the card
            color: AppColors.glassFill(brightness),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.glassBorder(brightness)),
            boxShadow: [
              BoxShadow( // soft drop shadow that lifts the card off the background
                color: Colors.black.withValues(
                    alpha: brightness == Brightness.dark ? 0.28 : 0.06), // stronger shadow in dark mode so it still reads against a dark backdrop
                blurRadius: 24,
                offset: const Offset(0, 10), // shadow falls downward for a subtle "floating" look
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
