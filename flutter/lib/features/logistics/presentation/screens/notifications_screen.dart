import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/logistics_widgets.dart';

class AppNotification {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final bool highlight; // draws attention (e.g. duty due)
  final List<String> actions;

  const AppNotification({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    this.highlight = false,
    this.actions = const [],
  });
}

/// Alerts / notifications feed grouped by day, matching mockup 3f.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _today = <AppNotification>[
    AppNotification(
      icon: Icons.gavel_rounded,
      color: Color(0xFFF59E0B),
      title: 'Duty payment required',
      body:
          'Bayan 4482910 · TCLU 118820-0 needs SAR 14,820 to clear Dammam customs.',
      time: '09:20',
      highlight: true,
      actions: ['Pay now', 'View Bayan'],
    ),
    AppNotification(
      icon: Icons.verified_rounded,
      color: Color(0xFF22C55E),
      title: 'Customs cleared',
      body: 'MSKU 704412-3 released from Jeddah Islamic Port. Truck assigned.',
      time: '07:58',
    ),
    AppNotification(
      icon: Icons.local_shipping_rounded,
      color: AppColors.primary,
      title: 'Departed Jeddah Port',
      body:
          'Trip SDX-TR-2214 en route to Riyadh DC · ETA Jul 21, 14:30.',
      time: '08:05',
    ),
  ];

  static const _yesterday = <AppNotification>[
    AppNotification(
      icon: Icons.warning_rounded,
      color: Color(0xFFEF4444),
      title: 'Vessel delayed 12h',
      body:
          'MV CMA CGM Ivanhoe rescheduled — new berth window Jul 24, 06:00.',
      time: '21:44',
    ),
    AppNotification(
      icon: Icons.task_alt_rounded,
      color: Color(0xFF06B6D4),
      title: 'Delivered — POD signed',
      body:
          'GESU 337719-8 received at Riyadh DC, Dock 4 · signed by M. Otaibi.',
      time: '17:02',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alerts',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              Text('Mark all read',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ],
          ),
        ),
        SizedBox(
          height: 58,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            children: const [
              _FilterPill('All', selected: true),
              _FilterPill('Customs'),
              _FilterPill('Transit'),
              _FilterPill('Delivery'),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
            children: [
              _sectionLabel('Today'),
              for (final n in _today) _card(context, n),
              _sectionLabel('Yesterday'),
              for (final n in _yesterday) _card(context, n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 8),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Color(0x66000000))),
      );

  Widget _card(BuildContext context, AppNotification n) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: n.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(n.icon, size: 21, color: n.color),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n.title,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(n.body,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0x8C000000))),
              if (n.actions.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (int i = 0; i < n.actions.length; i++) ...[
                      _actionBtn(n.actions[i], primary: i == 0),
                      if (i < n.actions.length - 1) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(n.time,
            style: const TextStyle(fontSize: 10.5, color: Color(0x66000000))),
      ],
    );

    if (n.highlight) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: n.color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: n.color.withValues(alpha: 0.35)),
        ),
        child: content,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        radius: 22,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: content,
      ),
    );
  }

  Widget _actionBtn(String label, {bool primary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: primary
            ? const LinearGradient(colors: AppColors.primaryGradient)
            : null,
        color: primary ? null : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: primary
            ? null
            : Border.all(color: const Color(0x1F000000)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: primary ? Colors.white : const Color(0xA6000000))),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterPill(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
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
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.white : const Color(0x99000000))),
    );
  }
}
