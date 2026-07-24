import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../domain/shipment.dart';
import '../widgets/shipment_widgets.dart';

/// Shipments list with search + type filters, matching mockup 3b.
// StatefulWidget: this screen needs mutable state (which filter chip is
// selected) that survives across rebuilds — a StatelessWidget can't hold that.
class ShipmentListScreen extends StatefulWidget {
  final List<Shipment> shipments;
  final void Function(Shipment)? onOpen; // called when a row is tapped, to navigate to its detail screen
  final VoidCallback? onScan; // called when the scan icon is tapped, to open the scanner
  const ShipmentListScreen({
    super.key,
    this.shipments = const [],
    this.onOpen,
    this.onScan,
  });

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

// The State object paired with ShipmentListScreen — holds the currently
// selected filter and rebuilds the widget tree whenever it changes.
class _ShipmentListScreenState extends State<ShipmentListScreen> {
  static const _filters = ['All', 'Ocean', 'Customs', 'Road']; // filter chip labels, index-aligned with selection
  int _filter = 0; // index into _filters for the currently selected chip

  /// Shipments matching the currently selected filter chip.
  List<Shipment> get _visible {
    // switch expression: picks the filtered list based on the selected
    // filter's label; `_` is the default/fallback branch (any other value).
    return switch (_filters[_filter]) {
      'Ocean' => widget.shipments
          .where((s) => s.status == ShipmentStatus.onVessel)
          .toList(),
      'Customs' => widget.shipments
          .where((s) => s.status == ShipmentStatus.atCustoms)
          .toList(),
      'Road' => widget.shipments
          .where((s) => s.status == ShipmentStatus.inTransit)
          .toList(),
      _ => widget.shipments, // 'All' (or anything unrecognized): no filtering
    };
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface; // base text/icon color for the current theme
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // title row: "Shipments" heading + filter/tune icon button
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
        // search bar with a scan-icon shortcut into the scanner screen
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
                // GestureDetector makes an otherwise-static icon tappable.
                GestureDetector(
                  onTap: widget.onScan,
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      size: 20, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        // horizontally scrolling row of filter chips
        SizedBox(
          height: 60,
          child: ListView.separated(
            // ListView.separated: like ListView.builder but also builds a
            // separator widget between each pair of items (here, spacing).
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
            itemCount: _filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _filterChip(i),
          ),
        ),
        // shipment rows for the active filter, or an empty-state message
        Expanded(
          child: _visible.isEmpty
              ? Center(
                  child: Text('No shipments yet',
                      style: TextStyle(
                          fontSize: 13.5,
                          color: onSurface.withValues(alpha: 0.45))),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                  itemCount: _visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 11),
                  itemBuilder: (_, i) => _row(context, _visible[i]),
                ),
        ),
      ],
    );
  }

  /// One tappable filter chip ("All", "Ocean", "Customs", "Road").
  Widget _filterChip(int i) {
    final selected = i == _filter;
    return GestureDetector(
      // setState tells Flutter this widget's state changed and it needs to
      // rebuild — here, switching the selected filter index.
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
          // the "All" chip also shows the total shipment count
          i == 0 ? 'All · ${widget.shipments.length}' : _filters[i],
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : const Color(0x99000000),
          ),
        ),
      ),
    );
  }

  /// One row in the shipment list: status icon, container + route, status
  /// chip, and a bottom line of contextual detail (ETA, duty, or progress).
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
                // left side: priority order is customs duty notice, then a
                // delay reason, then falling back to a plain ETA string
                s.bayanNumber != null
                    ? 'Bayan ${s.bayanNumber} · duty pending'
                    : s.eta.startsWith('Delayed')
                        ? 'Weather hold at origin'
                        : 'ETA ${s.eta}',
                style: const TextStyle(fontSize: 11, color: Color(0x66000000)),
              ),
              Text(
                // right side: outstanding duty amount takes priority, else
                // show route progress % while in transit, else nothing
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
