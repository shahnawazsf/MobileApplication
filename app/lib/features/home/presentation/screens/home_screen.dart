import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Placeholder post-login screen — exists so the router has somewhere to send
// authenticated users. Replace with the real home experience.
class HomeScreen extends ConsumerWidget { // ConsumerWidget: stateless but still needs `ref`
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user; // rebuilds if the signed-in user ever changes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(), // clears the token; router redirect handles the rest
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, ${user?.name ?? ''}', // null-safe even though this screen is only reachable when authenticated
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
