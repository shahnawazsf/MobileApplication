import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/shipment.dart';

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
