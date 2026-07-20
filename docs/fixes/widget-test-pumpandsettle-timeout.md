# Fix: `flutter test` failed with "pumpAndSettle timed out"

**Date:** 2026-07-20
**File:** `app/test/widget_test.dart`
**Affects:** `flutter test`

## Symptom

```
00:17 +0: Login screen renders user id, password and login button
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════
The following assertion was thrown running a test:
pumpAndSettle timed out
...
00:17 +0 -1: Some tests failed.
```

## Root cause

`AnimatedGradientBackground` (`app/lib/core/widgets/animated_gradient_background.dart`)
drives the login screen's drifting background orbs with:

```dart
_controller = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 18), // one full drift cycle
)..repeat(); // loops forever, no reverse
```

`WidgetTester.pumpAndSettle()` works by repeatedly pumping frames until no
frame produces a new one — i.e. until every animation has stopped. An
`AnimationController..repeat()` with no end condition never stops, so
`pumpAndSettle()` can never succeed here; it always times out. This isn't
something that goes away with more time — it's a permanent mismatch between
`pumpAndSettle` and any screen that has a genuinely infinite animation.

## Fix

Replaced the `pumpAndSettle()` call with two explicit `pump()` calls that
advance the clock only as far as the screen's one-shot entrance animations
(the `flutter_animate` `.fadeIn()`/`.slideY()` chains on the heading,
subtitle, and card — the longest of which is 500ms duration + 150ms delay).
The infinite background drift animation is left running in the background,
same as it would be on a real device; the test just no longer waits for it
to finish.

```dart
await tester.pumpWidget(const ProviderScope(child: MyApp()));
await tester.pump();
await tester.pump(const Duration(milliseconds: 700));
```

## Verification

`flutter test` — `00:01 +1: All tests passed!`
