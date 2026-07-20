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

class AppShell extends ConsumerWidget {
  final Widget child; // the active route's screen, supplied by ShellRoute
  final String currentPath; // state.matchedLocation from the router, drives the highlighted nav item

  const AppShell({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;

    void select(String path) {
      if (path != currentPath) context.go(path);
    }

    void logout() => ref.read(authProvider.notifier).logout(); // router redirect sends the user back to /login

    final title = navItems
        .firstWhere((item) => item.path == currentPath, orElse: () => navItems.first)
        .label;

    return Scaffold(
      body: AnimatedGradientBackground( // same drifting-orb backdrop as the login screen
        child: SafeArea(
          child: Row(
            children: [
              if (isWide)
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
