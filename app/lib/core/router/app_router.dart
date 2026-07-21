import 'package:flutter/material.dart'; // Navigator, MaterialPageRoute
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ref, Provider
import 'package:go_router/go_router.dart'; // GoRouter, GoRoute, ShellRoute
import '../../features/auth/presentation/providers/auth_provider.dart'; // authProvider, drives the redirect
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/alerts_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/presentation/screens/app_shell.dart';
import '../../features/shipments/presentation/screens/scan_screen.dart';
import '../../features/shipments/presentation/screens/shipment_detail_screen.dart';
import '../../features/shipments/presentation/screens/shipment_list_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

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
    initialLocation: '/splash', // first screen shown on cold start
    refreshListenable: refreshNotifier, // re-evaluates `redirect` below whenever this notifies
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isSplash = state.matchedLocation == '/splash';
      final isLoggingIn = state.matchedLocation == '/login';

      if (isSplash) return null; // let it run its own timer-driven navigation, untouched by the auth guard
      if (!isAuthenticated && !isLoggingIn) return '/login'; // guard: bounce signed-out users off protected routes
      if (isAuthenticated && isLoggingIn) return '/home'; // don't let a signed-in user sit on the login screen
      return null; // no redirect needed — proceed to the requested route
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
          GoRoute(
            path: '/shipments',
            builder: (context, state) => ShipmentListScreen(
              onOpen: (shipment) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShipmentDetailScreen(shipment: shipment),
                ),
              ),
              onScan: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ScanScreen()),
              ),
            ),
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const AlertsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
