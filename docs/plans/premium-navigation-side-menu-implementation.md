# Implementation Guide: Premium Post-Login Navigation Shell + Side Menu

**Date:** 2026-07-19
**Status:** Ready to apply — not yet written into the project
**Related plan:** [premium-navigation-side-menu.md](premium-navigation-side-menu.md)

This is the step-by-step build guide: exact commands to run and full file
contents, each annotated with why it's structured that way. Apply the steps
in order — later files import earlier ones.

`PremiumSideMenu` and `nav_items.dart` live under `features/shell/`, not
`core/widgets/`, because they depend on the `User` entity and the
`NavItem` list — keeping the dependency direction `features → core` (never
the reverse), the same way `auth/` is structured.

---

## Step 1 — Create the folders

```powershell
cd D:\Testing\projects\MobileApplication\app
New-Item -ItemType Directory -Force -Path lib\features\shell\presentation\screens
New-Item -ItemType Directory -Force -Path lib\features\shell\presentation\widgets
```

New `shell` feature gets the same `presentation/{screens,widgets}` split as
`auth/presentation/{screens,providers}` — no `data`/`domain` needed since it
holds no state of its own, just reads `authProvider`.

---

## Step 2 — `lib/features/shell/presentation/nav_items.dart`

Single source of truth for which routes appear in the side menu and how
they're highlighted. Both `PremiumSideMenu` (rendering) and `AppShell`
(title lookup) read from this same list, so a route is never listed in the
menu without an icon, or highlighted incorrectly because two places
disagreed on the path string.

```dart
import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });
}

// Every route wrapped in the ShellRoute (see app_router.dart) should have an
// entry here so PremiumSideMenu can list and highlight it.
const List<NavItem> navItems = [
  NavItem(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    label: 'Home',
    path: '/home',
  ),
  // Add Profile/Settings entries here once their routes exist, e.g.:
  // NavItem(icon: Icons.person_outline, selectedIcon: Icons.person_rounded, label: 'Profile', path: '/profile'),
];
```

---

## Step 3 — `lib/features/shell/presentation/widgets/premium_side_menu.dart`

The menu itself. Reuses `AppColors.glassFill`/`glassBorder` so it reads as
the same glassmorphic surface as `GlassCard` on the login screen, and
`AppColors.primaryGradient` for the avatar so the brand gradient shows up
post-login too, not just pre-login.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../nav_items.dart';

class PremiumSideMenu extends StatelessWidget {
  final User? user;
  final String currentPath;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;

  const PremiumSideMenu({
    super.key,
    required this.user,
    required this.currentPath,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final theme = Theme.of(context);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.glassFill(brightness),
        border: Border(right: BorderSide(color: AppColors.glassBorder(brightness))),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: gradient avatar (initials fallback — no photo backing this yet)
            // + name/description from the signed-in User entity.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: AppColors.primaryGradient),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(user?.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.name ?? '',
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.description ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Staggered fade/slide-in, matching the entrance treatment login_screen.dart
              // uses on its heading text via flutter_animate.
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
            Divider(height: 1, color: AppColors.glassBorder(brightness)),
            const SizedBox(height: 12),
            // Nav list — each tile animates in with an increasing delay (60ms * index)
            // so they cascade rather than all appearing at once.
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (var i = 0; i < navItems.length; i++)
                    _NavTile(
                      item: navItems[i],
                      selected: currentPath == navItems[i].path,
                      onTap: () => onSelect(navItems[i].path),
                    )
                        .animate()
                        .fadeIn(delay: (60 * i).ms, duration: 250.ms)
                        .slideX(begin: -0.1, end: 0),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.glassBorder(brightness)),
            // Logout pinned below the divider, separated from ordinary nav items and
            // styled in AppColors.error via isDestructive so it reads as a distinct action.
            Padding(
              padding: const EdgeInsets.all(12),
              child: _NavTile(
                item: const NavItem(
                  icon: Icons.logout_rounded,
                  selectedIcon: Icons.logout_rounded,
                  label: 'Log Out',
                  path: '/login',
                ),
                selected: false,
                onTap: onLogout,
                isDestructive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? AppColors.error
        : selected
            ? AppColors.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.75);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          // AnimatedContainer cross-fades the gradient-pill highlight in/out on selection
          // change, instead of it snapping — the "premium" feel the rest of the app has.
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.secondary.withValues(alpha: 0.15),
                      ],
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(selected ? item.selectedIcon : item.icon, color: color, size: 22),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Step 4 — `lib/features/shell/presentation/screens/app_shell.dart`

The responsive frame: permanent side rail above `_wideBreakpoint`, slide-in
`Drawer` below it. `AnimatedSwitcher` cross-fades the body between routes,
keyed by `currentPath` — each route has a distinct, never-repeating key, so
this doesn't hit the duplicate-key pitfall documented in
[login-duplicate-key-crash.md](../fixes/login-duplicate-key-crash.md) (that
bug came from *reusing* the same `'loading'` key across a rapid toggle, not
from keying by something that changes once per navigation).

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/animated_gradient_background.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../nav_items.dart';
import '../widgets/premium_side_menu.dart';

const _wideBreakpoint = 900.0; // above this width: permanent side rail; below: slide-in Drawer

class AppShell extends ConsumerWidget {
  final Widget child; // the active route's screen, supplied by ShellRoute
  final String currentPath; // state.matchedLocation from the router, drives the highlighted nav item

  const AppShell({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    void select(String path) {
      if (!isWide) scaffoldKey.currentState?.closeDrawer(); // close the Drawer before navigating on mobile
      if (path != currentPath) context.go(path);
    }

    void logout() => ref.read(authProvider.notifier).logout(); // router redirect sends the user back to /login

    final title = navItems
        .firstWhere((item) => item.path == currentPath, orElse: () => navItems.first)
        .label;

    return Scaffold(
      key: scaffoldKey,
      // Drawer only exists on narrow layouts — on wide layouts the same PremiumSideMenu
      // is rendered permanently in the Row below instead.
      drawer: isWide
          ? null
          : Drawer(
              child: PremiumSideMenu(
                user: user,
                currentPath: currentPath,
                onSelect: select,
                onLogout: logout,
              ),
            ),
      appBar: isWide ? null : AppBar(title: Text(title)),
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
```

---

## Step 5 — Update `lib/core/router/app_router.dart`

Wraps every authenticated route in a `ShellRoute` so `AppShell` persists
across navigation instead of being torn down and rebuilt per screen (which
would replay its entrance animations and reset the Drawer/rail state on
every tap). `/login` deliberately stays outside the `ShellRoute` — it has
its own full-screen layout with no side menu.

```dart
import 'package:flutter/foundation.dart'; // ChangeNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ref, Provider
import 'package:go_router/go_router.dart'; // GoRouter, GoRoute, ShellRoute
import '../../features/auth/presentation/providers/auth_provider.dart'; // authProvider, drives the redirect
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/shell/presentation/screens/app_shell.dart';

class _AuthRefreshNotifier extends ChangeNotifier { // bridges Riverpod state changes into GoRouter's refresh mechanism
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (previous, next) { // fires whenever AuthState changes
      if (previous?.isAuthenticated != next.isAuthenticated) { // only care about the signed-in/out transition
        notifyListeners(); // tells GoRouter to re-run its redirect callback
      }
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRefreshNotifier(ref); // one instance for the lifetime of this GoRouter

  return GoRouter(
    initialLocation: '/login', // first screen shown on cold start
    refreshListenable: refreshNotifier, // re-evaluates `redirect` below whenever this notifies
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) return '/login'; // guard: bounce signed-out users off protected routes
      if (isAuthenticated && isLoggingIn) return '/home'; // don't let a signed-in user sit on the login screen
      return null; // no redirect needed — proceed to the requested route
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute( // wraps every authenticated route in the persistent side-menu/top-bar chrome
        builder: (context, state, child) => AppShell(
          currentPath: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          // Future authenticated routes (e.g. /profile, /settings) go here so
          // they share AppShell's side menu/top bar — add a matching NavItem
          // in nav_items.dart for each one.
        ],
      ),
    ],
  );
});
```

---

## Step 6 — Simplify `lib/features/home/presentation/screens/home_screen.dart`

`AppShell` now owns the `Scaffold`, `AppBar`, and logout action, so
`HomeScreen` shrinks to just its body content — the same split every future
screen under the shell (`/profile`, `/settings`, …) should follow.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Dashboard body content only — Scaffold/AppBar/side menu/logout now live in AppShell.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user; // null-safe even though this screen is only reachable when authenticated

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Text(
        'Welcome, ${user?.name ?? ''}',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
```

---

## Step 7 — Verify

```powershell
cd D:\Testing\projects\MobileApplication\app
flutter analyze
flutter run -d chrome --web-port=5001
```

Log in, then check:

- **Narrow window** (< 900px): hamburger icon opens the `Drawer` with
  `PremiumSideMenu`.
- **Wide window** (≥ 900px): side menu is permanently visible, top bar
  shows the page title instead of an `AppBar`.
- **"Log Out"** in the menu signs out and the router redirect bounces back
  to `/login`.
- Resize the window across the 900px breakpoint while signed in — the
  layout should switch between Drawer and permanent rail without losing
  the signed-in state.

---

## Step 8 — Update `app/test/widget_test.dart`

Smoke test that the shell renders and swaps body content on navigation —
not written yet, add once the app is wired and running per Step 7.
