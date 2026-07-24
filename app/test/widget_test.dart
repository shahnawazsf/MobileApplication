import 'package:flutter_riverpod/flutter_riverpod.dart'; // ProviderScope, required for MyApp to build
import 'package:flutter_test/flutter_test.dart';

import 'package:app/app.dart';

void main() {
  testWidgets('Splash screen shows briefly, then hands off to login', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp())); // same wrapping main.dart uses at runtime
    await tester.pump(); // first frame — splash screen, before its 2s timer fires

    expect(find.text('SDES Mobile Application'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing); // login screen hasn't appeared yet

    // Not pumpAndSettle: AnimatedGradientBackground's drift animation repeats
    // forever (see animated_gradient_background.dart, used by both the splash
    // and login screens), so "settle" never arrives. Pump explicit durations
    // instead: past SplashScreen's fixed 2s delay + its go_router transition,
    // then past the login screen's own one-shot entrance animations (longest
    // is the card: 500ms + 150ms delay).
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('User ID'), findsOneWidget); // confirms the field is labeled "User ID", not "Email"
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
