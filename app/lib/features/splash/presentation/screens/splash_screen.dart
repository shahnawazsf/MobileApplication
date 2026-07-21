import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // .animate().fadeIn() below
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/animated_gradient_background.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/loading_indicator.dart';

/// First screen shown on cold start — same branded background as the login
/// screen, held for a brief beat so the app doesn't flash straight to the
/// login form. Not a session-restore gate: this backend doesn't issue a
/// durable bearer token yet (see auth/data/models/login_response_model.dart),
/// so there's nothing to silently check before landing on `/login` —
/// `app_router.dart`'s `redirect` still owns where an *authenticated* user
/// actually ends up.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: AnimatedGradientBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandLogo(size: 96),
              const SizedBox(height: 24),
              Text(
                'SDES Mobile Application',
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
              const SizedBox(height: 8),
              Text(
                'Saudi Development & Export Service',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
              const SizedBox(height: 48),
              const LoadingIndicator().animate().fadeIn(duration: 400.ms, delay: 350.ms),
            ],
          ),
        ),
      ),
    );
  }
}
