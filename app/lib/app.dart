import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends ConsumerWidget { // needs `ref` to read routerProvider, so ConsumerWidget not StatelessWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider); // rebuilds MaterialApp.router if the GoRouter instance ever changes

    return MaterialApp.router( // .router variant hands navigation off to go_router instead of Navigator routes
      title: 'My App',
      debugShowCheckedModeBanner: false, // hides the red "DEBUG" ribbon in the corner
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // follows the OS light/dark setting automatically
      routerConfig: router,
    );
  }
}
