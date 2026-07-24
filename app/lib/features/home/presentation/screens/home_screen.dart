import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/initials.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../auth/data/models/daily_container_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/daily_container_provider.dart';
import '../../../shipments/domain/shipment.dart';
import '../../../shipments/presentation/screens/shipment_detail_screen.dart';
import '../../../shipments/presentation/widgets/shipment_widgets.dart';

/// Operations dashboard — KPI grid + active containers, matching mockup 3a.
class HomeScreen extends ConsumerWidget { // ConsumerWidget gives build() a WidgetRef so it can read Riverpod providers (see authProvider below)
  final List<Shipment> shipments; // defaults to empty; the caller (router/tests) supplies real data
  const HomeScreen({super.key, this.shipments = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user; // ref.watch subscribes — screen rebuilds if the signed-in user changes
    final dailyContainersAsync = ref.watch(dailyContainerProvider);

    // Pushes the shipment detail screen on top of the current one (not a named
    // route — this screen already lives inside the router's ShellRoute).
    void openShipment(Shipment s) => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ShipmentDetailScreen(shipment: s)),
        );

    final dailyContainers = dailyContainersAsync.valueOrNull ?? const <DailyContainerModel>[];

    return ListView( // scrollable column — lets the dashboard grow past one screen height without overflowing
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        _header(context, user?.name),
        const SizedBox(height: 20),
        _kpiGrid(_buildKpis(dailyContainers)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Daily container summary',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Live',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 12),
        if (dailyContainersAsync.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (dailyContainersAsync.hasError)
          Text(
            dailyContainersAsync.error is Exception
                ? dailyContainersAsync.error.toString()
                : 'Unable to load daily container data right now.',
            style: TextStyle(
              fontSize: 13.5,
              color: Theme.of(context).colorScheme.error,
            ),
          )
        else if (dailyContainers.isEmpty)
          Text('No daily container data available',
              style: TextStyle(
                  fontSize: 13.5,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45)))
        else
          for (final item in dailyContainers.take(5)) ...[
            _dailyContainerRow(context, item),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 20),
        // "Active containers" section heading + "View all" link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Active containers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('View all',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 12),
        // Active containers list: an empty-state message when there's nothing
        // to show, otherwise up to 2 container cards (the rest live behind "View all").
        if (shipments.isEmpty)
          Text('No active containers',
              style: TextStyle(
                  fontSize: 13.5,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45)))
        else
          for (final s in shipments.take(2)) ...[ // spread (...) splices this loop's widgets directly into the outer children list
            _containerCard(context, s, openShipment),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  /// Greeting + user name on the left, notification bell and avatar initials on the right.
  Widget _header(BuildContext context, String? userName) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning',
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5))),
              Text(userName ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        _iconButton(context, Icons.notifications_rounded, badge: true), // notification bell with an unread-badge dot
        const SizedBox(width: 10),
        // avatar circle with initials
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(initialsOf(userName), // e.g. "John Doe" -> "JD"
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  /// A rounded icon button in a SoftCard shell, optionally showing a small
  /// unread-notification dot in its corner.
  Widget _iconButton(BuildContext context, IconData icon,
      {bool badge = false}) {
    return SoftCard(
      radius: 16,
      padding: const EdgeInsets.all(11),
      child: Stack( // Stack layers the badge dot on top of the icon instead of pushing it beside it
        clipBehavior: Clip.none, // lets the badge poke slightly outside the Stack's bounds without being clipped
        children: [
          Icon(icon,
              size: 21,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.65)),
          // notification badge dot
          if (badge)
            Positioned( // Positioned pins a Stack child to specific offsets from its edges
              right: -1,
              top: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor, // matches the page background so the dot looks "cut out" of the icon
                      width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 2-column grid of KPI stat cards, built from [items] (see [_buildKpis]).
  Widget _kpiGrid(List<_Kpi> items) {
    return GridView.count( // GridView.count lays children out in a fixed number of columns (crossAxisCount)
      crossAxisCount: 2,
      shrinkWrap: true, // sizes the grid to fit its children instead of expanding to fill available space
      physics: const NeverScrollableScrollPhysics(), // grid itself doesn't scroll — it's inside the outer ListView, which does
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55, // width:height ratio tuned so each card is short and wide, matching the mockup
      children: [for (final k in items) _kpiCard(k)],
    );
  }

  /// One row summarizing a single day's received/shipped container totals.
  Widget _dailyContainerRow(BuildContext context, DailyContainerModel item) {
    final dateLabel = item.actionDate != null
        ? '${item.actionDate!.day}/${item.actionDate!.month}/${item.actionDate!.year}'
        : 'N/A';

    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.actionDay ?? dateLabel,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Recv: ${item.recvdQty?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Ship: ${item.shippedQty?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  List<_Kpi> _buildKpis(List<DailyContainerModel> items) {
    final totalReceived = items.fold<double>(0, (sum, item) => sum + (item.recvdQty ?? 0));
    final totalShipped = items.fold<double>(0, (sum, item) => sum + (item.shippedQty ?? 0));
    final latest = items.isNotEmpty ? items.last : null;

    return [
      _Kpi(totalReceived.toStringAsFixed(0), 'Received today', Icons.inventory_2_rounded, AppColors.accent),
      _Kpi(totalShipped.toStringAsFixed(0), 'Shipped today', Icons.local_shipping_rounded, AppColors.primary),
      _Kpi(latest?.actionDay ?? '—', 'Last day', Icons.calendar_today_rounded, AppColors.warning),
      _Kpi(items.isEmpty ? '0' : '${items.length}', 'Days loaded', Icons.task_alt_rounded, AppColors.success),
    ];
  }

  /// One KPI card: a large value + icon on top, label underneath.
  Widget _kpiCard(_Kpi k) {
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(k.value,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: k.accent)),
              Icon(k.icon, size: 20, color: k.accent),
            ],
          ),
          const SizedBox(height: 2),
          Text(k.label,
              style: const TextStyle(fontSize: 12, color: Color(0x80000000))), // 50% black — muted label text
        ],
      ),
    );
  }

  /// Card summarizing one shipment: status icon, container/cargo, status
  /// chip, route progress bar, and ETA/progress footer. Tapping it opens detail.
  Widget _containerCard(
      BuildContext context, Shipment s, void Function(Shipment) onOpen) {
    return SoftCard(
      radius: 24,
      onTap: () => onOpen(s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // status icon tile (color keyed to the shipment's status)
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: s.status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(s.status.icon, size: 20, color: s.status.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.container,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(s.cargo,
                        style: const TextStyle(
                            fontSize: 11.5, color: Color(0x73000000))),
                  ],
                ),
              ),
              StatusChip(status: s.status), // small pill label (e.g. "In transit") — defined in shipment_widgets.dart
            ],
          ),
          const SizedBox(height: 14),
          RouteProgress( // origin -> destination progress bar, color-matched to the shipment status
            origin: s.origin,
            destination: s.destination,
            progress: s.progress,
            color: s.status.color,
          ),
          const SizedBox(height: 8),
          // footer: ETA on the left, either "Duty pending" or a percent-complete label on the right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ETA ${s.eta}',
                  style:
                      const TextStyle(fontSize: 11, color: Color(0x66000000))),
              Text(
                s.dutyDueSar != null
                    ? 'Duty pending' // outstanding customs duty takes priority over showing raw progress
                    : '${(s.progress * 100).round()}%',
                style:
                    const TextStyle(fontSize: 11, color: Color(0x66000000)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Plain data holder for one KPI card's display values — not a widget itself.
class _Kpi {
  final String value; // headline number/stat, e.g. '0'
  final String label; // caption describing what the value means
  final IconData icon;
  final Color accent; // color applied to both the value text and icon
  const _Kpi(this.value, this.label, this.icon, this.accent);
}
