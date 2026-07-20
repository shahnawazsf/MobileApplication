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

/// Demo data mirroring the design mockups — swap for a repository/API later.
const demoShipments = <Shipment>[
  Shipment(
    reference: 'SDX-2026-00871',
    container: 'MSKU 704412-3',
    billOfLading: 'MAEU-4471820',
    cargo: '40ft HC · Electronics',
    origin: 'Jeddah Port',
    destination: 'Riyadh DC',
    status: ShipmentStatus.inTransit,
    progress: 0.65,
    eta: 'Jul 21, 14:30',
  ),
  Shipment(
    reference: 'SDX-2026-00864',
    container: 'TCLU 118820-0',
    billOfLading: 'MAEU-4471655',
    cargo: '20ft · Auto parts',
    origin: 'Dammam Port',
    destination: 'Jubail',
    status: ShipmentStatus.atCustoms,
    progress: 0.35,
    eta: 'Jul 23, 11:00',
    bayanNumber: '4482910',
    dutyDueSar: 14820,
    journey: [
      JourneyStep(
        title: 'Departed Shanghai Port',
        subtitle: 'MV Maersk Semarang · Jun 28, 22:15',
        done: true,
      ),
      JourneyStep(
        title: 'Arrived Dammam — King Abdulaziz Port',
        subtitle: 'Discharged berth 14 · Jul 16, 19:40',
        done: true,
      ),
      JourneyStep(
        title: 'Customs clearance — in progress',
        subtitle: 'ZATCA Bayan 4482910 · lodged Jul 17',
        active: true,
      ),
      JourneyStep(
        title: 'Transit truck to Jubail',
        subtitle: 'Carrier assigned · SDX fleet',
      ),
      JourneyStep(
        title: 'Delivered — Jubail Industrial City',
        subtitle: 'Proof of delivery + e-signature',
      ),
    ],
  ),
  Shipment(
    reference: 'SDX-2026-00902',
    container: 'CMAU 552901-7',
    billOfLading: 'CMDU-9910233',
    cargo: '40ft · Machinery',
    origin: 'Shanghai',
    destination: 'Jeddah Islamic Port',
    status: ShipmentStatus.onVessel,
    progress: 0.15,
    eta: 'Berth Jul 24, 06:00',
  ),
  Shipment(
    reference: 'SDX-2026-00845',
    container: 'HLXU 220476-1',
    billOfLading: 'HLCU-5520117',
    cargo: '20ft · Textiles',
    origin: 'Jebel Ali',
    destination: 'Dammam Port',
    status: ShipmentStatus.delayed,
    progress: 0.05,
    eta: 'Delayed +12h',
  ),
  Shipment(
    reference: 'SDX-2026-00790',
    container: 'GESU 337719-8',
    billOfLading: 'MAEU-4470012',
    cargo: '40ft HC · Retail goods',
    origin: 'Dammam Port',
    destination: 'Riyadh DC',
    status: ShipmentStatus.delivered,
    progress: 1.0,
    eta: 'Yesterday 17:02',
  ),
];
