# Plan: Premium Post-Login Navigation Shell + Side Menu

**Date:** 2026-07-19
**Status:** Proposed — not yet implemented
**Related:** `app/lib/features/home/presentation/screens/home_screen.dart`,
`app/lib/core/router/app_router.dart`

## Goal

Replace the placeholder `HomeScreen` (owns its own `Scaffold`/`AppBar`/logout
button) with a persistent app shell — a premium glassmorphic side menu plus
top bar — that wraps every authenticated screen, matching the visual
language already established on the login screen (`AppColors`, `GlassCard`,
`AnimatedGradientBackground`, `flutter_animate`).

## Structure decision

Use go_router's `ShellRoute` so the side menu persists across screens
instead of being rebuilt per-route. `HomeScreen` becomes just one tab's
body content, not the owner of the Scaffold.

## Steps

1. **New feature folder** — `lib/features/shell/presentation/` for the
   shared app chrome (side menu + top bar), following the same
   `data/domain/presentation` convention as `auth/`.

2. **Navigation model** — a small `NavItem { icon, label, path }` list
   (Home, Profile, Settings, Logout, …) in
   `shell/presentation/nav_items.dart`, single source of truth for both the
   side menu and route matching.

3. **`PremiumSideMenu` widget** — `core/widgets/premium_side_menu.dart`:
   - Reuses `AppColors.primaryGradient` for a header (avatar circle +
     `authProvider.user.name`/`empCode`), `AppColors.glassFill/glassBorder`
     for the panel background (matches `GlassCard`).
   - Nav items with an animated selected-state indicator (gradient pill or
     left accent bar), `flutter_animate` staggered fade/slide on open like
     the login screen does.
   - Logout item wired to `ref.read(authProvider.notifier).logout()`.

4. **`AppShell` widget** — `shell/presentation/screens/app_shell.dart`:
   - Takes `child` (the active route's screen) and current path to
     highlight the right nav item.
   - Responsive: `LayoutBuilder`/breakpoint (~900px) — permanent side rail
     (always visible) on wide/web/desktop, slide-in `Drawer` behind a
     hamburger button on narrow/mobile widths.
   - Top bar: page title (from matched route) + user menu/logout icon,
     keeps `AnimatedGradientBackground` behind content for visual
     continuity with login.

5. **Wire into `app_router.dart`** — wrap the authenticated routes in a
   `ShellRoute`:

   ```dart
   ShellRoute(
     builder: (context, state, child) => AppShell(child: child),
     routes: [
       GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
       // future: /profile, /settings, etc. — all share the same shell
     ],
   ),
   ```

   `/login` stays outside the shell.

6. **Simplify `HomeScreen`** — drop its own `Scaffold`/`AppBar`/logout
   button (now owned by `AppShell`); it becomes pure dashboard content
   (cards/stats/whatever comes next).

7. **Polish pass** — entrance animations on route change (fade/slide the
   body), active-item highlight transition, dark/light theme check (reuse
   `Theme.of(context).brightness` like `AppColors.glassFill` already does).

8. **Update `test/widget_test.dart`** — smoke test that the shell renders
   the side menu and swaps body content on navigation.
