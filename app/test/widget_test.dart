import 'package:flutter_riverpod/flutter_riverpod.dart'; // ProviderScope, required for MyApp to build
import 'package:flutter_test/flutter_test.dart';

import 'package:app/app.dart';

void main() {
  testWidgets('Login screen renders user id, password and login button', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp())); // same wrapping main.dart uses at runtime
    // Not pumpAndSettle: AnimatedGradientBackground's drift animation repeats
    // forever (see animated_gradient_background.dart), so "settle" never
    // arrives. Pump past the one-shot flutter_animate entrance animations
    // (longest is the card: 500ms + 150ms delay) instead.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('User ID'), findsOneWidget); // confirms the field is labeled "User ID", not "Email"
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
