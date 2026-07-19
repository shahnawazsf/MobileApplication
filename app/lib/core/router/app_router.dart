import 'package:flutter/foundation.dart'; // ChangeNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ref, Provider
import 'package:go_router/go_router.dart'; // GoRouter, GoRoute
import '../../features/auth/presentation/providers/auth_provider.dart'; // authProvider, drives the redirect
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

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
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
