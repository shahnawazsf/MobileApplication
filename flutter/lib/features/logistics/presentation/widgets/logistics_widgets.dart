import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/shipment.dart';

/// Status pill used across shipment cards, matching the design mockups.
class StatusChip extends StatelessWidget {
  final ShipmentStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: status.color,
        ),
      ),
    );
  }
}

/// A soft frosted surface — the light-theme equivalent of GlassCard, tuned to
/// the lavender background from the mockups. Works in dark mode too.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: isDark ? 0.28 : 0.06),
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

/// Route progress bar: origin → destination with a filled portion.
class RouteProgress extends StatelessWidget {
  final String origin;
  final String destination;
  final double progress;
  final Color color;

  const RouteProgress({
    super.key,
    required this.origin,
    required this.destination,
    required this.progress,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0x99000000);
    return Row(
      children: [
        Text(origin,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(destination, style: TextStyle(fontSize: 12, color: muted)),
      ],
    );
  }
}

/// Animated drifting-orb backdrop, light-theme variant of
/// AnimatedGradientBackground — reuse the core one for dark screens.
class LightAuroraBackground extends StatelessWidget {
  final Widget child;
  const LightAuroraBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEEF0FE), Color(0xFFE4E7FB), Color(0xFFEDEFFD)],
            ),
          ),
        ),
        Positioned(
          right: -90,
          top: -70,
          child: _orb(AppColors.secondary.withValues(alpha: 0.18), 260),
        ),
        Positioned(
          left: -90,
          bottom: 110,
          child: _orb(AppColors.accent.withValues(alpha: 0.18), 220),
        ),
        child,
      ],
    );
  }

  Widget _orb(Color color, double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      );
}

/// Shared bottom navigation bar with a centered scan FAB, per the mockups.
class LogisticsNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onScan;

  const LogisticsNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.95),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          _tab(context, 0, Icons.home_rounded, 'Home'),
          _tab(context, 1, Icons.inventory_2_rounded, 'Shipments'),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onScan,
                child: Container(
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      color: Colors.white, size: 25),
                ),
              ),
            ),
          ),
          _tab(context, 3, Icons.notifications_rounded, 'Alerts'),
          _tab(context, 4, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, int index, IconData icon, String label) {
    final selected = index == currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final off = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0x66000000);
    final color = selected ? AppColors.primary : off;
    return Expanded(
      child: InkWell(
        onTap: () => onSelect(index),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23, color: color),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: color)),
          ],
        ),
      ),
    );
  }
}
