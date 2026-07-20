import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/shipment.dart';
import '../widgets/logistics_widgets.dart';

/// Operations home — KPI grid + active containers, matching mockup 3a.
class LogisticsHomeScreen extends StatelessWidget {
  final String userName;
  final VoidCallback? onOpenShipment;

  const LogisticsHomeScreen({
    super.key,
    this.userName = 'Ahmed Al-Rashid',
    this.onOpenShipment,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        _header(context),
        const SizedBox(height: 20),
        _kpiGrid(),
        const SizedBox(height: 20),
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
        for (final s in demoShipments.take(2)) ...[
          _containerCard(context, s),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _header(BuildContext context) {
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
              Text(userName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        _iconButton(context, Icons.notifications_rounded, badge: true),
        const SizedBox(width: 10),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: const Text('AR',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _iconButton(BuildContext context, IconData icon,
      {bool badge = false}) {
    return SoftCard(
      radius: 16,
      padding: const EdgeInsets.all(11),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon,
              size: 21,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.65)),
          if (badge)
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _kpiGrid() {
    const items = [
      (_Kpi('128', 'Active shipments', Icons.inventory_2_rounded,
          AppColors.accent)),
      (_Kpi('46', 'In transit', Icons.local_shipping_rounded,
          AppColors.primary)),
      (_Kpi('12', 'At customs', Icons.gavel_rounded, Color(0xFFF59E0B))),
      (_Kpi('31', 'Delivered today', Icons.task_alt_rounded,
          Color(0xFF22C55E))),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [for (final k in items) _kpiCard(k)],
    );
  }

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
              style: const TextStyle(fontSize: 12, color: Color(0x80000000))),
        ],
      ),
    );
  }

  Widget _containerCard(BuildContext context, Shipment s) {
    return SoftCard(
      radius: 24,
      onTap: onOpenShipment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
              StatusChip(status: s.status),
            ],
          ),
          const SizedBox(height: 14),
          RouteProgress(
            origin: s.origin,
            destination: s.destination,
            progress: s.progress,
            color: s.status.color,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ETA ${s.eta}',
                  style:
                      const TextStyle(fontSize: 11, color: Color(0x66000000))),
              Text(
                s.dutyDueSar != null
                    ? 'Duty pending'
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

class _Kpi {
  final String value;
  final String label;
  final IconData icon;
  final Color accent;
  const _Kpi(this.value, this.label, this.icon, this.accent);
}
