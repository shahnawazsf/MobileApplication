import 'package:flutter_riverpod/flutter_riverpod.dart'; // ProviderScope, required for MyApp to build
import 'package:flutter_test/flutter_test.dart';

import 'package:app/app.dart';

void main() {
  testWidgets('Login screen renders user id, password and login button', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp())); // same wrapping main.dart uses at runtime
    await tester.pumpAndSettle(); // waits out the flutter_animate entrance animations before asserting

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('User ID'), findsOneWidget); // confirms the field is labeled "User ID", not "Email"
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
