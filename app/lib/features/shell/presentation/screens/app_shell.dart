import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/animated_gradient_background.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shipments/presentation/screens/scan_screen.dart';
import '../nav_items.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/premium_side_menu.dart';

const _wideBreakpoint = 900.0; // above this width: permanent side rail; below: bottom nav bar

/// Persistent chrome (side menu or bottom nav bar + optional title) wrapped
/// around every authenticated route by the router's ShellRoute.
class AppShell extends ConsumerWidget { // ConsumerWidget (vs plain StatelessWidget) gives build() a WidgetRef so it can read Riverpod providers
  final Widget child; // the active route's screen, supplied by ShellRoute
  final String currentPath; // state.matchedLocation from the router, drives the highlighted nav item

  const AppShell({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user; // ref.watch subscribes: this widget rebuilds whenever authProvider's state changes
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint; // MediaQuery exposes the screen's size/metrics, used here to pick a layout

    void select(String path) {
      if (path != currentPath) context.go(path);
    }

    void logout() => ref.read(authProvider.notifier).logout(); // ref.read (no subscription) — one-off call, not something to rebuild on; router redirect sends the user back to /login

    // Look up the current route's display label; fall back to the first item
    // rather than crashing if currentPath doesn't match any known NavItem.
    final title = navItems
        .firstWhere((item) => item.path == currentPath, orElse: () => navItems.first)
        .label;

    return Scaffold(
      body: AnimatedGradientBackground( // same drifting-orb backdrop as the login screen
        child: SafeArea(
          child: Row(
            children: [
              if (isWide) // conditional child: `if` inside a widget list only includes the widget when true, no else means "nothing" otherwise
                PremiumSideMenu(
                  user: user,
                  currentPath: currentPath,
                  onSelect: select,
                  onLogout: logout,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWide)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    Expanded(
                      // AnimatedSwitcher cross-fades between old/new child whenever its key changes;
                      // KeyedSubtree gives `child` a key derived from currentPath so switching routes
                      // (even to a widget of the same runtime type) is recognized as a "new" child and animates.
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: KeyedSubtree(key: ValueKey(currentPath), child: child),
                      ),
                    ),
                    // Narrow layouts get the logistics-style bottom nav bar (with its
                    // own scan FAB) instead of the wide layout's permanent side rail —
                    // each screen carries its own title/header, so no AppBar is needed.
                    if (!isWide)
                      AppBottomNavBar(
                        items: navItems,
                        currentPath: currentPath,
                        onSelect: select,
                        onScan: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ScanScreen()),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
