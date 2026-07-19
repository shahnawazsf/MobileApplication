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
