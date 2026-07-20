import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/shipment.dart';
import '../widgets/logistics_widgets.dart';

/// Shipments list with search + type filters, matching mockup 3b.
class ShipmentListScreen extends StatefulWidget {
  final void Function(Shipment)? onOpen;
  final VoidCallback? onScan;
  const ShipmentListScreen({super.key, this.onOpen, this.onScan});

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends State<ShipmentListScreen> {
  static const _filters = ['All', 'Ocean', 'Customs', 'Road'];
  int _filter = 0;

  List<Shipment> get _visible {
    return switch (_filters[_filter]) {
      'Ocean' => demoShipments
          .where((s) => s.status == ShipmentStatus.onVessel)
          .toList(),
      'Customs' => demoShipments
          .where((s) => s.status == ShipmentStatus.atCustoms)
          .toList(),
      'Road' => demoShipments
          .where((s) => s.status == ShipmentStatus.inTransit)
          .toList(),
      _ => demoShipments,
    };
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shipments',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              SoftCard(
                radius: 16,
                padding: const EdgeInsets.all(11),
                child: Icon(Icons.tune_rounded,
                    size: 20, color: onSurface.withValues(alpha: 0.65)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: SoftCard(
            radius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    size: 20, color: onSurface.withValues(alpha: 0.4)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Container, B/L or Bayan number…',
                      style: TextStyle(
                          fontSize: 13.5,
                          color: onSurface.withValues(alpha: 0.4))),
                ),
                GestureDetector(
                  onTap: widget.onScan,
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      size: 20, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _filterChip(i),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
            itemCount: _visible.length,
            separatorBuilder: (_, __) => const SizedBox(height: 11),
            itemBuilder: (_, i) => _row(context, _visible[i]),
          ),
        ),
      ],
    );
  }

  Widget _filterChip(int i) {
    final selected = i == _filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = i),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: AppColors.primaryGradient)
              : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(999),
          border: selected
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.9)),
        ),
        child: Text(
          i == 0 ? 'All · ${demoShipments.length}' : _filters[i],
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : const Color(0x99000000),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, Shipment s) {
    return SoftCard(
      onTap: () => widget.onOpen?.call(s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: s.status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(s.status.icon, size: 19, color: s.status.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.container,
                        style: const TextStyle(
                            fontSize: 13.5, fontWeight: FontWeight.w600)),
                    Text('${s.origin} → ${s.destination}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0x73000000))),
                  ],
                ),
              ),
              StatusChip(status: s.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.bayanNumber != null
                    ? 'Bayan ${s.bayanNumber} · duty pending'
                    : s.eta.startsWith('Delayed')
                        ? 'Weather hold at origin'
                        : 'ETA ${s.eta}',
                style: const TextStyle(fontSize: 11, color: Color(0x66000000)),
              ),
              Text(
                s.dutyDueSar != null
                    ? 'SAR ${s.dutyDueSar!.toStringAsFixed(0)}'
                    : s.status == ShipmentStatus.inTransit
                        ? '${(s.progress * 100).round()}%'
                        : '',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: s.status.color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
