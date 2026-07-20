import 'package:flutter/material.dart';

/// Lifecycle stage of a container/shipment in the supply chain.
enum ShipmentStatus { onVessel, atCustoms, inTransit, delayed, delivered }

extension ShipmentStatusX on ShipmentStatus {
  String get label => switch (this) {
        ShipmentStatus.onVessel => 'On vessel',
        ShipmentStatus.atCustoms => 'At customs',
        ShipmentStatus.inTransit => 'In transit',
        ShipmentStatus.delayed => 'Delayed',
        ShipmentStatus.delivered => 'Delivered',
      };

  /// Accent color used for chips, icon tints and progress bars.
  Color get color => switch (this) {
        ShipmentStatus.onVessel => const Color(0xFF06B6D4),
        ShipmentStatus.atCustoms => const Color(0xFFF59E0B),
        ShipmentStatus.inTransit => const Color(0xFF2563EB),
        ShipmentStatus.delayed => const Color(0xFFEF4444),
        ShipmentStatus.delivered => const Color(0xFF22C55E),
      };

  IconData get icon => switch (this) {
        ShipmentStatus.onVessel => Icons.directions_boat_rounded,
        ShipmentStatus.atCustoms => Icons.gavel_rounded,
        ShipmentStatus.inTransit => Icons.local_shipping_rounded,
        ShipmentStatus.delayed => Icons.warning_rounded,
        ShipmentStatus.delivered => Icons.task_alt_rounded,
      };
}

/// A single point on a shipment's journey timeline.
class JourneyStep {
  final String title;
  final String subtitle;
  final bool done;
  final bool active;

  const JourneyStep({
    required this.title,
    required this.subtitle,
    this.done = false,
    this.active = false,
  });
}

class Shipment {
  final String reference; // e.g. SDX-2026-00871
  final String container; // e.g. MSKU 704412-3
  final String billOfLading;
  final String cargo;
  final String origin;
  final String destination;
  final ShipmentStatus status;
  final double progress; // 0..1 along the route
  final String eta;
  final String? bayanNumber; // ZATCA customs declaration
  final double? dutyDueSar; // outstanding duty, if any
  final List<JourneyStep> journey;

  const Shipment({
    required this.reference,
    required this.container,
    required this.billOfLading,
    required this.cargo,
    required this.origin,
    required this.destination,
    required this.status,
    required this.progress,
    required this.eta,
    this.bayanNumber,
    this.dutyDueSar,
    this.journey = const [],
  });
}
