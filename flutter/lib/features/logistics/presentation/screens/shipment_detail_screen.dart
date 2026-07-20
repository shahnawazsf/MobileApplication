import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/shipment.dart';
import '../widgets/logistics_widgets.dart';

/// Shipment detail with a vertical customs/journey timeline, matching mockup 3c.
class ShipmentDetailScreen extends StatelessWidget {
  final Shipment shipment;
  const ShipmentDetailScreen({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    final s = shipment;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context, s),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                children: [
                  _summaryCard(s),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                          child: _stat('ETA final delivery', s.eta)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _stat('Dwell at port', '2d 14h',
                              accent: const Color(0xFFB45309))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Journey',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  for (int i = 0; i < s.journey.length; i++)
                    _timelineStep(context, s, i),
                ],
              ),
            ),
            _actions(context),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, Shipment s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Row(
        children: [
          SoftCard(
            radius: 15,
            padding: const EdgeInsets.all(11),
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.reference,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600)),
                Text('Bill of lading ${s.billOfLading}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0x73000000))),
              ],
            ),
          ),
          SoftCard(
            radius: 15,
            padding: const EdgeInsets.all(11),
            child: const Icon(Icons.share_rounded, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(Shipment s) {
    return SoftCard(
      radius: 24,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: s.status.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(s.status.icon, size: 26, color: s.status.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${s.container} · ${s.cargo.split('·').first.trim()}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                Text('${s.origin} → ${s.destination}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0x73000000))),
              ],
            ),
          ),
          StatusChip(status: s.status),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {Color? accent}) {
    return SoftCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0x73000000))),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: accent)),
        ],
      ),
    );
  }

  Widget _timelineStep(BuildContext context, Shipment s, int i) {
    final step = s.journey[i];
    final last = i == s.journey.length - 1;
    final Color dotColor = step.done
        ? const Color(0xFF16A34A)
        : step.active
            ? const Color(0xFFD97706)
            : const Color(0x40000000);
    final IconData dot = step.done
        ? Icons.check_circle_rounded
        : step.active
            ? Icons.pending_rounded
            : Icons.radio_button_unchecked_rounded;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(dot, size: 20, color: dotColor),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    color: (step.done ? const Color(0xFF22C55E) : dotColor)
                        .withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: step.done || step.active
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: step.active ? const Color(0xFFB45309) : null)),
                  Text(step.subtitle,
                      style: const TextStyle(
                          fontSize: 11.5, color: Color(0x66000000))),
                  if (step.active && s.dutyDueSar != null)
                    _dutyBox(s.dutyDueSar!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dutyBox(double amount) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Duty payment pending',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB45309))),
              Text('SAR ${amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Text('Pay via SADAD',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Row(
        children: [
          SoftCard(
            radius: 20,
            padding: const EdgeInsets.all(17),
            child: const Icon(Icons.description_rounded,
                size: 22, color: Color(0xFF0891B2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.my_location_rounded,
                      size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Track live',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
