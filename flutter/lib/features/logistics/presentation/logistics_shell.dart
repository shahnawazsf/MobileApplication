import 'package:flutter/material.dart';
import 'widgets/logistics_widgets.dart';
import 'screens/logistics_home_screen.dart';
import 'screens/shipment_list_screen.dart';
import 'screens/shipment_detail_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/notifications_screen.dart';

/// Bottom-tab shell wiring Home / Shipments / Alerts with a centered scan FAB.
/// Drop into your router as the logistics entry point.
class LogisticsShell extends StatefulWidget {
  const LogisticsShell({super.key});

  @override
  State<LogisticsShell> createState() => _LogisticsShellState();
}

class _LogisticsShellState extends State<LogisticsShell> {
  int _index = 0;

  void _openShipment(shipment) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LightAuroraBackground(
        child: ShipmentDetailScreen(shipment: shipment),
      ),
    ));
  }

  void _openScan() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          const LightAuroraBackground(child: ScanScreen()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LogisticsHomeScreen(
        onOpenShipment: () => _openShipment(null), // pass a real Shipment
      ),
      ShipmentListScreen(onOpen: _openShipment, onScan: _openScan),
      const SizedBox.shrink(), // index 2 = scan FAB, handled separately
      const NotificationsScreen(),
      const _ProfilePlaceholder(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LightAuroraBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(_index),
                    child: pages[_index],
                  ),
                ),
              ),
              LogisticsNavBar(
                currentIndex: _index,
                onScan: _openScan,
                onSelect: (i) {
                  if (i == 2) return; // center slot is the scan FAB
                  setState(() => _index = i);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Profile'));
}
