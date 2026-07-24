import 'package:flutter/material.dart';

/// Lifecycle stage of a container/shipment in the supply chain.
// enum: a fixed, named set of possible values for this type — the compiler
// guarantees only these five states can ever exist.
enum ShipmentStatus { onVessel, atCustoms, inTransit, delayed, delivered }

// An `extension` bolts extra members (getters/methods) onto an existing type
// — here the ShipmentStatus enum — without editing its original definition.
// This lets the enum stay a simple list of values while UI-facing logic
// (label/color/icon) lives alongside it.
extension ShipmentStatusX on ShipmentStatus {
  /// Human-readable text shown for this status in chips and lists.
  String get label => switch (this) {
        // switch expression (Dart 3+): evaluates to a value directly, one
        // `case => result` arrow per branch, instead of statements inside cases.
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

  /// Icon representing this status, paired with [color] on avatars/badges.
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
  final String title; // step name, e.g. "Customs clearance"
  final String subtitle; // supporting detail text shown under the title
  final bool done; // true once this step has been completed
  final bool active; // true if this is the current, in-progress step

  // Curly-brace parameters are named parameters — callers pass them by name
  // (e.g. JourneyStep(title: ..., subtitle: ...)) instead of by position.
  // `required` makes an otherwise-optional named parameter mandatory.
  const JourneyStep({
    required this.title,
    required this.subtitle,
    this.done = false, // defaults to "not done" unless specified
    this.active = false, // defaults to "not the current step" unless specified
  });
}

/// Core shipment/container record used throughout the shipments feature —
/// the list, detail and home-dashboard screens all render from this model.
class Shipment {
  final String reference; // e.g. SDX-2026-00871
  final String container; // e.g. MSKU 704412-3
  final String billOfLading; // bill of lading number — the shipping document/receipt for the cargo
  final String cargo; // human-readable description of the goods being shipped
  final String origin; // departure port/city
  final String destination; // arrival port/city
  final ShipmentStatus status; // current lifecycle stage; drives label/color/icon everywhere
  final double progress; // 0..1 along the route
  final String eta; // estimated time of arrival, already formatted for display
  final String? bayanNumber; // ZATCA customs declaration — Saudi customs clearance reference number (domain term, flag for review)
  final double? dutyDueSar; // outstanding customs duty owed, in Saudi Riyals (SAR), if any (domain term, flag for review)
  final List<JourneyStep> journey; // ordered timeline steps rendered on the detail screen

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
    this.bayanNumber, // nullable: most shipments have no customs declaration yet
    this.dutyDueSar, // nullable: only set when duty is actually owed
    this.journey = const [], // defaults to an empty, immutable list when not supplied
  });
}
