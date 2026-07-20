import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Frosted glass-style surface shared by the dashboard and shipment screens —
/// uses the same AppColors.glassFill/glassBorder tokens as PremiumSideMenu.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glassFill(brightness),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.glassBorder(brightness)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                    alpha: brightness == Brightness.dark ? 0.28 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
